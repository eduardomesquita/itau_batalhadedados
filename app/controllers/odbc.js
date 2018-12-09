var exports = module.exports = {}
var db = require('odbc')()
  , cn = 'HIVE_HACKATHON'
  ;

exports.connection = function(query){

    return new Promise(function(resolver){
        db.open(cn, function (query ,err) {
            if (err) return console.log(err);
            
            db.query(query, [42], function (err, data) {
                if (err) console.log(err);
                
                resolver(data)
        
            db.close(function () {
            console.log('done');
            });
        });
        });
});
   
}