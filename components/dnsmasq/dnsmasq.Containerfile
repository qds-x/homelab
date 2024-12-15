FROM alpine
RUN apk update \
	&& apk --no-cache add dnsmasq

COPY dnsmasq.conf /etc/dnsmasq.conf

# EXPOSE 53/tcp
EXPOSE 53/udp

# By default dnsmasq forks into background
CMD [ "dnsmasq", "-k" ]