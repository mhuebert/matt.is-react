@safeStringify = (obj) ->
    obj = obj.toJSON?() || obj
    JSON.stringify(obj).replace(/<\/script/g, '<\\/script').replace(/<!--/g, '<\\!--')

@slugify = (string) -> 
  string = string || ""
  string = string.toLowerCase()
  string.replace(/[\s-]+/g, "-").replace(/[^\w-]*/g, "")

