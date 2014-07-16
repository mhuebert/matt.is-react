# @cjsx React.DOM

React = require("react")
Body = require("../widgets/body")

Component = React.createClass

    render: ->
      path = window?.location.pathname || @props.path
      path = path.replace(/^\/+|\/+$/gm,'')
      <Body sidebar={true} breadcrumb={path.split("/")}>
        <h1>So much paths. Could not find this one :-/.</h1>
      </Body>
module.exports = Component
