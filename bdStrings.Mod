MODULE bdStrings;
IMPORT SYSTEM;
CONST
  nullChar = 0X;
  escVal   = 0FFX;

TYPE
  chararr = ARRAY 2 OF CHAR;

PROCEDURE eos*(VAR s: ARRAY OF CHAR): LONGINT;
VAR
  upb, pos, res: LONGINT;
BEGIN

  upb := LEN(s) - 1; (* upper bound of the index range *)
  pos := upb - ORD(s[upb]);

  res := LEN(s); (* default for non null-terminated *)

  IF pos >= 0 THEN
    IF s[pos] = nullChar THEN
      res := pos
    ELSE
      IF s[upb] = escVal THEN
        pos := ORD(s[upb - 2]) * 256 + ORD(s[upb - 1]);
        (* in this case the encoding is relative to location 0 *)
        IF (pos >= 0) & (pos <= upb) & (s[pos] = nullChar) THEN
          res := pos
        END
      END
    END
  END;
  RETURN res
END eos;

PROCEDURE length*(VAR s: ARRAY OF CHAR): LONGINT;
BEGIN
  RETURN eos(s)
END length;

(* makes an empty string *)
PROCEDURE init*(VAR s: ARRAY OF CHAR);
 VAR
   i: LONGINT;
BEGIN
  i := 0;
  REPEAT
    s[i] := 0X;
    INC(i)
  UNTIL (i = (LEN(s) -1));
END init;

PROCEDURE isEmpty*(VAR s: ARRAY OF CHAR): BOOLEAN;
BEGIN
 RETURN s[0] = nullChar
END isEmpty;

PROCEDURE terminate*(VAR s: ARRAY OF CHAR; e: INTEGER);
BEGIN

END terminate;

PROCEDURE setSize(VAR s: ARRAY OF CHAR; i: LONGINT);
VAR
  tmp: INTEGER;
  tmpstr: chararr;
BEGIN
    IF i > 255 THEN
      s[LEN(s) - 1] := escVal;
      tmp := SHORT(i);
      tmpstr := SYSTEM.VAL(chararr, tmp);
      s[LEN(s)-2] := tmpstr[1];
      s[LEN(s)-3] := tmpstr[0];
    ELSE
      s[LEN(s) - 1] := CHR(SHORT(SHORT(i)));
    END
END setSize;

(* adapts regular null-terminated string to the proposed convention.
finds the null-character by a left-to-right scan and encodes its length in the conventional way *)
PROCEDURE accept*(VAR s : ARRAY OF CHAR);
  VAR
    i: LONGINT;
    tmp: INTEGER;
    tmpstr: chararr;
BEGIN
  i := 0;
  REPEAT
    INC(i)
  UNTIL (s[i] = 0X) OR (i = LEN(s));
  IF s[i] = 0X THEN
    setSize(s, i);
  ELSE
    s[LEN(s)-1] := 0X
  END;
END accept;

PROCEDURE assign*(VAR sl: ARRAY OF CHAR; sr: ARRAY OF CHAR);
VAR
  i : LONGINT;
BEGIN
  i := 0;
  REPEAT
    sl[i] := sr[i];
    INC(i)
  UNTIL (sr[i] = 0X) OR (i = LEN(sl)) OR (i = LEN(sr));
    IF sr[i] = 0X THEN
      sl[i] := 0X;
      setSize(sl, i)
    END
END assign;

PROCEDURE append*(VAR sl: ARRAY OF CHAR; sr: ARRAY OF CHAR);
VAR
  i, j: LONGINT;
BEGIN
  i := 0;
  j := eos(sl);
  REPEAT
    sl[j] := sr[i];
    INC(j); INC(i);
  UNTIL sr[i] = 0X;
    sl[j] := 0X;
    setSize(sl, j)
END append;

PROCEDURE appendChar*(VAR s: ARRAY OF CHAR; ch: CHAR);

BEGIN

END appendChar;

PROCEDURE nextChar(VAR s: ARRAY OF CHAR; pos: INTEGER): CHAR;

BEGIN

END nextChar;

(* appends part of sr onto sl, starting at sr[pos] upto (but not including) the first occurence of the character ch in sr, or (if ch is not found) upto the end of sr. Upon completion pos satisfies: (pos = eos(sr)) OR (sr[pos] = ch) *)
PROCEDURE appendUpTo(VAR sl: ARRAY OF CHAR; sr: ARRAY OF CHAR; pos: INTEGER; ch: CHAR);

BEGIN

END appendUpTo;

END bdStrings.
