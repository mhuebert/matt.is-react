# Example usage:

IndexServer = require("firebase-index-server")
Firebase = require("firebase")
root = new Firebase(process.env.FIREBASE_URL)
root.auth(process.env.FIREBASE_SECRET)
{slugify} = require("sparkboard-tools").utils


_ = require("underscore")

types = 
  book: "books"
  link: "links"
  person: "people"
  image: "images"
  gallery: "galleries"
  video: "videos"
  playlist: "playlists"
  text: "writing"

server = IndexServer
  ref: root
  index:
    type: "tagIndex"
    sourcePath: "/posts/"
    sourceAttribute: "tags"
    indexPath: "/tags/"
    keyTransform: (key) -> slugify(key)
  indexes:[
    type: "oneToMany"
    sourcePath: "/posts/"
    sourceAttribute: "tags"
    indexPath: "/tags/"
    keyTransform: (key) -> slugify(key)
  ,
    type: "oneToOne"
    sourcePath: "/posts/"
    sourceAttribute: "type"
    indexPath: "/types/"
    keyTransform: (key) -> types[key] || key
    priority: (snap) -> snap.child("date").val()

  ]