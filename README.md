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
                    # Firebase ref - useful to keep on hand to set & update
                    ref: new Firebase('https://my-site.firebaseIO.com/data')

                    # add query parameters
                    query: (ref, done) ->
                        done(ref.limit(10))
                    
                    # transform data before setting into props
                    parse: (data) -> data
                    
                    # default value (avoid 'undefined' errors)
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
