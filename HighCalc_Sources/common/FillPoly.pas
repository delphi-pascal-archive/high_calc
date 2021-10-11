unit FillPoly;

interface
uses  GrMath,windows;

type
   TPolygonLens=array of integer;
procedure GetFillPoints(var Points: RealPointArr;Polygons:RealPolyLineArr;
                            Angle1:double=0;Step1:double=1;
                            Angle2:double=90;Step2:double=1);overload;
procedure GetFillPoints(var Points: PointArr;Metr:PointArr;Hole1:PolyLineArr;
                            Angle1:double=0;Step1:double=1;
                            Angle2:double=90;Step2:double=1);overload;

function IsPtInPoly(Point:TRealPoint;
                       Polygons:RealPolyLineArr):boolean;overload;
Function IsPtInPoly(Point:TPoint;
                       Polygons:IntPolyLineArr):boolean;overload;
Function IsPtInPoly(Point:TPoint;
                       Polygons1:PolyLineArr):boolean;overload;
function IsRectInPoly(Rect:TRealRect;Polygons:RealPolyLineArr):boolean;overload;
function IsRectInPoly(Rect:TRect;Polygons:PolyLineArr):boolean;overload;

Procedure Trans01(const n : Integer; x0,y0,cosa,sina,xc,yc : Double;
                          var xn,yn : Double);

implementation
    Procedure Trans01(const n : Integer; x0,y0,cosa,sina,xc,yc : double;
                           var xn,yn : double);
          begin
         If n=0 then begin
            xn:=x0+xc*cosa-yc*sina;
            yn:=y0+xc*sina+yc*cosa;
           end else begin
            xn:= (xc-x0)*cosa+(yc-y0)*sina;
            yn:=-(xc-x0)*sina+(yc-y0)*cosa;
        end;
     end;


procedure GetFillPoints(var Points: RealPointArr;Polygons:RealPolyLineArr;
                            Angle1:double=0;Step1:double=1;
                            Angle2:double=90;Step2:double=1);

var Ncont,nc,i,j,nx,ny : Integer;
    dyn,Dl2,xz,yz,x0,y0,xzn,yzn,dl2z,
    xs,ys,xf,yf,cosa1,sina1,cosa2,sina2 : Double;
    P : TRealpoint;

  Procedure PointInterior(Polygons:RealPolyLineArr;
                          xs,ys,xf,yf : Double; var P : TRealPoint);
   const CountIter=10;
   var n,iter,i,j : Integer;
   dx,dy : double;
   Pz : TRealPoint;
  begin
    iter:=0;
    n:=10;
   while Iter <= CountIter do
    begin
     dx:=(xf-xs)/n;
     dy:=(yf-ys)/n;
      for i:=1 to n-1 do
      begin
       Pz.x:=xs+dx*i;
      for j:=1 to n-1 do
      begin
       Pz.y:=ys+dy*i;
       if  IsPtInPoly(Pz,Polygons) then
        begin
         P:=Pz;
         exit;
        end;
      end;
      end;
       n:=n*2 + 1;
       Inc(Iter);
    end;

    P.x:=(xs+xf)/2;
    P.y:=(ys+yf)/2;
  end;

begin
  Ncont:=Length(Polygons);
         xs:=Polygons[0][0].x;
         ys:=Polygons[0][0].y;
         xf:=Polygons[0][0].x;
         yf:=Polygons[0][0].y;
        for i:=0 to ncont-1 do
         begin
          Nc:=Length(Polygons[i]);
         for  j:=0 to nc-1 do
         begin
          if(xs > Polygons[i][j].x) then xs:=Polygons[i][j].x;
          if(ys > Polygons[i][j].y) then ys:=Polygons[i][j].y;
          if(xf < Polygons[i][j].x) then xf:=Polygons[i][j].x;
          if(yf < Polygons[i][j].y) then yf:=Polygons[i][j].y;
         end;
        end;

        cosa1:=cos(Angle1*pi/180);
        sina1:=sin(Angle1*pi/180);
        cosa2:=cos(Angle2*pi/180);
        sina2:=sin(Angle2*pi/180);
        y0:=ys;
        X0:=xs-(yf-ys)*cosa2;
        PointInterior(Polygons,xs,ys,xf,yf , P );
         Dyn:=P.y - ys;
         Dl2:=Dyn/Sina2;
         xz:=x0+dl2*cosa2;
         yz:=y0+dl2*cosa2;
         nx:=Trunc((P.x-xz)/step1 + 1);
         Ny:=Trunc(dl2/step2 +1);
         xzn:=P.x-step1*nx;
         yzn:=yz;
         dl2z:=ny*step2;
         X0:=xzn - dl2z*cosa2;
         Y0:=yzn - dl2z*sina2;
          xz:=x0;
          yz:=y0;
          nx:=0;

      While (yz < yf) do
      begin
       While (xz < xf ) do
        begin
         P.x:=xz;
         P.y:=yz;
         if IsPtInPoly(P,Polygons ) then
          begin
           Inc(nx);
           SetLength(Points,nx);
           Points[nx-1]:=P;
          end;
          xz:=xz+step1*cosa1;
          yz:=yz+step1*sina1;
        end;
        x0:=x0+step2*cosa2;
        y0:=y0+step2*sina2;
        xz:=x0;
        yz:=y0;
      end;
 end;// GetFillPoints



