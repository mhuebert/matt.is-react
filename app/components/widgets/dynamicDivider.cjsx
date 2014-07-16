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
        top: 0

    componentDidMount: ->
        loader = this.refs.divider.getDOMNode()
        # rotation = between(-5, 5) #between(-10, 10)
        # loader.style["-webkit-transform"] = this.state.transform = this.state["-moz-transform"] = "rotate(#{rotation}deg)"
        # shape = ['rectangle', 'triangle', 'oval'][between(0,2)]
        # color = ['#fc3500', '#fff77f', '#00ffa8', '#ff00b4', '#00fcff'][between(0,4)]
        # _.extend loader.style, shapes['rectangle'](color)

        # loader.style.marginLeft = -(Math.round(loader.style.width/2))
        # loader.style.marginTop = -(Math.round(loader.style.height/2))
        # loader.style.left = "#{between(20, 80)}%"
        # loader.style.top = "#{between(0, 10)}px"

        styles = {}

        # rectangle
        # width = between(4,30)
        width = between(20,40)
        # height = between(14,30)
        height = between(10,17)
        color = ['#fc3500', '#fff77f', '#00ffa8', '#ff00b4', '#00fcff'][between(0,4)]
        rotation = between(-3, 3)
        styles.width = "#{width}%"
        styles.background = color
        styles.height = "#{height}px"
        styles.left = "#{(100-width)/2}%"
        styles.lineHeight = "#{height}px"
        # if Math.random()*100 < 50
        #     # triangle
        #     width = between(10, 30)
        #     rotation = between(0, 360)
        #     styles.width = 0
        #     styles.height = 0
        #     styles.borderBottom = "#{width}px solid #{color}"
        #     styles.borderLeft = "#{width}px solid transparent"
        #     styles.borderRight = "#{width}px solid transparent"
        #     styles.background = 'transparent'
        loader.style["-webkit-transform"] = this.state.transform = this.state["-moz-transform"] = "rotate(#{rotation}deg)"
        
        styles

        @setState styles

    render: ->
        @transferPropsTo <div className="dynamic-divider-container" >
            <div className="dynamic-divider" ref="divider" style={this.state}>
            </div>
        </div>

module.exports = Component
