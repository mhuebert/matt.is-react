`/** @jsx React.DOM */`

React = require("react")
DynamicLoader = require("../partials/dynamicLoader")
Body = require("../body")

Component = React.createClass
    componentDidMount: ->
      setTimeout ->
        auth.logout()
    render: ->
        `<Body className="loading">
          <DynamicLoader />
          </Body>`

module.exports = Component
