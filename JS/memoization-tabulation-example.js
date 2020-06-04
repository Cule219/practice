/**
Create a function that will calculate minimum number of steps to get from a number (passed as a parameter n) to 1.
Available steps are you can take are: 
-1 (minus by one)
/2 (divide by two)
/3 (divide by three)
if number is 1 return 0
ex1:
  n = 3;
  n -= 1; // n is 2 => step 1
  n -= 1; // n is 1 => step 2
  we took 2 steps to get to 1 so we return 2 
ex2:
  n = 3;
  n /=3; // n is 1 => step 1
  we took 1 steps to get to 1 so we return 1 
ex3: 
  n = 5;
  n -= 1; // n is 4 => step 1
  n /= 2; // n is 2 => step 2
  n -= 1; // n is 1 => step 3
  we took 3 steps to get to 1 so we return 3 

  ** Numbers passed can be up to 1,000,000
*/
// function minStepsToOne(n) {}

function minStepsToOne(n) {
  function traverse(current) {
    if (current === 1) {
      return 0;
    }

    //subtract 1
    let steps = traverse(current - 1);

    //divide by 3
    if (current % 3 === 0) {
      let divide3 = traverse(current / 3);
      steps = Math.min(steps, divide3);
    }

    //divide by 2
    if (current % 2 === 0) {
      let divide2 = traverse(current / 2);
      steps = Math.min(steps, divide2);
    }

    return steps + 1;
  }

  return traverse(n);
}

function minStepsToOneMemo(n) {
  let cache = {};

  function traverse(current) {
    if (current in cache) {
      return cache[current];
    }

    if (current === 1) {
      return 0;
    }

    //subtract 1
    let steps = traverse(current - 1);

    //divide by 3
    if (current % 3 === 0) {
      let divide3 = traverse(current / 3);
      steps = Math.min(steps, divide3);
    }

    //divide by 2
    if (current % 2 === 0) {
      let divide2 = traverse(current / 2);
      steps = Math.min(steps, divide2);
    }

    cache[current] = steps + 1;
    return steps + 1;
  }

  return traverse(n);
}

function minStepsToOneTab(n) {
  let result = new Array(n + 1);
  result[1] = 0;

  for (let i = 2; i < result.length; i++) {
    //subtract 1
    let steps = result[i - 1];

    //divide by 3
    if (i % 3 === 0) {
      let divide3 = result[i / 3];
      steps = Math.min(steps, divide3);
    }

    //divide by 2
    if (i % 2 === 0) {
      let divide2 = result[i / 2];
      steps = Math.min(steps, divide2);
    }
    result[i] = steps + 1;
  }
  return result[n];
}

console.time("RECURSION: ");
console.log(minStepsToOne(500));
console.timeEnd("RECURSION: ");

console.time("MEMOIZATION: ");
console.log(minStepsToOneMemo(5000));
console.timeEnd("MEMOIZATION: ");

console.time("TABULATION: ");
console.log(minStepsToOneTab(1000000));
console.timeEnd("TABULATION: ");
