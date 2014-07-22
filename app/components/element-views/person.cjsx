# @cjsx React.DOM

React = require("react/addons")
cx = React.addons.classSet
titleStyle = require("../widgets/titleStyle")

Component = React.createClass
    mixins: [titleStyle.Mixin]
    getInitialState: ->
      {titleStyle: {}}

    render: ->
        element = @props.element
        permalink = if element.permalink then "/"+element.permalink else "/#{element.type}/#{element.id}"
        <div className={"element element-"+element.type}>
            <img  className={cx(imagePrimary: true,hidden:!element.image)} 
                  style={marginBottom:18} 
                  src={if element.image then element.image+"/convert?w=600&h=600&fit=clip" else ""} />         
          <h2>
            <a style={@state.titleStyle} ref="link" href={permalink}>
              {element.title}
            </a>
          </h2>
          <p>{element.body}</p>
        </div>

module.exports = Component
