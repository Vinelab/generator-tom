'use strict'

describe 'Socket', ->

    J = jasmine
    JMock = J.createSpy

    # global variables to be used inside tests
    io = null
    test = null
    config = null
    socket = null
    socket_service = null

    # mocked classes
    class Config
        get: JMock('get').andReturn
            scheme: 'http'
            host: 'localhost'
            port: '9091'

    class IOSocket
        on: JMock('on').andCallFake (event, callback)=> callback()

    class Connection
        on: JMock('on').andCallFake (event, callback)=> callback()
        close: JMock('close')

    class Service
        make: JMock('make').andReturn new Connection


    # load app and assign mocks
    beforeEach ->

        # should be created for each test
        class IOClient
            connect: JMock('connect').andReturn new IOSocket

        test = angular.module('test.app', [])

        # assign mocks to globals
        config = new Config
        io = new IOClient
        socket_service = new Service

        # register deps to our test app
        test.factory 'ioClient', -> io
        test.factory 'Config', -> config
        test.factory 'SocketService', -> socket_service

        # mock dat app
        angular.mock.module 'Najem', 'test.app'

        # gimme my Socket
        inject (Socket, Config, ioClient)-> socket = Socket


    it 'generates channel URL according to configuration attirbutes', ->
        url = socket.channelURL('/channel')
        stream = config.get()

        expect(url).toEqual("#{stream.scheme}://#{stream.host}:#{stream.port}/channel")


    it 'connects to server according to generated channel URL', ->
        channel = '/991024775/11188827647'
        stream = config.get()

        socket.connect channel

        expect(io.connect.mostRecentCall.args[0])
            .toEqual("#{stream.scheme}://#{stream.host}:#{stream.port}#{channel}")


    it 'establishes a connection when first initialized', ->
        expect(io.connect).toHaveBeenCalled()
        expect(io.connect.calls.length).toEqual 1


    it 'establishes a connection to a channel using open(...)', ->
        expect(socket.open('/channel')).not.toBeNull()
        expect(io.connect.calls.length).toEqual 2

        stream = config.get()
        channel_url = "#{stream.scheme}://#{stream.host}:#{stream.port}/channel"

        expect(io.connect.mostRecentCall.args[0]).toEqual channel_url


    it 'closes channel connections', ->
        channel = '/some/channel/somewhere'
        connection = socket.open channel, (connection)->
            connection.channel = JMock('channel').andReturn(channel)
            socket.close(connection)
            expect(connection.close).toHaveBeenCalled()


    it "sets channels[]'s main socket on initialization", ->
        expect(socket.channels).not.toBeNull()
        expect(socket.channels.hasOwnProperty('main')).toBeTruthy()
        expect( socket.channels['main'] instanceof IOSocket ).toBeTruthy()


    it 'keeps track of open/closed channels', ->
        channel = '/over/the/hills/and/far/away'
        connection = socket.open channel, (connection)->
            connection.channel = JMock('channel').andReturn(channel)

            expect(socket.channels.hasOwnProperty(channel)).toBeTruthy()
            expect(socket.channels[channel] instanceof IOSocket).toBeTruthy()

            socket.close(connection)
            expect(socket.channels.hasOwnProperty(channel)).toBeFalsy()

