'use strict'
<% if (controller) { %>
class <%= controller %>

    ###*
     * Create a new <%= controller %> instance
     *
     * @param  {Config/Config} Config
     * @param  {$scope} $scope
     * @param  {$element} $element
     * @param  {$attrs} $attrs
     * @return {<%= controller %>}
    ###
    constructor: (@Config, @$scope, @$element, @$attrs)->


# inject controller dependencies
<%= controller %>.$inject = ['Config', '$scope', '$element', '$attrs']
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