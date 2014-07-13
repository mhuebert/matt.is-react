
routes =  [
    { path: "/",                 handler: "Home" },
    { path: "/quotes",                 handler: "Home" },
    { path: "/writing",          handler: "Writing" },
    { path: "/settings",                 handler: "Settings" },
    { path: "/tags/:tag",         handler: "Writing" },
    { path: "/writing/:id",      handler: "WritingView" },
    { path: "/tags",            handler: "Tags" },
    { path: "/ideas",            handler: "Ideas" },
    { path: "/ideas/:id",   handler: "Edit" },
    { path: "/login",            handler: "Login" },
    { path: "/logout",           handler: "Logout" },
    { path: "/seeing",           handler: "Photography" },
    { path: "/seeing/:id",       handler: "PhotographyView" }
    # { path: "*",                 handler: "NotFound" }
]

module.exports = routes
