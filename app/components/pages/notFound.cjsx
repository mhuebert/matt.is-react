# @cjsx React.DOM

React = require("react")
Body = require("../widgets/body")

Component = React.createClass

    render: ->
      <Body sidebar={true}>
        <h1>So much paths. Could not find this one :-/.</h1>
      </Body>
module.exports = Component
