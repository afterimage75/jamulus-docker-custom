FROM alpine:3.11 as builder

ENV JAMULUS_VERSION 3_11_0

RUN \
 echo "**** updating system packages ****" && \
 apk update

RUN \
 echo "**** install build packages ****" && \
   apk add --no-cache --virtual .build-dependencies \
        build-base \
        wget \
        qt5-qtbase-dev \
        qt5-qttools-dev \
        qtchooser

WORKDIR /tmp
RUN \
 echo "**** getting source code ****" && \
   wget "https://github.com/jamulussoftware/jamulus/archive/latest.tar.gz" && \
   tar xzf latest.tar.gz


WORKDIR /tmp/jamulus-r${JAMULUS_VERSION}
RUN \
 echo "**** compiling source code ****" && \
   qmake "CONFIG+=nosound headless serveronly" Jamulus.pro && \
   make distclean && \
   make && \
   cp Jamulus /usr/local/bin/ && \
   rm -rf /tmp/* && \
   apk del .build-dependencies

FROM alpine:3.11

RUN apk add --update --no-cache \
    qt5-qtbase-x11 icu-libs tzdata

COPY --from=builder /usr/local/bin/Jamulus /usr/local/bin/Jamulus

CMD ["/usr/bin/nice","-n","-20","/usr/bin/ionice","-c","1","/usr/local/bin/Jamulus","-d -e 127.0.0.1 -F -n -o '├DaGarage Online┤;Asbury Park, NJ;us' -P -R /Jamulus/Recordings/Private -s -T -u 14 -w /Jamulus/Web/motd-jamulus-private.htm -Q 46 -p 22125"]

ENTRYPOINT ["Jamulus"]
