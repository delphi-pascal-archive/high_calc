unit grMath;
interface
uses windows,Classes,Math,SysUtils,Graphics,Mesagi,Gpmath;
const
  GedFileExt='.GED';
  TracerFileExt='.TRS';
  HoleCod=4001;
  GrfComPrefix=$2A;
type
  PRect=^TRect;
  TGrfMetrics=array of PPoint;
  TGrfMetricsArr=array[0..0] of PPoint;
  PGrfMetricsArr=^TGrfMetricsArr;
  TVariantArrayData=array[0..200] of variant;
  PVariantArrayData=^TVariantArrayData;
  PLongWord=^LongWord;
  TByteArr4=array[0..3] of byte;
  PByteArr4=^TByteArr4;
  TIntegerArray=array of integer;
  THoleSizes=TIntegerArray;
  TConnectCods=array of byte;
TSector=record
  Angle1,Angle2,Radius,Xc,Yc:double;
end;
TLayerAttributes=record
  Draw:boolean;
  Find:boolean;
  Edit:boolean;
  DeleteSymbols:boolean;
  UseLayerColor:boolean;
  ShowMetrics:boolean;
end;
  TGrfCommand=procedure(var Position:integer) of object;
  TGrfCommandsArray=array[$00..$99] of TGrfCommand;
TColors=array of TColor;  
TRescaleXY=procedure (var x,y:double) of object;
TRescaleProcs=array of TRescaleXY;
TIntArr=array[0..100] of byte;
//ByteArr=array of byte;
TBytes=array of byte;
PByteArr=^TIntArr;
HachCellNums=array of integer;//Номера хэш клеток
TSymbolListUnit=record
   SymbolNum:integer;
   Dist:integer;
   Angle:integer;
end;
TRefreshProc=procedure of object;
SymListArr=array of TSymbolListUnit;
TLine=record
     x1,y1,x2,y2:integer;
end;
TRealLine=record
     x1,y1,x2,y2:double;
end;
TShortPoint=record
     x,y:SmallInt;
end;
TRealPoint=record
  x,y:double;
end;
TQuadrangle=record
  p1,p2,p3,p4:TPoint;
end;
TRealQuadrangle=record
  p1,p2,p3,p4:TRealPoint;
end;
TRealRect=record
  Left,Top,Right,Bottom:double;
end;
PRealRect=^TRealRect;
CRealRect=class
  private
    FY1: double;
    FX2: double;
    FHeight: double;
    FWidth: double;
    FX1: double;
    FY2: double;
    FLeft: double;
    FRight: double;
    FTop: double;
    FBottom: double;
    procedure SetHeight(const Value: double);
    procedure SetWidth(const Value: double);
    procedure SetX1(const Value: double);
    procedure SetX2(const Value: double);
    procedure SetY1(const Value: double);
    procedure SetY2(const Value: double);
    procedure SetBottom(const Value: double);
    procedure SetLeft(const Value: double);
    procedure SetRight(const Value: double);
    procedure SetTop(const Value: double);

public
  property Left:double read FLeft write SetLeft;
  property Top:double read FTop write SetTop;
  property Right:double read FRight write SetRight;
  property Bottom:double read FBottom write SetBottom;
  property X1:double read FX1 write SetX1;
  property Y1:double read FY1 write SetY1;
  property X2:double read FX2 write SetX2;
  property Y2:double read FY2 write SetY2;
  property Width:double read FWidth write SetWidth;
  property Height:double read FHeight write SetHeight;
end;
TGeoPoint=TRealPoint;
PGeoPoint=^TGeoPoint;
TGeoPoints=array of TGeoPoint;
TGeoPointArr=array[0..1000] of TGeoPoint;
PGeoPointArr=^TGeoPointArr;
TMetrics=PGeoPointArr;
TRealRectArr=array of TRealRect;
TPointArr=array[0..1000] of TPoint;
PPointArr=^TPointArr;
TIntegerMetrics=PPointArr;
TPointArrArr=array[0..0] of PPointArr;
PPointArrArr=^TPointArrArr;
IntArr=array[0..0] of integer;
PIntArr=^IntArr;
THoles=array of TPoint;
TRealHoles=array of TGeoPoint;
PointArr=class
 private
   InternalBuf:PPointArr;
   BufLen:integer;
   MinY,MinX,Res:double;
   NotFree:boolean;
   function GetPoint(Index: integer): TPoint;
   procedure SetPoint(Index: integer; const Value: TPoint);
   function GetX(Index: integer): integer;
   function GetY(Index: integer): integer;
   procedure SetX(Index: integer; const Value: integer);
   procedure SetY(Index: integer; const Value: integer);
 public
   Scale:double;
   property Points[Index:integer]:TPoint read GetPoint write SetPoint;default;
   property x[Index:integer]:integer read GetX write SetX;
   property y[Index:integer]:integer read GetY write SetY;
   procedure SetLength(n:integer);
   procedure SetXY(Index: integer; const x,y: integer);
   procedure SetConvXY(Index: integer; x,y: double);
   function Length:integer;
   function GetBufAdr:PPointArr;
   procedure SetBuf(BufAdr:PPointArr;Len:integer);
   procedure CopyBuf(BufAdr:PPointArr;Len:integer);
   constructor Create(n:Integer);overload;
   constructor Create(n:Integer;XMin,YMin,Resolution:double);overload;
   destructor Destroy; override;
end;
RealPointArr=array of TRealPoint;
TRealPointArr=array of TRealPoint;
TPolygons=array of TRealPointArr;
TPolyPolygons=array of TPolygons;
PolyLineArr=array of PointArr;
TIntPointArr=array of TPoint;
IntPolyLineArr=array of TIntPointArr;
RealPolyLineArr=array of RealPointArr;
TPolyPolygon=class
private
   InternalBuf:PPointArrArr;
   PolyCount:integer;
   PolyPointsCount:PIntArr;
   FreeBufs:boolean;
public
   procedure AddPolygon(Pol:PointArr);
   procedure AddPolygons(Pol:PointArr;PointCount:array of integer);
   procedure GetIntPolyLineArr(var PolyArr:IntPolyLineArr);
   function IsPtInPoly(P:TPoint):boolean;
   function GetBoundedRect:TRect;
   procedure GetInternalBufs(var IntrlBuf:PPointArrArr; var PolyCnt:integer;
                                                   var PolPointCnt:PIntArr);
   procedure SetInernalBufs(InternalBuf:PPointArrArr;PolyCount:integer;
                                                    PolyPointsCount:PIntArr);
   procedure MinMax(var X1,Y1,X2,Y2:double);
   constructor Create;
   destructor Destroy; override;
//   function IsPtInPoly(p:TPoint):boolean;
end;

GrfMCom=procedure(XYBuf:PointArr);
TInternalFormirovalkaGrfa=function(HoleSizes:THoleSizes;const Metrics:PPointArr;
             const MetricsSize:integer; ConnectCods:PByteArr; TextLen:integer;
       const Text:PChar;ObjNum,SymCod:integer;GrfBuf:PByteArr;GrfSize:integer):boolean;

const
    Epsilon:double=1e-100;
    BigValue=1e100;
    crMyCursor=5;
    crGeoCursor=crMyCursor;
    crMoveHand=6;
    crMoveDownHand=7;

    MaxDouble:double=1.7E308;
function Revert(var x : Integer):Integer;overload;
function Revert(var x : SmallInt):SmallInt;overload;
procedure GeoMetricsToIntMetrics(Metrics:TMetrics;
    IntegerMetrics:TIntegerMetrics;MetricsSize:integer);
function BoolToStr(value:boolean):string;
function StrToBool(value:string):boolean;
function IntRect(R:TRealRect):TRect;
procedure MinMax(var X1,Y1,X2,Y2:double;L:TLine);
procedure IntPolyToReal(IntPoly:PointArr;var RealPoly:RealPointArr);
procedure PolyLineArrToIntPolyLineArr(S:PolyLineArr;var D:IntPolyLineArr);
function ShiftRect(R:TRealRect;x,y:double):TRealRect;overload;
function ShiftRect(R:TRect;x,y:integer):TRect;overload;

procedure ShiftPolygon(Points:PPointArr;PointCount:integer;dx,dy:integer);overload;
procedure ShiftPolygon(Points:TGrfMetrics;PointCount:integer;dx,dy:integer);overload;
procedure ShiftPolygon(Points:TMetrics;PointCount:integer;dx,dy:double);overload;

