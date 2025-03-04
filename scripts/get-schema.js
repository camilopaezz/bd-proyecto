#!/usr/bin/env node
const path = require("path");
const fs = require("fs/promises");

const { readDataset } = require("../dist/readDataset");
const { getSchema } = require("../dist/getSchema");

const DATASETH_PATH = process.argv[2];
const PWD = process.cwd();

(async function main() {
  try {
    const data = await readDataset(path.join(PWD, DATASETH_PATH));

    const schema = getSchema(data);

    console.log(schema);

    await fs.writeFile(
      "schema.json",
      JSON.stringify(Object.fromEntries(schema.entries())),
      {
        encoding: "utf8",
      }
    );
  } catch (e) {
    console.log(e);
  }
})();
