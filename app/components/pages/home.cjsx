# @cjsx React.DOM

React = require("react")



subscriptions = require("../../subscriptions")
ContentFilter = require("../widgets/contentFilter")
Body = require("../widgets/body")
{AsyncSubscriptionMixin} = subscriptions

Home = React.createClass
    mixins: [AsyncSubscriptionMixin]
    statics:
        subscriptions: (props) ->
            people: subscriptions.WritingList(20, '/users/'+props.settings.ownerId+'/writing')
        getMetadata: (props) ->
            title: props.settings.siteTitle
            description: props.settings.siteDescription
    render: ->
        <Body sidebar={true}>
          <ContentFilter />
          <p>Hello</p>
        </Body>

module.exports = Home
