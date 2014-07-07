`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")


{Firebase, FIREBASE_URL} = require("../../firebase")
{SubscriptionMixin, firebaseSubscription} = require("sparkboard-tools")
{snapshotToArray, slugify} = require("sparkboard-tools").utils
{Model} = require("../../models")
{ownerId} = require("../../../config")

TagList = require("../widgets/tagList")
Body = require("../body")

simplePagination = require("../widgets/simplePagination")
textareaAutosize = require("../widgets/textareaAutosize")
marked = require("marked")
marked.setOptions
  gfm: true
  tables: true
  breaks: true
  pedantic: false
  sanitize: false
  smartLists: true
  smartypants: true

unsafeCharacters = /[^\w\s.!?,:;'"]/

Component = React.createClass

    mixins: [SubscriptionMixin]


    statics:
        getMetadata: (props) ->
            title: props.post?.title
            description: props.post?.description
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
                            if idea = ideas[1]
                                done(ref.root().child("/posts/#{idea.id}"))
                            else
                                done(null)
                            
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
                            if ideas.length == 2
                                done(ref.root().child("/posts/#{ideas[0].id}"))
                            else
                                done(null)
                parse: (snapshot) -> 
                    snapshot.val()
                    
                default: {}
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id

    render: ->
        post = new Model(this.props.post)
        tags = _(post.get("tags")).keys()
        `<Body  breadcrumb={["writing", post.get("permalink")]}  
                navInclude ={<a href={"/ideas/"+post.get("slug")} className="right btn btn-trans showIfUser ">Edit</a>}
                className={"content "+(_.isEmpty(post.attributes) ? "loading" : "")}>
            
            <h1 className="text-center"><a href={"/"+post.get("permalink")}>{post.get("title")}</a></h1>
            <div className="writing-body" dangerouslySetInnerHTML={{__html: marked(post.get("body")||"")}}></div>
            <TagList tags={tags} 
                     url={function(tag){return "/tags/"+slugify(tag)}}
                     label={function(tag){return "#"+tag}}/>
            <simplePagination
                className={post.get("publishDate") ? "" : "hidden"} 
                back="/writing"
                next={this.props.postNext.permalink ? ("/"+this.props.postNext.permalink) : false} 
                prev={this.props.postPrev.permalink ? ("/"+this.props.postPrev.permalink) : false} />  
        </Body>`

module.exports = Component
