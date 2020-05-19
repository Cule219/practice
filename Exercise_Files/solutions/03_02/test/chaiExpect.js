const expect = require('chai').expect;
const reservation = require('./data/reservation');

// BDD "expect" style.
expect(reservation.email).to.equal('username@example.com');
