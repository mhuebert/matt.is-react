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
					people: subscriptions.People()
					themes: subscriptions.Themes()
	getInitialState: -> {}
	render: ->
		subs = this.type.subscriptions(@props)
		<div>
			<Header />
			<em>Edited in New York</em>
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
			<AddNode className="showIfUser" ref={subs.people.ref} attribute="name" />
			<ul>{
				@subs('people').map (person) -> 
					<li key={person.id}><a href="/people/#{person.id}">{person.name}</a></li>
			}</ul>
		</div>

module.exports = Component
