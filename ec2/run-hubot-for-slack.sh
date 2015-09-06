#!/bin/bash
SLACK_TOKEN=$1
WUNDERGROUND_KEY=$2

echo "Starting Redis"
docker pull redis
docker run \
  --detach \
  --name=mss-hubot-brain \
  redis

while true; do
  echo "Pulling latest bot image"
  docker pull nparry/mss-hubot

  echo "Cleaning up obsolete images"
  docker images | grep none | awk '{ print $3 }' | while read IMAGE; do
    echo "Cleaning up $IMAGE"
    docker rmi $IMAGE
  done

  echo "Starting bot"
  docker run \
    --rm \
    --name=mss-hubot \
    --link mss-hubot-brain:brain \
    -e REDISTOGO_URL=redis://brain:6379 \
    -e HUBOT_SLACK_TOKEN=$SLACK_TOKEN \
    -e HUBOT_WUNDERGROUND_API_KEY=$WUNDERGROUND_KEY \
    nparry/mss-hubot -a slack

  echo "Bot has exited"
  sleep 2
done
