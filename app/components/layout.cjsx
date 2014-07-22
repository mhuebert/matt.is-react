# @cjsx React.DOM

React = require("react")
_ = require("underscore")
RouterMixin = require("react-router").Mixin
Head = require("./widgets/head")
{FIREBASE_URL} = require("../firebase")
{AsyncSubscriptionMixin} = require("../subscriptions")


components = require("./index")

between = (n1, n2) ->
  Math.floor Math.random()*(n2-n1)
setAccentColor = ->
  window.accentColor = ['#fc3500', '#fff77f', '#00ffa8', '#ff00b4', '#00fcff'][between(0,4)]

Layout = React.createClass
    mixins: [RouterMixin]
    routes: require("../routes")
    fallbackRoute: require("../route-fallback")
    firebaseRefCache: ['topics', 'people', 'settings', 'elements'] # [ FIREBASE_URL+'/ideas', FIREBASE_URL+'/writing' ]
    _firebaseRefCache: []
    componentWillMount: ->
        if window?
            setAccentColor()
        if window? and !window.auth
            window.auth = new FirebaseSimpleLogin new Firebase(FIREBASE_URL), (err, user) =>
                if err
                    console.log "Error logging in"
                else if user 
                    window.user = user
                    @setProps user: user
                else
                    @setProps user: null
    componentDidMount: ->
        setTimeout =>
            for url in @firebaseRefCache
                do (url) =>
                    ref = new Firebase(FIREBASE_URL+"/"+url)
                    @_firebaseRefCache.push(ref)
                    ref.on "child_added", ->
        , 100
        
    getHandler: ->
        components[this.props.matchedRoute.handler]
    getMetadata: ->
        this.getHandler().getMetadata?(this.props) || {}

    getSubscriptionData: ->
        this.getHandler().subscriptions?(this.props) || {}
    login: ->
        auth.login('twitter')

    render: ->
        Handler = this.getHandler()
        metadata = this.getMetadata()
        subscriptionData = this.getSubscriptionData()

        <html>
            <Head   title={metadata.title || this.props.title}
                    description={metadata.description || this.props.description} />
            <body className={if this.props.user then "loggedIn" else "loggedOut"}  onClick={this.handleClick}>
                {this.transferPropsTo(<Handler subscriptions={subscriptionData} ref="handler" />)}

            </body>
        </html>

module.exports = Layout
