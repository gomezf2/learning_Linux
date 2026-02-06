

## Overview

Pipes (`|`) and redirection (`>`, `>>`, `<`, `2>`) are fundamental for building powerful command-line workflows. They let you chain commands together and control where input comes from and output goes to.

---

## File Redirection

### Output Redirection

```bash
# Redirect stdout to file (overwrites)
command > file.txt

# Append stdout to file
command >> file.txt

# Redirect stderr to file
command 2> error.log

# Redirect both stdout and stderr
command > output.txt 2>&1
command &> output.txt  # Shorthand (bash)

# Discard output
command > /dev/null
command 2> /dev/null  # Discard errors
command &> /dev/null  # Discard everything
```

**Examples:**

```bash
# Save file listing
ls -la > directory_contents.txt

# Append date to log
date >> activity.log

# Save errors separately
find / -name "docker" > found.txt 2> errors.txt

# Completely silent execution
apt update &> /dev/null
```

### Input Redirection

```bash
# Read input from file
command < input.txt

# Here document (multi-line input)
command << EOF
line 1
line 2
EOF

# Here string (single line)
command <<< "some text"
```

**Examples:**

```bash
# Send file contents as input
mysql < database_dump.sql

# Create file with content
cat << EOF > config.yml
database: localhost
port: 3306
EOF

# Pass string to command
grep "error" <<< "error message here"
```

---

## Pipes

### Basic Piping

The pipe (`|`) sends stdout from one command as stdin to another.

```bash
# Basic syntax
command1 | command2 | command3
```

**Common patterns:**

```bash
# Find and count
ls | wc -l

# Search and filter
ps aux | grep docker

# Sort and show top results
du -sh * | sort -h | tail -5

# Chain multiple filters
cat file.txt | grep "error" | sort | uniq
```

### Practical Pipe Combinations

**File searching and processing:**

```bash
# Find files, then search content
find . -name "*.log" | xargs grep "ERROR"

# Locate files and check their type
locate docker | xargs file

# Find and count occurrences
find /var/log -name "*.log" | wc -l

# Search, extract, and sort
grep "user" /etc/passwd | cut -d: -f1 | sort
```

**System monitoring:**

```bash
# Top memory users
ps aux | sort -nrk 4 | head -5

# Top CPU users
ps aux | sort -nrk 3 | head -5

# Disk usage sorted
df -h | grep -v "tmpfs" | sort -k5 -rn

# Process tree filtered
ps auxf | grep -v grep | grep docker
```

**Text processing:**

```bash
# Count unique lines
cat file.txt | sort | uniq -c

# Find duplicates
cat file.txt | sort | uniq -d

# Remove duplicates
cat file.txt | sort | uniq > clean.txt

# Column extraction
cat data.csv | cut -d',' -f2 | sort | uniq
```

**Network analysis:**

```bash
# Show listening ports
netstat -tuln | grep LISTEN

# Count connections by IP
netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n

# Check specific port
ss -tuln | grep :80
```

---

## Advanced Patterns

### Combining Pipes and Redirection

```bash
# Pipe and redirect output
command1 | command2 > output.txt

# Pipe and redirect errors
command1 2>&1 | command2

# Save intermediate results
command1 | tee intermediate.txt | command2 > final.txt

# Multiple outputs
command 2>&1 | tee full.log | grep ERROR > errors.log
```

### Using xargs

`xargs` builds commands from stdin - super powerful with pipes.

```bash
# Basic xargs
find . -name "*.tmp" | xargs rm

# Safe with spaces/special chars
find . -name "*.tmp" -print0 | xargs -0 rm

# Run command per line
cat urls.txt | xargs -I {} curl {}

# Parallel execution
find . -name "*.jpg" | xargs -P 4 -I {} convert {} {}.png

# With placeholder
locate docker | xargs -I {} ls -lh {}
```

### The tee Command

`tee` reads stdin and writes to both stdout AND files.

