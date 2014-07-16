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

React = require("react/addons")
cx = React.addons.classSet

Component = React.createClass
    render: ->
        <div className="element-text">
          <h2>{@props.title}</h2>
          <img className={cx(hidden:!@props.image)} style={marginBottom:18} src={if @props.image then @props.image+"/convert?w=500&h=500&fit=clip" else ""} />
          <div className="text-body" dangerouslySetInnerHTML={{__html: marked(@props.body||"")}} />
        </div>

module.exports = Component