procedure ShiftSubPolygon(Points:PPointArr;FirstPoint,PolyPointCount,
      PointCount:integer;dx,dy:integer);overload;

procedure ShiftSubPolygon(Points:TMetrics;FirstPoint,PolyPointCount,
      PointCount:integer;dx,dy:double);overload;

procedure RotatePolygon(Points:PPointArr;PointCount:integer;Xc,Yc:integer;
                        SinA,CosA:double);overload;
procedure RotatePolygon(Points:TGrfMetrics;PointCount:integer;Xc,Yc:integer;
                        SinA,CosA:double);overload;

procedure RotatePolygon(Points:TMetrics;PointCount:integer;Xc,Yc:double;
                        SinA,CosA:double);overload;

procedure NormalizeRect(var Rect:TRect);
procedure Exchange (var v1,v2:integer);
procedure InitRect(var Rect:TRect);
function IsLineInRect(const L:TLine;R:TRect):boolean;overload;
function IsLineInRect (var L:TRealLine;R:TRealRect):boolean;overload;
{function IsArcInRect(x1,y1,x2,y2,x3,y3,x4,y4:integer;
                                            R:TRect;positive:boolean):boolean;}
function IsRectInRect (R1,R2:TRealRect):boolean;overload;// R1 в R2
function IsRectInRect (R1,R2:TRect):boolean;overload;// R1 в R2
function IsFullRectInRect (R1,R2:TRect):boolean;overload;// R1 в R2
function IsCrossRect(R1,R2:TRealRect):boolean;overload;
function IsCrossRect(R1,R2:TRect):boolean;overload;

function IsPtInRect(x,y:double;R:TRealRect):boolean;overload;
function IsPtInRect(x,y:double;R:TRect):boolean;overload;
function IsPtInRect(const Point:TPoint;const R:TRect):boolean;overload;
procedure SwapInt(var a,b:integer);
function ClipLine(var L:TLine;R:TRect):boolean;
function OutCode(p:TPoint;r:TRect):byte;overload;
function OutCode(x,y:double;r:TRealRect):byte;overload;
function PtInPoly (Pt:TPoint; Pol:array of TPoint):boolean;overload;
function PtInPoly (Pt:TRealPoint; Pol:RealPointArr):boolean;overload;
function IsPolyInPoly(PolIn,Pol:RealPointArr):boolean;
function Equal(x,y:extended):boolean;
function OrtoLineK (Line:TRealLine):double; overload;//Возвращает коэффициент наклона перпендикуляра
function OrtoLineK (P1,P2:TPoint):double; overload; //Возвращает коэффициент наклона перпендикуляра
function OrtoCrossPoint (Line:TRealLine;P:TRealPoint;var ResP:TRealPoint):boolean;
//Возвращает ResP-точку пересечения перпендикуляра и Line проходящего через P.
function Rect(Line:TRealLine):TRealRect;overload;
function Rect(Left,Top,Right,Bottom:integer):TRect;overload;
procedure RotatePoint(var x,y:double;XCenter,YCenter,CosA,SinA:double);
procedure RotateIntPoint(var x,y:integer;XCenter,YCenter,CosA,SinA:double);
procedure RotatePoly(var PArr:PointArr;XCenter,YCenter,CosA,SinA:double);
function RectInPoly(R:TRect):PointArr;
function CrossPoint(var L1,L2:TLine;var p:TPoint):boolean;overload;//Пересечение прямых
function CrossPoint(var L1,L2:TRealLine;var p:TRealPoint):boolean;overload;//Пересечение прямых
function CrossPoint(k1,k2,a1,a2:double;var p:TRealPoint):boolean;overload;//Пересечение прямых
function OtrezokCrossPoint(var L1,L2:TLine;var p:TPoint):boolean;overload;//Пересечение отрезков
function OtrezokCrossPoint(var L1,L2:TRealLine;var p:TRealPoint):boolean;overload;//Пересечение отрезков
function RealRect(Left,Top,Right,Bottom:double):TRealRect;
procedure BoundedArcPolygon(x1,y1,x2,y2,x3,y3,x4,y4:integer;var Poly:PPointArr;
                            var PointCount:integer);
function IsArcInRect(x1,y1,x2,y2,x3,y3,x4,y4:integer;R:TRect):boolean;
function CreateLine(x1,y1,x2,y2:integer):TLine;
function PtInLine(p:TRealPoint;L:TRealLine):boolean;overload;
function PtInLine(p:TPoint;L:TLine):boolean;overload;
//Sin,Cos угла наклону и длина
function SinCosDist(var SinA,CosA,Dist:double;L:TRealLine):boolean;
function UnionRealRect(R1,R2:TRealRect):TRealRect;
function UnionRect(R1,R2:TRect):TRect;
//function GetBoundedRect(Rect:TRect):TRect;
function GetRotatedBoundedRect(Rect:TRect;Centr:TPoint;Angle:double):TRect;
function Ceil(v:double):integer;
function HeightOfRealRect(Rect:TRealRect):double;
function WidthOfRealRect(Rect:TRealRect):double;
function RoundUp(X: Extended): Int64;
function IsPtInPoly(Point:TPoint;AllPoints:THoles;Sizes:THoleSizes):boolean;
function IsPtInPolygon(Point:TPoint;AllPoints:THoles;Sizes:THoleSizes):boolean;
Function Determinant(P1,P2,P3 : TRealPoint):Extended;
Function Square(Polygon:RealPointArr):Extended;
function GrDistance(Point1,Point2:TRealPoint):extended;
function Orthogonal(p:TRealPoint;L:TRealLine;var CrossPt:TRealPoint):boolean;
function CreateRect(const Left,Top,Right,Bottom:integer):TRect;overload;
const
  GeoPointSize=sizeOf(TRealPoint);
  IntegerPointSize=sizeOf(TPoint);

implementation
uses
    FillPoly;
function PtInPoly (Pt:TPoint; Pol:array of TPoint):boolean;
var
   Count,i,n,j:integer;
   t:double;
begin
   n:=Length(Pol);
   Count:=0;
   for i:=0 to n-1 do
   begin
     j:=(i+1) mod n;
     if Pol[i].y = Pol[j].y then continue;
     if (Pol[i].y>Pt.y)and(Pol[j].y>Pt.y) then continue;
     if (Pol[i].y<Pt.y)and(Pol[j].y<Pt.y) then continue;
     if Min(Pol[i].y,Pol[j].y)=Pt.y then continue
     else begin
       t:= (Pt.y-Pol[i].y)/(Pol[j].y-Pol[i].y);
       if (t>=0) and (t<=1) then
         if Pol[i].x+t*(Pol[j].x-Pol[i].x)>=Pt.x then
           inc(Count);
     end;
   end;
   result:=(Count and 1)=1;
end;

function PtInPoly (Pt:TRealPoint; Pol:RealPointArr):boolean;
var
   Count,i,n,j:integer;
   t:double;
begin
   n:=Length(Pol);
   Count:=0;
   for i:=0 to n-1 do
   begin
      j:=(i+1) mod n;
      if Pol[i].y = Pol[j].y then continue;
      if (Pol[i].y>Pt.y)and(Pol[j].y>Pt.y) then continue;
      if (Pol[i].y<Pt.y)and(Pol[j].y<Pt.y) then continue;
      if Equal(Min(Pol[i].y,Pol[j].y),Pt.y) then continue
      else
      begin
         t:= (Pt.y-Pol[i].y)/(Pol[j].y-Pol[i].y);
         if (t>=0) and (t<=1) then
            if Pol[i].x+t*(Pol[j].x-Pol[i].x)>=Pt.x then
               inc(Count);
      end;
   end;
   result:=(Count and 1)=1;
end;

function IsPolyInPoly(PolIn,Pol:RealPointArr):boolean;
var
  i,j,k,l,m,n:integer;
  L1,L2:TRealLine;
  P:TRealPoint;
begin
//Необходимо ввести проверку пересечений
  result:=false;
  n:=Length(PolIn)-1;
  m:=Length(Pol)-1;
  for i:=0 to n do
  begin
    if PtInPoly(PolIn[i],Pol) then
    begin
      result:=true;
      exit;
    end;
    if (n>0)and(m>0) then
    begin
      j:=(i+1)mod n;
      L1.x1:=PolIn[i].x;
      L1.y1:=PolIn[i].y;
      L1.x2:=PolIn[j].x;
      L1.y2:=PolIn[j].y;
      for k:=0 to m do
      begin
        l:=(k+1)mod m;
        L2.x1:=Pol[k].x;
        L2.y1:=Pol[k].y;
        L2.x2:=Pol[l].x;
        L2.y2:=Pol[l].y;
        if OtrezokCrossPoint(L1,L2,P) then
        begin
          result:=true;
          exit;
        end;
      end;
    end;
  end;
