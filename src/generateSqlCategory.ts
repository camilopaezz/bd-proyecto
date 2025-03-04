import { Elements } from "./readDataset";

export type CategoriesIds = { [key: string]: number };

export function generateSqlCategory(
  elements: Elements
): [string[], CategoriesIds] {
  const keys = Object.keys(elements);

  const querys: string[] = [];

  const ids: CategoriesIds = {};

  for (let i = 0; i < keys.length; i++) {
    const name = keys[i].slice(0, -1);
    querys.push(`insert into Category (description) values ('${name}');`);

    ids[name] = i + 1;
  }

  return [querys, ids];
}
