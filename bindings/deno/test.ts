import * as sqlite_hello from "./mod.ts";
import meta from "./deno.json" assert { type: "json" };

import { assertEquals } from "https://deno.land/std@0.177.0/testing/asserts.ts";
import { Database } from "https://deno.land/x/sqlite3@0.8.0/mod.ts";

Deno.test("x/sqlite3", (t) => {
  const db = new Database(":memory:");

  db.enableLoadExtension = true;
  sqlite_hello.load(db);

  const [version] = db.prepare("select hello_version()").value<[string]>()!;

  assertEquals(version[0], "v");
  assertEquals(version.substring(1), meta.version);

  db.close();
});
