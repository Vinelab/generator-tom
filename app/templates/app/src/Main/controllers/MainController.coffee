"use strict"

class MainController

    constructor: (@$scope, @$location, @Config, @Storage, @Socket)->
        @greet()
        # load the comments channel
        Socket.open '/comments', (connection)->
            connection.on 'connection:established', -> console.log 'connection established with stream base'
            # close the stream when moving out of the main page.
            $scope.$on '$locationChangeStart', ->
                console.log 'closing connection'
                connection.close()

    greet: -> @$scope.message = 'Welcome!'

# inject controller dependencies
MainController.$inject = ['$scope', '$location', 'Config', 'Storage', 'Socket']

module.exports = (app)->

    require('Config')(app)
    require('Storage')(app)
    require('Socket')(app)

    # bind controller to app
    app.controller 'MainController', MainController