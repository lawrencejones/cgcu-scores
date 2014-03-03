angular.module('cgcu').service 'User', ($http, $rootScope) ->

  waiters = []
  INTERVAL = 60*1000
  _user = new class User

    users: null
    constructor: ->
      console.log 'Fetching users'
      do @refresh

    refresh: ->
      $http({
        url: '/users'
        method: 'GET'
      }).success (data) ->
        users = {}
        users[u.login] = u.points for u in data
        if not _user.users?
          _user.users = users
        else
          for l,s of users
            _user.users[l] = s
        if !$rootScope.$$phase? then $rootScope.$apply()
        cb?(_user.users) for cb in waiters
        setTimeout (-> do _user.refresh), INTERVAL


    get: (cb) ->
      if not @users?
        waiters.push cb
      else cb @users
      

    
