# @cjsx React.DOM

React = require("react/addons")
cx = React.addons.classSet

Component = React.createClass
    render: ->
        element = @props.element
        <div className="element-image">
          <p>
            {element.title}
          </p>
          <a href={"/#{element.type}/#{element.id}"}>
            <img className={cx(hidden:!element.image)} style={marginBottom:18} src={if element.image then element.image+"/convert?w=500&h=500&fit=clip" else ""} />
          </a>
          <p>{element.body}</p>
        </div>

module.exports = Component
