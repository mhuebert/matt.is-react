# @cjsx React.DOM

React = require("react")
AddNode = require("./addNode")
Link = require("./link")
Header = require("./header")

subscriptions = require("../../subscriptions")
{AsyncSubscriptionMixin} = subscriptions

initialState = {themes: [], people: [], subscriptions: {themes: [], people: []}}

Component = React.createClass
	mixins: [AsyncSubscriptionMixin]
	statics:
			subscriptions: (props) ->
					# people: subscriptions.List("/people", sort: "a-z")
					people: subscriptions.ElementsByIndex("/types/person")
					themes: subscriptions.List("/themes", sort: "a-z")
					settings: subscriptions.Object("/settings")
	getInitialState: -> {}
	render: ->
		subs = this.type.subscriptions(@props)
		<div>
			<Header />
			<em>Edited in {@subs("settings").location}</em>
			<div style={{marginTop: 13}} className="showIfUser">
				<Link className="btn btn-white btn-block" href="/new" >New</Link>
				<Link href="/ideas" >Ideas</Link> • 
				<Link href="/settings" >Settings</Link> • 
				<Link href="/logout" >Sign Out</Link>
			</div>
			<h3><a href="/themes/">Topics »</a></h3>
			<AddNode className="showIfUser" ref={subs.themes.ref} attribute="name" />
			<ul>{
				@subs('themes').map (theme) -> 
					<li key={theme.id}><a href="/themes/#{theme.id}">{theme.name}</a></li>
			}</ul>
			<h3><a href="/people/">People »</a></h3>
			<ul>{
				@subs('people').map (person) -> 
					<li key={person.id}><a href="/person/#{person.id}">{person.title}</a></li>
			}</ul>
		</div>

module.exports = Component
