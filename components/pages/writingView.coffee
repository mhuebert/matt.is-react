`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")


{Firebase, FIREBASE_URL} = require("../../app/firebase")
{SubscriptionMixin, firebaseSubscription} = require("sparkboard-tools")
{snapshotToArray} = require("sparkboard-tools").utils
{Model} = require("../../app/models")
{ownerId} = require("../../config")

Nav = require("../partials/nav")

DynamicLoader = require("../partials/dynamicLoader")
simplePagination = require("../partials/simplePagination")
slugify = require("../../app/utils").slugify
textareaAutosize = require("../partials/textareaAutosize")
marked = require("marked")
marked.setOptions
  gfm: true
  tables: true
  breaks: true
  pedantic: false
  sanitize: true
  smartLists: true
  smartypants: false

unsafeCharacters = /[^\w\s.!?,:;'"]/

Component = React.createClass

    mixins: [SubscriptionMixin]


    statics:
        getMetadata: (props) ->
            title: props.post?.title
        subscriptions: (props) ->
            match = props.matchedRoute
            id = match?.params?.id
            baseUrl = FIREBASE_URL+'/posts/'
            ref = new Firebase(baseUrl)
            indexUrl = FIREBASE_URL+"/users/#{ownerId}/writing/"
            post: firebaseSubscription
                ref: ref.child(id)
                server: true
                parse: (snapshot) ->
                    post = snapshot.val()
                    post.slug = snapshot.name() if post?
                    post
                default: {}
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id

            postNext: firebaseSubscription
                ref: new Firebase(indexUrl)
                query: (ref, done) -> 
                    ref.child(id).once "value", (snap) ->
                        ref.startAt(snap.getPriority()).limit(2).once "value", (snap) ->
                            ideas = snapshotToArray(snap)
                            idea = ideas[1] || {}
                            done(ref.root().child("/posts/#{idea.id}"))
                parse: (snapshot) -> 
                    snapshot.val()
                default: {}
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id
            
            postPrev: firebaseSubscription
                ref: new Firebase(indexUrl)
                query: (ref, done) -> 
                    ref.child(id).once "value", (snap) ->
                        ref.endAt(snap.getPriority()).limit(2).once "value", (snap) ->
                            ideas = snapshotToArray(snap)
                            idea = if ideas.length == 1 then {} else ideas[0]
                            done(ref.root().child("/posts/#{idea.id}"))
                parse: (snapshot) -> 
                    snapshot.val()
                    
                default: {}
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id


    render: ->
        post = new Model(this.props.post)
        `<div className={"content "+(_.isEmpty(post.attributes) ? "loading" : "")}>
            <DynamicLoader /><DynamicLoader />
            <Nav>
                <a href={"/posts/edit/"+post.get("slug")} className="right btn btn-trans showIfUser ">Edit</a>
            </Nav>
            <h1 className="text-center"><a href={"/"+post.get("permalink")}>{post.get("title")}</a></h1>
            <div className="writing-body" dangerouslySetInnerHTML={{__html: marked(post.get("body")||"")}}></div>
            <simplePagination 
                back="/writing"
                next={this.props.postNext.permalink ? ("/"+this.props.postNext.permalink) : false} 
                prev={this.props.postPrev.permalink ? ("/"+this.props.postPrev.permalink) : false} />  
        </div>`

module.exports = Component
