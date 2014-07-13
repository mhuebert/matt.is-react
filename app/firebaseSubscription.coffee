###

  Turn a firebase manifest into a subscription object.

  Example of a firebase manifest:

    ref: new Firebase(FIREBASE_URL+"/posts/"+id)
    default: {}
    parse: (snapshot) ->
        # modify the snapshot before setting into props
        post = snapshot.val()
        post.date = snapshot.getPriority() if post
        post.id = snapshot.name() if post
        post                    
    shouldUpdateSubscription: (oldProps, newProps) ->
        # a subscription can depend on the component's props.
        # when props change, we can optionally re-initialize
        # a subscription.
        oldProps.matchedRoute.params.id != newProps.matchedRoute.params.id


  Example of a subscription object:

  subscription = 
    subscribe: (callback) ->
      # whenever data changes, runs callback(data)
    unsubscribe: ->
      # cleans up

###

module.exports = (manifest) ->
  manifest.subscribe = (setData) ->
    manifest.query = manifest.query || (ref, cb) -> cb(ref)
    manifest.query manifest.ref, (ref) =>
      if ref == null
        manifest.inactive = true
        setData(manifest.default)
        return
      manifest.queryRef = ref
      updateObject = (snapshot) ->
        parse = manifest.parse || (snapshot) -> snapshot.val()
        value = parse(snapshot)
        setData(value)
      cancelUpdateObject = ->
        setData(manifest.default)
        
      ref.on "value", updateObject, cancelUpdateObject
  manifest.unsubscribe = ->
    if manifest.inactive != true
      manifest.queryRef?.off "value", manifest.__callback
  manifest

firebaseSyncedList = (manifest) ->
  list = []
  manifest.subscribe = (setData) ->
    manifest.query = manifest.query || (ref, cb) -> cb(ref)
    manifest.query manifest.ref, (ref) =>
      if ref == null
        manifest.inactive = true
        setData(manifest.default)
        return
      manifest.queryRef = ref

      updateObject = (snapshot) ->
        parse = manifest.parse || (snapshot) -> snapshot.val()
        value = parse(snapshot)
        setData(value)
      cancelUpdateObject = ->
        setData(manifest.default)
      # ref.on "value", updateObject, cancelUpdateObject

      ref.on "child_added", _add = (snap, prevChild) ->
        data = snap.val()
        data.$id = snap.name() # assumes data is always an object
        data.$priority = snap.getPriority()
        pos = positionAfter(list, prevChild)
        list.splice pos, 0, data
        setData(list)

      ref.on "child_removed", _remove = (snap) ->
        i = positionFor(list, snap.name())
        list.splice i, 1  if i > -1
        setData(list)

      ref.on "child_changed", _change = (snap) ->
        i = positionFor(list, snap.name())
        if i > -1
          list[i] = snap.val()
          list[i].$id = snap.name() # assumes data is always an object
        setData(list)

      ref.on "child_moved", _move = (snap, prevChild) ->
        curPos = positionFor(list, snap.name())
        if curPos > -1
          data = list.splice(curPos, 1)[0]
          newPos = positionAfter(list, prevChild)
          list.splice newPos, 0, data
        setData(list)

  manifest.unsubscribe = ->
      if manifest.inactive != true
        manifest.queryRef?.off() # "value", manifest.__callback
  manifest


# similar to indexOf, but uses id to find element
positionFor = (list, key) ->
  i = 0
  len = list.length

  while i < len
    return i  if list[i].$id is key
    i++
  -1

# using the Firebase API's prevChild behavior, we
# place each element in the list after it's prev
# sibling or, if prevChild is null, at the beginning
positionAfter = (list, prevChild) ->
  if prevChild is null
    0
  else
    i = positionFor(list, prevChild)
    if i is -1
      list.length
    else
      i + 1