Function IsPtInPoly(Point:TRealPoint;
                       Polygons:RealPolyLineArr):boolean;
   var NC,Ncont,i,j,ngr : integer;
       TF : boolean;
       Xz,Yz,xs,ys,xf,yf,ygr : Double;
       PSG : RealPointArr;

begin
  Ncont:=Length(Polygons);
  Xz:=Point.x;
  Yz:=Point.y;
         TF:=FALSE;
         Ngr:=0;
//         SetLength(Psg,ngr);
        for i:=0 to ncont-1 do
         begin
          Nc:=Length(Polygons[i]);
         for  j:=0 to nc-2 do
         begin
          xs:=Polygons[i][j].x;
          ys:=Polygons[i][j].y;
          xf:=Polygons[i][j+1].x;
          yf:=Polygons[i][j+1].y;
          if((((xz >  Xs) and (xz <= Xf)) or
              ((xz <= Xs) and (xz >  Xf)))) then
            begin
             ygr := Ys+(Yf-Ys)/(Xf-Xs)*(xz-Xs);
             Inc(ngr);
             SetLength(Psg,ngr);
             Psg[ngr-1].x:=xz;
             Psg[ngr-1].y:=ygr;
            end; //if
         end;//j
        end;// I

        if (ngr = 0) or (ngr mod 2 =1) then
         begin
         Result:=false;
         if Psg <> Nil then   Psg:=Nil;
         exit;
         end;

        for i:=0 to ngr-2 do
        for j:=i+1 to ngr-1 do
        begin
        if (Psg[i].y > Psg[j].y) then
         begin
         Ygr:=Psg[j].y;
         Psg[j].y:=Psg[i].y;
         Psg[i].y:=ygr;
         end;
        end;

       for i:=0 to ngr div 2 - 1 do
       begin
       if (Psg[2*i].y < yz) and (yz < Psg[2*i+1].y) then
        begin
         Tf:=True;
         Break;
        end;
       end;

        Result:=Tf;
         Psg:=Nil;
end;

Function IsPtInPoly(Point:TPoint;
                       Polygons1:PolyLineArr):boolean;
var
   Polygons:IntPolyLineArr;
begin
    PolyLineArrToIntPolyLineArr(Polygons1,Polygons);
    result:=IsPtInPoly(Point, Polygons);
end;
Function IsPtInPoly(Point:TPoint;
                       Polygons:IntPolyLineArr):boolean;
   var NC,Ncont,i,j,ngr : integer;
       TF : boolean;
       Xz,Yz,xs,ys,xf,yf,ygr : Double;
       PSG : RealPointArr;
//       Polygons:IntPolyLineArr;
begin
//  PolyLineArrToIntPolyLineArr(Polygons1,Polygons);
  Ncont:=Length(Polygons);//Число полигонов
  Xz:=Point.x;
  Yz:=Point.y;
         TF:=FALSE;
         Ngr:=0;
