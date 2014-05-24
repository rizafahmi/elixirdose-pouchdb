# PouchDB: CouchDB Within The Browser

I know CouchDB was build with Erlang. I really like CouchDB. It's new breed of database: document database,
it's fault-tolerant (thanks to Erlang VM), replication and conflict resolution features. What's not to love?!
Then I discover PouchDB, CouchDB within the web browser! With PouchDB, we enable to store data locally on browser then sync it with CouchDB.
Even better!

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
      <h1>Hello PouchDB!</h1>
    </body>
    </html>

> View on github: index.html

One more file we need is `app.js` for us to play around. We will write Javascript
inside this file. And to serve this html and javascript files, we need a simple web server. I usually used
`pyhton -m SimpleHTTPServer` command line, but let's use one of Elixir's web framework
for this purpose. Let's pick [Sugar](http://sugar-framework.github.io/) for no reason :)
Ok, this is the reason, recently Sugar release new version and it's catch my attention
so let's go with Sugar.

    $> mix new sugar_pouchdb
    $> cd sugar_pouchdb
    $> # Add '{:sugar, github: "sugar-framework/sugar"}'
    $> # to your deps
    $> vim mix.exs
    $> # Get dependencies and compile them
    $> mix do deps.get, deps.compile

    $> # Add your Sugar files
    $> mix sugar.init

    $> # Start your server
    $> mix server

That's pretty much it! Now enter `http://localhost:4000` on your browser. If you
see "Hello world" then you good to go. One more step
we need are copying `pouchdb-2.2.0.min.js` and `index.html` we created earlier to
`priv/www` directory. Then restart the web server. Then go to localhost:8080 once again.

From now on, we leave the server-side world and journey to client-side world. Be prepare....

> Warning: we will use javascript a lot from now on, I hope you love Javascript :)


### Trying PouchDB

Now open up `app.js` and start writing Javascript. First, we need to define a new
database. We called it `diaries`, since we want to create 5 senses diary similar to
we create when trying out Dynamo in [this article](http://www.elixirdose.com/brief-introduction-to-elixir-web-framework-dynamo/).

    var db = new PouchDB('diaries');

> View in github: app.js

Then we add one or more entries to the database.

    // Generate uuid for id
    var uuid = PouchDB.utils.uuid();

    var diary1 = {
      _id: uuid,
      title: "Riding a motorcycle",
      sight: 8,
      touch: 7,
      smell: 3,
      sound: 10,
      taste: 2
    };

    db.put(diary1);

> View in github: app.js

Then we can start getting data. You can use `db.get()` or `db.query()`. `db.get()`
need `_id` to retrieve data. If you want to get all data, use `db.query()`.
If you familiar with couchdb, you'll know what we will do next: create custom view.
CouchDB need to have a view to get the data. It's written in Javascript. So let's have
one. We will create a view that will get all data if the document have title. If
document doesn't have a title, it will not show.

    function map(doc){
      if (doc.title){
        emit(doc._id, doc);
      }
    }

Then run the query and print it on Javascript console.

    db.query({map: map}, {reduce: false}, function(err, response){
      console.log(response);
    });

The response should look like this:

    {
      "offset" : 0,
        "rows": [{
          "id": "95C19ED6-5BEC-628F-A9A6-0FCFAC6C2C31",
          "key": "95C19ED6-5BEC-628F-A9A6-0FCFAC6C2C31",
          "value": {
            _id: "95C19ED6-5BEC-628F-A9A6-0FCFAC6C2C31",
            _rev: "1-594d21315d51b8e69da9b5990807a6f6",
            sight: 8,
            smell: 0,
            sound: 1,
            taste: 2,
            title: "Reading email",
            touch: 5
          }
        }, {
          "id": "CA4A509F-E866-899A-83FA-E023364A4012",
          "key": "CA4A509F-E866-899A-83FA-E023364A4012",
          "value": {
            _id: "CA4A509F-E866-899A-83FA-E023364A4012",
            _rev: "1-0eff5a5ddf3a09103732c384371ab0c4",
            sight: 8,
            smell: 3,
            sound: 10,
            taste: 2,
            title: "Riding a motorcycle",
            touch: 7
          }
        }],
      total_rows: 2
    }

### Sync With CouchDB

Things get interesting when we able to sync to and from CouchDB. And more interesting
part is doing that very easy with PouchDB. Before we doing anything interesting,
make sure you have CouchDB installed on your localhost and setting up correctly.
Do this in your terminal:

    $> curl http://localhost:5984 -k
    {"couchdb":"Welcome","uuid":"ce0f54bc27dba624e4c9a2311c2cf733","version":"1.3.1","vendor":{"version":"1.3.1","name":"The Apache Software Foundation"}}

Or you can always use service such as [iriscouch.com](http://www.iriscouch.com).
Now let's open CouchDB's Futon admin site [http://localhost:5984/_utils/index.html](http://localhost:5984/_utils/index.html) and
make sure you didn't have database named `diaries`.

Type this at the end of our `app.js`.

    db.sync("http://localhost:5984/diaries"); // Or if you use iriscouch "http://username:password@mysubdomain.iriscouch.com"

If you open Javascript console then refresh your browser, you'll see the sync process.
After the sync process finished, reopen Futon and now you'll find `diaries` database.
Click it to open and view the data. In `diary` database on CouchDB you'll find
exactly the same data we found in PouchDB in our browser! Now let's create a new
document from CouchDB Futon then hit "Save Document". When we browse `diaries`
database on CouchDB, we will find three data, right?! But the data on PouchDB still
two. Before we revisit our site, please remove or comment `db.put()` line so
when we refresh our browser it will not create a new document.

When we refresh our browser now, it will sync once again.... And viola! Your data
is synced again! It feels like magic!

Let's do one more magic. We want auto sync every, let's say 2 seconds so we didn't
have to sync manually. Easy enough, add `setInterval()` around sync function.

    setInterval(function(){
      db.sync("http://localhost:5984/diaries");
    }, 2000);

Now when we add document in PouchDB or in CouchDB, it will be synced automatically.
Cool, right?!




Let's make it cooler with DOM manipulation. We print out the total of
documents in the HTML so we don't have to do it on Javascript console. To do this
we need help from another library: [jQuery](http://www.jquery.com/). I bet you know
all about this. Just add jquery to our `index.html` and start typing code below:

    <h2>Total documents: <span id="totalDocs">0</span></h2>
    <script src="http://code.jquery.com/jquery-2.1.1.min.js"></script>

> View on github: index.html

    function syncDB(){

      db.sync("http://localhost:5984/diaries");

      db.info(function(error, info) {
        $("#totalDocs").html(info.doc_count);
      });

      }setInterval(function(){
        syncDB();
    }, 2000);

> View on github: app.js

Refresh your browser, viola! Now your browser shows how many documents saved.
Let's add one more document from Couchdb Futon. When you save, wait for about
two seconds and our browser will show you how many documents we have after synced.


End of part one
