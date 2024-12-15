# homelab

## dnsmasq

- to see leases see `/var/lib/dhcp/dhclient.br0.leases` or `/var/lib/NetworkManager/`, `nmcli device show wlp0s20f3`
- default behaviour is to learn hostnames? Then we add a domain.
- dnsmasq server can't be a client of itself afaict. So there's some manual configuration
    - static DNS entry
    - can we configure to use itself as a DNS server?
- DNS somewhat confusingly operates on layer3 in that it sends layer3 broadcast packets over UDP
- how are we setting the IP of the DHCP server itself?
- you can run it as just a DNS server, but that's of limited use, given we want to serve hostnames etc.
- ansible to deploy probably.
- why do we want to run `dnsmasq` standalone? because 
    - router wasn't functioning as DNS server properly
        - not serving host names
        - doesn't allow adding own records
    - we could run it just in DNS server mode, then it wouldn't need host networking, but then it couldn't resolve for DHCP hosts. So why not run the whole thing standalone?
- why do we use host-networking? because the server needs to operate on the same LAN it distributes IPs on (without getting into DHCP relays)

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
E.g.
```
dig +short @localhost -p 9053 dragonstone.main.home
```
