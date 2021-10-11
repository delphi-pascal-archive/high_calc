unit RegUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CodeConst, DecodeUnit;

type
//  TRegCod=array[0..15] of byte;
  TRegForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Shape1: TShape;
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure EditChange(const CurrentEdit:TEdit;NextControl:TWinControl);
    procedure SaveRegCod(var RegCod:TRegCod);
    procedure StrToArr(const s:string;var b:byte);

  end;

const
  RegCodInput:boolean=false;

var
  RegForm: TRegForm;
//  RegCod:TRegCod;

procedure InputRegCod;
function IsRefCod(rc:string):boolean;
implementation

{$R *.dfm}
function IsRefCod(rc:string):boolean;
begin
  Result:=false;
  if Length(rc)=19 then begin
    if (rc[5]='-') and (rc[10]='-') and (rc[15]='-') then begin
      RegForm.Edit3.Text:=UpperCase(Copy(rc,1,4));
      RegForm.Edit4.Text:=UpperCase(Copy(rc,6,4));
      RegForm.Edit5.Text:=UpperCase(Copy(rc,11,4));
      RegForm.Edit6.Text:=UpperCase(Copy(rc,16,4));
      Result:=true;
    end;
  end;
end;
procedure InputRegCod;
var
  a:array[0..128] of byte;
  r:boolean;
begin
  InitSignatura;
  RegForm:=TRegForm.Create(nil);
  try
    r:=RegForm.ShowModal=mrYes;
    RegForm.SaveRegCod(RegCod);
  finally
    RegForm.Free;
  end;
  RegCodInput:=r;
end;


procedure TRegForm.Edit3Change(Sender: TObject);
begin
  EditChange(Edit3,Edit4);
end;

procedure TRegForm.EditChange(const CurrentEdit:TEdit;NextControl:TWinControl);
begin
  if IsRefCod(CurrentEdit.Text) then
    exit;
  CurrentEdit.Text:=UpperCase(Copy(CurrentEdit.Text,1,4));
  if Length(CurrentEdit.Text)=4 then
    ActiveControl:=NextControl
end;

procedure TRegForm.Edit4Change(Sender: TObject);
begin
  EditChange(Edit4,Edit5);
end;

procedure TRegForm.Edit5Change(Sender: TObject);
begin
  EditChange(Edit5,Edit6);
end;

procedure TRegForm.Edit6Change(Sender: TObject);
begin
  EditChange(Edit6,BitBtn1);
end;

procedure TRegForm.SaveRegCod(var RegCod: TRegCod);
var
  buf:array[0..15] of byte;
  i,n:integer;
begin
  Sleep(200);
  StrToArr(Edit3.Text,Buf[0]);
  StrToArr(Edit4.Text,Buf[4]);
  StrToArr(Edit5.Text,Buf[8]);
  StrToArr(Edit6.Text,Buf[12]);
  for i:=0 to 15 do
    RegCod[i]:=Buf[i] xor Signatura[i];
end;

procedure TRegForm.StrToArr(const s: string; var b: byte);
var
  i,n:integer;
begin
  n:=Length(s)-1;
  for i:=0 to n do
    PByte(integer(@b)+i)^:=Conv32ToByte(s[i+1]);
end;

procedure TRegForm.FormCreate(Sender: TObject);
begin
{  Edit3.Text:='QKC4';
  Edit4.Text:='5MTC';
  Edit5.Text:='45IL';
  Edit6.Text:='SUTL';}
end;

end.
