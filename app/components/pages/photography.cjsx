# @cjsx React.DOM

React = require("react")
Body = require("../body")

{SubscriptionMixin} = require("sparkboard-tools")
subscriptions = require("../../subscriptions")
{Collection} = require("../../models")



Component = React.createClass
    mixins: [SubscriptionMixin]
    statics:
        subscriptions: ->
            photos: subscriptions.List("/photos", limit:500)
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
                newPhotoRef = this.props.subscriptions.photos.ref.push
                    url: blob.url
                    owner: user.id
                newPhotoRef.setPriority Date.now()
    deletePhoto: (e) ->
        if confirm("Are you sure?")
            this.props.subscriptions.photos.ref.child(e.target.getAttribute("data-id")).remove()
            e.preventDefault()
            e.stopPropagation()
    render: ->
        deletePhoto = this.deletePhoto
        photos = new Collection(this.props.photos)
        <Body breadcrumb={["photography"]} className={"content "+ ((photos.size() > 0) ? "" : "loading")} style={{maxWidth:960}}>
            <h1>Photography</h1>
            <div className="photos text-center">
                <div className="showIfUser">
                    <a style={{display:'block',maxWidth:780, margin:"20px auto 30px"}} className="btn btn-standard" onClick={this.uploadPhoto}>Upload Photos</a>
                </div>
                { photos.map( (photo) -> 
                    <a key={photo.get("id")} href={"/seeing/"+photo.get("id")}><div data-id={photo.get("id")} onClick={deletePhoto} className="photo-delete">&times;</div><img src={photo.get("url")+"/convert?w=220&h=220&fit=crop"} /></a>)
                }
                </div>
        </Body>

module.exports = Component
