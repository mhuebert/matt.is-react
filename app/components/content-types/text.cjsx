# @cjsx React.DOM

marked = require("marked")
marked.setOptions
  gfm: true
  tables: true
  breaks: true
  pedantic: false
  sanitize: false
  smartLists: true
  smartypants: true

React = require("react")

Component = React.createClass
    render: ->
        <div className="element-text">
          <h2>{@props.title}</h2>
          <div className="text-body" dangerouslySetInnerHTML={{__html: marked(@props.body||"")}} />
        </div>

module.exports = Component
