`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")

Body = require("../body")

{SubscriptionMixin} = require("sparkboard-tools")
{WritingList} = require("../../subscriptions")

Component = React.createClass

    mixins: [SubscriptionMixin]

    statics:
        getMetadata: ->
            title: "Writing | Matt.is"
            description: "Wherein I uncover."
        subscriptions: ->
            writing: WritingList()

    render: ->

        `this.transferPropsTo(<Body className={"content "+ ((this.props.writing.length > 0) ? "" : "loading")}>
            <h1>Writing</h1>
            <ul className="messages link-list">
                {
                    this.props.writing.map(function(post){
                        return <li key={post.id} >
                                <a href={"/writing/"+post.id}>{post.title}</a>
                                </li>
                        })
                }
            </ul>

        </Body>)`

module.exports = Component
