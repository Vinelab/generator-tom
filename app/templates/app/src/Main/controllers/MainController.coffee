"use strict"

class MainController

    constructor: (@$scope, @$location, Config, StorageService, Socket)->
        @greet()

        stream = Socket.open '/comments', (stream)->
            # close the stream when moving out of the main page.
            $scope.$on '$locationChangeStart', -> Socket.close stream

    greet: -> @$scope.message = 'Welcome!'

# inject controller dependencies
MainController.$inject = ['$scope', '$location', 'Config', 'StorageService', 'Socket']

module.exports = (app)->

    require('Config')(app)
    require('src/Socket/Socket')(app)
    require('src/Storage/StorageService')(app)

    # bind controller to app
    app.controller 'MainController', MainController