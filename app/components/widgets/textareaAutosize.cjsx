# @cjsx React.DOM

React = require("react")

Component = React.createClass
  autoSize: ->
    textarea = this.getDOMNode()
    # textarea.style.height = ""
    textarea.style.height = textarea.scrollHeight + "px"
  onKeyUp: ->
    @autoSize()
  componentDidUpdate: ->
    @autoSize()
  render: ->
      this.transferPropsTo(
        <textarea placeholder={@props.placeholder || "Write here..."} 
                  className="textarea-autosize" 
                  onKeyUp={this.handleChange}>
        </textarea>
      )

module.exports = Component
