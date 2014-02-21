# GET /
exports.index = (req, res) ->
  res.render 'home', { title: 'CGCU <3s U' } # render home

# GET /signin
exports.signin = (req, res) ->
  res.render 'signin', { title: 'Signin' }
