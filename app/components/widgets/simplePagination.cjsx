# @cjsx React.DOM

React = require("react")
{getRootComponent} = require("sparkboard-tools").utils

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
      if e.which == 27
        @back()
    next: ->
      this.refs.next.getDOMNode().click() if this.props.next
    prev: ->
      this.refs.prev.getDOMNode().click() if this.props.prev
    back: ->
      this.refs.back.getDOMNode().click() if this.props.back

    render: ->
        this.transferPropsTo(<div className="paginate-simple">
            <a ref="prev" onClick={this.prev} className={"btn btn-white prev "+(if this.props.prev then "" else "hidden")} href={this.props.prev}/>
            <a ref="next" className={"btn btn-white next "+(if this.props.next then "" else "hidden")} href={this.props.next}/>
        </div>)

module.exports = Component


