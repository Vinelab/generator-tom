'use strict'

Config = require('Config')()

class CDN

    ###*
     * Expose Config to class methods
     *
     * @type {Config}
    ###
    @Config: Config

    ###*
     * Generate the url according to the type
     * of CDN and fallback to 'cdn.url' when not found
     *
     * @param  {string} type The CDN type (may be specified in dot notation)
     * @param  {string} uri
     * @return {string}      Fully qualified domain name
    ###
    @url: (type, uri)->

        if @Config.get("cdn.#{type}")
            url = @Config.get("cdn.#{type}")
        else
            url = if @Config.get('cdn.url')? then @Config.get('cdn.url') else ''

        return "#{url}/#{uri}"

    ###*
     * Generate a URL using the Javascript CDN
     *
     * @param  {string} uri
     * @return {string}
    ###
    @js: (uri)-> @url 'js', uri

    ###*
     * Generate a URL using the CSS CDN
     *
     * @param  {string} uri
     * @return {string}
    ###
    @css: (uri)-> @url 'css', uri

    ###*
     * Generate a URL using the images CDN
     *
     * @param  {string} uri
     * @return {string}
    ###
    @img: (uri)-> @url 'img', uri

    ###*
     * Generate a URL for a tempalte
     *
     * @param  {string} uri
     * @return {string}
    ###
    @template: (uri)-> @url 'html', uri

    ###*
     * Get all CDN endpoints
     *
     * @return {mixed}
    ###
    @endpoints: -> @Config.get('cdn')

CDN.$inject = ['Config']

module.exports = (app)->

    Config = require('Config')(app)
    # whitelist cdn endpoints
    app.config ['$sceDelegateProvider', ($sceDelegateProvider)->

        endpoints = Config.get('cdn')
        cdn = ['self']

        cdn.push("#{endpoints.url}/**")  if endpoints.url?
        cdn.push("#{endpoints.html}/**") if endpoints.html?
        cdn.push("#{endpoints.css}/**")  if endpoints.css?
        cdn.push("#{endpoints.js}/**")   if endpoints.js?
        cdn.push("#{endpoints.img}/**")  if endpoints.img?

        $sceDelegateProvider.resourceUrlWhitelist(cdn)
    ]

    app.service 'CDN', -> CDN
    # make class available through 'require'
    return CDN