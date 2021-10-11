unit Skintypes;

interface
uses
  windows,grMath,Graphics;
const
  shCircle=0;//Круг
  shEllipse=1;//Эллипс
  shRectangle=2;//Прямоугольник
  shRoundRectangle=3;//Закругленный прямоугольник
  shPolygon=4;//Многоугольник

  mdNoOperation=-1;
  mdAddPoint=1;
  mdDeletePoint=2;
  mdInsertPoint=3;
  mdMovePoint=4;
  mdMoveFigure=5;
  mdSelectFigure=6;
  mdSelectPoint=7;
type
  TIntPolygon=array of TPoint;

  TMemBitMap=array of byte;

  TButtonRegion=TIntPolygon;

  TCustomPressCalcButton=procedure (Cod:integer);
  TRegInfo=record
    ShapeType:integer;
    BoundedRect:TRect;
    Region:TButtonRegion;
  end;

  TIndInfo=record
    ShapeType:integer;
    BoundedRect:TRect;
    Region:TButtonRegion;
    Color:TColor;
  end;

  TButtonInfo=record
    Cod:integer;
    FindRegion:TRegInfo;
    DisableRegion:TRegInfo;
    LightRegion:TRegInfo;
    SelectRegion:TRegInfo;
    DisableBitMap:TBytes;
    LightBitMap:TBytes;
    SelectBitMap:TBytes;
  end;

  TButtonInfos=array of TButtonInfo;

  TIndicators=array of TIndInfo;


function GetBoundedRect(const ButtonRegion:TButtonRegion):TRect;
implementation

uses Types;

function GetBoundedRect(const ButtonRegion:TButtonRegion):TRect;
var
  i,n:integer;
  MinX,MaxX,MinY,MaxY:integer;
begin
  n:=Length(ButtonRegion)-1;
  with ButtonRegion[0] do begin
    MinX:=x;
    MaxX:=x;
    MinY:=y;
    MaxY:=y;
  end;
  for i:=1 to n do with ButtonRegion[i] do  begin
    if MinX>x then
      MinX:=x
    else if MaxX<x then
      MaxX:=x;
    if MinY>y then
      MinY:=y
    else if MaxY<y then
      MaxY:=y;
  end;
  with Result do begin
    Left:=MinX;
    Top:=MinY;
    Right:=MaxX;
    Bottom:=MaxY;
  end;
end;

end.
 