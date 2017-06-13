MODULE bdStrings;

CONST
  escVal = 0FFX;
  strLen = 256;

PROCEDURE eos*(VAR s: ARRAY OF CHAR): LONGINT;
VAR
  upb, pos, res: LONGINT;
BEGIN

  upb :=LEN(s) - 1; (* upper bound of the index range *)
  pos := upb - ORD(s[upb]);

  res := LEN(s); (* default for non null-terminated *)

  IF pos >= 0 THEN
    IF s[pos] = 0X THEN
      res := pos
    ELSE
      IF s[upb] = escVal THEN
        pos := ORD(s[upb - 2]) * strLen + ORD(s[upb - 1]);
        (* in this case the encoding is relative to location 0 *)
        IF (pos >= 0) & (pos <= upb) & (s[pos] = 0X) THEN
          res := pos
        END
      END
    END
  END;
  RETURN res
END eos;





END bdStrings.
