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
    type: "oneToMany"
    sourcePath: "/elements/"
    sourceAttribute: "topics"
    indexPath: "/related/topics/"
    priority: (snap) -> snap.child("date").val()
  ,
    type: "oneToMany"
    sourcePath: "/elements/"
    sourceAttribute: "people"
    indexPath: "/related/people/"
    priority: (snap) -> snap.child("date").val()

  ]