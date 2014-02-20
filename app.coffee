#!/usr/bin/env coffee
express = require 'express'
stylus  = require 'stylus'
nib     = require 'nib'
routes  = require './routes'

# Init app
app = express()

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
app.use express.static "#{__dirname}/public"    # static

# Routes for homepage
app.get '/', routes.home.index

# Configure scores resource routes
app.get '/scores',      routes.scores.findAll
app.get '/scores/:id',  routes.scores.findById

PORT = process.env.PORT || 3000
console.log "Listening at localhost:#{PORT}"
app.listen PORT
