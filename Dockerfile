FROM alpine:latest
MAINTAINER Jack Halford [jack.0x5.be]

# nut is in testing
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# busybox-extras for inetd
RUN apk update && apk add busybox-extras nut bash gawk

COPY http_wrapper.sh /
COPY upsc_exporter.sh /
COPY upsc_to_prometheus.awk /
COPY inetd.conf /etc/

ENTRYPOINT ["inetd", "-f"]
