# @cjsx React.DOM

React = require("react")
Link = require("./link")
{getRootComponent} = require("sparkboard-tools").utils
getPath = ->
	window?.location.pathname || getRootComponent(this).props.path

{complementary, darken} = require("../../colors")

Component = React.createClass
	componentDidMount: ->
			@setState borderColor: accentColor
	getInitialState: -> {}
	render: ->
		links = [ 
			['All', '/'], 
			['Quotes', '/quotes'], 
			['Images', '/images'], 
			['Playlists', '/playlists'],
			['Links', '/links'],
			['Books', '/books'],
			['Writing', '/writing']
		]

		@transferPropsTo <ul className="content-filter">
			{
				links.map (link) => (
					<li key={link[1]} >
						<Link style={{borderColor:(darken(complementary(@state.borderColor||"#000000"), 0))}} href={link[1]}>{link[0]}</Link>
					</li>            
				)  
			}  
			
		</ul>

module.exports = Component
