'use strict'

describe 'Controller: MainCtrl', ->

  # load the controller's module
  beforeEach module 'programClickerApp'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl', {
      $scope: scope
    }

  it 'is running test', ->
    expect(1).toBe 1
