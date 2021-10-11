unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,CodeConst;

type


  
  TForm1 = class(TForm)
    Button1: TButton;
    RegCodEdit: TEdit;
    Byte1Edit: TEdit;
    Byte2Edit: TEdit;
    Byte3Edit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit5: TEdit;
    Label5: TLabel;
    Edit6: TEdit;
    Label6: TLabel;
    Byte1Edit1: TEdit;
    Byte2Edit1: TEdit;
    Byte3Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    RegCodeMemo: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    function DivideStrBy4Symbols(s: string): string;
    { Private declarations }
  public
    { Public declarations }
    b1,b2,b3:byte;
    procedure WriteByte(const b:byte; const ByteIndexs:TByteIndexs);
    procedure ByteToArray(const b1:byte;const ByteIndexs:TByteIndexs);
    procedure CreateStrRegCod;
    function CreateFullStrRegCod:string;
  end;



var
  Form1: TForm1;


implementation

{$R *.dfm}
uses
  DecodeUnit;


function ConvByteTo32(c: byte): char;
begin
  if (c<=9) then
    result:=IntToStr(c)[1]
  else if (c<32) then
    result:=Char(c+byte('A')-10)
  else
    Raise Exception.Create('Невернный байт');
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  i,n:integer;
  m,b:byte;
begin
  b1:=StrToInt(Byte1Edit.Text);
  b2:=StrToInt(Byte2Edit.Text);
  b3:=StrToInt(Byte3Edit.Text);
  n:=15;
  for i:=0 to n do
    RegCod[i]:=Random(31);
  ByteToArray(b1,ByteIndexs1);
  ByteToArray(b2,ByteIndexs2);
  ByteToArray(b3,ByteIndexs3);
  CreateStrRegCod;
  RegCodEdit.Text:=DivideStrBy4Symbols(StrRegCod);
  StrRegCodToByteReg;
  ArrayToByte(b1,ByteIndexs1);
  ArrayToByte(b2,ByteIndexs2);
  ArrayToByte(b3,ByteIndexs3);
  Byte1Edit1.Text:=IntToStr(b1);
  Byte2Edit1.Text:=IntToStr(b2);
  Byte3Edit1.Text:=IntToStr(b3);
end;

procedure TForm1.ByteToArray(const b1: byte; const ByteIndexs: TByteIndexs);
var
  i:integer;
  b,m:byte;
begin
  for i:=0 to 7 do begin
    m:=1 shl i;
    b:=((m and b1)shr i);
    b:=b shl (ByteIndexs[i].BitCod-1);
    m:=1 shl (ByteIndexs[i].BitCod-1);
    RegCod[ByteIndexs[i].ByteCod-1]:=(RegCod[ByteIndexs1[i].ByteCod-1] and not m) or b;
  end;
end;

procedure TForm1.CreateStrRegCod;
var
  i,n:integer;
begin
  n := 16;
  SetLength(StrRegCod,n);
  for i:=1 to n do
    StrRegCod[i]:=ConvByteTo32(RegCod[i-1]);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;
end;

procedure TForm1.WriteByte(const b: byte; const ByteIndexs: TByteIndexs);
var
  i:integer;
  m,bt:byte;
begin
  for i:=0 to 7 do begin
    m:=1 shl i;
    bt:=(b and m) shr i;
    bt:=bt shl (ByteIndexs[i].BitCod-1);
    m:=not(1 shl (ByteIndexs[i].BitCod-1));
    RegCod[ByteIndexs[i].ByteCod]:=(RegCod[ByteIndexs[i].ByteCod] and m) or bt;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  StrRegCod:=RegCodEdit.Text;
  StrRegCodToByteReg;
  ArrayToByte(b1,ByteIndexs1);
  ArrayToByte(b2,ByteIndexs2);
  ArrayToByte(b3,ByteIndexs3);
  Byte1Edit1.Text:=IntToStr(b1);
  Byte2Edit1.Text:=IntToStr(b2);
  Byte3Edit1.Text:=IntToStr(b3);
end;

function TForm1.DivideStrBy4Symbols(s: string): string;
var
  i,n:integer;
begin
  Result:='';
  n:=Length(s);
  for i:=1 to n do begin
    Result:=Result+s[i];
    if (i and 3)=0 then
      Result:=Result+'-';
  end;
  if Result[Length(Result)]='-' then
    Result[Length(Result)]:=' ';
  Result:=Trim(Result);
end;


procedure TForm1.Button3Click(Sender: TObject);
var
  i,n:integer;
begin
  RegCodeMemo.Clear;
  n:=2000;
  for i:=1 to n do begin
    RegCodeMemo.Lines.Add(CreateFullStrRegCod);
  end;
end;

function TForm1.CreateFullStrRegCod: string;
var
  i,n:integer;
  m,b:byte;
begin
  b1:=StrToInt(Byte1Edit.Text);
  b2:=StrToInt(Byte2Edit.Text);
  b3:=StrToInt(Byte3Edit.Text);
  n:=15;
  for i:=0 to n do
    RegCod[i]:=Random(31);
  ByteToArray(b1,ByteIndexs1);
  ByteToArray(b2,ByteIndexs2);
  ByteToArray(b3,ByteIndexs3);
  CreateStrRegCod;
  result:=DivideStrBy4Symbols(StrRegCod);
end;

end.
