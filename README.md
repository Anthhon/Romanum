# Romanum

A CLI tool for converting between Roman numerals and integers, written in C.

## Features

- Roman numeral to integer (`XLII` → `42`)
- Integer to roman numeral *(in progress)*
- Case-insensitive input
- Subtractive notation support
- Optional debug logging via compile-time flag

## Build

```sh
gcc -o romanum main.c
```

Enable debug output:

```sh
gcc -DTOGGLE_DEBUG -o romanum main.c
```

## Usage

```
./romanum [OPTION] [VALUE]
```

| Flag | Long form | Action |
|------|-----------|--------|
| `-i` | `--to-int` | Convert Roman numeral to integer |
| `-r` | `--to-roman` | Convert integer to Roman numeral |

### Examples

```sh
./romanum -i XLII
# 42

./romanum --to-int mcmxcix
# 1999

./romanum -r 42
# (not yet implemented)
```

## Supported Numerals

| Symbol | Value |
|--------|-------|
| I | 1 |
| V | 5 |
| X | 10 |
| L | 50 |
| C | 100 |
| D | 500 |
| M | 1000 |

Subtractive pairs recognized: `IV`, `IX`, `XL`, `XC`, `CD`, `CM`, and extended pairs (`IL`, `IC`, `ID`, `IM`, `VL`, `VC`, `VD`, `VM`, `XD`, `XM`).

## Status

| Feature | Status |
|---------|--------|
| Roman → Integer | Implemented |
| Integer → Roman | In progress |
| Input validation | Partial |

## License

MIT
