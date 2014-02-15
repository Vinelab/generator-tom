App = angular.module('CleanAndClear', ['ngRoute'])

require('MainController')(App)

require('filters')(App)
require('routes')(App)