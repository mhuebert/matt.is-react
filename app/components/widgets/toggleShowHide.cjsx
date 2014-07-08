# @cjsx React.DOM

React = require("react")
{closestData} = require("sparkboard-tools").utils

Component = React.createClass
    handleClick: (e) ->
        if link = closestData(e.target, 'toggleHide') 
            e.preventDefault()
            e.stopPropagation()
            state = switch link.dataset.toggleHide
                when "false" then false
                when "true" then true
            this.setState
                hidden: state
    getInitialState: ->
      hidden: true
    render: ->
        this.transferPropsTo(<div onClick={this.handleClick} className={(if this.state.hidden then "toggle-hide-true" else "toggle-hide-false")}>
          {this.props.children}
        </div>)

module.exports = Component
