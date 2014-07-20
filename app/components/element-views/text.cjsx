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

Component = React.createClass
    getInitialState: ->
        showAll: @props.showAll || false
    maybeshowAll: (e) ->
        if "show-more-trigger" in e.target.classList
            @setState showAll: true
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

        <div className="element element-text">
            <h2><a href={"/#{element.type}/#{element.id}"}>{element.title}</a></h2>
            <img className={cx(hidden:!element.image)} style={marginBottom:18} src={if element.image then element.image+"/convert?w=500&h=500&fit=clip" else ""} />
            <div onClick={@maybeshowAll} className={cx("text-body":true, "show-more": @state.showAll)} dangerouslySetInnerHTML={{__html: body}} />

        </div>

module.exports = Component
