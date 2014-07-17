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
        showMore: false
    maybeShowMore: (e) ->
        if "show-more-trigger" in e.target.classList
            @setState showMore: true
    render: ->
        body = (@props.body || "").split(/[\s\n\r]*?<break\s*?\/>\s?/m)
        
        if body[1]?
            multiple = true
            body[0] = body[0]+" <a class='show-more-trigger' href='#'>Read More...</a>"
            body[1] = "<div class='part-two'>"+marked(body[1])+"</div>"
        body[0] = marked(body[0])
        body = body.join("")
        <div className="element-text">
            <h2>{@props.title}</h2>
            <img className={cx(hidden:!@props.image)} style={marginBottom:18} src={if @props.image then @props.image+"/convert?w=500&h=500&fit=clip" else ""} />
            <div onClick={@maybeShowMore} className={cx("text-body":true, "show-more": @state.showMore)} dangerouslySetInnerHTML={{__html: body}} />

        </div>

module.exports = Component
