'use strict'

class <%= provider %>

    ###*
     * This method is used by Angular to inject dependencies
     * into this provider which in turn will be used
     * to be injected into the constructor.
     *
     * @param  {Config} Config
     * @return {<%= provider %>}
    ###
    @$get: (Config)-> new this(Config)

    ###*
     * Create a new <%= provider %> instance.
     *
     * @param  {Config} Config
     * @return {<%= provider %>}
    ###
    constructor: (@Config)->

<%= provider %>.$inject = ['Config']

module.exports = (app)->
    # bring in dependencies
    require('Config')(app)

    # register
    app.provider '<%= provider %>', -> <%= provider %>
