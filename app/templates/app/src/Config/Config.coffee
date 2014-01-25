fs     = require 'fs'
yamljs = require 'yamljs'
_      = require 'underscore'

class Config

    ###*
     * Create a new Config instance.
     *     here's where the loading of configuration
     *     files from the filesystem takes place.
     *
     * @return {Config}
    ###
    constructor: ->

        settings = yamljs.parse fs.readFileSync "#{__dirname}/../../config/#{process.env.NODE_ENV}.yml"
        defaults  = yamljs.parse fs.readFileSync "#{__dirname}/../../config/default.yml"

        @settings = _.extend defaults ? {}, settings ? {}


    ###*
     * Get all the settings.
     *
     * @return {object}
    ###
    all: -> @settings

    ###*
     * Get a single configuration property.
     * Use dot notation for sub-level properties .
     *
     * @param  {string} path
     * @return mixed
    ###
    get: (path)->

        # return all the settings when no path is specified
        return @all() if not path?

        setting = @settings

        path = path.split '.'

        for prop, i in path

            if value? and i+1 is path.length
                setting[prop] = value

            setting = setting[prop]

        return setting

    ###*
     * Set a value for a configuration.
     * NB: The key's 0 level must initially exist.
     *
     * @param {string}  path
     * @param {mixed}   value
    ###
    set: (path, value)->

        settings = @settings

        path = path.split '.'

        for prop, i in path

            if value? and i+1 is path.length
                settings[prop] = value

            settings = settings[prop]

module.exports = (app)-> app.factory 'Config', -> new Config