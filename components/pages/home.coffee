`/** @jsx React.DOM */`

React = require("react")
Body = require("../body")
Nav = require("../partials/nav")
Writing = require("./writing")
Photography = require("./photography")

{SubscriptionMixin} = require("sparkboard-tools")
subscriptions = require("../../subscriptions")

Home = React.createClass
    mixins: [SubscriptionMixin]
    statics:
        subscriptions: ->
            photos: subscriptions.PhotoList(9)
            writing: subscriptions.WritingList(2)
        getMetadata: ->
            title: "Welcome | Matt.is"
            description: "Artefactually speaking."
    render: ->
        `<div>
            <Nav />
            <h1>Matthew Huebert</h1>
            <p className="intro">
              <span className="wordBlock">That's my name.</span> 
              <span className="wordBlock">I live in <a href="http://en.wikipedia.org/wiki/Reykjav%C3%ADk">Reykjavik.</a></span> 
              <span className="wordBlock">I'm building <a href="http://www.sparkboard.com">Sparkboard.</a></span>
            </p>
            <h1><a href="/writing">Writing</a></h1>
            <ul className="writing-list link-list" >
                {this.props.writing.map(function(post){return  <li key={post.id} ><a href={"/writing/"+post.id}>{post.title}</a></li>})}
                <li key="more"><a href="/writing" className="more-link" >more &rarr;</a></li>
            </ul>
            <h1><a href="/seeing">Photography</a></h1>
            <div className="photos">
                {this.props.photos.map(function(photo){return <a key={photo.id} href={"/seeing/"+photo.id}><img src={photo.url+"/convert?w=220&h=220&fit=crop"} /></a>})}
                <br/>
                <a key="more" href="/seeing" className="more-link" >more &rarr;</a>
            </div>
        </div>`

module.exports = Home
