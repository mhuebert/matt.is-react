`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")

Body = require("../body")


{SubscriptionMixin} = require("sparkboard-tools")
subscriptions = require("../../subscriptions")

Component = React.createClass

    mixins: [SubscriptionMixin]

    statics:
        getMetadata: ->
            title: "Tags | Matt.is"
            description: "Sometimes I tag things. Here are my tags."
        subscriptions: (props) ->
            tags: subscriptions.Tags()

    render: ->

        `this.transferPropsTo(<Body breadcrumb={['tags']} className={"content "+ ((this.props.tags.length > 0) ? "" : "loading")}>
            <h1>Tags</h1>
            <ul className="link-list">
                {
                    this.props.tags.map(function(tag){
                        console.log(tag);
                        return <li key={tag.id} >
                                <a href={"/tags/"+tag.id}>{tag.id}</a>
                                </li>
                        })
                }
            </ul>
        </Body>)`

module.exports = Component
