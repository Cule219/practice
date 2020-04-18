// create a function that will calculate minimum no of steps to get from a number to 1
// available steps are -1 /2 /3
// if number is 1 return 0

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
