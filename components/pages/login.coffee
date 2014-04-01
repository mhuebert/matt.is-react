`/** @jsx React.DOM */`

React = require("react")
DynamicLoader = require("../partials/dynamicLoader")
Body = require("../body")
Component = React.createClass
    componentDidMount: ->
      setTimeout ->
        auth.login "twitter",
          rememberMe: true
      , 500
    render: ->
        `<Body className="loading"></Body>`

module.exports = Component
