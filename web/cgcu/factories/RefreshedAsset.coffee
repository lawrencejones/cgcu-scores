angular.module('cgcu')
  .factory 'RefreshedAsset', ($http, $rootScope) ->
    class RefreshedAsset

      constructor: (@name, @url, @key, @interval = 10*1000) ->
        @waiters = []
        @registered = []
        @data = null
        do @refresh

      refresh: ->
        _asset = this
        $http({ url: @url, method: 'GET' })
          .success (_data) ->
            _asset.data ?= {}; data = {}
            data[d[_asset.key]] = d for d in _data
            # Formatted data now
            for k in (k for k,v of _asset.data when not data[k])
              d = _asset.data[k]
              _asset.data[k] = null # TODO evaluate performance
            angular.extend _asset.data, data
            setTimeout (-> do _asset.refresh), _asset.interval
            _asset.signal()

      register: (cb) ->
        @get cb
        @registered.push cb
        do @refresh

      signal: ->
        while @waiters.length > 0
          @waiters.pop()?(@data)
        cb?(@data) for cb in @registered
        if !$rootScope.$$phase? then $rootScope.$apply()

      get: (cb) ->
        if not @data?
          @waiters.push cb
        else cb?(@data)



