# PouchDB: CouchDB Within The Browser

I know CouchDB was built with Erlang. I really like CouchDB. It's new breed of document-based database, fault-tolerant (thanks to Erlang VM), and with replication and conflict resolution features. What's not to love?!

Then I discovered PouchDB, CouchDB within the web browser! With PouchDB, we are able to store data locally in browser and then sync it with CouchDB. Even better!

In this article, we will dig more into PouchDB and see where we can go with it.

## About PouchDB

According to [their website](http://pouchdb.com), PouchDB was written to help web developers build applications that work as well offline as they do online. Applications save data locally, so the user can use all the features of an app even when they're offline. Plus, the data is synchronized between clients, so the user has up-to-date data wherever they go.

PouchDB is actually written in Javascript, not Erlang. But the API is pretty much the same with CouchDB.

### Installing Phoenix Web Framework

To serve html and javascript files, we need a simple web server or web framework. I usually use the `python -m SimpleHTTPServer` command line, but let's use one of Elixir's web frameworks for this purpose. We'll pick [Phoenix](https://github.com/phoenixframework/phoenix) for no reason. :)

    $> git clone https://github.com/phoenixframework/phoenix.git && cd phoenix && mix do deps.get, compile
    $> mix phoenix.new pouch_phoenix ../pouch_phoenix
    $> cd ../pouch_phoenix
    $> mix do deps.get, compile
    $> mix phoenix.start

That's pretty much it! Now enter `http://localhost:4000` on your browser. If you see "Hello world", then you're good to go.

### Installing PouchDB And Phoenix

First, we need an HTML file for this project. Download [this script](https://github.com/daleharvey/pouchdb/releases/download/2.2.0/pouchdb-2.2.0.min.js) and then add it to the HTML file.

    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title></title>
      <script src="/static/pouchdb-2.2.0.min.js"></script>
      <script src="/static/app.js"></script>
    </head>
    <body>
      <h1>Hello PouchDB!</h1>
    </body>
    </html>

> View on github: index.html

One more step we need is copying `pouchdb-2.2.0.min.js` to the `priv/static/js` folder, and `index.html` to the `priv/views` folder. You need to create the `views` directory first. The last step we need to do is edit the controller to load our html file.

    defmodule PouchPhoenix.Controllers.Pages do
      use Phoenix.Controller

      def index(conn) do
        html conn, File.read!(Path.join(["priv/views/index.html"]))
      end
    end

Restart the web server. Go to localhost:4000 once again. You should see our html load just fine.

One more file we need is `app.js` to play around with. We will write Javascript inside this file. Create the file and put it in `priv/static/js` folder.

From now on, we leave and say goodbye to the server-side world and journey client-side. Be prepared...

> Warning: we will use javascript a lot from now on, I hope you love Javascript :)


### Trying PouchDB

Now open up `app.js` and start writing Javascript. First, we need to define a new database. We call it `diaries`, since we want to create a five senses diary similar to what we created when trying out Dynamo in [this article](http://www.elixirdose.com/brief-introduction-to-elixir-web-framework-dynamo/).

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

Now we can start getting data. You can use `db.get()` or `db.query()`. `db.get()` needs `_id` to retrieve data. If you want to get all the data, use `db.query()`.
If you're familiar with couchdb, you'll know what we will do next: create custom view.

CouchDB needs to have a view to get the data. It's written in Javascript. We will create a view that will get all data if the document has a title. If the document doesn't have a title, it will not show.

    function map(doc){
      if (doc.title){
        emit(doc._id, doc);
      }
    }

Run the query and print it out on a Javascript console.

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

Things get interesting when we are able to sync to and from CouchDB. Doing that is very easy with PouchDB. Before we do anything interesting, make sure you have CouchDB installed on your localhost and set up correctly.

Do this in your terminal:

    $> curl http://localhost:5984 -k
    {"couchdb":"Welcome","uuid":"ce0f54bc27dba624e4c9a2311c2cf733","version":"1.3.1","vendor":{"version":"1.3.1","name":"The Apache Software Foundation"}}

Or you can use a service such as [iriscouch.com](http://www.iriscouch.com). 

Let's open CouchDB's Futon admin site [http://localhost:5984/_utils/index.html](http://localhost:5984/_utils/index.html) and
make sure you didn't already have a database named `diaries`.

Type this at the end of `app.js`.

    db.sync("http://localhost:5984/diaries"); // Or if you use iriscouch "http://username:password@mysubdomain.iriscouch.com"

If you open a Javascript console then refresh your browser, you'll see the sync process. After the sync process finishes, reopen Futon and you'll find the `diaries` database. Click it to open and view the data. In the `diaries` database on CouchDB you'll find exactly the same data we found in PouchDB in our browser! Now let's create a new document from CouchDB Futon then hit "Save Document". 

When we browse the `diaries` database on CouchDB, we will find three points of data, right?! But the data on PouchDB is still two. Before we revisit our site, please remove or comment the `db.put()` line so when we refresh our browser it will not create a new document.

When we refresh our browser now, it will sync once again... And voila! Your data is synced again! It feels like magic!

Let's do one more magic trick. We want to auto sync every two seconds, let's say, so we don't have to sync manually. Easy enough; add `setInterval()` around the sync function.

    setInterval(function(){
      db.sync("http://localhost:5984/diaries");
    }, 2000);

Now when we add a document in PouchDB or in CouchDB, it will be synced automatically.  Cool, right?!

Let's make it cooler with DOM manipulation. We can print out the number of documents in the HTML so we don't have to do it on Javascript console. To do this,
we need help from another library: [jQuery](http://www.jquery.com/). I bet you know all about this one. Add jquery to our `index.html` and start typing the code below:

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

Refresh your browser and voila! Now your browser shows how many documents are saved. Let's add one more document from Couchdb Futon. When you save, wait for about
two seconds and our browser will show you how many documents we have after synced.


## Conclusion

What we did today was totally experimental. I'm aware that there was only a small portion of Elixir that we covered. There is also a possibility of not using Elixir at all. All we need is web server like Apache, nginx, or mochiweb.

But this concept alone is something else. We only need to learn client-side scripting like Javascript and jQuery -- or even a JavaScript framework such as Backbone or AngularJS -- with a little knowledge of NoSQL databases to create 'almost' real-time web application.

Until next time -- !


## References
* [pouchdb.com](http://pouchdb.com)
* [Phoenix Framework](https://github.com/phoenixframework/phoenix)
* [CouchDB](http://couchdb.apache.org/)
* [PouchDB Introduction Video](http://www.youtube.com/watch?v=TO4oGnDxkY0)
