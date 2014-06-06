`/** @jsx React.DOM */`

# Blank component to use as template

React = require("react")
Link = require("./link")
Dropdown = require("./dropdown")

Component = React.createClass
	render: ->
		breadcrumb = this.props.breadcrumb || []
		`this.transferPropsTo(<div className='nav-main'>
		    <div className="breadcrumb">
				<Link href="/">Matt.is</Link>
				{breadcrumb.map(function(slug){return <Link key={slug} href={"/"+slug}>{slug}</Link>})}
		  	</div>
		    <div className="right">
				{this.props.children}
				<Link href="/ideas" className="showIfUser btn btn-block">Ideas</Link>
				<Link href="/logout" className="btn btn-block showIfUser">Sign Out</Link>
				<Link href="/login" className="btn btn-block hideIfUser hidden">Sign In</Link>
			</div>
		</div>)`

module.exports = Component
