# @cjsx React.DOM

_ = require("underscore")
React = require("react")

Body = require("../widgets/body")


subscriptions = require("../../subscriptions")
{SubscriptionAsyncMixin} = subscriptions

Component = React.createClass

    render: ->

        <Body breadcrumb={['new']} sidebar={true}>
            <h1>New</h1>
        </Body>

module.exports = Component
