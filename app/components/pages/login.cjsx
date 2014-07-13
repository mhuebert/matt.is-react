# @cjsx React.DOM

React = require("react")
DynamicLoader = require("../widgets/dynamicLoader")
Body = require("../body")
Component = React.createClass
    login: ->
      auth.login "twitter",
        rememberMe: true

    render: ->
      loggedIn = user?.id?
      if window? and user?.id?
        window.location.href = "/"
      <Body>
        <a className={if loggedIn then "hidden" else ""} href="#" onClick={this.login}>Login</a>
        <a className={if loggedIn then "" else "hidden"} href="/">Home</a>
      </Body>

module.exports = Component
