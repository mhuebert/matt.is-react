{Firebase, FIREBASE_URL} = require("../utils/firebase")
_ = require("underscore")

{snapshotToArray} = require("sparkboard-tools").utils
{firebaseSubscription} = require("sparkboard-tools")

@PhotoList = (limit=500) ->
  firebaseSubscription
    ref: new Firebase(FIREBASE_URL+'/photos')
    query: (ref, done) -> done(ref.limit(limit))
    server: true
    parse: (snapshot) -> 
        snapshotToArray(snapshot).reverse()
    default: _([])

@WritingList = (limit=50) ->
  firebaseSubscription
    ref: new Firebase(FIREBASE_URL+'/writing')
    query: (ref, done) -> done(ref.limit(limit))
    default: _([])
    server: true
    parse: (snapshot) -> 
        _.chain(snapshot.val()).pairs().map((pair) -> 
            post = pair[1]
            post.id = pair[0]
            post
        ).value().reverse()


    