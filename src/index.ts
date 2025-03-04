import mysql, { Connection, ResultSetHeader } from "mysql2/promise";
import dotenv from "dotenv";
import chalk from "chalk";

dotenv.config();

import { readDataset } from "./readDataset";
import { getSchema } from "./getSchema";
import { generateSqlMegatable } from "./generateSqlMegatable";
import { generateSqlCategory } from "./generateSqlCategory";
import { productGenerator, specGenerator } from "./generateSqlSpecsAndProducts";

const DATASET_PATH = "./dataset";
const MEGATABLE_NAME = "Specs";

console.log(chalk.yellow("Conectando a la base de datos..."));

mysql
  .createConnection({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    database: process.env.MYSQL_DATABASE,
    password: process.env.MYSQL_PASSWORD,
  })
  .then((connection) => {
    console.log(chalk.green("Succesfully connected to db."));
    main(connection);
  })
  .catch((e) => {
    if (e instanceof Error) {
      console.error(chalk.red("Error conectando a la base de datos:"));
      console.error(chalk.red("Stack:", e.stack));
    }
  });

async function main(db: Connection) {
  const elements = await readDataset(DATASET_PATH);

  // 01. Get Specs Schemas and create
  const scheme = getSchema(elements);

  console.log(
    chalk.yellow("Generating query for " + MEGATABLE_NAME + " table...")
  );
  const megatableQuery = generateSqlMegatable(scheme, MEGATABLE_NAME);

  console.log(chalk.magenta(megatableQuery));
  await db.query(megatableQuery);
  console.log(chalk.green(`Table ${MEGATABLE_NAME} successfully created`));

  // 02. Create categories
  const [categoryQueries, categoryDictIds] = generateSqlCategory(elements);

  // for (const q of categoryQueries) {
  //   console.log(chalk.magenta(q));
  //   await db.query(q);
  // }

  // Insert Products ans specs
  for (const [category_name, elementBach] of Object.entries(elements)) {
    const categoryId = categoryDictIds[category_name.slice(0, -1)];

    for (const element of elementBach) {
      const [spectQuery, filteredValues] = specGenerator(element);

      const [resultHeader] = await db.query<ResultSetHeader>(spectQuery);

      const productQuery = productGenerator(
        categoryId,
        resultHeader.insertId,
        filteredValues
      );

      await db.query(productQuery);
    }
  }

  console.log(chalk.yellow("Desconectando de la base de datos"));
  await db.end();
}
