# @cjsx React.DOM

_ = require("underscore")
React = require("react")

Body = require("../widgets/body")
NewTypes = require("../widgets/newTypes")

contentForms = require("../content-types/forms")

subscriptions = require("../../subscriptions")
{SubscriptionAsyncMixin} = subscriptions

Component = React.createClass
    
    render: ->
        type = @props.matchedRoute.params.type || "text"
        Form = contentForms[type]

        <Body breadcrumb={['new']} sidebar={true}>
            <NewTypes />
            {Form({}, null)}
        </Body>

module.exports = Component
