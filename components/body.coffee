`/** @jsx React.DOM */`

React = require("react")
DynamicLoader = require("./partials/dynamicLoader")

Component = React.createClass
    render: ->
      `this.transferPropsTo(<div className="content">
        <DynamicLoader />
        {this.props.children}
      </div>)`

module.exports = Component