end;

function IsLineInRect (const L:TLine;R:TRect):boolean;overload;
var
   Code1,Code2:byte;
   Inside,Outside:boolean;
   dx,dy:integer;
   k,a,x,y:double;
begin
   NormalizeRect(R);
   with L do
   begin
     Code1:=OutCode(Point(x1,y1),R);
     Code2:=OutCode(Point(x2,y2),R);
   end;
   Inside:=(Code1 or Code2) = 0;
   Outside:=(Code1 and Code2) <> 0;
   if not (Inside or Outside) then
   begin
      with L,R do
      begin
         dx:=x2-x1; dy:=y2-y1;
         if dx<>0 then
         begin
            k:=dy/dx; a:=y1-k*x1;
            y:=k*Left+a;
            if (y>=Top)and(y<=Bottom) then
            begin result := true; exit; end;
            y:=k*Right+a;
            if (y>=Top)and(y<=Bottom) then
            begin result := true; exit; end;
         end;
         if dy<>0 then
         begin
            k:=dx/dy; a:=x1-k*y1;
            x:=k*Top+a;
            if (x>=Left)and(x<=Right) then
            begin result := true; exit; end;
            x:=k*Bottom+a;
            if (x>=Left)and(x<=Right) then
            begin result := true; exit; end;
         end;
         result:=false;
         exit;
      end;
      Inside:=(Code1 or Code2) = 0;
   end;
   result := Inside;
end;

function IsLineInRect (var L:TRealLine;R:TRealRect):boolean;overload;
var
   Code1,Code2:byte;
   Inside,Outside:boolean;
   dx,dy:double;
   k,a,x,y:double;
begin
   with L do
   begin
     Code1:=OutCode(x1,y1,R);
     Code2:=OutCode(x2,y2,R);
   end;
   Inside:=(Code1 or Code2) = 0;
   Outside:=(Code1 and Code2) <> 0;
   if not (Inside or Outside) then
   begin
      with L,R do
      begin
         dx:=x2-x1; dy:=y2-y1;
         if dx<>0 then
         begin
            k:=dy/dx; a:=y1-k*x1;
            y:=k*Left+a;
            if (y>=Top)and(y<=Bottom) then
            begin result := true; exit; end;
            y:=k*Right+a;
            if (y>=Top)and(y<=Bottom) then
            begin result := true; exit; end;
         end;
         if dy<>0 then
         begin
            k:=dx/dy; a:=x1-k*y1;
            x:=k*Top+a;
            if (x>=Left)and(x<=Right) then
            begin result := true; exit; end;
            x:=k*Bottom+a;
            if (x>=Left)and(x<=Right) then
            begin result := true; exit; end;
         end;
         result:=false;
         exit;
         //Code1:=OutCode(Point(x1,y1),R);
         //Code2:=OutCode(Point(x2,y2),R);
      end;
      Inside:=(Code1 or Code2) = 0;
   end;
   result := Inside;//Inside or not(Outside or Inside);
end;
{function IsArcInRect(x1,y1,x2,y2,x3,y3,x4,y4:integer;
                                        R:TRect;positive:boolean):boolean;
var
   a,b,c,d,e,f,g,dx,dy:double;
   xc,yc:integer;
begin
    a:=abs(x1-x2);
    b:=abs(y1-y2);
    xc:=(x1+x2) div 2;
    yc:=(y1+y2)div 2;
    R:=ShiftRect(R,-xc,-yc);
    with R do begin
       dy:=Top-Bottom;
       dx:=Right-Left;
       d:=dy*dy*a*a;
       c:=dx*dx/d;
       e:=c+1/(b*b);
       f:=(2*dx-Bottom*(2*Right*Right-4*Right))

    end;

end;}
function IsRectInRect (R1,R2:TRealRect):boolean;
begin
   with R1 do
      result:= IsPtInRect(Left,Top,R2) or IsPtInRect(Right,Top,R2) or
               IsPtInRect(Left,Bottom,R2) or IsPtInRect(Right,Bottom,R2);
end;
function IsRectInRect (R1,R2:TRect):boolean;
begin
   NormalizeRect(R1);
   NormalizeRect(R2);
   with R1 do
      result:= IsPtInRect(Left,Top,R2) or IsPtInRect(Right,Top,R2) or
               IsPtInRect(Left,Bottom,R2) or IsPtInRect(Right,Bottom,R2);
end;

function IsFullRectInRect (R1,R2:TRect):boolean;
begin
   with R1 do
      result:= IsPtInRect(Left,Top,R2) and IsPtInRect(Right,Top,R2) and
               IsPtInRect(Left,Bottom,R2) and IsPtInRect(Right,Bottom,R2);
end;
function IsCrossRect(R1,R2:TRealRect):boolean;
begin
   result:=(IsRectInRect(R1,R2) or IsRectInRect(R2,R1)) or

       ((((R1.Left<=R2.Left)and(R1.Right>=R2.Right))and
       ((R2.Top<=R1.Top)and(R2.Bottom>=R1.Bottom))) or

       ((((R2.Left<=R1.Left)and(R2.Right>=R1.Right))and
       ((R1.Top<=R2.Top)and(R1.Bottom>=R2.Bottom)))));
end;
function IsCrossRect(R1,R2:TRect):boolean;
begin
   NormalizeRect(R1);
   NormalizeRect(R2);
   result:=(IsRectInRect(R1,R2) or IsRectInRect(R2,R1)) or

       ((((R1.Left<=R2.Left)and(R1.Right>=R2.Right))and
       ((R2.Top<=R1.Top)and(R2.Bottom>=R1.Bottom))) or

       ((((R2.Left<=R1.Left)and(R2.Right>=R1.Right))and
       ((R1.Top<=R2.Top)and(R1.Bottom>=R2.Bottom)))));
end;

function IsPtInRect(x,y:double;R:TRealRect):boolean;
begin
   with R do
     result:=((x>=Min(Left,Right)) and (x<=Max(Left,Right)))
       and ((y>=Min(Top,Bottom)) and (y<=Max(Top,Bottom)));
end;
function IsPtInRect(x,y:double;R:TRect):boolean;
begin
   with R do
     result:=(((x>=Left) and (x<=Right)) or ((x<=Left) and (x>=Right))) and
      (((y>=Top) and (y<=Bottom)) or ((y<=Top) and (y>=Bottom)));
end;

function IsPtInRect(const Point:TPoint;const R:TRect):boolean;overload;
begin
   with R,Point do
     result:=(((x>=Left) and (x<=Right)) or ((x<=Left) and (x>=Right))) and
      (((y>=Top) and (y<=Bottom)) or ((y<=Top) and (y>=Bottom)));
end;

procedure SwapInt(var a,b:integer);
var c:integer;
begin
   c:=a;a:=b;b:=c;
end;

procedure SwapByte(var a,b:byte);
var c:byte;
begin
   c:=a;a:=b;b:=c;
end;
function OutCode(p:TPoint;r:TRect):byte;overload;
begin
   result:=0;
   with p,r do
   begin
      if (x<Left) then result:=result or 1;
      if (y<Top) then result:=result or 2;
      if (x>Right) then result:=result or 4;
      if (y>Bottom) then result:=result or 8;
   end;
end;
function OutCode(x,y:double;r:TRealRect):byte;overload;
begin
   result:=0;
   with r do
   begin
      if (x<Left) then result:=result or 1;
      if (y<Top) then result:=result or 2;
      if (x>Right) then result:=result or 4;
      if (y>Bottom) then result:=result or 8;
   end;
end;

function ClipLine(var L:TLine;R:TRect):boolean;
var
   Code1,Code2:byte;
   Inside,Outside:boolean;
