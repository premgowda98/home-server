# Squid Proxy Methods

## 1. Transparent Proxy
- Also called intercepting proxy.
- Client devices are unaware of the proxy; all traffic is redirected to Squid (e.g., via firewall rules).
- No proxy settings are needed on client devices.
- Useful for enforcing policies without user configuration.
- Limitations: Some protocols or HTTPS interception may not work seamlessly.

## 2. Regular (Explicit) Proxy
- Clients are configured to use the proxy (manually or via auto-config/PAC file).
- Proxy server is explicitly set in browser or system network settings.
- Easier to control and log traffic per user/device.
- Users can bypass the proxy if they change settings (unless restricted by firewall).

# Splice vs Bump (SSL Interception Modes)

When Squid handles HTTPS (SSL/TLS) traffic, it can operate in different modes:

## Splice
- Squid establishes a TCP connection but does not decrypt the SSL traffic.
- The proxy just passes encrypted data between client and server.
- Used when you want to allow SSL traffic without inspecting or modifying it.
- No certificate warnings for users.

## Bump
- Squid performs SSL interception (also called SSL bumping).
- Squid decrypts and inspects HTTPS traffic, then re-encrypts it to the client.
- Allows content filtering, logging, and policy enforcement on HTTPS.
- Requires Squid to present its own certificate to clients (may need to install CA cert on clients to avoid warnings).
- Can break some secure applications or cause privacy concerns.

```bash
acl manager proto cache_object
acl localhost src 127.0.0.1
http_access allow manager localhost
http_access deny manager

```

```bash
# Match domain and subdomains
acl bump_sites ssl::server_name_regex -i ^(.+\.)?yourdomain\.com$

# Bump only for the matched domains
ssl_bump bump bump_sites

# Splice everything else
ssl_bump splice all

```