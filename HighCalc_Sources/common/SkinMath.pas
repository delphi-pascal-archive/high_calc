unit SkinMath;

interface
uses
  Classes,Skintypes,Windows,GrMath;
procedure LoadRegInfo(Stream: TStream;
  var RegInfo: TRegInfo);
function IsPtInCircle(const Point: TPoint;
  const ButtonRegion:TButtonRegion): boolean;
function IsPtInEllipse(const Point: TPoint;
  const ButtonRegion:TButtonRegion): boolean;
function IsPtInPolygon(const Point: TPoint;
  const ButtonRegion:TButtonRegion): boolean;
function IsPtInRectangle(const Point: TPoint;
  const ButtonRegion:TButtonRegion): boolean;
function IsPtInRoundRectangle(const Point: TPoint;
  const ButtonRegion:TButtonRegion): boolean;
function IsPtInRegion(const ButtonInfo: TRegInfo;
  const Point: TPoint): boolean;
function CreateCircleRegion(const Region: TButtonRegion): HRGN;
function CreateEllipsRegion(const Region: TButtonRegion): HRGN;
function CreatePolygonRegion(const Region: TButtonRegion): HRGN;
function CreateRectRegion(const Region: TButtonRegion): HRGN;
function CreateRoundRectRegion(const Region: TButtonRegion): HRGN;
function CreateRegion(const Region: TRegInfo): HRGN;
implementation

procedure LoadRegInfo(Stream: TStream;
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

function IsPtInRegion(const ButtonInfo: TRegInfo;
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
end;

function CreateRegion(const Region: TRegInfo): HRGN;
begin
  Result:=0;
  case Region.ShapeType of
    shCircle:Result:=CreateCircleRegion(Region.Region);
    shEllipse:Result:=CreateEllipsRegion(Region.Region);//Эллипс
    shRectangle:Result:=CreateRectRegion(Region.Region);//Прямоугольник
    shRoundRectangle:Result:=CreateRoundRectRegion(Region.Region);//Закругленный прямоугольник
    shPolygon:Result:=CreatePolygonRegion(Region.Region);//Многоугольник
  end;
end;

function CreateCircleRegion(const Region: TButtonRegion): HRGN;
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

function CreateEllipsRegion(const Region: TButtonRegion): HRGN;
var
  x1,y1,x2,y2:integer;
begin
  x1:=Region[0].x;
  y1:=Region[0].y;
  x2:=Region[1].x;
  y2:=Region[1].y;
  result := CreateEllipticRgn(x1,y1,x2,y2);
end;

function CreatePolygonRegion(const Region: TButtonRegion): HRGN;
var
  PointCount:integer;
begin
  PointCount:=Length(Region);
  result := CreatePolygonRgn(Region[0],PointCount,ALTERNATE);
end;

function CreateRectRegion(const Region: TButtonRegion): HRGN;
var
  x1,y1,x2,y2:integer;
begin
  x1:=Region[0].x;
  y1:=Region[0].y;
  x2:=Region[1].x;
  y2:=Region[1].y;
  result := CreateRectRgn(x1,y1,x2,y2);
end;

function CreateRoundRectRegion(const Region: TButtonRegion): HRGN;
begin

end;

end.
