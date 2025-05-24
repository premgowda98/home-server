# pfSense - Complete Guide & Notes

## What is pfSense?

pfSense is a free, open-source firewall and router software distribution based on FreeBSD. It's designed to be installed on a computer to create a dedicated firewall/router for a network. pfSense is widely used in enterprise environments, home labs, and small to medium businesses as a cost-effective alternative to commercial firewall solutions.

## Key Features

### Core Networking Features
- **Firewall**: Stateful packet filtering with advanced rules
- **Router**: Multi-WAN support, load balancing, failover
- **VPN Server/Client**: OpenVPN, IPsec, WireGuard support
- **DHCP Server**: Dynamic IP assignment with reservations
- **DNS Server**: Unbound DNS resolver with filtering capabilities
- **Network Address Translation (NAT)**: Port forwarding, 1:1 NAT
- **Quality of Service (QoS)**: Traffic shaping and bandwidth management

### Advanced Features
- **High Availability (HA)**: CARP (Common Address Redundancy Protocol)
- **Load Balancing**: Distribute traffic across multiple servers
- **Captive Portal**: User authentication for guest networks
- **Intrusion Detection/Prevention (IDS/IPS)**: Suricata and Snort integration
- **Web Filtering**: pfBlockerNG for content filtering and ad blocking
- **Monitoring**: Real-time traffic analysis, logging, and reporting

### Package System
- **Package Manager**: Extend functionality with additional packages
- **Popular Packages**:
  - pfBlockerNG: Advanced blocking and filtering
  - Suricata: IDS/IPS functionality
  - ntopng: Network traffic monitoring
  - FRR: Advanced routing protocols (BGP, OSPF)
  - HAProxy: Load balancing and reverse proxy

## System Requirements

### Minimum Requirements
- **CPU**: 500 MHz processor
- **RAM**: 512 MB (1GB+ recommended)
- **Storage**: 4GB disk space (8GB+ recommended)
- **Network**: At least 2 network interfaces (WAN + LAN)

### Recommended for Production
- **CPU**: Multi-core processor (2+ cores)
- **RAM**: 2GB+ (4GB+ for heavy usage)
- **Storage**: SSD for better performance
- **Network**: Gigabit interfaces for high throughput

## Installation Methods

### 1. Bare Metal Installation
- Download ISO from pfSense website
- Boot from USB/CD and follow installer
- Best performance, full hardware access

### 2. Virtual Machine Installation
- **VMware**: vSphere, Workstation, Player
- **Proxmox**: KVM virtualization
- **Hyper-V**: Windows Server virtualization
- **VirtualBox**: Desktop virtualization

### 3. Hardware Appliances
- Official Netgate appliances
- Third-party pfSense-compatible hardware

## Configuration Basics

### Initial Setup
1. **Console Setup**: Configure interfaces via console
2. **Web Interface**: Access via https://192.168.1.1
3. **Setup Wizard**: Configure basic settings
4. **Interface Assignment**: Map physical ports to logical interfaces

### Essential Configurations
- **WAN Configuration**: Internet connection settings
- **LAN Configuration**: Internal network settings
- **Firewall Rules**: Allow/deny traffic rules
- **NAT Rules**: Port forwarding for services
- **DHCP Settings**: IP address distribution

## Common Use Cases

### Home Lab
- Separate network segments
- VPN access to home network
- Ad blocking and content filtering
- Guest network isolation

### Small Business
- Internet gateway and firewall
- Site-to-site VPN connections
- Guest portal for customers
- Bandwidth management

### Enterprise Edge
- Multi-WAN redundancy
- Advanced routing protocols
- High availability clustering
- Compliance and logging

## Networking Concepts

### Interfaces
- **WAN**: Internet-facing interface
- **LAN**: Internal network interface
- **DMZ**: Demilitarized zone for servers
- **OPT**: Optional interfaces for VLANs/segments

### VLANs
- Virtual network segmentation
- Isolate different network segments
- Trunk configuration on switches
- Inter-VLAN routing capabilities

### Routing
- Static routes for specific destinations
- Dynamic routing with FRR package
- Multi-WAN load balancing
- Policy-based routing

## Security Features

### Firewall Rules
- Default deny policy
- Stateful connection tracking
- Source/destination filtering
- Protocol-specific rules

### VPN Configuration
- **OpenVPN**: SSL/TLS-based VPN
- **IPsec**: Industry-standard VPN
- **WireGuard**: Modern, fast VPN protocol

### Security Packages
- **Suricata**: Network IDS/IPS
- **pfBlockerNG**: DNS/IP blocking
- **Snort**: Intrusion detection

## Monitoring & Maintenance

### Built-in Monitoring
- Dashboard with system status
- Real-time traffic graphs
- System logs and alerts
- Performance metrics

### Backup & Recovery
- Configuration backup/restore
- Automatic configuration history
- Package configuration backup
- Gold/master configuration images

### Updates
- Regular security updates
- Version upgrade process
- Configuration migration
- Testing in lab environment

## Best Practices

### Security
- Change default passwords
- Enable HTTPS for web interface
- Regular security updates
- Proper firewall rule documentation

### Performance
- Adequate hardware sizing
- Regular monitoring
- Traffic analysis
- Capacity planning

### Maintenance
- Regular configuration backups
- Change documentation
- Testing before production changes
- Disaster recovery planning

## Troubleshooting

### Common Issues
- Interface assignment problems
- DNS resolution issues
- VPN connectivity problems
- Performance bottlenecks

### Diagnostic Tools
- **Ping/Traceroute**: Network connectivity
- **Packet Capture**: Traffic analysis
- **System Logs**: Error investigation
- **Traffic Graphs**: Performance monitoring

## Resources

### Documentation
- [Official pfSense Documentation](https://docs.netgate.com/pfsense)
- [pfSense Book](https://docs.netgate.com/pfsense/en/latest/book/)
- Community forums and Reddit

### Training
- Netgate official training courses
- YouTube tutorials
- Hands-on lab practice
- Community workshops

## Licensing

- **Community Edition (CE)**: Free, open-source
- **Netgate pfSense Plus**: Commercial version with additional features
- **Support Options**: Community support vs. commercial support

---

*Note: This guide serves as a comprehensive reference for pfSense. Always refer to official documentation for the most up-to-date information and specific configuration details.*