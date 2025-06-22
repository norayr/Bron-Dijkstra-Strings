# Bjorn Dijkstra Strings (bdStrings) for Oberon

## Overview

This Oberon module implements an efficient string representation based on the paper "A Better Way to Combine Efficient String Length Encoding and Zero-termination" by C. Bron and E.J. Dijkstra (1988). It combines the benefits of null-terminated strings (compatibility with C) and explicit length encoding (efficiency) while requiring minimal changes to existing language implementations.

## Key Concepts from the Paper

Problem with Traditional Approaches

1. Null-terminated strings (C-style):

* Require O(n) time to determine length

* Inefficient for concatenation and other operations

2. Length-prefixed strings:

* Store length at beginning of string

* Require language implementation changes

* Incompatible with existing null-terminated systems

The Bjorn Dijkstra Solution

1. Store length information at the end of the string container

2. Use the last byte to encode either:

* Distance to null terminator (for strings ending within 254 bytes of container end)

* Escape value (0xFF) indicating two-byte absolute position encoding

3. Maintain null termination where possible for compatibility

4. Require no language changes - works with standard character arrays

Benefits

* Constant-time length lookup for most strings

* Efficient concatenation without full length scans

* Backward compatible with null-terminated strings

* Handles arbitrary length strings gracefully

* Minimal overhead (1-3 bytes per string container)


## Module Interface

```
DEFINITION bdStrings;

CONST
  nullChar* = 0X;  (* Null terminator character *)
  escVal*   = 0FFX; (* Escape value for long string encoding *)

PROCEDURE eos*(VAR s: ARRAY OF CHAR): LONGINT;
(* Returns index of null terminator or LEN(s) if full *)

PROCEDURE length*(VAR s: ARRAY OF CHAR): LONGINT;
(* Returns string length (same as eos) *)

PROCEDURE init*(VAR s: ARRAY OF CHAR);
(* Initializes string as empty *)

PROCEDURE isEmpty*(VAR s: ARRAY OF CHAR): BOOLEAN;
(* Returns TRUE if string is empty *)

PROCEDURE terminate*(VAR s: ARRAY OF CHAR; e: LONGINT);
(* Sets null terminator at position e and updates encoding *)

PROCEDURE accept*(VAR s: ARRAY OF CHAR);
(* Converts standard null-term string to BD encoding *)

PROCEDURE assign*(VAR sl: ARRAY OF CHAR; sr: ARRAY OF CHAR);
(* Copies sr to sl with truncation if needed *)

PROCEDURE append*(VAR sl: ARRAY OF CHAR; sr: ARRAY OF CHAR);
(* Appends sr to sl with truncation if needed *)

PROCEDURE appendChar*(VAR s: ARRAY OF CHAR; ch: CHAR);
(* Appends single character *)

PROCEDURE nextChar*(VAR s: ARRAY OF CHAR; VAR pos: LONGINT): CHAR;
(* Gets next character with position counter *)

PROCEDURE appendUpTo*(
  VAR sl: ARRAY OF CHAR;
  sr: ARRAY OF CHAR;
  VAR pos: LONGINT;
  ch: CHAR
);
(* Appends until specific character *)

END bdStrings.
```

## Usage Examples

Basic Usage

```
MODULE Demo;
IMPORT Out, bdStrings;

PROCEDURE BasicDemo*;
VAR
  s: ARRAY 20 OF CHAR;
  s2: ARRAY 10 OF CHAR;
BEGIN
  bdStrings.init(s);
  bdStrings.assign(s, "Hello");
  Out.String("Length: "); Out.Int(bdStrings.length(s), 0); Out.Ln; (* 5 *)

  bdStrings.append(s, " World!");
  Out.String(s); Out.Ln; (* "Hello World!" *)

  bdStrings.assign(s2, "OverflowTest");
  Out.String(s2); Out.Ln; (* "OverflowT" (truncated) *)
END BasicDemo;
```

Position-Based Operations

```
PROCEDURE PositionDemo*;
VAR
  s: ARRAY 30 OF CHAR;
  pos: LONGINT;
BEGIN
  bdStrings.init(s);
  pos := 0;

  bdStrings.appendUpTo(s, "First,Second,Third", pos, ',');
  Out.String("Part1: "); Out.String(s); Out.Ln; (* "First" *)

  INC(pos); (* Skip separator *)
  bdStrings.appendUpTo(s, "First,Second,Third", pos, ',');
  Out.String("Part2: "); Out.String(s); Out.Ln; (* "FirstSecond" *)
END PositionDemo;
```

File Extension Replacement

```
PROCEDURE FileNameDemo*;
VAR
  newName, oldName: ARRAY 30 OF CHAR;
  pos: LONGINT;
BEGIN
  oldName := "document.txt";
  bdStrings.init(newName);
  pos := 0;

  bdStrings.appendUpTo(newName, oldName, pos, '.');
  bdStrings.append(newName, ".bak");

  Out.String("New name: "); Out.String(newName); Out.Ln; (* "document.bak" *)
END FileNameDemo;
```

## Performance Characteristics

## String Operations and Implementation Notes

### Operation Complexity Table

| Operation     | Complexity | Notes                                 |
|---------------|------------|---------------------------------------|
| `eos`/`length`| O(1)       | Constant-time length lookup           |
| `init`        | O(1)       | Fast initialization                   |
| `assign`      | O(n)       | Proportional to source length         |
| `append`      | O(n)       | Proportional to appended length       |
| `accept`      | O(n)       | Scans until null terminator          |
| `appendUpTo`  | O(k)       | Proportional to characters copied     |

---

### Best Practices

- Initialize strings with `init` before use
- Use `assign` instead of `:=` for proper encoding
- Prefer `append` over manual copying for concatenation
- Use position parameters for efficient tokenization
- Check container size before operations with large strings
- Use `accept` when working with external null-term strings

---

### Advantages Over Traditional Strings

- **Efficiency**: Length determination in O(1) time
- **Compatibility**: Maintains null termination for C interop
- **Safety**: Built-in truncation protection
- **Flexibility**: Handles strings of arbitrary length
- **No GC required**: Works with standard arrays
- **Portability**: Pure Oberon implementation

---

### References

- Bron, C., & Dijkstra, E.J. (1988). *A Better Way to Combine Efficient String Length Encoding and Zero-termination*. SIGPLAN Notices, 24(6), 11–19.
- Abrahams, P.W. (1988). *Some Sad Remarks About String Handling in C*. SIGPLAN Notices, 23(10), 61–68.

---

This implementation brings the elegant string handling concepts from Dijkstra's paper to modern Oberon systems, providing efficient string operations while maintaining compatibility with existing paradigms.

