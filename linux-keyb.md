# Guide for coding and typing Portuguese across Mac, Windows, and Linux (including Omarchy)

A reference for people who move between macOS, Windows and Linux.

The Linux sections are Omarchy focused but mention Linux in general.

## Scope

This document covers keyboards with a **physical US layout**. The key count,
the key positions and the printed legends are US ANSI.

Every option below adds Portuguese to that hardware through software. The
hardware does not change.

Keyboards with a different physical layout are out of scope. This includes
ABNT2, the most common layout in Brazil. ABNT2 has more keys, and it has a
dedicated `ç` key, so it does not have the problem this document describes.

## The problem

Code needs plain punctuation. `'` `"` `` ` `` `~` `^` must type themselves:

```js
const a = 'a';
```

Portuguese needs accents: á é í ó ú, â ê ô, ã õ, à, ç, ü.

A layout that puts dead keys on plain punctuation solves the second need and
breaks the first. `'` stops typing an apostrophe. It arms an accent instead.

The two needs fight. Every option below is a different way to separate them.

## How each system solves it

### macOS

The Option key holds the accents. `Option+e` arms an acute. `Option+c` gives ç
directly. Plain `'` stays plain.

macOS lets Option be a modifier and an accent composer at the same time. The
shortcut dispatcher runs before text input. So `⌥⌘N` is a shortcut and `⌥N` is
a dead key. Both Option keys behave the same.

### Windows

The US-International layout puts dead keys on `'` `"` `` ` `` `~` `^`.

This breaks code. Users switch layouts: US for work, US-International for
Portuguese.

### Linux

Linux offers the same layout under the name `us(intl)`. Installers and desktop
environments list it as "English (US, intl., with dead keys)". Layout selection
is the default path, as on Windows.

This breaks code in the same way. Users select `us(intl)` and keep it, or load
two layouts and toggle. Omarchy stores the choice in `/etc/vconsole.conf` and
reads it at startup.

## Linux advanced features

Linux has two more mechanisms. Most users never meet them, because the layout
list does not mention them. They are independent, and you can use both.

**XKB levels.** Each key holds up to four symbols. Level 1 is the plain key.
Level 2 is Shift. Level 3 and 4 need a level-3 shifter, usually Right Alt.
A layout variant decides which symbol sits at which level. Options 1 and 3
below use this.

**Compose.** A prefix key. You tap it and release it, then type a short
sequence. `Compose ' a` gives á. Nothing is held. Compose reads a table, and
the table comes from the locale. Option 4 below uses this.

Omarchy turns Compose on by default and puts it on the CapsLock keycode:

```
kb_options = "compose:caps,shift:both_capslock_cancel"
```

Most distributions leave Compose off. Omarchy also ships a compose table with
emoji sequences.

## The options at a glance

The two mechanisms above, plus the layout list, give five options.

| | `ç` | Safe for code | Switching | Vanilla on Omarchy |
|---|---|---|---|---|
| 1. `us(mac)` | RAlt+c | ✅ | never | ✅ |
| 2. `us(intl)` | AltGr+comma | ❌ | never | ✅ |
| 3. `us(altgr-intl)` | AltGr+comma | ✅ | never | ✅ |
| 4. Compose only | `Compose , c` | ✅ | never | ✅ |
| 5. Switch `us` / `us(intl)` | AltGr+comma | ❌ while in intl | constant | ❌ |

"Vanilla on Omarchy" means you can select the option with `localectl` alone.
Option 5 needs a group toggle, and a group toggle is a `kb_options` value, so
it needs a file edit. See "Applying it on Omarchy".

### The trade-offs in short

- Dead keys on plain punctuation break code. Only option 2 does this, and
  option 5 does it while the second layout is active.
- Level-3 options keep punctuation safe. They put every accent behind Right
  Alt. Left Alt cannot compose accents.
- Compose keeps punctuation safe and needs no layout change. It costs three
  keystrokes for each accent.
