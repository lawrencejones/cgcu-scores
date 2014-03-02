# User model
mongoose = require 'mongoose'

userSchema = mongoose.Schema
  login:      String
  pass:       String
  salt:       String
  admin:      Boolean
  points:     Number

User = mongoose.model 'User', userSchema
User.find {}, (err, users) ->
  if users.length == 0
    [
      'lmj112'
    ].map (l) -> User.create { login: l, pass: '', admin: true, points: 0 }

module.exports = User
