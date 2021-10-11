unit FunLib;

interface
uses
  Math,MaxMin,UnlimitedFloat,UnlimitedFunLib,FunDefConst,SysUtils,AllMessages,
  Dialogs,Forms,AngConv;
procedure InitFunLib;
procedure InitNewFuncs;
implementation
uses Formula,PlotUn,CodeConst,DecodeUnit,GrumbUnit,main,MandlbrUn;

{$ifndef BettaVersion}
Procedure OpLicensedSin(Stack:TFormulaExecute);
begin
  Raise Exception.Create(LicensedSin);
end;

Procedure OpLicensedCos(Stack:TFormulaExecute);
begin
  Raise Exception.Create(LicensedCos);
end;

Procedure OpLicensedExp(Stack:TFormulaExecute);
begin
  Raise Exception.Create(LicensedExp);
end;

{$endif}
Procedure OpPlus(Stack:TFormulaExecute);
var
   x,y:TUnlimitedFloat;
begin
    x:=Stack.Pop;
    y:=Stack.Pop;
    x.Plus(y);
    y.Free;
    Stack.x.Let(x);
    x.Free;
end;

Procedure ExtendedOpAddition(Stack:TFormulaExecute);
var
   y:Extended;
begin
    Stack.Pop(y);
    Stack.ExtendedX:=Stack.ExtendedX+y;
end;