- Switching gives each mode the best keys for its task. It costs a switch at
  every context change, and the group state is per device.
- `ç` sits in a different place in each option. It is the single character
  that separates them most.
- Linux `us(intl)` is not the same as Windows US-International. Two `ç`
  habits do not carry over.

## Deep dive

### The level-3 shifter is a keycode, not a position

Every international variant ends with the same include:

```
include "level3(ralt_switch)"
```

That expands to one line:

```
key <RALT> { [ ISO_Level3_Shift ], type[group1]="ONE_LEVEL" };
```

The behaviour binds to the `<RALT>` keycode. If a keyboard sends `<RWIN>` in
that position, level 3 does not work.

Other keys can carry the shifter. These options exist:

```
alt  bksl  caps  enter  lalt  lsgt  lwin  menu  ralt  rwin  win
```

### A key cannot be both a shifter and a modifier

`lv3:alt_switch` puts level 3 on both Alt keys. It also removes `<LALT>` from
`Mod1`:

```
lv3:alt_switch:  modifier_map Mod1 { <ALT>, <META> };
default:         modifier_map Mod1 { <LALT>, <ALT>, <META> };
```

`<ALT>` and `<META>` are virtual aliases. No physical key sends them. So Alt
stops working as a modifier on both sides.

This is why the macOS behaviour cannot be copied. XKB has no layer that can
decide "level 3 unless another modifier is down". A key is a shifter or a
modifier.

### Compose tables come from the locale

The compose file uses `include "%L"`. `%L` resolves to the compose table of
the current locale.

`en_US.UTF-8` maps `dead_acute + c` to ć.

`pt_BR.UTF-8` is `en_US.UTF-8` plus six overrides. Two of them matter:

```
include "/usr/share/X11/locale/en_US.UTF-8/Compose"
<dead_acute> <C> : "Ç" Ccedilla
<dead_acute> <c> : "ç" ccedilla
```

You can reach it in two ways:

1. Set `LC_CTYPE=pt_BR.UTF-8`. The locale must be generated. See
   `/etc/locale.gen`.
2. Add the include to `~/.XCompose`:
   ```
   include "/usr/share/X11/locale/pt_BR.UTF-8/Compose"
   ```

### Layout groups hold state per device

A system can load several layouts and switch between them. The compositor
tracks the active group.

Hyprland tracks the group **per input device**. A toggle changes only the
device you typed on. A reconnect returns that device to group 0.

## The Linux options

### 1. `us(mac)`

Copies the macOS ABC layout. Accents move from Option to Right Alt.

| macOS | `us(mac)` | Output |
|---|---|---|
| Option+c | RAlt+c | ç |
| Option+e | RAlt+e | dead acute → á é í ó ú |
| Option+n | RAlt+n | dead tilde → ã õ ñ |
| Option+i | RAlt+i | dead circumflex → â ê ô |
| Option+u | RAlt+u | dead diaeresis → ü |
| Option+` | RAlt+` | dead grave → à |
| Option+9 | RAlt+9 | ª |
| Option+0 | RAlt+0 | º |
| Option+Shift+8 | RAlt+Shift+8 | ° |

Punctuation stays at levels 1 and 2:

```
key <AC11> { [ apostrophe, quotedbl,   ae,         AE        ] };
key <TLDE> { [ grave,      asciitilde, dead_grave, dead_horn ] };
```

`ç` is a direct keysym. No compose table takes part.

**Pros.** No switching. Safe for code. One chord per accent. Matches macOS
muscle memory.
**Cons.** Only Right Alt composes accents. Left Alt stays a plain modifier.
On macOS both Option keys do both jobs.

### 2. `us(intl)`

Dead keys sit on plain punctuation, like Windows US-International.

```
key <AC11> { [ dead_acute, dead_diaeresis, apostrophe, quotedbl ] };
key <TLDE> { [ dead_grave, dead_tilde,     grave,      asciitilde ] };
key <AB08> { [ comma,      less,           ccedilla,   Ccedilla ] };
```