//         SetLength(Psg,ngr);
        for i:=0 to ncont-1 do//Цикл по полигонам
        begin
          if Polygons[i]<>nil then
              Nc:=Length(Polygons[i])
          else Nc:=0;
          for  j:=0 to nc-2 do //Цикл по точкам полигона
          begin
            xs:=Polygons[i][j].x;
            ys:=Polygons[i][j].y;
            xf:=Polygons[i][j+1].x;
            yf:=Polygons[i][j+1].y;
            if((((xz >  Xs) and (xz <= Xf)) or
                 ((xz <= Xs) and (xz >  Xf)))) then begin
                 ygr := Ys+(Yf-Ys)/(Xf-Xs)*(xz-Xs);
                 Inc(ngr);
                 SetLength(Psg,ngr);
                 Psg[ngr-1].x:=xz;
                 Psg[ngr-1].y:=ygr;
            end; //if
          end;//j
        end;// I

        if (ngr = 0) or (ngr mod 2 =1) then
         begin
         Result:=false;
         if Psg <> Nil then   Psg:=Nil;
         exit;
         end;

        for i:=0 to ngr-2 do
        for j:=i+1 to ngr-1 do
        begin
        if (Psg[i].y > Psg[j].y) then
         begin
         Ygr:=Psg[j].y;
         Psg[j].y:=Psg[i].y;
         Psg[i].y:=ygr;
         end;
        end;

       for i:=0 to ngr div 2 - 1 do
       begin
       if (Psg[2*i].y < yz) and (yz < Psg[2*i+1].y) then
        begin
         Tf:=True;
         Break;
        end;
       end;

        Result:=Tf;
         Psg:=Nil;
end;


function IsRectInPoly(Rect:TRealRect;Polygons:RealPolyLineArr):boolean;
  var  p1 : TRealPoint;
begin
    p1.x:=Rect.Left;
    p1.y:=Rect.Top;
    if not IsPtInPoly(P1,Polygons) then
     begin
     result:=false;
     exit;
     end;

    p1.x:=Rect.Left;
    p1.y:=Rect.Bottom;
    if not IsPtInPoly(P1,Polygons) then
     begin
     result:=false;
     exit;
     end;

    p1.x:=Rect.Right;
    p1.y:=Rect.Top;
    if not IsPtInPoly(P1,Polygons) then
     begin
     result:=false;
     exit;
     end;

    p1.x:=Rect.Right;
    p1.y:=Rect.Bottom;
    if not IsPtInPoly(P1,Polygons) then
     begin
     result:=false;
     exit;
     end;

    Result:=True;
end;
function IsRectInPoly(Rect:TRect;Polygons:PolyLineArr):boolean;
  var  p1 : TPoint;
begin
    p1.x:=Rect.Left;
    p1.y:=Rect.Top;
    if not IsPtInPoly(P1,Polygons) then
     begin
     result:=false;
     exit;
     end;

    p1.x:=Rect.Left;
    p1.y:=Rect.Bottom;
    if not IsPtInPoly(P1,Polygons) then
     begin
     result:=false;
     exit;
     end;

    p1.x:=Rect.Right;
    p1.y:=Rect.Top;
    if not IsPtInPoly(P1,Polygons) then
     begin
     result:=false;
     exit;
     end;

    p1.x:=Rect.Right;
    p1.y:=Rect.Bottom;
    if not IsPtInPoly(P1,Polygons) then
     begin
     result:=false;
     exit;
     end;

    Result:=True;
end;
procedure GetFillPoints(var Points: PointArr;Metr:PointArr;Hole1:PolyLineArr;
                            Angle1:double=0;Step1:double=1;
                            Angle2:double=90;Step2:double=1);overload;
var
  FullMetr:RealPolyLineArr;
  RealPoints:RealPointArr;
  Hole:IntPolyLineArr;
  i,j,n,m:integer;
begin
  PolyLineArrToIntPolyLineArr(Hole1,Hole);
  if Hole<>nil then
     SetLength(FullMetr,Length(Hole)+1)
  else
     SetLength(FullMetr,1);
  n:=Metr.Length;
  SetLength(FullMetr[0],n);
  n:=n-1;
  for i:=0 to n do
  begin
     FullMetr[0][i].x:=Metr[i].x;
     FullMetr[0][i].y:=Metr[i].y;
  end;
  n:=Length(FullMetr)-2;
  for i:=1 to n do
  begin
     m:=Length(Hole[i-1]);
     SetLength(FullMetr[i],m);
     dec(m);
     for j:=0 to m do
     begin
        FullMetr[i][j].x:=Hole[i-1][j].x;
        FullMetr[i][j].y:=Hole[i-1][j].y;
     end;
  end;
  GetFillPoints(RealPoints,FullMetr,Angle1,Step1,Angle2,Step2);
  n:=Length(RealPoints);
  Points.SetLength(n);
  dec(n);
  for i:=0 to n do
  begin
     Points.x[i]:=round(RealPoints[i].x);
     Points.y[i]:=round(RealPoints[i].y);
  end;
end;

end.





