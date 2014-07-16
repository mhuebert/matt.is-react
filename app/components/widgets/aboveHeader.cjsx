# @cjsx React.DOM

React = require("react")
Link = require("./link")

Component = React.createClass
    render: ->
        breadcrumb = @props.breadcrumb || []
        <div className="above-header">
          <div className="breadcrumb">
              
              <Link key={'home'} href={"/"}>Matt.is</Link>
              <Link href="/" className={"hidden last-update"+(if breadcrumb.length == 0 then "" else " hidden")}>
                Updated: 3 hours ago
              </Link>
              {
                breadcrumb.map (slug, index) ->
                  url = "/" + breadcrumb[0..index].join("/")
                  <Link key={slug} href={url}>{slug}</Link>
              }
          </div>
          <span className="right">Search</span>
          <div className="clear" />
        </div>

module.exports = Component
