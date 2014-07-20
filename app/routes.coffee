
routes =  [

    { path: "/settings",         handler: "Settings" }
    { path: "/tags/:tag",        handler: "Writing" }
    { path: "/writing/:id",      handler: "WritingView" }
    { path: "/ideas",            handler: "Ideas" }
    { path: "/ideas/:id",        handler: "Edit" }
    { path: "/login",            handler: "Login" }
    { path: "/logout",           handler: "Logout" }
    { path: "/seeing",           handler: "Photography" }
    { path: "/seeing/:id",       handler: "PhotographyView" }
    { path: "/writing",          handler: "Writing" }
    { path: "/",                 handler: "ElementList" }
    { path: "/new",              handler: "ElementForm" }
    { path: "/edit/:type/:id",   handler: "ElementForm" }
    { path: "/:type/:id",        handler: "ElementView" }
    { path: "/type/:type",       handler: "ElementList" }
    { path: "/new/:type",        handler: "ElementForm" }
    # { path: "*",                 handler: "NotFound" }
]

module.exports = routes
