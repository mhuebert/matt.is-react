{Firebase, FIREBASE_URL} = require("./firebase")
_ = require("underscore")

{snapshotToArray, getRootComponent} = require("sparkboard-tools").utils
{firebaseRelationalSubscription} = require("sparkboard-tools")

firebaseSubscription = require("./firebaseSubscription")

root = new Firebase(FIREBASE_URL)
async = require("async")

@Object = (path, options={}) ->
  firebaseSubscription
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
  firebaseSubscription
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
  firebaseSubscription
    ref: root.child("/settings")
    server: true
    default: {}
@PhotoList = (limit=500) ->
  firebaseSubscription
    ref: root.child('/photos')
    query: (ref, done) -> done(ref.limit(limit))
    server: true
    parse: (snapshot) -> 
        snapshotToArray(snapshot).reverse()
    default: _([])


@ElementsByIndex = (indexPath, options={limit:50,offset:0}) ->

  firebaseRelationalSubscription
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
  

  firebaseRelationalSubscription
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

setSubscriptionStateCallback = (owner, path, defaultData) ->
  (data) ->
    state = {}
    state[path] = data || defaultData
    owner.setState(state)

fetchOnce = (subscription) ->
  (callback) ->
    subscription.subscribe (data) ->
      subscription.unsubscribe()
      callback(null, data||subscription.default)


ReactAsync = require('react-async')

@AsyncSubscriptionMixin =
  mixins: [ReactAsync.Mixin]
  subs: (path) ->
    @state[path] || @constructor.subscriptions?(this.props)[path].default
  getInitialStateAsync: (cb) ->
    @__subscriptions = {}
    # state = {subscriptions: {}}
    # for path, subscription of this.constructor.subscriptions?(this.props)
    #   state[path] = state[path] || subscription.default 
    #   state.subscriptions[path] = {}
    tasks = {}
    subscriptions = @constructor.subscriptions?(this.props)
    for path, subscription of subscriptions
      @__subscriptions[path] = subscription
      tasks[path] = fetchOnce(subscription)
    async.parallel tasks, (err, results) ->
      cb(null, results)
  subscribe: (props) ->
    @__subscriptions = {}
    for path, subscription of @constructor.subscriptions?(props)
      do (path, subscription) =>
          subscription.subscribe setSubscriptionStateCallback(this, path, subscription.default)
          @__subscriptions[path] = subscription
  unsubscribe: ->
    for path, subscription of @__subscriptions
      subscription.unsubscribe()
      delete @__subscriptions[path]
  # stateToJSON: (state) ->
  #   if state.fireRef
  #     console.log 'packing'
  #     state.fireRef = state.fireRef.toString()
  #   state
  # stateFromJSON: (state) ->
  #   if state.fireRef
  #     state.fireRref = new Firebase(state.fireRef)
  #   state
  componentDidMount: ->
    @subscribe(this.props)
  componentWillUnmount: ->
    @unsubscribe()
  componentWillReceiveProps: (newProps) ->
    pathsToUpdate = []
    
    for path, subscription of @__subscriptions
      if subscription.shouldUpdateSubscription?(this.props, newProps)
        pathsToUpdate.push(path)
    
    if pathsToUpdate.length > 0
      # Without this timeout, we were setting new props before these props
      # could be applied, which resulted in errors (parentNode undefined, etc.)
      # setTimeout =>
      newSubscriptions = @type.subscriptions(newProps)
      for path in pathsToUpdate
        @__subscriptions[path].unsubscribe()
        @__subscriptions[path] = newSubscriptions[path]
        @__subscriptions[path].subscribe setSubscriptionStateCallback(this, path)
      # , 50