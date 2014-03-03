angular.module('cgcu')
  .controller 'ScoreboardCtrl', ($scope, User) ->
    console.log 'Scoreboard Ctrl'
  
    usersCache = {}
    $scope.orderedUsers = ->
      if usersCache[$scope.users]?
        return usersCache[$scope.users]
      unreg = $scope.$watch $scope.users, (u, _u) ->
        usersCache[_u] = null
        unreg()

      users = ({login:l, points:p} for l,p of $scope.users).sort (a,b) ->
        b.points - a.points
      usersCache[$scope.users] = users

    User.get (users) ->
      $scope.users = users
