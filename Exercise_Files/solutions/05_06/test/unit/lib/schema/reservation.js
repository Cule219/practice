const chai = require('chai');
const should = chai.should();
const Reservation = require('../../../../lib/schema/reservation');

describe('Reservation Schema', function() {
  context('Date and Time Combination', function() {
    it('should return a ISO 8601 date and time with valid input', function() {
      const date = '2017/06/10';
      const time = '06:02 AM';

      Reservation.combineDateTime(date, time)
        .should.equal('2017-06-10T06:02:00.000Z');
    });

    it('should return null on a bad date and time', function() {
      const date = '!@#$';
      const time = 'fail';

      should.not.exist(Reservation.combineDateTime(date, time));
    });
  });

  context('Constructor', function() {
    it('should create a Reservation with valid fields', function() {
      const valid = {
        date: '2017/06/10',
        time: '06:02 AM',
        party: 4,
        name: 'Family',
        email: 'username@example.com'
      };

      const expected = {
        datetime: '2017-06-10T06:02:00.000Z',
        party: 4,
        name: 'Family',
        email: 'username@example.com',
        message: undefined,
        phone: undefined
      };

      const actual = new Reservation(valid);
      actual.should.deep.equal(expected);
    });
  });

  context('Validator', function() {
    it('should pass a valid reservation with no optional fields', function(done) {
      const reservation = new Reservation({
        date: '2017/06/10',
        time: '06:02 AM',
        party: 4,
        name: 'Family',
        email: 'username@example.com'
      });

      reservation.validator(function(error, value) {
        value.should.deep.equal(reservation);
        done(error);
      });
    });

    it('should fail a reservation with a bad email', function(done) {
      const reservation = new Reservation({
        date: '2017/06/10',
        time: '06:02 AM',
        party: 4,
        name: 'Family',
        email: 'username'
      });

      reservation.validator(function(error) {
        error.should
          .be.an('error')
          .and.not.be.null;
        done();
      });
    });
  });
});
