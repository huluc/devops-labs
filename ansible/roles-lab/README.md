# Ansible Roles Lab: Web Server + Load Balancer

Two Ansible roles (`webserver` and `loadbalancer`) deployed to two EC2 instances.
The load balancer is Apache running as a reverse proxy in front of an Apache + PHP web server.
The infrastructure is created with Terraform, the configuration is applied with Ansible.

## Architecture

```
  Visitor
     │  HTTP :80
     ▼
┌─────────────┐   private IP :80   ┌─────────────┐
│     lb1     │ ─────────────────▶ │    web1     │
│ Apache      │                    │ Apache +    │
│ (proxy)     │                    │ PHP         │
└─────────────┘                    └─────────────┘
```

The web server only accepts HTTP traffic from the load balancer's security group,
so the page is only reachable through the load balancer.

## Project structure

```
roles-lab/
├── infra/                 # Terraform: 2 EC2 instances, security groups, key pair
├── roles/
│   ├── webserver/         # Apache + PHP, deploys index.php
│   └── loadbalancer/      # Apache proxy modules + Jinja2 vhost template
└── playbooks/
    ├── ansible.cfg
    ├── hosts.example      # copy to "hosts" and fill in the IPs (real "hosts" is git-ignored)
    └── site.yml
```

## How to run

```bash
# 1. Create the servers
cd infra
terraform init
terraform apply
terraform output            # note the public IPs

# 2. Create the inventory
cd ../playbooks
cp hosts.example hosts      # fill in the IPs and your SSH key path

# 3. Check connectivity and run
ansible all -m ping
ansible-playbook site.yml

# 4. Verify
curl http://<LB_PUBLIC_IP>/                 # → Hello, World! — served by Ansible 🤖
curl --max-time 5 http://<WEB_PUBLIC_IP>/   # → timeout (direct access is blocked)

# 5. Clean up
cd ../infra
terraform destroy
```

Running `ansible-playbook site.yml` a second time reports `changed=0`: the roles are idempotent.

## Fixes to the original lab instructions

The lab code did not work as written. These are the issues I found and fixed:

| # | Issue | Fix |
|---|-------|-----|
| 1 | `webserver` tasks were missing the `---` line and the first task's `- name:` line (invalid YAML) | Completed the task definition |
| 2 | Apache serves `index.html` before `index.php`, so the Ubuntu default page hid the PHP page | Added a task that removes the default `index.html` |
| 3 | The template used `{{ host }}`, which is the inventory name (`web1`) and can't be resolved by the load balancer | Used the web server's private IP from Ansible facts: `hostvars[host]['ansible_default_ipv4']['address']` |
| 4 | `state` and `update_cache` were indented outside the `apt` module | Fixed the indentation |
| 5 | `libapache2-mod-proxy-html` is not needed; the proxy modules ship with `apache2` | Removed the package |
| 6 | `changed_when` referenced `ansible_stdout`, which does not exist | Saved the output with `register` and checked `'Enabling module' in a2enmod_result.stdout` |

## Additional improvements

- **Fully qualified module names** (`ansible.builtin.apt` instead of `apt`), the current best practice
- **Explicit service state**: both roles ensure Apache is `started` and `enabled` instead of relying on Ubuntu's install-time behavior
- **Network restriction**: port 80 on the web server is only open to the load balancer's security group
- **Infrastructure as Code**: the servers are created and destroyed with Terraform instead of the console
- **No secrets in Git**: the real inventory with IPs and key paths is git-ignored; `hosts.example` documents its format
