unit PlotUn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, mathimge,Formula,Math, StdCtrls;
const
  RotInc=0.5;
  ZoomInc=0.005;
type
  TPlotForm = class(TForm)
    PlotMathIm: TMathImage;
    Panel3D: TPanel;
    Label1: TLabel;
    UpButton: TButton;
    LeftButton: TButton;
    RightButton: TButton;
    DownButton: TButton;
    Label2: TLabel;
    InButton: TButton;
    OutButton: TButton;
    FillCheck: TCheckBox;
    WareColorPanel: TPanel;
    FillColorPanel: TPanel;
    ColorDialog1: TColorDialog;
    RedrawButton: TButton;
    Aspectcheck: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure UpButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UpButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DownButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DownButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlotMathImRotating(Sender: TObject);
    procedure LeftButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RightButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure InButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure InButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlotMathImZooming(Sender: TObject);
    procedure PlotMathImZoomStop(Sender: TObject);
    procedure OutButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FillColorPanelClick(Sender: TObject);
    procedure RedrawButtonClick(Sender: TObject);
  private
    { Private declarations }
    FormulaExecute:TFormulaExecute;
    Stack:TFormulaExecute;
    VarCod,XCod,YCod: integer;
    LowerBound, UpperBound: Extended;
    Func:string;
    BufY:array of double;
    MinX,MaxX,MinY,MaxY,MinZ,MaxZ:Extended;
    Surface:TSurface;
    Type3D:boolean;
    procedure CalcMinMax;
    procedure CalcMinMax3D;
    function CalcFunc(x:Extended):Extended;overload;
    function CalcFunc:Extended;overload;
  public
    { Public declarations }
    procedure SetBounds(const MinX,MinY,MaxX,MaxY:Extended);
    procedure Plot(const Stack:TFormulaExecute;const Func:string;
      const VarCod:integer; const LowerBound, UpperBound:Extended);overload;
    procedure Plot;overload;
    procedure Plot3D(const Stack:TFormulaExecute;const Func:string;
      const XCod,YCod:integer; const MinX,MaxX,MinY,MaxY:Extended);overload;
    procedure Plot3D;overload;
    procedure PlotFromBuf;
    procedure Plot3DFromBuf;
  end;

var
  PlotForm: TPlotForm;

implementation

{$R *.dfm}

{ TPlotForm }

procedure TPlotForm.Plot(const Stack: TFormulaExecute; const Func: string;
  const VarCod: integer; const LowerBound, UpperBound: Extended);
begin
//  PlotMathIm.Clear;

  Self.Stack:=Stack;
  Self.Func:=Func;
  Self.VarCod:=VarCod;
  Self.LowerBound:=Min(LowerBound,UpperBound);
  Self.UpperBound:=Max(LowerBound,UpperBound);
  Plot;
end;

procedure TPlotForm.CalcMinMax;
var
  i,n:integer;
  dx,x,y:Extended;
begin
  MinY:=1E4000;
  MaxY:=-MinY;
  n:=Length(BufY);
  dx:=(UpperBound-LowerBound)/n;
  dec(n);
  x:=LowerBound;
  for i:=0 to n do begin
    y:=CalcFunc(x);
    BufY[i]:=y;
    if MinY>y then
      MinY:=y
    else if MaxY<y then
      MaxY:=y;
    x:=x+dx;
  end;
end;

procedure TPlotForm.Plot;
begin
  SetLength (BufY,PlotMathIm.Width);
  FormulaExecute:=TFormulaExecute.Create;
  try
    CalcMinMax;
    SetBounds(LowerBound,MinY,UpperBound,MaxY);
    PlotFromBuf;
    Type3D:=false;
//    Stack.SetVariable(VarCod,FloatToStr(MinX));
//    Stack.ExtendedX:=FormulaExecute.Execute(Func);
  finally
    FormulaExecute.Free;
  end;
end;

procedure TPlotForm.SetBounds(const MinX, MinY, MaxX, MaxY: Extended);
begin
  PlotMathIm.SetWorld(MinX, MinY, MaxX, MaxY);
end;

function TPlotForm.CalcFunc(x: Extended): Extended;
begin
  Stack.SetVariable(VarCod,FloatToStr(x));
  Result:=FormulaExecute.Execute(Func);
end;

procedure TPlotForm.PlotFromBuf;
var
  i,n:integer;
  dx,x,y:Extended;
  axiscolor:TColor;
begin
  n:=Length(BufY);
  if n=0 then
    exit;
  axiscolor:=clRed;
  PlotMathIm.drawaxes('','',True,axiscolor,axiscolor);
  dx:=(UpperBound-LowerBound)/n;
  dec(n);
  x:=LowerBound;
  y:=BufY[0];
  PlotMathIm.MoveToPoint(x,y);
  for i:=1 to n do begin
    x:=x+dx;
    PlotMathIm.DrawLineTo(x,BufY[i]);
  end;
end;

procedure TPlotForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TPlotForm.FormResize(Sender: TObject);
begin
  PlotMathIm.Clear;
  if Type3D then
    Plot3DFromBuf
  else
    PlotFromBuf;
end;

procedure TPlotForm.Plot3D(const Stack: TFormulaExecute;
  const Func: string; const XCod, YCod: integer; const MinX, MaxX, MinY,
  MaxY: Extended);
