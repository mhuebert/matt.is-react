`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")


{Firebase, firebaseIdFromPath, snapshotToArray, FIREBASE_URL} = require("../../utils/firebase")
{SubscriptionMixin, firebaseSubscription} = require("sparkboard-tools")


Nav = require("../partials/nav")

DynamicLoader = require("../partials/dynamicLoader")
simplePagination = require("../partials/simplePagination")
slugify = require("../../utils").slugify
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
            baseUrl = FIREBASE_URL+'/writing/'
            ref = new Firebase(baseUrl)
            post: firebaseSubscription
                ref: ref.child(id)
                server: true
                parse: (snapshot) ->
                    post = snapshot.val()
                    post.slug = snapshot.name()
                    post
                default: {}
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id

            postNext: firebaseSubscription
                ref: new Firebase(baseUrl)
                query: (ref, done) -> 
                    ref.child(id).once "value", (snap) ->
                        done(ref.startAt(snap.getPriority()).limit(2))
                parse: (snapshot) ->
                    snapshotToArray(snapshot)[1] || {}
                default: {}
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id
            
            postPrev: firebaseSubscription
                ref: new Firebase(baseUrl)
                query: (ref, done) -> 
                    ref.child(id).once "value", (snap) ->
                        done(ref.endAt(snap.getPriority()).limit(2))
                parse: (snapshot) -> 
                    ideas = snapshotToArray(snapshot)
                    idea = if ideas.length == 1 then {} else ideas[0]
                    idea
                default: {}
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id


    render: ->
        `<div className={"content "+(_.isEmpty(this.props.post) ? "loading" : "")}>
            <DynamicLoader />
            <Nav>
                <a href={"/writing/edit/"+this.props.post.slug} className="right btn btn-trans showIfUser ">Edit</a>
            </Nav>
            <h1 className="text-center"><a href={"/writing/"+this.props.post.slug}>{this.props.post.title}</a></h1>
            <div className="writing-body" dangerouslySetInnerHTML={{__html: marked(this.props.post.body||"")}}></div>
            <simplePagination 
                back="/writing"
                next={this.props.postNext.id ? ("/writing/"+this.props.postNext.id) : false} 
                prev={this.props.postPrev.id ? ("/writing/"+this.props.postPrev.id) : false} />  
        </div>`

module.exports = Component
