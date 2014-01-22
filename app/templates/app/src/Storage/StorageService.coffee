"use strict"

class StorageService

    ###*
     * Put an item in storage.
     *
     * @param  {string} key
     * @param  {string} value
    ###
    put: (key, value)-> localStorage.setItem(key, value)

    ###*
     * Get an item from storage.
     *
     * @param  {string} key
     * @return {string}
    ###
    get: (key)-> localStorage.getItem key

    ###*
     * Flush storage.
    ###
    clear: -> localStorage.clear()

module.exports = (app)-> app.factory 'StorageService', -> new StorageService