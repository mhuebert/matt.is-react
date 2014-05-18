# Example usage:

IndexServer = require("firebase-index-server")
{FIREBASE_URL} = require("../firebase") 

_ = require("underscore")

server = IndexServer
  FIREBASE_URL: FIREBASE_URL
  index:
    type: "tagIndex"
    sourcePath: "/posts/"
    sourceAttribute: "tags"
    indexPath: "/tags/"