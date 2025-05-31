Certainly! Here's a well-structured, comprehensive set of notes summarizing your debugging process, including commands and a mermaid diagram to visualize the network flow. This should help you quickly recall what happened and how you fixed it, even after a few months.

---

# Debugging IPv6 DNS Issue in Home Network with PFSense Router

---

## Background

* **Network setup:**

  * PFSense router used as the main home router.
  * IPv6 **disabled** on PFSense router's LAN interface.
  * LAN interface connected to a secondary router acting as a **Wi-Fi access point**.
  * Laptop connects to this Wi-Fi network (named `"Namaste Guest"`).
* **Problem:**

  * Despite IPv6 being disabled on the PFSense router, laptop **receives IPv6 Router Advertisements (RAs)**.
  * IPv6 DNS servers get assigned to the laptop after some browsing activity.
  * Initial DNS servers are IPv4 (e.g., `8.8.8.8`, `1.1.1.1`), but after some time the DNS server changes to an IPv6 address.
  * DNS resolution fails over IPv6 DNS, resulting in no internet access.

---

## Diagnosis Steps

1. **Check DNS servers on laptop:**

   ```bash
   resolvectl status
   ```

   * Shows DNS servers currently assigned per network interface.
   * Observed DNS servers initially IPv4, later switched to IPv6.

2. **Check DNS resolution behavior with `dig`:**

   * Test IPv4 DNS server:

     ```bash
     dig @8.8.8.8 google.com
     ```

     * Successful resolution.

   * Test IPv6 DNS server (assigned by router):

     ```bash
     dig @[IPv6-address] google.com
     ```

     * Fails, confirming problem is with IPv6 DNS server.

3. **Check NetworkManager settings for the Wi-Fi interface:**

   ```bash
   nmcli connection show "Namaste Guest"
   ```

   * Found IPv6 method set to `auto`, meaning DHCP server (PFSense) is advertising IPv6 capabilities.
   * DHCP server on PFSense is sending IPv6 info despite IPv6 being disabled on LAN interface.

---

## Root Cause

* The PFSense DHCP server (or Router Advertisements) is **still advertising IPv6 parameters** on the LAN.
* Laptop accepts these and configures IPv6 DNS automatically.
* DNS queries try to use IPv6 DNS servers, which are unreachable or not configured properly.
* This leads to browsing failures.

---

## Resolution Steps

1. **Disable IPv6 on the Wi-Fi interface explicitly using NetworkManager:**

   ```bash
   nmcli connection modify "Namaste Guest" ipv6.method ignore
   nmcli connection down "Namaste Guest" && nmcli connection up "Namaste Guest"
   ```

   * This disables IPv6 on the laptop **for that specific Wi-Fi network**.
   * The configuration is saved in NetworkManager.
   * IPv6 remains disabled on `"Namaste Guest"` even after reconnecting or switching networks.

2. **Verify with `resolvectl status`:**

   * Confirm that IPv6 DNS servers no longer appear for `"Namaste Guest"`.

3. **Check DNS resolution again using `dig`:**

   * IPv4 DNS servers work fine.
   * IPv6 DNS servers no longer interfere.

---

## Additional Notes

* **`/etc/resolv.conf`** usually points to:

  ```
  nameserver 127.0.0.53
  ```

  * This means system uses `systemd-resolved` as a **local DNS stub resolver**.
  * Real DNS servers are configured inside `systemd-resolved` and can be viewed with `resolvectl status`.

---

## Summary Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph "Home Network Infrastructure"
        PF["PFSense Router<br/>(IPv6 disabled on LAN)"]
        AP["Wi-Fi Access Point<br/>(Secondary Router)"]
        PF ---|"LAN Connection<br/>(IPv4 only)"| AP
    end
    
    subgraph "Client Device"
        Laptop["Laptop"]
        NM["NetworkManager"]
        Laptop --- NM
    end
    
    subgraph "Problem Flow"
        AP ---|"Wi-Fi: 'Namaste Guest'<br/>(IPv6 RA still advertised)"| Laptop
        NM ---|"Receives IPv6 DNS servers"| IPv6DNS["IPv6 DNS Servers<br/>(Unreachable)"]
        NM ---|"Also receives IPv4 DNS"| IPv4DNS["IPv4 DNS Servers<br/>(8.8.8.8, 1.1.1.1)"]
        IPv6DNS ---|"DNS queries fail"| FAIL["Internet Access Fails"]
    end
    
    subgraph "Solution"
        CMD["nmcli connection modify<br/>'Namaste Guest'<br/>ipv6.method ignore"]
        CMD ---|"Disables IPv6"| NM
        NM ---|"Uses only IPv4 DNS"| IPv4DNS
        IPv4DNS ---|"DNS queries succeed"| SUCCESS["Internet Access Works"]
    end
    
    style IPv6DNS fill:#ffcccc
    style FAIL fill:#ffcccc
    style SUCCESS fill:#ccffcc
    style CMD fill:#cceeff
```

---

## Key Commands Recap

| Purpose                                  | Command                                                                        |
| ---------------------------------------- | ------------------------------------------------------------------------------ |
| Show DNS servers and network status      | `resolvectl status`                                                            |
| Test DNS resolution with specific server | `dig @8.8.8.8 google.com` / `dig @[IPv6-address] google.com`                   |
| Show NetworkManager connection details   | `nmcli connection show "Namaste Guest"`                                        |
| Disable IPv6 on Wi-Fi connection         | `nmcli connection modify "Namaste Guest" ipv6.method ignore`                   |
| Restart Wi-Fi connection                 | `nmcli connection down "Namaste Guest" && nmcli connection up "Namaste Guest"` |

---

## Lessons Learned

* Disabling IPv6 on the router **does not guarantee** clients won’t receive IPv6 info if DHCP or RA still advertises it.
* Client-side settings via NetworkManager can override or ignore router-advertised IPv6.
* Use `nmcli` to persistently disable IPv6 on troublesome networks.
* Always verify DNS servers in use via `resolvectl status`.
* Use `dig` to explicitly test DNS resolution on specific servers.

---

If you revisit this after months, this document should help you remember:

* What the setup was.
* How the IPv6 leak happened.
* How you used `nmcli` to fix it on your laptop.
* How to verify the fix.

---

If you'd like, I can help you turn this into a Markdown file or a personal knowledge base note!
