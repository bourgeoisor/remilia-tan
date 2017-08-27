#!/bin/sh
set -e

HUBOT_IRC_NICK="remilia-tan"
HUBOT_ALIAS="!"

export HUBOT_IRC_SERVER="irc.rizon.net"
export HUBOT_IRC_ROOMS="#wanikanidev"
export HUBOT_IRC_NICK=$HUBOT_IRC_NICK

export HUBOT_HELP_REPLY_IN_PRIVATE="true"

ARGS=$1
case $ARGS in
    shell)
        node_modules/hubot/bin/hubot --name "$HUBOT_IRC_NICK" --alias "$HUBOT_ALIAS"
        ;;
    *)
        node_modules/hubot/bin/hubot -a irc --name "$HUBOT_IRC_NICK" --alias "$HUBOT_ALIAS"
        ;;
esac

