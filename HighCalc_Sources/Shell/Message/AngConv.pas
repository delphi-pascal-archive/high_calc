unit AngConv;

interface
uses
  SysUtils;
function Deg(const d,m,s:extended):extended;
function DegToRad(const d,m,s:extended):extended;
function DegToGrad(const d,m,s:extended):extended;
function RadToDeg(const r:extended):extended;
function RadToGrad(const r:extended):extended;
function GradToDeg(const g:extended):extended;
function GradToRad(const g:extended):extended;
function DegToDms(const v:extended):string;

implementation
const
  k=PI/180;
  k1=180/PI;
  dggr=1/0.9;
  rgr=k1*dggr;
  grr=0.9*k1;
  km=1/60;
  ks=1/3600;
//Преобразование угловых величин
function Deg(const d,m,s:extended):extended;
begin
  Result:=d+km*m+ks*s;
end;

function DegToRad(const d,m,s:extended):extended;
begin
  Result:=k*(d+km*m+ks*s);
end;

function DegToGrad(const d,m,s:extended):extended;
begin
  Result:=dggr*(d+km*m+ks*s);
end;

function RadToDeg(const r:extended):extended;
begin
  Result:=r*k1;
end;

function RadToGrad(const r:extended):extended;
begin
  Result:=r*rgr;
end;

function GradToDeg(const g:extended):extended;
begin
  Result:=g*0.9;
end;

function GradToRad(const g:extended):extended;
begin
  Result:=g*grr;
end;

function DegToDms(const v:extended):string;
var
  d,m,s:extended;
begin
  d:=Int(v);
  m:=Frac(v)*60;
  s:=Frac(m)*60;
  m:=Int(m);
  Result:=Format('%gD%g''%g"',[d,m,s]);
end;

end.
