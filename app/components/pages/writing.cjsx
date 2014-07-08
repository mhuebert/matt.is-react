# @cjsx React.DOM

_ = require("underscore")
React = require("react")

Body = require("../body")


{SubscriptionMixin} = require("sparkboard-tools")
subscriptions = require("../../subscriptions")

Component = React.createClass

    mixins: [SubscriptionMixin]

    statics:
        getMetadata: ->
            title: "Writing | Matt.is"
            description: "Wherein I uncover."
        subscriptions: (props) ->
            indexPath = switch (tag = props.matchedRoute.params.tag)
                when undefined
                    '/users/'+props.settings.ownerId+'/writing' 
                else
                    '/tags/'+tag
            writing: subscriptions.WritingList(50, indexPath)

    render: ->
        
        switch tag = this.props.matchedRoute.params.tag 
            when undefined
                title = "Writing"
                breadcrumb = ['writing']
            else
                title = "#"+tag
                breadcrumb = ['tags', tag]

        this.transferPropsTo(<Body breadcrumb={breadcrumb} className={"content "+ (if (this.props.writing.length > 0) then "" else "loading")}>
            <h1>{title}</h1>
            <ul className="link-list">
                {
                    this.props.writing.map( (post) ->
                        <li key={post.id} >
                            <a href={"/"+post.permalink}>{post.title}</a>
                        </li>
                    )
                }
            </ul>
        </Body>)

module.exports = Component
