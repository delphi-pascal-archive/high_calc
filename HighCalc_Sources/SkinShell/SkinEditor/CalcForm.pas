unit CalcForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Skintypes,grMath, StdCtrls,Math,ButCodes,ExeUnit,Formula, ComCtrls,SkinMath;
type

  TCalcMainForm = class(TForm)
    IndicatorEdit: TEdit;
    InputMemo: TMemo;
    OutMemo: TMemo;
    FunctTree: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    MainBitMap:TBitMap;
    TempBitMap:TBitMap;
    MemoryStream:TMemoryStream;
    MouseDown:boolean;
    x,y:integer;
    ButtonCount:integer;
    ButtonInfos:TButtonInfos;
    PrevLightCod:integer;
    ButtonIndex:integer;
    IndicatorRect:TRect;
    OutMemoRect:TRect;
    FuncTreeRect:TRect;
    Indicators:TIndicators;
    procedure PressCalcButton(ButtonIndex:integer);
    procedure AddSymbolToIndicator(s:string);
    procedure ClearIndicator;
    procedure ExecuteExpression;
    procedure LoadMainBitMap(Stream:TStream);
    procedure LoadRegion(const Stream:TStream;var Region:TButtonRegion;
      var ShapeType:integer);
    procedure SetMainFormRegion(const RegType:integer;
      const Region:TButtonRegion);
    procedure SetIndicatorRegion(const RegType:integer;
      const Region:TButtonRegion);
    procedure SetOutMemoRegion(const RegType:integer;
      const Region:TButtonRegion);
    procedure SetFuncTreeRegion(const RegType:integer;
      const Region:TButtonRegion);
{    function CreateCircleRegion(const Region:TButtonRegion): HRGN;
    function CreateEllipsRegion(const Region:TButtonRegion): HRGN;
    function CreateRectRegion(const Region:TButtonRegion): HRGN;
    function CreateRoundRectRegion(const Region:TButtonRegion): HRGN;
    function CreatePolygonRegion(const Region:TButtonRegion): HRGN;}
    procedure LoadButtonInfo(Stream:TStream;i:integer);
//    procedure LoadRegInfo(Stream:TStream;var RegInfo:TRegInfo);
{    function IsPtInRegion (const ButtonInfo:TRegInfo;
      const Point:TPoint):boolean;}
    procedure DrawBitMap(Region:TRegInfo;BitMap:TBytes);
    procedure DrawLite(const Point:TPoint;DrawAny:boolean);
    procedure DrawRegion(const IndInfo: TIndInfo);
  public
    { Public declarations }
    procedure LoadSkin(FileName:TFileName);
    procedure DrawSkin;
  end;

var
  CalcMainForm: TCalcMainForm;

implementation

{$R *.DFM}

procedure TCalcMainForm.FormCreate(Sender: TObject);
begin
  MainBitMap:=TBitMap.Create;
  TempBitMap:=TBitMap.Create;
  MemoryStream:=TMemoryStream.Create;
  MouseDown:=false;
  PrevLightCod:=-1;
end;

procedure TCalcMainForm.FormDestroy(Sender: TObject);
begin
  MainBitMap.Free;
  TempBitMap.Free;
  MemoryStream.Free;
end;

procedure TCalcMainForm.LoadMainBitMap(Stream: TStream);
var
  Size,j0,j1:integer;
  n,i:integer;
  r:TRect;
  ShapeType:integer;
  MainFormRegion:TButtonRegion;
begin
  Stream.Read(Size,sizeOf(integer));
  MemoryStream.SetSize(Size);
  Stream.Read(MemoryStream.Memory^,Size);
  MemoryStream.Position:=0;
  MainBitMap.LoadFromStream(MemoryStream);
  Width:=MainBitMap.Width;
  Height:=MainBitMap.Height;
  Stream.Read(ButtonCount,SizeOf(integer));
  Stream.Read(j0,SizeOf(integer));
  if j0=1 then begin
    LoadRegion(Stream,MainFormRegion,ShapeType);
    SetMainFormRegion(ShapeType,MainFormRegion);
    dec(ButtonCount);
  end;
  Stream.Read(j1,SizeOf(integer));
  if j1=j0+1 then begin //Задан прямоугольник индикатора
    LoadRegion(Stream,MainFormRegion,ShapeType);
    SetIndicatorRegion(ShapeType,MainFormRegion);
    dec(ButtonCount);
    LoadRegion(Stream,MainFormRegion,ShapeType);
    SetOutMemoRegion(ShapeType,MainFormRegion);
    LoadRegion(Stream,MainFormRegion,ShapeType);
    SetFuncTreeRegion(ShapeType,MainFormRegion);
    dec(ButtonCount,2);
    //todo: Обеспечить загрузку контуров индикаторов и установку цветов управляющих элементов
    SetLength(Indicators,3);
    for i:=0 to 2 do
      Stream.Read(Indicators[i].Color,SizeOf(TColor));
    for i:=0 to 2 do
      LoadRegion(Stream,Indicators[i].Region,Indicators[i].ShapeType);
  end;

