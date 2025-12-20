
## Overview

A fundamental skill for any Linux administrator is the ability to see what is running on the system and how to control it. This chapter covers the lifecycle of processes, how to monitor them using static and dynamic tools, and how to manage their priority and resource limits via cgroups.

## 1. Understanding Processes

A **process** is an executing instance of a program. When you launch a command, the Linux kernel assigns it a unique identifier and allocates resources (RAM, CPU time).

### Key Process Attributes

- **PID (Process ID):** A unique number identifying the process.
    
- **PPID (Parent Process ID):** The PID of the process that started the current one.
    
- **UID/GID:** The User and Group IDs associated with the process (determines permissions).
    
- **Niceness:** The scheduling priority of the process.
    

> [!INFO] The First Process
> 
> When a Linux system boots, the kernel starts the init process (usually systemd on modern distributions like RHEL, Fedora, and Ubuntu). It always has PID 1. All other processes are children (or descendants) of PID 1.

---

## 2. Listing Processes with `ps`

The `ps` (process status) command is the primary tool for viewing the state of processes at a specific moment in time (static view).

### Common Syntax Styles

The `ps` command accepts options in three styles:

1. **UNIX options:** Preceded by a dash (e.g., `-e`).
    
2. **BSD options:** No dash (e.g., `aux`).
    
3. **GNU long options:** Two dashes (e.g., `--help`).
    

### The Ubiquitous Command: `ps aux`

This is the most common combination used to see every process on the system.

- `a`: Show processes for all users.
    
- `u`: Display the process's user/owner.
    
- `x`: Show processes not attached to a terminal.
    

**Key Columns in `ps aux` output:**

- **USER:** The user running the process.
    
- **PID:** The Process ID.
    
- **%CPU / %MEM:** Resource usage.
    
- **VSZ:** Virtual memory size.
    
- **RSS:** Resident Set Size (physical memory used).
    
- **TTY:** The terminal associated with the process (`?` means no terminal, often a daemon).
    
- **STAT:** The process state code.
    

