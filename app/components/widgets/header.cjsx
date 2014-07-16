# @cjsx React.DOM

React = require("react")

subscriptions = require("../../subscriptions")
{AsyncSubscriptionMixin} = subscriptions
{darken} = require("../../colors")
# caption={this.props.settings.homeTitle} 
Component = React.createClass
    mixins: [AsyncSubscriptionMixin]
    componentDidMount: ->
      @setState headerColor: accentColor
    statics:
        subscriptions: (props) ->
            settings: subscriptions.Settings()
    render: ->
        headerStyle = 
          background: @state.headerColor
          borderBottom: "2px solid #{darken(@state.headerColor, 0.07)}"
        @transferPropsTo <div style={headerStyle} className={"header"+(if @props.header == false then "hidden" else "")}>
          <div className="header-image">
            <h1><a className="header-caption" href="/">{@props.header?.title || @subs('settings').siteTitle}</a></h1>
          </div>
        </div>
      

module.exports = Component
