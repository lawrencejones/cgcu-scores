#!/usr/bin/env coffee
app = require './app'

app.listen (PORT = process.env.PORT || app.port), ->
  console.log "Listening at localhost:#{PORT}"
