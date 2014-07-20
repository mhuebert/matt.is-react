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
			['Feed', '/']
			['Text', '/type/text']
			['Images', '/type/image']
			['Videos', '/type/video']
			['Links', '/type/link']
			['Books', '/type/book']
			['People', '/type/person']
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
