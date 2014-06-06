
@Firebase = Firebase = window?.Firebase || require("firebase")
@Firebase.goOffline()
@FIREBASE_URL = process.env.FIREBASE_URL || require("../config").FIREBASE_URL
# if !window?
#     firebase = new Firebase(@FIREBASE_URL)
#     # firebase.auth(process.env.FIREBASE_SECRET)
#     console.log "authed to firebase"