# @cjsx React.DOM

React = require("react")
_ = require("underscore")

between = (n1, n2) ->
  Math.floor (Math.random()*(n2-n1))+n1

Component = React.createClass
    getInitialState: -> 
        position: "absolute"
        width: 30
        height: 30
        left: "50%"
        top: 9

    componentDidMount: ->
        loader = this.refs.divider.getDOMNode()
        styles = {}

        width = between(25,110)
        height = between(10,17)
        color = ['#fc3500', '#fff77f', '#00ffa8', '#ff00b4', '#00fcff'][between(0,4)]
        rotation = between(5, 20)/10
        if Math.random() < 0.5
            rotation = -rotation
        styles.width = "#{width}%"
        styles.background = color
        styles.height = "#{height}px"
        styles.left = "#{(100-width)/2}%"
        styles.lineHeight = "#{height}px"
        loader.style["-webkit-transform"] = this.state.transform = this.state["-moz-transform"] = "rotate(#{rotation}deg)"
        
        styles

        @setState styles

    render: ->
        @transferPropsTo <div className="dynamic-divider-container" >
            <div className="dynamic-divider" ref="divider" style={this.state}>
            </div>
        </div>

module.exports = Component
