`/** @jsx React.DOM */`

React = require("react")
Body = require("../body")
Writing = require("./writing")
Photography = require("./photography")

Home = React.createClass

    statics:
        getMetadata: ->
            title: "Welcome | Matt.is"
            description: "Artefactually speaking."

    render: ->
        `<Body>
            <h1>Matthew Huebert</h1>
            <p className="intro">
              <span className="wordBlock">That's my name.</span> 
              <span className="wordBlock">I live in <a>Reykjavik.</a></span> 
              <span className="wordBlock">I work on <a>Sparkboard.</a></span>
            </p>
            <Writing firebase={this.props.firebase} posts={this.props.posts} matchedRoute={this.props.matchedRoute} />
            <Photography firebase={this.props.firebase} photos={this.props.photos} matchedRoute={this.props.matchedRoute} style={{paddingTop:0}} />
        </Body>`

module.exports = Home
