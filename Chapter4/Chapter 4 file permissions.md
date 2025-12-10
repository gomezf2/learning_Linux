
## **Linux File Permissions — DevOps Cheat Sheet**

> A practical, DevOps‑oriented reference for understanding and applying Linux file permissions in real workflows.

---
##  **1. The Permission Model (Owner / Group / Others)**

Every file and directory has three permission sets:

```
r = read
w = write
x = execute (or “enter” for directories)
```

Example:

```
-rwxr-x---
```

Breakdown:

- **Owner:** rwx
- **Group:** r-x
- **Others:** ---

> [!info] DevOps Insight  
> Permissions are not just syntax — they define _who can break your automation_, _who can run your scripts_, and _who can modify infrastructure files_. Treat them as part of your security model.

---

##  **2. Numeric `chmod` (The DevOps Standard)**

You’ll use numeric modes constantly in scripts because they’re predictable and reproducible.

|Number|Meaning|
|---|---|
|7|rwx|
|6|rw-|
|5|r-x|
|4|r--|

Examples:

```
chmod 755 script.sh
chmod 640 secrets.env
chmod 700 ~/.ssh
```

> [!tip] Why numeric modes matter  
> They’re deterministic, script‑friendly, and avoid ambiguity — perfect for CI/CD, provisioning, and reproducible lab setups.

---

##  **3. Directory Permissions Work Differently**

For **directories**:

- **r** = list files
- **w** = create/delete files
- **x** = _enter_ the directory

Example:

```
drwx------ secure/
```

Only the owner can enter or view it.

> [!warning] Common mistake  
> A directory with `r--` but no `x` is _visible but inaccessible_.  
> A directory with `--x` but no `r` is _enterable but not listable_.

---

## **4. `umask` — Default Permission Control**

`umask` subtracts permissions when new files/directories are created.

Typical default:

```
umask 022
```

Meaning:

- remove write for group
- remove write for others

Results:

- new files → `rw-r--r--`
- new dirs → `rwxr-xr-x`

> [!example] DevOps Use Case  
> Adjust `umask` when creating shared directories for teams or services that need group write access.

---

## **5. Ownership: `chown` and `chgrp`**

```
chown user:group file
chgrp group file
```

> [!info] Why this matters in DevOps  
> Most permission issues in CI/CD, Docker volumes, and shared environments are _ownership_ problems, not `chmod` problems.

Examples:

```
sudo chown -R devops:devops /opt/project
sudo chown -R www-data:www-data /var/www
```

---

##  **6. Special Bits (setuid, setgid, sticky)**

### **setuid (s)**

File runs with the **owner’s** permissions.

Example:

```
-rwsr-xr-x root root /usr/bin/passwd
```

### **setgid (s)**

File runs with the **group’s** permissions.  
On directories: new files inherit the directory’s group.

```
chmod g+s shared_dir/
```

### **sticky bit (t)**

Only the file owner can delete files in the directory.

```
drwxrwxrwt /tmp
```

> [!warning] DevOps Caution  
> setuid/setgid can be dangerous.  
> Sticky bit is your friend for shared directories.

---

##  **7. ACLs (Access Control Lists)**

ACLs allow fine‑grained permissions beyond owner/group/others.

```
setfacl -m u:francis:rwx file
getfacl file
```

> [!info] When to use ACLs
> 
> - Multi‑team environments
> - Shared infrastructure
> - When group membership alone isn’t enough

---

##  **8. Practical DevOps Examples**

### **Make a script executable (but not writable by others)**

```
chmod 755 deploy.sh
```

### **Secure secrets**

```
chmod 600 secrets.env
```

### **Shared project directory**

```
mkdir /opt/project
chown root:devops /opt/project
chmod 770 /opt/project
```

### **Ensure group inheritance**

```
chmod g+s /opt/project
```

---

##  **9. DevOps‑Style Setup Script (Full Picture)**

A reproducible setup script using everything above.

```
#!/bin/bash

BASE="/opt/project"

# Create directory structure
mkdir -p $BASE/{config,logs,data}

# Set ownership to devops team
chown -R root:devops $BASE

# Allow group full access, deny others
chmod -R 770 $BASE

# Ensure new files inherit the group
chmod g+s $BASE

# Protect logs from accidental deletion
chmod +t $BASE/logs

# Secure secrets
touch $BASE/config/secrets.env
chmod 600 $BASE/config/secrets.env
```

