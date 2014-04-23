requireDirectory = require('require-directory')
argv = require("optimist").argv
_ = require("underscore")
fs = require("fs")

readPath = argv._[0]
writePath = argv._[1]

if !readPath
  console.log "No path provided. Quitting."
  return
else
  console.log "Compiling rules in: #{readPath}"


rules = {}
rulesFromFiles = requireDirectory module, readPath, /_[^\/]*$/
for key, json of rulesFromFiles
  _.extend rules, json

rules = JSON.stringify
  "rules": rules
, null, 4

fs.writeFileSync writePath, rules

