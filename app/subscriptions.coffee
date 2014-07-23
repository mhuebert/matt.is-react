{Firebase, FIREBASE_URL} = require("./firebase")
_ = require("underscore")

{snapshotToArray, getRootComponent} = require("sparkboard-tools").utils
{subscriptionByIndex, subscription} = require("firebase-subscriptions")

root = new Firebase(FIREBASE_URL)

@Object = (path, options={}) ->
  subscription
    ref: root.child(path)
    server: true
    default: {}
    parse: (snapshot) ->
      obj = snapshot?.val()
      if obj
        obj.id = snapshot.name()
        obj.priority = snapshot.getPriority()
      obj
@List = (path, options={}) ->
  subscription
    ref: root.child(path)
    server: true
    query: (ref, done) -> 
      if options.limit
        done(ref.limit(options.limit))
      else
        done(ref)
    parse: (snapshot) -> 
        list = snapshotToArray(snapshot)
        switch options.sort
            when "reverse"
                list = list.reverse()
            when "a-z"
                list = list.sort()
        list

    default: []


@Settings = ->
  subscription
    ref: root.child("/settings")
    server: true
    default: {}
@PhotoList = (limit=500) ->
  subscription
    ref: root.child('/photos')
    query: (ref, done) -> done(ref.limit(limit))
    server: true
    parse: (snapshot) -> 
        snapshotToArray(snapshot).reverse()
    default: _([])


@ElementsByIndex = (indexPath, options={limit:50,offset:0}) ->

  subscriptionByIndex
    indexRef: root.child(indexPath).limit(options.limit)
    dataRef: root.child('/elements')
    default: []
    server: true
    parseObject: (snapshot) ->
        post = snapshot.val()
        post.id = snapshot.name()
        post
    parseList: (list) -> 
        switch options.sort
            when "reverse"
                list = list.reverse()
            when "a-z"
                list = list.sort()
            else
                list = list.reverse()
        list


@WritingList = (limit=50, indexPath) ->

  # Either load tagged posts or this user's posts, depending on the params
  # we've received in the url.
  

  subscriptionByIndex
    indexRef: root.child(indexPath).limit(limit)
    dataRef: root.child('/posts')
    shouldUpdateSubscription: (oldProps, newProps) ->
      oldProps.settings.ownerId != newProps.settings.ownerId
    query: (ref, done) -> done(ref.limit(limit))
    default: []
    server: true
    parseObject: (snapshot) ->
        post = snapshot.val()
        post.id = snapshot.name()
        post
    parseList: (list) -> list.reverse()


@AsyncSubscriptionMixin = require("react-subscriptions").mixin