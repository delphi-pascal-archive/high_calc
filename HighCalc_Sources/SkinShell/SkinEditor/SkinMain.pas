unit SkinMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, PaintBoxWithRubberShape, Buttons,Jpeg, StdCtrls,
  Skintypes, SkinMath, Menus, GrMath, Math, Sort,ButCodes,Types;
const
  MaxBitMapIndex=2;
  OptFn='Main.Opt';
type

  TShape=class
  private
    ButtonRegion:TButtonRegion;
    FCod: integer;
    FShapeType: integer;
    Owner:TObject;
    PosPoint:TPoint;
    MousePressed:boolean;
    FigureMoving:boolean;
    FSelectedPointIndex: integer;
    procedure Circle;
    procedure Ellips;
    procedure Rect;
    procedure RoundRect;
    procedure Polygon;
    procedure DrawPoint(const Index:integer);
    procedure DrawBigPoint(const Index:integer);
    procedure SetCod(const Value: integer);
    procedure SetShapeType(const Value: integer);
    procedure BeginMoveFigure(Point:TPoint);
    procedure MoveFigure(Point:TPoint);
    procedure EndMoveFigure(Point:TPoint);
    function GetCanvas: TCanvas;
    procedure SetSelectedPointIndex(const Value: integer);
  public
    property Cod:integer read FCod write SetCod;
    property ShapeType:integer read FShapeType write SetShapeType;
    property Canvas:TCanvas read GetCanvas;
    property SelectedPointIndex:integer read FSelectedPointIndex write SetSelectedPointIndex;
    procedure Draw;
    procedure FillShape(Color: TColor);
    procedure DrawPoints;
    procedure DrawBigPoints();
    procedure AddPoint(const Point:TPoint);
    procedure MoveLastPoint(const Point:TPoint);
    procedure DelLastPoint;
    function IsPtInShape(const Point:TPoint):boolean;
    function IsPtInCircle(const Point:TPoint):boolean;
    function IsPtInEllipse(const Point:TPoint):boolean;
    function IsPtInRectangle(const Point:TPoint):boolean;
    function IsPtInRoundRectangle(const Point:TPoint):boolean;
    function IsPtInPolygon(const Point:TPoint):boolean;
    function MouseDown(x,y:integer):boolean;
    function MouseMove(x,y:integer):boolean;
    function GetBoundedRect:TRect;
    function GetCircleBoundedRect:TRect;
    function GetEllipseBoundedRect:TRect;
    function GetRectangleBoundedRect:TRect;
    function GetRoundRectangleBoundedRect:TRect;
    function GetPolygonBoundedRect:TRect;
    procedure MouseUp(x,y:integer);
    procedure SelectPoint(const Point:TPoint);
    procedure BeginMovePoint(const Point:TPoint);
    procedure MoveSelectedPoint(const Point:TPoint);
    procedure EndOperation;
    procedure SaveToTextFile(var TextFile:System.Text);
    procedure LoadFromTextFile(var TextFile:System.Text);
    procedure SaveToStream(const Stream:TStream);
    procedure LoadFromStream(const Stream:TStream);
    constructor Create(Owner:TObject);
    function AsRegInfo:TRegInfo;
  end;

  TShapes=array of TShape;

  TImageInfo=Class
  private
    FSelectedShapeIndex: integer;
