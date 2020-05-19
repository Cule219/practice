console.log('Compare test failures!');
console.log();

const fs = require('fs');

fs.readdirSync('./test').forEach(file => {
  if (file.indexOf('.js') > -1 && file !== 'index.js') {
    console.log(file);
    try {
      require(`./${file}`);
    }
    catch (e) {
      console.error(`  ${e.constructor.name}: ${e.message}`);
    }
    console.log();
  }
});
