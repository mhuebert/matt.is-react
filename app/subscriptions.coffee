{Firebase, FIREBASE_URL} = require("../app/firebase")
_ = require("underscore")

{snapshotToArray} = require("sparkboard-tools").utils
{firebaseSubscription, firebaseRelationalSubscription} = require("sparkboard-tools")

{ownerId} = require("../config")

@PhotoList = (limit=500) ->
  firebaseSubscription
    ref: new Firebase(FIREBASE_URL+'/photos')
    query: (ref, done) -> done(ref.limit(limit))
    server: true
    parse: (snapshot) -> 
        snapshotToArray(snapshot).reverse()
    default: _([])

@WritingList = (limit=50) ->
  firebaseRelationalSubscription
    indexRef: new Firebase(FIREBASE_URL+'/users/'+ownerId+'/writing').limit(limit)
    dataRef: new Firebase(FIREBASE_URL+'/posts')
    ref: new Firebase(FIREBASE_URL+'/writing')
    query: (ref, done) -> done(ref.limit(limit))
    default: _([])
    server: true
    parseObject: (snapshot) ->
        post = snapshot.val()
        post.id = snapshot.name()
        post
    parseList: (list) -> list.reverse()

    