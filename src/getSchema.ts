import { DBType, guessType } from "./guessType";
import { Elements } from "./readDataset";

export const IGNORED_FIELDS: {
  [key: string]: boolean;
} = {
  airflow: true,
  noise_level: true,
  channel_wattage: true,
  form_factor: true,
  mode: true,
  // to fix ^
  price: true,
  name: true,
};
export type Schema = Map<string, DBType>;

export function getSchema(elements: Elements) {
  const schema: Schema = new Map();

  for (const elementList of Object.values(elements)) {
    let completeElement: object = {};

    for (const element of elementList) {
      const someoneIsNull = Object.values(element).some((v) => v === null);
      if (!someoneIsNull) {
        completeElement = element;
        break;
      }
    }

    for (const [propertyKey, propertyValue] of Object.entries(
      completeElement
    )) {
      if (!schema.has(propertyKey) && !IGNORED_FIELDS[propertyKey]) {
        schema.set(propertyKey, guessType(propertyValue));
      }
    }
  }

  return schema;
}
