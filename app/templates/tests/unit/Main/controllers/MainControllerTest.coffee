'use strict'

describe 'Main: MainController', ->

    # load the app
    beforeEach module 'MaxwellHouse'

    # prepare controller and scope
    MainController = {}
    scope = {}

    beforeEach inject ($controller, $rootScope)->

        scope = $rootScope.$new();

        MainController = $controller('MainController', {
            $scope: scope
        })

    it 'should expose greeting message to scope', ->
        expect(scope.message).toEqual('Welcome!')