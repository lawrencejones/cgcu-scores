# Seed data for depts
exports.dept =
[
  'Aero',    'BioEng',  'ChemEng'
  'CivEng',  'Comp',    'EEEng'
].map (d) -> {dept: d, score: 0}
