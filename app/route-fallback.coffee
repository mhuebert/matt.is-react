{Firebase, FIREBASE_URL} = require("./firebase")
routes = require("./routes")
Router = require("sparkboard-tools").Router.create(routes)

module.exports = (path, callback) ->
  refPath = FIREBASE_URL+"/permalinks#{path}"
  ref = new Firebase(refPath)
  ref.once "value", (snap) ->
    redirect = snap.val()?.redirect
    if redirect and (matchedRoute = Router.matchStaticRoute(redirect))
      callback(matchedRoute)
      return
    callback
      path: path
      handler: "NotFound"
