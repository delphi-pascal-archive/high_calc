unit mathimge;

interface

uses
  SysUtils, Winprocs, WinTypes,Messages, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls;

type
  EMathImageError=class(Exception);
  {This exception is raised whenever the world settings
   create an EMathError exception. In this case the old settings
   are restored and EMathImageError is raised.
   The exception is also raised if the pointlist for drawpolyline
   is too long to be converted to an open array (only under
   Delphi 1)}

   ESurfaceError=Class(Exception);
   {ESurfaceError is raised whenever a construction of a TSurface
   object fails, or if a value is is being assigned to a nonexisting
   grid point}


  PD3FloatPoint=^TD3FloatPoint;
  TD3FloatPoint=record
              x,y,z:extended;
              next:PD3FloatPoint;
              end;
  {$IFDEF WINDOWS}
  PD3FloatPointArray=^TD3FloatPointarray;
  TD3FloatPointArray=array[0..300] of PD3FloatPoint;
  {$ENDIF}

  {Surface Object to be passed to D3DrawSurface:}
  TSurface=class(TObject)
    private
      Ferror:boolean;
      Fxm,Fym:integer;
      {$IFDEF WINDOWS}
      FFloatsurface:array[0..300] of PD3FloatPointArray;
      {$ENDIF}
      {$IFDEF WIN32}
      FFloatsurface:array[0..300,0..300] of PD3FloatPoint;
      {$ENDIF}
    public
      property error:boolean read Ferror;
      property xmesh:integer read Fxm;
      property ymesh:integer read Fym;
      constructor create(xgrid,ygrid:integer); virtual;
      {surface has (xgrid+1)*(ygrid+1) grid points.}
      {grids number from 0 to xgrid etc.}
      procedure Make(i,j:integer;x,y,z:extended);
      {assigns the point (x,y,z) to grid (i,j)}
      function D3Point(i,j:integer):TD3FloatPoint;
      {gets the point at grid (i,j)}
      destructor destroy; override;
    end;

  PFloatPoint=^TFloatpoint;
  TFloatPoint=record
     x,y:extended;
     next:PFloatPoint;
     end;

  {FloatPointList object to be passed to DrawPolyline:}
  {(Note: I find these lists easier to maintain than dynamic arrays)}
  TFloatPointList=class(TObject)
  private
    Fcount:longint;
  public
    Firstpoint,Currentpoint:PFloatpoint;
    next:TFloatPointList;
    property count:longint read Fcount;
    constructor create; virtual;
    destructor destroy; override;
    procedure add(x,y:extended);
    {add a point (x,y) at end of list}
    procedure assign(AFloatPointList:TFloatpointlist); virtual;
    {copy AFloatPointList to this one. AFloatPointList is still
    around as another instance.}
  end;

  {FloatPointListList object: list of FloatPointLists}
  TFloatPointListList=class(TObject)
  private
    FCount,FTotalCount:longint;
  public
    Firstlist,Currentlist:TFloatPointList;
    property count:longint read FCount;
    {number of *lists* in the object}
    property TotalCount:longint read FTotalcount;
    {number of total points in all lists}
    constructor create; virtual;
    destructor destroy; override;
    procedure add;
    {add a new list}
    procedure AddToCurrent(x,y:extended);
    {add (x,y) to the end of the current list.}
  end;

  TD3FloatPointList=class(TObject)
  private
    Fcount:longint;
  public
    Firstpoint,Currentpoint:PD3Floatpoint;
    next:TD3FloatPointList;
    property count:longint read Fcount;
    constructor create; virtual;
    destructor destroy; override;
    procedure add(x,y,z:extended);
    {add a point (x,y,z) at end of list}
    procedure assign(AFloatPointList:TD3Floatpointlist); virtual;
    {copy AFloatPointList to this one. AFloatPointList is still
    around as another instance.}
  end;

  {FloatPointListList object: list of FloatPointLists}
  TD3FloatPointListList=class(TObject)
  private
    FCount,FTotalCount:longint;
  public
    Firstlist,Currentlist:TD3FloatPointList;
    property count:longint read FCount;
    {number of *lists* in the object}
    property TotalCount:longint read FTotalcount;
    {number of total points in all lists}
    constructor create; virtual;
    destructor destroy; override;
    procedure add;
    {add a new list}
    procedure AddToCurrent(x,y,z:extended);
    {add (x,y) to the end of the current list.}
  end;



  TMathImage = class(TImage)
  private
    x1d2,x2d2,y1d2,y2d2,ax,bx,ay,by:extended;
    axisglb,ard3:boolean;
    x1d3,x2d3,y1d3,y2d3,z1d3,z2d3,alpha:extended;
    zrd3,yrd3:extended;
    basex,basey,basez,frontx,fronty,frontz,vd:extended;
    arad,tana,thetaz,thetay,sinz,siny,cosz,cosy,
    axd3,ayd3,azd3,bxd3,byd3,bzd3,ap,bxp,byp:extended;
    rightz, righty:extended;
    maxth,maxxtw,maxytw:integer;
    FClipRect:TRect;
    fversion:string;
    FCanvas:TCanvas;
    Rotating,Zooming,Moving:boolean;
    FOnRotating,FOnEndRotate,FOnMoving,FOnEndMove,
    FOnZooming,FOnEndZoom,FOnResize:TNotifyEvent;
    procedure setversion(x:string);
    procedure resetworld;
    procedure d3resetworld;
    procedure setaxisglb(a:boolean);
    procedure setx1d2(x:extended);
    procedure setx2d2(x:extended);
    procedure sety1d2(x:extended);
    procedure sety2d2(x:extended);
    procedure setx1d3(x:extended);
    procedure sety1d3(x:extended);
    procedure setx2d3(x:extended);
    procedure sety2d3(x:extended);
    procedure setz1d3(x:extended);
    procedure setz2d3(x:extended);
    procedure setvd(x:extended);
    procedure setzrd3(x:extended);
    procedure setyrd3(x:extended);
    procedure setalpha(x:extended);
    procedure setard3(x:boolean);
    function scalar(xb,yb,zb:extended):extended;
    procedure blockx(x:extended;var xb:extended);
    procedure blocky(y:extended;var yb:extended);
    procedure blockz(z:extended;var zb:extended);
    procedure project(xb,yb,zb:extended; var u,v:extended);
    procedure makeradians;
    function dist(xb,yb,zb:extended):extended;
    procedure findbase(var i1,i2,i3:integer);
    procedure initworld;
    procedure drawoneaxis(x1,y1,z1,x2,y2,z2:extended;c:string);
    function GetCanvas:TCanvas;
    function GetFont:TFont;
    procedure SetFont(Font:TFont);
    function  GetPen:TPen;
    procedure SetPen(Pen:TPen);
    function  GetBrush:TBrush;
    procedure SetBrush(Brush:TBrush);
    { Private declarations, never mind }
  protected
    procedure ReadD2WorldX1(Reader: TReader);
    procedure WriteD2WorldX1(Writer:TWriter);
    procedure ReadD2WorldX2(Reader: TReader);
    procedure WriteD2WorldX2(Writer:TWriter);
    procedure ReadD2WorldY1(Reader: TReader);
    procedure WriteD2WorldY1(Writer:TWriter);
    procedure ReadD2WorldY2(Reader: TReader);
    procedure WriteD2WorldY2(Writer:TWriter);
    procedure ReadD3WorldX1(Reader: TReader);
    procedure WriteD3WorldX1(Writer:TWriter);
    procedure ReadD3WorldY1(Reader: TReader);
    procedure WriteD3WorldY1(Writer:TWriter);
    procedure ReadD3WorldZ1(Reader: TReader);
    procedure WriteD3WorldZ1(Writer:TWriter);
    procedure ReadD3WorldX2(Reader: TReader);
    procedure WriteD3WorldX2(Writer:TWriter);
    procedure ReadD3WorldY2(Reader: TReader);
    procedure WriteD3WorldY2(Writer:TWriter);
    procedure ReadD3WorldZ2(Reader: TReader);
    procedure WriteD3WorldZ2(Writer:TWriter);
    procedure ReadD3Yrotation(Reader: TReader);
    procedure WriteD3Yrotation(Writer:TWriter);
    procedure ReadD3Zrotation(Reader: TReader);
    procedure WriteD3Zrotation(Writer:TWriter);
    procedure DefineProperties(Filer: TFiler); override;
    procedure WMWindowPosChanged(var Msg:TMessage); message WM_WINDOWPOSCHANGED;
    { Protected declarations }
{---------------------*********************************--------------------------}
{                               THE IMPORTANT STUFF                                                 }
{---------------------*********************************--------------------------}
  public
    hregion:HRgn;
    {current clippingregion}

    property Canvas:TCanvas read GetCanvas;
    {I had to overwrite the Canvas property of TImage. Takes too long
     to explain why.}


    property D2Axes:boolean read axisglb write setaxisglb;
    {If true, space is reserved on the image canvas to include axes.
    You need to call drawaxes in order to actually draw any.}


    constructor create(AOwner:TComponent); override;
    destructor destroy; override;

    procedure Clear;
    {Erases current picture.}

    procedure ClearClipped;
    {Only erases the clipping region inside of D2-axes}

    procedure reset;
    {readjusts world to pixel scaling if the image's size has changed.
     Obsolete, unless you have Autosize set to True}

    {The following are the methods for 2-d graphing:}

    procedure setworld(x1,y1,x2,y2:extended);
    {set world range in one step (to be preferred at runtime).
     Compare to published properties D2Worldx1,D2Worldx2 etc.}

    procedure setcolor(color:longint);
    {Short(?) for pen.color:=color. Has been kept for compatability}

    function getcolor:longint;
    {"Short" for result:=pen.color;}

    procedure RestorePen;

    procedure RestoreBrush;
    {Reset pen, brush to their original settings}

    function WindowX(x : extended):longint;
    {Translates World x to pixel x}

    function WindowY(y : extended):longint;
    {Translates World y to pixel y}

    function worldx(xs:longint):extended;
    function worldy(ys:longint):extended;
    {Translate pixel to world}

    function norm(x,y:extended):extended;
    {Length of vector (x,y)}

    procedure DrawPoint(x,y : extended);
   {puts a pixel with world coordinates (x,y) on the screen. Color
    is the currently selected pen color -> setcolor}

    procedure MovetoPoint(x,y:extended);
   {moves the cursor to the point with world coordinates (x,y)}

    procedure DrawLine(x1,y1,x2,y2 : extended);
   {Draws a line from (x1,y1) to (x2,y2) in world coordinates.
    Draws both end pixels.}

    procedure DrawLineto(x,y:extended);
   {draws a line from the current cursor position (see MovetoPoint) to
   point (x,y) in world coordinates. DrawLineTo never draws
   the endpixel (Win-default)}

    procedure DrawEllipse(x1,y1,x2,y2:extended);
    {draws an ellipse in the rectangle between (x1,y1) (lower left)
     and (x2,y2) (upper right) and fills it with the current brush color}

    procedure DrawRectangle(x1,y1,x2,y2:extended);
    {analog to canvas.rectangle}

    procedure DrawAxes(xlabel,ylabel:string;
                        zerolines:boolean;
                        axescolor,zerolinescolor:longint);
    {Draws Axes at the left and bottom boundary of the image. Ticks and
     labelling of numeric values are done automatically. xlabel, ylabel is
     text that goes to the end of the axes. Zerolines=true draws lines x=0,
     y=0. Axescolor,ZerolinesColor are selfexplaining.}

    procedure DrawVector(x,y,a,b:extended);
    {Draws a vector (a,b) at base (x,y)}

    procedure DrawPolyline(FloatPointList:TFloatpointlist);
    {Draws a line connecting points in FloatPointList. Faster
    than individual lines.}

    procedure DrawPolygon(FloatPointList:TFloatPointlist);
    {Draws a line connection the points in FloatPointList, closes the
    shape and fills it with the current brush)}

    procedure DrawPolyPolyLine(FloatPointListList:TFLoatPointListList);
    {Draws all lists in the ListList as Polylines}


   {D3Graphics procedures:}
    procedure d3setworld(x1,y1,z1,x2,y2,z2:extended);
    {Sets all d3-graphic bounds in one step, to be preferred
    at run time. Compare to published properties D3Worldx1 etc.}

    procedure d3window(x,y,z:extended; var xs,ys:longint);
    {translates world-(x,y,z) to pixel-(xs,ys)}

    procedure d3moveto(x,y,z:extended);
    procedure d3drawpoint(x,y,z:extended);
    procedure d3drawline(x1,y1,z1,x2,y2,z2:extended);
    procedure d3drawlineto(x,y,z:extended);
    {The 3-d-analogues of the line procedures}

    procedure d3drawaxes(xlabel,ylabel,zlabel:string);
    {Draws axes at the bondary of the world box
    and puts xlabel,ylabel,zlabel on their ends.
    It also puts up to 4 tick marks with number labels
    on each axis. Ticks always occur at true decimals.}

    procedure d3drawWorldbox;
    {Draws the box the current world resides in, with the 3 sides facing
    the viewer left open}

    procedure d3drawZeroCross;
    {Draws lines x=y=0, x=z=0, y=z=0}

    procedure D3Polyline(FloatPointList:TD3Floatpointlist);
    {analog of DrawPolyline}

    procedure D3PolyPolyline(FloatPointListList:TD3Floatpointlistlist);
    {analog to DrawPolyPolyLine}

    function d3distancetoviewer(x,y,z:extended):extended;
    {The (scaled) distance of the viewpoint to point (x,y,z). Could be
    used to see whether something is visible, but it's a lengthy
    algorithm which I dumped.}

    procedure D3StartRotatingLeft(increment:extended);
    {Rotates the viewpoint (not the object) to the left in
     the specified increment at a time. Note: The rotation goes
     on until you call StopRotating ***in another event handler****.
     The event OnRotation fires at each increment. Use it to
     make rotating visible.}

    procedure D3StartRotatingRight(increment:extended);
    {analogous}

    procedure D3StartRotatingUp(increment:extended);
    {analogous}

    procedure D3StartRotatingDown(increment:extended);
    {analogous}

    procedure D3StopRotating;
    {must be called to stop any of the 4 above. The Event
     OnRotateStop fires, so you can redraw your picture, say.}

    procedure D3StartMovingIn(increment:extended);
    {analogous, decreases the view distance by increment*D3Viewdist.
    (Relative decrease makes more sense)
    Event OnMoving gets fired at each step. D3StopMoving must be called
    to end all this.}

    procedure D3StartMovingOut(increment:extended);
    {analogous}

    procedure D3StopMoving;
    {must be called to stop above. Event OnMoveStop fires}

    procedure D3StartZoomingIn(increment:extended);
    {Keeps decreasing the view angle by increment*D3ViewAngle
     (relative) until
     D3StopZooming is called in an event handler.
     Event OnZooming fires at each step}

    procedure D3StartZoomingOut(increment:extended);
    {analogous}

    procedure D3StopZooming;
    {Must be called to stop all the zooming. Event OnZoomStop
    fires.}

    {Surface Routines:}

    procedure d3DrawSurface(surface:TSurface; fill, NoUpdate:boolean);
    {Draw surface. Surface must have been created and
    filled with the world coordinates of the gridpoints.
    Fill=false gives a wire frame, Fill=true displays it filled with
    the current brush color, invisible parts hidden. I've now found
    *the* cheap way to display filled surfaces right, previous was
    dumb.., but the way it's done now, it's not possible for a given
    surface point to *know* whether it's visible or not.
    NoUpdate=true: Display the surface all at once (fastest),
             false: Show some drawing steps in between. }

    { Public declarations }

  published

    property version:string read fversion write setversion;
   {Fake property to display the version of the component}

    property Font:TFont read GetFont write setfont;
    {Font of the image's drawing canvas}

    property Pen:TPen read getPen write SetPen;
    {For your convenience: instead of MyImage.Canvas.Pen
     you can just write MyImage.Pen.}

    property Brush:TBrush read GetBrush write SetBrush;
    {Same as above for the brush}


    property D2WorldX1: extended read x1d2 write setx1d2 stored false;
    property D2WorldX2: extended read x2d2 write setx2d2 stored false;
    property D2WorldY1: extended read y1d2 write sety1d2 stored false;
    property D2WorldY2: extended read y2d2 write sety2d2 stored false;
    {The above set the boundary for the 2-d-drawing world}
    {Don't worry about the stored false in all of these. They get stored:
    see override of DefineProperties. The default storing process never
    writes a value 0 of a float property to the dfm-file and the default
    value set in the constructor is used instead. So if that default is
    <>0, a value 0 can never be set. Overriding DefineProperties fixes it.
    Stored false is used so the property is not stored twice. (Thanks to
    Joe Herb for the tip)}


    property D3WorldX1: extended read x1d3 write setx1d3 stored false;
    property D3WorldX2: extended read x2d3 write setx2d3 stored false;
    property D3WorldY1: extended read y1d3 write sety1d3 stored false;
    property D3WorldY2: extended read y2d3 write sety2d3 stored false;
    property D3WorldZ1: extended read z1d3 write setz1d3 stored false;
    property D3WorldZ2: extended read z2d3 write setz2d3 stored false;
    {These set the boundaries for the 3-d-drawing world. When graphed,
     the world box is normalized so its longest edge has length 2, and
     the other edges have lengthes according to the true aspect ratio of
     the bounds you specify. If you set the property D3AspectRatio to false,
     the edges have all the same length 2. The box is then projected onto the
     image according to the settings of D3ViewDist, D3ViewAngle, D3Zrotation,
     D3yrotation: Everything is projected from the viewer location to
     the plane through the center of the box which perpendicular to the
     viewer direction. The part of the plane which you see, is what the
     viewangle can sweep out from the viewdistance. The viewer always looks
     at the center of the box, enough for math applications.}

    property D3Zrotation: extended read zrd3 write setzrd3 stored false;
    {Angle of viewpoint with the x-axis ("how much it's rotated
     about the z-axis" I know it's a bad name..)}

    property D3Yrotation: extended read yrd3 write setyrd3 stored false;
    {Angle of viewpoint with the z-axis ("how much the viewpoint is
     rotated about the y-axis") Again, bad name}

    property D3ViewDist: extended read vd write setvd;
    {Distance of viewpoint to the center of the d3-world }

    property D3ViewAngle:extended read alpha write setalpha;
    {Opening angle of the lens of the viewpoint. Large D3ViewAngle combined with
     small D3ViewDist give fish eye effect. See Surface.pas to get a feel.}

    property D3AspectRatio:boolean read ard3 write setard3;
    {When true (default) the true aspect ratio of the data
    is used for the worldbox. Otherwise, the box is square}

    property OnRotating:TNotifyEvent read FOnRotating write FOnRotating;
    {Event which fires at each increment of the angle in
     D3StartRotatingLeft etc.. Note: it is not called when you just
     alter values of D3ZRotation etc.}

    property OnRotateStop:TNotifyEvent read FOnEndRotate write FOnEndRotate;
    {Fires in D3StopRotating}

    property OnMoving:TNotifyEvent read FOnMoving write FOnMoving;
    {Fires at each increment in D3MoveIn -Out. Note: Does not fire
    when you justchange D3Viewdist}

    property OnMoveStop:TNotifyEvent read FOnEndMove write FOnEndMove;
    property OnZooming:TNotifyEvent read FOnZooming write FOnZooming;
    property OnZoomStop:TNotifyEvent read FOnEndZoom write FOnEndZoom;
    {analogous}

    property OnResize:TNotifyEvent read FOnResize write FOnResize;
    {Code you wish to perform each time the image bounds change,
     like redrawing what you had before. Note: At each resize of
     the image, the underlying bitmap is resized accordingly, and
     the world-to-image scalings are reset. This avoids flicker in drawing
     and makes sure that MouseEvents of the image get translated in
     the right way. Since there is no (easy) way to know what the
     image contained previous to resizing, you have to write the
     code in OnResize that restores the picture drawn so far, if you
     want to do so. If you don't assign OnResize, the picture under the
     previous scale is preserved, but any new drawing is done under
     the new scale.}

    {The nice thing about these events: you can use the sender
     variable to make exactly the mathimage that triggers the
     event to perform the update, so you might only have to write
     one or two event handlers  which take care of all the images
     you have, say in a notebook.}

     { Published declarations }

  end;


procedure Register;


implementation

procedure Register;
begin
  RegisterComponents('Samples', [TMathImage]);
end;

{TSurface}

constructor TSurface.create(xgrid,ygrid:integer);
var i,j:integer; l:longint;
begin
  inherited create;
  Fxm:=-1; Fym:=-1;
  Ferror:=true;
  l:=xgrid;
  l:=l*ygrid;
  if (xgrid>=0) and (xgrid<=300) and (ygrid>=0) and (ygrid<=300)
  {$IFDEF WINDOWS}
    and (l<32767)
  {$ENDIF}   	
  then
  begin
    ferror:=false;
    Fxm:=xgrid; Fym:=ygrid;
    For i:=0 to Fxm do
    begin
      {$IFDEF WINDOWS}
      New(FFloatSurface[i]);
      {$ENDIF}
      For j:=0 to Fym do
      begin
        {$IFDEF WINDOWS}
        New(FFloatSurface[i]^[j]);
        with FFloatSurface[i]^[j]^ do
        {$ENDIF}
        {$IFDEF WIN32}
        New(FFloatSurface[i,j]);
        with FFloatSurface[i,j]^ do
        {$ENDIF}
        begin
          x:=0; y:=0; z:=0;
        end;
      end;
    end;
  end else
  raise ESurfaceError.Create('Surface grid size out of bounds');
end;

procedure TSurface.Make(i,j:integer;x,y,z:extended);
begin
  if (i>=0) and (i<=Fxm) and (j>=0) and (j<=Fym)
  then
  begin
    {$IFDEF WINDOWS}
    FFloatSurface[i]^[j]^.x:=x;
    FFloatSurface[i]^[j]^.y:=y;
    FFloatSurface[i]^[j]^.z:=z;
    {$ENDIF}
    {$IFDEF WIN32}
    FFloatSurface[i,j]^.x:=x;
    FFloatSurface[i,j]^.y:=y;
    FFloatSurface[i,j]^.z:=z;
    {$ENDIF}
  end else
  raise ESurfaceError.Create('Surface gridpoint does not exist');
end;

function TSurface.D3Point(i,j:integer):TD3FloatPoint;
var p:TD3FloatPoint;
begin
  if (i>=0) and (i<=Fxm) and (j>=0) and (j<=Fym) then
  {$IFDEF WINDOWS}
    p:=FFloatSurface[i]^[j]^
  {$ENDIF}
  {$IFDEF WIN32}
    p:=FFloatSurface[i,j]^
  {$ENDIF}
  else with p do
  begin
    x:=0; y:=0; z:=0;
    raise ESurfaceError.Create('Surface Gridpoint does not exist');
  end;
  result:=p;
end;

destructor TSurface.destroy;
var i,j:integer;
begin
  for i:=0 to Fxm do
  begin
    for j:=0 to Fym do
    {$IFDEF WINDOWS}
    dispose(FFloatSurface[i]^[j]);
    dispose(FFloatSurface[i]);
    {$ENDIF}
    {$IFDEF WIN32}
    dispose(FFLoatSurface[i,j]);
    {$ENDIF};
  end;
  inherited destroy;
end;

{TFloatPointList}

constructor TFloatPointList.create;
begin
  inherited create;
  Firstpoint:=nil;
  Fcount:=0;
  Currentpoint:=nil;
  next:=nil;
end;

procedure TFloatPointList.add(x,y:extended);
var p:PFloatPoint;
begin
  new(p);
  p^.x:=x; p^.y:=y; p^.next:=nil;
  inc(Fcount);
  if Firstpoint=nil then
  begin
    Firstpoint:=p;
    Currentpoint:=p;
  end
  else
  begin
    currentpoint^.next:=p;
    currentpoint:=p;
  end;
end;

procedure TFloatPointList.assign;
var p:PFloatpoint; i:longint;
begin
  If AFloatPointlist.count>0 then
  begin
    p:=AFloatPointList.firstpoint;
    for i:=1 to AFloatPointlist.count do
    begin
      add(p^.x,p^.y);
      p:=p^.next;
    end;
  end;
end;


destructor TFloatPointList.destroy;
var p,q:PFloatPoint;
begin
  if FirstPoint<>nil then
  begin
    p:=Firstpoint;
    while p^.next<>nil do
    begin
      q:=p^.next;
      dispose(p);
      p:=q;
    end;
    dispose(p);
  end;
  firstpoint:=nil;
  Currentpoint:=nil;
  inherited destroy;
end;


{TFloatPointListList}

constructor TFloatPointListList.create;
begin
  inherited create;
  Firstlist:=nil;
  Fcount:=0;
  FTotalCount:=0;
  Currentlist:=nil;
end;

procedure TFloatPointListList.add;
var p:TFloatPointList;
begin
  p:=TFloatPointList.create;
  inc(Fcount);
  if Firstlist=nil then
  begin
    Firstlist:=p;
    Currentlist:=p;
  end
  else
  begin
    currentlist.next:=p;
    currentlist:=p;
  end;
end;

procedure TFloatPointListList.AddToCurrent(x,y:extended);
var p:PFloatPoint;
begin
  currentlist.add(x,y);
  inc(FTotalcount);
end;

destructor TFloatPointListList.destroy;
var p,q:TFloatPointList;
begin
  if FirstList<>nil then
  begin
    p:=FirstList;
    while p.next<>nil do
    begin
      q:=p.next;
      p.free;
      p:=q;
    end;
    p.free;
  end;
  firstlist:=nil;
  Currentlist:=nil;
  inherited destroy;
end;

{TD3FloatPointList}

constructor TD3FloatPointList.create;
begin
  inherited create;
  Firstpoint:=nil;
  Fcount:=0;
  Currentpoint:=nil;
  next:=nil;
end;

procedure TD3FloatPointList.add(x,y,z:extended);
var p:PD3FloatPoint;
begin
  new(p);
  p^.x:=x; p^.y:=y; p^.z:=z; p^.next:=nil;
  inc(Fcount);
  if Firstpoint=nil then
  begin
    Firstpoint:=p;
    Currentpoint:=p;
  end
  else
  begin
    currentpoint^.next:=p;
    currentpoint:=p;
  end;
end;

procedure TD3FloatPointList.assign;
var p:PD3Floatpoint; i:longint;
begin
  If AFloatPointlist.count>0 then
  begin
    p:=AFloatPointList.firstpoint;
    for i:=1 to AFloatPointlist.count do
    begin
      add(p^.x,p^.y,p^.z);
      p:=p^.next;
    end;
  end;
end;


destructor TD3FloatPointList.destroy;
var p,q:PD3FloatPoint;
begin
  if FirstPoint<>nil then
  begin
    p:=Firstpoint;
    while p^.next<>nil do
    begin
      q:=p^.next;
      dispose(p);
      p:=q;
    end;
    dispose(p);
  end;
  firstpoint:=nil;
  Currentpoint:=nil;
  inherited destroy;
end;


{TD3FloatPointListList}

constructor TD3FloatPointListList.create;
begin
  inherited create;
  Firstlist:=nil;
  Fcount:=0;
  FTotalCount:=0;
  Currentlist:=nil;
end;

procedure TD3FloatPointListList.add;
var p:TD3FloatPointList;
begin
  p:=TD3FloatPointList.create;
  inc(Fcount);
  if Firstlist=nil then
  begin
    Firstlist:=p;
    Currentlist:=p;
  end
  else
  begin
    currentlist.next:=p;
    currentlist:=p;
  end;
end;

procedure TD3FloatPointListList.AddToCurrent(x,y,z:extended);
var p:PD3FloatPoint;
begin
  currentlist.add(x,y,z);
  inc(FTotalcount);
end;

destructor TD3FloatPointListList.destroy;
var p,q:TD3FloatPointList;
begin
  if FirstList<>nil then
  begin
    p:=FirstList;
    while p.next<>nil do
    begin
      q:=p.next;
      p.free;
      p:=q;
    end;
    p.free;
  end;
  firstlist:=nil;
  Currentlist:=nil;
  inherited destroy;
end;



{TMathImage}
procedure TMathImage.setversion;
begin
  {fversion:=x};
end;

procedure TMathImage.setx1d2;
begin
  if (csDesigning in Componentstate) or
      (csReading in Componentstate) then
  x1d2:=x else
  setworld(x,y1d2,x2d2,y2d2);
end;
procedure TMathImage.setx2d2;
begin
  if (csDesigning in Componentstate) or
      (csReading in Componentstate) then
  x2d2:=x else
  setworld(x1d2,y1d2,x,y2d2);
end;
procedure TMathImage.sety1d2;
begin
  if (csDesigning in Componentstate) or
      (csReading in Componentstate) then
  y1d2:=x else
  setworld(x1d2,x,x2d2,y2d2);
end;
procedure TMathImage.sety2d2;
begin
  if csDesigning in Componentstate then
  y2d2:=x else
  {when reading only set the scale at the last read}
  setworld(x1d2,y1d2,x2d2,x);
end;
procedure TMathImage.setx1d3;
begin
  if (csDesigning in Componentstate) or
      (csReading in Componentstate) then
  x1d3:=x else
  d3setworld(x,y1d3,z1d3,x2d3,y2d3,z2d3);
end;
procedure TMathImage.setx2d3;
begin
  if (csDesigning in Componentstate) or
      (csReading in Componentstate) then
  x2d3:=x else
  d3setworld(x1d3,y1d3,z1d3,x,y2d3,z2d3);
end;
procedure TMathImage.sety1d3;
begin
  if (csDesigning in Componentstate) or
      (csReading in Componentstate) then
  y1d3:=x else
  d3setworld(x1d3,x,z1d3,x2d3,y2d3,z2d3);
end;
procedure TMathImage.sety2d3;
begin
  if (csDesigning in Componentstate) or
      (csReading in Componentstate) then
  y2d3:=x else
  d3setworld(x1d3,y1d3,z1d3,x2d3,x,z2d3);
end;
procedure TMathImage.setz1d3;
begin
  if (csDesigning in Componentstate) or
      (csReading in Componentstate) then
  z1d3:=x else
  d3setworld(x1d3,y1d3,x,x2d3,y2d3,z2d3);
end;
procedure TMathImage.setz2d3;
begin
  if csDesigning in Componentstate then
  z2d3:=x else
  {when reading set the scaling only in the last step}
  d3setworld(x1d3,y1d3,z1d3,x2d3,y2d3,x);
end;
procedure TMathImage.setvd;
begin
  vd:=x;
  if not (csdesigning in componentstate) then
  initworld;
end;
procedure TMathImage.setalpha;
begin
  alpha:=x;
  if not (csdesigning in componentstate) then
  initworld;
end;
procedure TMathImage.setzrd3;
begin
  zrd3:=x;
  if not (csdesigning in componentstate) then
  initworld;
end;
procedure TMathImage.setyrd3;
begin
  yrd3:=x;
  if not (csdesigning in componentstate) then
  initworld;
end;

procedure TMathImage.setard3;
begin
  ard3:=x;
  if not (csdesigning in componentstate) then
  initworld;
end;

{All the following tedious code is just so a value 0 can be set for
the properties... Maybe I get it more elegant in a later version, right
now I'm glad it works}
procedure TMathImage.ReadD2WorldX1(Reader: TReader);
begin
  x1d2:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD2WorldX1(Writer:TWriter);
begin
  Writer.WriteFloat(x1d2);
end;
procedure TMathImage.ReadD2WorldX2(Reader: TReader);
begin
  x2d2:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD2WorldX2(Writer:TWriter);
begin
  Writer.WriteFloat(x2d2);
end;
procedure TMathImage.ReadD2WorldY1(Reader: TReader);
begin
  y1d2:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD2WorldY1(Writer:TWriter);
begin
  Writer.WriteFloat(y1d2);
end;
procedure TMathImage.ReadD2WorldY2(Reader:TReader);
begin
  y2d2:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD2WorldY2(Writer:TWriter);
begin
  Writer.WriteFloat(y2d2);
end;
procedure TMathImage.ReadD3WorldX1(Reader: TReader);
begin
  x1d3:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD3WorldX1(Writer:TWriter);
begin
  Writer.WriteFloat(x1d3);
end;
procedure TMathImage.ReadD3WorldY1(Reader: TReader);
begin
  y1d3:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD3WorldY1(Writer:TWriter);
begin
  Writer.WriteFloat(y1d3);
end;
procedure TMathImage.ReadD3WorldZ1(Reader: TReader);
begin
  z1d3:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD3WorldZ1(Writer:TWriter);
begin
  Writer.WriteFloat(z1d3);
end;
procedure TMathImage.ReadD3WorldX2(Reader: TReader);
begin
  x2d3:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD3WorldX2(Writer:TWriter);
begin
  Writer.WriteFloat(x2d3);
end;
procedure TMathImage.ReadD3WorldY2(Reader: TReader);
begin
  y2d3:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD3WorldY2(Writer:TWriter);
begin
  Writer.WriteFloat(y2d3);
end;
procedure TMathImage.ReadD3WorldZ2(Reader: TReader);
begin
  z2d3:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD3WorldZ2(Writer:TWriter);
begin
  Writer.WriteFloat(z2d3);
end;
procedure TMathImage.ReadD3Yrotation(Reader: TReader);
begin
  yrd3:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD3Yrotation(Writer:TWriter);
begin
  Writer.WriteFloat(yrd3);
end;
procedure TMathImage.ReadD3Zrotation(Reader: TReader);
begin
  zrd3:=Reader.ReadFloat;
end;
procedure TMathImage.WriteD3Zrotation(Writer:TWriter);
begin
  Writer.WriteFloat(zrd3);
end;

procedure TMathImage.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  with Filer do
  begin
    DefineProperty('D2WorldX1',ReadD2WorldX1,WriteD2WorldX1,true);
    DefineProperty('D2WorldX2',ReadD2WorldX2,WriteD2WorldX2,true);
    DefineProperty('D2WorldY1',ReadD2WorldY1,WriteD2WorldY1,true);
    DefineProperty('D2WorldY2',ReadD2WorldY2,WriteD2WorldY2,true);
    DefineProperty('D3WorldX1',ReadD3WorldX1,WriteD3WorldX1,true);
    DefineProperty('D3WorldY1',ReadD3WorldY1,WriteD3WorldY1,true);
    DefineProperty('D3WorldZ1',ReadD3WorldZ1,WriteD3WorldZ1,true);
    DefineProperty('D3WorldX2',ReadD3WorldX2,WriteD3WorldX2,true);
    DefineProperty('D3WorldY2',ReadD3WorldY2,WriteD3WorldY2,true);
    DefineProperty('D3WorldZ2',ReadD3WorldZ2,WriteD3WorldZ2,true);
    DefineProperty('D3Zrotation',ReadD3Zrotation,WriteD3Zrotation,true);
    DefineProperty('D3Yrotation',ReadD3Yrotation,WriteD3Yrotation,true);
  end;
end;
{Tedious part over, the important stuff comes next}

Constructor TMathImage.Create(AOwner:TComponent);
var num:integer;  bitmap:tbitmap;
begin
  inherited create(AOWner);
  controlstyle:=controlstyle+[csopaque];
  hregion:=0;
  x1d2:=-1; x2d2:=1; y1d2:=-1; y2d2:=1;
  x1d3:=-1; x2d3:=1; y1d3:=-1; y2d3:=1;
  z1d3:=-1; z2d3:=1; axisglb:=false; alpha:=6;
  vd:=6.4; zrd3:=45; yrd3:=45; ard3:=true;
  picture:=nil;
  fversion:='3.0 July 98 ';
  FCanvas:=TCanvas.create;
  with FCanvas.Font do
  begin
    name:='Arial';
    size:=9;
    style:=[];
  end;
end;



Destructor TMathImage.Destroy;
var i,j:integer;
begin
  if hregion<>0 then deleteobject(hregion);
  FCanvas.free;
  inherited destroy;
end;

procedure TMathImage.WMWindowPosChanged(var Msg:TMessage);
begin
  if not (csDesigning in Componentstate) then
  if picture.graphic is TBitmap then
  if not Autosize then
  begin
    setaxisglb(axisglb);
    d3resetworld;
    picture.bitmap.height:=height;
    picture.bitmap.width:=width;
    if assigned(FOnResize) then FOnResize(self);
  end;
  inherited;
end;

function TMathImage.GetCanvas;
var
  Bitmap: TBitmap;
begin
  if not ((CSDesigning in Componentstate)
         or (CSReading in Componentstate))  then
  begin
    if Picture.Graphic = nil then
    begin
      Bitmap := TBitmap.Create;
      try
        Bitmap.Width := Width;
        Bitmap.Height := Height;
        Picture.Graphic := Bitmap;
        with picture.bitmap.canvas do
        begin
          font.assign(FCanvas.font);
          pen.assign(FCanvas.pen);
          brush.assign(FCanvas.brush);
        end;
      finally
        Bitmap.Free;
      end;
    end;
    if Picture.Graphic is TBitmap then
      Result := TBitmap(Picture.Graphic).Canvas
    else
      raise EInvalidOperation.Create('Image needs Bitmap for Drawing');
  end {If not (Designing or Reading)}
  else result:=FCanvas;
end;

function TMathImage.getfont;
begin
  result:=Canvas.font;
end;

procedure TMathImage.setfont;
begin
  FCanvas.Font.assign(font);
  Canvas.Font.assign(font);
end;

function TMathImage.getpen;
begin
  result:=Canvas.pen;
end;

procedure TMathImage.setpen;
begin
  FCanvas.Pen.assign(pen);
  Canvas.Pen.assign(pen);
end;

function TMathImage.getbrush;
begin
  result:=Canvas.brush;
end;

procedure TMathImage.setbrush;
begin
  FCanvas.Brush.assign(brush);
  Canvas.Brush.assign(brush);
end;

procedure TMathImage.restorebrush;
begin
  canvas.brush.assign(FCanvas.brush);
end;

procedure TMathImage.restorepen;
begin
  canvas.pen.assign(FCanvas.pen);
end;

procedure TMathImage.setaxisglb;
begin
  axisglb:=a;
  resetworld;
  if hregion<>0 then deleteobject(hregion);
  hregion:=0;
  if a then
  begin
    FCliprect:=rect(windowx(x1d2)+1,windowy(y2d2),
         windowx(x2d2)+1,windowy(y1d2));
    With FCliprect do
    hregion:=CreateRectRgn(Left,Top,Right,Bottom);
    SelectClipRgn(canvas.handle,hregion);
  end else
  begin
    SelectClipRgn(canvas.handle,0);
    FClipRect:=rect(0,0,width,height);
  end;
end;

procedure TMathImage.reset;
begin
  setaxisglb(axisglb);
  d3resetworld;
end;

procedure TMathImage.setworld;
var Smaxxtw, Smaxytw, Smaxth:integer;
    Sax, Sbx, Say, Sby:extended;
 function max(i,j:integer):integer;
 begin
   if i<j then result:=j else result:=i;
 end;

 function maxtextwidth(xx1,xx2:extended):integer;
 var itemp,xtick:extended;
     i,istart,ticks,w:longint;
 begin
   itemp:=ln((xx2-xx1)/8)/ln(10);
   if itemp>=0 then i:=trunc(itemp) else i:=trunc(itemp)-1;
   xtick:=exp(i*ln(10));
   istart:=round(xx1/xtick);
   while istart*xtick<xx1 do inc(istart);
   ticks:=round((xx2-xx1)/xtick);
   font.size:=font.size-1;
   w:=canvas.textwidth(floattostrf(istart*xtick,ffgeneral,3,3));
   for i:=1 to 4 do
   w:=max(w,canvas.textwidth(floattostrf((istart+i*(ticks div 4))*xtick,ffgeneral,3,3)));
   result:=w;
   font.size:=font.size+1;
 end;
begin
  if csDesigning in Componentstate then
  begin
    if x2<=x1 then exit;
  end;
  Smaxxtw:=maxxtw; Smaxytw:=maxytw; Sax:=Ax; Say:=Ay; Sbx:=Bx; Sby:=By;
  try
    if axisglb then
    begin
      maxxtw:=maxtextwidth(x1,x2);
      maxytw:=maxtextwidth(y1,y2);
      maxth:=canvas.textheight('-1.234567');
      Bx := (width-7-maxytw-(maxxtw div 2))/(x2 - x1);
      Ax :=6+maxytw-x1*Bx;
      By:=(height-7-2*maxth)/(y1-y2);
      Ay:=maxth-By*y2;
    end else
    begin
      Bx:=(width-1)/(x2-x1);
      Ax :=  - x1d2*Bx;
      By :=(height-1)/(y1-y2);
      Ay := -y2*By;
    end;
    x1d2:=x1; x2d2:=x2; y1d2:=y1; y2d2:=y2;
  except
    on E:EMathError do
    begin
      maxxtw:=Smaxxtw; maxytw:=Smaxytw; maxth:=Smaxth;
      Ax:=Sax; Ay:=Say; Bx:=Sbx; By:=Sby;
      raise EMathImageError.Create('Invalid D2-world bounds');
    end;
  end;
end;

procedure TMathImage.resetworld;
begin
  setworld(x1d2,y1d2,x2d2,y2d2);
end;

procedure TMathImage.setcolor;
begin
  pen.color:=color;
end;

function TMathImage.getcolor;
begin
  result:=pen.color;
end;

function TMathImage.WindowX;
var Temp: extended;
begin
  try
   Temp := Ax + Bx * x;
   if abs(temp)<16000 then
    result:= round(Temp)
   else
    if temp<0 then result:=-16000 else result:=16000;
  except
    on E:EMathError do
    begin
      result:=16000;
      raise EMathImageError.Create('Can''t convert to pixel-x');
    end;
  end;
end;

function TMathImage.WindowY;
var Temp : extended;
begin
  try
    Temp := Ay + By * y;
    if abs(temp)<16000 then
      result:= round(Temp)
    else
      if temp<0 then result:=-16000 else result:=16000;
  except
    on E:EMathError do
    begin
      result:=16000;
      raise EMathImageError.Create('Can''t convert to pixel-y');
    end;
  end;
end;

function TMathImage.norm;
begin
  result:=sqrt(sqr(x)+sqr(y));
end;

function TMathImage.worldx;
begin
  try
    result:=(xs-Ax)/Bx;
  except
    On E:EMathError do
    begin
      result:=0;
      raise EMathImageError.Create('Can''t convert to world-x');
    end;
  end;
end;

function TMathImage.worldy;
begin
  try
    result:=(ys-ay)/by;
  except
    On E:EMathError do
    begin
      raise EMathImageError.Create('Can''t convert to world-y');
    end;
  end;
end;

procedure TMathImage.clear;
var clipped:boolean;
begin
  clipped:=(hregion<>0);
  If clipped then
  begin
    deleteobject(hregion);
    selectcliprgn(canvas.handle,0);
    canvas.fillrect(rect(0,0,width,height));
    With FClipRect do
    hregion:=CreateRectRgn(Left,Top,Right,Bottom);
    selectcliprgn(canvas.handle,hregion);
  end else
    canvas.fillrect(rect(0,0,width,height));
  invalidate;
  {This is better than the method suggested in the documentation,
   because it keeps the previous settings for pen, brush etc. }
end;

procedure TMathImage.clearClipped;
begin
  canvas.fillrect(FCliprect);
  invalidate;
end;

procedure TMathImage.DrawPoint;
begin
   SelectClipRgn(canvas.handle,hregion);
  canvas.pixels[windowx(x),windowy(y)]:=canvas.pen.color;
end;

procedure TMathImage.MovetoPoint;
begin
  SelectClipRgn(canvas.handle,hregion);
  canvas.moveto(windowx(x),windowy(y));
end;

procedure TMathImage.DrawLine;
var p1,p2:TPoint;
begin
  SelectClipRgn(canvas.handle,hregion);
  p1:=point(windowx(x1),windowy(y1));
  p2:=point(windowx(x2),windowy(y2));
  {canvas.moveto(windowx(x1),windowy(y1));
  canvas.lineto(xw,yw);
  canvas.pixels[xw,yw]:=canvas.pen.color;}
  canvas.polyline([p1,p2,p1]);
  {Faster than the commented above. Note that moveto / lineto
   doesn't do what you want (or at least what I want), because
   it never draws the endpixel of the line}
end;


procedure TMathImage.DrawLineto(x,y:extended);
begin
  SelectClipRgn(canvas.handle,hregion);
  canvas.Lineto(windowx(x),windowy(y));
end;

procedure TMathImage.DrawEllipse(x1,y1,x2,y2:extended);
begin
  SelectClipRgn(canvas.handle,hregion);
  canvas.ellipse(windowx(x1),windowy(y2),windowx(x2),windowy(y1));
end;

procedure TMathImage.DrawRectangle;
begin
  SelectClipRgn(canvas.handle,hregion);
  canvas.rectangle(windowx(x1),windowy(y2),windowx(x2)+1,windowy(y1)+1);
  {Note: the one is added to make the rectangle come out the same as
  it would by using the canvas.polygon method. I don't know why the
  standard canvas rectangle is always a pixel too short.}
end;

procedure TMathImage.drawaxes;
var xs,ys,i,istart,ticks:longint;
    savepen:TPen; SaveBrush:TBrush;
    t:string; itemp,xtick,ytick:extended;

   function min(i,j:longint):longint;
   begin
     if i<j then result:=i else result:=j;
   end;

begin
  savebrush:=TBrush.create;
  savepen:=TPen.create;
  try
    savepen.assign(pen);
    savebrush.assign(brush);
    setaxisglb(true);
    if hregion<>0 then deleteobject(hregion);
    hregion:=0;
    brush.style:=bsclear;
    pen.style:=psSolid;
    pen.width:=1;
    setcolor(axescolor);
    drawline(x1d2,y1d2,x2d2,y1d2);
    itemp:=ln((x2d2-x1d2)/8)/ln(10);
    if itemp>=0 then
    i:=trunc(itemp) else i:=trunc(itemp)-1;
    xtick:=exp(i*ln(10));
    itemp:=ln((y2d2-y1d2)/8)/ln(10);
    if itemp>=0 then
      i:=trunc(itemp) else i:=trunc(itemp)-1;
    ytick:=exp(i*ln(10));
    if xtick>0 then
    begin
      istart:=round(x1d2/xtick);
      while istart*xtick<x1d2 do inc(istart);
      i:=istart;
      ticks:=round((x2d2-x1d2)/xtick);
      with font do
      size:=size-1;
      if ticks<=2000 then
      repeat
        xs:=windowx(i*xtick);
        ys:=windowy(y1d2);
        canvas.moveto(xs,ys);
        canvas.lineto(xs,ys+4);
        if (i-istart) mod (ticks div 4) =0 then
        begin
          t:=floattostrf(i*xtick,ffgeneral,3,3);
          with canvas do
          begin
            textout(xs-(textwidth(t) div 2), ys+6,t);
            moveto(xs,ys);
            lineto(xs,ys+6);
          end;
        end;
        inc(i)
      until i*xtick>x2d2-xtick;
      with font do size:=size+1;
    end;
    xs:=windowx(x2d2);
    ys:=windowy(y1d2);
    canvas.moveto(xs-6,ys-6);
    canvas.lineto(xs,ys);
    canvas.moveto(xs-6,ys+6);
    canvas.lineto(xs,ys);
    canvas.textout(min(xs+1,width-canvas.textwidth(xlabel)),ys-canvas.textheight(xlabel)-6,xlabel);
    drawline(x1d2,y1d2,x1d2,y2d2);
    if ytick>0 then
    begin
      istart:=round(y1d2/ytick);
      while istart*ytick<y1d2 do inc(istart);
      i:=istart;
      ticks:=round((y2d2-y1d2)/ytick);
      with font do
        size:=size-1;
      if ticks <=2000 then
      repeat
        xs:=windowx(x1d2);
        ys:=windowy(i*ytick);
        canvas.moveto(xs,ys);
        canvas.lineto(xs-4,ys);
        if (i-istart) mod (ticks div 4) =0 then
        begin
          t:=floattostrf(i*ytick,ffgeneral,3,3);
          with canvas do
          begin
            textout(xs-textwidth(t)-6,ys-textheight(t) div 2,t);
            moveto(xs,ys);
            lineto(xs-6,ys);
          end;
        end;
        inc(i);
      until i*ytick>y2d2-ytick;
      with font do
      size:=size+1;
    end;
    xs:=windowx(x1d2);
    ys:=windowy(y2d2);
    canvas.moveto(xs+6,ys+6);
    canvas.lineto(xs,ys);
    canvas.moveto(xs-6,ys+6);
    canvas.lineto(xs,ys);
    canvas.textout(xs+6,0,ylabel);
    with FClipRect do
    hregion:=CreateRectRgn(Left,Top,Right,Bottom);
    selectclipRgn(canvas.handle,hregion);
    if zerolines then
    begin
      canvas.pen.color:=zerolinescolor;
      drawline(0,y1d2,0,y2d2);
      drawline(x1d2,0,x2d2,0);
    end;
    brush.assign(savebrush);
    pen.assign(savepen);
  finally
    savebrush.free;
    savepen.free;
  end;
end;

procedure TMathImage.drawvector;
var aw,bw,xw,yw,u1,u2,v1,v2:longint; n:extended;
begin
  SelectClipRgn(canvas.handle,hregion);
  v1:=windowx(a+x);
  v2:=windowy(b+y);
  xw:=windowx(x);
  yw:=windowy(y);
  aw:=v1-xw;
  bw:=v2-yw;
  n:=norm(bw-aw,aw+bw);
  if n>0 then
  begin
  canvas.moveto(xw,yw);
  canvas.lineto(v1,v2);
  u1:=round(8.0*(bw-aw)/n);
  u2:=round(8.0*(-bw-aw)/n);
  canvas.moveto(v1,v2);
  canvas.lineto(v1+u1,v2+u2);
  u1:=round(8.0*(-aw-bw)/n);
  u2:=round(8.0*(aw-bw)/n);
  canvas.moveto(v1,v2);
  canvas.lineto(v1+u1,v2+u2);
  end;
end;


procedure TMathimage.DrawPolyline(FloatPointList:TFloatpointlist);
{$IFDEF WINDOWS}
type  TPointArray=array[0..16320] of TPoint;
{$ENDIF}
{$IFDEF WIN32}
type TPointArray=array[0..1000000] of TPoint;
{$ENDIF}
var p:PFloatPoint; i:longint; pointarray:^TPointArray;
begin
  SelectClipRgn(canvas.handle,hregion);
  with FloatPointList do
  begin
    {$IFDEF WINDOWS}
    if count>16320 then
    begin
      raise EMathImageError.Create('Pointlist too long');
      exit;
    end;
    {$ENDIF}
    getmem(pointarray,count*SizeOf(TPoint));
    p:=firstpoint;
    for i:=1 to count do
    with pointarray^[i-1] do
    begin
      x:=windowx(p^.x); y:=windowy(p^.y);
      p:=p^.next;
    end;
    picture.bitmap.canvas.pen.mode:=canvas.pen.mode;
    polyline(canvas.handle,pointarray^,count);
    {invalidate;}
    freemem(pointarray,count*SizeOf(TPoint));
  end;
end;

procedure TMathimage.DrawPolygon(FloatPointList:TFloatpointlist);
{$IFDEF WINDOWS}
type  TPointArray=array[0..16320] of TPoint;
{$ENDIF}
{$IFDEF WIN32}
type TPointArray=array[0..1000000] of TPoint;
{$ENDIF}
var p:PFloatPoint; i:longint; pointarray:^TPointArray;
begin
  SelectClipRgn(canvas.handle,hregion);
  with FloatPointList do
  begin
    {$IFDEF WINDOWS}
    if count>16320 then
    begin
      raise EMathImageError.Create('Pointlist too long');
      exit;
    end;
    {$ENDIF}
    getmem(pointarray,count*SizeOf(TPoint));
    p:=firstpoint;
    for i:=1 to count do
    with pointarray^[i-1] do
    begin
      x:=windowx(p^.x); y:=windowy(p^.y);
      p:=p^.next;
    end;
    picture.bitmap.canvas.pen.mode:=canvas.pen.mode;
    polygon(canvas.handle,pointarray^,count);
    invalidate;
    freemem(pointarray,count*SizeOf(TPoint));
  end;
end;

procedure TMathimage.DrawPolyPolyline(FloatPointListList:TFloatpointlistlist);
{$IFDEF WIN32}
type  TPointArray=array[0..1000000] of TPoint;
      TCountArray=array[0..1000000] of Integer;
var p:PFloatPoint; q:TFloatPointList; i,j,k:longint;
        pointarray:^TPointArray; countarray:^TCountArray;
begin
  SelectClipRgn(canvas.handle,hregion);
  with FloatPointListList do
  begin
    getmem(pointarray,totalcount*SizeOf(TPoint));
    getmem(countarray,count*SizeOf(Integer));
    q:=firstlist; k:=0;
    for i:=1 to count do
    begin
      p:=q.firstpoint;
      for j:=1 to  q.count do
      begin
        with pointarray^[k] do
        begin
          x:=windowx(p^.x); y:=windowy(p^.y);
        end;
        inc(k);
        p:=p^.next;
      end;
      countarray^[i-1]:=q.count;
      q:=q.next;
    end;
    polypolyline(canvas.handle,pointarray^,countarray^,count);
    invalidate;
    freemem(pointarray,totalcount*SizeOf(TPoint));
    freemem(countarray,count*SizeOf(Integer));
  end;
end;
{$ENDIF}

{$IFDEF WINDOWS}
var q:TFloatPointList; i:longint;
begin
  If FloatPointListList.count>0 then
  with FloatPointListList do
  begin
    q:=Firstlist;
    For i:=1 to count do
    begin
      DrawPolyline(q);
      q:=q.next;
    end;
  end;
end;
{$ENDIF}



function max(x,y:extended):extended;
begin
  if x<y then result:=y else result:=x;
end;

function min(x,y:extended):extended;
begin
  if x<y then result:=x else result:=y;
end;


procedure TMathImage.makeradians;
begin
  thetaz:=pi*zrd3/180;
  thetay:=pi*yrd3/180;
  arad:=pi*alpha/360;
  sinz:=sin(thetaz); cosz:=cos(thetaz);
  siny:=sin(thetay); cosy:= cos(thetay);
  tana:=sin(arad)/cos(arad);
  rightz:=(zrd3+90) - 180*round((zrd3+90.0)/180);
  righty:=yrd3 - 180*round(yrd3/180);
  axd3:=exp(ln(x2d3-x1d3));
  ayd3:=exp(ln(y2d3-y1d3));
  azd3:=exp(ln(z2d3-z1d3));
  if ard3=false then
  begin
    axd3:=2/axd3;
    ayd3:=2/ayd3;
    azd3:=2/azd3;
  end else
  begin
    axd3:=max(max(axd3,ayd3),azd3);
    ayd3:=2/axd3; axd3:=ayd3; azd3:=ayd3;
  end;
  bxd3:=-axd3*(x1d3+x2d3)/2;
  byd3:=-ayd3*(y1d3+y2d3)/2;
  bzd3:=-azd3*(z1d3+z2d3)/2;
  ap:=min(height,width)/2/tana/vd;
  bxp:=width/2; byp:=height/2;
end;

function TMathImage.scalar(xb,yb,zb:extended):extended;
begin
  scalar:=yb*sinz*siny+zb*cosy+xb*siny*cosz;
end;

function TMathImage.dist(xb,yb,zb:extended):extended;
begin
  dist:=d3viewdist-scalar(xb,yb,zb);
end;

function TMathImage.d3distancetoviewer(x,y,z:extended):extended;
var xb,yb,zb:extended;
begin
  blockx(x,xb); blocky(y,yb); blockz(z,zb);
  d3distancetoviewer:=sqrt(sqr(d3viewdist*siny*sinz-yb)+
    sqr(d3viewdist*cosy-zb)+sqr(d3viewdist*siny*cosz-xb));
end;


procedure TMathImage.findbase(var i1,i2,i3:integer);
var dmax,d:extended; i,j,k:integer;
begin
  i1:=-1;i2:=-1;i3:=-1;
  dmax:=0;
  for i:=0 to 1 do
  for j:=0 to 1 do
  for k:=0 to 1 do
  begin
    d:=dist(-1+2*i,-1+2*j,-1+2*k);
    dmax:=max(dmax,d);
    if d=dmax then
    begin
      i1:=-1+2*i;i2:=-1+2*j;i3:=-1+2*k;
    end;
  end;
end;

procedure TMathImage.initworld;
var umin,umax,vmin,vmax,d2w:extended;
    i1,i2,i3:integer;
    i,j,k:integer;
begin
  if d3viewdist<0.0001 then d3viewdist:=0.0001;
  if alpha > 179 then alpha:=179;
  if alpha <0.01 then alpha:=0.01;
  makeradians;
  findbase(i1,i2,i3);
    if i1=-1 then basex:=x1d3 else basex:=x2d3;
    if i2=-1 then basey:=y1d3 else basey:=y2d3;
    if i3=-1 then basez:=z1d3 else basez:=z2d3;
    if i1=1 then frontx:=x1d3 else frontx:=x2d3;
    if i2=1 then fronty:=y1d3 else fronty:=y2d3;
    if i3=1 then frontz:=z1d3 else frontz:=z2d3;
end;

procedure TMathImage.d3setworld;
var sx1,sx2,sy1,sy2,sz1,sz2:extended;
begin
  sx1:=x1d3; sx2:=x2d3; sy1:=y1d3;
  sy2:=y2d3; sz1:=z1d3; sz2:=z2d3;
  try
    x1d3:=x1;
    x2d3:=x2;
    y2d3:=y2;
    y1d3:=y1;
    y2d3:=y2;
    z1d3:=z1;
    z2d3:=z2;
    initworld;
  except
    on E:EMatherror do
    begin
      raise EMathImageError.Create('Invalid D3-world bounds');
      x1d3:=sx1; x2d3:=sx2; y1d3:=sy1; y2d3:=sy2; z1d3:=sz1; z2d3:=sz2;
      initworld;
    end;
  end;
end;

procedure TMathImage.d3resetworld;
begin
  initworld;
end;

procedure TMathImage.blockx(x:extended;var xb:extended);
begin
  xb:=bxd3+axd3*x;
end;

procedure TMathImage.blocky(y:extended;var yb:extended);
begin
  yb:=byd3+ayd3*y;
end;

procedure TMathImage.blockz(z:extended;var zb:extended);
begin
  zb:=bzd3+azd3*z;
end;

procedure TMathImage.d3window(x,y,z:extended; var xs,ys:longint);
var xb,yb,zb,rad,tan,tempx,tempy,d,u,v:extended;
begin
  try
  blockx(x,xb);
  blocky(y,yb);
  blockz(z,zb);
  project(xb,yb,zb,u,v);
  tempx:=bxp+ap*u;
  if abs(tempx)<16000 then xs:=round(tempx)
  else if tempx<0 then xs:=-16000 else xs:=16000;
  tempy:=byp-ap*v;
  if abs(tempy)<16000 then ys:=round(tempy)
  else if tempy <0 then ys:=-16000 else ys:=16000;
  except
    on E:EMathError do
    begin
      raise EMathImageError.Create('D3-World to pixel transform fails');
      xs:=16000; ys:=16000;
    end;
  end;
end;

procedure TMathImage.project;
var scal,d:extended;
begin
  scal:=scalar(xb,yb,zb);
  d:=d3viewdist-scal;
  if righty<>0 then
      v:=(zb-scal*cosy)/siny
  else
      v:=-(yb*sinz+xb*cosz)/cosy;
  if rightz<>0 then
  u:=(Yb+sinz*(v*cosy-scal*siny))/cosz
    else
      u:=-Xb*sinz;
  if d<=0 then d:=1.e-10;
  u:=u/d;
  v:=v/d;
end;

procedure TMathImage.d3moveto(x,y,z:extended);
var xs,ys:longint;
begin
  d3window(x,y,z,xs,ys);
  canvas.moveto(xs,ys);
end;

procedure TMathImage.d3drawpoint(x,y,z:extended);
var xs,ys:longint;
begin
  d3window(x,y,z,xs,ys);
  canvas.pixels[xs,ys]:=canvas.pen.color;
end;

procedure TMathImage.d3drawline(x1,y1,z1,x2,y2,z2:extended);
var u1,v1,u2,v2:longint;
begin
  d3window(x1,y1,z1,u1,v1);
  d3window(x2,y2,z2,u2,v2);
  canvas.polyline([point(u1,v1),point(u2,v2),point(u1,v1)]);
end;

procedure TMathImage.d3drawlineto(x,y,z:extended);
var xs,ys:longint;
begin
    d3window(x,y,z,xs,ys);
    canvas.lineto(xs,ys);
end;


procedure TMathImage.drawoneaxis(x1,y1,z1,x2,y2,z2:extended;c:string);
var norms,wx,wy:extended;
    xs1,ys1,xs2,ys2:longint; vsx,vsy:extended;
begin
  d3drawline(x1,y1,z1,x2,y2,z2);
  d3window(x1,y1,z1,xs1,ys1);
  d3window(x2,y2,z2,xs2,ys2);
  vsx:=(xs2-xs1); vsy:=(ys2-ys1);
  norms:=sqrt(vsx*vsx+vsy*vsy);
  if norms>0 then
  begin
    vsx:=vsx/norms; vsy:=vsy/norms;
    wx:=(-vsx+vsy)/sqrt(2); wy:=(-vsy-vsx)/sqrt(2);
    canvas.moveto(xs2,ys2);
    canvas.lineto(xs2+round(5*wx),ys2+round(5*wy));
    wx:=(-vsx-vsy)/sqrt(2); wy:=(-vsy+vsx)/sqrt(2);
    canvas.moveto(xs2,ys2);
    canvas.lineto(xs2+round(5*wx),ys2+round(5*wy));
    canvas.textout(xs2-10,ys2-canvas.textheight(c)-4,c);
  end;
end;


procedure TMathImage.d3drawaxes;
var xs,ys,i,istart,ticks:longint;
    SaveBrush:TBrush;
    SavePen:TPen;
    t:string; itemp,tick:extended;


begin   {******* drawd3axes ******}
  SavePen:=TPen.Create;
  SaveBrush:=TBrush.Create;
  SavePen.assign(canvas.pen);
  savebrush.assign(canvas.brush);
  canvas.brush.style:=bsclear;
  drawoneaxis(x1d3,y1d3,z1d3,x2d3,y1d3,z1d3,xlabel);
  drawoneaxis(x1d3,y1d3,z1d3,x1d3,y2d3,z1d3,ylabel);
  drawoneaxis(x1d3,y1d3,z1d3,x1d3,y1d3,z2d3,zlabel);
  itemp:=ln((x2d3-x1d3)/8)/ln(10);
  if itemp>=0 then
   i:=trunc(itemp) else i:=trunc(itemp)-1;
  tick:=exp(i*ln(10));
  with canvas.font do size:=size-1;
  if tick>0 then
  begin
    istart:=round(x1d3/tick);
    while istart*tick<x1d3 do inc(istart);
    ticks:=round((x2d3-x1d3)/tick) div 4;
    i:=istart+ticks;
    if ticks<=500 then
    repeat
      d3window(i*tick,y1d3,z1d3,xs,ys);
      t:=floattostrf(i*tick,ffgeneral,3,3);
      with canvas do
      begin
        textout(xs-(textwidth(t) div 2), ys+6,t);
        moveto(xs,ys);
        lineto(xs,ys+6);
      end;
      i:=i+ticks;
    until i*tick>x2d3;
  end;
  itemp:=ln((y2d3-y1d3)/8)/ln(10);
  if itemp>=0 then
   i:=trunc(itemp) else i:=trunc(itemp)-1;
  tick:=exp(i*ln(10));
  if tick>0 then
  begin
    istart:=round(y1d3/tick);
    while istart*tick<y1d3 do inc(istart);
    ticks:=round((y2d3-y1d3)/tick) div 4;
    i:=istart+ticks;
    if ticks<=500 then
    repeat
      d3window(x1d3,i*tick,z1d3,xs,ys);
      t:=floattostrf(i*tick,ffgeneral,3,3);
      with canvas do
      begin
        textout(xs-(textwidth(t) div 2), ys+6,t);
        moveto(xs,ys);
        lineto(xs,ys+6);
      end;
      i:=i+ticks;
    until i*tick>y2d3;
  end;
  itemp:=ln((z2d3-z1d3)/8)/ln(10);
  if itemp>=0 then
   i:=trunc(itemp) else i:=trunc(itemp)-1;
  tick:=exp(i*ln(10));
  if tick>0 then
  begin
    istart:=round(z1d3/tick);
    while istart*tick<z1d3 do inc(istart);
    ticks:=round((z2d3-z1d3)/tick) div 4;
    i:=istart+ticks;
    if ticks<=500 then
    repeat
      d3window(x1d3,y1d3,i*tick,xs,ys);
      t:=floattostrf(i*tick,ffgeneral,3,3);
      with canvas do
      begin
        textout(xs-textwidth(t)-6, ys-(textheight(t) div 2),t);
        moveto(xs,ys);
        lineto(xs-6,ys);
      end;
      i:=i+ticks;
    until i*tick>z2d3;
  end;
  with font do size:=size+1;
  canvas.brush.assign(savebrush);
  canvas.pen.assign(savepen);
  savebrush.free;
  savepen.free;
end;

procedure TMathImage.d3drawzerocross;
begin
   if 0>=x1d3 then if 0<=x2d3 then if 0>=z1d3 then if 0<=z2d3 then
   d3drawline(0,y1d3,0,0,y2d3,0);
   if 0>=z1d3 then if 0<=z2d3 then if 0>=y1d3 then if 0<=y2d3 then
   d3drawline(x1d3,0,0,x2d3,0,0);
   if 0>=y1d3 then if 0<=y2d3 then if 0>=x1d3 then if 0<=x2d3 then
   d3drawline(0,0,z1d3,0,0,z2d3);
end;

procedure TMathImage.d3drawworldbox;
var i:integer; delta:extended; savestyle:tpenstyle;
savecolor:tcolor;
begin
  savestyle:=canvas.pen.style;
  canvas.pen.style:=pssolid;
  {canvas.pen.color:=clblack;}
    d3drawline(basex,basey,basez,frontx,basey,basez);
    d3drawline(basex,basey,basez,basex,fronty,basez);
    d3drawline(basex,basey,basez,basex,basey,frontz);
    d3drawline(basex,fronty,basez,frontx,fronty,basez);
    d3drawline(basex,fronty,basez,basex,fronty,frontz);
    d3drawline(basex,basey,frontz,frontx,basey,frontz);
    d3drawline(basex,basey,frontz,basex,fronty,frontz);
    d3drawline(frontx,basey,basez,frontx,fronty,basez);
    d3drawline(frontx,basey,basez,frontx,basey,frontz);
 canvas.pen.style:=savestyle;
end;

procedure TMathimage.D3Polyline(FloatPointList:TD3Floatpointlist);
{$IFDEF WINDOWS}
type  TPointArray=array[0..16320] of TPoint;
{$ENDIF}
{$IFDEF WIN32}
type TPointArray=array[0..1000000] of TPoint;
{$ENDIF}
var p:PD3FloatPoint; xw,yw,i:longint; pointarray:^TPointArray;
begin
  SelectClipRgn(canvas.handle,hregion);
  with FloatPointList do
  begin
    {$IFDEF WINDOWS}
    if count>16320 then begin {Output error message} exit; end;
    {$ENDIF}
    getmem(pointarray,count*SizeOf(TPoint));
    p:=firstpoint;
    for i:=1 to count do
    with pointarray^[i-1] do
    begin
      D3window(p^.x,p^.y,p^.z,xw,yw);
      x:=xw; y:=yw;
      p:=p^.next;
    end;
    polyline(canvas.handle,pointarray^,count);
    invalidate;
    freemem(pointarray,count*SizeOf(TPoint));
  end;
end;

procedure TMathimage.D3PolyPolyline(FloatPointListList:TD3Floatpointlistlist);
{$IFDEF WIN32}
type  TPointArray=array[0..1000000] of TPoint;
      TCountArray=array[0..1000000] of Integer;
var p:PD3FloatPoint; q:TD3FloatPointList; xw,yw:longint;
    i,j,k:longint;
    pointarray:^TPointArray;
    countarray:^TCountArray;
begin
  SelectClipRgn(canvas.handle,hregion);
  with FloatPointListList do
  begin
    getmem(pointarray,totalcount*SizeOf(TPoint));
    getmem(countarray,count*SizeOf(Integer));
    q:=firstlist; k:=0;
    for i:=1 to count do
    begin
      p:=q.firstpoint;
      for j:=1 to  q.count do
      begin
        with pointarray^[k] do
        begin
          d3window(p^.x,p^.y,p^.z,xw,yw);
          x:=xw; y:=yw;
        end;
        inc(k);
        p:=p^.next;
      end;
      countarray^[i-1]:=q.count;
      q:=q.next;
    end;
    polypolyline(canvas.handle,pointarray^,countarray^,count);
    invalidate;
    freemem(pointarray,totalcount*SizeOf(TPoint));
    freemem(countarray,count*SizeOf(Integer));
  end;
end;
{$ENDIF}

{$IFDEF WINDOWS}
var q:TD3FloatPointList; i:longint;
begin
  If FloatPointListList.count>0 then
  with FloatPointListList do
  begin
    q:=Firstlist;
    For i:=1 to count do
    begin
      D3Polyline(q);
      q:=q.next;
    end;
  end;
end;
{$ENDIF}

procedure TMathimage.D3StartRotatingleft(increment:extended);
var inc:extended;
begin
  rotating:=true;
  inc:=increment;
  if ((d3yrotation>0) and (trunc(d3yrotation/180) mod 2=1))
     or ((d3yrotation<=0) and (trunc(d3yrotation/180) mod 2=0))
  then inc:=-inc;
  while rotating do
  begin
    d3zrotation:=d3zrotation-inc;
    if Assigned(FOnRotating) then FOnRotating(self);
    application.processmessages;
  end;
end;

procedure TMathimage.D3StartRotatingright(increment:extended);
var inc:extended;
begin
  rotating:=true;
  inc:=increment;
  if ((d3yrotation>0) and (trunc(d3yrotation/180) mod 2=1))
     or ((d3yrotation<=0) and (trunc(d3yrotation/180) mod 2=0))
  then inc:=-inc;
  while rotating do
  begin
    d3zrotation:=d3zrotation+inc;
    if Assigned(FOnRotating) then FOnRotating(self);
    application.processmessages;
  end;
end;

procedure TMathimage.D3StartRotatingup(increment:extended);
begin
  rotating:=true;
  while rotating do
  begin
    d3yrotation:=d3yrotation-increment;
    if assigned(FOnRotating) then FOnRotating(self);
    application.processmessages;
  end;
end;

procedure TMathimage.D3StartRotatingdown(increment:extended);
begin
  rotating:=true;
  while rotating do
  begin
    d3yrotation:=d3yrotation+increment;
    if assigned(FOnRotating) then FOnRotating(self);
    application.processmessages;
  end;
end;

procedure TMathimage.D3StopRotating;
begin
  Rotating:=false;
  If Assigned(FOnEndRotate) then FOnEndRotate(self);
end;

procedure TMathImage.D3StartMovingIn(increment:extended);
begin
  Moving:=true;
  While moving do
  begin
    d3viewdist:=d3viewdist*(1-increment);
    if assigned(FOnMoving) then FOnMoving(self);
    application.processmessages;
  end;
end;

procedure TMathImage.D3StartMovingOut(increment:extended);
begin
  Moving:=true;
  While moving do
  begin
    d3viewdist:=d3viewdist*(1+increment);
    if assigned(FOnMoving) then FOnMoving(self);
    application.processmessages;
  end;
end;

procedure TMathimage.D3StopMoving;
begin
  moving:=false;
  if assigned(FOnEndMove) then FOnEndMove(self);
end;

procedure TMathimage.D3StartZoomingIn(increment:extended);
begin
  Zooming:=true;
  while zooming do
  begin
    d3viewangle:=d3viewangle*(1-increment);
    if assigned(FOnZooming) then FOnZooming(self);
    application.processmessages;
  end;
end;

procedure TMathimage.D3StartZoomingOut(increment:extended);
begin
  zooming:=true;
  while zooming do
  begin
    d3viewangle:=d3viewangle*(1+increment);
    if assigned(FOnZooming) then FOnZooming(self);
    application.processmessages;
  end;
end;

procedure TMathimage.D3StopZooming;
begin
  Zooming := False;
  if assigned(FOnEndZoom) then FOnEndZoom(self);
end;

{Surface}

type
     PD3Point=^TD3Point;
     TD3point=record
             pt:TPoint;
             dist:single;
            end;
     {$IFDEF WINDOWS}
     PD3PointArray=^TD3PointArray;
     TD3PointArray=array[0..300] of PD3Point;
     {$ENDIF}

     PCell=^TCell;
     TCell=record
             vertex:array[0..3] of PD3Point;
             dist:single;
           end;
     TListCompare=function(item1,item2:pointer):integer;

function Compare(item1,item2:pointer):integer; far;
var Cell1,Cell2:PCell;
begin
  Cell1:=PCell(item1);
  Cell2:=PCell(item2);
  if Cell1^.dist>Cell2^.dist then result:=-1
  else if Cell1^.dist<Cell2^.dist then result:=1
  else result:=0;
end;

{$IFDEF WINDOWS}
procedure sort(var AList:Tlist; compare: TListCompare);

  procedure QuickSort(var AList:TList; compare: TListCompare; iLo,iHi:integer);
  var Lo, Hi:integer; Mid: pointer;
  begin
    with AList do
    begin
      Lo := iLo;
      Hi := iHi;
      Mid := items[(Lo + Hi) div 2];
      repeat
        while Compare(items[Lo],Mid)<0 do Inc(Lo);
        while Compare(items[Hi],Mid)>0 do Dec(Hi);
        if Lo <= Hi then
        begin
          Exchange(Lo,Hi);
          Inc(Lo);
          Dec(Hi);
        end;
      until Lo > Hi;
      if Hi > iLo then QuickSort(AList,Compare,iLo, Hi);
      if Lo < iHi then QuickSort(AList,Compare, Lo, iHi);
    end;
  end;
begin
  Quicksort(Alist,Compare,0,Alist.count-1);
end;
{$ENDIF}

procedure TMathImage.d3drawsurface(surface:TSurface; fill,NoUpdate:boolean);
var i,j,xw,yw,color,savecolor:longint;
    Alist:Tlist;
    ACell:PCell;
    Apoint:TD3FloatPoint;
    p0,p1,p2,p3:PD3Point;
    {$IFDEF WINDOWS}
    Screensurface:array[0..300] of PD3PointArray;
    {$ENDIF}
    {$IFDEF WIN32}
    ScreenSurface:array[0..300,0..300] of PD3Point;
    {$ENDIF}
begin
  if assigned(surface) then
  begin
  if not surface.error then
  with surface do
  begin
    for i:=0 to xmesh do
    begin
      {$IFDEF WINDOWS}
      new(screensurface[i]);
      {$ENDIF}
      for j:=0 to ymesh do
      begin
        Apoint:=D3Point(i,j);
        {$IFDEF WINDOWS}
        new(screensurface[i]^[j]);
        with screensurface[i]^[j]^ do
        {$ENDIF}
        {$IFDEF WIN32}
        new(screensurface[i,j]);
        with screensurface[i,j]^ do
        {$ENDIF}
        with Apoint do
        begin
          D3Window(x,y,z,xw,yw);
          pt.x:=xw; pt.y:=yw;
          dist:=d3distancetoviewer(x,y,z);
        end;
      end;
    end;
    if fill then
    begin
      Alist:=Tlist.create;
      Alist.Capacity:=2*xmesh*ymesh;
      for i:=0 to xmesh-1 do
      for j:=0 to ymesh-1 do
      begin
        if not NoUpdate then application.processmessages;
        New(ACell);
        p0:={$IFDEF WINDOWS}screensurface[i]^[j];{$ENDIF}
            {$IFDEF WIN32}  screensurface[i,j];{$ENDIF}
        p1:={$IFDEF WINDOWS}screensurface[i+1]^[j];{$ENDIF}
            {$IFDEF WIN32}  screensurface[i+1,j];{$ENDIF}
        p2:={$IFDEF WINDOWS}screensurface[i+1]^[j+1];{$ENDIF}
            {$IFDEF WIN32}  screensurface[i+1,j+1];{$ENDIF}
        p3:={$IFDEF WINDOWS}screensurface[i]^[j+1];{$ENDIF}
             {$IFDEF WIN32} screensurface[i,j+1];{$ENDIF}
        ACell^.vertex[0]:=p0;
        ACell^.vertex[1]:=p1;
        ACell^.vertex[2]:=p2;
        ACell^.vertex[3]:=p3;
        ACell^.dist:=(p0^.dist+p1^.dist+p2^.dist+p3^.dist)/4;
        AList.add(ACell);
      end;
      {$IFDEF WINDOWS}
      Sort(Alist,Compare);
      {$ENDIF}
      {$IFDEF WIN32}
      Alist.Sort(Compare);
      {$ENDIF}
      with AList do
      begin
        repaint;
        for i:=0 to count-1 do
        begin
          ACell:=PCell(items[i]);
          with ACell^ do
          canvas.polygon([vertex[0]^.pt,vertex[1]^.pt,vertex[2]^.pt,vertex[3]^.pt]);
          if not NoUpdate then if i mod 20 =0 then
          begin
            repaint;
            application.processmessages;
          end;
        end;
        for i:=0 to count-1 do
        begin
          Acell:=PCell(items[i]);
          dispose(Acell);
        end;
      end;
      Alist.free;
    end {if fill}
    else
    begin
      for i:=0 to xmesh do
      begin
        if not NoUpdate then
        begin
          repaint;
          application.processmessages;
        end;
        for j:=0 to ymesh do
        begin
          {$IFDEF WINDOWS}
          with screensurface[i]^[j]^ do
          canvas.moveto(pt.x,pt.y);
          if j<ymesh then
          with screensurface[i]^[j+1]^ do
          canvas.lineto(pt.x,pt.y);
          with screensurface[i]^[j]^ do
          canvas.moveto(pt.x,pt.y);
          if i<xmesh then
          with screensurface[i+1]^[j]^ do
          canvas.lineto(pt.x,pt.y);
          {$ENDIF}
          {$IFDEF WIN32}
          with screensurface[i,j]^ do
          canvas.moveto(pt.x,pt.y);
          if j<ymesh then
          with screensurface[i,j+1]^ do
          canvas.lineto(pt.x,pt.y);
          with screensurface[i,j]^ do
          canvas.moveto(pt.x,pt.y);
          if i<xmesh then
          with screensurface[i+1,j]^ do
          canvas.lineto(pt.x,pt.y);
          {$ENDIF}
        end; {for j}
      end; {for i}
    end; {if not fill}
    for i:=0 to xmesh do
    begin
      for j:=0 to ymesh do
      {$IFDEF WINDOWS}
      Dispose(ScreenSurface[i]^[j]);
      Dispose(ScreenSurface[i]);
      {$ENDIF}
      {$IFDEF WIN32}
      Dispose(ScreenSurface[i,j]);
      {$ENDIF}
    end;
  end {if not surface.error} else
  raise ESurfaceError.Create('Surface has not been created right');
  end else
  raise ESurfaceError.Create('Surface has not been created');
end;

end.
