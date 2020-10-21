FROM alpine:latest

RUN \
	apk --no-cache update && \
	apk --no-cache upgrade

RUN \
	apk --no-cache --update add sudo busybox-suid

RUN \
	echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories && \
	echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
	rm -f /var/cache/apk/* && \
	apk --no-cache update && \
	apk --no-cache --update add exim && \
	echo "http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/main" > /etc/apk/repositories && \
	echo "http://dl-cdn.alpinelinux.org/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/community" >> /etc/apk/repositories && \
	rm -f /var/cache/apk/* && \
	apk --no-cache update

RUN \
	mkdir -p /var/log/exim && \
	mkdir -p /scripts /scripts/entrypoint.d

COPY entrypoint.sh /scripts/entrypoint.sh

VOLUME ["/scripts/entrypoint.d"]
VOLUME ["/var/mail"]

EXPOSE 25 465 587

STOPSIGNAL SIGTERM

ENTRYPOINT ["/scripts/entrypoint.sh"]

CMD ["exim", "-bdf", "-v", "-q30m"]
