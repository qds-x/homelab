# dnsmasq

## Summary

This deploys an instance of `dnsmasq` on `dragonstone`.

Running a separate DHCP/DNS server has a few advantages:
- You now have central DNS in which you can add custom records
- Hostnames are resolvable by all machines on network. The router should do this but in my case freebox neither allowed me to add custom DNS records nor would add records for locally configured hostnames.

## Behaviour

This requires turning off the integrated DHCP server on your router, as having two DHCP servers responding to `DHCPDISCOVER` broadcasts is a big nono. 

`dnsmasq` will create DNS records for locally configured hostnames. On top of this, we configure a domain, so that records are created for `hostname.domain` and clients are configured to search this domain.

Insofar as DHCP is concerned, the host `dnsmasq` runs on cannot be also be a client afaik, which means the server host must be manually configured:
    - with a static IP. We add static DNS entry in `dnsmasq`
    - can we configure the host to use localhost as a DNS server?

It's possible to deploy `dnsmasq` as just a DNS server. In this case we would not need to run the container with `host-networking` enabled, and instead just forward a port. This would also allow us to run without adding the `NET_ADMIN` cap. However this is of limited use as we want to take advantage of dynamic DNS entries following DHCP assignments.

## Technical notes

- DHCP somewhat confusingly operates on layer3 in that it sends layer3 broadcast packets (UDP) on the local broadcast address. The server listens on port 68 and clients on 67.
- DNS standard port is 53
- DHCP relays notwithstanding (which I don't want to get into), a DHCP serer needs to have an interface on the same LAN it distributes IPs on. This means we need to use docker's `host-networking` option. 

## To do

- ansible to deploy probably

## Build

```
docker build . -t dnsmasq -f dnsmasq.Containerfile
```

## Deploy

```bash
# Full
docker run --name dnsmasq --rm -d --cap-add=NET_ADMIN --network=host --volume  ~/homelab/dnsmasq/persist:/persist dnsmasq

# Just DNS
docker run --name dnsmasq --rm -d --cap-add=NET_ADMIN -p 53:53/udp dnsmasq
```

## Debug
Test DNS from host:
```
dig +short @localhost -p 9053 dragonstone.main.home
```

Inspect DHCP leases on a client machine
```bash
# dhclient
/var/lib/dhcp/dhclient.br0.leases

# NetworkManager
ls -l /var/lib/NetworkManager/
nmcli device show wlp0s20f3
```