#!/bin/bash

# Building image
docker build -t docker-twitter-card .

# Saving image
echo Saving image...
rm -f docker-twitter-card_*.tar.bz2
docker save docker-twitter-card | bzip2 -9 > docker-twitter-card_`date +%Y%m%d%H%M%S`.tar.bz2
