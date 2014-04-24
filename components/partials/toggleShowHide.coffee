`/** @jsx React.DOM */`

React = require("react")

Component = React.createClass
    render: ->
        `this.transferPropsTo(<div>
          {this.props.children}
        </div>)`

module.exports = Component
