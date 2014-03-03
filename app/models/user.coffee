# User model
mongoose = require 'mongoose'

userSchema = mongoose.Schema
  login:      String
  pass:       String
  salt:       String
  admin:      Boolean
  points:     Number

admins =
  [
    'lmj112',  'jmm311',  'dyl111'
    'lc3310',  'tm1911',  'cac111'
    'gp711'
  ]

User = mongoose.model 'User', userSchema
User.find {}, (err, users) ->
  admins.map (l) ->
    User.findOne({ login: l }).exec (err, user) ->
      if not user?
        User.create { login: l, pass: '', admin: true, points: 0 }
      else user.admin = true; user.save()

module.exports = User
