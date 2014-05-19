`/** @jsx React.DOM */`

# Blank component to use as template

React = require("react")
Link = require("./link")
Dropdown = require("./dropdown")

Component = React.createClass
    render: ->
        `this.transferPropsTo(<div className='nav-main'>
            <Link href="/">Home</Link>            
            <Link href="/ideas" className="showIfUser btn btn-standard">Ideas</Link>
            <Link href="/logout" className="btn btn-standard showIfUser right">Sign Out</Link>
            <Link href="/login" className="btn btn-standard hideIfUser right hidden">Sign In</Link>
            {this.props.children}
        </div>)`

module.exports = Component
