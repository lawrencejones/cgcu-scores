angular.module('cgcu').service 'Dept', ($http, $rootScope) ->
  INTERVAL = 5000
  _dept = new class Dept
    depts: {}
    constructor: ->
      do @refresh
    refresh: ->
      console.log 'Fetching depts'
      $http({
        url: '/api/dept'
        method: 'GET'
      }).success (data) ->
        depts = {}
        depts[d.name] = d for d in data
        for n,d of depts
          _dept.depts[n] ?= d
          _dept.depts[n].score = d.score
        if !$rootScope.$$phase then $rootScope.$apply()
        setTimeout (-> do _dept.refresh), INTERVAL

    
angular.module('cgcu')
  .controller 'NewScoreCtrl', ($scope, Dept) ->

    console.log 'Init NewScoreCtrl'

    angular.extend $scope, {
      stage: 'score'
      scores: [1..5].map (s) -> 10*s
      depts: Dept.depts
      input:
        score: 0, login: '', dept: ''
    }

    $scope.setScore = (score) ->
      $scope.input.score = parseInt score, 10
      $scope.stage = 'dept'

    $scope.setDept = (dept) ->
      $scope.input.dept = dept
      $scope.stage = 'login'

    $scope.submit = ->
      console.log 'Submitting new score'
      console.log $scope.input

