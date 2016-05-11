#!/bin/bash

set -e

if [ "$#" -ne 2 ]; then
   echo "Usage: card.sh <type> <description>"
   exit 1
fi

TYPE=$1
DESCRIPTION=$2

urlencode() {
  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "$c" ;;
    *) printf "$c" | xxd -p -c1 | while read x;do printf "%%%s" "$x";done
    esac
  done
}

TITLE=$(urlencode "${DESCRIPTION}")
AVATAR=$(urlencode "http://jrruethe.github.io/blog/twitter-card/avatar.png")
TWITTER=$(urlencode "@jrruethe")
STICKER=$(urlencode "stickers/${TYPE}.png")
BACKGROUND=$(urlencode "#ccc url(https://source.unsplash.com/featured/1200x630/?water) top left no-repeat")

URL="http://jrruethe.github.io/blog/twitter-card/index.html?title=$TITLE&avatar=$AVATAR&twitter=$TWITTER&sticker=$STICKER&background=$BACKGROUND"

docker run --rm -v `pwd`:/mnt -w /mnt docker-twitter-card -- webshot --window-size=1200/630 --render-delay=1000 $URL twitter-card.png
docker run --rm -v `pwd`:/mnt -w /mnt docker-twitter-card -- /root/optipng -o7 twitter-card.png

