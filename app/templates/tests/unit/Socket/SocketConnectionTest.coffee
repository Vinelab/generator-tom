'use strict'

SocketConnection = require('src/Socket/SocketConnection')

describe 'SocketConnection', ->

    J = jasmine
    JMock = J.createSpy

    beforeEach module '<%= name %>'

    socket = {}
    scope = {}

    beforeEach inject ($rootScope)->
        scope = $rootScope.$new()
        # mock the $apply function
        scope.$apply = JMock('$apply')

        socket =
            name: '/my/channel'
            on: JMock('on').andCallFake (event, callback)=> callback()
            emit: JMock('emit').andCallFake (event, data, callback)=> callback()
            disconnect: JMock('disconnect')

    it 'binds a message and a callback to the socket, wrapping the callback with $scope.$apply', ->
        connection = new SocketConnection scope, socket

        callback = -> 'on callback'
        connection.on 'message', callback

        expect(socket.on).toHaveBeenCalled()
        expect(scope.$apply).toHaveBeenCalled()

    it 'emits a message wrapping its callback inside a $scope.$apply', ->
        connection = new SocketConnection scope, socket

        callback = -> 'emit callback'
        connection.emit 'message', {my: 'data'}, callback

        expect(socket.emit).toHaveBeenCalled()
        expect(scope.$apply).toHaveBeenCalled()

    it 'returns the channel name', ->
        connection = new SocketConnection scope, socket
        expect(connection.channel()).toBe('/my/channel')

    it 'closes', ->
        connection = new SocketConnection scope, socket
        connection.close()
        expect(socket.disconnect).toHaveBeenCalled()