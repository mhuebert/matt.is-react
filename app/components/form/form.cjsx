# @cjsx React.DOM

React = require("react")

Component = React.createClass
    getDefaultProps: ->
        payload: {}
    handleSubmit: (e) ->
        console.log @props.payload
        e.preventDefault()
    render: ->
        @transferPropsTo <form onSubmit={@handleSubmit}>
            {@props.children}
        </form>

module.exports = Component
