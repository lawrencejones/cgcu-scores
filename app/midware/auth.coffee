bcyrpt = require 'bcrypt-nodejs'

module.exports = (db, cname) ->

  _exports = {}

  hash_pass = (pass, salt) ->
    bcrypt = require 'bcrypt-nodejs'
    bcrypt.hashSync pass, salt, null

  db.collection cname, (err, users) ->
    _exports.authme = (req, res, next) ->
      if req.session.isAuthed then do next
      else res.send 401
    _exports.authenticate = (login, pass, success, fail) ->
      users.findOne { login: login }, (err, user) ->
        if err or !user? then return do fail
        if user.pass == '' # then default user, allow set password
          users.update {login: user.login}, {
            $set: {pass: hash_pass(pass, user.salt)}
          }, (err, result) ->
            console.log "User [#{user.login}] successfully authed"
            success user.login
        else if hash_pass(pass, user.salt) == user.pass
          console.log "User [#{user.login}] login successful"
          success user.login
        else do fail
  return _exports

  