**Pros.** Accents need no modifier. Familiar to Windows users.
**Cons.** Not safe for code. `'` and `` ` `` are armed. It also differs from
Windows in two places. See the traps below.

### 3. `us(altgr-intl)`

Same as `us(intl)`, but the dead keys move to level 3.

```
key <AC11> { [ apostrophe, quotedbl,   dead_acute, dead_diaeresis ] };
key <TLDE> { [ grave,      asciitilde, dead_grave, dead_tilde     ] };
key <AB08> { [ comma,      less,       ccedilla,   Ccedilla       ] };
```

**Pros.** No switching. Safe for code.
**Cons.** Accent keys sit on punctuation, not on mnemonic letters. `ç` sits on
AltGr+comma.

### 4. Compose only, on plain `us`

Keep the plain layout. Type every accent as a compose sequence.

```
á  Compose ' a      ã  Compose ~ a      ç  Compose , c
â  Compose ^ a      õ  Compose ~ o      ü  Compose " u
à  Compose ` a      Ç  Compose , C      Ã  Compose ~ A
```

`ç` uses comma, not acute. The `dead_acute + c` problem cannot happen.

**Pros.** No switching. Safe for code. No layout change at all. The same table
also holds emoji and text snippets.
**Cons.** Three keystrokes per accent. The cost grows with accent density.
Compose placement depends on the keyboard. See the traps below.

### 5. Switch layouts

Load two layouts and toggle. For example `us` and `us(intl)`.

**Pros.** Each mode is optimal for its task.
**Cons.** You pay a switch on every context change. The group resets per
device. `us(intl)` is not safe for code while active.

## Traps

### Linux `us(intl)` is not Windows US-International

Two differences, both on `ç`:

| Keys | Windows US-Intl | Linux `us(intl)` |
|---|---|---|
| `'` then `c` | ç | ć |
| AltGr+c | ç | © |

In Linux, `ç` sits on AltGr+comma. The `pt_BR.UTF-8` compose table fixes the
first row. Nothing fixes the second row, because `©` is a keysym in the layout.

### Compose placement depends on the keyboard

Keyboards without a physical CapsLock key send that keycode through a chord,
such as `Fn+Tab`. A three-press sequence then costs four presses, and one is a
chord.

Move Compose with a `compose:*` option if the default position is bad.

### Verify the level-3 key before you choose a level-3 layout

Some keyboards remap the keys beside the space bar with DIP switches or
firmware. Check what your keyboard sends before you rely on Right Alt.

## Applying it on Omarchy

Omarchy's default `input.lua` reads `/etc/vconsole.conf`:

```lua
local kb_layout  = vconsole.XKBLAYOUT or "us"
local kb_variant = vconsole.XKBVARIANT or ""
```

So `localectl` sets the layout and the variant, and `input.lua` stays vanilla:

```bash
sudo localectl set-x11-keymap us pc105+inet mac terminate:ctrl_alt_bksp
hyprctl reload
```

Omarchy reads only `XKBLAYOUT` and `XKBVARIANT` from that file. It hardcodes
`kb_model` and `kb_options`. The model and options in `/etc/vconsole.conf`
apply to the TTY console only.

This means `localectl` cannot set `lv3:*` or `compose:*`. Those are
`kb_options`. To change them, edit `~/.config/hypr/input.lua`.

## How to verify

```bash
# Live values
hyprctl getoption input:kb_layout
hyprctl getoption input:kb_variant
hyprctl getoption input:kb_options

# Which keycode a physical key sends
xkbcli interactive-wayland

# Compile a keymap and read the symbol levels
xkbcli compile-keymap --layout us --variant mac

# Compile the compose table and search it
/usr/lib/xkbcommon/xkbcli-compile-compose ~/.XCompose

# List the variants a layout offers
localectl list-x11-keymap-variants us
```
