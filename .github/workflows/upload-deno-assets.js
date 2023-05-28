const fs = require("fs").promises;

module.exports = async ({ github, context }) => {
  const VERSION = process.env.GITHUB_REF_NAME;
  const { owner, repo } = context.repo;

  const compiled_extensions = [
    {
      path: `sqlite-hello-macos-x86_64-extension/hola0.dylib`,
      name: `sqlite-hello-${VERSION}-deno-darwin-x86_64.hola0.dylib`,
    },
    {
      path: `sqlite-hello-macos-x86_64-extension/hello0.dylib`,
      name: `sqlite-hello-${VERSION}-deno-darwin-x86_64.hello0.dylib`,
    },
    {
      path: `sqlite-hello-macos-aarch64-extension/hola0.dylib`,
      name: `sqlite-hello-${VERSION}-deno-darwin-aarch64.hola0.dylib`,
    },
    {
      path: `sqlite-hello-macos-aarch64-extension/hello0.dylib`,
      name: `sqlite-hello-${VERSION}-deno-darwin-aarch64.hello0.dylib`,
    },
    {
      path: `sqlite-hello-linux-x86_64-extension/hola0.so`,
      name: `sqlite-hello-${VERSION}-deno-linux-x86_64.hola0.so`,
    },
    {
      path: `sqlite-hello-linux-x86_64-extension/hello0.so`,
      name: `sqlite-hello-${VERSION}-deno-linux-x86_64.hello0.so`,
    },
    {
      path: `sqlite-hello-windows-x86_64-extension/hola0.dll`,
      name: `sqlite-hello-${VERSION}-deno-windows-x86_64.hola0.dll`,
    },
    {
      path: `sqlite-hello-windows-x86_64-extension/hello0.dll`,
      name: `sqlite-hello-${VERSION}-deno-windows-x86_64.hello0.dll`,
    },
  ];

  const release = await github.rest.repos.getReleaseByTag({
    owner,
    repo,
    tag: VERSION,
  });
  const release_id = release.data.id;
  const outputAssetChecksums = [];

  await Promise.all(
    compiled_extensions.map(async ({ name, path }) => {
      const data = await fs.readFile(path);
      const checksum = createHash("sha256").update(data).digest("hex");
      outputAssetChecksums.push({ name, checksum });
      return github.rest.repos.uploadReleaseAsset({
        owner,
        repo,
        release_id,
        name,
        data,
      });
    })
  );

  return outputAssetChecksums.map((d) => `${d.checksum} ${d.name}`).join("\n");
};
