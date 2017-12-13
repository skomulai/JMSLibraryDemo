#!/bin/bash

OVERRIDE_DIR=$(dirname $(readlink -f $0))/../artemis-etc-override

docker run --name=artemis_mq -e 'ARTEMIS_MAX_MEMORY=1024M' -e ARTEMIS_USERNAME=admin -e ARTEMIS_PASSWORD=admin -d -p 8161:8161 -p 61616:61616 -v $OVERRIDE_DIR:/var/lib/artemis/etc-override --rm vromero/activemq-artemis:2.3.0
docker ps
