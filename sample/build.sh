#!/bin/bash

cd "$(dirname "$0")"


function run () {

  case "${1:-build-run}" in
    build-run)
      dotnet restore sample.csproj # generate project.json asset
      msbuild -noLogo /p:Configuration=Debug sample.csproj -v:m

      echo "RUN sample.exe"
      export CLOJURE_LOAD_PATH=$(cd "../clojure.clr-mono/bin" && pwd) 
      mono ./bin/Debug/net45/sample.exe
    ;;

    *)
      echo "Unkown action:$1"
    ;;

  esac
}

run $* 2>&1 | tee build.log
