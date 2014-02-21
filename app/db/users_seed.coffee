bcrypt = require 'bcrypt-nodejs'
# Seed data for users
exports.users = [
  {login: 'lmj112', pass: ''}
].map (u) -> u.salt = bcrypt.genSaltSync(8); u
