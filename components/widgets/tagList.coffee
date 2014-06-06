`/** @jsx React.DOM */`

React = require("react")

Component = React.createClass
    render: ->
        urlFor = this.props.url
        labelFor = this.props.label
        `<ul className="tag-list">
          {this.props.tags.map(function(tag, i){
            return(<li key={i+tag}><a href={urlFor(tag)}>{labelFor(tag)}</a></li>)
          })}
        </ul>`

module.exports = Component