```bash
# Save and display
command | tee output.txt

# Append mode
command | tee -a output.txt

# Multiple files
command | tee file1.txt file2.txt file3.txt

# In the middle of a pipe chain
command1 | tee intermediate.log | command2 | tee final.log
```

**Practical use:**

```bash
# Watch and log
docker logs -f container | tee docker.log

# Build and save output
make 2>&1 | tee build.log

# Test and record
pytest | tee test-results.txt
```

---

## Real-World Command Building

### Finding and Processing Files

```bash
# Find Docker configs and view them
find /etc -name "*docker*" 2>/dev/null | xargs cat

# Find large files and sort
find / -type f -size +100M 2>/dev/null | xargs du -h | sort -h

# Find recent logs and search them
find /var/log -mtime -1 -name "*.log" | xargs grep -i error > recent_errors.txt

# Count lines in all Python files
find . -name "*.py" | xargs wc -l | tail -1
```

### Log Analysis

```bash
# Extract and count error types
grep ERROR app.log | cut -d' ' -f4 | sort | uniq -c | sort -rn

# Find IPs with failed logins
grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -rn

# Save filtered logs
cat /var/log/syslog | grep -E "(error|warn)" > filtered.log 2>&1
```

### System Administration

```bash
# Backup with compression
tar czf - /home/user | ssh remote "cat > backup.tar.gz"

# Find and kill processes
ps aux | grep python | awk '{print $2}' | xargs kill

# Disk usage report
du -sh * 2>/dev/null | sort -h | tee disk-report.txt

# Update locate database and search
sudo updatedb && locate docker | tee docker-files.txt
```

### Data Processing

```bash
# CSV column statistics
cat data.csv | cut -d',' -f3 | sort -n | uniq -c

# Extract emails from files
grep -Eoh "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b" *.txt | sort | uniq > emails.txt

# Count word frequency
cat book.txt | tr ' ' '\n' | sort | uniq -c | sort -rn | head -20
```

---

## Common Gotchas

### Error Handling

```bash
# stderr not piped by default
command1 2>&1 | command2  # Include stderr in pipe

# Some commands buffer output
command | cat  # Force flush
command | stdbuf -oL grep pattern  # Line buffering
```

### File Descriptor Numbers

- `0` = stdin
- `1` = stdout
- `2` = stderr

```bash
# Redirect stderr to stdout
command 2>&1

# Redirect stdout to stderr
command 1>&2

# Swap stdout and stderr
command 3>&1 1>&2 2>&3
```

### Order Matters

```bash
# WRONG - redirects before piping
command | grep pattern > file.txt 2>&1

# RIGHT - stderr merged, then piped, then written
command 2>&1 | grep pattern > file.txt
```

---

## Quick Reference

|Operator|Meaning|
|---|---|
|`>`|Redirect stdout (overwrite)|
|`>>`|Redirect stdout (append)|
|`<`|Redirect stdin|
|`2>`|Redirect stderr|
|`2>&1`|Redirect stderr to stdout|
|`&>`|Redirect both stdout and stderr|
|`|`|
|`|&`|
|`<<`|Here document|
|`<<<`|Here string|

---

## Practice Exercises

Try building these commands:

1. Find all `.conf` files, search for "port", and save to a file
2. List processes, sort by memory, show top 10, save to file
3. Find files modified today, count them, append to log
4. Download a file, extract text, count words, save result
5. Monitor logs in real-time while saving to file

**Solutions:**

```bash
# 1
find / -name "*.conf" 2>/dev/null | xargs grep -l "port" > port-configs.txt

# 2
ps aux | sort -nrk 4 | head -10 > top-memory.txt

# 3
find . -mtime 0 | wc -l >> daily-files.log

# 4
curl -s https://example.com | grep -o '\w\+' | wc -w > wordcount.txt

# 5
tail -f /var/log/app.log | tee app-monitor.log
```

---

## Tags

#linux #bash #cli #pipes #redirection #commands #shell