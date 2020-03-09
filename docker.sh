#!/bin/bash

PROJ_DIR="$( cd "$(dirname "$0")/.." ; pwd -P )"

INSTANCE=my-ccv77-jekyll
IMAGE=${INSTANCE}.i
VOLUME=${INSTANCE}.vol
HTTP_PORT=4000

case "$1" in
    mkvol)
	if [[ $(id -u) -ne 0 ]] ; then
	    echo "Please run mkvol as root/sudo"
	    exit
	fi

	# re-create a local volume
  docker volume rm $VOLUME
	docker volume create --name $VOLUME
  docker volume inspect $VOLUME

	VOLUME_DIR=/var/lib/docker/volumes/$VOLUME/_data
	if [ -d "$VOLUME_DIR" ]; then
	    rm -df $VOLUME_DIR
	    ln -s $PROJ_DIR $VOLUME_DIR
	fi
	;;

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
	docker build $PROJ_DIR/.dockerize --tag $IMAGE || exit 10
	#;;

  #  run)
	docker stop -t1 $INSTANCE > /dev/null || true
	docker rm $INSTANCE > /dev/null || true

	#docker run -v $VOLUME:/myapp -dt --name $INSTANCE $IMAGE jekyll build --trace

	docker run -v $VOLUME:/myapp -dt -p $HTTP_PORT:4000 --name $INSTANCE $IMAGE \
      jekyll serve --trace --force_polling -H 0.0.0.0 -P 4000 > /dev/null
  
  sleep 2s
  if [ $(docker inspect -f '{{.State.Running}}' $INSTANCE) = "true" ]; then
    echo "Instance '$INSTANCE' started successfully. Show logs ..."
    docker logs -f $INSTANCE
  else
    docker logs $INSTANCE
  fi
	;;
esac
