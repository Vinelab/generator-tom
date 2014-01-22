"use strict"

class MainController

    constructor: (@$scope, @$location, StorageService)-> @greet()

    greet: -> @$scope.message = 'Welcome!'

# inject controller dependencies
MainController.$inject = ['$scope', '$location', 'StorageService']

module.exports = (app)->

    require('src/Config/Config')(app)
    require('src/Storage/StorageService')(app)

    # bind controller to app
    app.controller 'MainController', MainController