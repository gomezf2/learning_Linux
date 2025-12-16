
---
## 1. What is Vi / Vim?

**vi** is the classic Unix text editor: lightweight, keyboard‑driven, and available on virtually every Linux system.

**vim (Vi IMproved)** extends vi with:

- Syntax highlighting
    
- Multiple undo levels
    
- Split windows
    
- Extensive plugin support
    

Both editors are **modal**, relying on keystroke commands rather than menus or a mouse. This makes them extremely efficient once the mental model clicks.

---

## 2. Vim Modes (Mental Model)

Vim operates primarily in two modes:

- **Normal mode** — navigation, commands, deletion, copying
    
- **Insert mode** — entering and editing text
    

You always return to Normal mode with:

```
Esc
```

Most errors in Vim come from being in the wrong mode.

---

## 3. Entering Insert Mode (Adding Text)

### Insert & Append Commands

|Command|Action|
|---|---|
|`i`|Insert before cursor|
|`I`|Insert at beginning of line|
|`a`|Append after cursor|
|`A`|Append at end of line|

### Opening New Lines

|Command|Action|
|---|---|
|`o`|Open new line below and enter Insert mode|
|`O`|Open new line above and enter Insert mode|

Exit Insert mode with `Esc`.

---

## 4. Moving Around the Text

### Basic Movement

|Key|Movement|
|---|---|
|`h`|Left|
|`j`|Down|
|`k`|Up|
|`l`|Right|

Arrow keys work, but `h j k l` build better muscle memory.

### Word Navigation

|Command|Description|
|---|---|
|`w`|Next word|
|`W`|Next WORD (ignores punctuation)|
|`b`|Previous word|
|`B`|Previous WORD|

### Line Navigation

|Command|Description|
|---|---|
|`0`|Start of line|
|`$`|End of line|

### Screen Navigation

|Command|Description|
|---|---|
|`H`|Top of screen|
|`M`|Middle of screen|
|`L`|Bottom of screen|

---

## 5. Editing, Deleting, and Copying Text

### Single‑Character Commands

|Command|Action|
|---|---|
|`x`|Delete character under cursor|
|`X`|Delete character before cursor|

### Operator + Motion Pattern

Vim editing follows this pattern:

```
operator + motion
```

|Operator|Meaning|
|---|---|
|`d`|Delete|
|`c`|Change (delete + insert)|
|`y`|Yank (copy)|

The **motion** defines the range (`w`, `b`, `$`, `0`, etc.).

### Common Combinations

|Command|Action|
|---|---|
|`dw`|Delete word forward|
|`db`|Delete word backward|
|`dd`|Delete entire line|
|`cc`|Change entire line|
|`c$`|Change to end of line|
|`yy`|Yank line|
|`y)`|Yank sentence|
|`y}`|Yank paragraph|

### Using Counts (Repeating Motions)

Numbers repeat commands:

```
3dd   # delete 3 lines
5cw   # change 5 words
12j   # move down 12 lines
```

---

## 6. Pasting (Putting) Text

|Command|Action|
|---|---|
|`p`|Paste after cursor / below line|
|`P`|Paste before cursor / above line|

Behavior depends on whether characters or whole lines were yanked.

---

## 7. Visual Mode (Selecting Text)

|Command|Action|
|---|---|
|`v`|Character‑wise selection|
|`V`|Line‑wise selection|
|`Ctrl + v`|Block (column) selection|

Visual mode makes selection explicit before operating on text.

---

## 8. Repeating and Undoing Actions

|Command|Action|
|---|---|
|`.`|Repeat last change|
|`u`|Undo|
|`Ctrl + r`|Redo|

---

## 9. Saving and Exiting

|Command|Description|
|---|---|
|`:w`|Save file|
|`:q`|Quit (no unsaved changes)|
|`:wq`|Save and quit|
|`ZZ`|Save and quit|
|`:q!`|Quit without saving|

---

## 10. Essential Commands & Information

|Command|Description|
|---|---|
|`Esc`|Return to Normal mode|
|`Ctrl + g`|Show file info and cursor position|
|`:!command`|Run shell command from Vim|

Example:

```
:!date
```

---

## 11. Skipping Around a File

|Command|Action|
|---|---|
|`Ctrl + f`|Page forward|
|`Ctrl + b`|Page backward|
|`Ctrl + d`|Half‑page forward|
|`Ctrl + u`|Half‑page backward|
|`G`|Last line|
|`1G`|First line|
|`35G`|Go to line 35|

---

## 12. Searching

|Command|Description|
|---|---|
|`/pattern`|Search forward|
|`?pattern`|Search backward|
|`n`|Repeat search (same direction)|
|`N`|Repeat search (opposite direction)|

Examples:

```
/The.*foot
?[pP]rint
```

---

## 13. Ex (Command‑Line) Mode

|Command|Description|
|---|---|
|`:s/old/new`|Substitute first match on line|
|`:%s/old/new/g`|Substitute all matches in file|
|`:g/word`|Print lines containing word|

Examples:

```
:g/Local/s//Remote/g
```

---

## 14. Key Takeaways

- Vim is about **composing commands**, not memorising shortcuts
    
- Think in **verbs + motions**
    
- Stay aware of your mode
    
- Speed comes from repetition, not complexity
    

---

_End of Chapter 5_