var dash = require('../controllers/dashController');

module.exports = function(app) {

    app.get('/', dash.teste);

};