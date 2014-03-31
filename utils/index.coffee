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