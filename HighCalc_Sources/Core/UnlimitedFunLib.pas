unit UnlimitedFunLib;

interface
uses
  UnlimitedFloat,Formula,SysUtils;
Procedure OpUnlimExp(Stack:TFormulaExecute);
Procedure OpUnlimArcSin(Stack:TFormulaExecute);
Procedure OpUnlimLn(Stack:TFormulaExecute);
Procedure OpUnlimPi(Stack:TFormulaExecute);
Procedure OpUnlimE(Stack:TFormulaExecute);
Procedure UnlimExp(Value:TUnlimitedFloat);
Procedure UnlimLn(Value:TUnlimitedFloat);
Procedure UnlimArcSin(Value:TUnlimitedFloat);
Procedure UnlimPI(Value:TUnlimitedFloat);
Procedure UnlimE(Value:TUnlimitedFloat);
const
  PIConst:TUnlimitedFloat=nil;
  EConst:TUnlimitedFloat=nil;
implementation

Procedure OpUnlimExp(Stack:TFormulaExecute);
var
   x:TUnlimitedFloat;
begin
  x:=Stack.Pop;
  UnlimExp(x);
  Stack.X.Let(x);
  x.Free;
end;


{Procedure OpUnlimExp(Stack:TFormulaExecute);
var
   x:TUnlimitedFloat;
   ni,s,o,si:TUnlimitedFloat;
   xArr:array of TUnlimitedFloat;
begin
  x:=Stack.Pop;
  ni:=TUnlimitedFloat.Create;
  try
    si:=TUnlimitedFloat.Create;
    try
      o:=TUnlimitedFloat.Create;
      try
        s:=TUnlimitedFloat.Create;
        try
          si.Let(x);
          si.Plus(1);
          o.Let(x);
          o.Let(1);
          o.DecPrecision:=x.DecPrecision;
          ni.Let(o);
          ni.Power10(x.DecPrecision+1);
          o.Divide(ni);
          ni.Let(1);//=1
          ni.DecPrecision:=x.DecPrecision;
          s.Let(si);
          si.Let(x);
          while si.Comparison(o)=1 do begin
            si.Multiply(x);
            ni.Plus(1);
            si.Divide(ni);
            s.Plus(si);
          end;
          Stack.x.Let(s);
        finally
          s.Free;
        end;
      finally
        o.Free;
      end;
    finally
      si.Free;
    end;
  finally
    ni.Free;
  end;
  x.Free;
end;}

{Procedure OpUnlimExp(Stack:TFormulaExecute);
var
   x:TUnlimitedFloat;
   xi,ni,s,o,si,i:TUnlimitedFloat;
begin
    x:=Stack.Pop;
    xi:=TUnlimitedFloat.Create;
    try
      ni:=TUnlimitedFloat.Create;
      try
        si:=TUnlimitedFloat.Create;
        try
          o:=TUnlimitedFloat.Create;
          try
            s:=TUnlimitedFloat.Create;
            try
              i:=TUnlimitedFloat.Create;
              try
                si.Let(x);
                si.Plus(1);
                o.Let(x);
                o.Let(1);
                o.DecPrecision:=x.DecPrecision;
                i.Let(o);
                xi.Let(o);
                ni.Let(o);
                ni.Power10(x.DecPrecision+1);
                o.Divide(ni);
                ni.Let(xi);//=1
                s.Let(si);
                si.Let(x);
                while si.Comparison(o)=1 do begin
                  si.Multiply(x);
                  ni.Plus(1);
                  si.Divide(ni);
                  s.Plus(si);
                end;
                Stack.x.Let(s);
              finally
                i.Free;
              end;
            finally
              s.Free;
            end;
          finally
            o.Free;
          end;
        finally
          si.Free;
        end;
      finally
        ni.Free;
      end;
   finally
     xi.Free;
   end;
   x.Free;
end; }

Procedure OpUnlimArcSin(Stack:TFormulaExecute);
var
   x:TUnlimitedFloat;
begin
  x:=Stack.Pop;
  UnlimArcSin(x);
  Stack.X.Let(x);
  x.Free;
end;

