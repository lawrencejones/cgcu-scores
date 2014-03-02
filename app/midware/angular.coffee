# Concatenates full angular app into a single app.js
# TODO - refactor into midware

fs     = require 'fs'
path   = require 'path'
coffee = require 'coffee-script'

# Collects all coffeescript files in directory dpath
globCoffee = (dpath) ->
  rexedFiles = []
  for fpath in fs.readdirSync dpath
    fpath = path.join dpath, fpath
    if fs.statSync(fpath).isDirectory()
      rexedFiles.push globCoffee fpath
    else if /^(.+)\.coffee$/.test fpath
      rexedFiles.push fpath
  [].concat.apply [], rexedFiles

# Export the get request handler
module.exports = (options) ->
  return (req, res) ->
    res.setHeader 'Content-Type', 'text/javascript'
    res.send (globCoffee options.angularPath)
      .map((f) -> coffee.compile fs.readFileSync(f, 'utf8'))
      .reverse()
      .reduce (a,c) -> a + c

