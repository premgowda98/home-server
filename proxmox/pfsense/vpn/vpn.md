## 🔑 Overview: What Are We Comparing?

| Term               | Connects What?                      | Purpose                              | Example                    |
| ------------------ | ----------------------------------- | ------------------------------------ | -------------------------- |
| **Point-to-Point** | One device to another               | Direct device communication          | Laptop ↔ Server            |
| **Site-to-Site**   | One network to another              | Link remote LANs over the internet   | Office ↔ Data Center       |
| **VPN Mesh**       | Many devices/networks to each other | Peer-to-peer communication among all | Laptop ↔ VM ↔ NAS ↔ Server |

---

## 🧩 1. **Point-to-Point VPN**

### 🔗 Definition:

A direct encrypted connection **between two devices** (peers).

### 📌 Use Case:

* SSH to a remote machine securely
* IoT device ↔ server
* Admin laptop ↔ single firewall/router

### 🔧 Technologies:

* WireGuard
* OpenVPN (client-server mode)

### 🖼️ Diagram:

```
[Device A] <==== VPN Tunnel ====> [Device B]
```

---

## 🏢 2. **Site-to-Site VPN**

### 🔗 Definition:

Connects **two networks (LANs)** so that devices in both networks can talk as if they’re on the same local network.

### 📌 Use Case:

* Connect branch office to HQ
* Hybrid cloud: on-prem ↔ cloud VPC
* PFSense ↔ another PFSense

### 🔧 Technologies:

* IPSec
* OpenVPN (routing mode)
* WireGuard (manual config)

### 🖼️ Diagram:

```
[Network A] <==== VPN Tunnel ====> [Network B]
  (10.0.0.0/24)                    (192.168.1.0/24)
```

Every device in A can talk to every device in B over the VPN tunnel.

---

## 🌐 3. **VPN Mesh Network**

### 🔗 Definition:

A dynamic, peer-to-peer network where **every node can talk to every other node** securely, with minimal or no central configuration.

### 📌 Use Case:

* Teams working remotely
* Access homelab, cloud, and dev machines seamlessly
* Peer-to-peer services

### 🔧 Technologies:

* **Tailscale** (based on WireGuard)
* **Nebula**, **ZeroTier**
* **Netmaker** (WireGuard mesh)

### 🖼️ Diagram:

```
     [Device A]
     /       \\
[Device B]--[Device C]
    \\      /
     [Device D]
```

Each node can securely talk to any other — without needing to go through a central VPN server.

---

## ✅ Summary Table

| Feature               | Point-to-Point     | Site-to-Site         | VPN Mesh                      |
| --------------------- | ------------------ | -------------------- | ----------------------------- |
| 🔗 Connection Type    | Device ↔ Device    | LAN ↔ LAN            | Many ↔ Many                   |
| 📶 Devices Supported  | 2 devices          | 2+ devices per site  | Many peers                    |
| 🔧 Config Complexity  | Simple             | Moderate             | Automated (in mesh solutions) |
| 🔁 Peer Communication | One-to-one         | LAN-wide             | Any-to-any                    |
| ⚙️ Management         | Manual             | Needs routing tables | Often auto-managed            |
| 🧰 Example Tools      | WireGuard, OpenVPN | IPSec, PFSense VPN   | Tailscale, Nebula, ZeroTier   |

---

## 🎯 When to Use What?

| Use Case                           | Best Fit       |
| ---------------------------------- | -------------- |
| Secure a laptop to a server        | Point-to-Point |
| Connect two office networks        | Site-to-Site   |
| Seamless remote team collaboration | VPN Mesh       |
| Access homelab from anywhere       | VPN Mesh       |
| Connect AWS VPC to on-prem LAN     | Site-to-Site   |
