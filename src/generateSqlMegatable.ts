import { Schema } from "./getSchema";
import { DBType } from "./guessType";

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

export function generateSqlMegatable(schema: Schema, name: string) {
  const fields: string[] = [];

  for (const [key, type] of schema) {
    if (key === "name") {
      fields.push(`${key} 'varchar(150)'`);
    } else {
      fields.push(`${key} ${toMysqlType(type)}`);
    }
  }

  const singularName = name[0].toLowerCase() + name.slice(1, -1);

  const query = `create table if not exists ${name} (${
    singularName + "_id"
  } int auto_increment, ${fields.join(", ")}, primary key (${
    singularName + "_id"
  }));`;

  return query;
}
