# Wireguard

Secrets are currently just written locally in ~/secrets/wireguard.yml. Can be regenerated whenever.

## Deploy on new client
- generate private key `wg genkey`
- extract public key `echo -n key | wg pubkey`
- write to secrets/wireguard.yml
- update hostvars in inventory with wireguard ip
- run e.g. `ansible-playbook -i inventory/homelab.yml wireguard_client.yml -l tipton.main.home`
- update server config: `ansible-playbook -i inventory/homelab.yml wireguard_client.yml -l dragonstone.main.home`

