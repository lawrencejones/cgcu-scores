bcrypt = require 'bcrypt-nodejs'

module.exports = (User) ->

  _exports = {}

  hash_pass = (pass, salt) ->
    bcrypt.hashSync pass, salt, null

  _exports.authme = (req, res, next) ->
    if req.session.isAuthed then do next
    else res.send 401

  _exports.authenticate = (login, pass, success, fail) ->
    User.findOne({ login: login }).exec (err, user) ->
      if err or !user? then return do fail
      if not user.admin then return do fail
      if user.pass == '' # then default user, allow set password
        user.salt = bcrypt.genSaltSync 8
        user.pass = hash_pass pass, user.salt
        user.save()
        success user._id
      else if hash_pass(pass, user.salt) == user.pass
        console.log "User [#{user.login}] login successfully authed"
        success user._id
      else do fail
        
  return _exports

  
