{Firebase, FIREBASE_URL} = require("./firebase")
_ = require("underscore")

{snapshotToArray, getRootComponent} = require("sparkboard-tools").utils
{firebaseRelationalSubscription} = require("sparkboard-tools")

firebaseSubscription = require("./firebaseSubscription")

root = new Firebase(FIREBASE_URL)
async = require("async")

@List = (path) ->
  firebaseSubscription
    ref: root.child(path)
    server: true
    parse: (snapshot) -> snapshotToArray(snapshot).reverse()
    default: []
@Themes = ->
  firebaseSubscription
    ref: root.child("/themes")
    server: true
    parse: (snapshot) -> snapshotToArray(snapshot).sort()
    default: []
@People = ->
  firebaseSubscription
    ref: root.child("/people")
    server: true
    parse: (snapshot) -> snapshotToArray(snapshot).sort()
    default: []
@Tags = ->
  firebaseSubscription
    ref: root.child("/tags")
    server: true
    parse: (snapshot) -> snapshotToArray(snapshot).sort()
    default: _([])

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
    @state[path] || this.type.subscriptions?(this.props)[path].default
  getInitialStateAsync: (cb) ->
    @__subscriptions = {}
    # state = {subscriptions: {}}
    # for path, subscription of this.type.subscriptions?(this.props)
    #   state[path] = state[path] || subscription.default 
    #   state.subscriptions[path] = {}
    tasks = {}
    subscriptions = this.type.subscriptions?(this.props)
    for path, subscription of subscriptions
      @__subscriptions[path] = subscription
      tasks[path] = fetchOnce(subscription)
    async.parallel tasks, (err, results) ->
      cb(null, results)
  subscribe: (props) ->
    owner = getRootComponent(this)
    @__subscriptions = {}
    for path, subscription of @type.subscriptions?(props)
      do (path, subscription) =>
          subscription.subscribe setSubscriptionStateCallback(this, path, subscription.default)
          @__subscriptions[path] = subscription
  unsubscribe: ->
    for path, subscription of @__subscriptions
      subscription.unsubscribe()
      delete @__subscriptions[path]
  componentDidMount: ->
    @subscribe(this.props)
  componentWillUnmount: ->
    @unsubscribe()
  componentWillReceiveProps: (newProps) ->
    owner = getRootComponent(this)
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
        @__subscriptions[path].subscribe setSubscriptionStateCallback(owner, path)
      # , 50