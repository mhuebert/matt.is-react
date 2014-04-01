@Firebase = Firebase = window?.Firebase || require("firebase")

console.log @FIREBASE_URL = process.env.FIREBASE_URL || require("../config/config").FIREBASE_URL

if !window?
    console.log FIREBASE_SECRET = process.env.FIREBASE_SECRET
    firebase = new Firebase(@FIREBASE_URL)
    firebase.auth(FIREBASE_SECRET)
    console.log "authed to firebase"
    
getRootComponent = require("./index").getRootComponent

@FirebaseMixin =
    
    firebaseSubscribe: (props) ->
        owner = getRootComponent(this)
        @__firebaseSubscriptions = {}
        
        for path, obj of @type.firebase(props.matchedRoute)

            do (path, obj) =>
                query = obj.query || (ref, done) -> done(ref)

                query obj.ref, (queryRef) =>
                    # queryRef = query(obj.ref)

                    callback = (snapshot) =>
                        obj.parse = obj.parse || (snapshot) -> snapshot.val()
                        value = obj.parse(snapshot)

                        data = {}
                        data[path] = value || obj.default
                        owner.setProps data

                    @__firebaseSubscriptions[path] = 
                        ref: queryRef
                        callback: callback

                    queryRef.on "value", callback

    firebaseUnsubscribe: (props) ->
        for path of this.props.firebase
            {ref, callback} = @__firebaseSubscriptions[path]
            ref.off "value", callback
            delete @__firebaseSubscriptions[path]

    componentDidMount: ->
        @firebaseSubscribe(this.props)

    componentWillUnmount: ->
        @firebaseUnsubscribe(this.props)
    
    componentWillReceiveProps: (newProps) ->
        if newProps.matchedRoute.path != this.props.matchedRoute.path
            @firebaseUnsubscribe(newProps)
            @firebaseSubscribe(newProps)

    getDefaultProps: ->
        props = {}
        for path, obj of this.type.firebase(this.props.matchedRoute)
            props[path] = props[path] || obj.default 
        props

_ = require("underscore")
async = require("async")

@fetchFirebase = (manifest, fetchCallback) ->
    list = _.chain(manifest)
            .pairs()
            .map((pair)->
                if !pair[1].server
                    return false
                _.extend pair[1], path: pair[0])
            .value().filter(Boolean)
    # testQuery()
    getData = (obj, callback) ->
        obj.query = obj.query || (ref, done) -> done(ref)

        obj.query obj.ref, (queryRef) ->
            t = Date.now()
            queryRef.once "value", (snapshot) ->
                console.log "Firebase query finished in #{Date.now()-t}ms"
                data = {}
                obj.parse = obj.parse || (snapshot) -> snapshot.val()
                value = obj.parse(snapshot)
                data[obj.path] = value || obj.default
                callback(null, data)

    async.map list, getData, (err, data) ->
        object = {}
        for result in data
            _.extend object, result
        fetchCallback(object)

superagent = require("superagent")
testQuery = (url="www.apple.com")->
    t = Date.now()
    superagent.get url, (res) ->
        console.log "Got #{url} in #{Date.now()-t}ms"
@firebaseIdFromPath = (path) -> 
    path?.match(/\+(-.*)$/)?[1]
@snapshotToArray = (snapshot) ->
    elements = []
    snapshot.forEach (snap) ->
        element = snap.val()
        element.id = snap.name()
        elements.push element
        false
    elements
    

