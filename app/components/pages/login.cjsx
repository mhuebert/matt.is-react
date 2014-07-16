# @cjsx React.DOM

React = require("react")
DynamicLoader = require("../widgets/dynamicLoader")
Body = require("../body")
Component = React.createClass
    login: ->
      auth.login "twitter",
        rememberMe: true
      false
    getInitialState: -> accentColor: 'white'
    componentDidMount: ->
      @setState accentColor: accentColor
    render: ->
      loggedIn = user?.id?
      if window? and user?.id?
        window.location.href = "/"
      styles = 
        background: @state.accentColor

      <div className="single-purpose">
        <a style={styles} className={if loggedIn then "hidden" else ""} href="#" onClick={this.login}>
          <span>Login</span>
        </a>
        <a style={styles} className={if loggedIn then "" else "hidden"} href="/">
          <span>...</span>
        </a>
      </div>

module.exports = Component
