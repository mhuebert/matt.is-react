# Example usage:

IndexServer = require("firebase-index-server")
{firebase} = require("../firebase") 
Firebase = require("firebase")
root = new Firebase("#{firebase}.firebaseIO.com")
root.auth(process.env.FIREBASE_SECRET)


_ = require("underscore")

server = IndexServer
  ref: root
  index:
    type: "tagIndex"
    sourcePath: "/posts/"
    sourceAttribute: "tags"
    indexPath: "/tags/"