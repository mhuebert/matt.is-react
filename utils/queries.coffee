{Firebase, FirebaseMixin, snapshotToArray, FIREBASE_URL} = require("./firebase")

@PhotoList = 
  ref: new Firebase(FIREBASE_URL+'/test1/photos')
  query: (ref, done) -> done(ref.limit(50))
  server: true
  parse: (snapshot) -> snapshotToArray(snapshot).reverse()
  default: []

@WritingList = 
  ref: new Firebase(FIREBASE_URL+'/test1/writing')
  query: (ref, done) -> done(ref.limit(50))
  parse: (snapshot) -> 
      _.chain(snapshot.val()).pairs().map((pair) -> 
          post = pair[1]
          post.id = pair[0]
          post
      ).value().reverse()
  default: []