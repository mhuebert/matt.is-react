# @cjsx React.DOM

React = require("react")

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
            people: subscriptions.WritingList(20, '/users/'+props.settings.ownerId+'/writing')
            elements: subscriptions.List("/elements")
        getMetadata: (props) ->
            title: props.settings.siteTitle
            description: props.settings.siteDescription
    render: ->
        <Body sidebar={true}>
            <ContentFilter />
            {
                @subs("elements").map (element) ->
                    Element = ContentComponents[element.type]
                    <div key={element.id}>
                        {Element(element, null)}
                        <DynamicDivider />
                    </div>
            }
        </Body>

module.exports = Home
