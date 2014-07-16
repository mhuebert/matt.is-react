# @cjsx React.DOM

React = require("react/addons")
cx = React.addons.classSet

subscriptions = require("../../subscriptions")
ContentFilter = require("../widgets/contentFilter")
Body = require("../widgets/body")
{AsyncSubscriptionMixin} = subscriptions
ContentComponents = require("../content-types/index")
DynamicDivider = require("../widgets/dynamicDivider")



Home = React.createClass
    mixins: [AsyncSubscriptionMixin]
    statics:
        subscriptions: (props) ->
            if type = props.matchedRoute.params.type
                elements = subscriptions.ElementsByIndex("/types/"+type)
            else
                elements = subscriptions.List("/elements")
            elements.shouldUpdateSubscription = (oldProps, newProps) ->
                oldProps.matchedRoute.params.type != newProps.matchedRoute.params.type
            elements: elements
        getMetadata: (props) ->
            title: props.settings.siteTitle
            description: props.settings.siteDescription
    render: ->
        elements = @subs("elements")
        <Body sidebar={true}>
            <ContentFilter />
            {
                elements.map (element, index) ->
                    Element = ContentComponents[element.type] || React.DOM.div
                    <div key={element.id}>
                        {Element(element, null)}
                        <DynamicDivider className={cx(hidden:(index+1 == elements.length))} />
                    </div>
            }
        </Body>

module.exports = Home