begin
   with L do
   begin
     Code1:=OutCode(Point(x1,y1),R);
     Code2:=OutCode(Point(x2,y2),R);
   end;
   Inside:=(Code1 or Code2) = 0;
   Outside:=(Code1 and Code2) <> 0;
   result := Inside or not(Outside or Inside);
   with L,R do
     while not(Inside or Outside) do
     begin
       if Code1=0 then
       begin
         SwapInt(x1,x2);
         SwapInt(y1,y2);
         Code1:=Code2;
       end;
       if (Code1 and 1) <>0 then
         y1:=y1+round((Left-x1)*(y2-y1)/(x2-x1))
       else if (Code1 and 2) <>0 then
         x1:=x1+round((Top-y1)*(x2-x1)/(y2-y1))
       else if (Code1 and 4) <>0 then
         y1:=y1+round((Right-x1)*(y2-y1)/(x2-x1))
       else if (Code1 and 8) <>0 then
         x1:=x1+round((Bottom-y1)*(x2-x1)/(y2-y1));
       Code1:=OutCode(Point(x1,y1),R);
       Code2:=OutCode(Point(x2,y2),R);
       Inside:=(Code1 or Code2) = 0;
       Outside:=(Code1 and Code2) <> 0;
     end;
end;
function OrtoLineK (Line:TRealLine):double;
begin
  with Line do
    result :=(x1-x2)/(y2-y1);
end;
function OrtoLineK (P1,P2:TPoint):double;//Возвращает коэффициент наклона перпендикуляра
begin
  result :=(P1.x-P2.x)/(P2.y-P1.y);
end;

function OrtoCrossPoint (Line:TRealLine;P:TRealPoint;var ResP:TRealPoint):boolean;
var
  k1,a1,k2,a2,dx:double;
begin
  dx:=Line.x1-Line.x2;
  if Abs(dx)>Epsilon then
    k1:=(Line.y1-Line.y2)/dx
  else begin //Вертикальная прямая
    ResP.x:=Line.x1;
    ResP.y:=P.y;
    with Line do
      result:=(ResP.y>Min(y1,y2))and(ResP.y<Max(y1,y2));
    exit;
  end;
  if k1<Epsilon then begin //Горизонтальная прямая
    ResP.x:=P.x;
    ResP.y:=Line.y1;
    with Line do
      result:=(ResP.x>Min(x1,x2))and(ResP.x<Max(x1,x2));
    exit;
  end;
  With Line do
    a1:=y1-k1*x1;
  k2:=-1/k1;
  a2:=P.y-k2*P.x;
  CrossPoint(k1,k2,a1,a2,ResP);
  result:=IsPtInRect(ResP.x,ResP.y,Rect(Line));
end;

procedure RotatePoint(var x,y:double;XCenter,YCenter,CosA,SinA:double);
var xx:double;
begin
  xx:=CosA*(x-XCenter)-
      SinA*(y-YCenter)+XCenter;
  y:=SinA*(x-XCenter)+
     CosA*(y-YCenter)+YCenter;
  x:=xx;
end;
procedure RotateIntPoint(var x,y:integer;XCenter,YCenter,CosA,SinA:double);
var xx:integer;
begin
  xx:=round(CosA*(x-XCenter)-
      SinA*(y-YCenter)+XCenter);
  y:=round(SinA*(x-XCenter)+
     CosA*(y-YCenter)+YCenter);
  x:=xx;
end;
procedure RotatePoly(var PArr:PointArr;XCenter,YCenter,CosA,SinA:double);
var
   i,n,xx:integer;
begin
   with PArr do begin
     n:=Length-1;
     for i:=0 to n do
     begin
        xx:=round(CosA*(x[i]-XCenter)-SinA*(y[i]-YCenter)+XCenter);
        y[i]:=round(SinA*(x[i]-XCenter)+CosA*(y[i]-YCenter)+YCenter);
        x[i]:=xx;
     end;
   end;
end;
function RectInPoly(R:TRect):PointArr;
begin
   result:=PointArr.Create(5);
   with result,R do begin
      x[0]:=Left;
      y[0]:=Top;
      x[1]:=Right;
      y[1]:=Top;
      x[2]:=Right;
      y[2]:=Bottom;
      x[3]:=Left;
      y[3]:=Bottom;
      x[4]:=Left;
      y[4]:=Top;
   end;
end;
//Точка пересечения прямых
function CrossPoint(var L1,L2:TLine;var p:TPoint):boolean;
var
    k1,k2,a1,a2,dx1,dx2,dy1,dy2,dk:double;
  function IsCross1:boolean;
  begin
    k2:=dy2/dx2;
    with L2 do a2:=y1-k2*x1;
    dk:=k1-k2;
    if Abs(dk)>Epsilon then
    begin
       with p do
       begin
          x:=round((a2-a1)/dk);
          y:=round(k1*x+a1);
       end;
       result:=true;
    end else
       result:=false;//Параллельные прямые
  end;
  function IsCross2:boolean;
  begin
    k1:=dx1/dy1;
    k2:=dx2/dy2;
    with L1 do a1:=x1-k1*y1;
    with L2 do a2:=x1-k2*y1;
    dk:=k1-k2;
    if Abs(dk)>Epsilon then
    begin
       with p do
       begin
          y:=round((a2-a1)/dk);
          x:=round(k1*x+a1);
       end;
       result:=true;
    end else
       result:=false;//Параллельные прямые
  end;
begin
     with L1 do begin
        dx1:=x2-x1;
        dy1:=y2-y1;
     end;
     with L2 do begin
        dx2:=x2-x1;
        dy2:=y2-y1;
     end;
     if Abs(dx1)>Epsilon then
     begin
       k1:=dy1/dx1;
       with L1 do a1:=y1-k1*x1;
       if Abs(dx2)>Epsilon then
         result:=IsCross1
       else //L2-вертикальная x=const или точка
       begin
          with p do
          begin
             x:=L2.x1;
             y:=round(k1*x+a1);
             result:=true;
          end;
       end;
     end else//L1-вертикальная или точка
     begin
        if Abs(dy1)>Epsilon then
        begin
           if Abs(dy2)>Epsilon then
             result:=IsCross2
           else//L2 горизонтальная y=const или точка
           begin
              if Abs(dx2)>Epsilon then
              with p do
              begin
                  x:=L1.x1;
                  y:=L2.y1;
                  result:=true;
              end else//L2 точка
              begin
                 with p do
                 begin
                    x:=L2.x1;
                    y:=L2.y1;
                    result:=PtInLine(p,L1);
                 end;
              end;
           end;
        end else//L1 точка
        begin
            with p do
            begin
                x:=L1.x1;
                y:=L1.y1;
                result:=PtInLine(p,L2);
            end;
        end;
     end;
end;

function CreateRect(const Left,Top,Right,Bottom:integer):TRect;
begin
  Result.Left:=Left;
  Result.Top:=Top;
  Result.Right:=Right;
  Result.Bottom:=Bottom;
end;

function OtrezokCrossPoint(var L1,L2:TLine;var p:TPoint):boolean;//Пересечение отрезков
var
   R1,R2:TRect;
begin
   R1:=CreateRect(min(L1.x1,L1.x2),min(L1.y1,L1.y2),max(L1.x1,L1.x2),max(L1.y1,L1.y2));
   R2:=CreateRect(min(L2.x1,L2.x2),min(L2.y1,L2.y2),max(L2.x1,L2.x2),max(L2.y1,L2.y2));
   result:=IsCrossRect(R1,R2);
   if result then begin
     if CrossPoint(L1,L2,p) then begin
        result:= IsPtInRect(p.x,p.y,R1)and IsPtInRect(p.x,p.y,R2)
     end else
        result:=false;
   end;
end;
function CrossPoint(k1,k2,a1,a2:double;var p:TRealPoint):boolean;overload;//Пересечение прямых
var
    dk:double;
begin
  dk:=k1-k2;
  if Abs(dk)>Epsilon then
  begin
    with p do
     begin
       x:=(a2-a1)/dk;
       y:=k1*x+a1;
     end;
     result:=true;
  end else
     result:=false;//Параллельные прямые
end;

function CrossPoint(var L1,L2:TRealLine;var p:TRealPoint):boolean;overload;
var
    k1,k2,a1,a2,dx1,dx2,dy1,dy2,dk:double;
  function IsCross1:boolean;
  begin
    k2:=dy2/dx2;
    with L2 do a2:=y1-k2*x1;
    dk:=k1-k2;
    if Abs(dk)>Epsilon then
    begin
       with p do
       begin
          x:=(a2-a1)/dk;
          y:=k1*x+a1;
       end;
       result:=true;
    end else
       result:=false;//Параллельные прямые
  end;
  function IsCross2:boolean;
  begin
    k1:=dx1/dy1;
    k2:=dx2/dy2;
    with L1 do a1:=x1-k1*y1;
    with L2 do a2:=x1-k2*y1;
    dk:=k1-k2;
    if Abs(dk)>Epsilon then
    begin
       with p do
       begin
          y:=(a2-a1)/dk;
          x:=k1*x+a1;
       end;
       result:=true;
    end else
       result:=false;//Параллельные прямые
  end;
