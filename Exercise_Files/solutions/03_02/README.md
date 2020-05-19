# Node.js: Testing and Code Quality - Assertion Library Comparison

As I was writing this segment, I wanted to verify that each example worked
as I expected. It's also useful to have working examples of how each assertion
library performs the same task, such as a failed assertion.

I compared:

* https://nodejs.org/api/assert.html
* https://www.npmjs.com/package/chai
* https://www.npmjs.com/package/code
* https://www.npmjs.com/package/should

I intentionally made every assertion fail so you can see what happens. The
BDD-style scenario:

* Given a reservation object with property `email`
* And the `email` is `username@example.asdf`
* When the reservation email property is compared to `username@example.com`
* Then the test should fail

## Installation

```bash
npm install
```

## Execution

```bash
npm test
```
