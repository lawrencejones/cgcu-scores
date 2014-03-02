# Dept model
mongoose = require 'mongoose'

deptSchema = mongoose.Schema
  name:      String
  score:     Number

Dept = mongoose.model 'Dept', deptSchema
Dept.find {}, (err, depts) ->
  if depts.length == 0
    [
      'Aero', 'BioEng', 'ChemEng'
      'CivEng', 'Comp', 'EEEng'
    ].map (d) -> Dept.create { name: d, score: 0 }

module.exports = Dept

