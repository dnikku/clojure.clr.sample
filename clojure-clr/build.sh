#!/bin/bash

cd "$(dirname "$0")"

INSTANCE=clojure-clr.mono
IMAGE=${INSTANCE}.i

function run () {

  case "${1:-build-run}" in
    build-run)
    	docker build . -f mono.Dockerfile --tag $IMAGE || exit 10

      docker stop -t1 $INSTANCE > /dev/null || true
	    docker rm $INSTANCE > /dev/null || true

      docker run -dt --name $INSTANCE $IMAGE echo "DONE."

      rm -rf ./mono
      docker cp $INSTANCE:/app/clojure-clr/bin ./mono
    ;;

    *)
      echo "Unkown action:$1"
    ;;

  esac
}

run $* 2>&1 | tee build.log
