# @cjsx React.DOM

_ = require("underscore")
React = require("react")

Body = require("../widgets/body")


subscriptions = require("../../subscriptions")
{SubscriptionAsyncMixin} = subscriptions

Component = React.createClass

    mixins: [SubscriptionAsyncMixin]

    statics:
        subscriptions: (props) ->
            tags: subscriptions.Settings()

    render: ->

        <Body breadcrumb={['settings']}>
            <h1>Settings</h1>
        </Body>

module.exports = Component
