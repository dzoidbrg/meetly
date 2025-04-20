import * as sdk from "https://deno.land/x/appwrite/mod.ts";
import { Application } from "jsr:@oak/oak/application";
import { Router } from "jsr:@oak/oak/router";
export function add(a: number, b: number): number {
  return a + b;
}
function runServer() {
  let client = new sdk.Client();

  client
      .setEndpoint('https://[HOSTNAME_OR_IP]/v1') // Your API Endpoint
      .setProject('5df5acd0d48c2') // Your project ID
      .setKey('919c2d18fb5d4...a2ae413da83346ad2') // Your secret API key
   // Use only on dev mode with a self-signed SSL cert
  ; 

  const router = new Router();
router.get("/", (ctx) => {
  ctx.response.body = `<!DOCTYPE html>
    <html>
      <head><title>Hello oak!</title><head>
      <body>
        <h1>Hello oak!</h1>
      </body>
    </html>
  `;
});

const app = new Application();
app.use(router.routes());
app.use(router.allowedMethods());

app.listen({ port: 8080 });
}

//TODO: Implement fuction / list all users


// Learn more at https://docs.deno.com/runtime/manual/examples/module_metadata#concepts
if (import.meta.main) {
  console.log("Add 2 + 3 =", add(2, 3));
  runServer();
}
