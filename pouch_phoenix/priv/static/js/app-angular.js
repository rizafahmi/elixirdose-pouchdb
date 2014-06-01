
var app = angular.module('pouchApp', []);

app.service('diariesService', function() {
  var db = new PouchDB('diaries');
  this.getDiaries = function() {
    db.sync("http://localhost:5984/diaries");

  };
});

app.controller('diariesController', function($scope, diariesService) {
  function init() {
    $scope.diaries = diariesService.getDiaries();
  }

  init();
});

