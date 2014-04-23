
@Firebase = Firebase = window?.Firebase || require("firebase")
@FIREBASE_URL = process.env.FIREBASE_URL || require("../config/config").FIREBASE_URL
@snapshotToArray = require("sparkboard-tools").utils.snapshotToArray

if !window?
    FIREBASE_SECRET = process.env.FIREBASE_SECRET
    firebase = new Firebase(@FIREBASE_URL)
    firebase.auth(FIREBASE_SECRET)
    console.log "authed to firebase"

@firebaseIdFromPath = (path) -> 
    path?.match(/\+(-.*)$/)?[1]

# superagent = require("superagent")
# testQuery = (url="www.apple.com")->
#     t = Date.now()
#     superagent.get url, (res) ->
#         console.log "Got #{url} in #{Date.now()-t}ms"

