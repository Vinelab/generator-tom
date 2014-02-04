'use strict'
<% if (controller) { %>
class <%= controller %>

    ###*
     * Create a new <%= controller %> instance
     *
     * @param  {Config/Config} Config
     * @param  {$scope} $scope
     * @return {<%= controller %>}
    ###
    constructor: (@Config, @$scope)->


# inject controller dependencies
<%= controller %>.$inject = ['Config', '$scope']
<% } %>
module.exports = (app)-> app.directive '<%= directive %>', ->

    {
        restrict: '<%= restrict %>'
        <% if (transclude) { %>transclude: yes<% } %>
        <% if (templateUrl) { %>templateUrl: '<%= templateUrl %>'<% } else { %>template: ''<% } %>
        <% if (controller) { %>controller: <%= controller %>
        <% } else { %>scope:{ },
        link: (scope, element, attrs)-><% } %>
    }