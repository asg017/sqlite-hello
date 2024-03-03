#!/bin/sh


usage() {
    cat <<EOF
sqlite-hello-install 0.0.1-TODO.1 (577bf51ae 2023-04-05)

USAGE:
    $0 [static|loadable] [--target=XXX] [--prefix=XXX]

OPTIONS:
    --target
            Specify a different target platform to install. Available targets: macos-x86_64, macos-aarch64, linux-x86_64, windows-x86_64

    --prefix
            Specify a different directory to save the binaries. Defaults to the current working directory.
EOF
}


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
  



process_arguments() {
  while [[ $# -gt 0 ]]; do
      case "$1" in
          --help)
              usage
              exit 0
              ;;
          --target=*)
              target="${1#*=}"
              ;;
          --prefix=*)
              prefix="${1#*=}"
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
    "macos-x86_64-loadable")
    url="https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-loadable-macos-x86_64.tar.gz"
    checksum="af9ffd931002b970dda99f6a241ecf6802b7d974cbfb2db751d04d90903554cc"
    ;;
"macos-aarch64-loadable")
    url="https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-loadable-macos-aarch64.tar.gz"
    checksum="d8fb4b242d5429cd41fe3054042dfa1c3be76729b26ab52d286a0f091a8d42ec"
    ;;
"linux-x86_64-loadable")
    url="https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-loadable-linux-x86_64.tar.gz"
    checksum="3bfff760d70d86bb3e7f5cf9dcc4f8f6cfe0084af64f14c6f621963b818a3153"
    ;;
"windows-x86_64-loadable")
    url="https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-loadable-windows-x86_64.zip"
    checksum="552dbe82ee96dd1a751716127e036db20ed46d888441c9c67c9b1c5ef2946a94"
    ;;

    "macos-x86_64-static")
    url="https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-static-macos-x86_64.tar.gz"
    checksum="06fd5b41971f11ae07b3b689708d05d52a6dae5b4442ea8df5c5c6b869cb8898"
    ;;
"macos-aarch64-static")
    url="https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-static-macos-aarch64.tar.gz"
    checksum="1e628e2b9aa1e9d016303c15f1c2f8c1a5f7dac25557d1afac765a51beda3ab8"
    ;;
"linux-x86_64-static")
    url="https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-static-linux-x86_64.tar.gz"
    checksum="6cffb51e0ad7c8042050336fd5f9bc23b4437f51738e59a99b93865ec828da0d"
    ;;
"windows-x86_64-static")
    url="https://github.com/asg017/sqlite-hello/releases/download/v0.1.0-alpha.62/sqlite-hello-v0.1.0-alpha.62-static-windows-x86_64.zip"
    checksum="5c3c337fcda2eccb713199bcfd18d349cba7bc1c82a39682a43bcb8c83a3bd92"
    ;;

    *)
      echo "Unsupported platform $target" 1>&2
      exit 1
      ;;
    esac

    extension="${url##*.}"

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
  

main "$@"

