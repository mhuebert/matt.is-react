# @cjsx React.DOM

React = require("react")
AddNode = require("./addNode")
Link = require("./link")
Header = require("./header")

subscriptions = require("../../subscriptions")
{AsyncSubscriptionMixin} = subscriptions
_ = require("underscore")

Component = React.createClass
	mixins: [AsyncSubscriptionMixin]
	statics:
			subscriptions: (props) ->
					# people: subscriptions.List("/people", sort: "a-z")
					people: subscriptions.ElementsByIndex("/types/person")
					topics: subscriptions.List("/topics", sort: "a-z")
					settings: subscriptions.Object("/settings")
	getInitialState: -> {}
	render: ->
		subs = @constructor.subscriptions(@props)
		people = _.filter @subs('people'), (person) -> person.status != 'idea'

		<div>
			<Header />
			<em>Edited in {@subs("settings").location}</em>
			<div style={{marginTop: 13}} className="showIfUser">
				<Link className="btn btn-white btn-block" href="/new" >New</Link>
				<Link href="/ideas" >Ideas</Link> • 
				<Link href="/settings" >Settings</Link> • 
				<Link href="/logout" >Sign Out</Link>
			</div>
			<h3><a href="/topics/">Topics »</a></h3>
			<ul>{
				@subs('topics').map (topic) -> 
					<li key={topic.id}><a href="/topics/#{topic.id}">{topic.val}</a></li>
			}</ul>
			<h3 className="hidden"><a href="/people/">People »</a></h3>
			<ul>{
				people.map (person) -> 
					<li key={person.id}><a href="/person/#{person.id}">{person.title}</a></li>
			}</ul>
		</div>

module.exports = Component
