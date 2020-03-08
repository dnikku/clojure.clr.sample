#!/bin/bash

set -e # stop on first error

cd "$(dirname "$0")"

export CLOJURE_LOAD_PATH=$(cd "../clojure.clr-mono/bin/4.0/Debug" && pwd) 

function run () {

  case "${1:-build-run}" in
    build-run)
      echo "BUILD:"
      dotnet restore shell.csproj
      msbuild -noLogo /p:Configuration=Debug shell.csproj -v:m

      echo "RUN: server"
      mono ./bin/Debug/net45/clr-shell.exe "src/server.clj"
    ;;

    client)
      echo "RUN: client"
      mono ./bin/Debug/net45/clr-shell.exe "src/client.clj"
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
