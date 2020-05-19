const chai = require('chai');
const chaiHttp = require('chai-http');
const proxyquire = require('proxyquire');
const sinon = require('sinon');
const logger = require('morgan');

chai.use(chaiHttp);

const should = chai.should();

describe('/admin', function() {
  let app;
  let loggerStub;
  let dbStub;

  before(function() {
    loggerStub = sinon
      .stub(logger, 'morgan')
      .returns(function(req, res, next) {
        next();
      });

    dbStub = {
      all: function() {
        return Promise.resolve([]);
      }
    }
    dbStub['@global'] = true;

    app = proxyquire('../../app', {
      morgan: loggerStub,
      sqlite: dbStub
    });
  });

  after(function() {
    loggerStub.restore();
  });

  context('GET', function() {
    it('should allow access with a password', function(done) {
      chai.request(app)
        .get('/admin')
        .auth('admin', 'admin')
        .end(function(err, res) {
          res.should.have.status(200);
          done(err);
        });
    });

    it('should reject access without a password', function(done) {
      chai.request(app)
        .get('/admin')
        .end(function(err, res) {
          res.should.have.status(401);
          done();
        });
    });
  });
});
