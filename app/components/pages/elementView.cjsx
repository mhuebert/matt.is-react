# @cjsx React.DOM

React = require("react/addons")
cx = React.addons.classSet

ContentFilter = require("../widgets/contentFilter")
Body = require("../widgets/body")
ContentComponents = require("../element-views/index")


subscriptions = require("../../subscriptions")
{AsyncSubscriptionMixin} = subscriptions

Home = React.createClass
    mixins: [AsyncSubscriptionMixin]
    componentDidMount: ->
        window.scrollTo(0,0)
    statics:
        subscriptions: (props) ->
            element: subscriptions.Object("/elements/#{props.matchedRoute.params.id}")
        getMetadata: (props) ->
            title: if props.title then props.title+" | #{props.settings.siteTitle}" else props.settings.siteTitle
            description: if props.body then props.body[0..120]+"..." else props.settings.siteDescription
    render: ->
        element = @subs("element")
        Element = ContentComponents[element.type] || React.DOM.div
        <Body sidebar={true}>
        <a href={"/edit/#{element.type}/#{element.id}"} className="edit-content right showIfUser">Edit</a>
        {Element({element: element, showAll: true}, null)}
        </Body>

module.exports = Home