end;

procedure TCalcMainForm.LoadSkin(FileName: TFileName);
var
  FileStream:TFileStream;
  i:integer;
begin
  FileStream:=TFileStream.Create(FileName,fmOpenRead);
  try
    LoadMainBitMap(FileStream);
    SetLength(ButtonInfos,ButtonCount);
    dec(ButtonCount);
    for i:=0 to ButtonCount do
      LoadButtonInfo(FileStream,i);
  finally
    FileStream.Free;
  end;
end;

procedure TCalcMainForm.FormPaint(Sender: TObject);
begin
  DrawSkin;
end;

procedure TCalcMainForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Point:TPoint;
begin
  if PrevLightCod=-1 then begin
    MouseDown:=true;
    GetCursorPos(Point);
    Self.x:=Point.x;
    Self.y:=Point.y;
  end else begin
    PressCalcButton(ButtonIndex);
  end;
end;

procedure TCalcMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  dx,dy:integer;
  Point:TPoint;
begin
  if MouseDown then begin
    GetCursorPos(Point);
    dx:=Point.x-Self.x;
    dy:=Point.y-Self.y;
    Left:=Left+dx;
    Top:=Top+dy;
    Self.x:=Point.x;
    Self.y:=Point.y;
  end else begin
    Point.x:=x;
    Point.y:=y;
    DrawLite(Point,false);
  end;
end;

procedure TCalcMainForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  dx,dy:integer;
  Point:TPoint;
begin
  if MouseDown then begin
    GetCursorPos(Point);
    dx:=Point.x-Self.x;
    dy:=Point.y-Self.y;
    Left:=Left+dx;
    Top:=Top+dy;
    MouseDown:=false;
  end;
  if PrevLightCod<>-1 then begin
    Point.x:=x;
    Point.y:=y;
    DrawLite(Point,true);
  end;
end;

procedure TCalcMainForm.SetMainFormRegion(const RegType:integer;
  const Region:TButtonRegion);
var
  Rgn: HRGN;
begin
  case RegType of
    shCircle:Rgn:=CreateCircleRegion(Region);
    shEllipse:Rgn:=CreateEllipsRegion(Region);//Эллипс
    shRectangle:Rgn:=CreateRectRegion(Region);//Прямоугольник
    shRoundRectangle:Rgn:=CreateRoundRectRegion(Region);//Закругленный прямоугольник
    shPolygon:Rgn:=CreatePolygonRegion(Region);//Многоугольник
  end;
  SetWindowRgn(Handle,Rgn,True);
  DeleteObject(Rgn);
end;
{
function TCalcMainForm.CreateCircleRegion(
  const Region: TButtonRegion): HRGN;
var
  Radius:integer;
  Rect:TRect;
  xc,yc,x,y:integer;
begin
  xc:=Region[0].x;
  yc:=Region[0].y;
  x:=Region[1].x;
  y:=Region[1].y;
  Radius:=round(Sqrt(Sqr(xc-x)+Sqr(yc-y)));
  Rect.Left:=xc-Radius;
  Rect.Top:=yc-Radius;
  Rect.Right:=xc+Radius;
  Rect.Bottom:=yc+Radius;
  with Rect do
    result := CreateEllipticRgn(Left,Top,Right,Bottom);
end;

function TCalcMainForm.CreateEllipsRegion(
  const Region: TButtonRegion): HRGN;
var
  x1,y1,x2,y2:integer;
begin
  x1:=Region[0].x;
  y1:=Region[0].y;
  x2:=Region[1].x;
  y2:=Region[1].y;
  result := CreateEllipticRgn(x1,y1,x2,y2);
end;

function TCalcMainForm.CreatePolygonRegion(
  const Region: TButtonRegion): HRGN;
var
  PointCount:integer;
begin
  PointCount:=Length(Region);
  result := CreatePolygonRgn(Region[0],PointCount,ALTERNATE);
end;

function TCalcMainForm.CreateRectRegion(const Region: TButtonRegion): HRGN;
begin

end;

function TCalcMainForm.CreateRoundRectRegion(
  const Region: TButtonRegion): HRGN;
begin

end;
}
procedure TCalcMainForm.LoadButtonInfo(Stream:TStream;i:integer);
var
  BitMapSize:integer;
