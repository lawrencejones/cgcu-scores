# GET /
exports.index = (req, res) ->
  res.render 'home', { title: 'CGCU <3s U' } # render home
