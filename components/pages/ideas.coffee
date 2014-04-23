`/** @jsx React.DOM */`

_ = require("underscore")
React = require("react")
Addons = require("react-addons")

{Firebase, FIREBASE_URL} = require("../../utils/firebase")

{SubscriptionMixin, firebaseSubscription} = require("sparkboard-tools")
{Collection} = require("../../models")

Body = require("../body")
LinkList = require("../partials/linkList")
slugify = require("../../utils").slugify

Component = React.createClass

    mixins: [SubscriptionMixin]

    statics:
        # Describe the data to supply to this component from Firebase.
        subscriptions: ->
            # The data structure here will be mirrored in 'props',
            # so the following data will be found in 'props.ideas'.
            ideas: firebaseSubscription
                ref: new Firebase(FIREBASE_URL+'/ideas')
                query: (ref, done) -> done(ref.limit(50))
                server: true
                parse: (snapshot) -> 
                    _.chain(snapshot.val())
                        .pairs()
                        .map((pair) -> 
                            idea = pair[1]
                            idea.id = pair[0]
                            idea.href = "/ideas/"+slugify(idea.title)+"+"+idea.id
                            idea
                        )
                        .reverse().value()

        getMetadata: (props) ->
            title: "Ideas"
            description: "Wherein I uncover."
    handleChangeTitle: (e) ->
        this.setState
            title: e.target.value
            slug: slugify(e.target.value)
    handleKeyup: (e) ->
        if e.which == 13
            this.state.userid = user.id
            idea = this.props.subscriptions.ideas.ref.push this.state
            idea.setPriority Date.now()
            this.setState title: ""

    getInitialState: -> {}

    componentDidMount: ->
        this.refs.input.getDOMNode().focus()
        
    render: ->
        ideas = new Collection(this.props.ideas)
        `<Body className="ideas showIfUser">
            <h1>Ideas</h1>
            <input value={this.state.title} ref="input" className="ideas-input" onKeyUp={this.handleKeyup} onChange={this.handleChangeTitle} placeholder='Begin a new idea...' />
            <ul className="ideas link-list" >
                {ideas.map(function(link){
                    return <li key={link.get("id")}><a href={link.get("href")}>{link.get("title")}</a> <em className='wordCount'>{link.get("wordCount")}</em></li>
                })}
            </ul>
        </Body>`

module.exports = Component