begin
  Stream.Read (ButtonInfos[i].Cod,SizeOf(integer));

  LoadRegInfo(Stream,ButtonInfos[i].FindRegion);

{  Stream.Read (BitMapSize,SizeOf(integer));
  SetLength(ButtonInfos[i].DisableBitMap,BitMapSize);
  Stream.Read (ButtonInfos[i].DisableBitMap[0],BitMapSize);
  LoadRegInfo(Stream,ButtonInfos[i].DisableRegion);}

  Stream.Read (BitMapSize,SizeOf(integer));
  SetLength(ButtonInfos[i].SelectBitMap,BitMapSize);
  Stream.Read (ButtonInfos[i].SelectBitMap[0],BitMapSize);
  LoadRegInfo(Stream,ButtonInfos[i].SelectRegion);

  Stream.Read (BitMapSize,SizeOf(integer));
  SetLength(ButtonInfos[i].LightBitMap,BitMapSize);
  Stream.Read (ButtonInfos[i].LightBitMap[0],BitMapSize);
  LoadRegInfo(Stream,ButtonInfos[i].LightRegion);
end;

{procedure TCalcMainForm.LoadRegInfo(Stream: TStream;
  var RegInfo: TRegInfo);
var
  n:integer;
begin
  Stream.Read (RegInfo.ShapeType,SizeOf(integer));
  Stream.Read (n,SizeOf(Integer));
  Stream.Read (RegInfo.BoundedRect,SizeOf(TRect));
  SetLength(RegInfo.Region,n);
  Stream.Read (RegInfo.Region[0],n*SizeOf(TPoint));
end;

function IsPtInCircle(const Point: TPoint;
  const ButtonRegion:TButtonRegion): boolean;
var
  Radius,d:double;
  xc,yc,x,y:integer;
begin
  result:=false;
  if Length(ButtonRegion)<2 then
    exit;
  xc:=ButtonRegion[0].x;
  yc:=ButtonRegion[0].y;
  x:=ButtonRegion[1].x;
  y:=ButtonRegion[1].y;
  Radius:=Sqr(xc-x)+Sqr(yc-y);
  with Point do
    d:=Sqr(xc-x)+Sqr(yc-y);
  result:=Radius>=d;
end;

function IsPtInEllipse(const Point: TPoint;
  const ButtonRegion:TButtonRegion): boolean;
var
  a2,b2,xc,yc,x,y,ye2:double;
  x1,y1,x2,y2:integer;
begin
  result:=false;
  if Length(ButtonRegion)<2 then
    exit;
  x1:=ButtonRegion[0].x;
  y1:=ButtonRegion[0].y;
  x2:=ButtonRegion[1].x;
  y2:=ButtonRegion[1].y;
  a2:=Sqr((x1-x2)/2);
  b2:=Sqr((y1-y2)/2);
  xc:=(x1+x2)/2;
  yc:=(y1+y2)/2;
  x:=sqr(Point.x-xc);
  y:=sqr(Point.y-yc);
  ye2:=b2*(1-x/a2);
  result:=ye2>=y;
end;

function IsPtInPolygon(const Point: TPoint;
  const ButtonRegion:TButtonRegion): boolean;
var
  Sizes:THoleSizes;
begin
  SetLength(Sizes,1);
  Sizes[0]:=Length(ButtonRegion);
  result:=IsPtInPoly(Point,THoles(ButtonRegion),Sizes);
end;

function IsPtInRectangle(const Point: TPoint;
  const ButtonRegion:TButtonRegion): boolean;
var
  x1,y1,x2,y2:integer;
begin
  result:=false;
  if Length(ButtonRegion)<2 then
    exit;
  x1:=ButtonRegion[0].x;
  y1:=ButtonRegion[0].y;
  x2:=ButtonRegion[1].x;
  y2:=ButtonRegion[1].y;
  result:=IsPtInRect(Point,Classes.Rect(x1,y1,x2,y2));
end;

function IsPtInRoundRectangle(const Point: TPoint;
  const ButtonRegion:TButtonRegion): boolean;
begin
  result:=false;
end;

function TCalcMainForm.IsPtInRegion(const ButtonInfo: TRegInfo;
  const Point: TPoint): boolean;
begin
  result:=false;
  case ButtonInfo.ShapeType of
    shCircle:result:=IsPtInCircle(Point,ButtonInfo.Region);
    shEllipse:result:=IsPtInEllipse(Point,ButtonInfo.Region);
    shRectangle:result:=IsPtInRectangle(Point,ButtonInfo.Region);
    shRoundRectangle:result:=IsPtInRoundRectangle(Point,ButtonInfo.Region);
    shPolygon:result:=IsPtInPolygon(Point,ButtonInfo.Region);
  end;
end;}

