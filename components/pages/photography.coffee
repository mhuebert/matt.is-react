`/** @jsx React.DOM */`

React = require("react")
Body = require("../body")

Component = React.createClass

    statics:
        getMetadata: ->
            title: "Photography | Matt.is"
            description: "To see, or not to see."

    render: ->
        `<Body>
            <h1>Photography</h1>
        </Body>`

module.exports = Component
