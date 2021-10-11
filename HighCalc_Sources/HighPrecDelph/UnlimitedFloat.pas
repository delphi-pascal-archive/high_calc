unit UnlimitedFloat;

interface

uses
  UnlimitedInt,SysUtils,Math;
const
  MaxDecInt=1000000000;
  MaxDecIntLen=9;
  MaxInt:Extended=$100000000;
  Log10MaxInt:Extended=0.0;
  LnMaxInt:Extended=0.0;
  a:extended=0.0;
  DefaultSurplus:LongWord=1000000;
  ExpSymbol:char='$';//'E';
type
  TUnlimitedFloat=class
  private
    FExponentLen: LongWord;
    FSurplus: LongWord;
    FExponent: LongWord;//Порядок не может быть больше 4-х млрд.
    FFraction: TUnlimitedInteger;
    FDecPrecision: LongWord;
    MaxDecPrecision:integer;
    procedure SetExponent(const Value: LongWord);
    procedure SetExponentLen(const Value: LongWord);
    procedure SetFraction(const Value: TUnlimitedInteger);
    procedure SetFractionLen(const Value: integer);
    procedure SetSurplus(const Value: LongWord);
    procedure GetFromDecStr(DecStr:string);
    function GetFractionLen: Integer;
    procedure SetSign(const Value: boolean);
    function GetSign: boolean;
    function GetExponent: LongWord;
    procedure PlusMinus (Value:TUnlimitedFloat;Minus:boolean);
    function GetExponentLen: LongWord;
    function GetFractionAsHex: string;
    function GetExponentAsHex: string;
    procedure SetExponentAsHex(const Value: string);
    procedure SetFractionAsHex(const Value: string);
    procedure SetDecStr(const Value: string);
    function GetDecStr: string;
    function GetFractionDecStr: string;
    procedure SetFractionDecStr(const Value: string);
    procedure SetDecPrecision(const Value: LongWord);
  public
    property DecPrecision:LongWord read FDecPrecision write SetDecPrecision; //Число десятичных разрядов
//    property ExponentLen:LongWord read GetExponentLen write SetExponentLen;//Точность порядка
    property FractionLen:Integer read GetFractionLen write SetFractionLen;//Точность дробной части
//    property Exponent:TUnlimitedInteger read FExponent write SetExponent;//Порядок
    property Exponent:LongWord read GetExponent write SetExponent;
    property Fraction:TUnlimitedInteger read FFraction write SetFraction;//Дробная часть
    property Surplus:LongWord read FSurplus write SetSurplus;//Избыток
    property Sign:boolean read GetSign write SetSign;
    property FractionAsHex:string read GetFractionAsHex write SetFractionAsHex;
    property ExponentAsHex:string read GetExponentAsHex write SetExponentAsHex;
    property DecStr:string read GetDecStr write SetDecStr;
    function GetValueAsString(const Base:byte):string;//Получить число по основанию Base
    procedure SetValueAsString(const Base:byte;Value:string);//Присвоить число по основанию Base
    procedure SetFractionNBaseStr(const Base:byte;const Fraction:string);
    property FractionDecStr:string read GetFractionDecStr write SetFractionDecStr;
    procedure Plus (Value:TUnlimitedFloat);overload;
    procedure Plus (Value:integer);overload;
    procedure PlusFloat (Value:Extended);overload;
    procedure Substract (Value:TUnlimitedFloat);overload;
    procedure Substract (Value:integer);overload;
    procedure SubstractFloat (Value:Extended);overload;
    procedure Multiply (Value:TUnlimitedFloat);overload;
    procedure Multiply (Value:integer);overload;
    procedure MultiplyFloat (Value:Extended);overload;
    procedure Divide (Value:TUnlimitedFloat);overload;
    procedure Divide (Value:integer);overload;
    procedure DivideFloat (Value:Extended);overload;
    procedure Normalize;
    procedure NormalizeDecStr(InStr:string;var FractionStr,ExponentStr:string);
    procedure NormalizeNBaseStr(var FractionStr,ExponentStr:string);
    procedure NormalizeInNBaseStr(const Base:byte;InStr:string;var FractionStr,ExponentStr:string);
    function Comparison(Value:TUnlimitedFloat):Shortint;overload;
    function AbsComparison(Value:TUnlimitedFloat):Shortint;overload;
    procedure Let(Value:TUnlimitedFloat);overload;
    procedure Let(Value:integer);overload;
    procedure Let(Value:Extended);overload;
    procedure Exp(Value:TUnlimitedFloat);//Экспонента
    procedure Ln(Value:TUnlimitedFloat);//Натуральный логарифм
//    procedure Power(Value:TUnlimitedFloat);//Возведение в степень
    procedure SetFractionDecSignStr(Value: string);
    procedure SetFractionNBaseSignStr(const Base:byte;Value: string);
    function GetFractionDecSignStr(Len:integer): string;
    function GetFractionAsString(const Base:byte;const Len:integer): string;
    function IntNToStr(const Base:byte;const Value:LongWord):string;
    function IntNToStr1(const Base:byte;const Value:LongWord):string;
    function NBaseStrToInt(const Base:byte;const Value:string):Int64;
    function CharToNInt(const Value:char):byte;
    function GetRoundDecStr (DecStr:string;Len:LongWord=0):string;
    function GetRoundNBaseStr (NBaseStr:string;const Base:byte;Len:LongWord=0):string;
    function NormalizeOutDecStr(DecStr:string):string;
    function OptimazeOutDecStr(DecStr:string):string;
    function OptimazeNBaseStr(const Base:byte; var FractionStr, ExponentStr:string):string;
    procedure DelNExp(var FractionStr:string;const Exponent:integer);
    function  OptimExp(const FractionStr:string;const Exponent:integer;const Base:byte):string;
    function IntToStrN(const Base,Value:integer):string;
    function GetFractionAsFloat:extended;
    procedure Power10(Exponent:LongWord);
    procedure MulPower(const Base:byte; const Exponent:int64);
    function BasePrecision(const Base:byte):integer;
    constructor Create;
    destructor Destroy;override;
    function ConvDigit(const d:byte):char;
  end;
Var
  GlobLen:^integer;
  GlobalRes:TUnlimitedFloat;
  r:Pointer;
  MaxNInt:integer;//=1000000000;
  MaxNIntLen:byte;//=9;
  MaxDigit:char;
  NZero:string;

implementation

{ TUnlimitedFloat }

function TUnlimitedFloat.Comparison(Value: TUnlimitedFloat): Shortint;
var{Self>Value=>1;Self<Value=>-1;Self=Value=>0}
  s1,s2:boolean;
  n,i,r:integer;
  UnsignedValue:LongWord;
begin
 //todo:Сравнить знаки, порядки, дробные части
  s1:=Sign;
  s2:=Value.Sign;
  if s1 and not s2 then begin
    result:=-1;
    exit;
  end else if not s1 and s2 then begin
    result:=1;
    exit;
  end;
  if Exponent>Value.Exponent then begin
    if s1 and s2 then
      result:=-1
    else
      result:=1;
    exit;
  end;
  if Exponent<Value.Exponent then begin
    if s1 and s2 then
      result:=1
    else
      result:=-1;
    exit;
  end;
  if Fraction.Comparison(Value.Fraction)=1 then begin
    if s1 and s2 then
      result:=-1
    else
      result:=1;
    exit;
  end;
  if Fraction.Comparison(Value.Fraction)=-1 then begin
    if s1 and s2 then
      result:=1
    else
      result:=-1;
    exit;
  end;
  result:=0;
