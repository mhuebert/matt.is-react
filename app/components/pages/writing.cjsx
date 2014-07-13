# @cjsx React.DOM

_ = require("underscore")
React = require("react")
Body = require("../widgets/body")
ContentFilter = require("../widgets/contentFilter")
Link = require("../widgets/link")

subscriptions = require("../../subscriptions")
{AsyncSubscriptionMixin} = subscriptions

Component = React.createClass

    mixins: [AsyncSubscriptionMixin]

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
        writing = @state.writing || []
        switch tag = this.props.matchedRoute.params.tag 
            when undefined
                title = "Writing"
                breadcrumb = ['writing']
            else
                title = "#"+tag
                breadcrumb = ['tags', tag]

        componentList = {
            link: Link
            a: React.DOM.a
        }

        <Body sidebar={true} breadcrumb={['writing']}>
            <ContentFilter />
            <div className="inner-content">
                <ul className="link-list">
                    {
                        @subs('writing').map( (post) ->
                            <li key={post.id} >
                                {componentList["a"]({href:"/"+post.permalink}, post.title)} 
                                <a href={"/"+post.permalink}>{post.title}</a>
                                
                            </li>
                        )
                    }
                </ul>
            </div>
        </Body>

module.exports = Component
