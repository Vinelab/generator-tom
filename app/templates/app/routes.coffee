module.exports = (app)->

    CDN = require('CDN')(app)

    # configure AngularJS
    app.config ($routeProvider)->
        # setup routes
        $routeProvider
        .when '/',
            controller: 'MainController'
            templateUrl: CDN.template('main.html')
        .when '/comments',
            templateUrl: CDN.template('comments.html')
        .when '/cors',
            templateUrl: CDN.template('cors.html')