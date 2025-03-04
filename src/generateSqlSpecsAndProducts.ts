import { IGNORED_FIELDS } from "./getSchema";

function joinValues(values: unknown[]) {
  const result: string[] = [];

  for (const value of values) {
    if (typeof value === "number" || typeof value === "boolean") {
      result.push(`${value}`);
    } else {
      result.push(`'${value}'`);
    }
  }

  return result.join(", ");
}

export function specGenerator(
  item: object
): [string, { [key: string]: unknown }] {
  const keys: string[] = [];
  const values: unknown[] = [];

  const filtered: {
    [key: string]: unknown;
  } = {};

  Object.entries(item).forEach(([key, value]: [string, unknown]) => {
    if (IGNORED_FIELDS[key]) {
      filtered[key] = value;
    } else if (value === null) {
      console.log(`key: ${key} is ommited`);
    } else {
      if (Array.isArray(value)) {
        values.push(value.join(" - "));
      } else {
        values.push(value);
      }

      keys.push(key);
    }
  });

  const query = `insert into Specs (${keys.join(", ")}) values (${joinValues(
    values
  )})`;

  return [query, filtered];
}

export function productGenerator(
  categoryID: number,
  specId: number,
  filteredValues: { [key: string]: unknown }
) {
  const randomStock = Math.floor(Math.random() * 101);
  const price = filteredValues["price"] || Math.floor(Math.random() * 1001);

  return `insert into Products (stock, name, price, category_id, spec_id) values (${randomStock}, "${filteredValues["name"]}", ${price}, ${categoryID}, ${specId})`;
}
