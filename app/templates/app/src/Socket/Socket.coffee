'use strict'

class Socket

    ###*
     * This method is used by Angular to inject dependencies
     * into this provider which in turn will be used
     * to be injected into the constructor.
     *
     * @param  {src/Config/Config} Config
     * @return {Socket}
    ###
    @$get: (Config, ioClient)-> new this(Config, ioClient)

    ###*
     * Create a new Socket instance,
     *     here's where the initial connection
     *     to the `base` socket happens.
     *
     * @param  {src/Config/Config} Config
     * @return {Socket}
    ###
    constructor: (@Config, @io)->

        @channels = {}

        # establish the main channel connection
        socket = @connect()
        socket.on 'connect', =>
            @channels['main'] = socket

    ###*
     * Establish a new connection
     * in a channel.
     *
     * @param  {string} channel
     * @return {io.Socket}
    ###
    open: (channel, callback)->

        # establish connection if not established already
        if not @channels.hasOwnProperty channel
            socket = @connect channel
            socket.on 'connect', =>
                @channels[channel] = socket
                callback(socket) if typeof callback is 'function'
        else @channels[channel].reconnect() # reconnect an already established connection

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
     * @param  {Socket | SocketNamespace}   socket
     * @param  {function} callback
    ###
    close: (socket, callback)->

        if typeof socket is 'object'
            channel = socket.name

            if @channels.hasOwnProperty(channel)
                socket.disconnect()
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


Socket.$inject = ['Config', 'io']

module.exports = (app)->

    require('src/Socket/io')(app)
    require('src/Config/Config')(app)

    app.provider 'Socket', -> Socket