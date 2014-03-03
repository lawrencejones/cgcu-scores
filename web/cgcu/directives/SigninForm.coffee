angular.module('cgcu').directive 'signinForm', ->
  restrict: 'A'
  link: ($scope, $elem, attr) ->
    $elem.find('button:eq(0)').click ->
      $.ajax
        url: '/login'
        method: 'POST'
        data:
          login: $elem.find('input[name=login]').val()
          pass: $elem.find('input[name=pass]').val()
        success: (user) ->
          sessionStorage.uid = user._id
          window.location.href = '/'
          if not $scope.$$phase? then $scope.$apply()
        error: ->
          $elem
            .find('button.btn.btn-block')
            .removeClass('btn-primary')
            .addClass('btn-warning')
            .text 'Invalid login, try again'