begin
  Self.Stack:=Stack;
  Self.Func:=Func;
  Self.XCod:=XCod;
  Self.YCod:=YCod;

  Self.MinX:=Min(MinX, MaxX);
  Self.MaxX:=Max(MinX, MaxX);
  Self.MinY:=Min(MinY, MaxY);
  Self.MaxY:=Max(MinY, MaxY);
  Plot3D;
end;

procedure TPlotForm.Plot3D;
begin
  FormulaExecute:=TFormulaExecute.Create;
  try
    CalcMinMax3D;
    Plot3DFromBuf;
    Type3D:=true;
  finally
    FormulaExecute.Free;
  end;
end;

procedure TPlotForm.CalcMinMax3D;
var
  i,j,n,m:integer;
  dx,dy,x,y,z:Extended;
begin
  MinZ:=1E4000;
  MaxZ:=-MinZ;
  n:=60;
  m:=60;
  try
    Surface:=TSurface.create(n, m);
  except
    on E:ESurfaceError do
    begin
      MessageDlg(E.message,mtError,[mbOk],0);
      exit;
    end;
  end;
  dx:=(MaxX-MinX)/n;
  dy:=(MaxY-MinY)/m;
  x:=MinX;
  for i:=0 to n do begin
    y:=MinY;
    Stack.SetVariable(XCod,FloatToStr(x));
    for j:=0 to m do begin
      Stack.SetVariable(YCod,FloatToStr(y));
      z:=CalcFunc;
      if MinZ>Z then
        MinZ:=Z
      else if MaxZ<Z then
        MaxZ:=Z;
      Surface.Make(i,j,x,y,z);
      y:=y+dy;
    end;
    x:=x+dx;
  end;
end;

{procedure TPlotForm.MakeGraphSurface(const n, m :integer);
var i,j:integer; x,y,z:extended;
begin
  for i:=0 to xmesh do
  begin
    x:=gxmin+i*(gxmax-gxmin)/xmesh;
    for j:=0 to ymesh do
    with GraphSurface do
    begin
      y:=gymin+j*(gymax-gymin)/ymesh;
      graph(x,y,z);
      make(i,j,x,y,z);
    end;
  end;
end;
}
function TPlotForm.CalcFunc: Extended;
begin
  Result:=FormulaExecute.Execute(Func);
end;

procedure TPlotForm.Plot3DFromBuf;
begin
  screen.cursor:=crhourglass;
//    currenttype:=2;
  with PlotMathIm do
  begin
    d3setworld(MinX,MinY,MinZ,MaxX,MaxY,MaxZ);
//    d3aspectratio:=true;//aspectcheck.checked;
    d3aspectratio:=Aspectcheck.Checked;
    clear;
    d3drawworldbox;
    d3drawaxes('x','y','z');
    pen.color:=WareColorPanel.Color;//wirecolor;
    brush.color:=FillColorPanel.Color;//fillcolor;
    brush.style:=bssolid;
    Try
      d3drawsurface(Surface,FillCheck.Checked,true);
    except
      on E:ESurfaceError do
      messagedlg(E.message,mtError,[mbOk],0);
    end;
    restorebrush;
    restorepen;
  end;
  screen.cursor:=crdefault;
end;

procedure TPlotForm.UpButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PlotMathIm.D3StartRotatingUp(RotInc);
  FormResize(nil);
end;

procedure TPlotForm.UpButtonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PlotMathIm.D3StopRotating;
  FormResize(nil);
end;

procedure TPlotForm.DownButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PlotMathIm.D3StartRotatingDown(RotInc);
  FormResize(nil);
end;

procedure TPlotForm.DownButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PlotMathIm.D3StopRotating;
  FormResize(nil);
end;

procedure TPlotForm.PlotMathImRotating(Sender: TObject);
begin
  PlotMathIm.Clear;
  if Type3D then begin
    with PlotMathIm do
    begin
      d3setworld(MinX,MinY,MinZ,MaxX,MaxY,MaxZ);
      d3aspectratio:=Aspectcheck.Checked;//aspectcheck.checked;
      clear;
      d3drawworldbox;
      d3drawaxes('x','y','z');
//    pen.color:=clRed;//wirecolor;
//    brush.color:=clGreen;//fillcolor;
//    brush.style:=bssolid;
{    Try
      d3drawsurface(Surface,true,true);
    except
      on E:ESurfaceError do
      messagedlg(E.message,mtError,[mbOk],0);
    end;
    restorebrush;
    restorepen;}
    end;
  end;
end;

procedure TPlotForm.LeftButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PlotMathIm.D3StartRotatingLeft(RotInc);
end;

procedure TPlotForm.RightButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PlotMathIm.D3StartRotatingRight(RotInc);
end;

procedure TPlotForm.InButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PlotMathIm.D3StartZoomingin(ZoomInc);
end;

procedure TPlotForm.InButtonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PlotMathIm.D3StopZooming;
end;

procedure TPlotForm.PlotMathImZooming(Sender: TObject);
begin
  PlotMathImRotating(nil);
end;

procedure TPlotForm.PlotMathImZoomStop(Sender: TObject);
begin
  FormResize(nil);
end;

procedure TPlotForm.OutButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PlotMathIm.D3StartZoomingOut(ZoomInc);
end;

procedure TPlotForm.FillColorPanelClick(Sender: TObject);
begin
  if ColorDialog1.Execute then begin
    (Sender as TPanel).Color:=ColorDialog1.Color;
    (Sender as TPanel).Font.Color:=(not ColorDialog1.Color)and$FFFFFF;
  end;
end;

procedure TPlotForm.RedrawButtonClick(Sender: TObject);
begin
  FormResize(nil);
end;

end.
