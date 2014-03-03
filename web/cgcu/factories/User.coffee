angular.module('cgcu')
  .factory 'User', (RefreshedAsset) ->
    class User extends RefreshedAsset
    new User 'User', '/users', 'login', 10*1000

