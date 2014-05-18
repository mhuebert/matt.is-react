`/** @jsx React.DOM */`

React = require("react")
Body = require("../body")
Nav = require("../partials/nav")
Writing = require("./writing")
Photography = require("./photography")

{SubscriptionMixin} = require("sparkboard-tools")
subscriptions = require("../../app/subscriptions")
{Collection} = require("../../app/models")

Home = React.createClass
    mixins: [SubscriptionMixin]
    statics:
        subscriptions: (props) ->
            photos: subscriptions.PhotoList(9)
            writing: subscriptions.WritingList(20, props.settings.ownerId)
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
        </div>`

module.exports = Home
