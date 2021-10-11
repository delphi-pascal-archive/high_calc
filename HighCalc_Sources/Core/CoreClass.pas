unit CoreClass;

interface
uses
  Formula,UnlimitedFloat,Controls,Forms,SysUtils;
const
  rtHighPrec=1;
  rtCoProcessor=2;
type
  THighPrecCore=class
  private
    FHighPrec: boolean;
    FErrorCod: integer;
    FErrorPosition: integer;
    FResultType: integer;
    FExpressionType: integer;
    FExpression: string;
    FT:TFormulaTester;
    FE:TFormulaExecute;
    UnlimitedFloatRes:TUnlimitedFloat;
    FDecimalPrecision: integer;
    FResultBase: byte;
    FResultDMS: boolean;
    procedure SetHighPrec(const Value: boolean);
    procedure SetErrorCod(const Value: integer);
    procedure SetErrorPosition(const Value: integer);
    procedure SetExpression(const Value: string);
    procedure SetExpressionType(const Value: integer);
    procedure SetResultType(const Value: integer);
    function CalcExpression:string;
    function CalcHighPrecExpression:string;
    function GetResultValue: string;
    procedure SetDecimalPrecision(const Value: integer);
    function GetErrorPosition: integer;
    procedure SetResultBase(const Value: byte);
    procedure SetResultDMS(const Value: boolean);
  public
    property HighPrec:boolean read FHighPrec write SetHighPrec;
    property ExpressionType:integer read FExpressionType write SetExpressionType;
    property ResultType:integer read FResultType write SetResultType;
    property Expression:string read FExpression write SetExpression;
    property ResultValue:string read GetResultValue;
    property ErrorPosition:integer read GetErrorPosition;
    property ErrorCod:integer read FErrorCod write SetErrorCod;
    property DecimalPrecision:integer read FDecimalPrecision write SetDecimalPrecision;
    property ResultBase:byte read FResultBase write SetResultBase;
    property ResultDMS:boolean read FResultDMS write SetResultDMS;
    constructor Create;
    destructor Destroy;override;
  end;
implementation
uses
  AngConv;
{ THighPrecCore }

function THighPrecCore.CalcExpression: string;
var
   PolskaRecord:String;
   r:integer;
   Cursor:TCursor;
   Res:Extended;
   x:TUnlimitedFloat;
begin
  Result:='';
  Cursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    r:=FT.Test(Expression);
    if r=1 then //Пустое выражение
      exit;
    PolskaRecord:=FT.PolskaRecord;
    //UnlimitedFloatRes.DecPrecision:=FDecimalPrecision;
     //     Res.ExponentLen:=2;
    Res:=FT.Execute(PolskaRecord);
    if ResultDMS then
      Result:=DegToDms(Res)
    else begin
      Result:=FloatToStr(Res);
      if ResultBase<>10 then begin
        x:=TUnlimitedFloat.Create;
        try
          x.DecPrecision:=20;
          x.DecStr:=Result;
          Result:=x.GetValueAsString(ResultBase);
        finally
          x.Free;
        end;
      end;
    end;
  finally
    Screen.Cursor:=Cursor;
  end;
end;

function THighPrecCore.CalcHighPrecExpression: string;
var
   PolskaRecord:String;
   s:string;
   r:integer;
   Cursor:TCursor;
begin
  Result:='';
  Cursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    r:=FT.Test(Expression);
    if r=1 then //Пустое выражение
      exit;
    PolskaRecord:=FT.PolskaRecord;
    UnlimitedFloatRes.DecPrecision:=FDecimalPrecision;
     //     Res.ExponentLen:=2;
    FT.Execute(PolskaRecord,UnlimitedFloatRes);
{    if ResultBase=10 then
      s:=UnlimitedFloatRes.DecStr
    else}
      s:=UnlimitedFloatRes.GetValueAsString(ResultBase);
    Result:=s;
  finally
    Screen.Cursor:=Cursor;
  end;
end;

constructor THighPrecCore.Create;
begin
  inherited;
  FHighPrec := false;
  FT:=TFormulaTester.Create;
  FE:=TFormulaExecute.Create;
  UnlimitedFloatRes:=TUnlimitedFloat.Create;
end;

destructor THighPrecCore.Destroy;
begin
  FT.Free;
  FE.Free;
  UnlimitedFloatRes.Free;
  inherited;
end;

function THighPrecCore.GetErrorPosition: integer;
begin
  Result:=FT.ErrorPosition;
end;

function THighPrecCore.GetResultValue: string;
begin
  if FResultType=rtHighPrec then
    result:=CalcHighPrecExpression
  else if FResultType=rtCoProcessor then
    result:=CalcExpression
  else
    raise Exception.Create('Неверный ResultType');
end;

procedure THighPrecCore.SetDecimalPrecision(const Value: integer);
begin
  FDecimalPrecision := Value;
end;

procedure THighPrecCore.SetErrorCod(const Value: integer);
begin
  FErrorCod := Value;
end;

procedure THighPrecCore.SetErrorPosition(const Value: integer);
begin
  FErrorPosition := Value;
end;

procedure THighPrecCore.SetExpression(const Value: string);
begin
  FExpression := Value;
end;

procedure THighPrecCore.SetExpressionType(const Value: integer);
begin
  FExpressionType := Value;
end;

procedure THighPrecCore.SetHighPrec(const Value: boolean);
begin
  FHighPrec := Value;
end;

procedure THighPrecCore.SetResultBase(const Value: byte);
begin
  FResultBase := Value;
end;

procedure THighPrecCore.SetResultDMS(const Value: boolean);
begin
  FResultDMS := Value;
end;

procedure THighPrecCore.SetResultType(const Value: integer);
begin
  FResultType := Value;
end;

end.
