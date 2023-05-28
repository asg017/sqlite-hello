import { Database } from "https://deno.land/x/sqlite3@0.8.0/mod.ts";
import * as sqlite_hello from "https://deno.land/x/sqlite_hello/mod.ts";

const db = new Database(":memory:");
db.enableLoadExtension = true;
db.loadExtension(sqlite_hello.getLoadablePath());
db.enableLoadExtension = false;

const [version] = db.prepare("select hello_version()").value<[string]>()!;

console.log(version);
