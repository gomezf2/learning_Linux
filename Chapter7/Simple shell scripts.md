
---
# **Writing Simple Shell Scripts (Linux Bible Notes)**

## **1. What a Shell Script Is**

> [!info] A shell script is a text file containing commands executed in sequence.  
> Think of it as a reproducible command playlist.

### **Basic Structure**

```bash
#!/bin/bash
# This is a comment
echo "Hello world"
```

---

## **2. The Shebang Line (`#!`)**

> [!tip] The shebang tells Linux which interpreter should run the script.

Common examples:

- `#!/bin/bash`
- `#!/bin/sh`
- `#!/usr/bin/env bash` (portable)

### Example

```bash
#!/usr/bin/env bash
echo "Running with env-based Bash"
```

---

## **3. Making a Script Executable**

> [!warning] Creating a script is not enough — you must set execute permissions.

### Steps

```bash
nano myscript.sh
chmod +x myscript.sh
./myscript.sh
```

### Permission Breakdown

- `chmod +x file` → add execute permission
- `chmod 755 file` → owner write, everyone read/execute

---

## **4. Using Variables**

> [!note] No spaces around `=` when assigning variables.

### Assigning

```bash
name="Francis"
```

### Using

```bash
echo "Hello $name"
```

### Command substitution

```bash
today=$(date)
echo "Today is $today"
```

---

## **5. Positional Parameters (`$1`, `$2`, …)**

> [!tip] These allow your script to accept input arguments.

### Example Script

```bash
#!/bin/bash
echo "First argument: $1"
echo "Second argument: $2"
```

### Run

```bash
./myscript.sh apple banana
```

---

## **6. Exit Status (`$?`)**

> [!info] Every command returns a status.  
> `0` = success, non‑zero = error.

### Example

```bash
ls /not/a/path
echo "Exit code was: $?"
```

---

## **7. Conditional Logic**

> [!abstract] Conditions let your script make decisions.

### Basic Pattern

```bash
if [ condition ]; then
    commands
elif [ condition ]; then
    commands
else
    commands
fi
```

### Examples

Check if a file exists:

```bash
if [ -f "/etc/passwd" ]; then
    echo "File exists"
else
    echo "File missing"
fi
```

Check if a variable is empty:

```bash
if [ -z "$name" ]; then
    echo "Name is empty"
fi
```

---

## **8. Numeric & String Tests**

> [!note] Use `[` `]` with operators.

### Numeric Operators

- `-eq`
- `-ne`
- `-gt`
- `-lt`

```bash
if [ "$age" -gt 18 ]; then
    echo "Adult"
fi
```

### String Operators

- `=`
- `!=`
- `-z` (empty)
- `-n` (not empty)

---

## **9. Loops**

> [!tip] Loops automate repetition essential for sysadmin scripting.

### For Loop

```bash
for file in *.txt; do
    echo "Processing $file"
done
```

### While Loop

```bash
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    count=$((count + 1))
done
```

---

## **10. Reading User Input**

> [!example] `read` lets your script interact with the user.

### Example

```bash
read -p "Enter your name: " name
echo "Hello $name"
```

---

## **11. Functions**

> [!info] Functions help structure larger scripts.

### Example

```bash
greet() {
    echo "Hello $1"
}

greet "Francis"
```

---

## **12. Debugging Scripts**

> [!warning] Use debugging flags to trace execution.

### Run with debugging

```bash
bash -x myscript.sh
```

### Enable debugging inside script

```bash
set -x   # turn on debugging
set +x   # turn off debugging
```

---

## **13. Good Practices**

> [!success] These habits make your scripts reproducible and maintainable.

- Always include a shebang
- Use meaningful variable names
- Quote variables (`"$var"`)
- Use functions for clarity
- Comment _why_, not _what_
- Validate user input
- Consider `set -e` to stop on errors

---

## **14. Quick Reference — File Tests**

