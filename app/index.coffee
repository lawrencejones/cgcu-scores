express  = require 'express'
passport = require 'passport'
stylus   = require 'stylus'
nib      = require 'nib'
fs       = require 'fs'
path     = require 'path'
coffee   = require './midware/cs'

# Init app
app = express()
root_dir = path.join __dirname, '..'

# Configure app
config = require './config'
app.configure 'production', 'development', 'testing', ->
  config.setEnvironment app.settings.env

  # Init app settings
  app.set 'title', 'CGCU <3s U - Scoreboard'
  app.set 'views', "#{root_dir}/views"
  app.set 'view engine', 'jade'
  
  # Configure middleware
  app.use express.logger('dev')                   # logger
  app.use express.cookieParser()                  # cookie
  
  # Asset serving
  app.use stylus.middleware                       # stylus
    src: "#{root_dir}/stylesheets"
    dest: "#{root_dir}/public"
    compile: (str, path) -> stylus(str)
      .set('filename', path)
  app.use coffee.middleware                       # coffee
    src: "#{root_dir}/web"
  app.use express.static "#{root_dir}/public"    # static
  
  # Authentication
  app.use express.session                         # secret
    secret: 'thisismyappsecret'
  app.use passport.initialize()                   # pssprt
  app.use passport.session()

# Start database
db = require('./db') config, ['users', 'dept']

# Load routes
(require './routes')(app, db, passport)

# Export the app
module.exports = app

