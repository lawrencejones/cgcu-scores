#!/usr/bin/env coffee
express = require 'express'
stylus  = require 'stylus'
nib     = require 'nib'

# Init app
app = express()

# Init app settings
app.set 'title', 'CGCU <3s U - Scoreboard'
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

# Configure middleware
app.use express.logger('dev')                   # logger
app.use express.static "#{__dirname}/public"    # static
app.use stylus.middleware                       # stylus
  src: "#{__dirname}/public"
  compile: (str, path) -> stylus(str)
    .set('filename', path)
    .use nib()

# Control logging
print = -> if (verbose? || true)
  console.log.apply console, arguments

# GET for homepage
app.get '/', (req, res) ->
  res.end 'Hello world!'

PORT = process.env.PORT || 3000
print "Listening at localhost:#{PORT}"
app.listen PORT
