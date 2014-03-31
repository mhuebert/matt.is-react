`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")

Body = require("../body")
Firebase = require("../../utils/firebase").Firebase
FirebaseMixin = require("../../utils/firebase").FirebaseMixin
FIREBASE_URL = require("../../config").firebaseUrl
Component = React.createClass

    mixins: [FirebaseMixin]

    getInitialState: -> {}

    statics:
        getMetadata: ->
            title: "Writing | Matt.is"
            description: "Wherein I uncover."
        firebase: ->
            posts:
                ref: new Firebase(FIREBASE_URL+'/test1/writing')
                query: (ref, done) -> done(ref.limit(50))
                parse: (snapshot) -> 
                    _.chain(snapshot.val()).pairs().map((pair) -> 
                        post = pair[1]
                        post.id = pair[0]
                        post
                    ).value().reverse()
                default: []

    render: ->

        `this.transferPropsTo(<Body className={"content "+ ((this.props.posts.length > 0) ? "" : "loading")}>
            <h1>Writing</h1>
            <ul className="messages link-list">
                {
                    this.props.posts.map(function(obj){
                        return <li key={obj.id} >
                                <a href={"/writing/"+obj.id}>{obj.title}</a>
                                </li>
                        })
                }
            </ul>

        </Body>)`

module.exports = Component
