express  = require 'express'
passport = require 'passport'
nib      = require 'nib'
flash    = require 'connect-flash'
fs       = require 'fs'
path     = require 'path'
coffee   = require './midware/cs'
stylus   = require './midware/stylus'
ngget    = require './midware/angular'

# Init app
app = express()
root_dir = path.join (__dirname || process.cwd()), '..'

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
  app.use express.session                         # secret
    secret: 'huiwedh802h9#ji21jioio'
  app.use express.bodyParser()                    # params
  app.use flash()                                 # cflash

  # Live compilation, shouldn't be used in production
  if app.settings.env == 'development'
    app.get '/js/app.js', ngget                     # app.js
      angularPath: path.join root_dir, 'web'
    app.use stylus.middleware root_dir              # stylus
    app.use coffee.middleware root_dir              # coffee
  
  # Asset serving
  app.use express.static(                         # static
    path.join root_dir, 'public')
  
  # Authentication
  app.use passport.initialize()                   # pssprt


# Start database
db = require './db'

# Load app
server = app.listen (PORT = process.env.PORT || 80), ->
  console.log "Listening at localhost:#{PORT}"

# Load routes
(require './routes')(app, db, passport)

