import mysql, { Connection } from "mysql2/promise";
import dotenv from "dotenv";
import chalk from "chalk";

dotenv.config();

import { readDataset } from "./readDataset";
import { getSchema } from "./getSchema";
import { generateSqlMegatable } from "./generateSqlMegatable";

const DATASET_PATH = "./dataset";
const MEGATABLE_NAME = "Specifications";

console.log(chalk.yellow("Conectando a la base de datos..."));

mysql
  .createConnection({
    host: "localhost",
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
  const data = await readDataset(DATASET_PATH);
  const scheme = getSchema(data);

  console.log(
    chalk.yellow("Generating query for " + MEGATABLE_NAME + " table..."),
  );
  const query = generateSqlMegatable(scheme, MEGATABLE_NAME);

  console.log(chalk.magenta(query));
  await db.query(query);
  console.log(chalk.green(`Table ${MEGATABLE_NAME} successfully created`));

  console.log(chalk.yellow("Desconectando de la base de datos"));
  await db.end();
  console.log(chalk.green("Se desconecto exitosamente"));
}
