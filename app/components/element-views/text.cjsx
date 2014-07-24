# @cjsx React.DOM

_ = require("underscore")
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


titleStyle = require("../widgets/titleStyle")

Component = React.createClass
    mixins: [titleStyle.Mixin]
    getInitialState: ->
        showAll: @props.showAll || false
        titleStyle: {}
    maybeshowAll: (e) ->
        if "show-more-trigger" in e.target.classList
            @setState showAll: true
            e.preventDefault()
    render: ->
        element = @props.element
        body = (element.body || "").split(/[\s\n\r]*?<break\s*?\/>\s?/m)
        
        if body[1]?
            multiple = true
            body[0] = body[0]+" <a class='show-more-trigger' href='#'>Read More...</a>"
            body[1] = "<div class='part-two'>"+marked(body[1])+"</div>"
        body[0] = marked(body[0])
        body = body.join("")

        date = new Date(element.date)
        readableDate = "#{date.getFullYear()}/#{date.getMonth()}/#{date.getDate()}"

        style = if element.image then @state.titleStyle else {}

        permalink = if element.permalink then "/"+element.permalink else "/#{element.type}/#{element.id}"
          
        <div className="element element-text">
            <img className={cx(hidden:!element.image)} style={marginBottom:18} src={if element.image then element.image+"/convert?w=500&h=500&fit=clip" else ""} />
            <h2>
              <a style={style} href={permalink}>{element.title}</a>
            </h2>
            
            <div onClick={@maybeshowAll} className={cx("text-body":true, "show-more": @state.showAll)} dangerouslySetInnerHTML={{__html: body}} />

        </div>

module.exports = Component
