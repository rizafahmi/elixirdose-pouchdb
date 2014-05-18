# PouchDB: CouchDB Within The Browser

I know CouchDB was build with Erlang. I really like CouchDB because it's fault-tolerant and it's replication and conflict resolution features. Then I discover PouchDB, CouchDB within the web browser! With PouchDB, we enable to store data locally on browser then sync it with CouchDB.

In this article we will dig more about PouchDB and let's see where we will going with this.

## About PouchDB

According to their website, PouchDB was written to help web developer build applications that wor offline as well as they do online. Applications save data locally, so the user can use all the features of an app even when they're offline. Plus, the data is synchronized between clients, so the user has up-to-date data wherever they go.

PouchDB actually written in Javascript, not Erlang. But the API is pretty much the same with CouchDB. 

### Installing PouchDB

First, we need HTML file for this project. Then we download [this script](https://github.com/daleharvey/pouchdb/releases/download/2.2.0/pouchdb-2.2.0.min.js) and then add the script to the HTML file.

  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <title></title>
    <script src="pouchdb-2.2.0.min.js"></script>
  </head>
  <body>
    <h1>Hello nurse!</h1>
  </body>
  </html>

> View on github: index.html
