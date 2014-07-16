# @cjsx React.DOM

React = require("react/addons")
cx = React.addons.classSet

Component = React.createClass
    render: ->
        <div className="element-image">
          <p>{@props.title}</p>
          <img className={cx(hidden:!@props.image)} style={marginBottom:18} src={if @props.image then @props.image+"/convert?w=500&h=500&fit=clip" else ""} />
            <p>{@props.body}</p>
        </div>

module.exports = Component
