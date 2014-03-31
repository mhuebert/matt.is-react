`/** @jsx React.DOM */`

# Blank component to use as template

React = require("react")
Link = require("./link")
Dropdown = require("./dropdown")

Component = React.createClass
    render: ->
        `<div className='nav-main'>
            <Dropdown replaceWithSelectedLink="true">
                <ul >
                    <li><Link href="/">Home</Link></li>
                    <li><Link href="/writing">Writing</Link></li>
                    <li><Link href="/seeing">Photography</Link></li>
                    <li><Link href="/reading">Books</Link></li>
                </ul>
            </Dropdown>
            <Link href="/ideas" className="showIfUser">Ideas</Link>
            <Link href="/logout" className="showIfUser right">Sign Out</Link>
            <Link href="/login" className="hideIfUser right">Sign In</Link>
        </div>`

module.exports = Component