begin
     with L1 do begin
        dx1:=x2-x1;
        dy1:=y2-y1;
     end;
     with L2 do begin
        dx2:=x2-x1;
        dy2:=y2-y1;
     end;
     if Abs(dx1)>Epsilon then
     begin
       k1:=dy1/dx1;
       with L1 do a1:=y1-k1*x1;
       if Abs(dx2)>Epsilon then
         result:=IsCross1
       else //L2-вертикальная x=const или точка
       begin
          with p do
          begin
             x:=L2.x1;
             y:=k1*x+a1;
             result:=true;
          end;
       end;
     end else//L1-вертикальная или точка
     begin
        if Abs(dy1)>Epsilon then
        begin
           if Abs(dy2)>Epsilon then
             result:=IsCross2
           else//L2 горизонтальная y=const или точка
           begin
              if Abs(dx2)>Epsilon then
              with p do
              begin
                  x:=L1.x1;
                  y:=L2.y1;
                  result:=true;
              end else//L2 точка
              begin
                 with p do
                 begin
                    x:=L2.x1;
                    y:=L2.y1;
                    result:=PtInLine(p,L1);
                 end;
              end;
           end;
        end else//L1 точка
        begin
            with p do
            begin
                x:=L1.x1;
                y:=L1.y1;
                result:=PtInLine(p,L2);
            end;
        end;
     end;
end;
function OtrezokCrossPoint(var L1,L2:TRealLine;var p:TRealPoint):boolean;overload;
var
   R1,R2:TRealRect;
begin
   R1:=RealRect(min(L1.x1,L1.x2),min(L1.y1,L1.y2),max(L1.x1,L1.x2),max(L1.y1,L1.y2));
   R2:=RealRect(min(L2.x1,L2.x2),min(L2.y1,L2.y2),max(L2.x1,L2.x2),max(L2.y1,L2.y2));
   result:=IsCrossRect(R1,R2);
   if result then begin
     if CrossPoint(L1,L2,p) then begin
        result:= IsPtInRect(p.x,p.y,R1)and IsPtInRect(p.x,p.y,R2)
     end else
        result:=false;
   end;
end;
function PtInLine(p:TRealPoint;L:TRealLine):boolean;
var
   dx,dy,a,k:double;
begin
   with L do begin
      dx:=x2-x1;
      dy:=y2-y1;
   end;
   if Abs(dx)>Epsilon then
   begin
      k:=dx/dy;
      with L do a:=x1-k*y1;
      with p do result:= abs(k*x+a-y)<Epsilon;
   end else //L вертикальная или точка
   begin
      if Abs(dy)>Epsilon then
      begin
          with p,L do result:=abs(x-x1)<Epsilon;
      end else//L точка
         with p,L do result:=(abs(x-x1)<Epsilon) and (abs(y-y1)<Epsilon);
   end;
end;
function PtInLine(p:TPoint;L:TLine):boolean;
var
   Pr:TRealPoint;
   Lr:TRealLine;
begin
    with Lr do begin
       x1:=L.x1;
       x2:=L.x2;
       y1:=L.y1;
       y2:=L.y2;
    end;
    with Pr do begin
       x:=P.x;
       y:=P.y;
    end;
    result:=PtInLine(Pr,Lr);
end;
procedure BoundedArcPolygon(x1,y1,x2,y2,x3,y3,x4,y4:integer;var Poly:PPointArr;
                            var PointCount:integer);
var
   xc,yc:integer;
   sq21,sq22:byte;
   Point1,Point2:TPoint;
   i,j:integer;
function GetRayDir(x,y:integer):byte;
begin
  result:=0;
  if (x<0) then result:=result or 1;
  if (y<0) then result:=result or 2;
end;
function GetPoint(i:integer):TPoint;
begin
  if i>4 then i:=i-4;
  with result do case i of
    1:begin x:=x1;y:=y1; end;
    2:begin x:=x1;y:=y2; end;
    3:begin x:=x2;y:=y2; end;
    4:begin x:=x2;y:=y1; end;
  end;
end;
//Точка на прямоугольнике описывающем эллипс
function GetRPoint(x,y:integer;var sq2:byte):TPoint;
var
   PointBuf:array[0..3] of TPoint;
   L1,L2:TLine;
   CrPt:TPoint;
   RayDir:byte;
begin
   L1:=CreateLine(xc,yc,x,y);
   RayDir:=GetRayDir(x,y);
   with CrPt do
     if RayDir=0 then begin //1-я четверть
       L2:=CreateLine(x1,y1,x2,y1);
       if CrossPoint(L1,L2,CrPt) then
          if (x>=x1) and (x<=x2) then begin
              sq2:=1;
              result:=CrPt;
              exit;
          end;
       L2:=CreateLine(x2,y2,x2,y1);
       if CrossPoint(L1,L2,CrPt) then
          if (y>=y1) and (y<=y2) then begin
              sq2:=4;
              result:=CrPt;
              exit;
          end;
       Raise Exception.Create(ElipsErr);
     end else if RayDir=1 then begin//2-я четверть
       L2:=CreateLine(x1,y1,x2,y1);
       if CrossPoint(L1,L2,CrPt) then
          if (x>=x1) and (x<=x2) then begin
              sq2:=1;
              result:=CrPt;
              exit;
          end;
       L2:=CreateLine(x1,y1,x1,y2);
       if CrossPoint(L1,L2,CrPt) then
          if (y>=y1) and (y<=y2) then begin
              sq2:=2;
              result:=CrPt;
              exit;
          end;
       Raise Exception.Create(ElipsErr);
     end else if RayDir=3 then begin//3-я четверть
       L2:=CreateLine(x1,y2,x2,y2);
       if CrossPoint(L1,L2,CrPt) then
          if (x>=x1) and (x<=x2) then begin
              sq2:=3;
              result:=CrPt;
              exit;
          end;
       L2:=CreateLine(x1,y1,x1,y2);
       if CrossPoint(L1,L2,CrPt) then
          if (y>=y1) and (y<=y2) then begin
              sq2:=2;
              result:=CrPt;
              exit;
          end;
       Raise Exception.Create(ElipsErr);
     end else if RayDir=2 then begin//4-я четверть
       L2:=CreateLine(x1,y2,x2,y2);
       if CrossPoint(L1,L2,CrPt) then
          if (x>=x1) and (x<=x2) then begin
              sq2:=3;
              result:=CrPt;
              exit;
          end;
       L2:=CreateLine(x2,y2,x2,y1);
       if CrossPoint(L1,L2,CrPt) then
          if (y>=y1) and (y<=y2) then begin
              sq2:=4;
              result:=CrPt;
              exit;
          end;
       Raise Exception.Create(ElipsErr);
     end;
   Raise Exception.Create(ElipsErr);
end;
begin
  xc:=(x1+x2) shr 1;
  yc:=(y1+y2) shr 1;
  Point1:=GetRPoint(x3,y3,sq21);
  Point2:=GetRPoint(x4,y4,sq22);
  if (abs(Point1.x-Point2.x)<epsilon) and (abs(Point1.y-Point2.y)<epsilon) then
  begin//Эллипс
     PointCount:=4;
     GetMem(Poly,PointCount*IntegerPointSize);
     Poly[0].x:=x1;
     Poly[0].y:=y1;
     Poly[1].x:=x1;
     Poly[1].y:=y2;
     Poly[2].x:=x2;
     Poly[2].y:=y2;
     Poly[3].x:=x2;
     Poly[3].y:=y1;
     exit;
  end;
  if sq22<sq21 then
      sq22:=sq22+4
  else if sq22=sq21 then begin
      if (sq21=1) and (Point1.x<Point2.x) or (sq21=3) and (Point1.x>Point2.x) or
      (sq21=2) and (Point1.y<Point2.y) or (sq21=4) and (Point1.y>Point2.y) then
           sq22:=sq22+4;
  end;
  PointCount:=3+sq22-sq21;
  GetMem(Poly,PointCount*IntegerPointSize);
  Poly[0].x:=xc;
  Poly[0].y:=yc;
  Poly[1]:=Point1;
  Poly[PointCount-1]:=Point2;
  j:=2;
  for i:=sq21 to sq22-1 do begin
      Poly[j]:=GetPoint(i);
      inc(j);
  end;
