angular.module('cgcu')
  .controller 'ScoreboardCtrl', ($scope, User, Dept) ->
    console.log 'Scoreboard Ctrl'
  
    usersCache = {}
    $scope.orderedUsers = ->
      return {} if not $scope.users?
      if usersCache[$scope.users]?
        return usersCache[$scope.users]
      unreg = $scope.$watch $scope.users, (u, _u) ->
        usersCache[_u] = null
        unreg()

      users = ({login:l, points:u.points} for l,u of $scope.users)
        .sort (a,b) ->
          b.points - a.points
      console.log users
      usersCache[$scope.users] = users

    User.register (users) ->
      $scope.users = users
