var multiply = function (num1, num2) {
  return [...num1].reverse().reduce((a, v, i) => {
    let no = bigIntMultiply(num2, v) + "0".repeat(i);
    return bigIntAdd([...no].reverse(), [...a].reverse());
  }, "0");
};

const bigIntAdd = (bigInt1, bigInt2) => {
  const lengthier = bigInt1.length >= bigInt2.length ? bigInt1 : bigInt2;
  const shorter = lengthier === bigInt2 ? bigInt1 : bigInt2;
  return lengthier
    .reduce(
      (a, v, i) => {
        console.log(v, a[i], shorter[i]);
        const no = +v + a[i] + shorter[i] || 0;
        const over = ~~(no / 10);
        a[i] = no % 10;
        a[i + 1] = over;
        console.log(a);
        return a;
      },
      [0]
    )
    .reverse()
    .join("");
};

const bigIntMultiply = (bigInt, int) => {
  return [...bigInt]
    .reverse()
    .reduce(
      (a, v, i) => {
        const no = a[i] + v * int;
        const over = ~~(no / 10);
        a[i] = no % 10;
        a[i + 1] = over;
        return a;
      },
      [0]
    )
    .reverse()
    .join("");
};

console.log(multiply("24", "25"));
