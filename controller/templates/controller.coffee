"use strict"

class <%= controller %>

    ###*
     * Create a new <%= controller %> instance
     *
     * @param  {Config/Config} Config
     * @param  {$scope} $scope
     * @param  {$location} $location
     * @return {<%= controller %>}
    ###
    constructor: (@Config, @$scope, @$location)->

# inject controller dependencies
<%= controller %>.$inject = ['Config', '$scope', '$location']

module.exports = (app)->
    # bring in dependencies
    require('src/Config/Config')(app)

    # register
    app.controller '<%= controller %>', <%= controller %>