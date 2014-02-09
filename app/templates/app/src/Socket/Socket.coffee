'use strict'

class Socket

    ###*
     * This method is used by Angular to inject dependencies
     * into this provider which in turn will be used
     * to be injected into the constructor.
     *
     * @param  {src/Config/Config} Config
     * @param  {io} ioClient
     * @param  {Socket/SocketService} SocketService
     * @return {Socket}
    ###
    @$get: (Config, ioClient, SocketService)-> new this(Config, ioClient, SocketService)

    ###*
     * Create a new Socket instance,
     *     here's where the initial connection
     *     to the `main` socket happens.
     *
     * @param  {src/Config/Config} Config
     * @param  {io} io
     * @param  {Socket/SocketService} SocketService
     * @return {Socket}
    ###
    constructor: (@Config, @io, @SocketService)->

        @channels = {}

        # establish the main channel connection
        socket = @connect()
        socket.on 'connect', =>
            @channels['main'] = socket

    ###*
     * Establish a new connection
     * to a channel.
     *
     * @param  {string} channel
     * @param {Function} callback Will be called with a SocketConnection param
     * @return {io.socket}
    ###
    open: (channel, callback)->

        # establish a connection with the channel
        socket = @connect channel
        socket.on 'connect', =>
            @channels[channel] = socket
            callback @SocketService.make(socket) if typeof callback is 'function'

    ###*
     * Establish a connection with the server.
     *
     * @param  {string} channel Optionally specify a channel
     * @return {io.SocketNamespace}
    ###
    connect: (channel)-> @io.connect @channelURL(channel), {'force new connection': yes}

    ###*
     * Disconnect a socket.
     *
     * @param  {SocketConnection} connection
     * @param  {function} callback
    ###
    close: (connection, callback)->
        channel = connection.channel()

        if channel? and @channels.hasOwnProperty(channel)
            connection.close()
            delete @channels[channel]
            callback() if typeof callback is 'function'

    ###*
     * Build the channel URL.
     *
     * @param  {string} channel
     * @return {string}
    ###
    channelURL: (channel)->

        socket = @Config.get('socket')

        if channel?
            "#{socket.scheme}://#{socket.host}:#{socket.port}#{channel}"
        else "#{socket.scheme}://#{socket.host}:#{socket.port}"


Socket.$inject = ['Config', 'io', 'SocketService']

module.exports = (app)->

    require('src/Socket/services/SocketService')(app)
    require('src/Socket/factories/io')(app)
    require('src/Config/Config')(app)

    app.provider 'Socket', -> Socket