unit CodeConst;

interface
uses
  SysUtils, Registry, Windows,Forms;
type

  TRegCod=array[0..15] of byte;

  TByteIndex=record
    ByteCod:byte;
    BitCod:byte;
  end;

  TByteIndexs=array[0..7] of TByteIndex;
  TSignatura=array[0..15] of byte;

const
  ByteIndexs1:TByteIndexs=((ByteCod:1;BitCod:1),(ByteCod:2;BitCod:2),(ByteCod:3;BitCod:3),(ByteCod:4;BitCod:4),
    (ByteCod:5;BitCod:5),(ByteCod:6;BitCod:1),(ByteCod:7;BitCod:2),(ByteCod:8;BitCod:3));

  ByteIndexs2:TByteIndexs=((ByteCod:1;BitCod:2),(ByteCod:2;BitCod:3),(ByteCod:3;BitCod:4),(ByteCod:4;BitCod:5),
    (ByteCod:5;BitCod:2),(ByteCod:6;BitCod:3),(ByteCod:7;BitCod:4),(ByteCod:8;BitCod:5));

  ByteIndexs3:TByteIndexs=((ByteCod:1;BitCod:3),(ByteCod:2;BitCod:4),(ByteCod:3;BitCod:5),(ByteCod:9;BitCod:1),
    (ByteCod:10;BitCod:2),(ByteCod:11;BitCod:3),(ByteCod:12;BitCod:4),(ByteCod:13;BitCod:5));

  Signatura:TSignatura=(123,32,43,234,98,212,232,176,32,165,87,145,21,65,178,245);

  FirstByte=132;
  GrumbShow:byte=231;

  FirstDateSignatura:string='asdfgqwertzxcvbnmjuiolksdflk;jerwq[pisdfalkjgsdf';
  FirstDateSignaturaCode:string='65654asdfgqwe654456rtzxcvbnmjuiolksdflk;jerwq[pisdfalkjgsdf';
  BadCodes:array[0..1]of TRegCod =((0,0,4,0,0,0,0,4,6,7,3,2,9,0,2,3),
    (0,0,4,0,0,0,0,4,1,1,2,9,0,2,1,3));
var
  RegCod:TRegCod;
  StrRegCod:string[16];
procedure InitSignatura;
function GetDate: string;
procedure SetRegestryFocus;
function GetRestDays:integer;
implementation
procedure InitSignatura;
var
  i:integer;
begin
  for i:=0 to 15 do
    Signatura[i]:=Random(255);
end;

function GetDate: string;
begin
  result:=DateTimeToStr(Now());
end;

procedure SetRegestryFocus;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Control Panel\Desktop',False) then
      if not Reg.ReadInteger('ForegroundLockTimeout')=0 then
        Reg.WriteInteger('ForegroundLockTimeout',0);
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

function GetRestDays:integer;
var
  i,n:integer;
  a:string;
begin
  Result:=-1;
  n:=Length(FirstDateSignatura);
  for i:=1 to n do
    a:=a + char((byte(FirstDateSignatura[i])xor byte(FirstDateSignaturaCode[i])));
  try
    result:=30-Round(StrToDateTime(GetDate)-StrToDateTime(Trim(a)));
  except
    exit;
  end;
  if Result>30 then
    Result:=-1;
end;

end.
