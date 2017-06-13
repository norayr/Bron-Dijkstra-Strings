MODULE bdStrings;

CONST
  nullChar = 0X;
  escVal   = 0FFX;
  strLen   = 256;

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
        pos := ORD(s[upb - 2]) * strLen + ORD(s[upb - 1]);
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

BEGIN

END init;

PROCEDURE isEmpty(VAR s: ARRAY OF CHAR): BOOLEAN;

BEGIN
 RETURN s[0] = nullChar
END isEmpty;

PROCEDURE terminate*(VAR s: ARRAY OF CHAR; e: INTEGER);

BEGIN

END terminate;

(* adapts regular null-terminated string to the proposed convention.
finds the null-character by a left-to-right scan and encodes its length in the conventional way *)
PROCEDURE accept*(VAR s : ARRAY OF CHAR);
BEGIN


END accept;

PROCEDURE assign*(VAR sl: ARRAY OF CHAR; sr: ARRAY OF CHAR);

BEGIN

END assign;

PROCEDURE append*(VAR sl: ARRAY OF CHAR; sr: ARRAY OF CHAR);

BEGIN

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