> [!NOTE] Deciphering STAT Codes
> 
> The STAT column gives you the current health of the process. Common codes include:
> 
> - **R:** Running or runnable (on run queue).
>     
> - **S:** Sleeping (waiting for an event).
>     
> - **D:** Uninterruptible sleep (usually waiting for I/O).
>     
> - **Z:** Zombie (terminated but parent hasn't collected exit status).
>     
> - **T:** Stopped (suspended/paused).
>     
> - **<:** High-priority (not nice).
>     
> - **N:** Low-priority (nice).
>     

### The System V Style: `ps -ef`

Alternatively, you can use `ps -ef`:

- `-e`: Select all processes.
    
- `-f`: Do full-format listing.

- `-o`: List all options

This output includes the **PPID**, which is crucial when tracing process genealogy.

---

## 3. Dynamic Monitoring with `top`

Unlike `ps`, which takes a snapshot, `top` provides a real-time, dynamic view of the running system. By default, it refreshes every 3 seconds and sorts processes by CPU usage.

### Reading the `top` Header

The top section of the output provides system-wide stats:

1. **Uptime:** How long the system has been running.
    
2. **Load Average:** CPU demand over 1, 5, and 15 minutes.
    
3. **Tasks:** Total, running, sleeping, stopped, and zombie processes.
    
4. **CPU(s):** usage breakdown (`us` user, `sy` system, `id` idle, `wa` wait I/O).
    
5. **Mem/Swap:** Physical RAM and Swap usage.
    

> [!TIP] Interactive top Commands
> 
> While top is running, you can press single keys to change the view:
> 
> - `k`: Kill a process (prompts for PID).
>     
> - `r`: Renice a process (prompts for PID and value).
>     
> - `P`: Sort by CPU (default).
>     
> - `M`: Sort by Memory usage.
>     
> - `h`: Help menu.
>     
> - `q`: Quit.
>     

---

## 4. Controlling Processes (Signals)

You generally control processes by sending them **signals**. Signals tell a process to stop, restart, terminate, or reload configuration.

### Common Signals

You can refer to signals by name or number.

|**Signal ID**|**Name**|**Description**|**Use Case**|
|---|---|---|---|
|**1**|`SIGHUP`|Hangup|Reload configuration files without stopping the process.|
|**2**|`SIGINT`|Interrupt|Same as pressing `Ctrl+C`.|
|**9**|`SIGKILL`|Kill|Forcefully kills the process. Cannot be caught or ignored.|
|**15**|`SIGTERM`|Terminate|The default signal. Asks the process to stop nicely (clean up files, etc.).|
|**18**|`SIGCONT`|Continue|Resumes a stopped process.|
|**19**|`SIGSTOP`|Stop|Pauses the process (cannot be caught).|

### The `kill` Command

Used to send signals to a specific PID.

Bash

```
# Default (sends SIGTERM - 15)
kill 1234 

# Force kill (sends SIGKILL - 9)
kill -9 1234

# Reload config (sends SIGHUP - 1)
kill -1 1234
```

> [!DANGER] Avoid kill -9 Initially
> 
> Always try kill (SIGTERM) first. Using kill -9 forces the kernel to rip the process from memory immediately. This can result in corrupted files or open database connections because the process wasn't allowed to clean up after itself.

### `killall` and `pkill`

These commands allow you to kill processes by **name** rather than PID.

- **`killall firefox`**: Kills all processes named "firefox".
    
- **`pkill -u user1`**: Kills all processes owned by "user1".
    

---

## 5. Background and Foreground Processing

Linux allows you to run jobs in the background, freeing up your shell for other commands.

### Managing Jobs

1. **Start in Background (`&`):** Append an ampersand to a command.
    
    Bash
    
    ```
    find / -name "test" > output.txt &
    ```
    
2. **Pause a Foreground Job (`Ctrl+Z`):** This sends a `SIGSTOP` signal and suspends the job.
    
3. **View Jobs (`jobs`):** Lists the current shell's active jobs with their Job IDs (different from PIDs).
    
4. **Foreground (`fg`):** Brings a background/stopped job to the foreground.
    
    Bash
    
    ```
    fg %1  # Brings job 1 to foreground
    ```
    
5. **Background (`bg`):** Resumes a suspended job, but keeps it in the background.
    

---

## 6. Process Priority (Niceness)

Linux uses a priority system called "Niceness" to determine which processes get more CPU attention.

- **Range:** -20 (Highest Priority) to +19 (Lowest Priority).
    
- **Default:** 0.
    

Think of it as the process being "nice" to others. A process with +19 is very nice (steps aside for everyone). A process with -20 is very selfish (demands attention).

### Adjusting Priority

1. **`nice`**: Start a new process with a specific priority.
    
    Bash
    
    ```
    # Start tar command with low priority
    nice -n 10 tar -czf backup.tar.gz /home
    ```
    
2. **`renice`**: Change the priority of an _already running_ process.
    
    Bash
    
    ```
    # Change PID 1234 to high priority (requires sudo for negative numbers)
    sudo renice -n -5 1234
    ```
    

> [!WARNING] Permission Rules
> 
> - **Regular users** can only increase the niceness (make priority lower, e.g., 0 to 10). They cannot make a process more selfish.
>     
> - **Root** can set any niceness value (make priority higher or lower).
>     

---

## 7. Control Groups (cgroups)

While `nice` manages CPU priority, **cgroups** (Control Groups) allow the kernel to limit, account for, and isolate the resource usage (CPU, memory, disk I/O, network) of a collection of processes.

### Concept: The Hierarchy

Processes are organized into a hierarchical tree. If a parent group is limited to 1GB of RAM, all child processes combined cannot exceed that 1GB. In modern Linux (Systemd), every service and user session is assigned to a cgroup.

### Monitoring cgroups

Instead of viewing individual processes (like `ps`), you view the hierarchy.

#### 1. `systemd-cgls`

This command visualizes the tree structure of running processes, grouped by their service or slice. It is excellent for seeing the parent-child relationships that `ps` might miss.

Bash

```
$ systemd-cgls
Control group /:
-.slice
├─user.slice
│ ├─user-1000.slice
│ │ └─session-1.scope
│ │   ├─1234 /usr/bin/gnome-shell
```

#### 2. `systemd-cgtop`

Similar to `top`, but for cgroups. It shows which services or groups are consuming the most resources, rather than just individual PIDs.

- **Path:** The cgroup path (e.g., `/system.slice/httpd.service`).
    
- **Tasks:** Number of processes in that group.
    
- **%CPU:** CPU consumption of the whole group.
    
- **Memory:** RAM usage of the whole group.
    

> [!TIP] Why use cgroups?
> 
> If an Apache web server spawns 100 child processes, top might show 100 small entries. systemd-cgtop will show you exactly how much CPU the entire Apache service is using combined.

---

## 8. Summary of Key Commands

|**Command**|**Description**|
|---|---|
|`ps aux`|Detailed static list of all processes.|
|`top`|Real-time process monitoring.|
|`jobs`|List background jobs in current shell.|
|`kill [PID]`|Send a signal (default SIGTERM) to a PID.|
|`nice` / `renice`|Set or modify process priority.|
|`systemd-cgls`|Display process tree hierarchically by cgroup.|
|`systemd-cgtop`|Monitor resource usage by cgroup (Service/Slice).|


## signal options

| Signal    | Number   | Description                                                                  |
| --------- | -------- | ---------------------------------------------------------------------------- |
| `SIGHUP`  | 1        | Hang up on detected on controlling terminal or death of controlling process. |
| `SIGINT`  | 2        | Interrupt from keyboard                                                      |
| `SIGQUIT` | 3        | Quit from keyboard                                                           |
| `SIGABRT` | 6        | Abort signal from abort(3)                                                   |
| `SIGKILL` | 9        | Kill signal                                                                  |
| `SIGTERM` | 19,18,25 | Termination signal                                                           |
| `SIGSTOP` | 17,19,23 | Stop process                                                                 |


