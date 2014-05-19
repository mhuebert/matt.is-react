# Example usage:

IndexServer = require("firebase-index-server")
Firebase = require("firebase")
root = new Firebase(process.env.FIREBASE_URL)
root.auth(process.env.FIREBASE_SECRET)
{slugify} = require("sparkboard-tools").utils


_ = require("underscore")

server = IndexServer
  ref: root
  index:
    type: "tagIndex"
    sourcePath: "/posts/"
    sourceAttribute: "tags"
    indexPath: "/tags/"
    keyTransform: (key) -> slugify(key)