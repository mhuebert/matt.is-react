`/** @jsx React.DOM */`

React = require("react")
a = React.DOM.a

getRootComponent = (component) ->
  while component._owner
      component = component._owner
  component

ActiveLink = React.createClass
    getPath: ->
        window?.location.pathname || getRootComponent(this).props.path
    isActive: ->
        this.props.href+" - "+this.getPath()
        this.getPath() == this.props.href

    render: ->

        this.transferPropsTo(`<a className={(this.isActive() ? "activeLink" : "")}>{this.props.children}</a>`)

module.exports = ActiveLink
