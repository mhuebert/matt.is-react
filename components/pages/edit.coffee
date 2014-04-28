`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")


Nav = require("../partials/nav")
simplePagination = require("../partials/simplePagination")
slugify = require("../../app/utils").slugify
textareaAutosize = require("../partials/textareaAutosize")
toggleShowHide = require("../partials/toggleShowHide")
Dropdown = require("../partials/dropdown")
unsafeCharacters = /[^[:alnum:]\s.!?,:\*;'"]/g
moment = require("moment")
dateFormat = "MMMM D, YYYY"

{Firebase, FIREBASE_URL} = require("../../app/firebase")
{SubscriptionMixin, firebaseSubscription} = require("sparkboard-tools")

firebaseIdFromPath = (path) -> 
    path?.match(/\+(-.*)$/)?[1]

Component = React.createClass

    mixins: [SubscriptionMixin]
    statics:
        getMetadata: (props) ->
            title: props.post?.title
        subscriptions: (props) ->
            matchedRoute = props.matchedRoute
            id = matchedRoute.params.id
            post: firebaseSubscription
                ref: new Firebase(FIREBASE_URL+"/posts/"+id)
                server: true
                default: {}
                parse: (snapshot) ->
                    post = snapshot.val()
                    post.date = snapshot.getPriority() if post
                    post.id = snapshot.name() if post
                    post                    
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id

    

    getInitialState: -> 
        validDate: true
        date: Date.now()
        permalink: null

    componentWillUnmount: ->
        window?.removeEventListener('keydown', this.keyShortcuts)
    componentDidMount: ->
        this.refs.body.getDOMNode().focus()
        window.addEventListener('keydown', this.keyShortcuts)
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
        id = newProps.matchedRoute.params.id
        ref = new Firebase(FIREBASE_URL+'/posts/'+id)
        self = this
        ref.once "value", (snapshot) =>
            if post = snapshot.val()
                post.id = snapshot.name()
                self.refs.date.getDOMNode().value = moment(snapshot.getPriority()).format(dateFormat)
                self.setState post

    publish: ->
        ref = new Firebase(FIREBASE_URL+"/posts/#{this.state.id}")
        
        publishDate = Date.now()
        post = 
            publishDate: publishDate
            public: true
        @setState loading: true
        ref.update post, (error) =>
            if !error
                @save()
                @setState loading: false
                this._owner.navigate "/"+this.props.post.permalink
    
    updatePostLocations: ->
        switch this.props.post.publishDate?
            when true  
                location = "writing"
                notLocation = "ideas"
            when false
                location = "ideas"
                notLocation = "writing"
        priority = this.props.post.date || Date.now()
        postRef = this.props.subscriptions.post.ref.root().child("posts").child(this.props.post.id)
        postRef.root().child("users/#{user.id}/#{location}/#{this.props.post.id}").setWithPriority(true, priority)
        postRef.root().child("users/#{user.id}/#{notLocation}/#{this.props.post.id}").set(null)

    save: (callback) ->
        this.setState saving: true
        post = _(this.state).pick "title", "body", "slug", "wordCount", "description"
        post.wordCount = (this.state.body || "").split(" ").length
        post.owner = user.id
        priority = this.props.post.publishDate || Date.now()

        location = if this.props.post.publishDate then "/writing" else "/posts/edit"
        root = this.props.subscriptions.post.ref.root()

        if @permalinkReady() and this.props.post.permalink != this.state.permalink
            post.permalink = this.state.permalink
            root.child("permalinks/#{this.props.post.permalink}").set(null)
            root.child("permalinks").child(this.state.permalink).set
                redirect: "/writing/#{this.props.post.id}"
                owner: user.id

        postRef = root.child("posts").child(this.props.post.id)
        postRef.update post, =>
            this.setState 
                saving: false
            callback?()
        postRef.setPriority priority

        @updatePostLocations()

    
    storePostInUser: ->    
        

    handleTitleChange: (e) ->
        this.setState title: e.target.value.replace unsafeCharacters, ""

    handleBodyChange: (e) ->
        @setState body: e.target.value
    handleDescriptionChange: (e) ->
        @setState description: e.target.value

    changePermalink: (e) ->
        permalink = slugify e.target.value
        @setState permalink: permalink
        ref = new Firebase(FIREBASE_URL+'/permalinks/'+permalink)
        ref.once "value", (snapshot) =>
            permalinkAvailable = !snapshot.val()
            @setState 
                permalinkAvailable: permalinkAvailable
                permalinkChecked: permalink

    changeDate: (e) ->
        dateString = e.target.value
        momentObject = moment(dateString, dateFormat, true)
        @setState validDate: momentObject.isValid()
        dataRef = this.props.subscriptions.post.ref
        if momentObject.isValid()
            unixDate = momentObject.valueOf()
            this.props.subscriptions.post.ref.setPriority unixDate
            published = this.props.post.publishDate?
            if published
                dataRef.update publishDate: unixDate
            location = if published then "writing" else "ideas"
            indexRef = dataRef.root().child("/users/#{user.id}/#{location}").child(this.props.post.id)
            indexRef.setPriority unixDate

    objectModified: ->
        !_.isEqual this.props.post, _(this.state).pick("title", "body", "id", "wordCount")

    delete: ->
        if confirm("Are you sure? This cannot be undone.")

            id = this.state.id
            permalink = this.state.permalink
            rootRef = this.props.subscriptions.post.ref.root()
            this.props.subscriptions.post.ref.remove (err) =>
                if !err
                    rootRef.child("users/#{user.id}/writing/#{id}").set(null)
                    rootRef.child("users/#{user.id}/ideas/#{id}").set(null)
                    rootRef.child("permalinks/#{permalink}").set(null)
                    
                    this._owner.navigate "/"

    permalinkReady: -> (this.state.permalinkAvailable and this.state.permalinkChecked == this.state.permalink)
    render: ->
        isPublished = this.props.post?.publishDate?
        loading = _.isEmpty this.props.post
        if isPublished then viewLink = "/"+this.props.post.permalink else viewLink = "/writing/#{this.props.post.id}"
        
        `<div className={"content "+(loading ? "loading" : "")}>
            <Nav>    
                <a  href={viewLink}
                    className={"btn btn-standard right showIfUser"}>
                    View</a>
                <a  onClick={this.publish} 
                    className={(isPublished ? " hidden" : "")+" btn btn-standard right showIfUser"}>
                    Publish</a>
                <a  onClick={this.save} 
                    className={"btn btn-dark right showIfUser "+(this.state.saving ? "loading" : "")+(this.objectModified() ? "" : " disabled")}>Save</a>
            </Nav>

            <textareaAutosize   placeholder="Title..."
                                className="h1 text-center" 
                                ref="title" 
                                rows="1"
                                onChange={this.handleTitleChange} 
                                contentEditable="true" 
                                value={this.state.title}/>
            
            <toggleShowHide>
                <div className='text-center' style={{margin:"-30px 0 10px"}}>
                    <a data-toggle-hide={false} className=" hide-if-toggle-visible writing-edit-link show-element ">options</a>
                    <a data-toggle-hide={true} className=" hide-if-toggle-hidden writing-edit-link show-element ">hide options</a>
                </div>
                <div className="writing-inline-options hide-if-toggle-hidden">
                    <div>
                        /<input className={"grey "+(this.permalinkReady ? "success" : "error")}  placeholder="my-permalink" ref="permalink" onChange={this.changePermalink} value={this.state.permalink}/>
                    </div>
                    <div>
                        <input placeholder="Description" onChange={this.handleDescriptionChange} value={this.state.description}/>
                    </div>
                    <div>
                        <input ref="date" onChange={this.changeDate} className={"grey "+(this.state.validDate ? "success" : "error")} defaultValue={moment(this.state.date).format(dateFormat)}/>
                    </div>
                    <a className="btn btn-red btn-small" onClick={this.delete}>Delete</a>
                </div>
            </toggleShowHide>

            <textareaAutosize ref="body" onChange={this.handleBodyChange} className="idea-body" name="body" value={this.state.body} />
            

            
        </div>`

module.exports = Component
