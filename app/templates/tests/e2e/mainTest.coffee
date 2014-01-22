'use strict'

describe 'Main Page', ->

    host = 'http://localhost:9000/#'

    beforeEach ->
        browser.get host

    it 'should have the h1 present with a Welcome! message', ->
        expect(element(`by`.binding('message')).getText()).toEqual 'Welcome!'