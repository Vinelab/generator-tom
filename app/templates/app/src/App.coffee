App = angular.module('<%= name %>', ['ngRoute'])

require('MainController')(App)

require('filters')(App)
require('routes')(App)