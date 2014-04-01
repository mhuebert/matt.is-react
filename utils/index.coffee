@safeStringify = (obj) ->
    JSON.stringify(obj).replace(/<\/script/g, '<\\/script').replace(/<!--/g, '<\\!--')

@slugify = (string) -> 
  string = string || ""
  string = string.toLowerCase()
  string.replace(/[\s-]+/g, "-").replace(/[^\w-]*/g, "")

@getRootComponent = (component) ->
  while component._owner
      component = component._owner
  component

@fullScreen = ->
  fullscreenEnabled = document.fullscreenEnabled || document.mozFullScreenEnabled || document.documentElement.webkitRequestFullScreen

  (element) ->
      if (element.requestFullscreen) 
          element.requestFullscreen()
      else if (element.mozRequestFullScreen) 
          element.mozRequestFullScreen()
      else if (element.webkitRequestFullScreen) 
          element.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT)


if window?
  window.fullScreen = @fullScreen