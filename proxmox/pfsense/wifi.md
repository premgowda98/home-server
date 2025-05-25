# PFSense Virtual Router Setup Guide

## Overview
This guide documents the complete setup of a virtualized PFSense router running on Proxmox, with Wi-Fi access point integration using a secondary router configured as an access point.

## Network Architecture

```
Internet
   |
Router (Main ISP Router)
   |
   | Physical Connection
   |
NUC Server (Proxmox Host)
   |
   ├── VMBR0 (WAN Bridge) ──→ PFSense VM (WAN Interface)
   |                              |
   └── VMBR1 (LAN Bridge) ──→ PFSense VM (LAN Interface: 10.10.10.1)
           |                      |
           ├── Windows VM ────────┘
           |
           └── USB Ethernet Adapter
                   |
           Secondary Router (AP Mode)
           IP: 10.10.10.2
           DHCP: Disabled
                   |
               Wi-Fi Clients
```

## Hardware Requirements
- NUC Server running Proxmox
- Main router (ISP connection)
- Secondary router (for Wi-Fi AP)
- USB Ethernet adapter
- Ethernet cables

## Step-by-Step Setup Process

### Phase 1: Proxmox Network Bridge Configuration

1. **Initial Setup Verification**
   - Ensure NUC is connected to main router
   - Verify Proxmox is running and accessible
   - Confirm VMBR0 is already configured and connected to physical network interface

2. **Create Additional Network Bridge**
   - In Proxmox web interface, go to System → Network
   - Create new bridge: **VMBR1**
   - **Important**: Do NOT assign any physical network device to VMBR1
   - This will be an internal bridge for LAN traffic

### Phase 2: PFSense Virtual Machine Setup

3. **Create PFSense VM**
   - Create new virtual machine in Proxmox
   - Allocate appropriate resources (RAM, CPU, Storage)
   - Add two network interfaces:
     - **Network Device 1**: Connect to VMBR0 (WAN)
     - **Network Device 2**: Connect to VMBR1 (LAN)

4. **Install PFSense**
   - Boot VM with PFSense ISO
   - During installation, configure network interfaces:
     - **WAN Interface**: Assign to VMBR0
     - **LAN Interface**: Assign to VMBR1
   - Complete PFSense installation

5. **Initial PFSense Configuration**
   - Set LAN IP address: **10.10.10.1**
   - Set LAN subnet mask: **255.255.255.0** (/24)
   - Enable DHCP server on LAN (10.10.10.100-10.10.10.200 range)
   - **Critical**: Ensure default gateway is set on WAN interface (not LAN)

### Phase 3: Test VM Setup

6. **Create Test Windows VM**
   - Create new Windows VM in Proxmox
   - Connect network interface to **VMBR1**
   - Boot Windows VM
   - Verify it receives IP address from PFSense DHCP (10.10.10.x range)

7. **Access PFSense Web Interface**
   - From Windows VM, open browser
   - Navigate to: **http://10.10.10.1**
   - Login to PFSense web interface
   - Verify internet connectivity works

### Phase 4: Secondary Router Configuration (Wi-Fi AP)

8. **Prepare Secondary Router**
   - Connect power to secondary router
   - Connect LAN port of router to laptop using ethernet cable
   - Access router interface: **http://192.168.0.1**

9. **Configure Router as Access Point**
   - **Disable DHCP server** on the router
   - Change router IP address to: **10.10.10.2**
   - Set subnet mask: **255.255.255.0**
   - Set gateway: **10.10.10.1** (PFSense LAN IP)
   - Save configuration and reboot router

### Phase 5: Physical Connection Integration

10. **Connect USB Ethernet Adapter**
    - Connect USB Ethernet adapter to NUC
    - In Proxmox, identify the new network interface
    - Edit VMBR1 configuration
    - Assign the USB Ethernet adapter as the **Bridge Port** for VMBR1

11. **Connect Secondary Router**
    - Disconnect ethernet cable from laptop
    - Connect secondary router's LAN port to USB Ethernet adapter
    - Router should now be part of PFSense's LAN network

### Phase 6: Final Testing

12. **Verify Complete Setup**
    - Secondary router should receive IP 10.10.10.2 from PFSense
    - Wi-Fi should be available from secondary router
    - Connect mobile device to Wi-Fi
    - Test internet connectivity through the entire chain

## Network Flow
```
Internet → Main Router → NUC/Proxmox → PFSense VM (WAN) → PFSense VM (LAN) → Secondary Router (AP) → Wi-Fi Clients
```

## Troubleshooting Issues Encountered

### Issue 1: Default Gateway Configuration
**Problem**: PFSense default gateway was set on LAN instead of WAN

**Symptoms**:
- Local network communication works fine
- No internet access through PFSense
- Internal routing between VMs works
- Cannot reach external websites

**Solution**:
- Access PFSense web interface (10.10.10.1)
- Go to System → Routing → Gateways
- Ensure default gateway is assigned to WAN interface
- Remove any default gateway assignment from LAN interface
- Save and apply changes

**Root Cause**: When default gateway is on LAN, PFSense tries to route internet traffic back to the internal network instead of forwarding it to the WAN interface.

### Issue 2: Docker Network Conflict
**Problem**: Unable to access router configuration at 192.168.0.1 from laptop

**Symptoms**:
- Browser cannot reach 192.168.0.1
- Connection appears to loop back locally
- Router is powered on and functioning

**Solution**:
- Check for Docker networks using: `docker network ls`
- Identify conflicting network (likely using 192.168.0.0/24 range)
- Remove conflicting Docker network: `docker network rm <network_name>`
- Alternative: Temporarily stop Docker service during router configuration

**Root Cause**: Docker had created a bridge network using the 192.168.0.1 address space, causing routing conflicts when trying to access the physical router's management interface.

## Key Configuration Points

### PFSense Critical Settings
- **WAN Interface**: Connected to VMBR0 (receives IP from main router)
- **LAN Interface**: Connected to VMBR1 (IP: 10.10.10.1/24)
- **Default Gateway**: Must be on WAN interface
- **DHCP Server**: Enabled on LAN (10.10.10.100-200 range)

### Secondary Router Settings
- **Mode**: Access Point (DHCP disabled)
- **IP Address**: 10.10.10.2/24
- **Gateway**: 10.10.10.1 (PFSense)
- **Connection**: LAN port to USB Ethernet adapter

### Proxmox Network Bridges
- **VMBR0**: Connected to physical NIC (WAN traffic)
- **VMBR1**: Connected to USB Ethernet adapter (LAN traffic)

## Benefits of This Setup
1. **Centralized Firewall**: All traffic passes through PFSense
2. **Network Segmentation**: Clear separation between WAN and LAN
3. **Flexible Management**: Full control over routing, firewall rules, and DHCP
4. **Wi-Fi Integration**: Seamless wireless access point integration
5. **Scalability**: Easy to add more VMs to the internal network

## Future Considerations
- Consider VPN setup for remote access
- Implement additional firewall rules as needed
- Monitor bandwidth and performance
- Regular PFSense updates and backups
- Consider redundancy for critical services