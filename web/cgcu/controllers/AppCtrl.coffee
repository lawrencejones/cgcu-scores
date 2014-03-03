angular.module('cgcu')
  .controller 'AppCtrl', ($scope) ->

    # Initialise
    console.log 'Init AppCtrl'

    # Parse route
    for r in ['chart', 'scoreboard']
      if r == window.location.hash.slice(2)
        $scope.route = r
    $scope.route ?= 'chart'

    $scope.$watch 'route', (route) ->
      window.location.hash = "/#{route}"