{Procedure OpUnlimLn(Stack:TFormulaExecute);
var
   x:TUnlimitedFloat;
   ni,s,o,si,si1,xi:TUnlimitedFloat;
   xArr:array of TUnlimitedFloat;
begin
  x:=Stack.Pop;
  ni:=TUnlimitedFloat.Create;
  try
    si:=TUnlimitedFloat.Create;
    try
      si1:=TUnlimitedFloat.Create;
      try
        o:=TUnlimitedFloat.Create;
        try
          s:=TUnlimitedFloat.Create;
          try
            xi:=TUnlimitedFloat.Create;
            try
              xi.Let(x);
              xi.Plus(1);
              ni.Let(xi);
              xi.Substract(2);
              xi.Divide(ni);
              si1.Let(xi);
              si.Let(si1);
              s.Let(xi);
              xi.Multiply(si1);
              o.Let(1);
              o.DecPrecision:=x.DecPrecision;
              ni.Let(o);
              ni.Power10(x.DecPrecision+1);
              o.Divide(ni);
              ni.Let(3);
              ni.DecPrecision:=x.DecPrecision;
              while si.Comparison(o)=1 do begin
                si1.Multiply(xi);
                si.Let(si1);
                si.Divide(ni);
                ni.Plus(2);
                s.Plus(si);
              end;
              s.Multiply(2);
              if s.Comparison(o)>=0 then
                Stack.x.Let(s)
              else begin
                Stack.x.Let(0);
                x.DecPrecision:=s.DecPrecision;
              end;
            finally
              xi.Free;
            end;
          finally
            s.Free;
          end;
        finally
          o.Free;
        end;
      finally
        si1.Free;
      end;
    finally
      si.Free;
    end;
  finally
    ni.Free;
  end;
  x.Free;
end; }

Procedure OpUnlimLn(Stack:TFormulaExecute);
var
   x,ee:TUnlimitedFloat;
   e,xExponent,xSurplus:extended;
begin
  x:=Stack.Pop;
  e:=x.GetFractionAsFloat;
  if Abs(e)>1e-20 then
    e:=Ln(e);
  xExponent:=x.Exponent;
  xSurplus:=x.Surplus;
  e:=Int((xExponent-xSurplus)*LnMaxInt+e);
  ee:=TUnlimitedFloat.Create;
  try
    ee.Let(x);//установили точность
    ee.Let(e);
    UnlimExp(ee);
    x.Divide(ee);
  finally
    ee.Free;
  end;
  UnlimLn(x);
  x.PlusFloat(e);
  Stack.x.Let(x);
  x.Free;
end;

Procedure OpUnlimPi(Stack:TFormulaExecute);
begin
  UnlimPI(Stack.X);
end;

Procedure OpUnlimE(Stack:TFormulaExecute);
begin
  UnlimE(Stack.X);
end;

Procedure UnlimLn(Value:TUnlimitedFloat);
var
   x:TUnlimitedFloat;
   ni,s,o,si,si1,xi:TUnlimitedFloat;
   Prec:LongWord;
begin
  x:=Value;
  ni:=TUnlimitedFloat.Create;
  try
    si:=TUnlimitedFloat.Create;
    try
      si1:=TUnlimitedFloat.Create;
      try
        o:=TUnlimitedFloat.Create;
        try
          s:=TUnlimitedFloat.Create;
          try
            xi:=TUnlimitedFloat.Create;
            try
              xi.Let(x);
              xi.Plus(1);
              ni.Let(xi);
              xi.Substract(2);
              xi.Divide(ni);
              si1.Let(xi);
              si.Let(si1);
              s.Let(xi);
              xi.Multiply(si1);
              o.Let(1);
              o.DecPrecision:=x.DecPrecision;
              ni.Let(o);
              ni.Power10(x.DecPrecision+1);
              o.Divide(ni);
              ni.Let(3);
              ni.DecPrecision:=x.DecPrecision;
              while si.AbsComparison(o)=1 do begin
                si1.Multiply(xi);
                si.Let(si1);
                si.Divide(ni);
                ni.Plus(2);
                s.Plus(si);
              end;
              s.Multiply(2);
              if s.AbsComparison(o)=-1 then begin
                Prec:=s.DecPrecision;
                s.Let(0);
                s.DecPrecision:=Prec;
              end;
              x.Let(s);
            finally
              xi.Free;
            end;
          finally
            s.Free;
          end;
        finally
          o.Free;
        end;
      finally
        si1.Free;
      end;
    finally
      si.Free;
    end;
  finally
    ni.Free;
  end;
