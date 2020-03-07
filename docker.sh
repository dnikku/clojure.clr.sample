#!/bin/bash

INSTANCE=my-clj
IMAGE=${INSTANCE}.i

function run () {

case "$1" in
    rmi_prune)
	docker ps -qa -f 'status=exited' | xargs -r docker rm
  docker images -qa -f 'dangling=true' | xargs -r docker rmi
	;;

    bash)
	docker exec -it $INSTANCE /bin/bash
	;;

    logs)
	docker logs $INSTANCE
	;;

    build-run)
	docker build . --target buildClojureSample --tag $IMAGE || exit 10
	#;;

  #  run)
	docker stop -t1 $INSTANCE > /dev/null || true
	docker rm $INSTANCE > /dev/null || true

  docker run -dt --name $INSTANCE $IMAGE bash

  sleep 2
  docker ps -a

	;;
esac
}

run $* 2>&1 | tee build.log
