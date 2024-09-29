FROM debian:stable-slim

ENV VERSION latest

RUN echo "*** updating system packages ***"; \ 
    apt-get -qq update

RUN echo "*** prepare build environment ***"; \
    apt-get -y install --no-install-recommends wget devscripts build-essential qtbase5-dev qttools5-dev-tools

WORKDIR /tmp    
RUN echo "*** fetch jamulus source ***"; \
    wget https://github.com/jamulussoftware/jamulus/archive/${VERSION}.tar.gz; \
    tar xzf latest.tar.gz
    
WORKDIR /tmp/jamulus-${VERSION}   
RUN echo "*** compile jamulus ***"; \
   qmake "CONFIG+=nosound headless serveronly" Jamulus.pro; \
   make clean; \
   make; \
   cp Jamulus /usr/local/bin/Jamulus; \
   Jamulus --version

RUN echo "*** clean up build environment ***"; \
   rm -rf /tmp/*; \
   apt-get --purge -y remove wget devscripts build-essential qtbase5-dev qttools5-dev-tools; \
   apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
   
RUN echo "*** prepare run environment ***"; \
   apt-get -y install --no-install-recommends tzdata procps libqt5core5a libqt5network5 libqt5xml5

ENTRYPOINT ["Jamulus"]
