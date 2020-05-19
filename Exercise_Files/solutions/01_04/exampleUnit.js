// Test setup using Node.js Assert module.
const assert = require('assert');
// Tested method.
function cat() { return 'woof'; }
// Assertion - actual and expected.
assert.equal(cat(), 'meow');
