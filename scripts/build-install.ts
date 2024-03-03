// prettier-ignore
const spm = { "version": 0, "description": "", "loadable": [{ "os": "macos", "cpu": "x86_64", "url": "https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-loadable-macos-x86_64.tar.gz", "checksum_sha256": "af9ffd931002b970dda99f6a241ecf6802b7d974cbfb2db751d04d90903554cc" }, { "os": "macos", "cpu": "aarch64", "url": "https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-loadable-macos-aarch64.tar.gz", "checksum_sha256": "d8fb4b242d5429cd41fe3054042dfa1c3be76729b26ab52d286a0f091a8d42ec" }, { "os": "linux", "cpu": "x86_64", "url": "https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-loadable-linux-x86_64.tar.gz", "checksum_sha256": "3bfff760d70d86bb3e7f5cf9dcc4f8f6cfe0084af64f14c6f621963b818a3153" }, { "os": "windows", "cpu": "x86_64", "url": "https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-loadable-windows-x86_64.zip", "checksum_sha256": "552dbe82ee96dd1a751716127e036db20ed46d888441c9c67c9b1c5ef2946a94" }], "static": [{ "os": "macos", "cpu": "x86_64", "url": "https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-static-macos-x86_64.tar.gz", "checksum_sha256": "06fd5b41971f11ae07b3b689708d05d52a6dae5b4442ea8df5c5c6b869cb8898" }, { "os": "macos", "cpu": "aarch64", "url": "https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-static-macos-aarch64.tar.gz", "checksum_sha256": "1e628e2b9aa1e9d016303c15f1c2f8c1a5f7dac25557d1afac765a51beda3ab8" }, { "os": "linux", "cpu": "x86_64", "url": "https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-static-linux-x86_64.tar.gz", "checksum_sha256": "6cffb51e0ad7c8042050336fd5f9bc23b4437f51738e59a99b93865ec828da0d" }, { "os": "windows", "cpu": "x86_64", "url": "https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-static-windows-x86_64.zip", "checksum_sha256": "5c3c337fcda2eccb713199bcfd18d349cba7bc1c82a39682a43bcb8c83a3bd92" }] }

// TODO
// - [ ] build SHA, date, version
// - [ ] make in github actions
// - [ ] doc go makefile: `go list -m -f '{{.Version}}' github.com/asg017/sqlite-hello/bindings/go`

const version = "0.0.1-TODO.1";
const buildSha = "577bf51ae";
const buildDate = "2023-04-05";

const availableTargets = Array.from(
  new Set([
    ...spm.loadable.map((d) => `${d.os}-${d.cpu}`),
    ...(spm.static.map((d) => `${d.os}-${d.cpu}`) || []),
  ])
);
function build_usage(): string {
  return `
usage() {
    cat <<EOF
sqlite-hello-install ${version} (${buildSha} ${buildDate})

USAGE:
    $0 [static|loadable] [--target=target] [--prefix=path]

OPTIONS:
    --target
            Specify a different target platform to install. Available targets: ${availableTargets.join(
              ", "
            )}

    --prefix
            Specify a different directory to save the binaries. Defaults to the current working directory.
EOF
}`;
}
function build_current_target(): string {
  return `
current_target() {
  if [ "$OS" = "Windows_NT" ]; then
    # TODO disambiguate between x86 and arm windows
    target="windows-x86_64"
    return 0
  fi
  case $(uname -sm) in
  "Darwin x86_64") target=macos-x86_64 ;;
  "Darwin arm64") target=macos-aarch64 ;;
  "Linux x86_64") target=linux-x86_64 ;;
  *) target=$(uname -sm);;
  esac
}
  `;
}
function build_process_arguments(): string {
  return `

process_arguments() {
  while [[ $# -gt 0 ]]; do
      case "$1" in
          --help)
              usage
              exit 0
              ;;
          --target=*)
              target="\${1#*=}"
              ;;
          --prefix=*)
              prefix="\${1#*=}"
              ;;
          static|loadable)
              type="$1"
              ;;
          *)
              echo "Unrecognized option: $1"
              usage
              exit 1
              ;;
      esac
      shift
  done
  if [ -z "$type" ]; then
    type=loadable
  fi
  if [ "$type" != "static" ] && [ "$type" != "loadable" ]; then
      echo "Invalid type '$type'. It must be either 'static' or 'loadable'."
      usage
      exit 1
  fi
  if [ -z "$prefix" ]; then
    prefix="$PWD"
  fi
  if [ -z "$target" ]; then
    current_target
  fi
}

  `;
}
function build_main(): string {
  return `
  main() {
    local type=""
    local target=""
    local prefix=""
    local url=""
    local checksum=""

    process_arguments "$@"

    echo "Type: $type"
    echo "Target: $target"
    echo "Prefix: $prefix"

    case "$target-$type" in
    ${spm.loadable
      .map(
        (d) => `"${d.os}-${d.cpu}-loadable")
    url="${d.url}"
    checksum="${d.checksum_sha256}"
    ;;`
      )
      .join("\n")}

    ${spm.static
      .map(
        (d) => `"${d.os}-${d.cpu}-static")
    url="${d.url}"
    checksum="${d.checksum_sha256}"
    ;;`
      )
      .join("\n")}

    *)
      echo "Unsupported platform $target" 1>&2
      exit 1
      ;;
    esac

    extension="\${url##*.}"

    if [ "$extension" = "zip" ]; then
      tmpfile="$prefix/tmp.zip"
    else
      tmpfile="$prefix/tmp.tar.gz"
    fi

    curl --fail --location --progress-bar --output "$tmpfile" "$url"

    if ! echo "$checksum $tmpfile" | sha256sum --check --status; then
      echo "Checksum fail!"  1>&2
      rm $tmpfile
      exit 1
    fi

    if [ "$extension" = "zip" ]; then
      unzip "$tmpfile" -d $prefix
      rm $tmpfile
    else
      tar -xzf "$tmpfile" -C $prefix
      rm $tmpfile
    fi

    echo "✅ $target $type binaries installed at $prefix."
}
  `;
}

console.log(`#!/bin/sh

${build_usage()}

${build_current_target()}

${build_process_arguments()}

${build_main()}

main "$@"
`);
