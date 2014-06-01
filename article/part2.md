# PouchDB Part 2

This week we will continue our journey into PouchDB world. In last article we cover
PouchDB usage and how to synced it with CouchDB on the server then shows total
documents available using jQuery. Now let's go further pick one of JavaScript
framework and use it with PouchDB to display our documents.

## Short Intro To AngularJS

[AngularJS](http://angularjs.org) is great framework to start with. It suit me and suit this project because
it is fully extensible and one of the easier to start with. Let's the code talk.
First of all, let's create one html file for this purpose with `angular.js` script
loaded at the end of body tag.

    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>AngularJS Meet PouchDB</title>
    </head>
    <body>
      <h1>Hello Angular!</h1>

      <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.16/angular.min.js">
    </body>
    </html>

> View on github

Don't forget to add route to this page in `lib/pouch_phoenix/router.ex` file and
also edit our controller to accomodate the changes.

  get "/angular/", PouchPhoenix.Controllers.Pages, :angular

> View on github

Before we open the page in browser, let's add `ng-app` at the top of the page
as the way to remark the html file as angular view. Meanwhile, we add a simple
angular data binding to eval `1 +1`. Then if you run in your browser and see the
result `2` that mean our angular run just fine.


    <!DOCTYPE html>
    <html lang="en" ng-app>
    <head>
      <meta charset="UTF-8">
      <title>AngularJS Meet PouchDB</title>
    </head>
    <body>
      <h1>Hello Angular!</h1>
      <p>{{1+1}}</p>

      <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.16/angular.min.js">
    </body>
    </html>

> View on github

[screenshot]

Ok, so far we doing great! Now let's create table to present our documents.


    <!DOCTYPE html>
    <html lang="en" ng-app>
    <head>
      <meta charset="UTF-8">
      <title>AngularJS Meet PouchDB</title>
    </head>
    <body>
      <h1>Five Senses Diary</h1>
      <table>
        <th>
          <td>Title</td>
          <td>Sight</td>
          <td>Smell</td>
          <td>Sound</td>
          <td>Taste</td>
          <td>Touch</td>
        </th>
        <tr>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
      </table>

      <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.16/angular.min.js">
    </body>
    </html>

> View on github

Now let's inject dummy data using `ng-init` then display it on the table using
`ng-repeat`.


    <!DOCTYPE html>
    <html lang="en" ng-app>
    <head>
      <meta charset="UTF-8">
      <title>AngularJS Meet PouchDB</title>
    </head>
    <body ng-init="diaries=['Entry #1', 'Entry #2']">
      <h1>Five Senses Diary</h1>
      <table>
        <th>
          <td>Title</td>
          <td>Sight</td>
          <td>Smell</td>
          <td>Sound</td>
          <td>Taste</td>
          <td>Touch</td>
        </th>
        <tr ng-repeat="diary in diaries">
          <td>{{diary}}</td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
      </table>

      <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.16/angular.min.js">
    </body>
    </html>

> View on github

Then you'll see `Entry #1` and `Entry #2` in browser. It's time to connect to pouchDB by
re-adding pouchDB script and add new javascript file for our playing ground.

    <script src="/static/js/pouchdb-2.2.0.min.js"></script>
    <script src="/static/js/app-angular.js"></script>
> View on github

Open up `app-angular.js` add angular module so we can connect
between view(html) and controller(javascript).

    var app = angular.module('pouchApp', []);

    app.controller('diariesController', function($scope) {
      $scope.diaries = [
        {"id": 1, "title": "Entry #1"},
        {"id": 2, "title": "Entry #2"}
      ];
    }

> View on github

After that, open our html file then add `pouchApp` module in `ng-app` so it'll connect.
And also remove `ng-init` then replace it with `ng-controller`.


    <!DOCTYPE html>
    <html lang="en" ng-app="pouchApp">
    <head>
      <meta charset="UTF-8">
      <title>AngularJS Meet PouchDB</title>
    </head>
    <body ng-controller="diariesController">
      <h1>Five Senses Diary</h1>
        <table>
          <th>
            <td>Title</td>
            <td>Sight</td>
            <td>Smell</td>
            <td>Sound</td>
            <td>Taste</td>
            <td>Touch</td>
          </th>
          <tr ng-repeat="diary in diaries">
            <td>{{diary}}</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
          </tr>
        </table>

      <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.16/angular.min.js"></script>
      <script src="/static/js/pouchdb-2.2.0.min.js"></script>
      <script src="/static/js/app-angular.js"></script>
    </body>
    </html>
