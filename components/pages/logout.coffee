`/** @jsx React.DOM */`

React = require("react")
DynamicLoader = require("../partials/dynamicLoader")
Body = require("../body")

Component = React.createClass
    componentDidMount: ->
      auth.logout()
      setTimeout ->
        window.location.href = "/"
      , 600
    render: ->
        `<Body className="loading">
          <DynamicLoader />
          </Body>`

module.exports = Component
