# @cjsx React.DOM

_ = require("underscore")
React = require("react")
Nav = require("../widgets/nav")
DynamicLoader = require("../widgets/dynamicLoader")
simplePagination = require("../widgets/simplePagination")

{Firebase, FIREBASE_URL} = require("../../firebase")
{SubscriptionMixin, firebaseSubscription} = require("sparkboard-tools")
{snapshotToArray} = require("sparkboard-tools").utils
Component = React.createClass

    mixins: [SubscriptionMixin]

    statics:
        getMetadata: (props) ->
            title: "Photography"
        subscriptions: (props) ->
            match = props.matchedRoute
            id = match?.params?.id
            baseUrl = FIREBASE_URL+'/photos/'
            ref = new Firebase(baseUrl)
            photo: firebaseSubscription
                ref: ref.child(id)
                server: true                    
                default: {}
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id

            photoPrev: firebaseSubscription
                ref: new Firebase(baseUrl)
                query: (ref, done) -> 
                    ref.child(id).once "value", (snap) ->
                        done(ref.startAt(snap.getPriority()).limit(2))
                parse: (snapshot) ->
                    snapshotToArray(snapshot)[1] || {}
                default: {}
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id
            
            photoNext: firebaseSubscription
                ref: new Firebase(baseUrl)
                query: (ref, done) -> 
                    ref.child(id).once "value", (snap) ->
                        done(ref.endAt(snap.getPriority()).limit(2))
                parse: (snapshot) -> 
                    photos = snapshotToArray(snapshot)
                    photo = if photos.length == 1 then {} else photos[0]
                    photo
                default: {}
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id


    render: ->
        conversion = "/convert?w=1000&h=1000"
        <div className={"content "+(if _.isEmpty(this.props.photo) then "loading" else "")} style={{maxWidth:960}}>
            <div  className="photo-single">
                <a style={{color:'white',position:'absolute',top:10,left:10,fontSize:16,color:'#999999'}} href="/seeing">&larr; back</a>
                <a className="imageContainer"  style={{backgroundImage:"url("+this.props.photo.url+conversion+")"}}  href={if this.props.photoNext.id then "/seeing/"+this.props.photoNext.id else "/seeing"}></a>
                <simplePagination 
                    next={if this.props.photoNext.id then ("/seeing/"+this.props.photoNext.id) else false} 
                    prev={if this.props.photoPrev.id then ("/seeing/"+this.props.photoPrev.id) else false} 
                    back="/seeing" />
            </div>
            
            <div style={{opacity:0,position:'absolute',height:0,width:0,overflow:'hidden'}}>
                <img src={this.props.photoNext.url+conversion} />
            </div> 
        </div>

module.exports = Component
