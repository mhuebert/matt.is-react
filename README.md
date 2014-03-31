Matt.is
===

SEO-friendly blog using [Firebase](http://www.firebase.com) and [React](http://facebook.github.io/react/).


**Details**

- Asset packaging: [gulp](http://gulpjs.com/) & [browserify](http://browserify.org/)
- Server: [express](http://expressjs.com/)
- Router: a react mix-in (`utils/router`) matches each path to a `Handler` component
- Server-side rendering: `utils/reactMiddleware`
- Data: the `Handler` component specifies Firebase data dependencies, which are optionally fetched before rendering on the server, and always subscribed to (with real-time updates) on the client.

**Server-side rendering:**

In `server/react-middleware`:
1. `utils/router` finds the `Handler` for the current path.
- Each handler describes data dependencies in `statics.firebase()`. We pass this to `fetchFirebase` to load it asynchronously.
- We add data received from Firebase to `props` and render the root component, `Layout`, into HTML.
- In the browser, the `Handler` will keep its Firebase data up-to-date automatically using `FirebaseMixin`.

**Firebase subscriptions**

Describe the Firebase data you want in your Handler's `statics.firebase`. This data will be synced into the component's `props`.

Example `Firebase` manifest:


    Component = React.createClass
        mixins: [FirebaseMixin]
        statics:
            firebase: ->
                posts:
                    ref: new Firebase('https://my-site.firebaseIO.com/data')
                    query: (ref) -> ref.limit(10)
                    parse: (data) -> # do something with returned data

Data is mounted at the same path in `props` as it appears in the firebase manifest. Data in this example will be found at `props.post`.

| Method | What it does
|---|---
| `ref` _Firebase ref, required_    | a Firebase ref
| `query` _function, optional_   | Receives, and must return, a Firebase ref.
| `parse` _function, optional_ | Modify received data before setting into `props`
| `default` _optional_ | What to set in `props` before data is loaded


**Properties for `<head>`**

A `Handler` can specify properties, like `title` and `description`, for the root `Layout` component. These go in `statics/getMetaData()`:

    Component = React.createClass
        mixins: [FirebaseMixin]
        statics:
            getMetadata: ->
                title: "Writing | Matt.is"
                description: "Wherein I uncover."

In `Layout`, remember to transfer props to the `Handler`:

        this.transferPropsTo(Handler)
