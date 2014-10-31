'use strict'

###*
 # @ngdoc overview
 # @name programClickerApp
 # @description
 # # programClickerApp
 #
 # Main module of the application.
###
angular
  .module('programClickerApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch'
  ])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
