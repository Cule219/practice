const chai = require('chai');
const chaiHttp = require('chai-http');
const proxyquire = require('proxyquire');
const sinon = require('sinon');
const logger = require('morgan');

chai.use(chaiHttp);

const should = chai.should();

describe('app.js', function() {
  // Backup.
  const env = process.env['NODE_ENV'] || 'development';

  let app;
  let loggerStub;

  before(function() {
    loggerStub = sinon
      .stub(logger, 'morgan')
      .returns(function(req, res, next) {
        next();
      });
  });

  after(function() {
    loggerStub.restore();
  });

  context('errors', function() {
    it('should return a 404 for a missing page in production', function(done) {
      process.env['NODE_ENV'] = 'production';
      app = proxyquire('../../app', {
        morgan: loggerStub
      });
      process.env['NODE_ENV'] = env;
      chai.request(app)
        .get('/bananas')
        .end(function(err, res) {
          res.should.have.status(404);
          res.text.should.not.contain('app.js');
          done();
        });
    });
  });
});
