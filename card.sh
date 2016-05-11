#!/bin/bash

set -e

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

TITLE=$(urlencode "Take control of your Twitter feed and make your posts stand out")
AVATAR=$(urlencode "http://jrruethe.github.io/blog/twitter-card/avatar.png")
TWITTER=$(urlencode "@jrruethe")
STICKER=$(urlencode "stickers/docker.png")
BACKGROUND=$(urlencode "#ccc url(https://source.unsplash.com/featured/1200x630/?mountains) top left no-repeat")

URL="http://jrruethe.github.io/blog/twitter-card/index.html?title=$TITLE&avatar=$AVATAR&twitter=$TWITTER&sticker=$STICKER&background=$BACKGROUND"

docker run --rm -v `pwd`:/mnt -w /mnt docker-twitter-card -- webshot --window-size=1200/630 --render-delay=1000 $URL twitter-card.png
# docker run --rm -v `pwd`:/mnt -w /mnt titpetric/webshot-cli --window-size=1200/630 --render-delay=2000 $URL twitter-card.png
# docker run --rm -v `pwd`:/mnt -w /mnt docker-twitter-card -- /root/optipng -o7 twitter-card.png

