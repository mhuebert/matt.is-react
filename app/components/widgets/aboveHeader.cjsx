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
                  if typeof slug == 'object'
                    url = "/"+slug[0]
                    slug = slug[1]
                  else
                    url = "/" + breadcrumb[0..index].join("/")
                  <Link key={index} href={url}>{slug}</Link>
              }
          </div>
          <span className="right hidden">Search</span>
          <div className="clear" />
        </div>

module.exports = Component
