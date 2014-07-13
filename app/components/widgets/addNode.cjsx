# @cjsx React.DOM

React = require("react")
{slugify} = require("sparkboard-tools").utils

Component = React.createClass
	getInitialState: -> 
		state = {}
		state[@props.attribute] = ""
		state
	handleChange: (e) ->
		state = {}
		state[@props.attribute] = e.target.value
		@setState state
	handleKeyDown: (e) ->
		value = @state[@props.attribute]
		if value?.length > 1 and e.which == 13
			obj = {}
			obj[@props.attribute] = value
			@props.ref.child(slugify(value)).set obj
			obj[@props.attribute] = ""
			@setState obj
	render: ->
		@transferPropsTo <input value={@state.name}
								type="text"
								placeholder="Add..."
								onKeyDown={@handleKeyDown} 
								onChange={@handleChange} /> 

module.exports = Component
