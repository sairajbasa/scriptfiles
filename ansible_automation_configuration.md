# Ansible Automation – Common Mistakes & Correct Configuration

(Formatted for easy understanding – Markdown)

---

## 1) Mistake: Confusing root on Master with root on Clients

### ❌ Wrong assumption
- Being `root` on AnsibleMaster means commands will run as root on clients.

### ✅ Correct understanding
- Root on AnsibleMaster ≠ root on AnsibleClients
- Ansible always follows the **remote user** (`ansible_user`)
- Privilege escalation requires **sudo / become**

---

## 2) Mistake: Not understanding where the SSH public key is stored

### ❌ What happened
- Ran `ls`
- Did not see any key files
- Assumed key copy failed

### ✅ Reality
- `.ssh` is a **hidden directory**

### ✔ Correct verification
```bash
ls -la ~/.ssh
cat ~/.ssh/authorized_keys
```

### 🔑 Golden rule
- If SSH login does **NOT** ask for a password, the public key copy is successful.

---

## 3) Mistake: SSH works but Ansible shows “Missing sudo password”

### ❌ Symptoms
- SSH key login works
- Ansible `yum install` fails

### ✅ Root cause
- `sudo` requires a password
- Ansible cannot provide interactive passwords

---

## 4) Mistake: Wrong sudoers entry for automation

### ❌ Existing (wrong for automation)
```ini
sairaj ALL=(ALL) ALL
```
- Allows sudo
- Still asks for password

### ✅ Correct (Ansible-ready)
```ini
sairaj ALL=(ALL) NOPASSWD: ALL
```
- Passwordless sudo
- Required for Ansible / CI-CD

---

## 5) Mistake: Expecting `become=true` to work without sudo config

### ❌ Wrong assumption
- Adding `become=true` alone is enough

### ✅ Reality
- `become=true` only requests sudo
- Sudoers must allow passwordless execution

---

## 6) Correct Inventory (Best Practice)

```ini
[dev]
10.0.0.102

[prod]
10.0.0.160

[all:vars]
ansible_user=sairaj
become=true
become_method=sudo
```

### ✔ Why this is correct
- Uses a normal user (secure)
- Automatic privilege escalation
- Works across all hosts

---

## 7) Final Verification Checklist

### 🔐 SSH check
```bash
ssh sairaj@client_ip
```
- No password → OK

### 🔐 Sudo check
```bash
sudo whoami
```
- Output: `root` → OK

### 🚀 Ansible check
```bash
ansible all -a "whoami"
```
- Output: `root` → OK

### 📦 Package install
```bash
ansible all -a "yum install -y git"
```
- SUCCESS → Automation ready

---

## 8) Why these mistakes are normal

- Cloud images override SSH defaults
- SSH and sudo are separate systems
- Ansible depends on both
- Beginners usually fix SSH but forget sudo

---

## 9) Interview-ready one-liner

> I configured SSH key-based authentication for Ansible connectivity and enabled passwordless sudo for privilege escalation using become, which is the standard production approach.

---

## 10) Optional Production Hardening

```ini
sairaj ALL=(ALL) NOPASSWD: /usr/bin/yum, /usr/bin/systemctl
```
- Limits root access
- Used in real production environments

---

## ✅ Final Status

- SSH keys configured correctly
- Hidden files understood
- Inventory structured
- Passwordless sudo enabled
- Ansible production-ready
