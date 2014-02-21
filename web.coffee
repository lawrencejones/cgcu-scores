#!/usr/bin/env coffee
express  = require 'express'
passport = require 'passport'
stylus   = require 'stylus'
nib      = require 'nib'
fs       = require 'fs'
path     = require 'path'
coffee   = require 'coffee-script'
routes   = require './routes'

# Init app
app = express()

# Attach middleware to coffeescript
coffee.middleware = (options) ->
  srcdir = options.src || path.join __dirname, 'app'
  rexJs  = /^(\/app\/)(\w+).js/
  # Returns js if corresponding cs src exists and is compileable
  getCoffeeSrc = (url) ->
    if url && rexJs.test url
      fname = (url.match rexJs)[2]
      return if not fname?
      fpath = path.join srcdir, "#{fname}.coffee"
      if fs.existsSync fpath
        return coffee.compile fs.readFileSync fpath, 'utf8'
  # Return middleware
  (req, res, next) ->
    if (src = getCoffeeSrc req.url)
      res.send src
    else next()

# Init app settings
app.set 'title', 'CGCU <3s U - Scoreboard'
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

# Configure middleware
app.use express.logger('dev')                   # logger
app.use stylus.middleware                       # stylus
  src: "#{__dirname}/stylesheets"
  dest: "#{__dirname}/public"
  compile: (str, path) -> stylus(str)
    .set('filename', path)
app.use coffee.middleware                       # coffee
  src: "#{__dirname}/app"
app.use express.static "#{__dirname}/public"    # static

# Routes for homepage
app.get '/',        routes.home.index
app.get '/signin',  routes.home.signin

# Configure scores resource routes
app.get '/scores',      routes.scores.findAll
app.get '/scores/:id',  routes.scores.findById

PORT = process.env.PORT || 3000
console.log "Listening at localhost:#{PORT}"
app.listen PORT
