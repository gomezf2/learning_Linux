

## File Redirection Metacharacters (DevOps Notes)

## Overview

In Linux, commands produce **streams**:

- **STDOUT** → normal output
- **STDERR** → error output
- **STDIN** → input to a command

Redirection metacharacters let you **route these streams** into files, commands, or other tools.  
Think of them as **data plumbing** — essential for automation, CI/CD, logging, and reproducible workflows.

---

## Core Redirection Operators

### `>` — Redirect STDOUT (overwrite)

Writes output to a file, replacing its contents.

```
terraform plan > plan.txt
```

Useful for:

- Storing deterministic output
- CI artifacts
- Clean logs

---

### `>>` — Redirect STDOUT (append)

Adds output to the end of a file.

```
echo "Backup completed at $(date)" >> backup.log
```

Useful for:

- Persistent logs
- Audit trails
- Script run history

---

### `2>` — Redirect STDERR (overwrite)

Captures only error output.

```
kubectl apply -f manifests/ 2> errors.log
```

Useful for:

- Debugging
- Separating clean output from failures

---

### `2>>` — Redirect STDERR (append)

Appends errors to a log.

```
ansible-playbook site.yml 2>> ansible-errors.log
```

Useful for:

- Long‑running automation
- Error accumulation

---

### `&>` — Redirect STDOUT and STDERR (overwrite)

Sends everything to one file.

```
./run_migrations.sh &> migrations.log
```

Useful for:

- CI/CD steps
- Unified logs

---

### `&>>` — Redirect STDOUT and STDERR (append)

Appends both streams.

```
helm upgrade myapp ./chart &>> helm.log
```

Useful for:

- Persistent combined logs

---

### `<` — Redirect STDIN

Feeds a file _into_ a command.

```
mysql < schema.sql
```

Useful for:

- Provisioning
- Database seeding
- Loading configs

---

## Pipelines (`|`)

Pipes send STDOUT of one command into STDIN of another.

```
journalctl -u nginx | grep error > nginx-errors.log
```

Useful for:

- Filtering logs
- Extracting structured data
- Building reproducible pipelines

---

# Understanding the Example Commands

## 1. `mail root < ~/.bashrc`

### What it does

- Sends the contents of `~/.bashrc` as the **email body** to the `root` user.
- `<` feeds the file into the `mail` command as STDIN.

### Why it matters in DevOps

- Automating notifications
- Sending logs/configs to admins
- Feeding files into tools that expect input

---

## 2. `man chmod | col -b > /tmp/chmod`

### What it does

- Gets the `chmod` man page
- Cleans formatting with `col -b`
- Saves plain text to `/tmp/chmod`

### Why it matters in DevOps

- Creating clean documentation
- Preparing text for parsing
- Storing reference material for training or automation

---

## 3. `echo "I finished the project on $(date)" >> ~/projects`

### What it does

- Appends a timestamped message to the file `~/projects`.

### Why it matters in DevOps

- Logging
- Audit trails
- Tracking script runs
- Recording events with timestamps

---

# Quick Reference Table

|Operator|Meaning|Typical DevOps Use|
|---|---|---|
|`>`|Redirect STDOUT (overwrite)|Save clean output, CI artifacts|
|`>>`|Redirect STDOUT (append)|Logs, audit trails|
|`2>`|Redirect STDERR (overwrite)|Capture errors|
|`2>>`|Redirect STDERR (append)|Persistent error logs|
|`&>`|Redirect both streams|Unified logs|
|`&>>`|Append both streams|Long‑running automation logs|
|`<`|Redirect STDIN|Provisioning, feeding configs|
|`|`|Pipeline|Filtering, transforming, chaining commands|

---
