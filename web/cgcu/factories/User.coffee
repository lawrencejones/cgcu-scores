angular.module('cgcu')
  .factory 'User', (RefreshedAsset) ->
    class User extends RefreshedAsset
    new User 'User', '/api/users', 'login', 10*1000

