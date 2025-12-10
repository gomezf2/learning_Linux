
## Here Documents (Heredocs) — DevOps Notes

## Overview

A **here document** (heredoc) lets you pass a block of text to a command **as if it came from a file**, without creating an actual file on disk.

General form:

```
command <<EOF
...text...
EOF
```

Everything between the markers is sent to the command’s STDIN.

This is heavily used in DevOps for:

- provisioning servers
- generating config files
- templating YAML/JSON
- feeding multi‑line input to tools
- writing systemd units
- automating database setup

---

# Why Heredocs Matter in DevOps

Heredocs allow you to:

- embed configuration directly inside scripts
- avoid scattering temporary files
- keep automation reproducible and self‑contained
- generate multi‑line files deterministically
- pass structured input to commands (SQL, YAML, JSON, cloud-init, etc.)

They are one of the most important Bash features for infrastructure automation.

---

# Basic Syntax

```
command <<EOF
line 1
line 2
line 3
EOF
```

- `EOF` is just a delimiter; you can name it anything.
- The ending delimiter **must** appear alone on a line.

---

# Variable Expansion

## Expansion enabled (default)

```
name="Francis"

cat <<EOF
Hello $name
EOF
```

Output:

```
Hello Francis
```

Useful when generating config files that include dynamic values.

---

## Expansion disabled (quote the delimiter)

```
cat <<'EOF'
Hello $name
EOF
```

Output:

```
Hello $name
```

Useful when writing:

- scripts
- YAML with `$`
- Terraform templates
- literal shell code

---

# Indented Heredocs (`<<-EOF`)

Allows indentation inside your script while removing leading tabs.

```
cat <<-EOF
    This text will not include leading tabs
EOF
```

Keeps scripts visually clean.

---

# DevOps‑Focused Examples

## 1. Creating a config file

```
cat <<EOF > /etc/myapp/config.yaml
port: 8080
log_level: info
enable_metrics: true
EOF
```

Use case:

- provisioning servers
- generating reproducible configs

---

## 2. Appending to a log file

```
cat <<EOF >> ~/deploy.log
Deployment finished at $(date)
EOF
```

Use case:

- audit trails
- script run history

---

## 3. Feeding SQL into a database

```
mysql -u root <<EOF
CREATE DATABASE devops;
GRANT ALL PRIVILEGES ON devops.* TO 'francis'@'localhost';
EOF
```

Use case:

- database provisioning
- CI/CD test environment setup

---

## 4. Creating a systemd service file

```
sudo tee /etc/systemd/system/myapp.service <<EOF
[Unit]
Description=My App Service

[Service]
ExecStart=/usr/local/bin/myapp

[Install]
WantedBy=multi-user.target
EOF
```

Use case:

- automating service creation
- reproducible server setup

---

## 5. Running commands on a remote server via SSH

```
ssh ubuntu@server <<EOF
sudo apt update
sudo apt install -y nginx
sudo systemctl enable nginx
EOF
```

Use case:

- bootstrapping servers
- remote provisioning

---

## 6. Generating Kubernetes manifests on the fly

```
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:latest
EOF
```

Use case:

- templating manifests
- dynamic config generation in CI

---

# When You’ll Use Heredocs Most

- Writing config files during provisioning
- Creating systemd units
- Generating YAML/JSON templates
- Passing SQL to databases
- Bootstrapping servers via SSH
- Embedding multi‑line scripts inside automation
- Cloud-init user-data
- CI/CD pipelines that generate files dynamically

They’re everywhere in real DevOps work.
