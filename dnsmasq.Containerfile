FROM alpine
RUN apk update \
	&& apk --no-cache add dnsmasq