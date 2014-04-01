
Home = require("./pages/home")
Writing = require("./pages/writing")
WritingView = require("./pages/writingView")
Photography = require("./pages/photography")
PhotographyView = require("./pages/photographyView")
Ideas = require("./pages/ideas")
Edit = require("./pages/edit")
Login = require("./pages/login")
Logout = require("./pages/logout")

routes =  [
    { path: "/",                 handler: Home },
    { path: "/writing",          handler: Writing },
    { path: "/writing/:id",      handler: WritingView },
    { path: "/ideas",            handler: Ideas },
    { path: "/writing/edit/:slug", handler: Edit },
    { path: "/ideas/:id",         handler: Edit },
    { path: "/login",            handler: Login },
    { path: "/logout",           handler: Logout },
    { path: "/seeing",           handler: Photography },
    { path: "/seeing/:id",       handler: PhotographyView }
]

module.exports = routes
