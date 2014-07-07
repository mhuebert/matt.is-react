`/** @jsx React.DOM */`

React = require("react")
Body = require("../body")
Nav = require("../widgets/nav")
Writing = require("./writing")
Photography = require("./photography")

{SubscriptionMixin} = require("sparkboard-tools")
subscriptions = require("../../subscriptions")
{Collection} = require("../../models")

Home = React.createClass
    mixins: [SubscriptionMixin]
    statics:
        subscriptions: (props) ->
            writing: subscriptions.WritingList(20, '/users/'+props.settings.ownerId+'/writing' )
            photos: subscriptions.PhotoList()
        getMetadata: (props) ->
            title: props.settings.siteTitle
            description: props.settings.siteDescription
    render: ->
        writing = new Collection(this.props.writing)
        photos = new Collection(this.props.photos)
        `<div className="content">
                <Nav />
                <h1>{this.props.settings.homeTitle}</h1>
                <ul className="link-list" >
                    {writing.map(function(post){  
                        return <li key={post.get("id")} >
                            <a href={"/"+post.get("permalink")}>{post.get("title")}</a> 
                        </li>})}
                    <li key="more"><a href="/writing" className="more-link btn btn-standard" >more &rarr;</a></li>
                </ul>
            <div className="home-photos">
                {photos.map(function(photo){
                    return  <a key={photo.get("id")} href={"/seeing/"+photo.get("id")}>
                                <img src={photo.get("url")+"/convert?w=120&h=120&fit=crop"} />
                            </a>
                    })}
            </div>

        </div>`

module.exports = Home
