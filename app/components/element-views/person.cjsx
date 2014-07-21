# @cjsx React.DOM

React = require("react/addons")
cx = React.addons.classSet

Component = React.createClass
    render: ->
        element = @props.element
        <div className="element">
            <img  className={cx(imagePrimary: true,hidden:!element.image)} 
                  style={marginBottom:18} 
                  src={if element.image then element.image+"/convert?w=600&h=600&fit=clip" else ""} />         
          <h2>
            <a href={"/#{element.type}/#{element.id}"}>
              {element.title}
            </a>
          </h2>
          <p>{element.body}</p>
        </div>

module.exports = Component
