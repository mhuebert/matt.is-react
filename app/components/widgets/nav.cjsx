# @cjsx React.DOM

React = require("react")
Link = require("./link")
Dropdown = require("./dropdown")

Component = React.createClass
	render: ->

		this.transferPropsTo <div className='nav-main'>
				<div className="right">{this.props.children}
					<Link href="/ideas" className="showIfUser btn btn-block">Ideas</Link>
					<Link href="/logout" className="btn btn-block showIfUser">Sign Out</Link>
					<Link href="/login" className="btn btn-block hideIfUser">Sign In</Link>
				</div>
	  	</div>
		
		
module.exports = Component
