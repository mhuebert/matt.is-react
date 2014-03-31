`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")

{Firebase, FirebaseMixin, firebaseIdFromPath, snapshotToArray} = require("../../utils/firebase")

Body = require("../body")
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
FIREBASE_URL = require("../../config").firebaseUrl

Component = React.createClass

    mixins: [FirebaseMixin]


    statics:
        getMetadata: (props) ->
            title: props.post?.title
        firebase: (match) ->
            id = match?.params?.id
            baseUrl = FIREBASE_URL+'/test1/writing/'
            ref = new Firebase(baseUrl)
            post:
                ref: ref.child(id)
                server: true
                parse: (snapshot) ->
                    post = snapshot.val()
                    post.slug = snapshot.name()
                    post
                default: {}

            postNext:
                ref: new Firebase(baseUrl)
                query: (ref, done) -> 
                    ref.child(id).once "value", (snap) ->
                        done(ref.startAt(snap.getPriority()).limit(2))
                parse: (snapshot) ->
                    snapshotToArray(snapshot)[1] || {}
                default: {}
            
            postPrev:
                ref: new Firebase(baseUrl)
                query: (ref, done) -> 
                    ref.child(id).once "value", (snap) ->
                        done(ref.endAt(snap.getPriority()).limit(2))
                parse: (snapshot) -> 
                    ideas = snapshotToArray(snapshot)
                    idea = if ideas.length == 1 then {} else ideas[0]
                    idea
                default: {}


    render: ->
        `<Body className={"content "+(_.isEmpty(this.props.post) ? "loading" : "")}>
            <h1 className="text-center"><a href={"/writing/"+this.props.post.slug}>{this.props.post.title}</a></h1>
            <div className="writing-body" dangerouslySetInnerHTML={{__html: marked(this.props.post.body||"")}}></div>
            <simplePagination 
                next={this.props.postNext.id ? ("/writing/"+this.props.postNext.id) : false} 
                prev={this.props.postPrev.id ? ("/writing/"+this.props.postPrev.id) : false} />
            <div className="controls ideas-controls">
                <a href={"/writing/edit/"+this.props.post.slug} className="btn btn-trans showIfUser ">Edit</a>
            </div>    
        </Body>`

module.exports = Component
