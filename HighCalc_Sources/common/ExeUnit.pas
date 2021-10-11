unit ExeUnit;

interface
uses
  Forms,Controls,Formula,UnlimitedFloat,FunLib,CoreClass,OptUnit,Dialogs,SysUtils;

function ExecExpresion(Expression:string;var ErrorPosition:integer):string;
var
  Options:TOptionsSaver;

implementation
(*
function ExecExpresion(Expression:string):string;
var
   FT:TFormulaTester;
   FE:TFormulaExecute;
   Res:TUnlimitedFloat;
   PolskaRecord:String;
   s:string;
   r:integer;
   Cursor:TCursor;
begin
  Result:='';
  Cursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    FT:=TFormulaTester.Create;
    try
      r:=FT.Test(Expression);
      if r=1 then //Пустое выражение
        exit;
      PolskaRecord:=FT.PolskaRecord;
{    finally
      FT.Free;
    end;
    FT:=TFormulaTester.Create;
    try}
      Res:=TUnlimitedFloat.Create;
      try
        Res.DecPrecision:=1000;
   //     Res.ExponentLen:=2;
        FT.Execute(PolskaRecord,Res);
        s:=Res.DecStr;
        Result:=s;
      finally
        Res.Free;
      end;
    finally
      FT.Free;
    end;
    //ExpressionBuffer.AddExpression(ExpressionMemo);
  finally
    Screen.Cursor:=Cursor;
  end;
end;
*)


function ResultType:byte;
begin
  if Options.UseCoProcessor then
    Result:=rtCoProcessor
  else
    Result:=rtHighPrec;
end;

function ExecExpresion(Expression:string;var ErrorPosition:integer):string;
var
   Res:TUnlimitedFloat;
   PolskaRecord:String;
   HighPrecCore:THighPrecCore;
   Cursor:TCursor;
begin
  ErrorPosition:=-1;
  Result:='';
  Cursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    HighPrecCore:=THighPrecCore.Create;
    try
      HighPrecCore.Expression:=Expression;
//      HighPrecCore.ResultType:=rtCoProcessor;
//      HighPrecCore.ResultType:=rtHighPrec;
      HighPrecCore.ResultType:=ResultType;
//      HighPrecCore.DecimalPrecision:=1000;
      HighPrecCore.DecimalPrecision:=Options.Precision;
      HighPrecCore.ResultBase:=Options.ResultBase;
      HighPrecCore.ResultDMS:=Options.ResDMS;
      result:=HighPrecCore.ResultValue;
    //  ShowMessage(IntToStr(HighPrecCore.ErrorPosition));
    finally
      ErrorPosition:=HighPrecCore.ErrorPosition;
      HighPrecCore.Free;
    end;
    //ExpressionBuffer.AddExpression(ExpressionMemo);
  finally
    Screen.Cursor:=Cursor;
  end;
end;


end.