end;

constructor TUnlimitedFloat.Create;
begin
  inherited;
  FFraction:=TUnlimitedInteger.Create;
  Surplus:=DefaultSurplus;
end;

procedure TUnlimitedFloat.Divide(Value: TUnlimitedFloat);
var
  W:TUnlimitedFloat;
  FractLength:LongWord;
  Remainder:TUnlimitedInteger;
  Prec:LongWord;
  sr,sv:boolean;
  DebugTxt:System.Text;
  TempValue:TUnlimitedFloat;
  FloatPrec:integer;
begin
  TempValue:=TUnlimitedFloat.Create;
  try
    TempValue.Let(Value);
    FractLength:=FractionLen;
    sr:=FFraction.Sign xor TempValue.FFraction.Sign;
    sv:=TempValue.FFraction.Sign;
    FFraction.Sign:=false;
    TempValue.FFraction.Sign:=false;
    W:=TUnlimitedFloat.Create;
    try
      W.Exponent:=FExponent;
      W.Exponent:=W.Exponent-TempValue.FExponent+FSurplus;
      W.Fraction.Let(FFraction);
      Prec:=W.Fraction.Precision;
      FloatPrec:=FractionLen+TempValue.FractionLen;
//      if W.FFraction.Comparison(TempValue.FFraction)>=0{W>=V} then begin
        W.Exponent:=W.Exponent+1;
        W.FractionLen:=FractionLen+TempValue.FractionLen-1;
        W.Fraction.Precision:=FloatPrec;
{      end else
        W.FractionLen:=FloatPrec;}
      while TempValue.FFraction.GetBuf[TempValue.FractionLen-1]=0 do begin
        TempValue.FFraction.Multiply(2);//todo: Разобраться с нормализацией
        W.FFraction.Multiply(2);
      end;
      Remainder:=TUnlimitedInteger.Create;
      try
{ {      AssignFile(DebugTxt,'c:\debugTxt.Txt');
        Rewrite(DebugTxt);
        WriteLn(DebugTxt,W.Fraction.HexStr);
        WriteLn(DebugTxt,TempValue.FFraction.HexStr);
        CloseFile(DebugTxt);}
        W.FFraction.Divide(TempValue.FFraction,Remainder);
      finally
        Remainder.Free;
      end;
   //   if W.FractionLen=FloatPrec then
//        W.FractionLen:=FloatPrec;
{      if W.Fraction.GetBuf[Prec]<>0 then begin //todo:Разобраться - переполнение при делении
        W.Fraction.Precision:=Prec+1;
        W.FractionLen:=Prec;
        W.Exponent:=W.Exponent+1;
      end;}

      W.Fraction.Precision:=Prec;
{      W.Fraction.Precision:=W.Fraction.Precision-TempValue.FractionLen; //todo:Разобраться с целочисленным делением - почему результат на 1 разряд больше
      if W.FractionLen<>Prec then begin
        W.FractionLen:=Prec;

      end;}
      if W.FFraction.Sign then begin
        W.FractionLen:=Prec-1;
        W.Fraction.Precision:=Prec+1;
        W.FractionLen:=Prec;
        W.Exponent:=W.Exponent+1;
      end;
      TempValue.FFraction.Sign:=sv;
      W.FFraction.Sign:=Sr;
      W.Normalize;
////    W.FractionLen:=FractLength;
      FExponent:=W.FExponent;
      FFraction.Let(W.FFraction);
    finally
      W.Free;
    end;
  finally
    TempValue.Free;
  end;
end;

procedure TUnlimitedFloat.Divide(Value: integer);
var
  TempUnlimitedFloat:TUnlimitedFloat;
begin
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.FSurplus:=FSurplus;
    TempUnlimitedFloat.Let(Value);
    TempUnlimitedFloat.FractionLen:=FractionLen;
    Divide(TempUnlimitedFloat);
  finally
    TempUnlimitedFloat.Free;
  end;
end;

procedure TUnlimitedFloat.Exp(Value: TUnlimitedFloat);
var
  X,X1,s,n,n1,o,Element:TUnlimitedFloat;
  i:integer;
  FractLength:LongWord;
begin
  FractLength:=FractionLen;
  X:=TUnlimitedFloat.Create;
  try
    X.Fraction.Let(FFraction);
    X.Exponent:=FExponent;
    X.FractionLen:=2*FractLength;
    X1:=TUnlimitedFloat.Create;
    try
      X1.Fraction.Let(1);
      X1.Exponent:=Surplus+1;
      X1.FractionLen:=2*FractLength;
      s:=TUnlimitedFloat.Create;
      try
        n:=TUnlimitedFloat.Create;
        try
          n.Let(x1);
          n1:=TUnlimitedFloat.Create;
          try
            o:=TUnlimitedFloat.Create;
            try
              o.Let(x1);
              o.FExponent:=o.FExponent-FractLength;
              Element:=TUnlimitedFloat.Create;
              try
                Element.Let(x1);
                s.Let(Element);
                i:=0;
                while Element.Comparison(o)=1 do begin //Пока Element>o
                  x1.Multiply(x);
                  Element.Let(x1);
                  inc(i);
//                  n.Multiply(i);
                  Element.Divide(n);
                  s.Plus(Element);
                end;
              finally
                Element.Free;
              end;
            finally
              o.Free;
            end;
          finally
            n1.Free;
          end;
        finally
          n.Free;
        end;
      finally
        s.Free;
      end;
    finally
      x1.Free;
    end;
  finally
    X.Free;
  end;
end;

function TUnlimitedFloat.GetDecStr: string;
var
  FractionStr,ExponentStr: string;
  DecExp:LongInt;
  TempUnlimitedFloat:TUnlimitedFloat;
  TempUnlimitedFloat10:TUnlimitedFloat;
  ExpSign:boolean;
  LogExp:integer;
  s:string;
  FractSign:boolean;
begin
  if FFraction.Zero then begin
    result:='0';
    exit;
  end;
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    ExpSign:=FExponent<Surplus;
    DecExp:=Abs(FExponent-SurPlus);
    a:=Log10(MaxInt);
    LogExp:=Round(a*DecExp);
    TempUnlimitedFloat10:=TUnlimitedFloat.Create;
    try
      TempUnlimitedFloat10.Surplus:=Surplus;
      repeat
        TempUnlimitedFloat.Let(Self);
        TempUnlimitedFloat.FractionLen:=2*FractionLen;
        TempUnlimitedFloat10.Let(1);
        TempUnlimitedFloat10.FractionLen:=FractionLen*2;
        TempUnlimitedFloat10.Power10(LogExp);
        if ExpSign then
          TempUnlimitedFloat.Multiply(TempUnlimitedFloat10)
        else
          TempUnlimitedFloat.Divide(TempUnlimitedFloat10);
        if TempUnlimitedFloat.FExponent>TempUnlimitedFloat.Surplus then begin
          if ExpSign then
            Dec(LogExp)
          else
            inc(LogExp)
        end else if TempUnlimitedFloat.FExponent<TempUnlimitedFloat.Surplus then begin
          if ExpSign then
            inc(LogExp)
          else
            dec(LogExp);
        end;
      until TempUnlimitedFloat.FExponent=TempUnlimitedFloat.Surplus;
      if ExpSign then
        LogExp:=-LogExp;
      FractionStr:=TempUnlimitedFloat.FractionDecStr;
      FractSign:=FractionStr[1]='-';
      if FractSign then
        FractionStr:=Copy(FractionStr,2,Length(FractionStr));
      s:='0'+DecimalSeparator+FractionStr+'E'+IntToStr(LogExp);
//      Result:=NormalizeOutDecStr(s);
      Result:=OptimazeOutDecStr(s);
//      Result:=s;
      if FractSign then
        Result:='-'+Result;
    finally
      TempUnlimitedFloat10.Free;
    end;
  finally
    TempUnlimitedFloat.Free;
  end;
end;

function TUnlimitedFloat.GetExponent: LongWord;
begin
  result:=FExponent;
end;

function TUnlimitedFloat.GetExponentAsHex: string;
begin
  result:=format('%.x',[FExponent]);
end;

function TUnlimitedFloat.GetExponentLen: LongWord;
begin
  result:=1//FExponent.Precision;
end;

function TUnlimitedFloat.GetFractionAsHex: string;
begin
  result:=FFraction.FractionHexStr;
end;

function TUnlimitedFloat.GetFractionDecSignStr(Len:integer): string;
var
  TempUnlimitedFloat:TUnlimitedFloat;
  n:integer;
  Prec:LongWord;
  s:boolean;
  Buf: TUnlimitedIntegerBuf;
  r:string;
begin
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.Let(Self);
    TempUnlimitedFloat.FExponent:=FSurplus;
    Prec:=TempUnlimitedFloat.FractionLen;
    TempUnlimitedFloat.FractionLen:=Prec*2;
    r:='';
    s:=TempUnlimitedFloat.Sign;
    if s then
      TempUnlimitedFloat.Sign:=false;
    while Length(r)<=Len-9 do begin
      TempUnlimitedFloat.Multiply(MaxDecInt);
      if  TempUnlimitedFloat.FExponent>TempUnlimitedFloat.Surplus then begin
        with TempUnlimitedFloat.FFraction do begin
          Buf:=GetBuf;
          r:=r+Format('%.9d',[Buf[Precision-1]]);
          Buf[Precision-1]:=0;
        end;
        TempUnlimitedFloat.Normalize;
      end else
        r:=r+'000000000';
    end;
    if s then
      r:='-'+r;
  finally
    TempUnlimitedFloat.Free;
  end;
  result:=r;
end;

function TUnlimitedFloat.GetFractionDecStr: string;
begin
//  Result:=GetFractionDecSignStr(10000);
    Result:=GetFractionDecSignStr(MaxDecPrecision);
end;

function TUnlimitedFloat.GetFractionLen: integer;
begin
  result:=Fraction.Precision;
end;

procedure TUnlimitedFloat.GetFromDecStr(DecStr: string);
begin
  //todo:реализовать:
  { для преобразования числа f*2^e в десятичный формат
    преобразовать 2^e в F*10^E (очевидно 10^E=A*2^k т.е. 10^E представить в
    формате с плавающей точкой)}
end;

function TUnlimitedFloat.GetRoundDecStr(DecStr: string;
  Len: LongWord=0): string;
var
  i:integer;
  a,b:integer;
  s:string;
begin
  if Len=0 then
    Len:=FDecPrecision;
  if Len=0 then
    Raise Exception.Create('Set precision more then 0');
  if Length(DecStr)>Len then begin
    a:=StrToInt(DecStr[Len+1]);
    if a>4 then begin
      a:=1;
      for i:=Len downto 1 do begin
        if a=1 then begin
          b:=StrToInt(DecStr[i]);
          b:=b+a;
          if b>9 then
            DecStr[i]:=' '
          else begin
            a:=0;
            s:=IntToStr(b);
            DecStr[i]:=s[1];
          end;
        end else
          break;
      end;
      if a=1 then
        Raise Exception.Create('Overflow at round.');
       // Raise Exception.Create('Переполнение при округлении десятичной строки');
    end;
    result:=Copy (DecStr,1,Len);
  end else
    result:=DecStr;
//    raise Exception.Create('Короткая строка');
end;

function TUnlimitedFloat.GetSign: boolean;
begin
  result:=FFraction.Sign;
end;

procedure TUnlimitedFloat.Let(Value: TUnlimitedFloat);
begin
  FFraction.Let(Value.FFraction);
  FExponent:=Value.FExponent;
  FDecPrecision:=Value.DecPrecision;
  MaxDecPrecision:=Value.MaxDecPrecision;
  Surplus:=Value.Surplus;
end;

procedure TUnlimitedFloat.Let(Value: integer);
begin
  if Value=0 then begin
    FExponent:=100;
    FFraction.Let(0);
  end else begin
    FExponent:=SurPlus+1;
    FFraction.Let(Value);
  end;
end;

procedure TUnlimitedFloat.Ln(Value: TUnlimitedFloat);
var
  W:TUnlimitedFloat;
begin
{  W:=TUnlimitedFloat.Create;
  try
    W.Exponent.Let(FExponent);
    W.Exponent.Plus(Value.FExponent);
    W.Exponent.Substract(FSurplus);
    W.Fraction.Let(FFraction);
    W.Fraction.Multiply(Value.FFraction);
    W.Normalize;
    W.FractionLen:=FractLength;
    FExponent.Let(W.FExponent);
    FFraction.Let(W.FFraction);
  finally
    W.Free;
  end;}
end;

procedure TUnlimitedFloat.Multiply(Value: TUnlimitedFloat);
var
  W:TUnlimitedFloat;
  FractLength:LongWord;
begin
  FractLength:=FractionLen;
  W:=TUnlimitedFloat.Create;
  try
    W.Exponent:=FExponent+Value.FExponent-FSurplus;
    W.Fraction.Let(FFraction);
    W.Fraction.Multiply(Value.FFraction);
    W.Normalize;
    W.FractionLen:=FractLength;
    FExponent:=W.FExponent;
    FFraction.Let(W.FFraction);
  finally
    W.Free;
  end;
end;

procedure TUnlimitedFloat.Multiply(Value: integer);
var
  TempUnlimitedFloat:TUnlimitedFloat;
begin
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.FSurplus:=FSurplus;
    TempUnlimitedFloat.Let(Value);
    Multiply(TempUnlimitedFloat);
  finally
    TempUnlimitedFloat.Free;
  end;
end;

procedure TUnlimitedFloat.Normalize;
const
  b:LongWord=$80000000;
var
  i,n,k1,k2,l:integer;
  s:boolean;
  Buf,TempBuf:TUnlimitedIntegerBuf;
  Sf:boolean;
  MoveLen:integer;
begin
  if FFraction.Zero then begin
    Exponent:=1;
    exit;
  end;
  Sf:=Sign;
  Sign:=false;
  Buf:=Fraction.GetBuf;
  n:=Length(Buf)-1;
  k1:=-1;
  for i:=n downto 0 do begin
    if Buf[i]>0 then begin
      k1:=i;
      break;
    end else if i>0 then begin
      if Buf[i-1]>=b then begin
        k1:=i;
        break;
      end;
    end;
  end;
  if k1>0 then begin
    if {Sf and }(Int64(Buf[k1])>=Int64(b)) then//todo: д.б. Buf[n-1]=0
      inc(k1);
    if k1>n then
      raise Exception.Create('Переполнение при нормализации');
    MoveLen:=k1+1;
    if n-k1>0 then begin
      if MoveLen>0 then
        Move(Buf[0],Buf[n-k1],MoveLen*SizeOf(LongWord));
      FillChar(Buf[0],(n-k1)*SizeOf(LongWord),0);
      Exponent:=Exponent-(n-k1);
    end;
  end;
  Sign:=Sf;
{  for i:=0 to n do begin
    if Buf[i]>0 then begin
      k2:=i;
      break;
    end;
  end;
  l:=k2-k1+1;
  if l>FractionLen then begin
    s:=false;
    if Buf[k2-FractionLen]>=b then begin
      s:=true
    end;
  end;   }
end;

procedure TUnlimitedFloat.NormalizeDecStr(InStr: string; var FractionStr,
  ExponentStr: string);
var
  PointPos,EPos,BegPos,a:integer;
  i:integer;
  Sign:boolean;
  Exponent:Int64;
begin
  InStr:=Trim(InStr);
  Sign:=InStr[1]='-';
  if Sign then
    InStr:=Copy(InStr,2,Length(InStr));
  for i:=1 to Length(InStr)-1 do
    If InStr[i]<>'0' then
      break
    else
      InStr[i]:=' ';
  InStr:=Trim(UpperCase(InStr));
  PointPos:=Pos(DecimalSeparator,InStr);
  EPos:=Pos(ExpSymbol,InStr);
  FractionStr:='';
  ExponentStr:='0';
  BegPos:=1;
  if PointPos>0 then begin
    FractionStr:=Copy(InStr,1,PointPos-1);
    BegPos:=PointPos+1;
  end;

  if EPos>0 then begin
    FractionStr:=FractionStr+Copy(InStr,BegPos,EPos-BegPos);
    ExponentStr:=Copy(InStr,EPos+1,Length(InStr));
  end else
    FractionStr:=FractionStr+Copy(InStr,BegPos,Length(InStr));
  if PointPos>0 then
    a:=PointPos-1
  else
    a:=Length(FractionStr);
  if Sign then
    FractionStr:='-'+FractionStr;
  ExponentStr:=IntToStr(StrToInt(ExponentStr)+a);
  Exponent:=StrToInt(ExponentStr);
  i:=1;
  while FractionStr[i]='0' do begin
    FractionStr[i]:=' ';
    Inc(i);
    Dec(Exponent);
  end;
  FractionStr:=trim(FractionStr);
  if Length(FractionStr)=0 then
    FractionStr:='0';
  ExponentStr:=IntToStr(Exponent);
end;

procedure TUnlimitedFloat.Plus(Value: TUnlimitedFloat);
begin
  PlusMinus(Value,false);
end;

function TUnlimitedFloat.NormalizeOutDecStr(DecStr: string): string;
var
  FractionStr,ExponentStr:string;
  Exponent:int64;
  m:boolean;
  k,i:integer;
begin
  NormalizeDecStr(DecStr,FractionStr,ExponentStr);
  Exponent:=StrToInt(ExponentStr)-1;
  if FractionStr[1]='9' then begin
    FractionStr:='0'+FractionStr;
    Inc(Exponent);
  end;
  FractionStr:=Trim(GetRoundDecStr(FractionStr));
  k:=1;
  for i:=Length(FractionStr) downto 1 do
    if FractionStr[i]<>'0' then begin
      k:=i;
      break;
    end;
  if k<Length(FractionStr) then
    FractionStr:=Copy(FractionStr,1,k);
  if FractionStr[1]='0' then begin
    FractionStr:=Copy(FractionStr,2,Length(FractionStr));
    Dec(Exponent);
  end;
  ExponentStr:=IntToStr(Exponent);
  result:=FractionStr[1]+DecimalSeparator+Copy(FractionStr,2,Length(FractionStr))+
    'E'+ExponentStr;
end;

procedure TUnlimitedFloat.Plus(Value: integer);
var
  TempUnlimitedFloat:TUnlimitedFloat;
begin
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.FSurplus:=FSurplus;
    TempUnlimitedFloat.Let(Value);
    TempUnlimitedFloat.FractionLen:=FractionLen;
    Plus(TempUnlimitedFloat);
  finally
    TempUnlimitedFloat.Free;
  end;
end;

procedure TUnlimitedFloat.PlusMinus (Value:TUnlimitedFloat;Minus:boolean);
var
  U,V,W:TUnlimitedFloat;
  ShiftLen:Integer;
  x,y:TUnlimitedInteger;
  Sv,Su:boolean;//Знаки V и U
  WFractionLen:LongWord;
  Exch:boolean;
  UBuf,XBuf:TUnlimitedIntegerBuf;
begin
  W:=TUnlimitedFloat.Create;
  try
    W.Surplus:=Surplus;
    if Exponent>Value.Exponent then begin
      U:=Self;
      V:=Value;
      Exch:=false;
    end else begin
      V:=Self;
      U:=Value;
      Exch:=true;
    end;
    Su:=U.Sign;
    Sv:=V.Sign;
    W.FExponent:=U.FExponent;
    WFractionLen:=(FractionLen shl 1) + 2;
    W.FractionLen:=WFractionLen;
    ShiftLen:=U.Exponent-V.Exponent;
    if ShiftLen<FractionLen+2 then begin
    //if U.Exponent.Comparison(FractionLen+2)<1 then begin
      x:=TUnlimitedInteger.Create;
      try
        y:=TUnlimitedInteger.Create;
        try
          x.Precision:=W.FractionLen;
          y.Precision:=W.FractionLen;
          U.Sign:=false;
          V.Sign:=false;
          UBuf:=U.Fraction.GetBuf;
          XBuf:=x.GetBuf;
          Move(UBuf[0], XBuf[WFractionLen-FractionLen-1], FractionLen*SizeOf(integer));
//          Move(U.Fraction.GetBuf[0], x.GetBuf[FractionLen-1], FractionLen);
          Move(V.Fraction.GetBuf[0], y.GetBuf[WFractionLen-FractionLen-
            ShiftLen-1], FractionLen*SizeOf(integer));
          U.Sign:=Su;
          V.Sign:=Sv;
          x.Sign:=Su;
          y.Sign:=Sv;
          if Minus then begin
            if Exch then begin
              y.Substract(x);
              W.Fraction.Let(y);
            end else begin
              x.Substract(y);
              W.Fraction.Let(x);
            end;
          end else begin
            x.Plus(y);
            W.Fraction.Let(x);
          end;
          Sv:=W.Sign;
         // W.Sign:=false;
        finally
          y.Free;
        end;
      finally
        x.Free;
      end;
      inc(W.FExponent);//В старшем байте ноль для того чтобы не было переполнения
      W.Normalize;
      W.FractionLen:=FractionLen;
      Exponent:=W.Exponent;
      Fraction.Let(W.Fraction);
    end else if U<>Self then begin
      Exponent:=U.Exponent;
      Fraction.Let(U.Fraction);
    end;
  finally
    W.Free;
  end;
end;

{procedure TUnlimitedFloat.Power(Value: TUnlimitedFloat);
begin

end;}

procedure TUnlimitedFloat.Power10(Exponent: LongWord);
var
  i,n,m:integer;
begin
  n:=Exponent div MaxDecIntLen;
  m:=Exponent mod MaxDecIntLen;
  for i:=1 to n do
    Multiply(MaxDecInt);
  for i:=1 to m do
    Multiply(10);
end;

procedure TUnlimitedFloat.SetDecStr(const Value: string);
var
  FractionStr,ExponentStr: string;
  DecExp:LongInt;
  TempUnlimitedFloat:TUnlimitedFloat;
  ExpSign:boolean;
begin
  NormalizeDecStr(Value,FractionStr,ExponentStr);
  FExponent:=FSurplus;
  FractionDecStr:=FractionStr;
  //FFraction.Let(2);
  if FFraction.GetBuf[FractionLen-1]=0 then
    inc(FExponent);
  DecExp:=StrToInt(ExponentStr);
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.Surplus:=Surplus;
    TempUnlimitedFloat.Let(1);
    TempUnlimitedFloat.FractionLen:=FractionLen*2;
    ExpSign:=DecExp<0;
    DecExp:=Abs(DecExp);
    TempUnlimitedFloat.Power10(DecExp);
    if ExpSign then
      Divide(TempUnlimitedFloat)
    else
      Multiply(TempUnlimitedFloat);
  finally
    TempUnlimitedFloat.Free;
  end;
end;

procedure TUnlimitedFloat.SetExponent(const Value: LongWord);
begin
  FExponent:=Value;
end;

procedure TUnlimitedFloat.SetExponentAsHex(const Value: string);
begin
  if Value[1]<>'-' then
    FExponent:= StrToInt('$'+Value)
  else
    FExponent:= StrToInt(Value);
end;

procedure TUnlimitedFloat.SetExponentLen(const Value: LongWord);
var
  Prec:LongWord;
  Buf:TUnlimitedIntegerBuf;
begin
{  Prec:=Exponent.Precision;
  if Prec>Value then begin
    Buf:=Exponent.GetBuf;//В старших адресах сохраняем старшие байты
    Move(Buf[Prec-Value],Buf[0],Value);
  end;
  Exponent.Precision:= Value;
  if Value>Prec then begin
    Buf:=Exponent.GetBuf;//В старших адресах сохраняем старшие байты
    Move(Buf[0],Buf[Value-Prec],Prec);
  end;}
end;

procedure TUnlimitedFloat.SetFraction(const Value: TUnlimitedInteger);
begin
  FFraction.Let(Value);
end;

procedure TUnlimitedFloat.SetFractionAsHex(const Value: string);
begin
  FFraction.FractionHexStr:= Value;
end;

procedure TUnlimitedFloat.SetFractionDecSignStr(Value: string);
const
  MaxDecInt=1000000000;
  MaxDecIntLen=9;
var
  n,m,i:integer;
  s:boolean;
  v:LongWord;
  VStr:string;
  k:integer;
  Prec:integer;
  a:integer;
  Buf:TUnlimitedIntegerBuf;
  TempExponent:LongWord;
begin
  if Length(Value)=0 then
    exit;
  TempExponent:=FExponent;
  FExponent:=Surplus;
  Prec:=FractionLen;
  FractionLen:=Prec*2;
  Buf:=FFraction.GetBuf;
  FillChar(Buf[0],FractionLen*SizeOf(integer),0);
  s:=Value[1]='-';
  if s then
    Value:=Copy(Value,2,Length(Value)-1);
  n:=Length(Value);
  m:=n mod MaxDecIntLen;
  n:=n div MaxDecIntLen;
  v:=0;
  if m>0 then begin
    VStr:=Copy(Value,Length(Value)-m+1,m);
    v:=StrToInt(VStr);
    k:=Length(Value)-m+1;
  end else
    k:=Length(Value)+1;
  Plus(v);
//  a:=round(Math.Power(10,m));
  a:=1;
  for i:=1 to m do
    a:=a*10;
  Divide(a);
//  Divide(MaxDecInt);
  for i:=1 to n do begin
    Dec(k,MaxDecIntLen);
    v:=StrToInt(Copy(Value,k,MaxDecIntLen));
    Plus(v);
    Divide(MaxDecInt);
  end;
 // Optimize;
  Sign:=s;
  FractionLen:=Prec;
  if s then
    FExponent:=TempExponent+(FExponent-Surplus)
  else
    FExponent:=TempExponent;
end;

procedure TUnlimitedFloat.SetFractionDecStr(const Value: string);
begin
  SetFractionDecSignStr(Value);
end;

procedure TUnlimitedFloat.SetFractionLen(const Value: integer);
var
  Prec:LongWord;
  Buf:TUnlimitedIntegerBuf;
begin
  Prec:=FFraction.Precision;
  if Prec>Value then begin
    Buf:=FFraction.GetBuf;//В старших адресах сохраняем старшие байты
    Move(Buf[Prec-Value],Buf[0],Value*SizeOf(LongWord));
  end;
  FFraction.Precision:= Value;
  if (Value>Prec)and (Prec>0) then begin
    Buf:=FFraction.GetBuf;//В старших адресах сохраняем старшие байты
    Move(Buf[0],Buf[Value-Prec],Prec*SizeOf(LongWord));
    FillChar(Buf[0],(Value-Prec)*SizeOf(LongWord),0);
  end;
end;

procedure TUnlimitedFloat.SetSign(const Value: boolean);
begin
  FFraction.Sign:=Value;
end;

procedure TUnlimitedFloat.SetSurplus(const Value: LongWord);
begin
  FSurplus := Value;
end;

procedure TUnlimitedFloat.Substract(Value: TUnlimitedFloat);
begin
  PlusMinus(Value,true);
end;

procedure TUnlimitedFloat.Substract(Value: integer);
var
  TempUnlimitedFloat:TUnlimitedFloat;
begin
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.FSurplus:=FSurplus;
    TempUnlimitedFloat.Let(Value);
    TempUnlimitedFloat.FractionLen:=FractionLen;
    Substract(TempUnlimitedFloat);
  finally
    TempUnlimitedFloat.Free;
  end;
end;

procedure TUnlimitedFloat.SetDecPrecision(const Value: LongWord);
var
  a,b:extended;
begin
  FDecPrecision := Value;
  a:=Value;
  a:=a/Log10MaxInt;
  FractionLen:=Abs(round(a)+3);
  MaxDecPrecision:=round(Int(FractionLen*Log10MaxInt));
end;

function TUnlimitedFloat.OptimazeOutDecStr(DecStr: string): string;
var
  FractionStr,ExponentStr:string;
  Exponent:int64;
  m:boolean;
  k,i:integer;
  s:string;
begin
  result:='';
  if Length(DecStr)=0 then
    exit;
  NormalizeDecStr(DecStr,FractionStr,ExponentStr);
  Exponent:=StrToInt(ExponentStr);
  if FractionStr[1]='9' then begin
    FractionStr:='0'+FractionStr;
    Inc(Exponent);
  end;
  FractionStr:=Trim(GetRoundDecStr(FractionStr));
  k:=1;
  for i:=Length(FractionStr) downto 1 do
    if (FractionStr[i]<>'0')or(i=1) then begin
      k:=i;
      break;
    end;
  if k<Length(FractionStr) then
    FractionStr:=Copy(FractionStr,1,k);
  if (FractionStr[1]='0')and(Length(FractionStr)>1) then begin
    FractionStr:=Copy(FractionStr,2,Length(FractionStr));
    Dec(Exponent);
  end;
  if (Exponent>=-4)and (Exponent<Length(FractionStr)+4) then begin
    DelNExp(FractionStr,Exponent);
    Result:=FractionStr;
{    if Exponent<=0 then begin
      SetLength(s,-Exponent);
      if Length(s)>0 then
        FillChar(s[1],Length(s),Ord('0'));
      result:='0'+DecimalSeparator+s+FractionStr;
    end else begin
      if Exponent<Length(FractionStr) then
        result:=Copy(FractionStr,1,Exponent)+DecimalSeparator+Copy(FractionStr,Exponent+1,
           Length(FractionStr))
      else begin
        SetLength(s,Exponent-Length(FractionStr));
        if Length(s)>0 then
          FillChar(s[1],Length(s),Ord('0'));
        result:=FractionStr+s;
      end;
    end}
  end else begin
    Result:=OptimExp(FractionStr,Exponent,10);
{    ExponentStr:=IntToStr(Exponent-1);
    if Length(FractionStr)>1 then
      result:=FractionStr[1]+DecimalSeparator+Copy(FractionStr,2,Length(FractionStr))+
        'E'+ExponentStr
    else begin
      if Length(FractionStr)=1 then
        if (FractionStr<>'0')and(Length(ExponentStr)>0) then
          result:=FractionStr+'E'+ExponentStr
        else
          result:=FractionStr
      else
        Raise Exception.Create('Потеря точности при оптимизации строки');
    end;}
  end;
end;

destructor TUnlimitedFloat.Destroy;
begin
  FFraction.Free;
  FFraction:=nil;
  inherited;
end;

procedure TUnlimitedFloat.Let(Value: Extended);
var
  s:string;
begin
  s:=FloatToStr(Value);
  DecStr:=s;
end;

procedure TUnlimitedFloat.DivideFloat(Value: Extended);
var
  TempUnlimitedFloat:TUnlimitedFloat;
begin
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.FSurplus:=FSurplus;
    TempUnlimitedFloat.Let(Value);
//    TempUnlimitedFloat.FractionLen:=FractionLen;
    Divide(TempUnlimitedFloat);
  finally
    TempUnlimitedFloat.Free;
  end;
end;

procedure TUnlimitedFloat.MultiplyFloat(Value: Extended);
var
  TempUnlimitedFloat:TUnlimitedFloat;
begin
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.FSurplus:=FSurplus;
    TempUnlimitedFloat.Let(Value);
    Multiply(TempUnlimitedFloat);
  finally
    TempUnlimitedFloat.Free;
  end;
end;

procedure TUnlimitedFloat.PlusFloat(Value: Extended);
var
  TempUnlimitedFloat:TUnlimitedFloat;
begin
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.FSurplus:=FSurplus;
    TempUnlimitedFloat.FractionLen:=FractionLen;
    TempUnlimitedFloat.Let(Value);
    Plus(TempUnlimitedFloat);
  finally
    TempUnlimitedFloat.Free;
  end;
end;

procedure TUnlimitedFloat.SubstractFloat(Value: Extended);
var
  TempUnlimitedFloat:TUnlimitedFloat;
begin
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.FSurplus:=FSurplus;
    TempUnlimitedFloat.Let(Value);
    TempUnlimitedFloat.FractionLen:=FractionLen;
    Substract(TempUnlimitedFloat);
  finally
    TempUnlimitedFloat.Free;
  end;
end;

function TUnlimitedFloat.GetFractionAsFloat: extended;
var
  TempUnlimitedFloat:TUnlimitedFloat;
  n:integer;
  Prec:LongWord;
  s:boolean;
begin
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.Let(Self);
    TempUnlimitedFloat.DecPrecision:=15;
    result:=StrToFloat('0'+DecimalSeparator+
      TempUnlimitedFloat.GetFractionDecStr);
  finally
    TempUnlimitedFloat.Free;
  end;
end;

function TUnlimitedFloat.AbsComparison(Value: TUnlimitedFloat): Shortint;
var{Self>Value=>1;Self<Value=>-1;Self=Value=>0}
  s1,s2:boolean;
  n,i,r:integer;
  UnsignedValue:LongWord;
begin
 //todo:Сравнить знаки, порядки, дробные части
  s1:=Sign;
  s2:=Value.Sign;
  Sign:=false;
  Value.Sign:=false;
  result:=Comparison(Value);
  Sign:=s1;
  Value.Sign:=s2;
end;

procedure TUnlimitedFloat.MulPower(const Base: byte;
  const Exponent: int64);
var
  i,n,m:integer;
begin
{  l:=Trunc(LogN(Base,System.MaxInt));
  MaxNIntLen:=round(l);
  MaxNInt:=Round(Power(Base,MaxNIntLen));}
  n:=Exponent div MaxNIntLen;
  m:=Exponent mod MaxNIntLen;
  for i:=1 to n do
    Multiply(MaxNInt);
  for i:=1 to m do
    Multiply(Base);
end;

function TUnlimitedFloat.GetValueAsString(const Base: byte): string;
var
  FractionStr,ExponentStr: string;
  DecExp:LongInt;
  TempUnlimitedFloat:TUnlimitedFloat;
  TempUnlimitedFloatN:TUnlimitedFloat;
  ExpSign:boolean;
  LogExp:integer;
  s:string;
  FractSign:boolean;
  l:double;
  Len:integer;
begin
  if FFraction.Zero then begin
    result:='0';
    exit;
  end;
  l:=Trunc(LogN(Base,System.MaxInt));
  MaxNIntLen:=round(l);
  MaxNInt:=Round(Power(Base,MaxNIntLen));
  if Base<=10 then
    MaxDigit:=char(Base+byte('0')-1)
  else
    MaxDigit:=char(Base-10+byte('A')-1);
  SetLength(NZero,MaxNIntLen);
  FillChar(NZero[1],MaxNIntLen,'0');

  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    ExpSign:=FExponent<Surplus;
    DecExp:=Abs(FExponent-SurPlus);
    a:=LogN(Base,MaxInt);
    LogExp:=Round(a*DecExp);
    TempUnlimitedFloatN:=TUnlimitedFloat.Create;
    try
      TempUnlimitedFloatN.Surplus:=Surplus;
      repeat
        TempUnlimitedFloat.Let(Self);
        TempUnlimitedFloat.FractionLen:=2*FractionLen;
        TempUnlimitedFloatN.Let(1);
        TempUnlimitedFloatN.FractionLen:=FractionLen*2;
        TempUnlimitedFloatN.MulPower(Base,LogExp);
        if ExpSign then
          TempUnlimitedFloat.Multiply(TempUnlimitedFloatN)
        else
          TempUnlimitedFloat.Divide(TempUnlimitedFloatN);
        if TempUnlimitedFloat.FExponent>TempUnlimitedFloat.Surplus then begin
          if ExpSign then
            Dec(LogExp)
          else
            inc(LogExp)
        end else if TempUnlimitedFloat.FExponent<TempUnlimitedFloat.Surplus then begin
          if ExpSign then
            inc(LogExp)
          else
            dec(LogExp);
        end;
      until TempUnlimitedFloat.FExponent=TempUnlimitedFloat.Surplus;
      if ExpSign then
        LogExp:=-LogExp;
      //Len:=Round(TempUnlimitedFloat.MaxDecPrecision*2*Log10(Base));
      Len:=Round(TempUnlimitedFloat.MaxDecPrecision*2*LogN(Base,10));

//todo:Пересчитать логорифм 10 по основанию системы исчисления.      
//      Len:=Round(TempUnlimitedFloat.MaxDecPrecision*3);
      FractionStr:=TempUnlimitedFloat.GetFractionAsString(Base,Len);//FractionDecStr;
      FractSign:=FractionStr[1]='-';
      if FractSign then
        FractionStr:=Copy(FractionStr,2,Length(FractionStr));
      s:='0'+DecimalSeparator+FractionStr+'$'+IntToStr(LogExp);//Для обозначения порядка используется $
//      Result:=NormalizeOutDecStr(s);
      ExponentStr:=IntToStr(LogExp);
      Result:=OptimazeNBaseStr(Base,FractionStr,ExponentStr);
//      Result:=s;
      if FractSign then
        Result:='-'+Result;
    finally
      TempUnlimitedFloatN.Free;
    end;
  finally
    TempUnlimitedFloat.Free;
  end;
end;





function TUnlimitedFloat.GetFractionAsString(const Base: byte;
  const Len: integer): string;
var
  TempUnlimitedFloat:TUnlimitedFloat;
  i,n:integer;
  Prec:LongWord;
  s:boolean;
  Buf: TUnlimitedIntegerBuf;
  r:string;
begin
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.Let(Self);
    TempUnlimitedFloat.FExponent:=FSurplus;
    Prec:=TempUnlimitedFloat.FractionLen;
    TempUnlimitedFloat.FractionLen:=Prec*2;
    r:='';
//    s:=false;
    s:=TempUnlimitedFloat.Sign;
{    if s then begin//если отр. величина, то производим сдвиг и увеличиваем порядок
      Buf:=TempUnlimitedFloat.FFraction.GetBuf;
      n:=Length(Buf)-1;
      for i:=1 to n do
        Buf[i-1]:=Buf[i];
//      Move(Buf[1],Buf[0],Length(Buf)-1);
      Buf[n]:=0;
      inc(TempUnlimitedFloat.FExponent,BasePrecision(Base));
    end;}
    TempUnlimitedFloat.Sign:=false;
    while Length(r)<=Len-MaxNIntLen do begin
      TempUnlimitedFloat.Multiply(MaxNInt);
      if  TempUnlimitedFloat.FExponent>TempUnlimitedFloat.Surplus then begin
        with TempUnlimitedFloat.FFraction do begin
          Buf:=GetBuf;
          r:=r+IntNToStr(Base,Buf[Precision-1]);//Format('%.9d',[Buf[Precision-1]]);
          Buf[Precision-1]:=0;
        end;
        TempUnlimitedFloat.Normalize;
      end else
        r:=r+NZero;
    end;
    if s then
      r:='-'+r;
  finally
    TempUnlimitedFloat.Free;
  end;
  result:=r;
end;

function TUnlimitedFloat.IntNToStr(const Base: byte;
  const Value: LongWord): string;
var
  d,m:byte;
  v,i:LongWord;
begin
  if Value=0 then begin
    Result:=NZero;
    exit;
  end;
  SetLength(Result,MaxNIntLen);
  v:=Value;
  i:=0;
  while v>0 do begin
    m:=v mod Base;
    v:=v div Base;
    if m<10 then
      Result[MaxNIntLen-i]:=char(byte('0')+m)
    else
      Result[MaxNIntLen-i]:=char(m-10+byte('A'));
    inc(i);
  end;
  if MaxNIntLen-i>0 then
    FillChar(Result[1],MaxNIntLen-i,'0');
end;

procedure TUnlimitedFloat.DelNExp(var FractionStr: string;
  const Exponent: integer);
var
  s:string;  
begin
  if Exponent<=0 then begin
    SetLength(s,-Exponent);
    if Length(s)>0 then
      FillChar(s[1],Length(s),Ord('0'));
    FractionStr:='0'+DecimalSeparator+s+FractionStr;
  end else begin
    if Exponent<Length(FractionStr) then
      FractionStr:=Copy(FractionStr,1,Exponent)+DecimalSeparator+Copy(FractionStr,Exponent+1,
         Length(FractionStr))
    else begin
      SetLength(s,Exponent-Length(FractionStr));
      if Length(s)>0 then
        FillChar(s[1],Length(s),Ord('0'));
      FractionStr:=FractionStr+s;
    end;
  end;
end;

function TUnlimitedFloat.OptimExp(const FractionStr: string;
  const Exponent: integer;const Base:byte): string;
var
  ExponentStr:String;
begin
//  ExponentStr:=IntToStr(Exponent-1);
  ExponentStr:=IntToStrN(Base,Exponent-1);
  if Length(FractionStr)>1 then
    result:=FractionStr[1]+DecimalSeparator+Copy(FractionStr,2,Length(FractionStr))+
      ExpSymbol+ExponentStr
  else begin
    if Length(FractionStr)=1 then
      if (FractionStr<>'0')and(Length(ExponentStr)>0) then
        result:=FractionStr+ExpSymbol+ExponentStr
      else
        result:=FractionStr
    else
      Raise Exception.Create('Потеря точности при оптимизации строки');
  end;
end;

procedure TUnlimitedFloat.NormalizeNBaseStr(var FractionStr,
  ExponentStr: string);
var
  PointPos,EPos,BegPos,a:integer;
  i:integer;
  Sign:boolean;
  Exponent:Int64;
begin
  FractionStr:=Trim(FractionStr);
  Sign:=FractionStr[1]='-';
  if Sign then
    FractionStr:=Copy(FractionStr,2,Length(FractionStr));
  FractionStr:=Trim(UpperCase(FractionStr));
  Exponent:=StrToInt(ExponentStr);
  i:=1;
  while FractionStr[i]='0' do begin
    FractionStr[i]:=' ';
    Inc(i);
    Dec(Exponent);
  end;
  FractionStr:=trim(FractionStr);
  if Length(FractionStr)=0 then
    FractionStr:='0';
  ExponentStr:=IntToStr(Exponent);
  if Sign then
    FractionStr:='-'+FractionStr;
end;

function TUnlimitedFloat.OptimazeNBaseStr(const Base:byte; var FractionStr,
  ExponentStr:string): string;
var
  Exponent:int64;
  m:boolean;
  k,i:integer;
  s:string;
begin
  result:='';
  if Length(FractionStr)=0 then
    exit;
  NormalizeNBaseStr(FractionStr,ExponentStr);
  Exponent:=StrToInt(ExponentStr);
  if FractionStr[1]=MaxDigit then begin
    FractionStr:='0'+FractionStr;
    Inc(Exponent);
  end;
  FractionStr:=Trim(GetRoundNBaseStr (FractionStr,Base));
  k:=1;
  for i:=Length(FractionStr) downto 1 do
    if (FractionStr[i]<>'0')or(i=1) then begin
      k:=i;
      break;
    end;
  if k<Length(FractionStr) then
    FractionStr:=Copy(FractionStr,1,k);
  if (FractionStr[1]='0')and(Length(FractionStr)>1) then begin
    FractionStr:=Copy(FractionStr,2,Length(FractionStr));
    Dec(Exponent);
  end;
  if (Exponent>=-4)and (Exponent<Length(FractionStr)+4) then begin
    DelNExp(FractionStr,Exponent);
    Result:=FractionStr;
  end else begin
    Result:=OptimExp(FractionStr,Exponent,Base);
  end;
end;

function TUnlimitedFloat.GetRoundNBaseStr(NBaseStr: string;const Base:byte;
  Len: LongWord): string;
var
  i:integer;
  a,b:integer;
  s:string;
begin
  if Len=0 then
    Len:=round(FDecPrecision*LogN(Base,10));
  if Len=0 then
    Raise Exception.Create('Set precision more then 0');
  if Length(NBaseStr)>Len then begin
    a:=CharToNInt(NBaseStr[Len+1]);
    if a>(Base div 2)-1 then begin
      a:=1;
      for i:=Len downto 1 do begin
        if a=1 then begin
          b:=CharToNInt(NBaseStr[i]);
          b:=b+a;
          if b>CharToNInt(MaxDigit) then
            NBaseStr[i]:=' '
          else begin
            a:=0;
            s:=IntNToStr1(Base,b);
            NBaseStr[i]:=s[1];
//            DecStr[i]:=s[1];
          end;
        end else
          break;
      end;
      if a=1 then
        Raise Exception.Create('Round overflow.');
       // Raise Exception.Create('Переполнение при округлении десятичной строки');
    end;
    result:=Copy (NBaseStr,1,Len);
  end else
    result:=NBaseStr;
end;

function TUnlimitedFloat.CharToNInt(const Value: char): byte;
var
  d,m:byte;
  v,i:LongWord;
begin
  if (Value>='0') and (Value<='9') then
    Result:=Byte(Value)-Byte('0')
  else
    Result:=10+Byte(UpperCase(Value)[1])-Byte('A');
end;

function TUnlimitedFloat.IntNToStr1(const Base: byte;
  const Value: LongWord): string;
var
  d,m:byte;
  v,i:LongWord;
begin
  if Value=0 then begin
    Result:='0';
    exit;
  end;
  Result:='';
  v:=Value;
  i:=0;
  while v>0 do begin
    m:=v mod Base;
    v:=v div Base;
    if m<10 then
      Result:=char(byte('0')+m)+Result
    else
      Result:=char(m-10+byte('A'))+Result;
    inc(i);
  end;
end;

function TUnlimitedFloat.BasePrecision(const Base: byte): integer;
begin
  Result:=Round(LogN(Base,10)*DecPrecision);
end;

procedure TUnlimitedFloat.SetFractionNBaseSignStr(const Base: byte;
  Value: string);
var
  n,m,i:integer;
  s:boolean;
  v:LongWord;
  VStr:string;
  k:integer;
  Prec:integer;
  a:integer;
  Buf:TUnlimitedIntegerBuf;
  TempExponent:LongWord;
begin
  if Length(Value)=0 then
    exit;
  TempExponent:=FExponent;
  FExponent:=Surplus;
  Prec:=FractionLen;
  FractionLen:=Prec*2;
  Buf:=FFraction.GetBuf;
  FillChar(Buf[0],FractionLen*SizeOf(integer),0);
  s:=Value[1]='-';
  if s then
    Value:=Copy(Value,2,Length(Value)-1);
  n:=Length(Value);
  m:=n mod MaxNIntLen;
  n:=n div MaxNIntLen;
  v:=0;
  if m>0 then begin
    VStr:=Copy(Value,Length(Value)-m+1,m);
    v:=NBaseStrToInt(Base,VStr);
    k:=Length(Value)-m+1;
  end else
    k:=Length(Value)+1;
  Plus(v);
  a:=1;
  for i:=1 to m do
    a:=a*Base;
  Divide(a);
  for i:=1 to n do begin
    Dec(k,MaxNIntLen);
    v:=NBaseStrToInt(Base,Copy(Value,k,MaxNIntLen));
    Plus(v);
    Divide(MaxNInt);
  end;
  Sign:=s;
  FractionLen:=Prec;
  if s then
    FExponent:=TempExponent+(FExponent-Surplus)
  else
    FExponent:=TempExponent;
end;

procedure TUnlimitedFloat.SetValueAsString(const Base: byte;
  Value: string);
var
  FractionStr,ExponentStr: string;
  DecExp:LongInt;
  TempUnlimitedFloat:TUnlimitedFloat;
  ExpSign:boolean;
  l:double;
begin
  l:=Trunc(LogN(Base,System.MaxInt));
  MaxNIntLen:=round(l);
  MaxNInt:=Round(Power(Base,MaxNIntLen));
  NormalizeInNBaseStr(Base,Value,FractionStr,ExponentStr);
  FExponent:=FSurplus;
  SetFractionNBaseSignStr (Base,FractionStr);
  //FFraction.Let(2);
  if FFraction.GetBuf[FractionLen-1]=0 then
    inc(FExponent);
  DecExp:=StrToInt(ExponentStr);
  TempUnlimitedFloat:=TUnlimitedFloat.Create;
  try
    TempUnlimitedFloat.Surplus:=Surplus;
    TempUnlimitedFloat.Let(1);
    TempUnlimitedFloat.FractionLen:=FractionLen*2;
    ExpSign:=DecExp<0;
    DecExp:=Abs(DecExp);
    TempUnlimitedFloat.MulPower(Base,DecExp);
    if ExpSign then
      Divide(TempUnlimitedFloat)
    else
      Multiply(TempUnlimitedFloat);
  finally
    TempUnlimitedFloat.Free;
  end;
end;

procedure TUnlimitedFloat.NormalizeInNBaseStr(const Base:byte;InStr: string;
  var FractionStr, ExponentStr: string);
var
  PointPos,EPos,BegPos,a:integer;
  i:integer;
  Sign:boolean;
  Exponent:Int64;
begin
  InStr:=Trim(InStr);
  Sign:=InStr[1]='-';
  if Sign then
    InStr:=Copy(InStr,2,Length(InStr));
  for i:=1 to Length(InStr)-1 do//Удаляем не значащие нули
    If InStr[i]<>'0' then
      break
    else
      InStr[i]:=' ';
  InStr:=Trim(UpperCase(InStr));
  PointPos:=Pos(DecimalSeparator,InStr);
  EPos:=Pos(ExpSymbol,InStr);
  FractionStr:='';
  ExponentStr:='0';
  BegPos:=1;
  if PointPos>0 then begin
    FractionStr:=Copy(InStr,1,PointPos-1);
    BegPos:=PointPos+1;
  end;

  if EPos>0 then begin
    FractionStr:=FractionStr+Copy(InStr,BegPos,EPos-BegPos);
    ExponentStr:=Copy(InStr,EPos+1,Length(InStr));
  end else
    FractionStr:=FractionStr+Copy(InStr,BegPos,Length(InStr));
  if PointPos>0 then
    a:=PointPos-1
  else
    a:=Length(FractionStr);
  if Sign then
    FractionStr:='-'+FractionStr;
  ExponentStr:=IntToStr(NBaseStrToInt(Base,ExponentStr)+a);
  Exponent:=StrToInt(ExponentStr);
  i:=1;
  while FractionStr[i]='0' do begin
    FractionStr[i]:=' ';
    Inc(i);
    Dec(Exponent);
  end;
  FractionStr:=trim(FractionStr);
  if Length(FractionStr)=0 then
    FractionStr:='0';
  ExponentStr:=IntToStr(Exponent);
end;

function TUnlimitedFloat.NBaseStrToInt(const Base: byte;
  const Value: string): Int64;
var
  d,m,a:byte;
  n,i:LongWord;
begin
  Result:=0;
  n:=Length(Value);
  for i:=1 to n do begin
    a:=CharToNInt(Value[i]);
    if a>=Base then
      Raise Exception.Create(
        Format('Symbol %s is inadmissible in %d base value.',[Value[i],Base]));
    Result:=Result*Base+a;
  end;
end;

procedure TUnlimitedFloat.SetFractionNBaseStr(const Base: byte;
  const Fraction: string);
begin
  SetFractionNBaseSignStr (Base, Fraction);
end;

function TUnlimitedFloat.IntToStrN(const Base, Value: integer): string;
var
  i,n,d,m:integer;
begin
  n:=Abs(Value);
  if n=0 then
    Result:='0'
  else
    Result:='';
  while n>0 do begin
    m:=n mod Base;
    n:=n div Base;
    Result:=ConvDigit(m)+Result;
  end;
  if Value<0 then
    Result:='-'+Result;
end;

function TUnlimitedFloat.ConvDigit(const d: byte): char;
begin
  if d>9 then
    Result:=Char(Byte('A')+d-10)
  else
    Result:=Char(Byte('0')+d);
end;

initialization
  Log10MaxInt:=Log10(MaxInt);
  LnMaxInt:=Ln(MaxInt);

end.
