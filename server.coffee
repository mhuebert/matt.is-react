express = require("express")
http = require("http")
path = require("path")

# `reactMiddleware` is our only real place of work:
reactMiddleware = require("./app/react-middleware")

app = express()
    .use(express.static(path.join(__dirname, './public')))
    .use(express.favicon(path.join(__dirname, './public', 'images', 'favicon.ico')))
    .use(express.logger())
    .use(express.compress())
    .use(express.errorHandler())
    .use(reactMiddleware)

port = process.env.PORT || 8080
http.createServer(app).listen(port)
console.log("Open http://localhost:#{port}")
