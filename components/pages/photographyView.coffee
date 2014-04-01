`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")

{Firebase, FirebaseMixin, firebaseIdFromPath, snapshotToArray, FIREBASE_URL} = require("../../utils/firebase")
{fullScreen} = require("../../utils/")
Nav = require("../partials/nav")

DynamicLoader = require("../partials/dynamicLoader")
simplePagination = require("../partials/simplePagination")

Component = React.createClass

    mixins: [FirebaseMixin]

    statics:
        getMetadata: (props) ->
            title: "Photography"
        firebase: (match) ->
            id = match?.params?.id
            baseUrl = FIREBASE_URL+'/photos/'
            ref = new Firebase(baseUrl)
            photo:
                ref: ref.child(id)
                server: true                    
                default: {}

            photoPrev:
                ref: new Firebase(baseUrl)
                query: (ref, done) -> 
                    ref.child(id).once "value", (snap) ->
                        done(ref.startAt(snap.getPriority()).limit(2))
                parse: (snapshot) ->
                    snapshotToArray(snapshot)[1] || {}
                default: {}
            
            photoNext:
                ref: new Firebase(baseUrl)
                query: (ref, done) -> 
                    ref.child(id).once "value", (snap) ->
                        done(ref.endAt(snap.getPriority()).limit(2))
                parse: (snapshot) -> 
                    photos = snapshotToArray(snapshot)
                    photo = if photos.length == 1 then {} else photos[0]
                    photo
                default: {}


    render: ->
        conversion = "/convert?w=1000&h=1000"
        `<div className={"content "+(_.isEmpty(this.props.photo) ? "loading" : "")} style={{maxWidth:960}}>
            <div  className="photo-single">
                <a style={{color:'white',position:'absolute',top:10,left:10,fontSize:16,color:'#999999'}} href="/seeing">&larr; back</a>
                <a className="imageContainer"  style={{backgroundImage:"url("+this.props.photo.url+conversion+")"}}  href={this.props.photoNext.id ? "/seeing/"+this.props.photoNext.id : "/seeing"}></a>
                <simplePagination 
                    next={this.props.photoNext.id ? ("/seeing/"+this.props.photoNext.id) : false} 
                    prev={this.props.photoPrev.id ? ("/seeing/"+this.props.photoPrev.id) : false} 
                    back="/seeing" />
            </div>
            
            <div style={{opacity:0,position:'absolute',height:0,width:0}}>
                <img src={this.props.photoNext.url+conversion} />
            </div> 
        </div>`

module.exports = Component
