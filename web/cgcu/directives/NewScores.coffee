angular.module('cgcu')
  .directive 'newScoreTrigger', ($modal, $rootScope) ->
    restrict: 'AC'
    link: ($scope, $elem, attr) ->
      $elem.click ->
        $rootScope.$modal = $modal
          template: '/partials/score-modal'
