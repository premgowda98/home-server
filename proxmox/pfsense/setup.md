# pfsense


1. Install ISO Image [here](https://atxfiles.netgate.com/mirror/downloads/) 
2. Need to have 2 network devices on proxmox
   1. By default vmbr0 is created
3. Now on the proxmox server, create 2 network bridges:
   - `vmbr0` for WAN which is already created by promox
   - `vmbr1` for LAN -> create this and do not atach any physical device to it
4. Sources:
   1. [1](https://www.youtube.com/watch?v=ZnT29rP-11s)
   2. [2](https://www.youtube.com/watch?v=RpCjlyvOt18)
5. In the setting Choose option 2 to set ip address for wan and lan
   1. For wan choose the ip address assigned by the router and also provide a gateway
   2. For lan choose ip address like `10.10.10.1` but do not enter any gateway and enable DHCP server on lan interface
   3. Once done, attach any other VM and add network driver i.e vmbr1 with has pfsens lan
   4. Now in this VM open browser with `10.10.10.1` and pfsense web interface will open
   5. Login with default credentials:
      - Username: `admin`
      - Password: `pfsense`