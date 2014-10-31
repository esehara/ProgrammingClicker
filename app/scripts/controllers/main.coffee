'use strict'

###*
 # @ngdoc function
 # @name programClickerApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the programClickerApp
###
INIT_MONEY = 5
COST_BOOK = 10
COST_PC = 50

class GameLoop
  constructor: ($scope) ->
    @scope = $scope
  
  main: () ->
    @scope.player.bugPenalty()

class Book
  constructor: () ->
    @reading = 0
    @knowledge = Probability.setknowledgeToBook()

  getknowledge: () ->
    @knowledge
    
  read: () ->
    @reading += Probability.readBook()

  done: () ->
    @reading > 100

class PC
  constructor: () ->
    @level = 1
 
  basecost: COST_PC

  cost: () ->
    this.basecost * (1 + (@level * 0.25))

  upgrade: () ->
    @level += 1

class Probability
  @includeBug: () ->
    Math.random() < 0.1

  @successDebug: () ->
    Math.random() < 0.3

  @knowfromInternet: () ->
    Math.random() < 0.3

  @setknowledgeToBook: () ->
    Math.floor(Math.random() * 10 + 5)

  @readBook: () ->
    Math.floor(Math.random() * 10 + 5)

  @knowfromCoding: () ->
    Math.random() < 0.1

class Bug
  constructor: () ->
    @bug = 0

  addBug: () ->
    @bug += 1

  fixBug: () ->
    @bug -= 1
    if @bug < 0
      @bug = 0

  bugPenalty: () ->
    if @bug < 1
      return 0
    Math.pow(@bug, @bug) / Math.pow(10, @bug)

class Brain
  constructor: () ->
    @knowledge = 0
    @readbook = null

  salary: (mul_bonus) ->
    (@knowledge / 100) * mul_bonus

  knowfromInternet: () ->
    if Probability.knowfromInternet()
      @knowledge += 1

  knowfromBook: () ->
    if @readbook?
      @readbook.read()
      if @readbook.done()
        @knowledge += @readbook.getknowledge()
        @readbook = null
    else
      @readbook = new Book()
      @readbook.read()
        
  knowfromCoding: () ->
    if Probability.knowfromCoding()
      @knowledge += 1
  
class Player
  constructor: () ->
    @currentMoney = INIT_MONEY
    @bug = new Bug()
    @brain = new Brain()
    @pc = new PC()

  roundMoney: () ->
    @currentMoney *= 100
    @currentMoney = Math.round(@currentMoney)
    @currentMoney /= 100

  fixMoney: () ->
    if @currentMoney < 0
      @currentMoney = 0

  coding: () ->
    @currentMoney += @brain.salary(@pc.level)
    if Probability.includeBug()
      @bug.addBug()
    @brain.knowfromCoding()
    this.roundMoney()

  debug: () ->
    if Probability.successDebug()
      @bug.fixBug()

  bugPenalty: () ->
    @currentMoney -= @bug.bugPenalty() 
    this.roundMoney()
    this.fixMoney()

  buyBook: () ->
    if @brain.readbook
      @brain.knowfromBook()
    else if @currentMoney > COST_BOOK
      @currentMoney -= COST_BOOK
      this.roundMoney()
      @brain.knowfromBook()

  buyPC: () ->
    if @currentMoney > @pc.cost()
      @currentMoney -= @pc.cost()
      this.roundMoney()
      @pc.level = @pc.upgrade()
  
  canBuyBook: () ->
    @currentMoney > COST_BOOK || @brain.readbook

  canShowPC: () ->
    this.canBuyPC() || (@pc.level > 1)

  canBuyPC: () ->
    @currentMoney > @pc.cost()
  
angular.module('programClickerApp')
  .controller 'MainCtrl', ['$scope', '$interval', ($scope, $interval) ->
    $scope.player = new Player()
    gameloop = new GameLoop($scope)
    setInterval(() ->
      gameloop.main()
      $scope.$apply()
    , 1000)
    $scope.doCoding = () -> $scope.player.coding()
    $scope.doDebug  = () -> $scope.player.debug()
    $scope.doKnowfromInternet = () -> $scope.player.brain.knowfromInternet()
    $scope.doKnowfromBook = () -> $scope.player.buyBook()
    $scope.doBuyPC = () -> $scope.player.buyPC()
    ]    
