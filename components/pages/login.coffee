`/** @jsx React.DOM */`

React = require("react")
DynamicLoader = require("../partials/dynamicLoader")

Component = React.createClass
    componentDidMount: ->
      setTimeout ->
        auth.login "twitter",
          rememberMe: true
      , 500
    render: ->
        `<div className="loading"><DynamicLoader /></div>`

module.exports = Component
