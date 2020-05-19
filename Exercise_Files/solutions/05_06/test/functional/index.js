const chai = require('chai');
const chaiHttp = require('chai-http');
const proxyquire = require('proxyquire');
const sinon = require('sinon');
const logger = require('morgan');

chai.use(chaiHttp);

const should = chai.should();

describe('/', function() {
  let app;
  let loggerStub;

  before(function() {
    loggerStub = sinon
      .stub(logger, 'morgan')
      .returns(function(req, res, next) {
        next();
      });

    app = proxyquire('../../app', {
      morgan: loggerStub
    });
  });

  after(function() {
    loggerStub.restore();
  });

  context('GET', function() {
    it('should contain the word "Nadia"', function(done) {
      chai.request(app)
        .get('/')
        .end(function(err, res) {
          res.should.have.status(200);
          res.text.should.contain('Nadia');
          done(err);
        });
    });
  });

  context('DELETE', function() {
    it('should fail to delete the homepage', function(done) {
      chai.request(app)
        .delete('/')
        .end(function(err, res) {
          res.should.have.status(500);
          done();
        });
    });
  });
});