end;
function SinCosDist(var SinA,CosA,Dist:double;L:TRealLine):boolean;
var
   dx,dy:double;
begin
    with L do
    begin
       dx:=x2-x1;dy:=y2-y1;
    end;
    dist:=sqrt(dx*dx+dy*dy);
    if dist<Epsilon then
       result:=false
    else  begin
       SinA:=dy/Dist;
       CosA:=dx/Dist;
       result:=true;
    end;
end;

function IsArcInRect(x1,y1,x2,y2,x3,y3,x4,y4:integer;R:TRect):boolean;
var
   R1:TRect;
begin
   with R1 do begin
      Left:=min(x1,x2);
      Top:=min(y1,y2);
      Right:=max(x1,x2);
      Bottom:=max(y1,y2);
   end;
   result:=IsCrossRect(R1,R);
end;

procedure IntPolyToReal(IntPoly:PointArr;var RealPoly:RealPointArr);
var
   i,n:integer;
begin
   n:=IntPoly.Length;
   SetLength(RealPoly,n);
   dec(n);
   for i:=0 to n do with IntPoly.Points[i] do
   begin
      RealPoly[i].x:=x;
      RealPoly[i].y:=y;
   end;
end;
procedure PolyLineArrToIntPolyLineArr(S:PolyLineArr;var D:IntPolyLineArr);
var
   i,n,j,m:integer;
   Buf:PPointArr;
begin
   n:=length(s);
   SetLength(d,n);
   dec (n);
   for i:=0 to n do begin
       if s[i]=nil then continue;
       SetLength(d[i],s[i].Length);
//       Buf:=s[i].GetBufAdr;
//       Move(Buf,d[i],s[i].Length*SizeOf(TPoint));
       m:=s[i].Length-1;
       for j:=0 to m do
       begin
          d[i][j]:=s[i][j];
       end;
   end;
end;
function UnionRealRect(R1,R2:TRealRect):TRealRect;
begin
   with result do
   begin
      Left:=Min(R1.Left,R2.Left);
      Top:=Min(R1.Top,R2.Top);
      Right:=Max(R1.Right,R2.Right);
      Bottom:=Max(R1.Bottom,R2.Bottom);
   end;
end;
function UnionRect(R1,R2:TRect):TRect;
begin
   with result do
   begin
      Left:=Min(R1.Left,R2.Left);
      Top:=Min(R1.Top,R2.Top);
      Right:=Max(R1.Right,R2.Right);
      Bottom:=Max(R1.Bottom,R2.Bottom);
   end;
end;
function ShiftRect(R:TRealRect;x,y:double):TRealRect;
begin
   with result do
   begin
      Left:=r.Left+x;
      Right:=r.Right+x;
      Top:=r.Top+y;
      Bottom:=r.Bottom+y;
   end;
end;
function ShiftRect(R:TRect;x,y:integer):TRect;
begin
   with result do
   begin
      Left:=r.Left+x;
      Right:=r.Right+x;
      Top:=r.Top+y;
      Bottom:=r.Bottom+y;
   end;
end;

function GetRotatedBoundedRect(Rect:TRect;Centr:TPoint;Angle:double):TRect;
var
   x1,y1,x2,y2,x3,y3,x4,y4:double;
   CosA,SinA:double;
begin
   with Rect do
   begin
      x1:=Left;
      y1:=Top;
      x2:=Right;
      y2:=Top;
      x3:=Right;
      y3:=Bottom;
      x4:=Left;
      y4:=Bottom;
      CosA:=Cos(Angle);
      SinA:=Sin(Angle);
      RotatePoint(x1, y1, Centr.x, Centr.y, CosA, SinA);
      RotatePoint(x2, y2, Centr.x, Centr.y, CosA, SinA);
      RotatePoint(x3, y3, Centr.x, Centr.y, CosA, SinA);
      RotatePoint(x4, y4, Centr.x, Centr.y, CosA, SinA);
      with Result do
      begin
          Left:=round(Min(Min(x1,x2),Min(x3,x4)));
          Top:=round(Min(Min(y1,y2),Min(y3,y4)));
          Right:=round(Max(Max(x1,x2),Max(x3,x4)));
          Bottom:=round(Max(Max(y1,y2),Max(y3,y4)));
      end;
   end;
end;
function Ceil(v:double):integer;
begin
   result:=Trunc(v);
   if frac(v)>0 then
     inc (result);
end;
{ PointArr }

constructor PointArr.Create(n: Integer);
begin
   Scale:=1;
   NotFree:=false;
   if n<>0 then
       GetMem(InternalBuf,n*SizeOf(TPoint));
   BufLen:=n;
end;

procedure PointArr.CopyBuf(BufAdr: PPointArr; Len: integer);
begin
    if (BufLen>0) and not NotFree then
       FreeMem(InternalBuf,BufLen*SizeOf(TPoint));
    BufLen:=Len;
    GetMem(BufAdr,SizeOf(TPoint)*Len);
    Move(BufAdr,InternalBuf,SizeOf(TPoint)*Len);
    NotFree:=false;
end;

constructor PointArr.Create(n: Integer; XMin, YMin, Resolution: double);
begin
   Scale:=1;
   NotFree:=false;
   if n<>0 then
      GetMem(InternalBuf,n*SizeOf(TPoint));
   BufLen:=n;
   MinX:=XMin;
   MinY:=YMin;
   Res:=Resolution;
end;

destructor PointArr.Destroy;
begin
    if (BufLen>0) and not NotFree then
       FreeMem(InternalBuf,BufLen*SizeOf(TPoint));
    inherited Destroy;
end;

function PointArr.GetBufAdr: PPointArr;
begin
    result:=InternalBuf;
end;

function PointArr.GetPoint(Index: integer): TPoint;
begin
   result:=InternalBuf^[Index];
   with  result do begin
       x:=round(Scale*x);
       y:=round(Scale*y);
   end;
end;


function PointArr.GetX(Index: integer): integer;
begin
   result:=round(Scale*InternalBuf^[Index].x);
end;

function PointArr.GetY(Index: integer): integer;
begin
   result:=round(Scale*InternalBuf^[Index].y);
end;

function PointArr.Length: integer;
begin
   result:=BufLen;
end;

procedure PointArr.SetBuf(BufAdr: PPointArr; Len: integer);
begin
    if (BufLen>0) and not NotFree then
       FreeMem(InternalBuf,BufLen*SizeOf(TPoint));
    BufLen:=Len;
    InternalBuf:=BufAdr;
    NotFree:=true;
end;

procedure PointArr.SetConvXY(Index:integer; x, y: double);
var
   xi,yi:integer;
begin
    xi:=round((x-minX)*res);
    yi:=round((y-minY)*res);
    SetXY(Index,xi,yi);
end;

procedure PointArr.SetLength(n: integer);
var
   TempBuf:PPointArr;
   i,m:integer;
begin
    TempBuf:=InternalBuf;
    if n>0 then begin
       GetMem(InternalBuf,n*SizeOf(TPoint));
       m:=Min(BufLen,n)-1;
       for i:=0 to m do
          InternalBuf[i]:=TempBuf[i];
    end;
    if not NotFree and (BufLen>0) then
       FreeMem(TempBuf,BufLen*SizeOf(TPoint));
    BufLen:=n;
    NotFree:=false;
end;

procedure PointArr.SetPoint(Index: integer; const Value: TPoint);
begin
   InternalBuf^[Index]:=Value;
end;

procedure PointArr.SetX(Index: integer; const Value: integer);
begin
   InternalBuf^[Index].x:=Value;
end;

procedure PointArr.SetXY(Index: integer; const x, y: integer);
begin
    InternalBuf^[Index].x:=x;
    InternalBuf^[Index].y:=y;
end;

procedure PointArr.SetY(Index: integer; const Value: integer);
begin
   InternalBuf^[Index].y:=Value;
end;

{ TPolyPolygon }

procedure TPolyPolygon.AddPolygon(Pol: PointArr);
var
    i,n,m:integer;
    TempBuf:PPointArrArr;
    TempCount:PIntArr;
