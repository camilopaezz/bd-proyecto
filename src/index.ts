import fs from "fs/promises";
import mysql, { Connection } from "mysql2/promise";
import dotenv from "dotenv";
import chalk from "chalk";

dotenv.config();

import { readDataset } from "./readDataset";
import { getSchema, Schema } from "./getSchema";
import { DBType } from "./guessType";

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

  const x = await db.query(query);
  console.log(query);

  console.log(chalk.yellow("Desconectando de la base de datos"));
  await db.end();
  console.log(chalk.green("Se desconecto exitosamente"));
}

function toMysqlType(type: DBType) {
  switch (type) {
    case "string":
      return "varchar(100)";
    case "integer":
      return "int";
    case "float":
      return "float(2)";
    case "boolean":
      return "boolean";
    case "array":
      return "varchar(100)";

    default:
      break;
  }
}

function generateSqlMegatable(schema: Schema, name: string) {
  const fields: string[] = [];

  for (const [key, type] of schema) {
    fields.push(`${key} ${toMysqlType(type)}`);
  }

  const singularName = name[0].toLowerCase() + name.slice(1, -1);

  const query = `create table ${name} (${singularName + "_id"} int auto_increment, ${fields.join(", ")}, primary key (${singularName + "_id"}));`;

  return query;
}
