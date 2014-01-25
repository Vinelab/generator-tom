'use strict'

class StorageService

    ###*
     * Create a new StorageService instnace.
     *
     * @param  {$window} $window
     * @return {StorageService}
    ###
    constructor: (@$window)->

    ###*
     * Put an item in storage.
     *
     * @param  {string} key
     * @param  {mixed} value
    ###
    put: (key, value)->
        mapped = JSON.stringify {_v: value}
        @$window.localStorage.setItem(key, mapped)

    ###*
     * Get an item from storage.
     *
     * @param  {string} key
     * @return {mixed}
    ###
    get: (key)->
        value = @$window.localStorage.getItem key
        # reduce stored value
        return JSON.parse(value)?._v

    ###*
     * Flush storage.
    ###
    flush: -> @$window.localStorage.clear()

StorageService.$inject = ['$window']

module.exports = (app)-> app.service 'StorageService', StorageService