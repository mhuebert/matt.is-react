# @cjsx React.DOM

_ = require("underscore")
React = require("react")

Body = require("../widgets/body")
{FIREBASE_URL} = require("../../firebase")

Text = require("../form-elements/text")

Component = React.createClass

    render: ->

        <Body breadcrumb={['settings']} sidebar={true}>
            <h1>Settings</h1>
            <form>
            <Text label="Title" fireRef={FIREBASE_URL+"/settings/siteTitle"} />
            <Text type="textarea" label="Description" fireRef={FIREBASE_URL+"/settings/siteDescription"} />
            </form>
        </Body>

module.exports = Component
