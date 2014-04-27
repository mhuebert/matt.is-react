# React Middleware for server-side rendering.

React = require("react")
coffee = require('coffee-script')
nodeJSX = require("node-jsx")
url = require("url")
_ = require("underscore")

safeStringify = require("../app/utils").safeStringify
{fetchSubscriptions} = require("sparkboard-tools")

# By installing `node-jsx`, we can use JSX inside backticks in coffee-script files. 

nodeJSX.install
  extension: '.coffee'
  additionalTransform: (src) ->
    coffee.compile src,
      'bare': true

# root component:
components = require("../components")
{Layout} = components

# Router - parse the same routes on the client and server.
routes = require("./routes")
Router = require("sparkboard-tools").Router.create(routes)
Router.addFallback require("./route-fallback")

# Begin middleware...
module.exports = (req, res, next) ->

    path = url.parse(req.url).pathname

    # Use our `Router` to find the appropriate `Handler` component, which contains Firebase data dependencies:
    Router.matchRoute path, (matchedRoute) ->
        props = 
            path: path
            matchedRoute: matchedRoute

        handler = components[matchedRoute.handler]

        subscriptions = handler.subscriptions?(props) || {}

        # Fetch our data from Firebase & put it into props:
        fetchSubscriptions subscriptions, (subscriptionData) ->
            _.extend props, subscriptionData

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
