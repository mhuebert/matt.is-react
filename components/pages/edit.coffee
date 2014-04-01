`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")

{Firebase, FirebaseMixin, firebaseIdFromPath, snapshotToArray, FIREBASE_URL} = require("../../utils/firebase")

Nav = require("../partials/nav")
simplePagination = require("../partials/simplePagination")
slugify = require("../../utils").slugify
textareaAutosize = require("../partials/textareaAutosize")
Dropdown = require("../partials/dropdown")
unsafeCharacters = /[^\w\s.!?,:\*;'"]/
moment = require("moment")
dateFormat = "MMMM D, YYYY"

Component = React.createClass

    mixins: [FirebaseMixin]

    componentWillUnmount: ->
        window?.removeEventListener('keydown', this.keyShortcuts)
    componentDidMount: ->
        this.refs.body.getDOMNode().focus()
        window.addEventListener('keydown', this.keyShortcuts)

    getInitialState: -> 
        slugAvailable: true
        validDate: true
        date: Date.now()

    keyShortcuts: (e) ->
        if (e.metaKey or e.ctrlKey)
            if e.which == 83
                e.preventDefault() and e.stopPropagation()
                @save()            
            if e.which == 8
                e.preventDefault() and e.stopPropagation()
                @delete()
            if e.which == 80 and this.props.matchedRoute.params.id
                e.preventDefault() and e.stopPropagation()
                @publish()
    
    componentWillReceiveProps: (newProps) ->
        if id = firebaseIdFromPath(newProps.matchedRoute.params.id)
            url = FIREBASE_URL+'/ideas/'+id
        if id = newProps.matchedRoute.params.slug
            url = FIREBASE_URL+'/writing/'+id
        ref = new Firebase(url)
        self = this
        ref.once "value", (snapshot) =>
            if idea = snapshot.val()
                idea.id = id
                self.refs.date.getDOMNode().value = moment(snapshot.getPriority()).format(dateFormat)
                self.setState idea

    statics:
        getMetadata: (props) ->
            title: props.idea?.title
        firebase: (match) ->
            if match.params.id
                id = firebaseIdFromPath(match?.params?.id)
                url = FIREBASE_URL+'/ideas/'
            if match.params.slug
                id = match.params.slug
                url = FIREBASE_URL+'/writing/'
            baseRef = new Firebase(url)
            idea:
                ref: baseRef.child(id)
                server: true
                parse: (snapshot) ->
                    idea = snapshot.val()
                    idea.date = snapshot.getPriority() if idea
                    idea
    publish: ->
        if this.state.slugAvailable == false or this.props.matchedRoute.params.slug
            return
        slug = this.state.slug || this.state.id
        publishRef = new Firebase(FIREBASE_URL+'/writing/'+slug)
        idea = _(this.state).pick "title", "body"
        idea.publishDate = Date.now()
        this.setState loading: true
        publishRef.setWithPriority idea, idea.publishDate, (error) =>
            if !error
                this.props.firebase.idea.ref.remove()
                this._owner.navigate "/writing/#{slug}"
            else
                this.setState loading: false
            # Todo: implement a 'flash message' capability
    save: ->
        this.setState saving: true
        idea = _(this.state).pick "title", "body", "slug", "wordCount"
        idea.id = this.state.slug || this.state.id
        idea.wordCount = (this.state.body || "").split(" ").length
        this.props.firebase.idea.ref.update idea, =>
            this.setState 
                saving: false

    handleTitleChange: (e) ->
        this.setState title: e.target.value.replace /[^\w\s.!*?,:;'"]/g, ""

    handleBodyChange: (e) ->
        @setState body: e.target.value

    handleSlugChange: (e) ->
        slug = slugify(e.target.value) || this.props.idea.id

        @setState slug: slug
        ref = new Firebase(FIREBASE_URL+'/writing/')
        ref.child(slug).once "value", (snapshot) =>
            slugAvailable = !snapshot.val()?
            @setState slugAvailable: slugAvailable
    changeDate: (e) ->
        dateString = e.target.value
        momentObject = moment(dateString, dateFormat, true)
        @setState validDate: momentObject.isValid()
        if momentObject.isValid()
            unixDate = momentObject.valueOf()
            this.props.firebase.idea.ref.setPriority unixDate

    objectModified: ->
        !_.isEqual this.props.idea, _(this.state).pick("title", "body", "slug", "id", "wordCount")

    componentDidUpdate: ->
        width = this.refs.slugPreview.getDOMNode().offsetWidth+6
        this.refs.slugInput.getDOMNode().style.width = "#{width}px"

    delete: ->
        if confirm("Are you sure? This cannot be undone.")
            if this.props.matchedRoute.params.slug
                url = "/writing"
            else
                url = "/ideas"

            this.props.firebase.idea.ref.remove (err) =>
                this._owner.navigate url


    render: ->
        isPublished = this.props.matchedRoute.params.slug
        loading = _.isEmpty this.props.idea
        `<div className={"content "+(loading ? "loading" : "")}>
            <Nav>    
                

                <Dropdown className="ideaOptions right showIfUser" label="Options">
                    <ul >
                        <li>
                            <a  href={"/writing/"+this.props.matchedRoute.params.slug}
                                className={(isPublished ? "" : "hidden")}>
                                View</a>
                        </li>
                        <li>
                            <a  onClick={this.publish} 
                    className={(this.state.slugAvailable ? "" : "disabled")+(isPublished ? " hidden" : "")}>
                    Publish</a>
                        </li>
                        <li><a onClick={this.delete}>Delete</a></li>
                    </ul>
                </Dropdown>
                

                <a  onClick={this.save} 
                    className={"btn btn-dark right showIfUser "+(this.state.saving ? "loading" : "")+(this.objectModified() ? "" : " disabled")}>Save</a>
            </Nav>
            <textareaAutosize   className="h1 text-center" 
                                ref="title" 
                                rows="1"
                                onChange={this.handleTitleChange} 
                                contentEditable="true" 
                                value={this.state.title}
                                placeholder="Title..."/>

            <textareaAutosize ref="body" onChange={this.handleBodyChange} className="idea-body" name="body" value={this.state.body} />
            
            <div className="writing-inline-options">
                <div className={"slugInput "+((this.state.slug || this.state.id) ? "" : "hidden")+(isPublished ? " hidden" : "")}>
                    <span className="label">matt.is/writing/</span>
                    <input  ref="slugInput" 
                            className={"grey "+(this.state.slugAvailable ? "success" : "error")}
                            onChange={this.handleSlugChange} 
                            value={this.state.slug||this.state.id} />
                    <div style={{position:"absolute"}}>
                        <span className="slugPreview" ref="slugPreview">{this.state.slug || this.state.id}</span>
                    </div>
                </div>
                <br/>
                <input ref="date" onChange={this.changeDate} className={"grey "+(this.state.validDate ? "success" : "error")} defaultValue={moment(this.state.date).format(dateFormat)}/>
                    
            </div>

            
        </div>`

module.exports = Component
