
routes =  [
    { path: "/",                 handler: "Home" },
    { path: "/type/:type",       handler: "Home" },
    { path: "/writing",          handler: "Writing" },
    { path: "/settings",         handler: "Settings" },
    { path: "/new",              handler: "New" },
    { path: "/new/:type",        handler: "New" },
    { path: "/tags/:tag",        handler: "Writing" },
    { path: "/writing/:id",      handler: "WritingView" },
    { path: "/tags",             handler: "Tags" },
    { path: "/ideas",            handler: "Ideas" },
    { path: "/ideas/:id",        handler: "Edit" },
    { path: "/login",            handler: "Login" },
    { path: "/logout",           handler: "Logout" },
    { path: "/seeing",           handler: "Photography" },
    { path: "/seeing/:id",       handler: "PhotographyView" }
    # { path: "*",                 handler: "NotFound" }
]

module.exports = routes
