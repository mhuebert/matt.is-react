# Example usage:

IndexServer = require("firebase-index-server")
Firebase = require("firebase")
root = new Firebase(process.env.FIREBASE_URL)
root.auth(process.env.FIREBASE_SECRET)
{slugify} = require("sparkboard-tools").utils


_ = require("underscore")

server = IndexServer
  ref: root
  indexes:[
    type: "oneToOne"
    sourcePath: "/elements/"
    sourceAttribute: "type"
    indexPath: "/types/"
    priority: (snap) -> snap.child("date").val()
  ,
    type: "manyToMany"
    sourcePath: "/elements/"
    sourceAttribute: "topics"
    indexPath: "/related/topics/"
    keyTransform: (key) -> slugify(key)
    priority: (snap) -> snap.child("date").val()
  ,
    type: "manyToMany"
    sourcePath: "/elements/"
    sourceAttribute: "people"
    indexPath: "/related/people/"
    priority: (snap) -> snap.child("date").val()
  , 
    type: "derivedPriority"
    sourcePath: "/elements"
    priority: (snap) -> snap.child("date").val()
  ,
    type: "permalink"
    sourcePath: "/elements"
    sourceAttribute: "permalink"
    indexPath: "/permalinks"
    getRedirect: (snap) -> "/#{snap.child('type').val()}/#{snap.name()}"
  ]