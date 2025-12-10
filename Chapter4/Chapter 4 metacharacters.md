#learning #linux 
## Summary

File‑matching metacharacters (also called _globs_) allow you to select groups of files based on patterns rather than typing each filename manually. This is essential for DevOps workflows because it enables automation, reproducibility, and safe bulk operations across logs, configs, manifests, and artifacts.

Globs are expanded **by the shell**, not by commands. This means the shell replaces the pattern with matching filenames _before_ the command runs.


# Core Patterns and What They Do

### `*` — Match zero or more characters

Matches anything, including nothing. Useful for selecting broad sets of files.

> [!example] Example `ls *.log` 
> Lists all files ending in `.log`.

### `?` — Match exactly one character

Useful when filenames follow a fixed-width pattern.

> [!example] Example `ls app-?.yaml` 
> Matches: `app-a.yaml`, `app-1.yaml` Does not match: `app-prod.yaml`.

### `[abc]` — Match any one character in the set

Useful for selecting files that start with specific letters.

> [!example] Example `ls [agw]*` 
> Matches files starting with a, g, or w.

### `[a-z]` — Match a range of characters

Useful for alphabetical or numeric ranges.

> [!example] Example `ls file-[0-9].txt` 
> Matches: `file-1.txt`, `file-7.txt` 
> Not: `file-10.txt`.

### `[^abc]` — Match any character _not_ in the set

Useful for excluding certain prefixes.

> [!example] Example `ls [^a]*` 
> Matches all files not starting with `a`.

### `{a,b,c}` — Brace expansion (not globbing)

Expands into multiple literal strings. Useful for predictable, explicit expansions.

> [!example] Example `echo {dev,prod,stage}-config.yaml` 
> Expands to: `dev-config.yaml prod-config.yaml stage-config.yaml`


![[Pasted image 20251204140804.png]]