Procedure ExtendedOpSubtraction(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=y-Stack.ExtendedX;
end;

Procedure ExtendedOpMultiplication(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=Stack.ExtendedX*y;
end;

Procedure ExtendedOpDivision(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=y/Stack.ExtendedX;
end;

Procedure ExtendedOpModulo(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=Trunc(y) mod Trunc(Stack.ExtendedX);
end;

Procedure ExtendedOpPercentage(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=Stack.ExtendedX*y*0.01;
end;

Procedure ExtendedOpIntegerDivision(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=Trunc(y) div Trunc(Stack.ExtendedX);
end;

Procedure ExtendedOpPower(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=Power(y,Stack.ExtendedX);
end;

Procedure ExtendedOpSetVariable(Stack:TFormulaExecute);
var
  y:Extended;
  VarCod:integer;
begin
  Stack.Pop(y);
  VarCod:=round(y);
  Stack.SetVariable(VarCod,FloatToStr(Stack.ExtendedX));
end;

Procedure ExtendedOpTestsEqualValues(Stack:TFormulaExecute);//todo: Доработать ввести Epsilon 
var
  y:Extended;
begin
  Stack.Pop(y);
  if Stack.ExtendedX=y then
    Stack.ExtendedX:=1
  else
    Stack.ExtendedX:=0;
end;

Procedure ExtendedOpBigger(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  if Stack.ExtendedX<y then
    Stack.ExtendedX:=1
  else
    Stack.ExtendedX:=0;
end;

Procedure ExtendedOpSmaller(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  if Stack.ExtendedX>y then
    Stack.ExtendedX:=1
  else
    Stack.ExtendedX:=0;
end;

Procedure ExtendedOpXor(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=Trunc(Stack.ExtendedX) xor Trunc(y);
end;

Procedure ExtendedOpAnd(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=not (Trunc(Stack.ExtendedX) xor Trunc(y));
end;

Procedure ExtendedOpNand(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=not (Trunc(Stack.ExtendedX) xor Trunc(y));
end;

Procedure ExtendedOpXNor(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=not (Trunc(Stack.ExtendedX) xor Trunc(y));
end;

Procedure ExtendedOpOr(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=Trunc(Stack.ExtendedX) or Trunc(y);
end;

Procedure ExtendedOpNor(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=not (Trunc(Stack.ExtendedX) or Trunc(y));
end;

Procedure ExtendedOpNot(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=not Trunc(Stack.ExtendedX);
end;

Procedure ExtendedOpShl(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=Trunc(y) shl Trunc(Stack.ExtendedX);
end;

Procedure ExtendedOpShr(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=Trunc(y) shr Trunc(Stack.ExtendedX);
end;

//IV.

Procedure ExtendedOpLcm(Stack:TFormulaExecute);
begin
//    Stack.ExtendedX:=not Trunc(Stack.ExtendedX);
end;

Procedure ExtendedOpGcd(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=Trunc(Stack.ExtendedX) shl Trunc(y);
end;

Procedure ExtendedOpMin(Stack:TFormulaExecute);
var
  x:array of extended;
  n,i:integer;
begin
  n:=round(Stack.ExtendedX);
  SetLength(x,n);
  for i:=0 to n-1 do
     Stack.Pop(x[i]);
  Stack.ExtendedX:=MinFloat(x);
end;

Procedure ExtendedOpMax(Stack:TFormulaExecute);
var
  x:array of extended;
  n,i:integer;
begin
  n:=round(Stack.ExtendedX);
  SetLength(x,n);
  for i:=0 to n-1 do
     Stack.Pop(x[i]);
  Stack.ExtendedX:=MaxFloat(x);
end;

Procedure ExtendedOpFrac(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Frac(Stack.ExtendedX);
end;

Procedure ExtendedOpAbs(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Abs(Stack.ExtendedX);
end;

Procedure ExtendedOpIntg(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Int(Stack.ExtendedX);
end;

Procedure ExtendedOpRound(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Round(Stack.ExtendedX);
end;

Procedure ExtendedOpTrunc(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Trunc(Stack.ExtendedX);
end;

Procedure ExtendedOpLogten(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Log10(Stack.ExtendedX);
end;

Procedure ExtendedOpLogN(Stack:TFormulaExecute);
var
  y:Extended;
begin
  Stack.Pop(y);
  Stack.ExtendedX:=LogN(Stack.ExtendedX,y);
end;

Procedure ExtendedOpExp(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Exp(Stack.ExtendedX);
end;

procedure ExtendedOpLn(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Ln(Stack.ExtendedX);
end;

Procedure ExtendedOpCeil(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Ceil(Stack.ExtendedX);
end;

Procedure ExtendedOpFloor(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Floor(Stack.ExtendedX);
end;

Procedure ExtendedOpSqrt(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Sqrt(Stack.ExtendedX);
end;

Procedure ExtendedOpSqr(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Sqr(Stack.ExtendedX);
end;

Procedure ExtendedOpRandom(Stack:TFormulaExecute);
begin
    Stack.ExtendedX:=Random(round(Stack.ExtendedX));
end;

Procedure ExtendedOpAverage(Stack:TFormulaExecute);
var
   x,s:extended;
   n,i:integer;
begin
  n:=round(Stack.ExtendedX);
  s:=0;
  for i:=0 to n-1 do begin
     Stack.Pop(x);
     s:=x+s;
  end;
  Stack.ExtendedX:=s/n;
end;

Procedure ExtendedOpSum(Stack:TFormulaExecute);
var
  x,s:extended;
  n,i:integer;
begin
  n:=round(Stack.ExtendedX);
  s:=0;
  for i:=0 to n-1 do begin
     Stack.Pop(x);
     s:=x+s;
  end;
  Stack.ExtendedX:=s;
end;

Procedure ExtendedOpMul(Stack:TFormulaExecute);
var
  x,s:extended;
  n,i:integer;
begin
  n:=round(Stack.ExtendedX);
  s:=1;
  for i:=0 to n-1 do begin
     Stack.Pop(x);
     s:=x*s;
  end;
  Stack.ExtendedX:=s;
end;

//V. Trigonometric Functions

procedure ExtendedOpSin(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Sin(Stack.ExtendedX);
end;

Procedure ExtendedOpCos(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Cos(Stack.ExtendedX);
end;

Procedure ExtendedOpTan(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Tan(Stack.ExtendedX);
end;

Procedure ExtendedOpCot(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Cotan(Stack.ExtendedX);
end;

Procedure ExtendedOpSinh(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Sinh(Stack.ExtendedX);
end;

Procedure ExtendedOpCosh(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Cosh(Stack.ExtendedX);
end;

Procedure ExtendedOpTanh(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Tanh(Stack.ExtendedX);
end;

Procedure ExtendedOpArcsin(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=ArcSin(Stack.ExtendedX);
end;

Procedure ExtendedOpArccos(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=ArcCos(Stack.ExtendedX);
end;

Procedure ExtendedOpArctan(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=ArcTan(Stack.ExtendedX);
end;

Procedure ExtendedOpArccot(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Arccot(Stack.ExtendedX);
end;

Procedure ExtendedOpArcsinh(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Sinh(Stack.ExtendedX);
end;

procedure ExtendedOpArccosh(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Cosh(Stack.ExtendedX);
end;

Procedure ExtendedOpArctanh(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=ArcTanh(Stack.ExtendedX);
end;

Procedure ExtendedOpArccoth(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=Arccoth(Stack.ExtendedX);
end;

Procedure ExtendedOpSec(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=1/cos(Stack.ExtendedX);
end;

Procedure ExtendedOpCsc(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=1/sin(Stack.ExtendedX);
end;

Procedure ExtendedOpSech(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=1/cosh(Stack.ExtendedX);
end;

Procedure ExtendedOpCsch(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=1/sinh(Stack.ExtendedX);
end;

Procedure ExtendedOpArcsec(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=1/arccos(Stack.ExtendedX);
end;

Procedure ExtendedOpArccsc(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=1/arcsin(Stack.ExtendedX);
end;

Procedure ExtendedOpArcsech(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=1/arccosh(Stack.ExtendedX);
end;

Procedure ExtendedOpArccsch(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=1/arcsin(Stack.ExtendedX);
end;

//VI. Special Functions and Series

Procedure ExtendedOpFib(Stack:TFormulaExecute);
var
   x,Fib:Extended;
   f1,f2,f3:extended;
begin
  x:=Stack.ExtendedX;
  if( x < 2 ) then Fib := x
  else if x = 2 then  Fib := 1
  else begin
    f2 := 1;
    f3 := 2;
    while( x > 3 ) do begin
      f1 := f2;
      f2 := f3;
      f3 := f1 + f3;
      x := x - 1;
    end;
    Fib := f3;
  end;
  Stack.ExtendedX:=Fib;
end;

Procedure ExtendedOpBinom(Stack:TFormulaExecute);
var
   x,y:Extended;
begin
  Stack.Pop(x);
  Stack.ExtendedX:=Sqrt(x);
end;

Procedure ExtendedOpGamma(Stack:TFormulaExecute);
var
   x,y:Extended;
begin
  Stack.Pop(x);
  Stack.ExtendedX:=Sqr(x);
end;

Procedure ExtendedOpBeta(Stack:TFormulaExecute);
var
   x,y:Extended;
begin
    Stack.Pop(x);
    Stack.ExtendedX:=Floor(x);
end;

Procedure ExtendedOpHarmonic(Stack:TFormulaExecute);
var
   x,y:Extended;
begin
  Stack.Pop(x);
  Stack.ExtendedX:=Sqrt(x);
end;

Procedure ExtendedOpPochhammer(Stack:TFormulaExecute);
var
   x,y,m:Extended;
   i,n:integer;
begin
  y:=Stack.ExtendedX;
  Stack.Pop(x);
  n:=round(y)-1;
  m:=1;
  for i:=0 to n do
    m:=m*(x+i);
  Stack.ExtendedX:=m;
end;

Procedure ExtendedOpFermat(Stack:TFormulaExecute);
var
   x,y:Extended;
begin
    Stack.Pop(x);
    Stack.ExtendedX:=Floor(x);
end;

Procedure ExtendedOpBth(Stack:TFormulaExecute);
var
  x,y:Extended;
  CurrentN,CurrentU,Res:Extended;
  i,n:integer;
begin
  n:=round(Stack.ExtendedX);
  Stack.Pop(y);
  Stack.Pop(x);
  CurrentN:=1;
  CurrentU:=1;
  Res:=0;
  for i:=n downto 0 do
  begin
    Res:=Res+(Power(x,i)*Power(y,n-i)*CurrentN)/CurrentU;
    CurrentN:=CurrentN*i;
    CurrentU:=CurrentU*(n-i+1);
  end;
  Stack.ExtendedX:=Res;
end;

Procedure ExtendedOpBman(Stack:TFormulaExecute);
var
  x,y,nr:Extended;
begin
  nr:=Stack.ExtendedX;
  Stack.Pop(y);
  Stack.Pop(x);
  Stack.ExtendedX:=Power(x+y,nr);
end;

//VII. Primes and Numbers

//VIII. Integrals

//IX. Function Plots and Graphs
Procedure ExtendedOpPlot(Stack:TFormulaExecute);
var
  VarCodFloat,MinX,MaxX:Extended;
  VarCod:integer;
  Expression:string;
  FormulaExecute:TFormulaExecute;
begin
  MaxX:=Stack.ExtendedX;
  Stack.Pop(MinX);
  Stack.Pop(VarCodFloat);
  VarCod:=Round(VarCodFloat);
  Stack.Pop(Expression);
  PlotForm:=TPlotForm.Create(nil);
  PlotForm.Panel3D.Visible:=false;
  PlotForm.Show;
  PlotForm.Plot(Stack, Expression, VarCod, MinX,MaxX);
  Stack.ExtendedX:=0;
end;

Procedure ExtendedOpZPlot(Stack:TFormulaExecute);
var
  XCodF,YCodF,MinX,MaxX,MinY,MaxY:Extended;
  XCod,YCod:integer;
  Expression:string;
  FormulaExecute:TFormulaExecute;
begin
  MaxY:=Stack.ExtendedX;
  Stack.Pop(MinY);
  Stack.Pop(YCodF);
  Stack.Pop(MaxX);
  Stack.Pop(MinX);
  Stack.Pop(XCodF);
  XCod:=Round(XCodF);
  YCod:=Round(YCodF);
  Stack.Pop(Expression);
  PlotForm:=TPlotForm.Create(nil);
  PlotForm.Show;
  PlotForm.Plot3D(Stack, Expression, XCod,YCod,MinX,MaxX,MinY,MaxY);
  Stack.ExtendedX:=0;
end;


//X. Financial Functions

Procedure ExtendedOpSln(Stack:TFormulaExecute);
var
   cost,salvage,life:Extended;
begin
  life:=Stack.ExtendedX;
  Stack.Pop(salvage);
  Stack.Pop(cost);
  Stack.ExtendedX:=SLNDepreciation(cost,salvage,round(life));
end;

Procedure ExtendedOpSyd(Stack:TFormulaExecute);
var
   cost,salvage,life,Period:Extended;
begin
  Period:=Stack.ExtendedX;
  Stack.Pop(life);
  Stack.Pop(salvage);
  Stack.Pop(cost);
  Stack.ExtendedX:=SYDDepreciation(cost,salvage,
    round(life),round(Period));
end;

Procedure ExtendedOpCterm(Stack:TFormulaExecute);
var
   x:Extended;
begin
  Stack.Pop(x);
  Stack.ExtendedX:=Floor(x);
end;

Procedure ExtendedOpTerm(Stack:TFormulaExecute);
var
   x:Extended;
begin
    Stack.Pop(x);
    Stack.ExtendedX:=Floor(x);
end;

Procedure ExtendedOpPmt(Stack:TFormulaExecute);
var
   x:Extended;
begin
    Stack.Pop(x);
    Stack.ExtendedX:=Floor(x);
end;

Procedure ExtendedOpRate(Stack:TFormulaExecute);
var
   x:Extended;
begin
    Stack.Pop(x);
    Stack.ExtendedX:=Floor(x);
end;

Procedure ExtendedOpPv(Stack:TFormulaExecute);
var
   x:Extended;
begin
    Stack.Pop(x);
    Stack.ExtendedX:=Floor(x);
end;

Procedure ExtendedOpNpv(Stack:TFormulaExecute);
var
   x:Extended;
begin
    Stack.Pop(x);
    Stack.ExtendedX:=Floor(x);
end;

Procedure ExtendedOpFv(Stack:TFormulaExecute);
var
   x:Extended;
begin
    Stack.Pop(x);
    Stack.ExtendedX:=Floor(x);
end;

Procedure ExtendedOpDb(Stack:TFormulaExecute);
var
   x:Extended;
begin
    Stack.Pop(x);
    Stack.ExtendedX:=Floor(x);
end;

Procedure ExtendedOpDdb(Stack:TFormulaExecute);
var
   cost,salvage,life,period:Extended;
begin
  Period:=Stack.ExtendedX;
  Stack.Pop(life);
  Stack.Pop(salvage);
  Stack.Pop(cost);
  Stack.ExtendedX:= DoubleDecliningBalance(cost,salvage,
    round(life),round(Period));
end;

Procedure ExtendedOpExtFin(Stack:TFormulaExecute);
var
   x:Extended;
begin
    Stack.Pop(x);
    Stack.ExtendedX:=Floor(x);
end;

Procedure ExtendedOpH(Stack:TFormulaExecute);
var
  Value:string;
  x:TUnlimitedFloat;
begin
  Stack.Pop(Value);
  x:=TUnlimitedFloat.Create;
  try
    x.DecPrecision:=20;
    x.SetValueAsString(16,Value);
    Stack.ExtendedX:=StrToFloat(x.DecStr);
  finally
    x.Free;
  end;
end;

Procedure OpH(Stack:TFormulaExecute);
var
  Value:string;
begin
  Stack.Pop(Value);
  Stack.x.SetValueAsString(16,Value);
end;

Procedure ExtendedOpO(Stack:TFormulaExecute);
var
  Value:string;
  x:TUnlimitedFloat;
begin
  Stack.Pop(Value);
  x:=TUnlimitedFloat.Create;
  try
    x.DecPrecision:=20;
    x.SetValueAsString(8,Value);
    Stack.ExtendedX:=StrToFloat(x.DecStr);
  finally
    x.Free;
  end;
end;

Procedure OpO(Stack:TFormulaExecute);
var
  Value:string;
begin
  Stack.Pop(Value);
  Stack.x.SetValueAsString(8,Value);
end;

Procedure ExtendedOpB(Stack:TFormulaExecute);
var
  Value:string;
  x:TUnlimitedFloat;
begin
  Stack.Pop(Value);
  x:=TUnlimitedFloat.Create;
  try
    x.DecPrecision:=20;
    x.SetValueAsString(2,Value);
    Stack.ExtendedX:=StrToFloat(x.DecStr);
  finally
    x.Free;
  end;
end;

Procedure OpB(Stack:TFormulaExecute);
var
  Value:string;
begin
  Stack.Pop(Value);
  Stack.x.SetValueAsString(2,Value);
end;

Procedure ExtendedOpXBase(Stack:TFormulaExecute);
var
  Value:string;
  br:Extended;
  Base:byte;
  x:TUnlimitedFloat;
begin
  Stack.Pop(Value);
  Stack.Pop(br);
  Base:=round(br);
  if (Base>32)or (Base<2) then
    Raise Exception.Create('Error Base in function XBase.');
  x:=TUnlimitedFloat.Create;
  try
    x.DecPrecision:=20;
    x.SetValueAsString(Base,Value);
    Stack.ExtendedX:=StrToFloat(x.DecStr);
  finally
    x.Free;
  end;
end;

Procedure ExtendedOpMandelb(Stack:TFormulaExecute);
var
  a,b,s:Extended;
begin
  s:=Stack.ExtendedX;
  Stack.Pop(b);
  Stack.Pop(a);
  DrawMondelbrot(a,b,s);
  Stack.ExtendedX:=0;
end;

Procedure ExtendedOpDeg(Stack:TFormulaExecute);
var
  d,m,s:Extended;
begin
  s:=Stack.ExtendedX;
  Stack.Pop(m);
  Stack.Pop(d);
  Stack.ExtendedX:=Deg(d,m,s);
end;

Procedure ExtendedOpDegToRad(Stack:TFormulaExecute);
var
  d,m,s:Extended;
begin
  s:=Stack.ExtendedX;
  Stack.Pop(m);
  Stack.Pop(d);
  Stack.ExtendedX:=DegToRad(d,m,s);
end;

Procedure ExtendedOpDegToGrad(Stack:TFormulaExecute);
var
  d,m,s:Extended;
begin
  s:=Stack.ExtendedX;
  Stack.Pop(m);
  Stack.Pop(d);
  Stack.ExtendedX:=DegToGrad(d,m,s);
end;

Procedure ExtendedOpRadToDeg(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=RadToDeg(Stack.ExtendedX);
end;

Procedure ExtendedOpRadToGrad(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=RadToGrad(Stack.ExtendedX);
end;

Procedure ExtendedOpGradToDeg(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=GradToDeg(Stack.ExtendedX);
end;

Procedure ExtendedOpGradToRad(Stack:TFormulaExecute);
begin
  Stack.ExtendedX:=GradToRad(Stack.ExtendedX);
end;


Procedure OpXBase(Stack:TFormulaExecute);
var
  Value:string;
  br:TUnlimitedFloat;
  Base:byte;
begin
  Stack.Pop(Value);
  br:=Stack.Pop;
  Base:=StrToInt(br.DecStr);
  br.Free;
  if (Base>32)or (Base<2) then
    Raise Exception.Create('Error Base in function XBase.');
  Stack.x.SetValueAsString(Base,Value);
end;

//EndFuncs;

Procedure OpMultiplication(Stack:TFormulaExecute);
var
   x,y:TUnlimitedFloat;
begin
    x:=Stack.Pop;
    y:=Stack.Pop;
    x.Multiply(y);
    y.Free;
    Stack.x.Let(x);
    x.Free;
end;
Procedure OpMinus(Stack:TFormulaExecute);
var
   x,y:TUnlimitedFloat;
begin
    y:=Stack.Pop;
    x:=Stack.Pop;
    x.Substract(y);
    y.Free;
    Stack.x.Let(x);
    x.Free;
end;
Procedure OpDivision(Stack:TFormulaExecute);
var
   x,y:TUnlimitedFloat;
begin
    y:=Stack.Pop;
    x:=Stack.Pop;
    x.Divide(y);
    y.Free;
    Stack.x.Let(x);
    x.Free;
end;

{
function OpExtent(Stack:TFormulaExecute):extended;
var
   x,y:extended;
begin
    y:=Stack.Pop;
    x:=Stack.Pop;
    if x=0 then result:=0;
    if x>0 then result:=exp(y*ln(x));
//    if x<0 then errorcount:=true;
end;
function OpSin(Stack:TFormulaExecute):extended;
var
   x:extended;
begin
    x:=Stack.Pop;
    result:=Sin(x);
end;
function OpCos(Stack:TFormulaExecute):extended;
var
   x:extended;
begin
    x:=Stack.Pop;
    result:=Cos(x);
end;
function OpMin(Stack:TFormulaExecute):extended;
var
   x:array of extended;
   n,i:integer;
begin
    n:=round(Stack.Pop);
    SetLength(x,n);
    for i:=0 to n-1 do
       x[i]:=Stack.Pop;
    result:=MinFloat(x);
end;

function OpMax(Stack:TFormulaExecute):extended;
var
   x:array of extended;
   n,i:integer;
begin
    n:=round(Stack.Pop);
    SetLength(x,n);
    for i:=0 to n-1 do
       x[i]:=Stack.Pop;
    result:=MaxFloat(x);
end;
}

{$ifndef BettaVersion}

Procedure InitRegistredFunLib(Stack:TFormulaExecute);
begin
  ExtendedOperations[oExp]:=ExtendedOpExp;
  ExtendedOperations[oSin]:=ExtendedOpSin;
  ExtendedOperations[oCos]:=ExtendedOpCos;
  MainCalcForm.Registration1.Visible:=false;
  MainCalcForm.Registration2.Visible:=false;
  MainCalcForm.Registration3.Visible:=false;
end;


Procedure CallGrumblingForm(Stack:TFormulaExecute);
begin
{$ifndef BettaVersion}
  CloseMainForm:= not ShowGrumblingForm;
{$Endif}
end;

{$endif}


procedure InitFunLib;
var
  i:integer;
begin
   Randomize;
   Operations[oAddition]:=OpPlus;
   Operations[oSubtraction]:=OpMinus;
   Operations[oMultiplication]:=OpMultiplication;
   Operations[oDivision]:=OpDivision;


   Operations[oExp]:=OpUnlimExp;
   Operations[oArcSin]:=OpUnlimArcSin;
   Operations[oLn]:=OpUnlimLn;
   Operations[oH]:=OpH;
   Operations[oO]:=OpO;
   Operations[oB]:=OpB;
   Operations[oXBase]:=OpXBase;
//   Operations[oPi]:=OpUnlimPi;
//   Operations[oE]:=OpUnlimE;

//II. Operators
   ExtendedOperations[oAddition]:=ExtendedOpAddition;
   ExtendedOperations[oSubtraction]:=ExtendedOpSubtraction;
   ExtendedOperations[oMultiplication]:=ExtendedOpMultiplication;
   ExtendedOperations[oDivision]:=ExtendedOpDivision;
   ExtendedOperations[oModulo]:=ExtendedOpModulo;
   ExtendedOperations[oPercentage]:=ExtendedOpPercentage;
   ExtendedOperations[oIntegerDivision]:=ExtendedOpIntegerDivision;
   ExtendedOperations[oPower]:=ExtendedOpPower;
//   ExtendedOperations[oFactorial]:=ExtendedOpPlus;
//   ExtendedOperations[oRoot]:=ExtendedOpPlus;
//   ExtendedOperations[oTenPower]:=;
  ExtendedOperations[oSetVariable]:=ExtendedOpSetVariable;
  ExtendedOperations[oTestsEqualValues]:=ExtendedOpTestsEqualValues;
  ExtendedOperations[oBigger]:=ExtendedOpBigger;
  ExtendedOperations[oSmaller]:=ExtendedOpSmaller;
  
//III. Logical Operators
  ExtendedOperations[oXor]:=ExtendedOpXor;
  ExtendedOperations[oXNor]:=ExtendedOpXNor;
  ExtendedOperations[oAnd]:=ExtendedOpAnd;
  ExtendedOperations[oNand]:=ExtendedOpNand;
  ExtendedOperations[oOr]:=ExtendedOpOr;
  ExtendedOperations[oNor]:=ExtendedOpNor;
  ExtendedOperations[oNot]:=ExtendedOpNot;
  ExtendedOperations[oShl]:=ExtendedOpShl;
  ExtendedOperations[oShr]:=ExtendedOpShr;

//IV. General Functions
//  ExtendedOperations[oLcm]:=ExtendedOpLcm;
//  ExtendedOperations[oGcd]:=ExtendedOpGcd;
  ExtendedOperations[oMin]:=ExtendedOpMin;
  ExtendedOperations[oMax]:=ExtendedOpMax;
  ExtendedOperations[oFrac]:=ExtendedOpFrac;
  ExtendedOperations[oAbs]:=ExtendedOpAbs;
  ExtendedOperations[oIntg]:=ExtendedOpIntg;
  ExtendedOperations[oRound]:=ExtendedOpRound;
  ExtendedOperations[oTrunc]:=ExtendedOpTrunc;
  ExtendedOperations[oLogten]:=ExtendedOpLogten;
  ExtendedOperations[oLogN]:=ExtendedOpLogN;
{$ifdef BettaVersion}
  ExtendedOperations[oExp]:=ExtendedOpExp;
{$Else}
  ExtendedOperations[oExp]:=OpLicensedExp;
{$EndIf}
  ExtendedOperations[oLn]:=ExtendedOpLn;
  ExtendedOperations[oCeil]:=ExtendedOpCeil;
  ExtendedOperations[oFloor]:=ExtendedOpFloor;
  ExtendedOperations[oSqrt]:=ExtendedOpSqrt;
  ExtendedOperations[oSqr]:=ExtendedOpSqr;
  ExtendedOperations[oRandom]:=ExtendedOpRandom;
  ExtendedOperations[oAverage]:=ExtendedOpAverage;
  ExtendedOperations[oSum]:=ExtendedOpSum;
  ExtendedOperations[oMul]:=ExtendedOpMul;

//V. Trigonometric Functions
{$ifdef BettaVersion}
  ExtendedOperations[oSin]:=ExtendedOpSin;
  ExtendedOperations[oCos]:=ExtendedOpCos;
{$Else}
  ExtendedOperations[oSin]:=OpLicensedSin;
  ExtendedOperations[oCos]:=OpLicensedCos;
{$EndIf}
  ExtendedOperations[oTan]:=ExtendedOpTan;
  ExtendedOperations[oCot]:=ExtendedOpCot;
  ExtendedOperations[oSinh]:=ExtendedOpSinh;
  ExtendedOperations[oCosh]:=ExtendedOpCosh;
  ExtendedOperations[oTanh]:=ExtendedOpTanh;
  ExtendedOperations[oArcsin]:=ExtendedOpArcsin;
  ExtendedOperations[oArccos]:=ExtendedOpArccos;
  ExtendedOperations[oArctan]:=ExtendedOpArctan;
  ExtendedOperations[oArccot]:=ExtendedOpArccot;
  ExtendedOperations[oArcsinh]:=ExtendedOpArcsinh;
  ExtendedOperations[oArccosh]:=ExtendedOpArccosh;
  ExtendedOperations[oArctanh]:=ExtendedOpArctanh;
  ExtendedOperations[oArccoth]:=ExtendedOpArccoth;
  ExtendedOperations[oSec]:=ExtendedOpSec;
  ExtendedOperations[oCsc]:=ExtendedOpCsc;
  ExtendedOperations[oSech]:=ExtendedOpSech;
  ExtendedOperations[oCsch]:=ExtendedOpCsch;
  ExtendedOperations[oArcsec]:=ExtendedOpArcsec;
  ExtendedOperations[oArccsc]:=ExtendedOpArccsc;
  ExtendedOperations[oArcsech]:=ExtendedOpArcsech;
  ExtendedOperations[oArccsch]:=ExtendedOpArccsch;

//VI.Special Functions and Series

  ExtendedOperations[oFib]:=ExtendedOpFib;
//  ExtendedOperations[oBinom]:=ExtendedOpBinom;
//  ExtendedOperations[oGamma]:=ExtendedOpGamma;
//  ExtendedOperations[oBeta]:=ExtendedOpBeta;
//  ExtendedOperations[oHarmonic]:=ExtendedOpHarmonic;
  ExtendedOperations[oPochhammer]:=ExtendedOpPochhammer;
//  ExtendedOperations[oFermat]:=ExtendedOpFermat;
  ExtendedOperations[oBth]:=ExtendedOpBth;
  ExtendedOperations[oBman]:=ExtendedOpBman;

//VII. Primes and Numbers

//  ExtendedOperations[oPhi]:=ExtendedOpPhi;
//  ExtendedOperations[oPrime]:=ExtendedOpPrime;
//  ExtendedOperations[oPrimeC]:=ExtendedOpPrimeC;
//  ExtendedOperations[oPrimeN]:=ExtendedOpPrimeN;
//  ExtendedOperations[oMersenne]:=ExtendedOpMersenne;
//  ExtendedOperations[oMersenneGen]:=ExtendedOpMersenneGen;
//  ExtendedOperations[oMersGen]:=ExtendedOpMersGen;
//  ExtendedOperations[oGenMers]:=ExtendedOpGenMers;
//  ExtendedOperations[oPerfect]:=ExtendedOpPerfect;
//  ExtendedOperations[oSigma]:=ExtendedOpSigma;
//  ExtendedOperations[oTau]:=ExtendedOpTau;
//  ExtendedOperations[oMoebius]:=ExtendedOpMoebius;
//  ExtendedOperations[oSafeprime]:=ExtendedOpSafeprime;

//VIII. Integrals

//  ExtendedOperations[oStudent]:=ExtendedOpFib;
//  ExtendedOperations[oGauss]:=ExtendedOpBinom;
//  ExtendedOperations[oDilog]:=ExtendedOpGamma;
//  ExtendedOperations[oDawson]:=ExtendedOpBeta;
//  ExtendedOperations[oErf]:=ExtendedOpHarmonic;
//  ExtendedOperations[oErfc]:=ExtendedOpPochhammer;
//  ExtendedOperations[oSi]:=ExtendedOpFermat;
//  ExtendedOperations[oCi]:=ExtendedOpBth;
//  ExtendedOperations[oSsi]:=ExtendedOpBman;
//  ExtendedOperations[oShi]:=ExtendedOpPochhammer;
//  ExtendedOperations[oChi]:=ExtendedOpFermat;
//  ExtendedOperations[oFresnelC]:=ExtendedOpBth;
//  ExtendedOperations[oFresnelS]:=ExtendedOpBman;
//  ExtendedOperations[oFresnelF]:=ExtendedOpFermat;
//  ExtendedOperations[oFresnelG]:=ExtendedOpBth;
//  ExtendedOperations[oEllipticE]:=ExtendedOpBman;
//  ExtendedOperations[oEllipticCE]:=ExtendedOpFermat;
//  ExtendedOperations[oEllipticK]:=ExtendedOpBth;
//  ExtendedOperations[oEllipticCK]:=ExtendedOpBman;

//IX. Function Plots and Graphs
  ExtendedOperations[oPlot]:=ExtendedOpPlot;
  ExtendedOperations[oZPlot]:=ExtendedOpZPlot;

//X. Financial Functions
  ExtendedOperations[oSln]:=ExtendedOpSln;
  ExtendedOperations[oSyd]:=ExtendedOpSyd;
//  ExtendedOperations[oCterm]:=ExtendedOpCterm;
//  ExtendedOperations[oTerm]:=ExtendedOpTerm;
//  ExtendedOperations[oPmt]:=ExtendedOpPmt;
//  ExtendedOperations[oRate]:=ExtendedOpRate;
//  ExtendedOperations[oPv]:=ExtendedOpPv;
//  ExtendedOperations[oNpv]:=ExtendedOpNpv;
//  ExtendedOperations[oFv]:=ExtendedOpFv;
//  ExtendedOperations[oDb]:=ExtendedOpDb;
  ExtendedOperations[oDdb]:=ExtendedOpDdb;
//  ExtendedOperations[oExtFin]:=ExtendedOpExtFin;


  ExtendedOperations[oH]:=ExtendedOpH;
  ExtendedOperations[oO]:=ExtendedOpO;
  ExtendedOperations[oB]:=ExtendedOpB;
  ExtendedOperations[oXBase]:=ExtendedOpXBase;
  ExtendedOperations[oMandl]:=ExtendedOpMandelb;

  ExtendedOperations[oDeg]:=ExtendedOpDeg;
  ExtendedOperations[oDegToRad]:=ExtendedOpDegToRad;
  ExtendedOperations[oDegToGrad]:=ExtendedOpDegToGrad;
  ExtendedOperations[oRadToDeg]:=ExtendedOpRadToDeg;
  ExtendedOperations[oRadToGrad]:=ExtendedOpRadToGrad;
  ExtendedOperations[oGradToDeg]:=ExtendedOpGradToDeg;
  ExtendedOperations[oGradToRad]:=ExtendedOpGradToRad;

//Открыты все функции
  ExtendedOperations[oExp]:=ExtendedOpExp;
  ExtendedOperations[oSin]:=ExtendedOpSin;
  ExtendedOperations[oCos]:=ExtendedOpCos;


//End Fundef




{   Operations[Extent]:=OpExtent;

   Operations[100]:=OpSin;
   Operations[101]:=OpCos;
   Operations[102]:=OpMin;
   Operations[103]:=OpMax;}


//   SetLength(FunDefs,MaxFunCod+1);
{   FunDefs[oExp].FunId:='EXP';
   FunDefs[oExp].ArgNum:=1;
   FunDefs[oArcSin].FunId:='ARCSIN';
   FunDefs[oArcSin].ArgNum:=1;
   FunDefs[oLn].FunId:='LN';
   FunDefs[oLn].ArgNum:=1;}
//   FunDefs[oPi].FunId:='PI';
//   FunDefs[oPi].ArgNum:=0;
//   FunDefs[oE].FunId:='E';
//   FunDefs[oE].ArgNum:=0;


{   FunDefs[101].FunId:='COS';
   FunDefs[101].ArgNum:=1;
   FunDefs[102].FunId:='MIN';
   FunDefs[102].ArgNum:=-1;
   FunDefs[103].FunId:='MAX';
   FunDefs[103].ArgNum:=-1;}

//Protect functinos
{$ifndef BettaVersion}
  ExtendedOperations[oNewFuncs]:=InitRegistredFunLib;
  ExtendedOperations[GrumbShow]:=CallGrumblingForm;
{$endif}

end;

procedure InitNewFuncs;
var
  b2:byte;
  i:integer;
begin
{$ifndef BettaVersion}
  for i:=0 to 15 do
    RegCod[i]:=RegCod[i] xor Signatura[i];
  ArrayToByte(b2,ByteIndexs2);
  ExtendedOperations[b2](nil);
  for i:=0 to 15 do
    RegCod[i]:=RegCod[i] xor Signatura[i];
{$EndIf}
end;

initialization
  InitFunLib;
end.
