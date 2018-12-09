var exports = module.exports = {}
var odbc = require('./odbc');

exports.getDocentes = function(req, res) {
    odbc.connection('docentes_sudeste_2016').then(function(data){
        return res.json(data)
    });
};

exports.getMatriculas = function(req, res) {
    odbc.connection('matricula_sudeste_2015').then(function(data){
        return res.json(data)
    });
};

exports.getPense = function(req, res) {
    odbc.connection('pense_estudantes').then(function(data){
        return res.json(data)
    });
};