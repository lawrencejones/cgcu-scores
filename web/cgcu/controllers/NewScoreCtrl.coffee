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


