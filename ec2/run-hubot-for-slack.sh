#!/bin/bash
# Dumb utility script to keep hubot running on Slack.
# Run this in a screen session!!
SLACK_TOKEN=$1

while true; do
  echo "Pulling latest bot image"
  docker pull nparry/mss-hubot

  echo "Cleaning up obsolete images"
  docker images | grep none | awk '{ print $3 }' | while read IMAGE; do
    echo "Cleaning up $IMAGE"
    docker rmi $IMAGE
  done

  echo "Starting bot"
  docker run --rm --name="mss-hubot" --net=host -e REDISTOGO_URL=redis://localhost:6379 -e HUBOT_SLACK_TOKEN=$SLACK_TOKEN nparry/mss-hubot -a slack -d

  echo "Bot has exited"
  sleep 2
done
