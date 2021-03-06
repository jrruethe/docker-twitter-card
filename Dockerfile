# docker-twitter-card 2016-05-11 21:36:45 -0400
FROM phusion/baseimage:0.9.18
MAINTAINER jrruethe@gmail.com

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 4.4.4

COPY optipng /root/optipng

COPY Dockerfile /Dockerfile
COPY Dockerfile.yml /Dockerfile.yml

RUN `# Updating Package List`                                                       &&       \
     DEBIAN_FRONTEND=noninteractive apt-get update                                  &&       \
                                                                                             \
    `# Installing packages`                                                         &&       \
     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends               \
     build-essential                                                                         \
     curl                                                                                    \
     libfontconfig1                                                                          \
     xvfb                                                                                    \
                                                                                             \
    `# Cleaning up after installation`                                              &&       \
     DEBIAN_FRONTEND=noninteractive apt-get clean                                   &&       \
     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*                                  &&       \
                                                                                             \
                                                                                             \
     for key in                                                                              \
     9554F04D7259F04124DE6B476D5A82AC7E37093B                                                \
     94AE36675C464D64BAFA68DD7434390BDBE9B9C5                                                \
     0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93                                                \
     FD3A5288F042B6850C66B31F09FE44734EB7990E                                                \
     71DCFD284A79C3B38668286BC97EC7A07EDE3FC1                                                \
     DD8F2338BAE7501E3DD5AC78C273792F7D83545D                                                \
     B9AE9905FFD7803F25714661B63B535A4C206CA9                                                \
     C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8                                                \
     ; do                                                                                    \
     gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key";                          \
     done                                                                           &&       \
                                                                                             \
     curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
     && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc"                \
     && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc                     \
     && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c -       \
     && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1   \
     && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt &&       \
                                                                                             \
     npm install -g webshot-cli                                                     &&       \
     ln -s /usr/bin/nodejs /usr/bin/node                                            &&       \
     ln -s /root/optipng /usr/bin/optipng                                           &&       \
                                                                                             \
    `# Removing build dependencies`                                                 &&       \
     DEBIAN_FRONTEND=noninteractive apt-get purge -y                                         \
     build-essential                                                                        

ENTRYPOINT ["/sbin/my_init"]
