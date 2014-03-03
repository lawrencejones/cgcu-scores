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
    secret: 'mysecret'
  app.use express.bodyParser()                    # params
  app.use flash()                                 # cflash
  
  # Asset serving
  app.use stylus.middleware root_dir              # stylus
  app.use coffee.middleware root_dir              # coffee
  app.use express.static(                         # static
    path.join root_dir, 'public')
  
  # Authentication
  app.use passport.initialize()                   # pssprt

  # Concatenates all coffeescript for webapp
  app.get '/app.js', ngget
    angularPath: path.join root_dir, 'web'

# Start database
db = require './db'

# Load app
server = app.listen (PORT = process.env.PORT || 80), ->
  console.log "Listening at localhost:#{PORT}"

# Load routes
(require './routes')(app, db, passport)

