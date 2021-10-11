unit DecodeUnit;

interface
uses
  CodeConst,SysUtils;


function Conv32ToByte(c: char): byte;
procedure StrRegCodToByteReg;
procedure ArrayToByte(var b: byte; const ByteIndexs: TByteIndexs);
procedure StrToArr(const s: string; var b: byte);

implementation

procedure StrRegCodToByteReg;
var
  i,n:integer;
begin
  n := 16;
  for i:=1 to n do
    RegCod[i-1]:=Conv32ToByte(StrRegCod[i]);
end;

procedure DecodeRegCodToByteReg;
var
  i,n:integer;
begin
  n := 16;
  for i:=1 to n do
    RegCod[i-1]:=RegCod[i-1]  xor Signatura[i];
end;

function Conv32ToByte(c: char): byte;
begin
  if (c>='0')and(c<='9') then
    result:=StrToInt(c)
  else if (c>='A')and(c<='V') then
    result:=byte(c)-byte('A')+10
  else
    result:=0;
end;

procedure ArrayToByte(var b: byte; const ByteIndexs: TByteIndexs);
var
  i:integer;
  m:byte;
begin
  b:=0;
  for i:=0 to 7 do begin
    m:=1 shl (ByteIndexs[i].BitCod-1);
    b:=b or (((RegCod[ByteIndexs[i].ByteCod-1] and m) shr (ByteIndexs[i].BitCod-1)) shl i)
  end;
end;

procedure StrToArr(const s: string; var b: byte);
var
  i,n:integer;
begin
  n:=Length(s)-1;
  for i:=0 to n do
    PByte(integer(@b)+i)^:=Conv32ToByte(s[i+1]);
end;

end.
