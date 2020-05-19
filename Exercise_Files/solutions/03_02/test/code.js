const expect = require('code').expect;
const reservation = require('./data/reservation');

// BDD "expect" style.
expect(reservation.email).to.equal('username@example.com');
