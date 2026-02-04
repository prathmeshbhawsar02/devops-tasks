
const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");

const port = process.env.PORT || 3001;
const mongoUrl = process.env.MONGO_URL || "mongodb://username:password@mongo:27017/todos?authSource=admin";

async function main() {
  await mongoose.connect(mongoUrl, {
    useUnifiedTopology: true,
    useNewUrlParser: true,
  });

  const app = express();
  app.use(cors());
  app.use(express.json());

  app.get("/health", (req, res) => res.send("OK"));

  app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });
}

main().catch(console.error);