routeHome = (auth, User) ->

  # GET /
  index: (req, res) ->
    res.render 'home',  # render home
      title: 'CGCU <3s U'
      sudo: req.session.isAuthed
  
  # GET /signin
  signin: (req, res) ->
    res.render 'signin',
      title: 'Signin'
      lash: req.session.flash

  # GET /users
  getUsers: (req, res) ->
    User.find({}).exec (err, users) ->
      if err then res.send 500
      else
        response = []
        for u in (u for u in users when u.points? and u.points > 0)
          response.push
            login: u.login
            points: u.points
        res.send response

  # POST /login (?login=<login>&pass=<pass>)
  login: (req, res) ->
    [login, pass] = [req.body.login, req.body.pass]
    req.session.isAuthed = false
    success = (uid) ->
      req.session.isAuthed = true
      res.send { uid: uid }
    fail = ->
      req.session.isAuthed = false
      res.send 401
    auth.authenticate login, pass, success, fail


routeDev = (User) ->

  # GET /users
  # Dev only
  getUsers: (req, res) ->
    User.find({}).exec (err, users) ->
      if err then res.send 500
      else
        res.send users

  # DELETE /users
  # Dev only
  deleteUsers: (req, res) ->
    User.remove {}, (err) ->
      process.exit 0


routeDept = (auth, Dept, User) ->

  # GET /api/dept
  findAll: (req, res) ->
    Dept.find({}).exec (err, depts) ->
      if err then res.send 500
      else
        res.send depts
  
  # GET /api/dept/:dept
  findByDept: (req, res) ->
    query = Dept.find { name: req.params.dept }
    query.exec (err, dept) ->
      if err then res.send 500
      else
        res.send dept

  # POST /api/score
  postScore: (req, res) ->
    deptQuery = { name: req.body.dept }
    deptUpdate = { $inc: { score: req.body.score } }
    req.body.score = parseInt req.body.score, 10
    Dept.update deptQuery, deptUpdate, (err, num) ->
      if err then return res.send 500
      console.log "Updated #{num} depts"
      User.findOne { login: req.body.login }, (err, user) ->
        if err then return res.send 500
        if not user?
          User.create
            login: req.body.login
            admin: false
            points: req.body.score
        else
          user.points += req.body.score
          user.save()
        res.send 200

  # DELETE /api/dept/:dept/score
  clearScore: (req, res) ->
    Dept.update {
      name: req.params.dept
    }, { score: 0 }, { multi: true }, (err, num) ->
      if err then res.send 500
      else
        res.send { num: num }

  # DELETE /api/reset
  resetScores: (req, res) ->
    Dept.update {}, { score: 0 }, { multi: true }, (err, num) ->
      if err then res.send 500
      else
        res.send { num: num }


# Takes app and appropriate parameters for route config
module.exports = (app, db, passport) ->

  auth = (require './midware/auth')(db.models.User)
  authme = auth.authme

  home = routeHome auth, db.models.User
  dept = routeDept auth, db.models.Dept, db.models.User
  dev  = routeDev        db.models.User

  # General partial route
  app.get '/partials/:name', (req, res) ->
    res.render req.params.name, { layout: false }

  # Routes for homepage
  app.get  '/',           home.index
  app.get  '/signin',     home.signin
  app.get '/users',       home.getUsers
  app.post '/login',      home.login

  # Routes for dev only
  # Do NOT publish to production
  if app.settings.env == 'development'
    app.get    '/dev/users',    dev.getUsers
    app.delete '/dev/users',    dev.deleteUsers

  # Configure scores resource routes
  app.get     '/api/dept',                      dept.findAll
  app.get     '/api/dept/:dept',                dept.findByDept
  app.post    '/api/score',             authme, dept.postScore
  app.delete  '/api/dept/:dept/score',  authme, dept.clearScore
  app.delete  '/api/reset',             authme, dept.resetScores

