var exports = module.exports = {}
var odbc = require('./odbc');

exports.getDocentes = function(req, res) {
    odbc.connection('docentes_sudeste_2016').then(function(data){
        return res.json(data)
    });
};
