
routes =  [
    { path: "/",                 handler: "Home" },
    { path: "/writing",          handler: "Writing" },
    { path: "/writing/:id",      handler: "WritingView" },
    { path: "/ideas",            handler: "Ideas" },
    { path: "/posts/edit/:id",   handler: "Edit" },
    { path: "/login",            handler: "Login" },
    { path: "/logout",           handler: "Logout" },
    { path: "/seeing",           handler: "Photography" },
    { path: "/seeing/:id",       handler: "PhotographyView" }
    # { path: "*",                 handler: "NotFound" }
]

module.exports = routes
