unit MandlbrUn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, PaintBoxWithRubberShape,Math,
  ComCtrls;

type
  TMandelbrForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    AEdit: TEdit;
    BEdit: TEdit;
    Label2: TLabel;
    SEdit: TEdit;
    Label3: TLabel;
    PaintBoxWithRubberShape1: TPaintBoxWithRubberShape;
    SpeedButton1: TSpeedButton;
    ProgressBar1: TProgressBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PaintBoxWithRubberShape1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PaintBoxWithRubberShape1RubberChange(Sender: TObject;
      var Rect: TRect);
    procedure SpeedButton1Click(Sender: TObject);
  private
    Bitmap:TBitmap;
    x,y:integer;
    procedure Seta(const Value: double);
    procedure Setb(const Value: double);
    procedure Sets(const Value: double);
    function GetA: double;
    function GetB: double;
    function GetS: double;
    { Private declarations }
  public
    { Public declarations }
    property a:double read GetA write Seta;
    property b:double read GetB write Setb;
    property s:double read GetS write Sets;
    procedure DrawMandelbrot;
    function GetColor(x,y:double):TColor;
  end;

var
  MandelbrForm: TMandelbrForm;
procedure DrawMondelbrot(const a,b,s:double);
implementation

uses Types;

{$R *.dfm}

procedure DrawMondelbrot(const a,b,s:double);
begin
  MandelbrForm:=TMandelbrForm.Create(nil);
  MandelbrForm.a:=a;
  MandelbrForm.b:=b;
  MandelbrForm.s:=s;
  MandelbrForm.Show;
end;

{ TMandelbrForm }

procedure TMandelbrForm.DrawMandelbrot;
var
  a,b,s,ds,b1:double;
  i,j,n:integer;
begin
  ProgressBar1.Position:=0;
  a:=Self.a;
  b:=Self.b;
  s:=Self.s;
  with Bitmap do
    n:=Min(Width,Height);
  ds:=s/n;
  b1:=b;
  ProgressBar1.Max:=n;
  ProgressBar1.Step:=1;
  for i:=1 to n do begin
    b:=b1;
    for j:=1 to n do begin
     // PaintBoxWithRubberShape1.Canvas.Pixels[i+x,j+y]:=GetColor(a,b);
      Bitmap.Canvas.Pixels[i-1,n-j]:=GetColor(a,b);
      b:=b+ds;
    end;
    a:=a+ds;
    ProgressBar1.StepIt;
    Application.ProcessMessages;
  end;
  ProgressBar1.Position:=0;
end;

function TMandelbrForm.GetA: double;
begin
  Result:=StrToFloat(AEdit.Text);
end;

function TMandelbrForm.GetB: double;
begin
  Result:=StrToFloat(BEdit.Text);
end;

function TMandelbrForm.GetColor(x, y: double): TColor;
var
  xs,ys,xx:double;
  n,i,r:integer;
begin
  n:=100;
  xs:=x;
  ys:=y;
  r:=n;
  for i:=0 to n do begin
    xx:=xs*xs-ys*ys+x;
    ys:=2*xs*ys+y;
    xs:=xx;
    if xs*xs + ys*ys >4 then begin
      r:=i;
      break;
    end;
  end;
  if r=100 then
    Result:=0
  else
    Result:=round(r*2.5+((n-r)*2.5)*256);
  //todo: Задать цвет точки
end;

function TMandelbrForm.GetS: double;
begin
  Result:=StrToFloat(SEdit.Text);
end;

procedure TMandelbrForm.Seta(const Value: double);
begin
  AEdit.Text := FloatToStr(Value);
end;

procedure TMandelbrForm.Setb(const Value: double);
begin
  BEdit.Text := FloatToStr(Value);
end;

procedure TMandelbrForm.Sets(const Value: double);
begin
  SEdit.Text := FloatToStr(Value);
end;

procedure TMandelbrForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TMandelbrForm.PaintBoxWithRubberShape1Paint(Sender: TObject);
begin
  //DrawMandelbrot;
  x:=(PaintBoxWithRubberShape1.Width-Bitmap.Width) div 2;
  y:=(PaintBoxWithRubberShape1.Height-Bitmap.Height) div 2;
  PaintBoxWithRubberShape1.Canvas.Draw(x,y,Bitmap);
end;

procedure TMandelbrForm.FormCreate(Sender: TObject);
begin
  Bitmap:=TBitmap.Create;
end;

procedure TMandelbrForm.FormDestroy(Sender: TObject);
begin
  Bitmap.Free;
end;

procedure TMandelbrForm.FormResize(Sender: TObject);
begin
  Bitmap.Width:=Min(PaintBoxWithRubberShape1.Width,PaintBoxWithRubberShape1.Height);
  Bitmap.Height:=Bitmap.Width;
  DrawMandelbrot;
  PaintBoxWithRubberShape1.Invalidate;
end;

procedure TMandelbrForm.PaintBoxWithRubberShape1RubberChange(
  Sender: TObject; var Rect: TRect);
var
  k:double;
  si:integer;
begin
  with Rect do begin
    Top:=Bitmap.Height-Top+y;
    Bottom:=Bitmap.Height-Bottom+y;
  end;
  with Rect do
    si:=Max(Abs(Left-Right),Abs(Top-Bottom));
  k:=Self.s/Bitmap.Width;
  s:=si*k;
  with Rect do
    a:=(Min(Left,Right)-x)*k+a;
  with Rect do
    b:=Min(Top,Bottom)*k+b;
  DrawMandelbrot;
  PaintBoxWithRubberShape1.Invalidate;
end;

procedure TMandelbrForm.SpeedButton1Click(Sender: TObject);
begin
  DrawMandelbrot;
  PaintBoxWithRubberShape1.Invalidate;
end;

end.
