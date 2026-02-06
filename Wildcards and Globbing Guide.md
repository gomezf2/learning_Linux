

## Overview

Wildcards (also called **globbing** or **pathname expansion**) are special characters that let you match multiple files or paths using patterns. The shell expands these patterns _before_ running the command.

> **Related:** [[pipes-and-redirection-guide]] - Combine wildcards with pipes for powerful workflows

---

## Basic Wildcards

### The Asterisk `*`

Matches **any number of characters** (including zero).

```bash
# All files in current directory
ls *

# All .txt files
ls *.txt

# All files starting with "test"
ls test*

# All files ending with "backup"
ls *backup

# Files containing "docker" anywhere
ls *docker*

# All .conf files in subdirectories
ls */*.conf

# Multiple levels deep
ls */*/*.log
```

**Common uses:**

```bash
# Copy all images
cp *.jpg /backup/

# Delete all temporary files
rm temp_*

# Count Python files
ls *.py | wc -l

# Move all 2024 logs
mv *2024*.log archive/
```

### The Question Mark `?`

Matches **exactly one character**.

```bash
# file1, file2, fileA, etc. (not file10)
ls file?

# Three-character extensions
ls *.???

# Date patterns: 01-31
ls file-??.txt

# Two-digit years
ls report_20??.pdf

# Exact length matching
ls ????.*  # Four-character filenames
```

**Practical examples:**

```bash
# Day-specific logs (01-31)
ls app-2024-01-??.log

# Single letter directories
cd /mnt/?

# License plate patterns
grep "ABC-???" database.txt
```

### Square Brackets `[]`

Matches **any one character** from the set inside.

```bash
# Match file1, file2, file3
ls file[123]

# Match fileA, fileB, fileC
ls file[ABC]

# Ranges: 0-9
ls file[0-9]

# Ranges: a-z
ls file[a-z]

# Multiple ranges
ls [A-Za-z]*

# Specific characters
ls *[aeiou]*  # Contains vowels
```

**Character ranges:**

```bash
# Numbers only
ls data[0-9][0-9][0-9].txt

# Lowercase letters
ls [a-z]*.sh

# Uppercase letters
ls [A-Z]*.txt

# Alphanumeric
ls [A-Za-z0-9]*

# Combined patterns
ls file[1-5][a-c].dat
```

### Negation `[!]` or `[^]`

Matches **any character NOT in the set**.

```bash
# Not .txt files
ls *[!t][!x][!t]

# Files NOT starting with digits
ls [!0-9]*

# Not vowels
ls *[!aeiou]*

# Not lowercase
ls [!a-z]*

# Exclude specific characters
ls file[!123].txt
```

**Practical uses:**

```bash
# All non-hidden files (not starting with .)
ls [!.]*

# Exclude backup files
ls [!*~]

# Not log files
ls *[!.log]
```

---

## Brace Expansion `{}`

Generates **multiple strings** from patterns. Very powerful for creating or operating on multiple items.

### Basic Brace Expansion

```bash
# Create multiple files
touch file{1,2,3}.txt
# Expands to: file1.txt file2.txt file3.txt

# Multiple extensions
ls script.{sh,py,rb}

# Prefixes and suffixes
echo {test,prod,dev}_config

# Multiple words
echo {hello,goodbye,hi}_world
```

### Ranges

```bash
# Numeric ranges
echo {1..10}
# Output: 1 2 3 4 5 6 7 8 9 10

# Letter ranges
echo {a..z}
echo {A..Z}

# Reverse ranges
echo {10..1}
echo {z..a}

# Step intervals (bash 4+)
echo {0..100..10}  # 0 10 20 30 ... 100
echo {a..z..2}     # a c e g ...
```

### Nested Braces

```bash
# Create directory structure
mkdir -p project/{src,bin,test}/{main,utils}

# Multiple file types in multiple dirs
ls {docs,src}/*.{md,txt}

# Complex combinations
touch {2023,2024}/{01..12}/{report,summary}.csv
```

### Practical Applications

```bash
# Backup files
cp important.txt{,.backup}
# Expands to: cp important.txt important.txt.backup

# Quick rename pattern
mv config.{old,new}
# Expands to: mv config.old config.new

# Create dated directories
mkdir backup_{2024..2026}

# Multiple operations
touch {test,dev,prod}_{config,data,logs}.{yml,json}

# Year-month directories
mkdir -p logs/20{23..24}/{01..12}

# Padding with leading zeros
touch file{001..100}.txt
```

---

## POSIX Character Classes

More portable and locale-aware than `[a-z]` style ranges.

### Common Classes

```bash
# Alphanumeric characters
ls *[[:alnum:]]*

# Alphabetic characters only
ls *[[:alpha:]]*

# Digits only
ls *[[:digit:]]*

# Lowercase letters
ls *[[:lower:]]*

# Uppercase letters
ls *[[:upper:]]*

# Whitespace
grep [[:space:]] file.txt

# Punctuation
ls *[[:punct:]]*

# Printable characters
grep [[:print:]] file.txt

# Hexadecimal digits
ls *[[:xdigit:]]*
```

