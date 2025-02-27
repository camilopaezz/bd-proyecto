import fs from "fs/promises";

export type Elements = {
  [key: string]: object[];
};

export async function readDataset(datasetPath: string) {
  const elements: Elements = {};
  const entries = await fs.readdir(datasetPath);

  for (const entry of entries) {
    if (!entry.endsWith(".json")) {
      continue;
    }

    const filename = entry;

    const data = await fs.readFile(`${datasetPath}/${filename}`, "utf-8");
    const jsonData = JSON.parse(data);

    elements[filename.slice(0, -4)] = jsonData;
  }

  return elements;
}
