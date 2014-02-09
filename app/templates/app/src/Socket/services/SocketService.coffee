'use strict'

SocketConnection = require('src/Socket/SocketConnection')

class SocketService

    ###*
     * Create a new SocketService instnace.
     *
     * @param  {$rootScope} $rootScope
     * @return {SocketService}
    ###
    constructor: (@$rootScope)->

    ###*
     * Make a new Socket/SocketConnection
     * out of an io.SocketNamespace.
     *
     * @param  {io.SocketNamespace} socket
     * @return {Socket/SocketConnection}
    ###
    make: (socket)-> new SocketConnection @$rootScope, socket

SocketService.$inject = ['$rootScope']

module.exports = (app)-> app.service 'SocketService', SocketService