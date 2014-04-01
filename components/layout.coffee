`/** @jsx React.DOM */`

React = require("react")
_ = require("underscore")

RouterMixin = require("../utils/router").Mixin

Head = require("./partials/head")
NotFound = require("./pages/notFound")

{FIREBASE_URL} = require("../utils/firebase")

Layout = React.createClass
    mixins: [RouterMixin]
    routes: require("./routes")
    firebaseRefCache: [ FIREBASE_URL+'/ideas',
                        FIREBASE_URL+'/writing'
                        ]
    _firebaseRefCache: []
    componentDidMount: ->
        setTimeout =>
            for url in @firebaseRefCache
                ref = new Firebase(url)
                @_firebaseRefCache.push(ref)
                ref.on "child_added", ->
        , 100
        window.auth = new FirebaseSimpleLogin new Firebase(FIREBASE_URL), (err, user) =>
            if err
                console.log "Error logging in"
            else if user 
                window.user = user
                @setProps user: user
            else
                @setProps user: null
    getHandler: ->
        this.props.matchedRoute?.handler || NotFound
    getMetadata: ->
        this.getHandler().getMetadata?(this.props) || {}
    getFirebaseData: ->
        this.getHandler().firebase?(this.props.matchedRoute) || {}
    login: ->
        auth.login('twitter')
    render: ->

        Handler = this.getHandler()
        metadata = this.getMetadata()
        firebaseData = this.getFirebaseData()

        `<html>
            <Head   title={metadata.title ? metadata.title : this.props.title}
                    description={metadata.description ? metadata.description : this.props.description} />
            <body className={this.props.user ? "loggedIn" : "loggedOut"}  onClick={this.handleClick}>
                {this.transferPropsTo(<Handler firebase={firebaseData} ref="handler" />)}
            </body>
        </html>`

module.exports = Layout
