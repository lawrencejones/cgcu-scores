angular.module('cgcu')
  .factory 'Dept', (RefreshedAsset) ->
    class Dept extends RefreshedAsset
    new Dept 'Dept', '/api/dept', 'name', 20*1000
