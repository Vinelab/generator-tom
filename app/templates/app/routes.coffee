module.exports = (app)->
    # configure AngularJS
    app.config ($routeProvider)->
        # setup routes
        $routeProvider
        .when '/',
            controller: 'MainController'
            templateUrl: 'app/views/main.html'