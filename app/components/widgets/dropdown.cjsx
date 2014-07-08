# @cjsx React.DOM

React = require("react")
_ = require("underscore")
Addons = require("react/addons")
{getRootComponent} = require("sparkboard-tools").utils


Component = React.createClass
    getInitialState: -> 
      active: false
    show: -> 
      this.setState active: true
      window.addEventListener('click', this.hide)
    hide: -> 
      this.setState active: false
      window.removeEventListener('click', this.hide)
    componentWillUnmount: ->
      window.removeEventListener('click', this.hide)
    toggle: (e) ->
        e.preventDefault()
        e.stopPropagation()
        if this.state.active
          this.hide()
        else
          this.show()

    render: ->
        currentPath = window?.location.pathname || getRootComponent(this).props.path
        
        currentLink = <a>{this.props.label}</a>

        if this.props.replaceWithSelectedLink
          exactMatch = false
          React.Children.forEach this.props.children.props.children, (child) ->
            link = child.props.children
            if currentPath == link.props.href
              currentLink = link
              exactMatch = true
            if exactMatch == false and currentPath.indexOf(link.props.href) == 0
              currentLink = link  
        
        currentLinkStyle = currentLink.props.selectedStyle?.style || {}

        this.transferPropsTo(
          <div  className={"dropdown "+(if this.state.active then "active" else "")}
                onMouseEnter={this.show}
                onMouseLeave={this.hide}>
            <a  
                className="selectedDropdownLink" 
                href={currentLink.props.href} 
                style={currentLinkStyle}>
                {currentLink.props.children}
            </a>
            <div onClick={this.toggle} className="caret" />

            {this.props.children}
        </div>
        )

module.exports = Component
