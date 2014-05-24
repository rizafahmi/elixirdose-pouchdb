
// Define a new database
var db = new PouchDB('diaries');

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

uuid = PouchDB.utils.uuid();

var diary2 = {
  _id: uuid,
  title: "Reading email",
  sight: 8,
  touch: 5,
  smell: 0,
  sound: 1,
  taste: 2
}

// db.put(diary2);

  function map(doc){
    if (doc.title){
      emit(doc._id, doc);
    }
  }

  db.query({map: map}, {reduce: false}, function(err, response){
    console.log(response);
  });

  function syncDB(){

    db.sync("http://localhost:5984/diaries");

    db.info(function(error, info) {
      $("#totalDocs").html(info.doc_count);
    });

  }

  // Sync database with couchdb
  setInterval(function(){
    syncDB();
  }, 2000);
