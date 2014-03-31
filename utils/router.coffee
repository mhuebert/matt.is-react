_ = require("underscore")
urlPattern = require('url-pattern')

RouterMixin = @Mixin =
    getDefaultProps: ->
        matchedRoute: this.matchRoute(this.props.path || window.location.pathname)

    handleClick: (e) ->
        if (e.target.tagName == 'A') and e.target.pathname[0] == "/"
            e.preventDefault()
            this.navigate(e.target.pathname)

    handlePopstate: ->
        path = window.location.pathname
        if this.props.matchedRoute.path != path
            this.setProps matchedRoute: this.matchRoute(path)

    componentDidMount: ->
        window.addEventListener 'popstate', this.handlePopstate

    matchRoute: (path) ->
        path += "/" if path[path.length-1] != "/"
        for route in (this.routes || [])
            route.path += "/" if route.path[route.path.length-1] != "/"
            pattern = urlPattern.newPattern route.path
            params = pattern.match(path)
            if params
                return {
                    path: path
                    params: params
                    handler: route.handler
                }

    navigate: (path, callback) ->
        window.history.pushState(null, null, path)
        this.setProps({ matchedRoute: this.matchRoute(path) }, callback)

@create = (routes) ->
    Router = _.clone RouterMixin

    _.extend Router,
        routes: routes
        add: (route) ->
            this.routes.push route
    Router
