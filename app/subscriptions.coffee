{Firebase, FIREBASE_URL} = require("../app/firebase")
_ = require("underscore")

{snapshotToArray} = require("sparkboard-tools").utils
{firebaseSubscription, firebaseRelationalSubscription} = require("sparkboard-tools")

{ownerId} = require("../config")

root = new Firebase(FIREBASE_URL)

@Tags = ->
  firebaseSubscription
    ref: root.child("/tags")
    server: true
    parse: (snapshot) -> snapshotToArray(snapshot).sort()
    default: _([])

@PhotoList = (limit=500) ->
  firebaseSubscription
    ref: root.child('/photos')
    query: (ref, done) -> done(ref.limit(limit))
    server: true
    parse: (snapshot) -> 
        snapshotToArray(snapshot).reverse()
    default: _([])

@WritingList = (limit=50, indexPath) ->

  # Either load tagged posts or this user's posts, depending on the params
  # we've received in the url.
  

  firebaseRelationalSubscription
    indexRef: root.child(indexPath).limit(limit)
    dataRef: root.child('/posts')
    ref: root.child('/writing')
    shouldUpdateSubscription: (oldProps, newProps) ->
      oldProps.settings.ownerId != newProps.settings.ownerId
    query: (ref, done) -> done(ref.limit(limit))
    default: _([])
    server: true
    parseObject: (snapshot) ->
        post = snapshot.val()
        post.id = snapshot.name()
        post
    parseList: (list) -> list.reverse()

    