|Test|Meaning|
|---|---|
|`-f file`|File exists and is regular|
|`-d dir`|Directory exists|
|`-e path`|Path exists|
|`-r file`|Readable|
|`-w file`|Writable|
|`-x file`|Executable|

- - - 

# Bash Text Processing Commands

These tools are commonly used in Bash to **search, filter, transform, and extract text**, especially when working with files, logs, and command output.

---

## `grep`  Search Text

`grep` searches for **patterns** inside files or standard input and prints matching lines.

### Basic Syntax

```bash
grep [options] "pattern" file
```

### Common Examples

```bash
grep "error" logfile.txt
grep -i "warning" logfile.txt     # case-insensitive
grep -n "main" program.c          # show line numbers
grep -r "TODO" .                  # recursive search
```

### Useful Options

- `-i` → Ignore case
    
- `-n` → Show line numbers
    
- `-v` → Invert match (show non-matching lines)
    
- `-r` → Recursive search
    
- `-E` → Extended regex
    

> [!tip]  
> `grep` is often the **first filter** in a pipeline.

> [!example]
> 
> ```bash
> ps aux | grep python
> ```

> [!warning]  
> `grep` matches **lines**, not individual words unless you specify boundaries.

---

## `cut`  Extract Columns

`cut` extracts **specific fields or characters** from each line of input.

### Basic Syntax

```bash
cut [options] file
```

### Field-Based Extraction

```bash
cut -d "," -f 1 data.csv
cut -d ":" -f 1 /etc/passwd
```

### Character-Based Extraction

```bash
cut -c 1-5 file.txt
```

### Useful Options

- `-d` → Delimiter
    
- `-f` → Field number(s)
    
- `-c` → Character range
    

> [!tip]  
> Use `cut` when the file format is **simple and consistent**.

> [!warning]  
> `cut` cannot handle variable spacing well — use `awk` instead.

---

## `tr` Translate or Delete Characters

`tr` replaces or removes **individual characters** from input.

### Basic Syntax

```bash
command | tr SET1 SET2
```

### Common Examples

```bash
tr 'a-z' 'A-Z'        # lowercase → uppercase
tr -d '\n'            # delete newlines
tr -s ' '             # squeeze repeated spaces
```

### Useful Options

- `-d` → Delete characters
    
- `-s` → Squeeze repeats
    

> [!note]  
> `tr` works on **characters only**, not strings.

> [!example]
> 
> ```bash
> echo "hello world" | tr ' ' '_'
> ```

---

## `awk` Pattern Scanning & Processing

`awk` is a **powerful text processing language** built into Unix.

### Basic Syntax

```bash
awk 'pattern { action }' file
```

### Print Columns

```bash
awk '{print $1}' file.txt
awk '{print $1, $3}' file.txt
```

### Using Delimiters

```bash
awk -F "," '{print $2}' data.csv
```

### Conditional Logic

```bash
awk '$3 > 50 {print $1}' scores.txt
```

### Built-In Variables

- `$0` → Entire line
    
- `$1, $2, ...` → Fields
    
- `NF` → Number of fields
    
- `NR` → Record (line) number
    

> [!tip]  
> Use `awk` when you need **logic, math, or complex formatting**.

> [!example]
> 
> ```bash
> df -h | awk '{print $1, $5}'
> ```

> [!important]  
> `awk` replaces many uses of `cut`, `grep`, and simple scripts.

---

## `sed`  Stream Editor

`sed` edits text **line-by-line** without opening an editor.

### Basic Syntax

```bash
sed 'command' file
```

### Substitution

```bash
sed 's/old/new/' file.txt
sed 's/error/warning/g' file.txt
```

### In-Place Editing

```bash
sed -i 's/foo/bar/g' file.txt
```

### Delete Lines

```bash
sed '5d' file.txt         # delete line 5
sed '/error/d' file.txt   # delete matching lines
```

> [!warning]  
> `sed -i` modifies files **permanently** — use with care.

> [!tip]  
> `sed` is ideal for **automated edits** in scripts.

