## Wiregaurd VPN Configuration

[Source 1](https://youtu.be/IvGjWndvTk0)
[Source 2](https://youtu.be/XEGb3ajiyXA)

1. **Install WireGuard** on your pfsense UI.
2. Go to wiregaurd settings under VPN
3. Create Interafce `10.20.0.1/24` for wiregaurd network
4. Generate public-key and store it.
5. Enable wiregaurd on settings page.
6. Enable firewall rules for wiregaurd interface.
7. Install ubuntu client [source](https://youtu.be/jb3uMuYYLhQ)
   1. `wg genkey | tee privatekey | wg pubkey > publickey`
8. Disable the block private address rule in WAN interface.

/etc/wiregaurd/wg0.conf
```bash                                                                      
[Interface]
PrivateKey=2A2jdI6DMHKUzO7dip5EJpBrEXVmA1dTYpzOrf4ZjEI=
Address=10.20.0.10/24
DNS=8.8.8.8,1.1.1.1

[Peer]
PublicKey=EdHT+cy0uuzSgx3Id+FzlbLmvwXraKj6x6rFNN2hNBQ=
Endpoint=192.168.0.102:51820
AllowedIPs=10.20.0.0/24,10.10.10.0/24
PersistentKeepalive=25
```

```bash
sudo wg show
sudo wg-quick up wg0
sudo wg-quick down wg0
```