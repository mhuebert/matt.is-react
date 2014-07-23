# @cjsx React.DOM

_ = require("underscore")
React = require("react")
Addons = require("react/addons")

{Firebase, FIREBASE_URL} = require("../../firebase")


{subscriptionByIndex} = require("firebase-subscriptions")
SubscriptionMixin = require("react-subscriptions").mixin

{Collection} = require("../../models")
{snapshotToArray, slugify} = require("sparkboard-tools").utils

Body = require("../widgets/body")
LinkList = require("../widgets/linkList")


{ownerId} = require("../../../config")

Component = React.createClass

    mixins: [SubscriptionMixin]

    statics:
        # Describe the data to supply to this component from Firebase.
        subscriptions: (props) ->
            # The data structure here will be mirrored in 'props',
            # so the following data will be found in 'props.ideas'.
            ideas: subscriptionByIndex
                indexRef: new Firebase(FIREBASE_URL+"/users/#{ownerId}/ideas")
                dataRef: new Firebase(FIREBASE_URL+"/posts")
                default: _([])
                parseObject: (snapshot) ->
                    post = snapshot.val()
                    post.id = snapshot.name()
                    post.priority = snapshot.getPriority()
                    post.href = "/ideas/"+post.id
                    post
                parseList: (list) ->
                    list.reverse()

        getMetadata: (props) ->
            title: "Ideas"
            description: "Wherein I uncover."
    handleChangeTitle: (e) ->
        this.setState
            title: e.target.value
            permalink: slugify(e.target.value)
    handleKeyup: (e) ->
        if e.which == 13
            indexRef = this.props.subscriptions.ideas.indexRef
            rootRef = indexRef.root()
            
            idea = 
                title: this.state.title
                owner: user.id
            ideaRef = this.props.subscriptions.ideas.dataRef.push() 
            ideaRef.setWithPriority idea, Date.now()

            # Create permalink
            rootRef.child("/permalinks/#{this.state.permalink}").set {owner: user.id, redirect: "/writing/#{ideaRef.name()}"}, (error) =>
                ideaRef.update permalink: this.state.permalink

            # Create reference in /user/ideas
            indexRef.child(ideaRef.name()).set(true)

            # Clear
            this.setState title: ""

    getInitialState: -> {}

    componentDidMount: ->
        this.refs.input.getDOMNode().focus()
        
    render: ->
        ideas = new Collection(this.props.ideas)
        <Body  breadcrumb={["ideas"]} className="ideas showIfUser">
            <h1>Ideas</h1>
            <input value={this.state.title} ref="input" className="ideas-input" onKeyUp={this.handleKeyup} onChange={this.handleChangeTitle} placeholder='Begin a new idea...' />
            <ul className="ideas link-list" >
                {ideas.map((link) -> 
                    <li key={link.get("id")}><a href={link.get("href")}>{link.get("title")}</a> <em className='wordCount'>{link.get("wordCount")}</em></li>
                )}
            </ul>
        </Body>

module.exports = Component
