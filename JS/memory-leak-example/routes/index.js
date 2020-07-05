var express = require("express");
var router = express.Router();

// Assigning to global variable will eventualy cause a memory leak
const requests = new Map();
/* GET home page. */
router.get("/", function (req, res, next) {
  requests.set(req.id, req);
  res.render("index", { title: "Express" });
});

module.exports = router;
