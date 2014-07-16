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
    type: "oneToMany"
    sourcePath: "/elements/"
    sourceAttribute: "people"
    indexPath: "/people/"
    keyTransform: (key) -> slugify(key)
  ,
    type: "oneToOne"
    sourcePath: "/elements/"
    sourceAttribute: "type"
    indexPath: "/types/"
    priority: (snap) -> snap.child("date").val()
  ,
    type: "oneToMany"
    sourcePath: "/elements/"
    sourceAttribute: "topics"
    indexPath: "/topics/"
    keyTransform: (key) -> types[key] || key
    priority: (snap) -> snap.child("date").val()

  ]