> [!success] What This Script Demonstrates
> 
> - Correct ownership
> - Predictable permissions
> - Group inheritance
> - Sticky bit for safety
> - Secure handling of secrets
> - Reproducible, DevOps‑grade setup


#### File permission options

you can add permissions recursively with the -R option, this can make a directory and all its files bellow have the permissions that you have set. 

``chmod 755 -R $HOME/myapps``

everything under my apps inherits the permission 755. 

- - - 

using octal values for permissions is not always the best course of action, its very good for scripting and doing it fast but its not as human readable and editing permissions is easier with symbolic permissions style like ``chmod g-w file`` can take away write access for a group but leave everything the same. 

- - -

#### Symbolic permission options


## 🛡️ File Ownership vs Permissions

> **💡 Note:**  
> Ownership determines _who_ can change permissions. Permissions determine _what_ users can do.  
> You can’t change permissions on a file you don’t own—unless you're root.

---

## 🔧 `chmod` — Changing Permissions

### 🧠 Symbolic Mode (Letters)

Symbolic mode uses letters to modify permissions incrementally and descriptively.

> **📘 Example:**  
> `chmod a-w file`  
> 🔹 Removes write permission from **all** (user, group, others)  
> 🔹 Resulting permission: `r-xr-xr-x`

> **📘 Example:**  
> `chmod o-x file`  
> 🔹 Removes execute permission from **others**  
> 🔹 Resulting permission: `rwxrwxrw-`

> **📘 Example:**  
> `chmod go-rwx file`  
> 🔹 Removes all permissions from **group** and **others**  
> 🔹 Resulting permission: `rwx-------`

---

### ➕ Adding Permissions with `+`

> **📘 Example:**  
> `chmod u+rw files`  
> 🔹 Adds read and write for **user**  
> 🔹 Resulting permission: `rw-------`

> **📘 Example:**  
> `chmod a+x files`  
> 🔹 Adds execute for **all**  
> 🔹 Resulting permission: `--x--x--x`

> **📘 Example:**  
> `chmod ug+rx files`  
> 🔹 Adds read and execute for **user** and **group**  
> 🔹 Resulting permission: `r-xr-x---`

---

## 🧮 Numeric Mode (Octal)

Numeric mode sets all permissions at once using a three-digit code:

- First digit: user
- Second digit: group
- Third digit: others

> **💡 Tip:**  
> Use numeric mode when you want to set a known, complete permission state (e.g., `chmod 755 file`).

---

## 🧠 Why Use Letters Instead of Numbers?

> **📌 Callout:**  
> Symbolic mode is safer for incremental changes.  
> You don’t risk overwriting existing permissions unintentionally.

---

#### Umask application examples

# 🚀 DevOps Perspective on `umask`

## 🔒 Security by Default

> [!note]  
> `umask` enforces **least privilege** automatically. It ensures new files and directories don’t expose sensitive data.  
> Example: Logs created with `umask 027` → `rw-r-----` (only owner can write, group can read, others blocked).

---

## ⚙️ Consistency Across Environments

> [!tip]  
> A consistent `umask` across dev, CI/CD, and production ensures predictable defaults.  
> Prevents “works on my machine” issues where files are writable locally but locked down in production.

---

## 👥 Collaboration Control

> [!example]  
> In shared environments, `umask` defines group access.  
> For build artifact directories, `umask 002` allows group members to read/write while blocking others.

---

## 🤖 Automation & CI/CD Pipelines

> [!important]  
> Jenkins, Docker, and GitLab runners create many files.  
> `umask` ensures they don’t need manual `chmod` fixes later, reducing human error in automated deployments.

---

## 📜 Compliance & Auditing

> [!warning]  
> Organizations with strict policies (PCI-DSS, HIPAA) require tight file access controls.  
> Setting `umask` system-wide enforces compliance without relying on developers to remember `chmod`.

---

## 🧭 Practical Use Cases

- Jenkins workspace directories → `umask 027`
- Log files → `umask 077`
- Shared deployment artifacts → `umask 002`
- Docker containers → set `umask` in entrypoint scripts

---

## ⚖️ Summary

> [!quote]  
> From a DevOps perspective, the point of `umask` is to enforce **least privilege**, guarantee **predictable defaults**, reduce **manual fixes**, and support **security compliance**.


