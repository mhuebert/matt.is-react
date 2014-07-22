
between = (n1, n2) ->
  Math.floor (Math.random()*(n2-n1))+n1

randomStyle = @randomStyle = ->
  styles = {}

  color = ['#fc3500', '#fff77f', '#00ffa8', '#ff00b4', '#00fcff'][between(0,4)]
  rotation = between(-30, 30)/10
  styles.background = color
  transform = "rotate(#{rotation}deg)"
  styles.transform = transform
  styles.WebkitTransform = transform
  styles.msTransform = transform
  styles.display = "inline-block"
  styles.padding = "10px 15px"
  styles.marginTop = -50
  styles

@Mixin = 
  componentDidMount: ->
    @setState titleStyle: randomStyle()
