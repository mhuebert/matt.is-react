# @cjsx React.DOM

React = require("react")

Component = React.createClass
    render: ->
        <div className="input-group">
          <input name={@props.name}/>
          <label for={@props.name}>{@props.label}</label>
        </div>

module.exports = Component
