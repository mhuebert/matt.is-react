Matt.is
===

SEO-friendly blog using [Firebase](http://www.firebase.com) and [React](http://facebook.github.io/react/) using [sparkboard-tools](https://www.github.com/sparkboard/sparkboard-tools)

**Router**

A `Router` mix-in matches each path to a single `Handler` component.

Routes are defined like this:

```
routes =  [
    { path: "/",                 handler: Home },
    { path: "/writing",          handler: Writing },
    { path: "/writing/:id",      handler: WritingView },
    ...
    { path: "*",                 handler: NotFound }
]
```

A `Handler` component declares data dependencies in a manifest located in `statics.subscriptions()`. Data is synced into the root component's `props`.


```coffeescript
    Component = React.createClass
        mixins: [SubscriptionMixin]
        statics:
            subscriptions: (props) ->
                posts:
                    subscribe: ->
                    unsubscribe: ->
                    default: ->
                    shouldUpdateSubscription: (oldProps, newProps) ->
```

For convenience, we can define Firebase manifest: 

```coffeescript
    manifest = 
        ref: new Firebase(FIREBASE_URL+'/photos')
        query: (ref, done) -> done(ref.limit(10))
        server: true
        parse: (snapshot) -> snapshotToArray(snapshot).reverse()
        default: []
```

...and convert the Firebase manifest into a subscription object:

```
    subscription = firebaseSubscription(manifest)

```

**Javascript & Styles**

[Gulp](http://gulpjs.com/) & [Browserify](http://browserify.org/)

**React-Middleware**

Server-side rendering in `express`. We fetch Firebase data and supply it as props to our root component, `Layout`.

**Properties for `<head>`**

A `Handler` can specify metadata for the root `Layout` component in `statics/getMetaData()`:

    Component = React.createClass
        mixins: [FirebaseMixin]
        statics:
            getMetadata: ->
                title: "Welcome to Matt.is"
                description: "My great site."
