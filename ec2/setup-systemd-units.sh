#!/bin/bash

[ -d /home/core/hubot ] || git clone https://github.com/nparry/mss-hubot.git /home/core/hubot

for ARG in "$@"; do
  NAME=$(cut -d' ' -f1 <<<"$ARG")
  SLACK_TOKEN=$(cut -d' ' -f2 <<<"$ARG")
  WUNDERGROUND_KEY=$(cut -d' ' -f3 <<<"$ARG")

  echo "Settings:"
  echo $NAME
  echo $SLACK_TOKEN
  echo $WUNDERGROUND_KEY

  echo "Creating systemd service for $NAME"
  cat > /etc/systemd/system/hubot-$NAME.service <<END_OF_UNIT
  [Unit]
  Description=Hubot for $NAME

  [Service]
  User=core
  ExecStart=/home/core/hubot/ec2/run-hubot-for-slack.sh $NAME $SLACK_TOKEN $WUNDERGROUND_KEY
END_OF_UNIT
  systemctl start hubot-$NAME.service
done

