# Require scores db
db = require '../db'

# GET /scores
exports.findAll = (req, res) ->
  res.send []

# GET /scores/:id
exports.findById = (req, res) ->
  res.send
    id: req.params.id
    dept: 'Department'
    score: 1500

