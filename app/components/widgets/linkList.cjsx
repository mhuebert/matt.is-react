# @cjsx React.DOM

React = require("react")

Component = React.createClass
    render: ->
        this.transferPropsTo(<ul className="link-list">
            {this.props.list.map((link)-> 
              <li key={link.id}><a href={link.href}>{link.title}</a></li>
            )}
        </ul>)

module.exports = Component
