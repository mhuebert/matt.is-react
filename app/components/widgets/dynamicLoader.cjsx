# @cjsx React.DOM

React = require("react")
_ = require("underscore")

between = (n1, n2) ->
  Math.floor Math.random()*(n2-n1)


shapes = 
  oval: (color) ->
    d1 = between(400,1200)
    d2 = Math.round d1/2

    background: color
    width: d1
    height: d2
    borderRadius: "#{Math.round(d1/2)}px #{Math.round(d2/2)}px"
  circle: (color)->
    diameter = between(100,800)

    width: diameter
    height: diameter
    borderRadius: diameter
    background: color
  rectangle: (color) ->

    skew = between(10,60)
    if between(0,1) == 0
      skew = 0

    transform: "skew(#{skew}deg)"
    width: "#{between(20,90)}%"
    height: "#{between(20,90)}%"
    background: color
  square: (color) ->
    width = between(250, 800)

    width: width
    height: width
    background: color
  triangle: (color) ->
    width: 0
    height: 0 
    borderBottom: "#{between(380,1100)}px solid #{color}" 
    borderLeft: "#{between(380,1100)}px solid transparent"
    borderRight: "#{between(380,1100)}px solid transparent"
  
  pacman: (color) ->

    diameter = between(60, 600)

    width: 0
    height: 0
    borderTop: "#{diameter}px solid #{color}"
    borderLeft: "#{diameter}px solid #{color}"
    borderBottom: "#{diameter}px solid #{color}"
    borderRight: "60px solid transparent"
    borderTopLeftRadius: diameter
    borderTopRightRadius: diameter
    borderBottomLeftRadius: diameter
    borderBottomRightRadius: diameter

Component = React.createClass
    getInitialState: -> 
        position: "absolute"
        width: 50
        height: 50
        left: "50%"
        marginLeft: -25
        top: "50%"
        marginTop: -25

    componentDidMount: ->
        loader = this.refs.loader.getDOMNode()
        rotation = between(0, 360)
        loader.style["-webkit-transform"] = this.state.transform = this.state["-moz-transform"] = "rotate(#{rotation}deg)"
        # loader.style.width = between(150,700)
        # loader.style.height = between(150,700)
        # shape = ['oval', 'square', 'rectangle', 'pacman'][between(0,3)]
        shape = ['rectangle'][between(0,3)]
        color = ['#fc3500', '#fff77f', '#00ffa8', '#ff00b4', '#00fcff'][between(0,4)]
        # color = '#ff0048'
        _.extend loader.style, shapes['rectangle'](color)
        loader.style.marginLeft = -(Math.round(loader.style.width/2))
        loader.style.marginTop = -(Math.round(loader.style.height/2))
        loader.style.left = "#{between(20, 80)}%"
        loader.style.top = "#{between(20, 80)}%"

    render: ->
        <div ref="loader" className="loader" style={this.state}>

        </div>

module.exports = Component