//    Jpeg: TJpegImage;
    BitMap1:TBitMap;//Фон
    BitMap2:TBitMap;//Фон + сохраненные фигуры
    BitMap3:TBitMap;//Фон + сохраненные фигуры+ редактируемая фигура
    Shapes:TShapes;
    ZoomValue: double;
    Position: TPoint;
    PaintBoxWithRubberShape:TPaintBoxWithRubberShape;
    FAy: double;
    FAx: double;
    FCanvas:TCanvas;
    FDrawToPaintBox: boolean;
    FFileName: TFileName;
    FIndex: integer;
    BitMap:TBitMap;
    MemoryStream:TMemoryStream;

    procedure SetSelectedShapeIndex(const Value: integer);
    function GetCanvas: TCanvas;
    function GetSelectedShape: TShape;
    procedure SetAx(const Value: double);
    procedure SetAy(const Value: double);
    procedure SetCanvas(const Value: TCanvas);
    procedure SetDrawToPaintBox(const Value: boolean);
    procedure SetFileName(const Value: TFileName);
    procedure LoadBitMap(FileName: TFileName);
    procedure SetIndex(const Value: integer);
  public
    property SelectedShapeIndex:integer read FSelectedShapeIndex write SetSelectedShapeIndex;
    property SelectedShape:TShape read GetSelectedShape;
    property Ax:double read FAx write SetAx;
    property Ay:double read FAy write SetAy;
    property DrawToPaintBox:boolean read FDrawToPaintBox write SetDrawToPaintBox;
    property Canvas:TCanvas read GetCanvas write SetCanvas;
    property FileName:TFileName read FFileName write SetFileName;
    property Index:integer read FIndex write SetIndex;
    function ImageX(x:integer):integer;
    function ImageY(y:integer):integer;
    function CanvasX(x:integer):integer;
    function CanvasY(y:integer):integer;
    function ShapeIndexByCod(Cod:integer):integer;
    procedure AddShape;
    procedure DrawBitMap1;
    procedure DrawBitMap2;
    procedure DrawBitMap3;
    procedure DrawShapes;
    procedure DrawSelectedShapes;
    procedure DrawAll;
    procedure ResultToCanvas;
    procedure DrawAllToBitMap(BitMap:TBitMap);
    procedure MouseDown(x,y:integer);
    procedure MouseMove(x,y:integer);
    procedure MouseUp(x,y:integer);
    procedure EndOperation;
    procedure SaveImageInfoToTextFile(var TextFile:System.Text);
    procedure LoadImageInfoFromTextFile(var TextFile:System.Text);
    procedure SaveToStream(const Stream:TStream;const SaveImages:boolean);
    procedure SaveShape(const Stream:TStream; const i:integer;
      const SaveImage:boolean);
    procedure LoadFromStream(const Stream:TStream);
    constructor Create;
    function ShapeByCode(const Code:integer):TShape;
  end;

  TMainForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ScrollBox1: TScrollBox;
    BackgroundPB: TPaintBoxWithRubberShape;
    ScrollBox2: TScrollBox;
    PaintBoxWithRubberShape2: TPaintBoxWithRubberShape;
    ScrollBox3: TScrollBox;
    PressedPB: TPaintBoxWithRubberShape;
    ScrollBox4: TScrollBox;
    LightedPB: TPaintBoxWithRubberShape;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    MainMenu1: TMainMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    N5: TMenuItem;
    N6: TMenuItem;
    Colors1: TMenuItem;
    ExpressionField1: TMenuItem;
    ResultField1: TMenuItem;
    FunctionTree1: TMenuItem;
    ColorDialog1: TColorDialog;
    Options1: TMenuItem;
    Loadlastproject1: TMenuItem;
    Exit1: TMenuItem;
    procedure SpeedButton1Click(Sender: TObject);
    procedure BackgroundPBPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxWithRubberShape2Paint(Sender: TObject);
    procedure PressedPBPaint(Sender: TObject);
    procedure LightedPBPaint(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure BackgroundPBMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BackgroundPBMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure BackgroundPBMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N6Click(Sender: TObject);
    procedure ExpressionField1Click(Sender: TObject);
    procedure ResultField1Click(Sender: TObject);
    procedure FunctionTree1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    FProjectName: TFileName;
    FSkinEdited: boolean;
    procedure SetProjectName(const Value: TFileName);
    function GetShapeCodes:TIntegerArray;
    procedure SetSkinEdited(const Value: boolean);
    procedure SetExpressionFieldColor(const Value: TColor);
    procedure FillRegion(Code:integer;Color:TColor);
    procedure SetIndRes(const Value: TColor);
    procedure SetIndTree(const Value: TColor);
    function GetExpressionFieldColor: TColor;
    function GetIndRes: TColor;
    function GetIndTree: TColor;
    { Private declarations }
  public
    { Public declarations }
    ImageInfos:array[0..MaxBitMapIndex] of TImageInfo;
    property ProjectName:TFileName read FProjectName write SetProjectName;
    property SkinEdited:boolean read FSkinEdited write SetSkinEdited;
    property ExpressionFieldColor:TColor read GetExpressionFieldColor write SetExpressionFieldColor;
    property IndResColor:TColor read GetIndRes write SetIndRes;
    property IndTreeColor:TColor read GetIndTree write SetIndTree;
    procedure InitBitmaps;
    procedure LoadBitMap(Index:integer;FileName:TFileName);
    procedure SetPaintBoxSize(Index:integer);
    procedure Draw(Index:integer);
    procedure SaveProjectToTextFile(FileName:TFileName);
    procedure LoadProjectFromTextFile(FileName:TFileName);
    procedure SaveBinSkin;
    procedure SaveSkinToStream(Stream:TStream);
    procedure RunCalc;
    procedure RefreshImage(Index:integer);
    procedure LoadOptions(FileName:TFileName);
    procedure SaveOptions(FileName:TFileName);
  end;

var
  MainForm: TMainForm;
  ActionCod:integer;
  ProjDir:string;

implementation

uses ShpPropDlg, CalcForm;

{$R *.DFM}

{ TForm1 }

procedure TMainForm.Draw(Index: integer);
begin
//  ImageInfos[Index].DrawAll;
  ImageInfos[Index].ResultToCanvas;
  if ImageInfos[Index].SelectedShapeIndex>-1 then begin
    ImageInfos[Index].Canvas:=BackgroundPB.Canvas;
    ImageInfos[Index].SelectedShape.DrawBigPoints();
  end;

//  FillRegion(IndicatorCod,FExpressionFieldColor);

//  ImageInfos[Index].DrawShapes;
end;

procedure TMainForm.InitBitmaps;
var
  i:integer;
begin
  for i:=0 to MaxBitMapIndex do begin
    ImageInfos[i]:=TImageInfo.Create;
    ImageInfos[i].Index:=i;
  end;
{  for i:=0 to MaxBitMapIndex do
    ImageInfos[i].Jpeg:=TJpegImage.Create;}
  ImageInfos[0].PaintBoxWithRubberShape:=BackgroundPB;
  ImageInfos[1].PaintBoxWithRubberShape:=PressedPB;
  ImageInfos[2].PaintBoxWithRubberShape:=LightedPB;
//  ImageInfos[3].PaintBoxWithRubberShape:=PaintBoxWithRubberShape4;
end;

procedure TMainForm.LoadBitMap(Index: integer; FileName: TFileName);
var
  TempBitMap:TBitMap;
  Ext:string;
begin
  Ext:=LowerCase(ExtractFileExt(FileName));
  if Ext='.bmp' then begin
    TempBitMap:=TBitMap.Create;
    try
      TempBitMap.LoadFromFile(FileName);
      ImageInfos[Index].FFileName:=FileName;
      ImageInfos[Index].LoadBitMap(FileName);
      ImageInfos[Index].DrawBitMap2;
//      ImageInfos[Index].Jpeg.Assign(TempBitMap);
    finally
      TempBitMap.Free;
    end;
  end;{ else
    ImageInfos[Index].Jpeg.LoadFromFile(FileName);}
{  ImageInfos[Index].BitMap1.LoadFromFile(FileName);
  ImageInfos[Index].BitMap.LoadFromFile(FileName);
  ImageInfos[Index].BitMap.Width:=1;
  ImageInfos[Index].BitMap.Height:=1;
  ImageInfos[Index].ZoomValue:=1;
  ImageInfos[Index].Position.x:=0;
  ImageInfos[Index].Position.y :=0;
  ImageInfos[Index].FileName:=FileName;
  SetPaintBoxSize(Index);}
  Draw(Index);
end;

procedure TMainForm.SetPaintBoxSize(Index:integer);
begin
  with ImageInfos[Index] do begin
    PaintBoxWithRubberShape.Width:=round(BitMap1.Width*ZoomValue);
    PaintBoxWithRubberShape.Height:=round(BitMap1.Height*ZoomValue);
  end;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  OpenDialog1.FileName:='';
  OpenDialog1.InitialDir:='C:\WORK\Calc\';
  OpenDialog1.Filter:='Bitmap|*.bmp|Jpeg|*.jpg;*.Jpeg';
  OpenDialog1.DefaultExt:='.bmp';
  if OpenDialog1.Execute then
    LoadBitMap(PageControl1.ActivePageIndex,OpenDialog1.FileName);
end;

procedure TMainForm.BackgroundPBPaint(Sender: TObject);
begin
  Draw(0);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ActionCod:=mdNoOperation;
  InitBitmaps;
  SkinEdited:=false;
end;

procedure TMainForm.PaintBoxWithRubberShape2Paint(Sender: TObject);
begin
//  Draw(1);
end;

procedure TMainForm.PressedPBPaint(Sender: TObject);
begin
  Draw(1);
end;

procedure TMainForm.LightedPBPaint(Sender: TObject);
begin
  Draw(2);
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  with ImageInfos[PageControl1.ActivePageIndex] do
    ZoomValue:=ZoomValue*1.5;
  SetPaintBoxSize(PageControl1.ActivePageIndex);
  Draw(PageControl1.ActivePageIndex);
end;

procedure TMainForm.SpeedButton3Click(Sender: TObject);
const
  k=1/1.5;
begin
  with ImageInfos[PageControl1.ActivePageIndex] do
    ZoomValue:=ZoomValue*k;
  SetPaintBoxSize(PageControl1.ActivePageIndex);
  Draw(PageControl1.ActivePageIndex);
end;

procedure TMainForm.LoadProjectFromTextFile(FileName: TFileName);
var
  PrjFile:System.Text;
  i:integer;
begin
  FProjectName:=FileName;
  ProjDir:=ExtractFilePath(FileName);
  AssignFile(PrjFile,FileName);
  Reset(PrjFile);
  try
    ReadLn(PrjFile,IndicatorColors[IndicatorCod]);
    ReadLn(PrjFile,IndicatorColors[IndResCod]);
    ReadLn(PrjFile,IndicatorColors[IndTreeCod]);
    for i:=0 to MaxBitMapIndex do begin
      ImageInfos[i].LoadImageInfoFromTextFile(PrjFile);
      ImageInfos[i].FileName:=ProjDir+ImageInfos[i].FileName;
//      LoadBitMap(i,ImageInfos[i].FileName);
    end;
  finally
    CloseFile(PrjFile);
  end;
  SkinEdited:=false;
end;

procedure TMainForm.SaveProjectToTextFile(FileName: TFileName);
var
  PrjFile:System.Text;
  i:integer;
begin
  FProjectName:=FileName;
  AssignFile(PrjFile,FileName);
  Rewrite(PrjFile);
  try
    WriteLn(PrjFile,IndicatorColors[IndicatorCod]);
    WriteLn(PrjFile,IndicatorColors[IndResCod]);
    WriteLn(PrjFile,IndicatorColors[IndTreeCod]);
    for i:=0 to MaxBitMapIndex do
      ImageInfos[i].SaveImageInfoToTextFile(PrjFile);
  finally
    CloseFile(PrjFile);
  end;
  SkinEdited:=false;
end;

{ TShape }

procedure TShape.AddPoint(const Point: TPoint);
var
  i:integer;
begin
  i:=Length(ButtonRegion);
  SetLength(ButtonRegion,i+1);
  ButtonRegion[i]:=Point;
end;

function TShape.AsRegInfo: TRegInfo;
begin
  Result.ShapeType:=FShapeType;
  Result.BoundedRect:=GetBoundedRect;
  Result.Region:=ButtonRegion;
end;

procedure TShape.BeginMoveFigure(Point: TPoint);
begin
  if FigureMoving then
    EndMoveFigure(Point)
  else begin
    PosPoint:=Point;
    FigureMoving:=true;
  end;
end;

procedure TShape.BeginMovePoint(const Point: TPoint);
begin
  if FSelectedPointIndex>-1 then
    FSelectedPointIndex:=-1
  else
    SelectPoint(Point);
end;

procedure TShape.Circle;
var
  Radius:integer;
  Rect:TRect;
  xc,yc,x,y:integer;
begin
  Canvas.Pen.Color:=clBlack;
  Canvas.Brush.Style:=bsClear;
  if Length(ButtonRegion)<2 then
    exit;
  xc:=(Owner as TImageInfo).CanvasX(ButtonRegion[0].x);
  yc:=(Owner as TImageInfo).CanvasY(ButtonRegion[0].y);
  x:=(Owner as TImageInfo).CanvasX(ButtonRegion[1].x);
  y:=(Owner as TImageInfo).CanvasY(ButtonRegion[1].y);
  Radius:=round(Sqrt(Sqr(xc-x)+Sqr(yc-y)));
  Rect.Left:=xc-Radius;
  Rect.Top:=yc-Radius;
  Rect.Right:=xc+Radius;
  Rect.Bottom:=yc+Radius;
  Canvas.Ellipse(Rect);
end;

constructor TShape.Create(Owner: TObject);
begin
  Self.Owner:=Owner;
  MousePressed:=false;
  SelectedPointIndex:=-1;
end;

procedure TShape.DelLastPoint;
var
  i:integer;
begin
  i:=Length(ButtonRegion);
  SetLength(ButtonRegion,i-1);
end;

procedure TShape.Draw;
begin
  case FShapeType of
    shCircle:Circle;
    shEllipse:Ellips;//Эллипс
    shRectangle:Rect;//Прямоугольник
    shRoundRectangle:RoundRect;//Закругленный прямоугольник
    shPolygon:Polygon;//Многоугольник
  end;
end;

procedure TShape.FillShape(Color: TColor);
var
  Rgn:HRGN;
  Region:TRegInfo;
  Brush:HBRUSH ;
  a:boolean;
  c:integer;
  r:TIntPolygon;
begin
  Region:=AsRegInfo;
  Rgn:=CreateRegion(Region);
  try
    Brush := CreateSolidBrush(Color);
    try
      a:=FillRgn(Canvas.Handle,Rgn,Brush);
    finally
      DeleteObject(Brush);
    end;  
  finally
    DeleteObject(Rgn);
  end;
end;


procedure TShape.DrawPoint(const Index: integer);
var
  x,y:integer;
begin
//  Canvas.Pen.Color:=clLime;//clRed;
//  Canvas.Brush.Color:=clLime;//clRed;
  Canvas.Brush.Style:=bsSolid;
  x:=(Owner as TImageInfo).CanvasX(ButtonRegion[Index].x);
  y:=(Owner as TImageInfo).CanvasY(ButtonRegion[Index].y);
  Canvas.Pixels[x,y]:=clLime;
//  Canvas.Rectangle(x-2,y-2,x+2,y+2);
end;

procedure TShape.DrawPoints;
var
  i,n:integer;
begin
  n:=Length(ButtonRegion)-1;
  for i:=0 to n do
    DrawPoint(i);
end;

procedure TShape.Ellips;
var
  Rect:TRect;
  x1,y1,x2,y2:integer;
begin
  Canvas.Pen.Color:=clBlack;
  Canvas.Brush.Style:=bsClear;
  if Length(ButtonRegion)<2 then
    exit;
  x1:=(Owner as TImageInfo).CanvasX(ButtonRegion[0].x);
  y1:=(Owner as TImageInfo).CanvasY(ButtonRegion[0].y);
  x2:=(Owner as TImageInfo).CanvasX(ButtonRegion[1].x);
  y2:=(Owner as TImageInfo).CanvasY(ButtonRegion[1].y);
  Rect.Left:=x1;
  Rect.Top:=y2;
  Rect.Right:=x2;
  Rect.Bottom:=y1;
  Canvas.Ellipse(Rect);
end;

procedure TShape.EndMoveFigure(Point: TPoint);
begin
  if FigureMoving then begin
    MoveFigure(Point);
    ActionCod:=mdNoOperation;
    FigureMoving:=false;
  end;
end;

procedure TShape.EndOperation;
begin
  case ActionCod of
    mdAddPoint: DelLastPoint;
  end;
  ActionCod:=mdNoOperation;
end;

function TShape.GetBoundedRect: TRect;
begin
  case ShapeType of
    shCircle:result:=GetCircleBoundedRect;
    shEllipse:result:=GetEllipseBoundedRect;
    shRectangle:result:=GetRectangleBoundedRect;
    shRoundRectangle:result:=GetRoundRectangleBoundedRect;
    shPolygon:result:=GetPolygonBoundedRect;
  end;
end;

function TShape.GetCanvas: TCanvas;
begin
  result:=(Owner as TImageInfo).Canvas;
end;

function TShape.GetCircleBoundedRect: TRect;
var
  Radius:double;
  xc,yc,x,y:integer;
begin
  if Length(ButtonRegion)<2 then
    Raise Exception.Create('Необходимо 2 точки');
  xc:=ButtonRegion[0].x;
  yc:=ButtonRegion[0].y;
  x:=ButtonRegion[1].x;
  y:=ButtonRegion[1].y;
  Radius:=Sqrt(Sqr(xc-x)+Sqr(yc-y));
  result:=Classes.Rect(round(xc-Radius),round(yc-Radius),
    round(xc+Radius),round(yc+Radius));
end;

function TShape.GetEllipseBoundedRect: TRect;
begin
  if Length(ButtonRegion)<2 then
    Raise Exception.Create('Необходимо 2 точки');
  result:=Classes.Rect(ButtonRegion[0].x,ButtonRegion[0].y,
    ButtonRegion[1].x,ButtonRegion[1].y);
end;

function TShape.GetPolygonBoundedRect: TRect;
var
  i,n:integer;
  MinX,MinY,MaxX,MaxY:integer;
begin
  n:=Length(ButtonRegion)-1;
  if Length(ButtonRegion)<1 then
    Raise Exception.Create('Необходимо 2 точки');
  MinX:=ButtonRegion[0].x;
  MinY:=ButtonRegion[0].y;
  MaxX:=ButtonRegion[0].x;
  MaxY:=ButtonRegion[0].y;
  for i:=1 to n do begin
    if MinX>ButtonRegion[i].x then
      MinX:=ButtonRegion[i].x;
    if MinY>ButtonRegion[i].y then
      MinY:=ButtonRegion[i].y;
    if MaxX<ButtonRegion[i].x then
      MaxX:=ButtonRegion[i].x;
    if MaxY<ButtonRegion[i].y then
      MaxY:=ButtonRegion[i].y;
  end;
  result:=Classes.Rect(MinX,MinY,MaxX,MaxY);
end;

function TShape.GetRectangleBoundedRect: TRect;
begin
  if Length(ButtonRegion)<2 then
    Raise Exception.Create('Необходимо 2 точки');
  result:=Classes.Rect(ButtonRegion[0].x,ButtonRegion[0].y,
    ButtonRegion[1].x,ButtonRegion[1].y);
end;

function TShape.GetRoundRectangleBoundedRect: TRect;
begin

end;

function TShape.IsPtInCircle(const Point: TPoint): boolean;
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

function TShape.IsPtInEllipse(const Point: TPoint): boolean;
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

function TShape.IsPtInPolygon(const Point: TPoint): boolean;
var
  Sizes:THoleSizes;
begin
  SetLength(Sizes,1);
  Sizes[0]:=Length(ButtonRegion);
  result:=IsPtInPoly(Point,THoles(ButtonRegion),Sizes);
end;

function TShape.IsPtInRectangle(const Point: TPoint): boolean;
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

function TShape.IsPtInRoundRectangle(const Point: TPoint): boolean;
begin
  result:=false;
end;

function TShape.IsPtInShape(const Point: TPoint): boolean;
begin
  result:=false;
  case ShapeType of
    shCircle:result:=IsPtInCircle(Point);
    shEllipse:result:=IsPtInEllipse(Point);
    shRectangle:result:=IsPtInRectangle(Point);
    shRoundRectangle:result:=IsPtInRoundRectangle(Point);
    shPolygon:result:=IsPtInPolygon(Point);
  end;
end;

procedure TShape.LoadFromStream(const Stream: TStream);
var
  n,i:integer;
begin
  Stream.Read(FShapeType,SizeOf(Integer));
  Stream.Read(FCod,SizeOf(Integer));
  Stream.Read(n,SizeOf(Integer));
  SetLength(ButtonRegion,n);
  dec(n);
  for i:=0 to n do
    Stream.Read(ButtonRegion[i],SizeOf(TPoint));
end;

procedure TShape.LoadFromTextFile(var TextFile: Text);
var
  n,i:integer;
begin
  ReadLn(TextFile,FShapeType,FCod,n);
  SetLength(ButtonRegion,n);
  dec(n);
  for i:=0 to n do with ButtonRegion[i] do
    ReadLn(TextFile,x,y);
end;

function TShape.MouseDown(x, y: integer):boolean;
var
  Point:TPoint;
begin
  Point.x:=x;
  Point.y:=y;
  MousePressed:=true;
  result:=false;
  case ActionCod of
    mdAddPoint:begin AddPoint(Point);result:=true; end;
    mdMoveFigure:begin BeginMoveFigure(Point);result:=true; end;
    mdDeletePoint:;
    mdInsertPoint:;
    mdMovePoint:begin BeginMovePoint(Point);result:=true; end;
    mdSelectFigure:;
    mdSelectPoint:;
  end;
end;

function TShape.MouseMove(x, y: integer):boolean;
var
  Point:TPoint;
begin
  result:=false;
  Point.x:=x;Point.y:=y;
  case ActionCod of
    mdAddPoint:begin MoveLastPoint(Point);result:=true;end;
    mdMoveFigure:begin MoveFigure(Point);result:=true;end;
    mdDeletePoint:;
    mdInsertPoint:;
    mdMovePoint:begin MoveSelectedPoint(Point); result:=true;end;
    mdSelectFigure:;
    mdSelectPoint:;
  end;
end;

procedure TShape.MouseUp(x, y: integer);
var
  Point:TPoint;
begin
  Point.x:=x;
  Point.y:=y;
  case ActionCod of
    mdAddPoint:;
    mdMoveFigure:;
    mdDeletePoint:;
    mdInsertPoint:;
    mdMovePoint:;
    mdSelectFigure:;
    mdSelectPoint:;
  end;
  MousePressed:=false;
end;

procedure TShape.MoveFigure(Point: TPoint);
var
  dx,dy:integer;
  i,n:integer;
begin
  if FigureMoving then begin
    dx:=Point.x-PosPoint.x;
    dy:=Point.y-PosPoint.y;
    n:=Length(ButtonRegion)-1;
    for i:=0 to n do with ButtonRegion[i] do begin
      x:=x+dx;
      y:=y+dy;
    end;
    PosPoint:=Point;
  end;  
end;

procedure TShape.MoveLastPoint(const Point: TPoint);
var
  i:integer;
begin
  i:=Length(ButtonRegion)-1;
  if i>=0 then
    ButtonRegion[i]:=Point;
end;

procedure TShape.MoveSelectedPoint(const Point: TPoint);
begin
  if FSelectedPointIndex>-1 then
    ButtonRegion[FSelectedPointIndex]:=Point;
end;

procedure TShape.Polygon;
var
  i,n:integer;
  x1,y1,x2,y2:integer;
  CanvasButtonRegion:TButtonRegion;
begin
  Canvas.Pen.Color:=clBlack;
  Canvas.Brush.Style:=bsClear;
  n:=Length(ButtonRegion);
  if n<2 then
    exit;
  SetLength(CanvasButtonRegion,n);
  dec(n);
  for i:=0 to n do begin
    CanvasButtonRegion[i].x:=(Owner as TImageInfo).CanvasX(ButtonRegion[i].x);
    CanvasButtonRegion[i].y:=(Owner as TImageInfo).CanvasY(ButtonRegion[i].y);
  end;
  Canvas.Polygon(CanvasButtonRegion);
end;

procedure TShape.Rect;
var
  Rect:TRect;
  x1,y1,x2,y2:integer;
begin
  Canvas.Pen.Color:=clBlack;
  Canvas.Brush.Style:=bsClear;
  if Length(ButtonRegion)<2 then
    exit;
  x1:=(Owner as TImageInfo).CanvasX(ButtonRegion[0].x);
  y1:=(Owner as TImageInfo).CanvasY(ButtonRegion[0].y);
  x2:=(Owner as TImageInfo).CanvasX(ButtonRegion[1].x);
  y2:=(Owner as TImageInfo).CanvasY(ButtonRegion[1].y);
  Rect.Left:=x1;
  Rect.Top:=y2;
  Rect.Right:=x2;
  Rect.Bottom:=y1;
  Canvas.Rectangle(Rect);
end;

procedure TShape.RoundRect;
var
  x1,y1,x2,y2,x3,y3:integer;
begin
  Canvas.Pen.Color:=clBlack;
  Canvas.Brush.Style:=bsClear;
  if Length(ButtonRegion)<3 then
    exit;
  x1:=(Owner as TImageInfo).CanvasX(ButtonRegion[0].x);
  y1:=(Owner as TImageInfo).CanvasY(ButtonRegion[0].y);
  x2:=(Owner as TImageInfo).CanvasX(ButtonRegion[1].x);
  y2:=(Owner as TImageInfo).CanvasY(ButtonRegion[1].y);
  x3:=(Owner as TImageInfo).CanvasX(ButtonRegion[2].x);
  y3:=(Owner as TImageInfo).CanvasY(ButtonRegion[2].y);
  Canvas.RoundRect(x1,y1,x2,y2,x3,y3);
end;

procedure TShape.SaveToStream(const Stream: TStream);
var
  n,i:integer;
  r:TRect;
begin
  n:=Length(ButtonRegion);
  r:=GetBoundedRect;
  Stream.Write(FShapeType,SizeOf(Integer));
//  Stream.Write(FCod,SizeOf(Integer));
  Stream.Write(n,SizeOf(Integer));
  Stream.Write(r,SizeOf(TRect));
  Stream.Write(ButtonRegion[0],n*SizeOf(TPoint));
end;

procedure TShape.SaveToTextFile(var TextFile: Text);
var
  n,i:integer;
begin
  n:=Length(ButtonRegion);
  WriteLn(TextFile,FShapeType,' ',FCod,' ',n);
  dec(n);
  for i:=0 to n do with ButtonRegion[i] do
    WriteLn(TextFile,x,' ',y);
end;

procedure TShape.SelectPoint(const Point:TPoint);
var
  i,n:integer;
  r:TRect;
  s:double;
begin
  with Point do begin
    s:=2;//(owner as TImageInfo).ZoomValue;
    r:=Classes.Rect(round(x-s),round(y-s),round(x+s),round(y+s));
    n:=Length(ButtonRegion)-1;
    for i:=0 to n do with ButtonRegion[i] do
      if IsPtInRect(x,y,r) then begin
        FSelectedPointIndex:=i;
        exit;
      end;
    SelectedPointIndex:=-1;
  end;
end;

procedure TShape.SetCod(const Value: integer);
begin
  FCod := Value;
end;

procedure TShape.SetSelectedPointIndex(const Value: integer);
begin
  FSelectedPointIndex := Value;
end;

procedure TShape.SetShapeType(const Value: integer);
begin
  FShapeType := Value;
end;

procedure TShape.DrawBigPoints();
var
  i,n:integer;
begin
  n:=Length(ButtonRegion)-1;
  for i:=0 to n do
    DrawBigPoint(i);
end;

procedure TShape.DrawBigPoint(const Index: integer);
var
  x,y:integer;
begin
  Canvas.Pen.Color:=clRed;
  Canvas.Brush.Color:=clRed;
  Canvas.Brush.Style:=bsSolid;
  x:=Round(ButtonRegion[Index].x*(Owner as TImageInfo).ZoomValue);
  y:=round(ButtonRegion[Index].y*(Owner as TImageInfo).ZoomValue);
//  Canvas.Pixels[x,y]:=clLime;
  Canvas.Rectangle(x-2,y-2,x+2,y+2);
end;

{ TImageInfo }

procedure TImageInfo.AddShape;
var
  n:integer;
begin
  n:=Length(Shapes);
  SetLength(Shapes,n+1);
  Shapes[n]:=TShape.Create(Self);
  FSelectedShapeIndex:=n;
  ActionCod:=mdAddPoint;
end;

function TImageInfo.CanvasX(x: integer): integer;
begin
//  result:=round(x*ZoomValue);
  result:=x;
end;

function TImageInfo.CanvasY(y: integer): integer;
begin
//  result:=round(y*ZoomValue);
  result:=y;
end;

constructor TImageInfo.Create;
begin
  inherited;
  FSelectedShapeIndex:=-1;
  ZoomValue:=1;
  FAx:=0;
  FAy:=0;
  FDrawToPaintBox := true;
  BitMap:=TBitMap.Create;
  MemoryStream:=TMemoryStream.Create;
  BitMap1:=TBitMap.Create;
  BitMap2:=TBitMap.Create;
  BitMap3:=TBitMap.Create;
end;

procedure TImageInfo.DrawBitMap1;
begin
  with PaintBoxWithRubberShape do
//    if not Jpeg.Empty then
    if (BitMap1.Width>0) and (BitMap1.Height>0) then
      Self.Canvas.Draw(0,0,BitMap1);
end;

procedure TImageInfo.DrawAll;
begin
  DrawBitMap1;
  DrawShapes;
//  DrawSelectedShapes;
end;

procedure TImageInfo.DrawAllToBitMap(BitMap: TBitMap);
begin
  Canvas:=BitMap.Canvas;
  FDrawToPaintBox:=false;
  DrawAll;
end;

procedure TImageInfo.DrawSelectedShapes;
begin
  if FSelectedShapeIndex>=0 then begin
    Shapes[FSelectedShapeIndex].Draw;
//    Shapes[FSelectedShapeIndex].DrawPoints;
  end;
end;

procedure TImageInfo.DrawShapes;
var
  i,n:integer;
begin
  try
    i:=ShapeIndexByCod(Indicator1Cod);
    Shapes[i].FillShape(IndicatorColors[IndicatorCod]);
    i:=ShapeIndexByCod(IndResCod);
    Shapes[i].FillShape(IndicatorColors[IndResCod]);
    i:=ShapeIndexByCod(IndTreeCod);
    Shapes[i].FillShape(IndicatorColors[IndTreeCod]);
  except
  end;
  n:=Length(Shapes)-1;
  for i:=0 to n do if i<>FSelectedShapeIndex then
    Shapes[i].Draw;


end;

procedure TImageInfo.EndOperation;
begin
  Shapes[FSelectedShapeIndex].EndOperation;
end;

function TImageInfo.GetCanvas: TCanvas;
begin
  if DrawToPaintBox then
    result:=PaintBoxWithRubberShape.Canvas
  else
    result:=FCanvas;
end;

function TImageInfo.GetSelectedShape: TShape;
begin
  if SelectedShapeIndex>-1 then
    result:=Shapes[SelectedShapeIndex]
  else
    result:=nil;
end;

function TImageInfo.ImageX(x: integer): integer;
begin
  result:=round(x/ZoomValue+Ax);
end;

function TImageInfo.ImageY(y: integer): integer;
begin
  result:=round(y/ZoomValue+Ay);
end;

procedure TImageInfo.LoadImageInfoFromTextFile(var TextFile: Text);
var
  n,i:integer;
begin
  ReadLn(TextFile,FFileName);
  ReadLn(TextFile,n);
  SetLength(Shapes,n);
  dec(n);
  for i:=0 to n do begin
    Shapes[i]:=TShape.Create(Self);
    Shapes[i].LoadFromTextFile(TextFile);
  end;
  LoadBitMap(ProjDir+FFileName);
  DrawBitMap2;
end;

procedure TImageInfo.MouseDown(x, y: integer);
var
  Point:TPoint;
  i,n:integer;
begin
  x:=ImageX(x);
  y:=ImageY(y);
  if ActionCod=mdSelectFigure then begin
    Point.x:=x;
    Point.y:=y;
    n:=Length(Shapes)-1;
    for i:=n downto 0 do
      if Shapes[i].IsPtInShape(Point) then begin
        FSelectedShapeIndex:=i;
        DrawBitMap3;
        ResultToCanvas;
//        DrawAll;
        break;
      end;
  end else begin
    if FSelectedShapeIndex<0 then
      exit;
    if Shapes[FSelectedShapeIndex].MouseDown(x,y) then
      DrawBitMap2;
  end;  
end;

procedure TImageInfo.MouseMove(x, y: integer);
begin
  if FSelectedShapeIndex<0 then
    exit;
  x:=ImageX(x);
  y:=ImageY(y);
  if Shapes[FSelectedShapeIndex].MouseMove(x,y) then begin
    DrawBitMap3;
    ResultToCanvas;
  end;
end;

procedure TImageInfo.MouseUp(x, y: integer);
begin
  if FSelectedShapeIndex<0 then
    exit;
  x:=ImageX(x);
  y:=ImageY(y);
  Shapes[FSelectedShapeIndex].MouseUp(x,y);
end;

procedure TImageInfo.SaveImageInfoToTextFile(var TextFile: Text);
var
  n,i:integer;
begin
  WriteLn(TextFile,ExtractFileName(FFileName));
  n:=Length(Shapes);
  WriteLn(TextFile,n);
  dec(n);
  for i:=0 to n do
    Shapes[i].SaveToTextFile(TextFile);
end;

procedure TImageInfo.SetAx(const Value: double);
begin
  FAx := Value;
end;

procedure TImageInfo.SetAy(const Value: double);
begin
  FAy := Value;
end;

procedure TImageInfo.SetCanvas(const Value: TCanvas);
begin
  FCanvas:=Value;
end;

procedure TImageInfo.SetDrawToPaintBox(const Value: boolean);
begin
  FDrawToPaintBox := Value;
end;

procedure TImageInfo.SetFileName(const Value: TFileName);
begin
  FFileName := Value;
end;

procedure TImageInfo.SetSelectedShapeIndex(const Value: integer);
begin
  FSelectedShapeIndex := Value;
end;

procedure TMainForm.SpeedButton5Click(Sender: TObject);
var
  Point:TPoint;
begin
  if ShapeDialog then begin
    ImageInfos[PageControl1.ActivePageIndex].AddShape;
    ImageInfos[PageControl1.ActivePageIndex].SelectedShape.Cod:=
      ShapeDlgForm.Cod;
    ImageInfos[PageControl1.ActivePageIndex].SelectedShape.ShapeType:=
      ShapeDlgForm.ShapeType;
    ImageInfos[PageControl1.ActivePageIndex].SelectedShape.AddPoint(Point);
  end;
end;

procedure TMainForm.BackgroundPBMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then begin
    ImageInfos[PageControl1.ActivePageIndex].MouseDown(x,y);
    if ActionCod=mdSelectFigure then
      ActionCod:=mdNoOperation;
      Draw(PageControl1.ActivePageIndex);
  end;
end;

procedure TMainForm.BackgroundPBMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ImageInfos[PageControl1.ActivePageIndex].MouseMove(x,y);
  if ActionCod<>mdNoOperation then
    Draw(PageControl1.ActivePageIndex);
  if  ActionCod in [mdAddPoint,mdDeletePoint,mdInsertPoint,mdMovePoint,mdMoveFigure] then
    SkinEdited:=true;

end;

procedure TMainForm.BackgroundPBMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ImageInfos[PageControl1.ActivePageIndex].MouseUp(x,y);
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
  ImageInfos[PageControl1.ActivePageIndex].EndOperation;
  ImageInfos[PageControl1.ActivePageIndex].SelectedShapeIndex:=-1;
  ImageInfos[PageControl1.ActivePageIndex].DrawBitMap2;
  ImageInfos[PageControl1.ActivePageIndex].DrawBitMap3;
  Draw(PageControl1.ActivePageIndex);
end;

procedure TMainForm.SpeedButton6Click(Sender: TObject);
begin
  ActionCod:=mdSelectFigure;
  ImageInfos[PageControl1.ActivePageIndex].SelectedShapeIndex:=-1;
  ImageInfos[PageControl1.ActivePageIndex].DrawBitMap2;
  ImageInfos[PageControl1.ActivePageIndex].DrawBitMap3;
end;

procedure TMainForm.SpeedButton8Click(Sender: TObject);
begin
  if ImageInfos[PageControl1.ActivePageIndex].SelectedShapeIndex>=0 then
    ActionCod:=mdMoveFigure;
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
  OpenDialog1.FileName:='';;
  OpenDialog1.Filter:='Проект скина|*.skp';
  OpenDialog1.DefaultExt:='.skp';
  OpenDialog1.InitialDir:='C:\WORK\Calc\';
  if OpenDialog1.Execute then begin
    LoadProjectFromTextFile(OpenDialog1.FileName);
    ProjectName:=OpenDialog1.FileName;
  end;
end;

procedure TMainForm.N4Click(Sender: TObject);
begin
  SaveDialog1.Filter:='Проект скина|*.skp';
  SaveDialog1.DefaultExt:='.skp';
  if SaveDialog1.Execute then begin
    SaveProjectToTextFile(SaveDialog1.FileName);
    ProjectName:=SaveDialog1.FileName;
  end;
end;

procedure TImageInfo.DrawBitMap2;
begin
  Canvas:=BitMap2.Canvas;
  BitMap2.Width:=BitMap1.Width;
  BitMap2.Height:=BitMap1.Height;
  FDrawToPaintBox:=false;
  DrawAll;
end;

procedure TImageInfo.DrawBitMap3;
begin
  Canvas:=BitMap3.Canvas;
  BitMap3.Width:=BitMap1.Width;
  BitMap3.Height:=BitMap1.Height;
  FDrawToPaintBox:=false;
  Canvas.Draw(0,0,BitMap2);
  DrawSelectedShapes;
end;


procedure TImageInfo.ResultToCanvas;
var
  BitMap:TBitMap;
begin
  if (ActionCod=mdNoOperation)and (FSelectedShapeIndex<0) then
    BitMap:=BitMap2
  else
    BitMap:=BitMap3;
  with PaintBoxWithRubberShape do
    if (BitMap.Width>0) and (BitMap.Height>0) then
      PaintBoxWithRubberShape.Canvas.
        StretchDraw(CreateRect(0,0,Width-1,Height-1),BitMap)
end;

procedure TImageInfo.LoadBitMap(FileName: TFileName);
var
  TempBitMap:TBitMap;
  Ext:string;
begin
  BitMap1.LoadFromFile(FileName);
  BitMap.LoadFromFile(FileName);
  BitMap.Width:=1;
  BitMap.Height:=1;
  ZoomValue:=1;
  Position.x:=0;
  Position.y :=0;
  FileName:=FileName;
  MainForm.SetPaintBoxSize(Index);
//  Draw(Index);
end;

procedure TImageInfo.SetIndex(const Value: integer);
begin
  FIndex := Value;
end;

procedure TMainForm.SpeedButton9Click(Sender: TObject);
begin

  ActionCod:=mdMovePoint;
end;

procedure TMainForm.SpeedButton10Click(Sender: TObject);
var
  Cod,ShapeType,i,n:integer;
  ButtonRegion:TButtonRegion;
begin
  if ImageInfos[PageControl1.ActivePageIndex].SelectedShapeIndex>-1 then begin
    i:=ImageInfos[PageControl1.ActivePageIndex].SelectedShapeIndex;
    n:=Length(ImageInfos[PageControl1.ActivePageIndex].Shapes[i].ButtonRegion);
    SetLength(ButtonRegion,n);
    Move(ImageInfos[PageControl1.ActivePageIndex].Shapes[i].ButtonRegion[0],
      ButtonRegion[0],n*SizeOf(TPoint));
    Cod:=ImageInfos[PageControl1.ActivePageIndex].Shapes[i].Cod;
    ShapeType:=ImageInfos[PageControl1.ActivePageIndex].Shapes[i].ShapeType;
    ImageInfos[PageControl1.ActivePageIndex].AddShape;
    ActionCod:=mdNoOperation;
    ImageInfos[PageControl1.ActivePageIndex].SelectedShape.ButtonRegion:=
      ButtonRegion;
    ImageInfos[PageControl1.ActivePageIndex].SelectedShape.Cod:=Cod;
    ImageInfos[PageControl1.ActivePageIndex].SelectedShape.ShapeType:=ShapeType;
  end;
end;

procedure TMainForm.SpeedButton7Click(Sender: TObject);
var
  Point:TPoint;
begin
  if ImageInfos[PageControl1.ActivePageIndex].SelectedShapeIndex>-1 then begin
    ShapeDlgForm.Cod:=ImageInfos[PageControl1.ActivePageIndex].
      SelectedShape.Cod;
    ShapeDlgForm.ShapeType:=ImageInfos[PageControl1.ActivePageIndex].
      SelectedShape.ShapeType;
    if ShapeDialog then begin
      ImageInfos[PageControl1.ActivePageIndex].SelectedShape.Cod:=
        ShapeDlgForm.Cod;
      ImageInfos[PageControl1.ActivePageIndex].SelectedShape.ShapeType:=
        ShapeDlgForm.ShapeType;
      ImageInfos[PageControl1.ActivePageIndex].DrawBitMap2;
      ImageInfos[PageControl1.ActivePageIndex].DrawBitMap3;
      Draw(PageControl1.ActivePageIndex);
//      ActionCod:=mdAddPoint;
//      ImageInfos[PageControl1.ActivePageIndex].SelectedShape.AddPoint(Point);  
    end;
  end;
end;

procedure TMainForm.SpeedButton11Click(Sender: TObject);
begin
  SaveBinSkin;
  RunCalc;
end;

procedure TMainForm.RunCalc;
var
  SkinName:TFileName;
begin
  SkinName:=ChangeFileExt(FProjectName,'.bsk');
  CalcMainForm.LoadSkin(SkinName);
  CalcMainForm.Show;
end;

procedure TMainForm.SaveBinSkin;
var
  SkinName:TFileName;
  Stream:TFileStream;
begin
  SkinName:=ChangeFileExt(FProjectName,'.bsk');
  Stream:=TFileStream.Create(SkinName,fmCreate);
  try
    SaveSkinToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TMainForm.SetProjectName(const Value: TFileName);
begin
  FProjectName := Value;
end;

procedure TMainForm.SaveSkinToStream(Stream: TStream);
var
  i,j,Cod,Index,n,j0,j1,BitMapSize:integer;
  SkinCodes:TIntegerArray;
  MemoryStream:TMemoryStream;
begin
  MemoryStream:=TMemoryStream.Create;
  try
    ImageInfos[0].BitMap1.SaveToStream(MemoryStream);
    BitMapSize:=MemoryStream.Size;
    Stream.Write(BitMapSize,SizeOf(integer));
    Stream.Write(MemoryStream.Memory^,BitMapSize);
  finally
    MemoryStream.Free;
  end;
  SkinCodes:=GetShapeCodes;
  n:=Length(SkinCodes);
  Stream.Write(n,SizeOf(integer));
  if n=0 then
    exit;
  if SkinCodes[0]=FrameCod then
    j0:=1
  else
    j0:=0;
  Stream.Write(j0,SizeOf(integer));
  if j0=1 then begin//Задан контур окна
    Index:=ImageInfos[0].ShapeIndexByCod(FrameCod);
    ImageInfos[0].SaveShape(Stream,Index,false);
  end;
  if SkinCodes[j0]=IndicatorCod then
    j1:=j0+1
  else
    j1:=j0;
  Stream.Write(j1,SizeOf(integer));
  if j1=j0+1 then begin //Задан прямоугольник индикатора
    Index:=ImageInfos[0].ShapeIndexByCod(IndicatorCod);
    ImageInfos[0].SaveShape(Stream,Index,false);
    Index:=ImageInfos[0].ShapeIndexByCod(IndResCod);
    ImageInfos[0].SaveShape(Stream,Index,false);
    Index:=ImageInfos[0].ShapeIndexByCod(IndTreeCod);
    ImageInfos[0].SaveShape(Stream,Index,false);

    Stream.Write(IndicatorColors[IndicatorCod],Length(IndicatorColors)*SizeOf(TColor));
    ImageInfos[0].SaveShape(Stream,ImageInfos[0].ShapeIndexByCod(Indicator1Cod),false);
    ImageInfos[0].SaveShape(Stream,ImageInfos[0].ShapeIndexByCod(IndRes1Cod),false);
    ImageInfos[0].SaveShape(Stream,ImageInfos[0].ShapeIndexByCod(IndTree1Cod),false);


//todo:Сохранить Контуры для индикаторов j1:=7 Сделать возможным не задавать прямоугольник дерева и результата, а выражение можно было вводить в TEdit
//    j1:=4;
    j1:=7;
  end;
  dec(n);
  for j:=j1 to n do begin
    Cod:=SkinCodes[j];
    Stream.Write(Cod,SizeOf(integer));
    for i:=0 to MaxBitMapIndex do begin
      Index:=ImageInfos[i].ShapeIndexByCod(Cod);
      ImageInfos[i].SaveShape(Stream,Index,i<>0);
    end;
  end;
end;

procedure TImageInfo.LoadFromStream(const Stream: TStream);
begin

end;

procedure TImageInfo.SaveToStream(const Stream: TStream;const
   SaveImages:boolean);
var
  n,i:integer;
  r:TRect;
  BitMapSize:integer;
  x,y:integer;
begin
  n:=Length(Shapes);
  Stream.Write(n,SizeOf(Integer));
  dec(n);
  for i:=0 to n do
    SaveShape(Stream,i,SaveImages);
end;

function TImageInfo.ShapeIndexByCod(Cod:integer): integer;
var
  n,i:integer;
begin
  n:=Length(Shapes)-1;
  for i:=0 to n do if Shapes[i].Cod=Cod then begin
    result:=i;
    exit;
  end;

  Raise Exception.Create('Не найден контур с кодом '+IntToStr(Cod));
end;

procedure TImageInfo.SaveShape(const Stream:TStream; const i:integer;
  const SaveImage:boolean);
var
  r:TRect;
  BitMapSize:integer;
  x,y:integer;
begin
  if SaveImage then begin
    r:=Shapes[i].GetBoundedRect;
    BitMap.Width:=Abs(r.Left-r.Right)+1;
    BitMap.Height:=Abs(r.Top-r.Bottom)+1;
    x:=Min(r.Left,r.Right);
    y:=Min(r.Top,r.Bottom);
    BitMap.Canvas.Draw(-x,-y,BitMap1);
    MemoryStream.SetSize(0);
    BitMap.SaveToStream(MemoryStream);
    BitMap.SaveToFile('c:\a.bmp');
    BitMapSize:=MemoryStream.Size;
    Stream.Write(BitMapSize,SizeOf(integer));
    Stream.Write(MemoryStream.Memory^,BitMapSize);
  end;
  Shapes[i].SaveToStream(Stream);
end;

function CompareInteger(P1,P2:Pointer):boolean;
begin
  result:=PInteger(P1)^>PInteger(P2)^
end;

function TMainForm.GetShapeCodes: TIntegerArray;
var
  n,i:integer;
  a:TPointerArray;
  t:TIntegerArray;
begin
  n:=Length(ImageInfos[0].Shapes);
  SetLength(result,n);
  SetLength(a,n);
  SetLength(t,n);
  dec(n);
  for i:=0 to n do begin
    t[i]:=ImageInfos[0].Shapes[i].Cod;
    a[i]:=@t[i];
  end;
  QSort(a,CompareInteger);
  for i:=0 to n do begin
    result[i]:=PInteger(a[i])^;
    if i>0 then if result[i]=result[i-1] then
      Raise Exception.Create('Код '+ IntToStr(result[i])+' повторяется дважды');
  end;
end;

procedure TMainForm.N5Click(Sender: TObject);
begin
  SpeedButton10Click(nil);
  SpeedButton8Click(nil);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
//  FileName:='C:\Work\Calc\Skins\dragon.skp';
//  FileName:='C:\Work\Calc\Skins\New1\Ready\dragon.skp';
//  FileName:='C:\Work\Calc\Skins\New1\Ready\Proj.skp';
//  FileName:='C:\Work\Calc\Skins\New1\Ready\Proj2.skp';
  LoadOptions(ExtractFilePath(Application.ExeName)+OptFn);
  if Loadlastproject1.Checked then
    LoadProjectFromTextFile(ProjectName);
end;

procedure TMainForm.SetSkinEdited(const Value: boolean);
begin
  FSkinEdited := Value;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  r:word;
begin
  if SkinEdited then begin
    r:=MessageDlg('Save skin file?',mtConfirmation,mbYesNoCancel,0);
    if r=mrYes then
      SaveProjectToTextFile(ProjectName)
    else if r=mrCancel then
      Action:=caNone;
  end;
  SaveOptions(ExtractFilePath(Application.ExeName)+OptFn);
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
  if ProjectName<>'' then
    SaveProjectToTextFile(ProjectName);
end;

procedure TMainForm.ExpressionField1Click(Sender: TObject);
begin
  ColorDialog1.Color:=ExpressionFieldColor;
  if ColorDialog1.Execute then begin
    ExpressionFieldColor:=ColorDialog1.Color;
    SkinEdited:=true;
    RefreshImage(0);
  end;
end;

procedure TMainForm.SetExpressionFieldColor(const Value: TColor);
begin
  IndicatorColors[IndicatorCod]:=Value;
end;

function TImageInfo.ShapeByCode(const Code: integer): TShape;
begin
  Result:=Shapes[ShapeIndexByCod(Code)];

end;

procedure TMainForm.FillRegion(Code: integer; Color: TColor);
var
  Rgn:HRGN;
  Region:TRegInfo;
  Brush:HBRUSH ;
  a:boolean;
  c:integer;
  r:TIntPolygon;
begin
  Region:=ImageInfos[0].ShapeByCode(IndicatorCod).AsRegInfo;
  Rgn:=CreateRegion(Region);
  try
    Brush := CreateSolidBrush(Color);
    a:=FillRgn(BackgroundPB.Canvas.Handle,Rgn,Brush);
    DeleteObject(Brush);
  finally
    DeleteObject(Rgn);
  end;
end;

procedure TMainForm.SetIndRes(const Value: TColor);
begin
  IndicatorColors[IndResCod] := Value;
end;

procedure TMainForm.SetIndTree(const Value: TColor);
begin
  IndicatorColors[IndTreeCod] := Value;
end;

function TMainForm.GetExpressionFieldColor: TColor;
begin
  Result:=IndicatorColors[IndicatorCod];
end;

function TMainForm.GetIndRes: TColor;
begin
  Result:=IndicatorColors[IndResCod];
end;

function TMainForm.GetIndTree: TColor;
begin
  Result:=IndicatorColors[IndTreeCod];
end;

procedure TMainForm.RefreshImage(Index: integer);
begin
  ImageInfos[Index].DrawBitMap2;
  ImageInfos[Index].DrawBitMap3;
  Draw(Index);
end;

procedure TMainForm.ResultField1Click(Sender: TObject);
begin
  ColorDialog1.Color:=IndResColor;
  if ColorDialog1.Execute then begin
    IndResColor:=ColorDialog1.Color;
    SkinEdited:=true;
    RefreshImage(0);
  end;
end;

procedure TMainForm.FunctionTree1Click(Sender: TObject);
begin
  ColorDialog1.Color:=IndTreeColor;
  if ColorDialog1.Execute then begin
    IndTreeColor:=ColorDialog1.Color;
    SkinEdited:=true;
    RefreshImage(0);
  end;
end;

procedure TMainForm.LoadOptions(FileName: TFileName);
var
  f:TextFile;
  a:string;
begin
  AssignFile(f,FileName);
  Reset(f);
  try
    ReadLn(f,a);
    ReadLn(f,FProjectName);
    Loadlastproject1.Checked:=a='TRUE';
  finally
    CloseFile(f);
  end;
end;

procedure TMainForm.SaveOptions(FileName: TFileName);
var
  f:TextFile;
  a:boolean;
begin
  AssignFile(f,FileName);
  Rewrite(f);
  try
    a:=Loadlastproject1.Checked;
    Writeln(f,a);
    Writeln(f,FProjectName);
  finally
    CloseFile(f);
  end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.SpeedButton4Click(Sender: TObject);
begin
  if ProjectName<>'' then
    SaveProjectToTextFile(ProjectName);
end;

end.
