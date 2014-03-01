routeHome = (db, auth) ->

  # GET /
  index: (req, res) ->
    res.render 'home', {  # render home
      title: 'CGCU <3s U'
      sudo: req.session.isAuthed
    }
  
  # GET /signin
  signin: (req, res) ->
    res.render 'signin', { title: 'Signin', flash: req.session.flash }

  # POST /login (?login=<login>&pass=<pass>)
  login: (req, res) ->
    [login, pass] = [req.body.login, req.body.pass]
    success = ->
      req.session.isAuthed = true
      res.redirect '/'
    fail = ->
      req.session.isAuthed = false
      req.flash 'error', 'Invalid login, try again'
      res.redirect 'back'
    if req.session.isAuthed
      res.redirect '/'
    else auth.authenticate login, pass, success, fail

  # GET /users
  # Dev only
  users: (req, res) ->
    db.collection 'users', (_, users) ->
      users.find {}, (_, cursor) ->
        cursor.toArray (err, uarray) ->
          console.log uarray
          res.send uarray


routeDept = (db, auth) ->

  deptCollection = null
  db.collection 'dept', (err, collection) ->
    deptCollection = collection if not err

  # GET /dept
  findAll: (req, res) ->
    deptCollection.find {}, (err, cursor) ->
      cursor.toArray (err, array) ->
        res.send array
  
  # GET /dept/:dept
  findByDept: (req, res) ->
    deptCollection.findOne {dept: req.params.dept}, (err, dept) ->
      res.send if err then 404 else dept

  # POST /dept/:dept/score
  postScore: (req, res) ->
    try
      score = parseInt req.body.score, 10
    catch err
      return res.send 500
    query = { dept: req.params.dept }
    deptCollection.update query, {
      $inc: { score: score }
    }, (err, result) ->
      if not err then res.send 200 else res.send 404

  # DELETE /dept/:dept/score
  clearScore: (req, res) ->
    query = { dept: req.params.dept }
    deptCollection.update query, {
      $set: { score: 0 }
    }, (err, result) ->
      if not err then res.send 200 else res.send 404
        

# Takes app and appropriate parameters for route config
module.exports = (app, db, passport) ->

  auth = (require './midware/auth')(db, 'users')
  authme = auth.authme

  home = routeHome db, auth
  dept = routeDept db, auth

  # Routes for homepage
  app.get  '/',           home.index
  app.get  '/signin',     home.signin
  app.post '/login',      home.login
  app.get  '/users',      home.users

  # Configure scores resource routes
  app.get     '/dept',                      dept.findAll
  app.get     '/dept/:dept',                dept.findByDept
  app.post    '/dept/:dept/score',  authme, dept.postScore
  app.delete  '/dept/:dept/score',  authme, dept.clearScore
