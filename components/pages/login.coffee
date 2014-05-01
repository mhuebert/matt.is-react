`/** @jsx React.DOM */`

React = require("react")
DynamicLoader = require("../partials/dynamicLoader")
Body = require("../body")
Component = React.createClass
    componentDidMount: ->
      auth.login "twitter",
        rememberMe: true
    render: ->
        `<Body className="loading"></Body>`

module.exports = Component
