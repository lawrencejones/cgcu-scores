routeHome = ->
  # GET /
  index: (req, res) ->
    res.render 'home', { title: 'CGCU <3s U' } # render home
  
  # GET /signin
  signin: (req, res) ->
    res.render 'signin', { title: 'Signin' }

routeDept = ->

  # GET /dept
  findAll: (req, res) ->
    db.collection 'dept', (err, dept) ->
      if not err then dept.find {}, (err, cursor) ->
        cursor.toArray (err, array) ->
          res.send array
  
  # GET /dept/:dept
  findByDept: (req, res) ->
    db.collection 'dept', (err, dept) ->
      if not err
        dept.findOne {dept: req.params.dept}, (err, dept) ->
          res.send if err then 404 else dept
        

db = null
# Takes app and appropriate parameters for route config
module.exports = (app, _db, passport) ->

  db = _db

  home = do routeHome
  dept = do routeDept

  # Routes for homepage
  app.get '/',            home.index
  app.get '/signin',      home.signin

  # Configure scores resource routes
  app.get '/dept',        dept.findAll
  app.get '/dept/:dept',  dept.findByDept
