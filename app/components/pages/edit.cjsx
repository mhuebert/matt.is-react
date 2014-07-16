# @cjsx React.DOM

_ = require("underscore")
React = require("react")


Body = require("../widgets/body")
simplePagination = require("../widgets/simplePagination")
{slugify} = require("sparkboard-tools").utils
textareaAutosize = require("../widgets/textareaAutosize")
toggleShowHide = require("../widgets/toggleShowHide")
Dropdown = require("../widgets/dropdown")
unsafeCharacters = /[^[:alnum:]\s.!?,:\*;'"]/g
moment = require("moment")
dateFormat = "MMMM D, YYYY"

{Firebase, FIREBASE_URL} = require("../../firebase")
{firebaseSubscription} = require("sparkboard-tools")
subscriptions = require("../../subscriptions")
{AsyncSubscriptionMixin} = subscriptions

firebaseIdFromPath = (path) -> 
    path?.match(/\+(-.*)$/)?[1]

Component = React.createClass

    mixins: [AsyncSubscriptionMixin]
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

    

    getInitialState: -> {}
    # validDate: true
    # date: Date.now()
    # permalink: null

    componentWillUnmount: ->
        window?.removeEventListener('keydown', @keyShortcuts)
    componentDidMount: ->
        this.refs.body.getDOMNode().focus()
        window.addEventListener('keydown', @keyShortcuts)
    keyShortcuts: (e) ->
        if (e.metaKey or e.ctrlKey)
            if e.which == 83
                e.preventDefault() and e.stopPropagation()
                @save()            
            if e.which == 8
                e.preventDefault() and e.stopPropagation()
                @delete()
            if e.which == 80 and @props.matchedRoute.params.id
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
        ref = new Firebase(FIREBASE_URL+"/posts/#{@state.id}")
        
        publishDate = Date.now()
        post = 
            publishDate: publishDate
            public: true
        @setState loading: true
        ref.update post, (error) =>
            if !error
                @save()
                @setState loading: false
                @_owner.navigate "/"+@subs('post').permalink
    
    updatePostLocations: ->
        switch @subs('post').publishDate?
            when true  
                location = "writing"
                notLocation = "ideas"
            when false
                location = "ideas"
                notLocation = "writing"
        priority = @subs('post').date || Date.now()
        postRef = @state.subscriptions.post.ref.root().child("posts").child(@subs('post').id)
        postRef.root().child("users/#{user.id}/#{location}/#{@subs('post').id}").setWithPriority(true, priority)
        postRef.root().child("users/#{user.id}/#{notLocation}/#{@subs('post').id}").set(null)

    save: (callback) ->
        @setState saving: true
        post = _(@state).pick "title", "body", "slug", "wordCount", "description"
        post.wordCount = (@state.body || "").split(" ").length
        post.owner = user.id
        priority = @subs('post').publishDate || Date.now()

        location = if @subs('post').publishDate then "/writing" else "/ideas"
        root = @state.subscriptions.post.ref.root()

        if @permalinkReady() and @subs('post').permalink != @state.permalink
            post.permalink = @state.permalink
            root.child("permalinks/#{@subs('post').permalink}").set(null)
            root.child("permalinks").child(@state.permalink).set
                redirect: "/writing/#{@subs('post').id}"
                owner: user.id

        postRef = root.child("posts").child(@subs('post').id)
        postRef.update post, =>
            @setState 
                saving: false
            callback?()
        postRef.setPriority priority

        @updatePostLocations()

    
    storePostInUser: ->    
        

    handleTitleChange: (e) ->
        @setState title: e.target.value.replace unsafeCharacters, ""

    handleBodyChange: (e) ->
        @setState body: e.target.value
    handlePreviewChange: (e) ->
        @setState preview: e.target.value
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
        dataRef = @state.subscriptions.post.ref
        if momentObject.isValid()
            unixDate = momentObject.valueOf()
            @state.subscriptions.post.ref.setPriority unixDate
            published = @subs('post').publishDate?
            if published
                dataRef.update publishDate: unixDate
            location = if published then "writing" else "ideas"
            indexRef = dataRef.root().child("/users/#{user.id}/#{location}").child(@subs('post').id)
            indexRef.setPriority unixDate

    objectModified: ->
        !_.isEqual @subs('post'), _(@state).pick("title", "body", "id", "wordCount")

    delete: ->
        if confirm("Are you sure? This cannot be undone.")

            id = @state.id
            permalink = @state.permalink
            rootRef = @state.subscriptions.post.ref.root()
            @state.subscriptions.post.ref.remove (err) =>
                if !err
                    rootRef.child("users/#{user.id}/writing/#{id}").set(null)
                    rootRef.child("users/#{user.id}/ideas/#{id}").set(null)
                    rootRef.child("permalinks/#{permalink}").set(null)
                    
                    @_owner.navigate "/"

    permalinkReady: -> (@state.permalinkAvailable and @state.permalinkChecked == @state.permalink)
    render: ->
        isPublished = @subs('post')?.publishDate?
        loading = _.isEmpty @subs('post')
        if isPublished then viewLink = "/"+@subs('post').permalink else viewLink = "/writing/#{@subs('post').id}"

        if isPublished 
            breadcrumb = ["writing", @subs('post').permalink]
        else
            breadcrumb = ["ideas", @subs('post').id]

        <Body  breadcrumb={breadcrumb} sidebar={true}>
            <div className="inner-content">
                <span><a  onClick={@save} 
                        className={"btn btn-white btn-list right showIfUser "+(@state.saving ? "loading" : "")+(@objectModified() ? "" : " disabled")}>
                        Save</a>
                    <a  onClick={@publish} 
                        className={(isPublished ? " hidden" : "")+" btn btn-white btn-list right showIfUser"}>
                        Publish</a>
                    <a  href={viewLink}
                        className={"btn btn-white btn-list right showIfUser"}>
                        View</a></span>
                <textareaAutosize   placeholder="Title"
                                    className="h1 text-center" 
                                    ref="title" 
                                    rows="1"
                                    onChange={@handleTitleChange} 
                                    contentEditable="true" 
                                    value={@state.title}/>
                
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
                            <input  placeholder="Description" 
                                    onChange={@handleDescriptionChange} 
                                    value={@state.description}/>
                        </div>
                        <div>
                            <input  ref="date" 
                                    onChange={@changeDate} 
                                    className={"grey "+(if @state.validDate then "success" else "error")} 
                                    defaultValue={moment(@state.date).format(dateFormat)}/>
                        </div>
                        <a className="btn btn-red btn-small" onClick={@delete}>Delete</a>
                    
                            <textareaAutosize   ref="preview" 
                                                onChange={@handlePreviewChange} 
                                                className="idea-preview" 
                                                name="preview" 
                                                value={@state.preview}
                                                placeholder="Summary"/>
                    </div>

                </toggleShowHide>

                
                

                <textareaAutosize ref="body" onChange={@handleBodyChange} placeholder="Text" className="idea-body" name="body" value={@state.body} />
            </div>
            

            
        </Body>

module.exports = Component
