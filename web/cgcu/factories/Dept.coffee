angular.module('cgcu').service 'Dept', ($http, $rootScope) ->
  INTERVAL = 5000
  waiters = []
  _dept = new class Dept

    constructor: ->
      do @refresh

    depts: null

    get: (cb) ->
      if not @depts?
        waiters.push cb
      else cb @depts
      
    refresh: ->
      console.log 'Fetching depts'
      $http({
        url: '/api/dept'
        method: 'GET'
      }).success (data) ->
        depts = {}
        depts[d.name] = d for d in data
        if not _dept.depts?
          _dept.depts = depts
        else
          for n,d of depts
            _dept.depts[n] ?= d
            _dept.depts[n].score = d.score
        if !$rootScope.$$phase then $rootScope.$apply()
        cb?(_dept.depts) for cb in waiters
        setTimeout (-> do _dept.refresh), INTERVAL

    
