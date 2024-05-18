require("dotenv").config();

const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

const posts = [
  {
    id: 1,
    title: "First Post",
    content: "This is the content of the first post.",
  },
  {
    id: 2,
    title: "Second Post",
    content: "This is the content of the second post.",
  },
  {
    id: 3,
    title: "Third Post",
    content: "This is the content of the third post.",
  },
];

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.get("/posts", (req, res) => {
  res.json(posts);
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
