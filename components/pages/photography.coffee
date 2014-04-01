`/** @jsx React.DOM */`

React = require("react")
Body = require("../body")
Nav = require("../partials/nav")

FirebaseMixin = require("../../utils/firebase").FirebaseMixin
PhotoList = require("../../utils/queries").PhotoList
DynamicLoader = require("../partials/dynamicLoader")


Component = React.createClass
    mixins: [FirebaseMixin]
    statics:
        firebase: ->
            photos: PhotoList()
        getMetadata: ->
            title: "Photography | Matt.is"
            description: "To see, or not to see."
    uploadPhoto: ->
        options = 
            multiple: true
            mimetypes: ['image/*']
            container: 'window'
        filepicker.pickAndStore options, {}, (inkBlobs) =>
            for blob in inkBlobs
                newPhotoRef = this.props.firebase.photos.ref.push {url: blob.url}
                newPhotoRef.setPriority Date.now()
    deletePhoto: (e) ->
        if confirm("Are you sure?")
            this.props.firebase.photos.ref.child(e.target.getAttribute("data-id")).remove()
    render: ->
        deletePhoto = this.deletePhoto
        `<div className={"content "+ ((this.props.photos.length > 0) ? "" : "loading")} style={{maxWidth:960}}>
            <Nav />
            <DynamicLoader /><DynamicLoader />
            <h1>Photography</h1>
            <div className="photos text-center">
                <div className="showIfUser">
                    <a style={{display:'block',marginBottom:20}} className="btn btn-standard" onClick={this.uploadPhoto}>Upload Photos</a>
                </div>
              {this.props.photos.map(function(photo){return <a key={photo.id} href={"/seeing/"+photo.id}><div onClick={deletePhoto} className="photo-delete">&times;</div><img src={photo.url+"/convert?w=220&h=220&fit=crop"} /></a>})}
            </div>
        </div>`

module.exports = Component
