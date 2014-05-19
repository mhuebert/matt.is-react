`/** @jsx React.DOM */`

React = require("react")
DynamicLoader = require("../widgets/dynamicLoader")
Body = require("../body")
Component = React.createClass
    login: ->
      auth.login "twitter",
        rememberMe: true

    render: ->
      loggedIn = user?.id?
      `<Body>
        <a className={loggedIn ? "hidden" : ""} href="#" onClick={this.login}>Login</a>
        <a className={loggedIn ? "" : "hidden"} href="/">Home</a>
      </Body>`

module.exports = Component