procedure TCalcMainForm.DrawBitMap(Region: TRegInfo; BitMap: TBytes);
var
  Rgn: HRGN;
  Size:integer;
begin
  Rgn:=CreateRegion(Region);
  try
    SelectClipRgn(Canvas.Handle,Rgn);
    Size:=Length(BitMap);
    MemoryStream.SetSize(0);
    MemoryStream.Write(BitMap[0],Size);
    MemoryStream.Position:=0;
    TempBitMap.LoadFromStream(MemoryStream);
    with Region do
      Canvas.Draw(BoundedRect.Left,BoundedRect.Top,TempBitMap);
  finally
    DeleteObject(Rgn);
  end;
end;

procedure TCalcMainForm.DrawLite(const Point: TPoint;DrawAny:boolean);
var
  i:integer;
begin
  for i:=0 to ButtonCount do
    if IsPtInRegion (ButtonInfos[i].FindRegion,Point) then begin
      if (PrevLightCod<>ButtonInfos[i].Cod)or DrawAny then begin
        if PrevLightCod<>-1 then
          DrawSkin;
//          Canvas.Draw(0,0,MainBitMap);
//          Canvas.StretchDraw(rect(0,0,Width-1,Height-1),MainBitMap);
        DrawBitMap(ButtonInfos[i].LightRegion,ButtonInfos[i].LightBitMap);
        PrevLightCod:=ButtonInfos[i].Cod;
        ButtonIndex:=i;
      end;
      exit;
    end;
  if PrevLightCod<>-1 then begin
    DrawSkin;
//    Canvas.Draw(0,0,MainBitMap);
//    Canvas.StretchDraw(rect(0,0,Width-1,Height-1),MainBitMap);
    PrevLightCod:=-1;
  end;
end;

procedure TCalcMainForm.SetIndicatorRegion(const RegType: integer;
  const Region: TButtonRegion);
var
  n:integer;
begin
  n:=Length(Region);
  if n<>2 then
    Raise Exception.Create('Неверное число точек в контуре индикатора -'+
      IntToStr(n));
  IndicatorRect:=PRect(@Region[0])^;
  with InputMemo do begin
    Left:=Min(IndicatorRect.Left,IndicatorRect.Right);
    Top:=Min(IndicatorRect.Top,IndicatorRect.Bottom);
    with IndicatorRect do begin
      Width:=Abs(Left-Right)+1;
      Height:=Abs(Top-Bottom)+1;
    end;
  end;
end;

procedure TCalcMainForm.PressCalcButton(ButtonIndex: integer);
var
  Cod:integer;
begin
  DrawBitMap(ButtonInfos[ButtonIndex].SelectRegion,
    ButtonInfos[ButtonIndex].SelectBitMap);
  Cod:=ButtonInfos[ButtonIndex].Cod;
  if (Cod>=bt_0) and (Cod<=bt_9) then
    AddSymbolToIndicator(IntToStr(Cod-bt_0))
  else if (Cod=bt_CloseForm) then
    Close
  else if (Cod=bt_Clear) then
    ClearIndicator
  else if (Cod=bt_Exe) then
    ExecuteExpression
  else if (Cod=bt_Plus) then
    AddSymbolToIndicator('+')
  else if (Cod=bt_Minus) then
    AddSymbolToIndicator('-')
  else if (Cod=bt_Mul) then
    AddSymbolToIndicator('*')
  else if (Cod=bt_Div) then
    AddSymbolToIndicator('/')
  else if (Cod=bt_DecSeparator) then
    AddSymbolToIndicator(DecimalSeparator)


