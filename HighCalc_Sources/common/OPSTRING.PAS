unit OpString;

interface
Uses SysUtils;
Type
  CharSet = set of Char;


Function JustExtension(const Nm : String):String;

Function HexB(B : Byte):String;

Function BinaryB(B : Byte):String;

function WordPosition(N : Byte; S : string; WordDelims : CharSet) : Byte;
    {-Given a set of word delimiters, return start position of N'th word in S}

function Detab(S : string; TabSize : Byte) : string;
  {-Expand tabs in a string to blanks on spacing TabSize}

function WordCount(S : string; WordDelims : CharSet) : Byte;
  {-Given a set of word delimiters, return number of words in S}

Function StUpCase(S : String):String;

Function Long2Str(const L : LongInt):String;

Function Real2Str(const E : Extended; w,d : Integer):String;

Function Str2Real(const S : String; var E : Extended):Boolean;

Function Str2Long(const S : String; var E : LongInt):Boolean;

Function ExtractWord(N : Byte; S : string; WordDelims : CharSet) : string;
  {-Given a set of word delimiters, return the N'th word in S}

function PadCh(S : string; Ch : Char; Len : Byte) : string;
  {-Return a string right-padded to length len with ch}

function Pad(S : string; Len : Byte) : string;
  {-Return a string right-padded to length len with blanks}

function LeftPadCh(S : string; Ch : Char; Len : Byte) : string;
  {-Return a string left-padded to length len with ch}

function LeftPad(S : string; Len : Byte) : string;
  {-Return a string left-padded to length len with blanks}

Function HexL(const I : LongInt):String;

Function JustFileName(S : String):String;

{ Trim trims leading and trailing spaces and control characters from the
  given string. }

function Trim(const S: string): string;

{ TrimLeft trims leading spaces and control characters from the given
  string. }

function TrimLeft(const S: string): string;

{ TrimRight trims trailing spaces and control characters from the given
  string. }

function TrimRight(const S: string): string;


implementation

Const Bits : Array [0..7] of Byte =
(1,2,4,8,16,32,64,128);

Function BinaryB(B : Byte):String;
var I : Byte;
begin
 Result:='';
 For I:=0 to 7 do
  If (Bits[I] and B)=0 then
   Result:='0'+Result else
   Result:='1'+Result;
end;

Function HexL(const I : LongInt):String;
begin Result:=IntToHex(I,4); end;

Function JustExtension(const Nm : String):String;
begin Result:=ExtractFileExt(Nm); end;

Function JustFileName(S : String):String;
begin Result:=ExtractFileName(S); end;

function Trim(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  if I > L then Result := '' else
  begin
    while S[L] <= ' ' do Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;

function TrimLeft(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  Result := Copy(S, I, Maxint);
end;

function TrimRight(const S: string): string;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] <= ' ') do Dec(I);
  Result := Copy(S, 1, I);
end;

  function PadCh(S : string; Ch : Char; Len : Byte) : string;
    {-Return a string right-padded to length len with ch}
  {var
    o : string;}
{$Ifndef WIN32}
    SLen : Byte absolute S;
{$Endif}
  begin
    if Length(S) >= Len then
      PadCh := S
    else begin
{$Ifndef WIN32}
      o[0] := Chr(Len);
      Move(S[1], o[1], SLen);
      if SLen < 255 then
        FillChar(o[Succ(SLen)], Len-SLen, Ch);
      PadCh := o;
{$Else}
      Result:=S+StringOfChar(Ch,Len-Length(S));
{$Endif}
    end;
  end;

  function Pad(S : string; Len : Byte) : string;
    {-Return a string right-padded to length len with blanks}
  begin
    Pad := PadCh(S, ' ', Len);
  end;

  function LeftPadCh(S : string; Ch : Char; Len : Byte) : string;
    {-Return a string left-padded to length len with ch}
  {var
    o : string;}
{$Ifndef WIN32}
    SLen : Byte absolute S;
{$Endif}
  begin
{$Ifndef WIN32}
    if Length(S) >= Len then
      LeftPadCh := S
    else if SLen < 255 then begin
      o[0] := Chr(Len);
      Move(S[1], o[Succ(Word(Len))-SLen], SLen);
      FillChar(o[1], Len-SLen, Ch);
      LeftPadCh := o;
    end;
{$Else}
   If Length(S)>=Len then
    Result:=S else
    Result:=StringOfChar(Ch,Len-Length(S))+S;
{$Endif}
  end;

  function LeftPad(S : string; Len : Byte) : string;
    {-Return a string left-padded to length len with blanks}
  begin
    LeftPad := LeftPadCh(S, ' ', Len);
  end;
  function WordPosition(N : Byte; S : string; WordDelims : CharSet) : Byte;
    {-Given a set of word delimiters, return start position of N'th word in S}
  var
    I, Count : Byte;
{$Ifndef WIN32}
    SLen : Byte absolute S;
{$Else}
    SLen : Integer;
{$Endif}
  begin
    Count := 0;
    I := 1;
    WordPosition := 0;
{$Ifdef WIN32}
    SLen:=Length(S);
{$Endif}
    while (I <= SLen) and (Count <> N) do begin
      {skip over delimiters}
      while (I <= SLen) and (S[I] in WordDelims) do
        Inc(I);

      {if we're not beyond end of S, we're at the start of a word}
      if I <= SLen then
        Inc(Count);

      {if not finished, find the end of the current word}
      if Count <> N then
        while (I <= SLen) and not(S[I] in WordDelims) do
          Inc(I)
      else
        WordPosition := I;
    end;
  end;


  function ExtractWord(N : Byte; S : string; WordDelims : CharSet) : string;
    {-Given a set of word delimiters, return the N'th word in S}
{$Ifndef WIN32}
  var
    I, Len : Byte;
    SLen : Byte absolute S;
{$Else}
  var I,Len : Integer;
{$Endif}
  begin
{$Ifndef WIN32}
    Len := 0;
    I := WordPosition(N, S, WordDelims);
    if I <> 0 then
      {find the end of the current word}
      while (I <= SLen) and not(S[I] in WordDelims) do begin
        {add the I'th character to result}
        Inc(Len);
        ExtractWord[Len] := S[I];
        Inc(I);
      end;
    ExtractWord[0] := Char(Len);
{$else}
    Len := 0;
    I := WordPosition(N, S, WordDelims);
    if I <> 0 then begin
      {find the end of the current word}
      while (I <= Length(S)) and not(S[I] in WordDelims) do begin
        Inc(Len); Inc(I);
      end;
     Result:=Copy(S,I-Len,Len);
    end else
    Result:='';
{$Endif}
  end;

Function Str2Real(const S : String; var E : Extended):Boolean;
begin Result:=True;
 try E:=StrToFloat(S);
 except on EConvertError do Result:=False;
 end;
end;

Function Str2Long(const S : String; var E : LongInt):Boolean;
begin Result:=True;
 try E:=StrToInt(S);
 except on EConvertError do Result:=False;
 end;
end;

Function Real2Str(const E : Extended; w,d : Integer):String;
begin Result:=FloatToStrF(E,ffFixed,w,d); end;

Function Long2Str(const L : LongInt):String;
begin Result:=IntToStr(L); end;

Function StUpCase(S : String):String;
begin Result:=UpperCase(S); end;

  function WordCount(S : string; WordDelims : CharSet) : Byte;
    {-Given a set of word delimiters, return number of words in S}
  var
    I, Count : Byte;
{$Ifndef WIN32}
    SLen : Byte absolute S;
{$Else}
    SLen : Integer;
{$Endif}
  begin
    Count := 0;
    I := 1;
{$Ifdef WIN32}
    SLen:=Length(S);
{$Endif}
    while I <= SLen do begin
      {skip over delimiters}
      while (I <= SLen) and (S[I] in WordDelims) do
        Inc(I);

      {if we're not beyond end of S, we're at the start of a word}
      if I <= SLen then
        Inc(Count);

      {find the end of the current word}
      while (I <= SLen) and not(S[I] in WordDelims) do
        Inc(I);
    end;

    WordCount := Count;
  end;

function Detab(S : string; TabSize : Byte) : string;
  {-Expand tabs in a string to blanks on spacing TabSize}
var R : String; I : Integer;
begin R:='';
 For I:=1 to Length(S) do
  If S[I]=#9 then R:=R+LeftPad('',TabSize) else R:=R+S[I];
 Result:=R;
end;

Function HexB(B : Byte):String;
begin
 Result:=IntToHex(B,2);
end;


end.
