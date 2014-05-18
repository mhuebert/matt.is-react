`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")

Body = require("../body")

{SubscriptionMixin} = require("sparkboard-tools")
subscriptions = require("../../app/subscriptions")

Component = React.createClass

    mixins: [SubscriptionMixin]

    statics:
        getMetadata: ->
            title: "Writing | Matt.is"
            description: "Wherein I uncover."
        subscriptions: (props) ->
            writing: subscriptions.WritingList(50, props.settings.ownerId)

    render: ->

        `this.transferPropsTo(<Body className={"content "+ ((this.props.writing.length > 0) ? "" : "loading")}>
            <h1>Writing</h1>
            <ul className="link-list">
                {
                    this.props.writing.map(function(post){
                        return <li key={post.id} >
                                <a href={"/"+post.permalink}>{post.title}</a>
                                </li>
                        })
                }
            </ul>

        </Body>)`

module.exports = Component