begin
   if not FreeBufs then
      raise Exception.Create('Невозможно добавить полигон');
   TempBuf:=InternalBuf;
   TempCount:=PolyPointsCount;
   n:=PolyCount;
   inc(PolyCount);
   GetMem(InternalBuf,PolyCount*SizeOf(PPointArr));
   Move(TempBuf,InternalBuf,n*SizeOf(PPointArr));
   FreeMem(TempBuf,n*SizeOf(PPointArr));
   GetMem(PolyPointsCount,PolyCount*SizeOf(integer));
   Move(TempCount,PolyPointsCount,n*SizeOf(integer));
   FreeMem(TempCount,n*SizeOf(integer));
   m:=Pol.Length;
   PolyPointsCount[n]:=m;//Число точек в добавляемом полигоне
   GetMem(InternalBuf[n],m*SizeOf(TPoint));
   dec(m);
   for i:=0 to m do
      InternalBuf[n][i]:=Pol[i];
end;

procedure TPolyPolygon.AddPolygons(Pol: PointArr;
  PointCount: array of integer);
var
    i,j,k,n,m:integer;
    TempBuf:PPointArrArr;
    TempCount:PIntArr;
    AddPolyCount:integer;
begin
  if not FreeBufs then
        raise Exception.Create('Невозможно добавить полигоны');
   AddPolyCount:=length(PointCount);//Число добавляемых полигонов
   TempBuf:=InternalBuf;
   TempCount:=PolyPointsCount;
   n:=PolyCount;
   inc(PolyCount,AddPolyCount);
   GetMem(InternalBuf,PolyCount*SizeOf(PPointArr));
   Move(TempBuf,InternalBuf,n*SizeOf(PPointArr));
   FreeMem(TempBuf,n*SizeOf(PPointArr));
   GetMem(PolyPointsCount,PolyCount*SizeOf(integer));
   Move(TempCount,PolyPointsCount,n*SizeOf(integer));
   FreeMem(TempCount,n*SizeOf(integer));
   i:=0;
   for k:=n to PolyCount-1 do begin//по добавляемым полигонам
      m:=PointCount[k-n];
      PolyPointsCount[k]:=m;//Число точек в добавляемом полигоне
      GetMem(InternalBuf[k],m*SizeOf(TPoint));
      dec(m);
      for j:=0 to m do begin
         InternalBuf[k][j]:=Pol[i];
         inc(i);
      end;
   end;
end;

constructor TPolyPolygon.Create;
begin
   FreeBufs:=true;
   InternalBuf:=nil;
   PolyCount:=0;
   PolyPointsCount:=nil;
end;

destructor TPolyPolygon.Destroy;
var
   i,n:integer;
begin
  if FreeBufs then begin
     n:=PolyCount-1;
     for i:=0 to n do
          FreeMem(InternalBuf[i],PolyPointsCount[i]*SizeOf(TPoint));
     FreeMem(InternalBuf,PolyCount*SizeOf(PPointArr));
     FreeMem(PolyPointsCount,PolyCount*SizeOf(integer));
  end;
end;

function TPolyPolygon.GetBoundedRect: TRect;
var
   i,n : integer;
begin
   with result do begin
     Left:=2000000000;
     Top:=-2000000000;
     Right:=-2000000000;
     Bottom:=2000000000;
     if PolyCount<1 then exit;
     n:=PolyPointsCount[0]-1;
     for i:=0 to n do begin
       if InternalBuf[0][i].x<Left then Left:=InternalBuf[0][i].x;
       if InternalBuf[0][i].x>Right then Right:=InternalBuf[0][i].x;
       if InternalBuf[0][i].y>Top then Top:=InternalBuf[0][i].y;
       if InternalBuf[0][i].y<Bottom then Bottom:=InternalBuf[0][i].y;
     end;
   end;
end;

procedure TPolyPolygon.GetInternalBufs(var IntrlBuf: PPointArrArr;
  var PolyCnt: integer; var PolPointCnt: PIntArr);
begin
   IntrlBuf:=InternalBuf;
   PolyCnt:=PolyCount;
   PolPointCnt:=PolyPointsCount;
end;

procedure TPolyPolygon.GetIntPolyLineArr(var PolyArr: IntPolyLineArr);
var
   i,j,n,m:integer;
begin
   n:=PolyCount-1;
   SetLength(PolyArr,PolyCount);
   for i:=0 to n do begin
      m:=PolyPointsCount[i]-1;
      SetLength(PolyArr[i],PolyPointsCount[i]);
      for j:=0 to m do
         PolyArr[i][j]:=InternalBuf[i][j];
   end;
end;

function TPolyPolygon.IsPtInPoly(P: TPoint): boolean;
var
    Pol:IntPolyLineArr;
begin
    GetIntPolyLineArr(Pol);
    result:=FillPoly.IsPtInPoly(P,Pol);
end;

procedure TPolyPolygon.MinMax(var X1, Y1, X2, Y2: double);
var
   i,j,n,m:integer;
begin
   n:=PolyCount-1;
   for i:=0 to n do begin
      m:=PolyPointsCount[i]-1;
      for j:=0 to m do begin
         with InternalBuf[i][j] do begin
              X1:=Min(X1,X);
              Y1:=Min(Y1,Y);
              X2:=Max(X2,X);          
              Y2:=Max(Y2,Y);
         end;
      end;
   end;
end;

procedure TPolyPolygon.SetInernalBufs(InternalBuf: PPointArrArr;
  PolyCount: integer; PolyPointsCount: PIntArr);
begin
     Self.InternalBuf:=InternalBuf;
     Self.PolyCount:=PolyCount;
     Self.PolyPointsCount:=PolyPointsCount;
     FreeBufs:=false;
end;

{ CRealRect }

procedure CRealRect.SetBottom(const Value: double);
begin
  FBottom := Value;
end;

procedure CRealRect.SetHeight(const Value: double);
begin
  FHeight := Value;
end;

procedure CRealRect.SetLeft(const Value: double);
begin
  FLeft := Value;
end;

procedure CRealRect.SetRight(const Value: double);
begin
  FRight := Value;
end;

procedure CRealRect.SetTop(const Value: double);
begin
  FTop := Value;
end;

procedure CRealRect.SetWidth(const Value: double);
begin
  FWidth := Value;
end;

procedure CRealRect.SetX1(const Value: double);
begin
  FX1 := Value;
end;

procedure CRealRect.SetX2(const Value: double);
begin
  FX2 := Value;
end;

procedure CRealRect.SetY1(const Value: double);
begin
  FY1 := Value;
end;

procedure CRealRect.SetY2(const Value: double);
begin
  FY2 := Value;
end;
procedure MinMax(var X1,Y1,X2,Y2:double;L:TLine);
begin
    X1:=Min(X1,L.X1);
    X1:=Min(X1,L.X2);
    Y1:=Min(Y1,L.Y1);
    Y1:=Min(Y1,L.Y2);
    X2:=Max(X2,L.X1);
    X2:=Max(X2,L.X2);
    Y2:=Max(Y2,L.Y1);
    Y2:=Max(Y2,L.Y2);
end;

procedure ShiftPolygon(Points:PPointArr;PointCount:integer;dx,dy:integer);
var
   i:integer;
begin
   dec(PointCount);
   for i:=0 to PointCount do
      with Points[i] do begin
          x:=x+dx;
          y:=y+dy;
      end;
end;

procedure ShiftSubPolygon(Points:PPointArr;FirstPoint,PolyPointCount,
   PointCount:integer;dx,dy:integer);
var
   i,j:integer;
begin
  j:=FirstPoint;
  for i:=1 to PointCount do begin
    if j>=PolyPointCount then
      j:=j-PolyPointCount;
    with Points[j] do begin
        x:=x+dx;
        y:=y+dy;
    end;
    inc(j);
  end;
end;

procedure ShiftSubPolygon(Points:TMetrics;FirstPoint,PolyPointCount,
      PointCount:integer;dx,dy:double);overload;
var
   i,j:integer;
begin
  j:=FirstPoint;
  for i:=1 to PointCount do begin
    if j>=PolyPointCount then
      j:=j-PolyPointCount;
    with Points[j] do begin
        x:=x+dx;
        y:=y+dy;
    end;
    inc(j);
  end;
end;

procedure ShiftPolygon(Points:TGrfMetrics;PointCount:integer;dx,dy:integer);
var
   i:integer;
