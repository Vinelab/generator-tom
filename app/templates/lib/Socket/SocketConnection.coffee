###*
 * a wrapper for io/SocketNamespace
 * that wraps each of the @on and @emit
 * callbacks inside $scope.$apply,
 * This tells AngularJS that it needs to check
 * the state of the application and update the templates
 * if there was a change after running the callback passed to it.
###
class SocketConnection

    ###*
     * Create a new SocketConnection instance.
     *
     * @param  {$scope} $rootScope
     * @param  {io.SocketNamespace} @socket
     * @return {Socket/SocketConnection}
    ###
    constructor: (@$rootScope, @socket)->

    ###*
     * set an event listener to a socket message
     * and run the callback inside a $scope.$apply.
     *
     * @param  {string}   message
     * @param  {Function} callback
     * @return {io.SocketNamespace}
    ###
    on: (message, callback)->
        @socket.on message, =>
            args = arguments
            @$rootScope.$apply => callback.apply(@socket, args) if typeof callback is 'function'

    ###*
     * emit a message with data on the socket
     * wrapping the callback with $scope.$apply.
     *
     * @param  {string}   message
     * @param  {mixed}    data
     * @param  {Function} callback
     * @return {io.SocketNamespce}
    ###
    emit: (message, data, callback)->
        @socket.emit message, data, =>
            arts = arguments
            @$rootScope.$apply => callback.apply(@socket, args) if typeof callback is 'function'

    ###*
     * Get the connected channel name.
     *
     * @return {string}
    ###
    channel: -> @socket.name

    ###*
     * Close an open connection.
     *
     * @return {void}
    ###
    close: -> @socket.disconnect()

module.exports = SocketConnection