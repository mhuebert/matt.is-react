# @cjsx React.DOM

React = require("react")

Component = React.createClass
    render: ->
        <head>
            <title >{this.props.title}</title>
            <meta name='description' content={this.props.description} />
            <meta charSet="utf-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />

            <link rel="stylesheet" type="text/css" href="/styles/app.css" />
            <script type='text/javascript' src='/js/firebase.min.js'></script>
            <script type='text/javascript' src='/js/firebase-simple-login.js'></script>
            <script src="/js/app.js"></script>
            
        </head>

module.exports = Component
