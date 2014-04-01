`/** @jsx React.DOM */`

React = require("react")

Component = React.createClass
    render: ->
        `<head>
            <title >{this.props.title}</title>
            <meta name='description' content={this.props.description} />
            <meta charSet="utf-8"/>
            <link rel="stylesheet" type="text/css" href="/app.css" />
            <script type='text/javascript' src='/js/firebase.min.js'></script>
            <script type='text/javascript' src='/js/firebase-simple-login.js'></script>
            <script src="/js/app.js"></script>
            
        </head>`

module.exports = Component
