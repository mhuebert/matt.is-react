`/** @jsx React.DOM */`

React = require("react")
Nav = require("./partials/nav")
DynamicLoader = require("./partials/dynamicLoader")

Component = React.createClass
    render: ->
      `this.transferPropsTo(<div className="content">
        <Nav />
        <DynamicLoader />
        {this.props.children}
      </div>)`

module.exports = Component