### Full List

|Class|Matches|
|---|---|
|`[:alnum:]`|Alphanumeric: `[A-Za-z0-9]`|
|`[:alpha:]`|Alphabetic: `[A-Za-z]`|
|`[:digit:]`|Digits: `[0-9]`|
|`[:lower:]`|Lowercase: `[a-z]`|
|`[:upper:]`|Uppercase: `[A-Z]`|
|`[:space:]`|Whitespace (space, tab, newline)|
|`[:blank:]`|Space and tab only|
|`[:punct:]`|Punctuation characters|
|`[:print:]`|Printable characters|
|`[:graph:]`|Visible characters (no whitespace)|
|`[:cntrl:]`|Control characters|
|`[:xdigit:]`|Hexadecimal: `[0-9A-Fa-f]`|

**Usage:**

```bash
# Find files with only digits in name
ls *[[:digit:]]*

# Case-insensitive matching
ls [[:upper:]]*[[:lower:]]*

# Clean filenames (remove special chars)
rename 's/[^[:alnum:].]/_/g' *
```

---

## Extended Globbing (extglob)

Enable with: `shopt -s extglob` (bash)

### Patterns

|Pattern|Meaning|
|---|---|
|`?(pattern)`|Matches zero or one occurrence|
|`*(pattern)`|Matches zero or more occurrences|
|`+(pattern)`|Matches one or more occurrences|
|`@(pattern)`|Matches exactly one occurrence|
|`!(pattern)`|Matches anything except pattern|

```bash
# Enable extended globbing
shopt -s extglob

# Match .jpg or .png files
ls *.@(jpg|png)

# Exclude .txt and .log
ls !(*.txt|*.log)

# One or more digits
ls file+([0-9]).txt

# Zero or more 'a's
ls file*(a).txt

# Not backup files
rm !(*.backup)
```

**Practical examples:**

```bash
# Delete everything except important files
rm !(keep|important|critical).txt

# Multiple extensions
cp *.@(jpg|png|gif) /images/

# Match version numbers
ls app-+([0-9]).+([0-9]).+([0-9]).tar.gz

# Disable when done
shopt -u extglob
```

---

## Globstar `**` (Recursive Globbing)

Enable with: `shopt -s globstar` (bash 4+)

```bash
# Enable globstar
shopt -s globstar

# All Python files recursively
ls **/*.py

# All .conf files in any subdirectory
find . -name "*.conf"  # or
ls **/*.conf

# Specific depth
ls **/test/**/*.js

# All files recursively
ls **/*
```

**Comparison:**

```bash
# Without globstar
ls */*.py        # One level deep
ls */*/*.py      # Two levels deep
ls */*/*/*.py    # Three levels deep

# With globstar
ls **/*.py       # Any depth
```

---

## Important Behaviors

### Hidden Files

By default, `*` does **not** match hidden files (starting with `.`).

```bash
# Doesn't include .bashrc, .profile, etc.
ls *

# Explicitly include hidden files
ls .*

# All files including hidden
ls * .*

# Better: use extended glob
shopt -s dotglob
ls *
shopt -u dotglob
```

### Shell Expansion Order

The shell expands wildcards **before** running the command.

```bash
# This command
ls *.txt

# Becomes (if you have file1.txt and file2.txt)
ls file1.txt file2.txt
```

**Preventing expansion:**

```bash
# Use quotes to prevent expansion
echo "*"          # Prints: *
echo '*'          # Prints: *

# Escape the character
echo \*           # Prints: *

# Useful when passing to commands
find . -name "*.txt"    # Quotes prevent shell expansion
find . -name '*.txt'    # Single quotes work too
```

### No Match Behavior

If no files match, behavior depends on shell options:

```bash
# Default (bash): pass literal pattern
ls *.xyz          # If no .xyz files, tries to ls "*.xyz"

# Set nullglob: expand to nothing
shopt -s nullglob
ls *.xyz          # Expands to: ls (just lists current dir)

# Set failglob: throw error
shopt -s failglob
ls *.xyz          # Error: no match
```

---

## Combining Wildcards

You can combine multiple wildcard types for complex patterns.

```bash
# Files like: test_1.txt, test_a.txt, prod_2.log
ls *_[0-9a-z].*

# Dates: 2024-01-01 through 2024-12-31
ls log_20[2-9][0-9]-[0-1][0-9]-[0-3][0-9].txt

# Version numbers
ls app-[0-9].[0-9].[0-9].tar.gz

# Multiple patterns
ls *.{txt,log,conf} | grep -E "2024|2025"

# Complex filters
ls [A-Z]*[0-9]*.{jpg,png}
```

---

## Real-World Examples

### File Management

