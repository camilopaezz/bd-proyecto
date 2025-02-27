export type DBType = "float" | "integer" | "string" | "array" | "boolean";

export function guessType(value: unknown): DBType {
  if (typeof value === "number") {
    return Number.isInteger(value) ? "integer" : "float";
  }

  if (typeof value === "object") {
    if (Array.isArray(value)) {
      return "array";
    }
  }

  if (typeof value === "boolean") {
    return "boolean";
  }

  return "string";
}
