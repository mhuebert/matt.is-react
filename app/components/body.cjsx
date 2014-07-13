# @cjsx React.DOM

React = require("react")
Nav = require("./widgets/nav")
DynamicLoader = require("./widgets/dynamicLoader")

Component = React.createClass
    render: ->
      this.transferPropsTo(<div className="content">
        <DynamicLoader />
        {this.props.children}
        </div>)

module.exports = Component
