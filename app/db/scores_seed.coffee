# Seed data for scores
exports.scores =
[
  'Aero',    'BioEng',  'ChemEng'
  'CivEng',  'Comp',    'EEEng'
]
  .map (d) -> {dept: d, score: 0}
