# @cjsx React.DOM

React = require("react")
a = React.DOM.a

{getRootComponent} = require("sparkboard-tools").utils

ActiveLink = React.createClass
    getPath: ->
        window?.location.pathname || getRootComponent(this).props.path
    isActive: ->
        this.getPath() == this.props.href

    render: ->

        this.transferPropsTo(<a className={(if this.isActive() then "activeLink" else "")}>{this.props.children}</a>)

module.exports = ActiveLink