end;

procedure TCalcMainForm.AddSymbolToIndicator(s: string);
var
  eqPos:integer;
begin
  eqPos:=Pos('=',IndicatorEdit.Text);
  if eqPos>0 then
    IndicatorEdit.Text:=Copy(IndicatorEdit.Text,eqPos+1,
      Length(IndicatorEdit.Text));
  IndicatorEdit.Text:=IndicatorEdit.Text+s;
  IndicatorEdit.SelStart:=Length(IndicatorEdit.Text);

//  IndicatorEdit.
end;

procedure TCalcMainForm.ClearIndicator;
begin
  IndicatorEdit.Text:='';
end;

procedure TCalcMainForm.ExecuteExpression;
var
  eqPos:integer;
  s:string;
  ErrorPosition:integer;
begin
  eqPos:=Pos('=',IndicatorEdit.Text);
  if eqPos>0 then
    s:=Copy(IndicatorEdit.Text,1,eqPos-1)
  else
    s:=IndicatorEdit.Text;
  ErrPosInTestEpress:=-1;
  try
    if Length(s)>0 then
      IndicatorEdit.Text:=s+'='+ExecExpresion(s,ErrorPosition)
    else
      IndicatorEdit.Text:='';
    IndicatorEdit.SelStart:=Length(IndicatorEdit.Text);
  except
    dec(ErrPosInTestEpress);
    if ErrPosInTestEpress>-1 then
      IndicatorEdit.SelStart:=ErrPosInTestEpress
    else
      Raise
  end;
end;

procedure TCalcMainForm.LoadRegion(const Stream:TStream;
  var Region: TButtonRegion;var ShapeType:integer);
var
  n:integer;
  r:TRect;
begin
  Stream.Read(ShapeType,SizeOf(Integer));
  Stream.Read(n,SizeOf(Integer));
  Stream.Read(r,SizeOf(TRect));
  SetLength(Region,n);
  Stream.Read(Region[0],n*SizeOf(TPoint));
end;

procedure TCalcMainForm.SetFuncTreeRegion(const RegType: integer;
  const Region: TButtonRegion);
var
  n:integer;
begin
  n:=Length(Region);
  if n<>2 then
    Raise Exception.Create('Неверное число точек в контуре индикатора -'+
      IntToStr(n));
  FuncTreeRect:=PRect(@Region[0])^;
  with FunctTree do begin
    Left:=Min(FuncTreeRect.Left,FuncTreeRect.Right);
    Top:=Min(FuncTreeRect.Top,FuncTreeRect.Bottom);
    with FuncTreeRect do begin
      Width:=Abs(Left-Right)+1;
      Height:=Abs(Top-Bottom)+1;
    end;
  end;
end;

procedure TCalcMainForm.SetOutMemoRegion(const RegType: integer;
  const Region: TButtonRegion);
var
  n:integer;
begin
  n:=Length(Region);
  if n<>2 then
    Raise Exception.Create('Неверное число точек в контуре индикатора -'+
      IntToStr(n));
  OutMemoRect:=PRect(@Region[0])^;
  with OutMemo do begin
    Left:=Min(OutMemoRect.Left,OutMemoRect.Right);
    Top:=Min(OutMemoRect.Top,OutMemoRect.Bottom);
    with OutMemoRect do begin
      Width:=Abs(Left-Right)+1;
      Height:=Abs(Top-Bottom)+1;
    end;
  end;
end;

procedure TCalcMainForm.DrawRegion(const IndInfo:TIndInfo);
var
  Rgn:HRGN;
  Region:TRegInfo;
  Brush:HBRUSH ;
  a:boolean;
  c:integer;
  r:TIntPolygon;
begin
  Region.ShapeType:=IndInfo.ShapeType;
  Region.Region:=IndInfo.Region;
  Rgn:=CreateRegion(Region);
  try
    Brush := CreateSolidBrush(IndInfo.Color);
    try
      a:=FillRgn(Canvas.Handle,Rgn,Brush);
    finally
      DeleteObject(Brush);
    end;
  finally
    DeleteObject(Rgn);
  end;
end;


procedure TCalcMainForm.DrawSkin;
var
  i:integer;
begin
  Canvas.Draw(0,0,MainBitMap);
  for i:=0 to 2 do
    DrawRegion(Indicators[i]);

end;

end.
