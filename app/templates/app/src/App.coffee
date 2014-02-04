App = require 'app/boot/start'

require('src/Main/controllers/MainController')(App)

require('app/filters')(App)
require('app/routes')(App)