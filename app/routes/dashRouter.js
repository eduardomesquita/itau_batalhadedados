var dash = require('../controllers/dashController');

module.exports = function(app) {

    app.get('/', function(req, res){
        return res.json({'status': 'ok'})
    });

    app.get('/docentes', dash.getDocentes);

    app.get('/matriculas', dash.getMatriculas);

    app.get('/pense', dash.getPense);

};