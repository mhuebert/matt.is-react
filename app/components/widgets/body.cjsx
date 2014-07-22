# @cjsx React.DOM

React = require("react")

Sidebar = require("./sidebar")
AboveHeader = require("./aboveHeader")
Header = require("./header")
Link = require("./link")
ContentFilter = require("./contentFilter")

# caption={this.props.settings.homeTitle} 
Component = React.createClass
    
    render: ->
      <div className={"content"+(if @props.sidebar == false then " single-col" else "")}>
          <div className="left-col">
              <AboveHeader breadcrumb={@props.breadcrumb} />
              <Header />

              {@transferPropsTo(<div>{@props.children}</div>)}
          </div>

          <div className={"right-col"+(if @props.sidebar == false then " hidden" else "")}>
              <Sidebar />
          </div>
          <div className="clear" />

      </div>

module.exports = Component
