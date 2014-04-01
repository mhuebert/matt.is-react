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
            baseUrl = FIREBASE_URL+'/test1/photos/'
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
        `<div className={"content "+(_.isEmpty(this.props.photo) ? "loading" : "")} style={{maxWidth:960}}>
            <div  className="photo-single">
                <a style={{color:'white',position:'absolute',top:10,left:10,fontSize:16,color:'#999999'}} href="/seeing">&larr; back</a>
                <a className="imageContainer"  style={{backgroundImage:"url("+this.props.photo.url+")"}}  href={this.props.photoNext.id ? "/seeing/"+this.props.photoNext.id : "/seeing"}></a>
                <simplePagination 
                    next={this.props.photoNext.id ? ("/seeing/"+this.props.photoNext.id) : false} 
                    prev={this.props.photoPrev.id ? ("/seeing/"+this.props.photoPrev.id) : false} /> 
            </div>
            
            <div className="hidden">
                <img src={this.props.photoNext.url} />
                <img src={this.props.photoPrev.url} />
            </div> 
        </div>`

module.exports = Component
