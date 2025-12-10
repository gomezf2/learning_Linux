
**Definition:** A fast and versatile file copying tool that synchronizes files and directories between two locations.

**Common Syntax:**
`rsync [options] [source] [destination]`

**Key Flags:**
* `-a` (Archive): Preserves permissions, times, symbolic links, and copies recursively. It ensures the destination is an exact clone of the source.
* `-v` (Verbose): displays a detailed list of files being transferred during the process.
* `-z` (Compress): Compresses file data during the transfer (useful for sending over the internet).
* `--exclude`: Prevents specific files or directories from being synced.

**Why use it over cp?**
`cp` blindly copies everything. `rsync` checks the file differences and only transfers the changes (deltas), making it much faster for backups.

