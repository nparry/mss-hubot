#!/bin/bash
BOT_ID=$1
[ -z $BOT_ID ] && echo "Please provide BOT_ID" && exit 1

SLACK_TOKEN=$2
[ -z $SLACK_TOKEN ] && echo "Please provide SLACK_TOKEN" && exit 1

WUNDERGROUND_KEY=$3
[ -z $WUNDERGROUND_KEY ] && echo "Please provide WUNDERGROUND_KEY" && exit 1

CSE_ID=$4
[ -z $CSE_ID ] && echo "Please provide CSE_ID" && exit 1

CSE_KEY=$5
[ -z $CSE_KEY ] && echo "Please provide CSE_KEY" && exit 1

echo "Starting Redis"
docker pull redis
docker run \
  --detach \
  --name=${BOT_ID}-hubot-brain \
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
    --name=${BOT_ID}-hubot \
    --link ${BOT_ID}-hubot-brain:brain \
    -e REDISTOGO_URL=redis://brain:6379 \
    -e HUBOT_SLACK_TOKEN=$SLACK_TOKEN \
    -e HUBOT_WUNDERGROUND_API_KEY=$WUNDERGROUND_KEY \
    -e HUBOT_GOOGLE_CSE_ID=$CSE_ID \
    -e HUBOT_GOOGLE_CSE_KEY=$CSE_KEY \
    nparry/mss-hubot -a slack

  echo "Bot has exited"
  sleep 2
done
