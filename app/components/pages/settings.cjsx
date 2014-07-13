# @cjsx React.DOM

_ = require("underscore")
React = require("react")

Body = require("../widgets/body")
{Firebase, FIREBASE_URL} = require("../../firebase")

subscriptions = require("../../subscriptions")
{SubscriptionAsyncMixin} = subscriptions

textSingle = require("../form/textSingle")

Component = React.createClass

    mixins: [SubscriptionAsyncMixin]

    statics:
        subscriptions: (props) ->
            tags: subscriptions.Settings()

    render: ->

        <Body breadcrumb={['settings']} sidebar={true}>
            <h1>Settings</h1>
            <form>
            <textSingle label="Title" ref={new Firebase(FIREBASE_URL+"/settings/siteName")} />
            <textSingle label="Description" ref={new Firebase(FIREBASE_URL+"/settings/siteName")} />
            </form>
        </Body>

module.exports = Component
