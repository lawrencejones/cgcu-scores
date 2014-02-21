routeHome = ->
  # GET /
  index: (req, res) ->
    res.render 'home', { title: 'CGCU <3s U' } # render home
  
  # GET /signin
  signin: (req, res) ->
    res.render 'signin', { title: 'Signin' }

routeScores = ->
  # GET /scores
  findAll: (req, res) ->
    res.send []
  
  # GET /scores/:id
  findById: (req, res) ->
    res.send
      id: req.params.id
      dept: 'Department'
      score: 1500

# Takes app and appropriate parameters for route config
module.exports = (app, db, passport) ->

  home   = do routeHome
  scores = do routeScores

  # Routes for homepage
  app.get '/',            home.index
  app.get '/signin',      home.signin

  # Configure scores resource routes
  app.get '/scores',      scores.findAll
  app.get '/scores/:id',  scores.findById