begin
   dec(PointCount);
   for i:=0 to PointCount do
      with Points[i]^ do begin
          x:=x+dx;
          y:=y+dy;
      end;
end;

procedure ShiftPolygon(Points:TMetrics;PointCount:integer;dx,dy:double);overload;
var
   i:integer;
begin
  dec(PointCount);
  for i:=0 to PointCount do
     with Points[i] do begin
         x:=x+dx;
         y:=y+dy;
     end;
end;

procedure RotatePolygon(Points:PPointArr;PointCount:integer;Xc,Yc:integer;
                        SinA,CosA:double);
var
   i,xx:integer;
begin
   dec(PointCount);
   for i:=0 to PointCount do
      with Points[i] do begin
            xx:=round(CosA*(x-XC)-SinA*(y-YC)+XC);
            y:=round(SinA*(x-XC)+CosA*(y-YC)+YC);
            x:=xx;
      end;
end;

procedure RotatePolygon(Points:TMetrics;PointCount:integer;Xc,Yc:double;
                        SinA,CosA:double);
var
   i,xx:integer;
begin
   dec(PointCount);
   for i:=0 to PointCount do
      with Points[i] do begin
            xx:=round(CosA*(x-XC)-SinA*(y-YC)+XC);
            y:=round(SinA*(x-XC)+CosA*(y-YC)+YC);
            x:=xx;
      end;
end;

procedure RotatePolygon(Points:TGrfMetrics;PointCount:integer;Xc,Yc:integer;
                        SinA,CosA:double);
var
   i,xx:integer;
begin
   dec(PointCount);
   for i:=0 to PointCount do
      with Points[i]^ do begin
            xx:=round(CosA*(x-XC)-SinA*(y-YC)+XC);
            y:=round(SinA*(x-XC)+CosA*(y-YC)+YC);
            x:=xx;
      end;
end;

procedure InitRect(var Rect:TRect);
begin
   with Rect do begin
       Left:=High(Integer);
       Right:=Low(Integer);
       Bottom:=High(Integer);
       Top:=Low(Integer);
   end;
end;
function CreateLine(x1,y1,x2,y2:integer):TLine;
begin
  result.x1:=x1;
  result.y1:=y1;
  result.x2:=x2;
  result.y2:=y2;
end;
function IntRect(R:TRealRect):TRect;
begin
  with r do begin
     result.Left:=round(Left);
     result.Top:=round(Top);
     result.Right:=round(Right);
     result.Bottom:=round(Bottom);
  end;
end;
function HeightOfRealRect(Rect:TRealRect):double;
begin
  with Rect do
     result:=abs(Top-Bottom);
end;
function WidthOfRealRect(Rect:TRealRect):double;
begin
  with Rect do
     result:=abs(Left-Right);
end;
function RoundUp(X: Extended): Int64;
begin
  result:=Trunc(x);
  if Frac(x)>1e-10 then
    inc(result);
end;
function IsPtInPoly(Point:TPoint;AllPoints:THoles;Sizes:THoleSizes):boolean;
var
   Polygons:IntPolyLineArr;
   i,n,PointCount:integer;
begin
  n:=Length(Sizes)-1;
  SetLength(Polygons,n+1);
  PointCount:=0;
  for i:=0 to n do begin
     SetLength(Polygons[i],Sizes[i]);
     Move(AllPoints[PointCount],Polygons[i][0],Sizes[i]*SizeOf(TPoint));
     Inc(PointCount,Sizes[i]);
  end;
{  m:=Length(AllPoints)-PointCount;
  SetLength(Polygons[n+1],m);
  Move(AllPoints[PointCount],Polygons[n+1][0],m*SizeOf(TPoint));}
  result:=FillPoly.IsPtInPoly(Point,Polygons);
end;
procedure Exchange (var v1,v2:integer);
var
  v:integer;
begin
  v:=v2;
  v2:=v1;
  v1:=v;
end;
procedure NormalizeRect(var Rect:TRect);
begin
  with Rect do begin
    if Left>Right then
       Exchange(Left,Right);
    if Bottom<Top then
       Exchange(Bottom,Top)
  end;
end;
Function Determinant(P1,P2,P3 : TRealPoint):Extended;
begin
 result:=
  P1.X*P2.Y+P3.X*P1.Y+P2.X*P3.Y-
  P3.X*P2.Y-P2.X*P1.Y-P1.X*P3.Y;
end;
Function  Square(Polygon:RealPointArr):Extended;
var I : Integer; S : Extended;
    P : TRealPoint;
    Count : integer;
begin
  P:=Polygon[0];
  Count := Length(Polygon)-2;
  S:=0;
  For I:=1 to Count do begin
    S:=S+Determinant(P,Polygon[I],Polygon[I+1]);
  end;
  result:=0.5*S;
end;
function Equal(x,y:extended):boolean;
begin
  result:=abs(x-y)<Epsilon;
end;
function RealRect(Left,Top,Right,Bottom:double):TRealRect;
begin
  result.Left:=Left;
  result.Top:=Top;
  result.Right:=Right;
  result.Bottom:=Bottom;
end;
function BoolToStr(value:boolean):string;
begin
  if value then
    result:='true'
  else
    result:='false'
end;
function StrToBool(value:string):boolean;
begin
  value:=trim(LowerCase(value));
  if value='true' then
    result:=true
  else if value='false' then
    result:=false
  else
    Raise Exception.Create(value+' is not boolean')
end;

function GrDistance(Point1,Point2:TRealPoint):extended;
begin
  result:=sqrt(sqr(Point1.x-Point2.x)+sqr(Point1.y-Point2.y));
end;
function Orthogonal(p:TRealPoint;L:TRealLine;var CrossPt:TRealPoint):boolean;
var
  a1,a2,k1,k2,dx,dy:double;
begin
  result:=false;
  dx:=L.x1-L.x2;
  dy:=L.y1-L.y2;
  if abs(dx)<Epsilon then
    k1:=BigValue
  else
    k1:=dy/dx;
  a1:=L.y1-k1*L.x1;
  if abs(k1)>Epsilon then
    k2:=-1/k1
  else
    k2:=-BigValue;
  a2:=-k2*p.x+p.y;
  if CrossPoint(k1,k2,a1,a2,CrossPt) then
    result:=IsPtInRect(p.x,p.y,RealRect(min(l.x1,l.x2),min(l.y1,l.y2),
                                        max(l.x1,l.x2),max(l.y1,l.y2)))
  else
    Raise Exception.Create('Неизвестная ошибка в GrMath.Orthogonal');
end;
function IsPtInPolygon(Point:TPoint;AllPoints:THoles;Sizes:THoleSizes):boolean;
var
  Polygons:IntPolyLineArr;
  i,n,PointCount:integer;
begin
  result:=false;
  n:=Length(Sizes)-1;
  if n<0 then
    exit;
  SetLength(Polygons,n+1);
  PointCount:=0;
  for i:=0 to n do begin
     SetLength(Polygons[i],Sizes[i]);
     Move(AllPoints[PointCount],Polygons[i][0],Sizes[i]*SizeOf(TPoint));
     Inc(PointCount,Sizes[i]);
  end;
  if PtInPoly(Point,Polygons[n]) then
  begin
    dec(n);
    result:=true;
    for i:=0 to n do begin
      if PtInPoly(Point,Polygons[i]) then
      begin
        result:=false;
        exit;
      end;
    end;
  end;
end;
function Revert(var x : Integer):Integer;overload;
begin
  result:=RevertLongInt(x);
  x:=result;
end;

function Revert(var x : SmallInt):SmallInt;overload;
begin
  result:=RevertInteger(x);
  x:=result;
end;

procedure GeoMetricsToIntMetrics(Metrics:TMetrics;
    IntegerMetrics:TIntegerMetrics;MetricsSize:integer);
var
  i,n:integer;
begin
  n:=MetricsSize-1;
  for i:=0 to n do begin
    with IntegerMetrics[i] do begin
      x:=round(Metrics[i].x);
      y:=round(Metrics[i].y);
    end;
  end;
end;

function Rect(Line:TRealLine):TRealRect;
begin
  with Line do begin
    Result.Left:=Min(x1,x2);
    Result.Right:=Max(x1,x2);
    Result.Top:=Min(y1,y2);
    Result.Left:=Max(y1,y2);
  end;
end;
function Rect(Left,Top,Right,Bottom:integer):TRect;overload;
begin
  result:=Classes.Rect(Left,Top,Right,Bottom);
end;

end.
