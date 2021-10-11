unit GrumbUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellApi;

const
  ProductId='67884';
//  ProgName='Mathemathical Calculator';
  HiperLink1='http://www.regsoft.net/purchase.php3?productid='+ProductId;
  HiperLink2='http://www.regsoft.net/purchase_nonsecure.php3?productid='+ProductId;
type
  TGrumblingForm = class(TForm)
    RunButton: TButton;
    BuyLabel: TLabel;
    BuyButton: TButton;
    Timer1: TTimer;
    ExitButton: TButton;
    DateLabel: TLabel;
    RegButton: TButton;
    DaysLabel: TLabel;
    WinCalcLabel: TLabel;
    Purchasing1: TLabel;
    Purchasing2: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RegButtonClick(Sender: TObject);
    procedure BuyButtonClick(Sender: TObject);
    procedure WinCalcLabelClick(Sender: TObject);
    procedure Purchasing1Click(Sender: TObject);
    procedure Purchasing2Click(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure Purchasing1MouseEnter(Sender: TObject);
    procedure Purchasing1MouseLeave(Sender: TObject);
  private
    { Private declarations }
    a:integer;
    c:byte;
  public
    { Public declarations }
  end;
const
  RunButtonVisible:boolean=false;
var
  GrumblingForm: TGrumblingForm;
function ShowGrumblingForm:boolean;
implementation
uses
  CodeConst,RegUnit, main;
{$R *.dfm}
function ShowGrumblingForm:boolean;
begin
  if GetRestDays<0 then
    RunButtonVisible:=false;
  GrumblingForm:=TGrumblingForm.Create(nil);
  try
    GrumblingForm.RunButton.Visible:=RunButtonVisible;
//    GrumblingForm.RunButton.Visible:=true;
    GrumblingForm.DaysLabel.Visible:=RunButtonVisible;
    result:=GrumblingForm.ShowModal=mrOk;
  finally
    GrumblingForm.Free;
  end;
end;

procedure TGrumblingForm.Timer1Timer(Sender: TObject);
var
  r,g,b:byte;
begin
  dec(a);
  DateLabel.Caption:=IntToStr(a);
  if a<0 then begin
    a:=-1;
    DateLabel.Visible:=false;
  end;
  inc(c,10);
  r:=c;
  g:=255-c;
  b:=(c div 2) + 120;
  BuyLabel.Color:=r+(g+b*256)*256;
  BuyLabel.Font.Color:=255-r+(255-g+(255-b)*256)*256;
  RunButton.Enabled:=a<0;
  if RegCodInput then
    MainCalcForm.TestRegCod;
end;

procedure TGrumblingForm.FormCreate(Sender: TObject);
begin
  a:=50;
//  a:=0;
  c:=0;
  try
    DaysLabel.Caption:=IntToStr(GetRestDays)+' Days left.';
  except
  end;  
  //DateLabel.Caption:=FirstDateSignatura;
end;

procedure TGrumblingForm.RegButtonClick(Sender: TObject);
begin
  InputRegCod;
end;

procedure TGrumblingForm.BuyButtonClick(Sender: TObject);
begin
  ShellExecute(handle,'open',HiperLink1,nil,nil,SW_SHOW);
end;

procedure TGrumblingForm.WinCalcLabelClick(Sender: TObject);
begin
  ShellExecute(handle,'open','http://www.wincalc.com',nil,nil,SW_SHOW);
end;

procedure TGrumblingForm.Purchasing1Click(Sender: TObject);
begin
  ShellExecute(handle,'open',HiperLink1,nil,nil,SW_SHOW);
end;

procedure TGrumblingForm.Purchasing2Click(Sender: TObject);
begin
  ShellExecute(handle,'open',HiperLink2,nil,nil,SW_SHOW);
end;

procedure TGrumblingForm.ExitButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TGrumblingForm.Purchasing1MouseEnter(Sender: TObject);
begin
  if Sender is TLabel then begin
    with (Sender as TLabel) do begin
      Font.Color:=clYellow;
      Transparent:=False;
      Color:=clGreen;
    end;
  end;

end;

procedure TGrumblingForm.Purchasing1MouseLeave(Sender: TObject);
begin
  if Sender is TLabel then
    with (Sender as TLabel) do begin
      Font.Color:=clBlue;
      Transparent:=True;
      Color:=clWhite;
    end;
end;

end.
