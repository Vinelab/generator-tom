App = require 'app/bootstrap'

require('src/Main/controllers/MainController')(App)

# configure AngularJS
App.config ($routeProvider)->

    console.log 'App Configuration Started...'

    # setup routes
    $routeProvider
        .when '/',
            controller: 'MainController'
            templateUrl: 'app/views/main.html'