'user strict'

CDN = require('CDN')()

describe 'CDN', ->

    J = jasmine
    JMock = J.createSpy

    beforeEach module '<%= name %>'


    it 'loads the corresponding CDN url according to the specified endpoint', ->
        config = get: JMock('get').andReturn('http://test.service.url')

        CDN.Config = config

        url = CDN.url('whateva', 'page.html')

        expect(url).toBe 'http://test.service.url/page.html'
        expect(config.get).toHaveBeenCalledWith('cdn.whateva')


    it 'falls back to URL when the specified CDN endpoint is not found', ->
        config = get: JMock('get').andCallFake (param)->
            return 'http://test.service.url' if param is 'cdn.url'

        CDN.Config = config

        url = CDN.url('something', 'main.html')

        expect(url).toBe 'http://test.service.url/main.html'
        expect(config.get).toHaveBeenCalledWith('cdn.url')


    it 'loads js endpoint', ->
        config = get: JMock('get').andReturn('http://js.service.url')

        CDN.Config = config

        url = CDN.js('app.js')

        expect(url).toBe 'http://js.service.url/app.js'
        expect(config.get).toHaveBeenCalledWith('cdn.js')


    it 'loads css endpoint', ->
        config = get: JMock('get').andReturn('http://css.service.url')

        CDN.Config = config

        url = CDN.css('style.css')

        expect(url).toBe 'http://css.service.url/style.css'
        expect(config.get).toHaveBeenCalledWith('cdn.css')


    it 'loads img endpoint', ->
        config = get: JMock('get').andReturn('http://img.service.url')

        CDN.Config = config

        url = CDN.img('logo.png')

        expect(url).toBe 'http://img.service.url/logo.png'
        expect(config.get).toHaveBeenCalledWith('cdn.img')


    it 'loads template (html) endpoint', ->
        config = get: JMock('get').andReturn('http://html.service.url')

        CDN.Config = config

        url = CDN.template('navbar.html')

        expect(url).toBe 'http://html.service.url/navbar.html'
        expect(config.get).toHaveBeenCalledWith('cdn.html')


    it 'returns all the endpoints', ->
        endpoints = {
            url: 'http://url.service.url'
            html: 'http://html.service.url'
            css: 'http://css.service.url'
            js: 'http://js.service.url'
            img: 'http://images.service.url'
        }

        config = get: JMock('get').andReturn endpoints

        CDN.Config = config

        expect(CDN.endpoints()).toBe endpoints