```bash
# Backup all configs
cp /etc/*.conf /backup/configs/

# Move old logs to archive
mv app_20{20,21,22}*.log /archive/

# Delete temp files
rm /tmp/temp_* /tmp/*.tmp

# Find large files
ls -lh **/*.{mp4,avi,mkv} | grep "G"

# Copy specific year's photos
cp IMG_2024*.{jpg,JPG} /photos/2024/
```

### Batch Operations

```bash
# Convert all images
for img in *.jpg; do convert "$img" "${img%.jpg}.png"; done

# Rename files (add prefix)
for file in *.txt; do mv "$file" "backup_$file"; done

# Process data files
for data in data_{1..100}.csv; do
    python process.py "$data" > "result_${data}"
done

# Compress logs by month
for month in {01..12}; do
    tar czf logs_2024-${month}.tar.gz log_2024-${month}-*.txt
done
```

### Search and Filter

```bash
# Find config files modified today
ls -lt /etc/*.conf | head

# Count files by type
echo "Python: $(ls **/*.py 2>/dev/null | wc -l)"
echo "JavaScript: $(ls **/*.js 2>/dev/null | wc -l)"

# List only directories
ls -d */

# Find duplicate extensions
ls * | grep -o '\.[^.]*$' | sort | uniq -c | sort -rn
```

### System Administration

```bash
# Check log sizes
du -sh /var/log/*.log | sort -h

# Find old backups
ls -lt *.backup | tail -20

# List users' home directories
ls -ld /home/*/

# Check all systemd services
ls /etc/systemd/system/*.service
```

---

## Common Pitfalls

### Quoting Issues

```bash
# WRONG - shell expands before grep sees it
grep error *.log

# RIGHT - if you want grep to handle the pattern
grep error "*.log"

# WRONG - expansion happens before find
find . -name *.txt

# RIGHT - quotes protect from shell expansion
find . -name "*.txt"
```

### Word Splitting

```bash
# Dangerous if filenames have spaces
for file in $(ls *.txt); do
    echo $file        # Breaks on spaces
done

# Better - glob directly
for file in *.txt; do
    echo "$file"      # Preserves spaces
done

# Best - use quotes
for file in *.txt; do
    rm "$file"        # Safe
done
```

### Destructive Operations

```bash
# VERY DANGEROUS - always double-check
rm *

# Safer - list first
ls *
# Then if safe:
rm *

# Even safer - use -i for interactive
rm -i *

# Safest - use trash or move to temp
mkdir /tmp/todelete
mv * /tmp/todelete/
```

### Case Sensitivity

```bash
# Linux is case-sensitive
ls *.txt    # Matches: file.txt
ls *.TXT    # Matches: file.TXT (different!)

# Match both
ls *.[tT][xX][tT]

# Or use extended glob
shopt -s nocaseglob
ls *.txt    # Matches: file.txt, file.TXT, file.TxT
shopt -u nocaseglob
```

---

## Quick Reference

|Pattern|Matches|Example|
|---|---|---|
|`*`|Any characters|`*.txt` → all .txt files|
|`?`|Single character|`file?.txt` → file1.txt, fileA.txt|
|`[abc]`|One of: a, b, or c|`file[123]` → file1, file2, file3|
|`[a-z]`|Range a through z|`[A-Z]*` → files starting with capital|
|`[!abc]`|Not a, b, or c|`[!0-9]*` → not starting with digit|
|`{a,b}`|Brace expansion|`file{1,2}.txt` → file1.txt file2.txt|
|`{1..5}`|Range expansion|`{1..5}` → 1 2 3 4 5|

---

## Testing Patterns

Before running destructive operations, test your patterns:

```bash
# Instead of:
rm *_backup.*

# First test:
ls *_backup.*        # See what matches
echo rm *_backup.*   # See the full command
# Then run if correct

# Or use echo to debug
echo *.{txt,log}     # Shows expansion

# Use -i flag for confirmation
rm -i *_backup.*
```

---

## Practice Exercises

Try these patterns:

1. List all `.jpg` and `.png` files
2. Create files named `test01.txt` through `test10.txt`
3. Find all files starting with capital letters
4. Delete all files ending with `~` (backups)
5. List all hidden files (starting with `.`)
6. Copy all 2024 logs to an archive directory
7. Find files with exactly 4-character names
8. List all directories (not files)

**Solutions:**

```bash
# 1
ls *.{jpg,png}
ls *.jpg *.png

# 2
touch test{01..10}.txt

# 3
ls [A-Z]*

# 4
rm *~

# 5
ls .[!.]*
ls -d .*

# 6
mkdir -p archive
cp *2024*.log archive/

# 7
ls ????
ls -d ????

# 8
ls -d */
```

---

## See Also

- [[pipes-and-redirection-guide]] - Combine with pipes for powerful commands
- `man bash` - Search for "Pattern Matching" section
- `man glob` - POSIX globbing documentation

---

## Tags

#linux #bash #cli #wildcards #globbing #patterns #shell #files