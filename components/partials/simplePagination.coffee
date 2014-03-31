`/** @jsx React.DOM */`

React = require("react")
getRootComponent = (component) ->
  while component._owner
      component = component._owner
  component

Component = React.createClass
    componentDidMount: ->
      window.addEventListener('keydown', this.navigate)
    componentWillUnmount: ->
      window?.removeEventListener('keydown', this.navigate)
    navigate: (e) ->
      if e.target.tagName in ['TEXTAREA', 'INPUT']
        return
      if e.which == 39
        @next()
      if e.which == 37
        @prev()
    next: ->
      this.refs.next.getDOMNode().click()
    prev: ->
      this.refs.prev.getDOMNode().click()

    render: ->
        `<div className="paginate-simple">
            <a ref="prev" onClick={this.prev} className={"prev "+(this.props.prev ? "" : "hidden")} href={this.props.prev}/>
            <a ref="next" className={"next "+(this.props.next ? "" : "hidden")} href={this.props.next}/>
        </div>`

module.exports = Component


