`/** @jsx React.DOM */`

# Blank component to use as template

React = require("react")
Link = require("./link")
Dropdown = require("./dropdown")

Component = React.createClass
    render: ->
        `this.transferPropsTo(<div className='nav-main'>
            <Dropdown replaceWithSelectedLink="true">
                <ul >
                    <li><Link href="/">Home</Link></li>
                    <li><Link href="/writing">Writing</Link></li>
                    <li><Link href="/seeing">Photography</Link></li>
                    <li><Link href="/reading">Books</Link></li>
                    <li><Link href="/ideas" className="showIfUser">Ideas</Link></li>
                </ul>
            </Dropdown>
            
            <Link href="/logout" className="btn btn-standard showIfUser right">Sign Out</Link>
            <Link href="/login" className="btn btn-standard hideIfUser right">Sign In</Link>
            {this.props.children}
        </div>)`

module.exports = Component
