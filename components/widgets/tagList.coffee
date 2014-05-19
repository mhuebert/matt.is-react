`/** @jsx React.DOM */`

React = require("react")

Component = React.createClass
    render: ->
        `<ul className="tag-list">
          {this.props.tags.map(function(tag){
            return(<li className="tag" key={tag}>{tag}</li>)
          })}
        </ul>`

module.exports = Component