end;

Procedure UnlimExp(Value:TUnlimitedFloat);
var
   x:TUnlimitedFloat;
   ni,s,o,si:TUnlimitedFloat;
   i:integer;
   Sign:boolean;
begin
  x:=Value;
  Sign:=x.Sign;
  x.Sign:=false;
  ni:=TUnlimitedFloat.Create;
  try
    si:=TUnlimitedFloat.Create;
    try
      o:=TUnlimitedFloat.Create;
      try
        s:=TUnlimitedFloat.Create;
        try
          si.Let(x);
          si.Plus(1);
          o.Let(x);
          o.Let(1);
          o.DecPrecision:=x.DecPrecision;
          ni.Let(o);
          ni.Power10(x.DecPrecision+1);
          o.Divide(ni);
          ni.Let(1);//=1
          ni.DecPrecision:=x.DecPrecision;
          s.Let(si);
          si.Let(x);
          i:=0;
          while si.AbsComparison(o)=1 do begin
            si.Multiply(x);
            ni.Plus(1);
            si.Divide(ni);
            s.Plus(si);
            inc(i);
          end;
          if Sign then begin
            ni.Let(1);//=1
            ni.DecPrecision:=s.DecPrecision;
            ni.Divide(s);
            x.Let(ni);
          end else
            x.Let(s);
        finally
          s.Free;
        end;
      finally
        o.Free;
      end;
    finally
      si.Free;
    end;
  finally
    ni.Free;
  end;
end;

Procedure UnlimArcSin(Value:TUnlimitedFloat);
var
   x:TUnlimitedFloat;
   x2,ni,s,o,si,n1,n2,n3:TUnlimitedFloat;
begin
  x:=Value;
  x2:=TUnlimitedFloat.Create;
  try
    ni:=TUnlimitedFloat.Create;
    try
      s:=TUnlimitedFloat.Create;
      try
        o:=TUnlimitedFloat.Create;
        try
          si:=TUnlimitedFloat.Create;
          try
            n1:=TUnlimitedFloat.Create;
            try
              n2:=TUnlimitedFloat.Create;
              try
                n3:=TUnlimitedFloat.Create;
                try
                  x2.Let(x);
                  x2.Multiply(x);
                  si.Let(x2);
                  si.Multiply(x);
                  si.Divide(6);
                  s.Let(si);
                  s.Plus(x);
                  n1.Let(3);
                  n1.DecPrecision:=x.DecPrecision;
                  n2.Let(4);
                  n2.DecPrecision:=x.DecPrecision;
                  n3.Let(5);
                  n3.DecPrecision:=x.DecPrecision;
                  o.Let(x);
                  o.Let(1);
                  o.DecPrecision:=x.DecPrecision;
                  ni.Let(o);
                  ni.Power10(x.DecPrecision+1);
                  o.Divide(ni);
                  while si.Comparison(o)=1 do begin
                    si.Multiply(n1);
                    si.Multiply(n1);
                    si.Multiply(x2);
                    ni.Let(n2);
                    ni.Multiply(n3);
                    si.Divide(ni);
                    s.Plus(si);
                    n1.Plus(2);
                    n2.Plus(2);
                    n3.Plus(2);
                  end;
                  x.Let(s);
                finally
                  n3.Free;
                end;
              finally
                n2.Free;
              end;
            finally
              n1.Free;
            end;
          finally
            si.Free;
          end;
        finally
          o.Free;
        end;
      finally
        s.Free;
      end;
    finally
      ni.Free;
    end;
  finally
    x2.Free;
  end;
end;

Procedure UnlimPI(Value:TUnlimitedFloat);
begin
  if PIConst=nil then begin
    Value.DecStr:='0'+DecimalSeparator+'5';
    UnlimArcSin(Value);
    Value.Multiply(6);
    PIConst:=TUnlimitedFloat.Create;
    PIConst.Let(Value);
  end else
    Value.Let(PIConst);
end;

Procedure UnlimE(Value:TUnlimitedFloat);
var
  Prec:LongWord;
begin
  if EConst=nil then begin
    Prec:=Value.FractionLen;
    Value.Let(1);
    Value.FractionLen:=Prec;
    UnlimExp(Value);
    EConst:=TUnlimitedFloat.Create;
    EConst.Let(Value);
  end else
    Value.Let(EConst);
end;

end.
