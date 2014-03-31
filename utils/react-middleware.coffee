# React Middleware
# Wherein server-side rendering happens.

React = require("react")
coffee = require('coffee-script')
nodeJSX = require("node-jsx")
url = require("url")
_ = require("underscore")

safeStringify = require("../utils").safeStringify
{fetchFirebase} = require("../utils/firebase")

# By installing `node-jsx`, we can use JSX inside backticks in coffee-script files. 

nodeJSX.install
  extension: '.coffee'
  additionalTransform: (src) ->
    coffee.compile src,
      'bare': true

# Router - parse the same routes on the client and server.

routes = require("../components/routes")
Router = require("../utils/router").create(routes)

# root component:

Layout = require("../components/layout")
NotFoundHandler = require("../components/pages/notFound")

# Begin middleware...

module.exports = (req, res, next) ->

    props =
        path: url.parse(req.url).pathname

    # Use our `Router` to find the appropriate `Handler` component, which contains Firebase data dependencies:
    match = Router.matchRoute(props.path)
    Handler = match?.handler || NotFoundHandler
    firebaseManifest = Handler.firebase?(match) || {}

    # Fetch our data from Firebase & put it into props:
    fetchFirebase firebaseManifest, (firebaseData) ->

        _.extend props, firebaseData

        # Create our root component, and render it into HTML:

        App = Layout(props)
        html = React.renderComponentToString(App)

        html += "
            <script>
                var Layout = React.renderComponent(Components.Layout(#{safeStringify(props)}), document)
            </script>
        "

        res.setHeader('Content-Type', 'text/html')
        res.send html
