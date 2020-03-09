#!/bin/bash

set -e # stop on first error

cd "$(dirname "$0")"

CLR_SHELL="./bin/Debug/netcoreapp3.1/clr-shell"
export CLOJURE_LOAD_PATH=$(cd "$(dirname $CLR_SHELL)" && pwd)

function run () {

  case "${1:-build-run}" in
    build-run)
      echo "BUILD:"
      dotnet build shell.csproj --nologo

      echo "RUN: server"
      $CLR_SHELL "src/server.clj"
    ;;

    client)
      echo "RUN: client"
      $CLR_SHELL "src/client.clj"
    ;;

    clean)
      echo "CLEAN:"
      rm -rf ./bin ./obj
    ;;

    *)
      echo "Unkown action:$1"
    ;;

  esac
}

run $* 2>&1 | tee build.log
