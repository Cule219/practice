const proxyquire = require('proxyquire');
const sinon = require('sinon');
const chai = require('chai');
const should = chai.should();
const Reservation = require('../../../lib/schema/reservation');
const db = require('sqlite');

describe('Reservations Library', function() {
  const debugStub = function() {
    return sinon.stub();
  }
  let reservations;

  before(function() {
    reservations = proxyquire('../../../lib/reservations', {
      debug: debugStub
    });
  });

  context('Validate', function() {
    it('should pass a valid reservation with no optional fields', function() {
      const reservation = new Reservation({
        date: '2017/06/10',
        time: '06:02 AM',
        party: 4,
        name: 'Family',
        email: 'username@example.com'
      });

      return reservations.validate(reservation)
        .then(actual => actual.should.deep.equal(reservation));
    });

    it('should fail an invalid reservation with a bad email', function() {
      const reservation = new Reservation({
        date: '2017/06/10',
        time: '06:02 AM',
        party: 4,
        name: 'Family',
        email: 'username'
      });

      return reservations.validate(reservation)
        .catch(error => error.should.be.an('error').and.not.be.null);
    });
  });

  context('Create', function() {
    let dbStub;

    before(function() {
      dbStub = sinon.stub(db, 'run').resolves({
        stmt: {
          lastID: 1349
        }
      });
      reservations = proxyquire('../../../lib/reservations', {
        debug: debugStub,
        sqlite: dbStub
      });
    });

    after(function() {
      dbStub.restore();
    });

    it('should return the created reservation ID', function(done) {
      const reservation = new Reservation({
        date: '2017/06/10',
        time: '06:02 AM',
        party: 4,
        name: 'Family',
        email: 'username@example.com'
      });

      reservations.create(reservation)
        .then(lastID => {
          lastID.should.deep.equal(1349);
          done();
        })
        .catch(error => done(error));
    });
  });
});
