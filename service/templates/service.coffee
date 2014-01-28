'use strict'

class <%= service %>

    ###*
     * Create a new <%= service %> instnace.
     *
     * @param  {$window} $window
     * @return {<%= service %>}
    ###
    constructor: (@$window)->

<%= service %>.$inject = ['$window']

module.exports = (app)-> app.service '<%= service %>', <%= service %>