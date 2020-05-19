const should = require('should'); // eslint-disable-line no-unused-vars
const reservation = require('./data/reservation');

// BDD "should" style.
reservation.should.have
  .property('email')
  .and.equal('username@example.com');
