angular.module('cgcu')
  .controller 'NewScoreCtrl', ($scope, User, Dept) ->

    console.log 'Init NewScoreCtrl'

    angular.extend $scope, {
      stage: 'score'
      scores: [1..5].map (s) -> 10*s
      depts: Dept.data
      input:
        score: 0, login: '', dept: ''
    }

    $scope.setScore = (score) ->
      $scope.input.score = parseInt score, 10
      $scope.stage = 'dept'

    $scope.setDept = (dept) ->
      $scope.input.dept = dept.name
      $scope.stage = 'login'

    $scope.submit = ->
      console.log 'Submitting new score'
      $.ajax
        url: '/api/score'
        method: 'POST'
        data: $scope.input
        success: (data) ->
          if $scope.$modal then $scope.$modal.hide()
          User.refresh()
          Dept.refresh()


