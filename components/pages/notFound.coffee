`/** @jsx React.DOM */`

React = require("react")
Body = require("../body")

Component = React.createClass
    render: ->
      console.log "Going to crash"
      `<Body>
          <h1>So much paths. We not couldn't find one this.</h1>
      </Body>`

module.exports = Component
