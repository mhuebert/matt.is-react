# @cjsx React.DOM

React = require("react/addons")
cx = React.addons.classSet

subscriptions = require("../../subscriptions")
ContentFilter = require("../widgets/contentFilter")
Body = require("../widgets/body")
{AsyncSubscriptionMixin} = subscriptions
ContentComponents = require("../element-views/index")
DynamicDivider = require("../widgets/dynamicDivider")
_ = require("underscore")


Home = React.createClass
    mixins: [AsyncSubscriptionMixin]
    componentDidMount: ->
        window.scrollTo(0,0)
    statics:
        subscriptions: (props) ->
            if type = props.matchedRoute.params.type
                elements = subscriptions.ElementsByIndex("/types/"+type)
            else if topic = props.matchedRoute.params.topic
                elements = subscriptions.ElementsByIndex("/related/topics/"+topic)
            else
                elements = subscriptions.List("/elements", sort: "reverse")
            elements.shouldUpdateSubscription = (oldProps, newProps) ->
                o = oldProps.matchedRoute.params
                n = newProps.matchedRoute.params
                o.type != n.type or o.topic != n.topic
            elements: elements
        getMetadata: (props) ->
            title: props.settings.siteTitle
            description: props.settings.siteDescription
    render: ->
        elements = _(@subs("elements")).filter (element) -> element.status != "idea"
        if topic = @props.matchedRoute.params.topic
            breadcrumb = [["topics/#{topic}", topic]]
        else if type = @props.matchedRoute.params.type
            breadcrumb = [["topics/#{type}", type]]
        else
            breadcrumb = [] 
        <Body sidebar={true} breadcrumb={breadcrumb}>
            <ContentFilter className="hidden" />
            {
                elements.map (element, index) ->
                    Element = ContentComponents[element.type] || React.DOM.div

                    <div key={element.id} className={"element-container element-#{element.type}"}>
                        <a href={"/edit/#{element.type}/#{element.id}"} className="edit-content showIfUser"></a>
                        {Element({element: element}, null)}
                        <DynamicDivider className={cx(hidden:(index+1 == elements.length))} />
                    </div>
            }
        </Body>

module.exports = Home