---

## Typical Bash Pipelines

These tools shine when **combined**.

```bash
cat logfile.txt | grep "ERROR" | awk '{print $2}' | sort | uniq
```

> [!example]  
> Extract usernames from `/etc/passwd`
> 
> ```bash
> cut -d ":" -f 1 /etc/passwd
> ```

> [!important]  
> Learn to **chain commands** using pipes (`|`) — this is core Bash skill.

---

## When to Use What

|Task|Best Tool|
|---|---|
|Search lines|`grep`|
|Extract fixed columns|`cut`|
|Replace characters|`tr`|
|Logic + formatting|`awk`|
|Edit text streams|`sed`|

> [!summary]  
> Mastering these commands turns Bash into a **powerful data-processing environment**.

---
Below are **two clear, practical Bash example scripts** you can store in your Obsidian vault.  
They are written to **demonstrate real usage** of `grep`, `cut`, `tr`, `awk`, and `sed` in context.

---

# Example Bash Scripts

## Simple Backup Script (with logging & filtering)

**Purpose:**

- Back up a directory
    
- Keep a timestamped archive
    
- Log results
    
- Demonstrates `grep`, `awk`, `sed`, `tr`
    

---

### Script: `backup.sh`

```bash
#!/bin/bash

# ===== Configuration =====
SOURCE_DIR="$HOME/documents"
BACKUP_DIR="$HOME/backups"
LOG_FILE="$BACKUP_DIR/backup.log"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Timestamp (safe for filenames)
TIMESTAMP=$(date | tr ' :' '_')

BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# ===== Perform Backup =====
tar -czf "$BACKUP_FILE" "$SOURCE_DIR" 2>> "$LOG_FILE"

# ===== Log Result =====
if [ $? -eq 0 ]; then
    echo "$(date): Backup successful -> $BACKUP_FILE" >> "$LOG_FILE"
else
    echo "$(date): Backup FAILED" >> "$LOG_FILE"
fi

# ===== Show Recent Backups =====
echo "Recent backups:"
ls -lh "$BACKUP_DIR" | grep "backup_" | awk '{print $9, $5}'
```

---

### What This Script Teaches

> [!tip]  
> `tr` is used to **sanitize timestamps** for filenames.

> [!example]
> 
> ```bash
> TIMESTAMP=$(date | tr ' :' '_')
> ```

> [!important]  
> `awk` extracts **filename and size** cleanly from `ls`.

> [!note]  
> This is a realistic pattern used in **cron jobs** and production systems.

---

##  Log Monitoring & Cleanup Script

**Purpose:**

- Scan logs for errors
    
- Extract useful fields
    
- Auto-clean noisy messages
    
- Demonstrates `grep`, `cut`, `awk`, `sed`
    

---

### Script: `log_monitor.sh`

```bash
#!/bin/bash

LOG_FILE="/var/log/syslog"
OUTPUT_FILE="$HOME/error_report.txt"

# ===== Extract Errors =====
grep -i "error" "$LOG_FILE" > temp_errors.txt

# ===== Clean Log Messages =====
sed -i 's/\[.*\]//g' temp_errors.txt

# ===== Extract Timestamp + Message =====
awk '{print $1, $2, $3, $NF}' temp_errors.txt > "$OUTPUT_FILE"

# ===== Summary =====
ERROR_COUNT=$(grep -c "error" "$LOG_FILE")

echo "Total errors found: $ERROR_COUNT"
echo "Report saved to $OUTPUT_FILE"

# Cleanup
rm temp_errors.txt
```

---

### What This Script Teaches

> [!tip]  
> `sed` is great for **removing unwanted patterns** like timestamps or tags.

> [!example]
> 
> ```bash
> sed 's/\[.*\]//g'
> ```

> [!important]  
> `awk` lets you **reformat logs** without touching the original file.

> [!warning]  
> Never run log scripts as root unless required — logs can be large.

---



---
