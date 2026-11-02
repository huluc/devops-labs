# Docker Networking – Isolation Test with Ping

Ironhack DevOps bootcamp lab: prove that containers on different networks can't talk to each other, then connect them.

## Scenario

| Container  | Network                                  |
|------------|------------------------------------------|
| container1 | `isolatedNetwork` (192.168.1.0/24)       |
| container2 | default `bridge` → later also `isolatedNetwork` |

## Results

| Test | Result | Why |
|------|--------|-----|
| Ping by name, different networks | ❌ `bad address` | Docker DNS only resolves containers on a shared network; the default bridge has no DNS at all |
| Ping by IP, different networks | ❌ 100% packet loss | Docker blocks traffic between networks with firewall rules |
| Ping by name after `docker network connect` | ✅ | Both containers share `isolatedNetwork` |

Run everything with `./commands.sh`.

## Changes compared to the lab instructions

- `alpine` instead of `centos` (CentOS Linux is end-of-life, the image is deprecated; Alpine is tiny and includes `ping`).
- `ping -c 3` so the command stops by itself.
- Tested both name and IP to separate the two blockers (DNS vs. firewall isolation).

## What I learned

- **Default bridge vs. user-defined bridge:** same driver, but user-defined networks add DNS and isolation.
- **Other drivers:** `host` (shares host network, no isolation), `none` (no network), `overlay` (multi-host), `macvlan` (container appears as its own device on the LAN).
- **`docker network connect` adds a door, not a bridge:** container2 is on both networks, but container1 still can't reach the default bridge.
- **Bridge containers always get private IPs:** outbound via NAT (Network Address Translation), inbound via published ports (`-p`).

