
var app = angular.module('pouchApp', []);

app.controller('diariesController', function($scope) {
  $scope.diaries = [
    {"id": 1, "title": "Entry #1"},
    {"id": 2, "title": "Entry #2"}
  ];
});
