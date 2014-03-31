Matt.is
===

SEO-friendly blog using [Firebase](http://www.firebase.com) and [React](http://facebook.github.io/react/).


**Router**

A React Mixin, located in `utils/router`, matches each path to a single `Handler` component.

**Firebase Data Dependencies**

A `Handler` component declares data dependencies in a manifest located in `statics.firebase()`. Data is synced into the root component's `props`.


```coffeescript
    Component = React.createClass
        mixins: [FirebaseMixin]
        statics:
            firebase: ->
                posts:
                    ref: new Firebase('https://my-site.firebaseIO.com/data')
                    query: (ref, done) ->
                        # add query parameters
                        done(ref.limit(10))
                    parse: (data) ->
                        # transform data before setting into props
                    default: []
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
