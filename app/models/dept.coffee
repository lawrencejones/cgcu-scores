# Dept model
mongoose = require 'mongoose'

deptSchema = mongoose.Schema
  name:      String
  score:     Number

depts =
  [
    'Aero', 'BioEng', 'ChemEng', 'MechEng'
    'CivEng', 'Comp', 'EEEng'
  ]

Dept = mongoose.model 'Dept', deptSchema
depts.map (d) ->
  Dept.findOne({ name: d }).exec (err, dept) ->
    if not dept?
      Dept.create { name: d, score: 0 }

module.exports = Dept

