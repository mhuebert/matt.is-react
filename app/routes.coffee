
routes =  [

    { path: "/settings",         handler: "Settings" }
    { path: "/login",            handler: "Login" }
    { path: "/logout",           handler: "Logout" }
    { path: "/",                 handler: "ElementList" }
    { path: "/new",              handler: "ElementForm" }
    { path: "/edit/:type/:id",   handler: "ElementForm" }
    { path: "/:type/:id",        handler: "ElementView" }
    { path: "/type/:type",       handler: "ElementList" }
    { path: "/topics/:topic",       handler: "ElementList" }
    { path: "/new/:type",        handler: "ElementForm" }
    # { path: "*",                 handler: "NotFound" }
]

module.exports = routes
