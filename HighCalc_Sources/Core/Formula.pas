unit Formula;

interface
uses SysUtils,Dialogs,UnlimitedFloat,FunDefConst,VarUnit;
const
   prString=1;
   prVariable=2;
   prValue=3;
   prConstString=4;
   MinX=1;
   MaxX=702;
   MinY=1;
   MaxY=10000;
   MinFunCod=0;
//   MaxFunCod=200;
   MaxFunCod=255;
{   Plus=3;
   Minus=4;
   Multiplication=5;
   Division=6;}
   Bracket=7;
   Extent=8;
{   oExp=101;
   oArcSin=102;
   oLn=103;
   oPi=104;
   oE=105;
   oSin=106;}
   ParametrSeparator=';';
   NewMinusSymbol='~';
type
   TGetFunction=function(x,y:integer):extended;
   FunctionDefinitions=array of TFuncDesc;
   StackElementPointer=^StackElement;
   StackElement=record
      Val:TUnlimitedFloat;//число
      Next:StackElementPointer;
   end;
   ExtendedStackElementPointer=^ExtendedStackElement;
   ExtendedStackElement=record
      Val:Extended;//число
      Next:ExtendedStackElementPointer;
   end;

   StringStackElementPointer=^StringStackElement;
   StringStackElement=record
      StrLen:integer;
      Val:PChar;//Строка
      Next:StringStackElementPointer
   end;

   StackOperationElementPointer=^StackOperationElement;
   StackOperationElement=record
      OpCod:word;
      Next:StackOperationElementPointer;
   end;
   ByteArray=array[0..0] of byte;
   TPolskaRecord=^ByteArray;
   TextendedArray=array[0..0] of extended;
   TRange=record
      NumElem:integer;
      Buf:^TextendedArray;
   end;
   TFormulaCompiler=class
       PolskaRecord:string;
       ArifmRecord:string;
       function TranslateVal(var s:string;var i:integer):string;
   end;

  TFormulaExecute=class(TFormulaCompiler)
  protected
    VarBuf:TVarBuf;
  private
    FCoProc: boolean;
    FStrBuf: string;
    procedure SetCoProc(const Value: boolean);
    procedure SetStrBuf(const Value: string);
  public
       TopValStack:StackElementPointer;
       ExtendedTopValStack:ExtendedStackElementPointer;
       StringTopValStack:StringStackElementPointer;
       GetVal:TGetFunction;
       X:TUnlimitedFloat;
       ExtendedX:Extended;
       property StrBuf:string read FStrBuf write SetStrBuf;
       property CoProc:boolean read FCoProc write SetCoProc;
       procedure Push(Val:TUnlimitedFloat);overload;
       procedure Push(Val:Extended);overload;
       procedure Push(Val:String);overload;
       function Pop:TUnlimitedFloat;overload;
       procedure Pop(var Val:Extended);overload;
       procedure Pop(var Val:string);overload;
       procedure PushVariable(const VarCod:integer);
       procedure PushVariableExt(const VarCod:integer);
       procedure ExecOperation(CodOp:integer);
       procedure ExecExtendedOperation(CodOp:integer);
       procedure Execute(const Formula:string;var Res:TUnlimitedFloat);overload;
       function Execute(Formula:string):Extended;overload;
       function ExtractString(PolskaRecord:string;var i:integer):string;
       function GetCell(var i:integer):extended;virtual;abstract;
       procedure SetVariable(VarCod:integer;Value:string);
       constructor Create;
  end;

  TExpressionIndexer=array of byte;
  TFormulaTester=class(TFormulaExecute)
  private
    FErrorPosition: integer;
    procedure SetErrorPosition(const Value: integer);
    function DeleteQuotes(var line: string): boolean;
  public
      TestFormula:string;
      ParamCount:integer;
      ExpressionIndexer:TExpressionIndexer;
      property ErrorPosition:integer read FErrorPosition write SetErrorPosition;
      function Test(Formula:string):integer;
      procedure DelReturnSpace(var Formula:string);
      procedure IsCorrect(var i,ParamCount:integer;const Args: array of integer);//
      function  TranslateConstString(var i:integer):string;
      function  GetRangeSize(var i,x1,y1,x2,y2:integer):integer;
      function TranslateId(var i:integer;s:string):string;
      function TranslateOperandId(var i:integer;s:string):string;
      function GetFunCod(s:string;var Cod,ArgNum:integer):boolean;
      procedure GetVariableCod(s:string;var Cod:integer);
      procedure GetConstantCod(const s:string;var Cod:integer);
      function GetConstantByCod(const Cod:integer):string;
      function GetCell(var i:integer):extended;override;
      function ConvertToPolskaRecord(Formula:string):string;
      function GetOpCod(c:char):string;
      procedure DeleteBrackets(var line:string);
  end;
  Operation=procedure(Stack:TFormulaExecute);
var
   Operations:array[1..MaxFunCod] of operation;
   ExtendedOperations:array[1..MaxFunCod] of Operation;
//   FunDefs:FunctionDefinitions;
   ErrPosInTestEpress:integer;
implementation
function IsHighLetter(c:char):boolean;
begin
   result:=((c>='A')and(c<='Z'))or(c='_');
end;
function IsDigit(c:char):boolean;
begin
   result:=(c>='0')and(c<='9')or(c='-')or(c=DecimalSeparator);
end;

function ConvX(X:string):integer;
var
  Len,i:byte;
  C:integer;
begin
   Len:=length(X);
   result:=0;
   C:=1;
   for i:=Len downto 1 do begin
       result:=result+(byte(X[i])-byte('A')+1)*C;
       C:=C*26;
   end;
end;

{ TFormulaCompiler }
function TFormulaCompiler.TranslateVal(var s:string;  var i: integer): string;
var
  d,e:boolean;
begin
   result:='';
   if s[i]='-' then begin
       result:='-';
       inc(i);
       if ((s[i]<'0')or(s[i]>'9'))and (s[i]<>DecimalSeparator) then begin
         result:='-1';
         dec(i);
         s[i]:='*';
       end;
   end;
   if s[i]=DecimalSeparator then begin
     inc(i);
     if (s[i]<'0')or(s[i]>'9') then
       Raise Exception.Create('Digit expected.');//Ожидалась цифра
     result:=result+'0'+DecimalSeparator;
   end;
   d:=false;
   e:=false;
   while (s[i]>='0')and(s[i]<='9')or(s[i]=DecimalSeparator)or(s[i]=ExpSymbol)
     or(s[i]='-')do begin
     if (s[i]='-')and(s[i-1]<>ExpSymbol) then
       exit;
     if s[i]=DecimalSeparator then begin
       if d then
         exit
       else
         d:=true
     end;
     if s[i]=ExpSymbol then begin
       if e then
         exit
       else
         e:=true
     end;
     result:=result+s[i];
     inc(i);
   end;
end;
{ TFormulaExecute }

procedure TFormulaExecute.ExecOperation(CodOp:integer);
begin
  if CodOp<MinVariableCod then begin
    if @Operations[CodOp]=nil then
      Raise Exception.Create('Operation isn''t support.');
//      Raise Exception.Create('Операция не поддерживается');
    Operations[CodOp](Self);
  end else
    PushVariable(CodOp);
end;

(*procedure TFormulaExecute.Execute(const Formula:string;var Res:TUnlimitedFloat);
var
   TempS:string;
   i,Len:integer;
   a,b:string;
begin
//    ConvertFormula(Formula);
    i:=1;
  x:=TUnlimitedFloat.Create;
  try
    x.Let(Res);
    //x.FractionLen:=20;
   // x:=Res;
    PolskaRecord:=Formula;
    Len:=Length(Formula);
    TempS:='1';
    GlobLen:=@Len;
    GlobalRes:=Res;
//    r:=Pointer(@Res);
    a:=Res.FractionDecStr;
   // Res:=x;
    b:=Res.FractionDecStr;
    ShowMessage(a);
    ShowMessage(b);
    a:=Res.DecStr;
    ShowMessage(IntToStr(integer(@Res)));
    b:=Res.DecStr;
    ShowMessage(a);
    ShowMessage(b);

//    ShowMessage(Res.DecStr);
//    ShowMessage(Res.DecStr);
    X.DecStr:=TempS;
    ShowMessage(Res.DecStr);
//    TempS:=X.DecStr;
//    ShowMessage(TempS+IntToStr(GlobLen^)+Res.DecStr+IntToStr(integer(r)));
    while i<=Len do begin
      inc(i);
    end;
    while i<=Len do begin
       if (PolskaRecord[i]>='0') and (PolskaRecord[i]<='9') or
          (PolskaRecord[i]='-') then begin
  //         TempS:='';
           while (i<=Len) and  ((PolskaRecord[i]>='0') and
                (PolskaRecord[i]<='9')or (PolskaRecord[i]=DecimalSeparator)or
                (PolskaRecord[i]='E') or(PolskaRecord[i]='-'))do begin
//                TempS:=TempS+PolskaRecord[i];
                inc(i);
           end;
(*          X.DecStr:=TempS;
//           X.DecStr:='1312';
       end else if (PolskaRecord[i]='^') then begin
           inc(i);
//           Push(X);
       end else if (PolskaRecord[i]='#') then begin
           inc(i);
           TempS:='';
           while (i<=Len) and  (PolskaRecord[i]>='0') and
                (PolskaRecord[i]<='9')do begin
              //  TempS:=TempS+PolskaRecord[i];
                inc(i);
           end;
          // Push(X);
//           ExecOperation(StrToInt(TempS));

       end;
       inc(i);
    end;
    Res.Let(x);
  finally
    x.Free;

  end;
end;*)

procedure TFormulaExecute.Execute(const Formula:string;var Res:TUnlimitedFloat);
var
   TempS:string;
   i,Len:integer;
begin
  i:=1;
  x:=TUnlimitedFloat.Create;
  try
    x.Let(Res);
    PolskaRecord:=Formula;
    Len:=Length(PolskaRecord);
    while i<=Length(PolskaRecord) do begin
       if (PolskaRecord[i]>='0') and (PolskaRecord[i]<='9') or
          (PolskaRecord[i]='-') then begin
           TempS:='';
           while (i<=Len) and  ((PolskaRecord[i]>='0') and
                (PolskaRecord[i]<='9')or (PolskaRecord[i]=DecimalSeparator)or
                (PolskaRecord[i]=ExpSymbol) or(PolskaRecord[i]='-'))do begin
                TempS:=TempS+PolskaRecord[i];
                inc(i);
           end;
           X.DecStr:=TempS;
       end else if (PolskaRecord[i]='^') then begin
           inc(i);
           Push(X);
       end else if (PolskaRecord[i]='#') then begin
           inc(i);
           TempS:='';
           while (i<=Len) and  (PolskaRecord[i]>='0') and
                (PolskaRecord[i]<='9')do begin
                TempS:=TempS+PolskaRecord[i];
                inc(i);
           end;
           Push(X);
           ExecOperation(StrToInt(TempS));
       end else if (PolskaRecord[i]='''') then begin
         inc(i);
         StrBuf:=ExtractString(PolskaRecord,i);
         Push(StrBuf);
      end
    end;
    Res.Let(x);
  finally
    x.Free;
  end;
end;


function TFormulaExecute.Execute(Formula: string): Extended;
var
   TempS:string;
   i,Len:integer;
begin
  i:=1;
  PolskaRecord:=Formula;
  Len:=Length(PolskaRecord);
  while i<=Len do begin
     if (PolskaRecord[i]>='0') and (PolskaRecord[i]<='9') or
        (PolskaRecord[i]='-') then begin
         TempS:='';
         while (i<=Len) and  ((PolskaRecord[i]>='0') and
              (PolskaRecord[i]<='9')or (PolskaRecord[i]=DecimalSeparator)or
              (PolskaRecord[i]=ExpSymbol) or(PolskaRecord[i]='-'))do begin
              TempS:=TempS+PolskaRecord[i];
              inc(i);
         end;
         ExtendedX:=StrToFloat(TempS);
     end else if (PolskaRecord[i]='^') then begin
         inc(i);
         Push(ExtendedX);
     end else if (PolskaRecord[i]='#') then begin
         inc(i);
         TempS:='';
         while (i<=Len) and  (PolskaRecord[i]>='0') and
              (PolskaRecord[i]<='9')do begin
              TempS:=TempS+PolskaRecord[i];
              inc(i);
         end;
//         Push(ExtendedX);//todo : Убрать, в функциях использовать в качестве одного параметра ExtendedX
         ExecExtendedOperation(StrToInt(TempS));
     end else if (PolskaRecord[i]='''') then begin
         inc(i);
         StrBuf:=ExtractString(PolskaRecord,i);
         Push(StrBuf);
     end
  end;
  result:=ExtendedX;
end;

function TFormulaExecute.Pop: TUnlimitedFloat;
var
   Temp:StackElementPointer;
begin
   Result:=TopValStack.Val;
   Temp:=TopValStack;
   TopValStack:=TopValStack.Next;
   FreeMem(Temp,SizeOf(StackElement));
end;

procedure TFormulaExecute.Push(Val: TUnlimitedFloat);
var
   Temp:StackElementPointer;
begin
  GetMem(Temp,SizeOf(StackElement));
  Temp.Val:=TUnlimitedFloat.Create;
  Temp.Val.Let(Val);
  Temp.Next:=TopValStack;
  TopValStack:=Temp;
end;


procedure TFormulaExecute.Push(Val: Extended);
var
   Temp:ExtendedStackElementPointer;
begin
  GetMem(Temp,SizeOf(ExtendedStackElement));
  Temp.Val:=Val;
  Temp.Next:=ExtendedTopValStack;
  ExtendedTopValStack:=Temp;
end;

procedure TFormulaExecute.SetCoProc(const Value: boolean);
begin
  FCoProc := Value;
end;

procedure TFormulaExecute.Pop(var Val: Extended);
var
   Temp:ExtendedStackElementPointer;
begin
   Val:=ExtendedTopValStack.Val;
   Temp:=ExtendedTopValStack;
   ExtendedTopValStack:=ExtendedTopValStack.Next;
   FreeMem(Temp,SizeOf(ExtendedStackElement));
end;

procedure TFormulaExecute.ExecExtendedOperation(CodOp: integer);
begin
  if CodOp<MinVariableCod then
    ExtendedOperations[CodOp](Self)
  else
    PushVariableExt(CodOp);
end;

constructor TFormulaExecute.Create;
begin
  VarBuf:=VarUnit.VarBuf;
end;

procedure TFormulaExecute.PushVariable(const VarCod: integer);
begin
  X.DecStr:=VarBuf.GetVariableValue(VarCod);
end;

procedure TFormulaExecute.PushVariableExt(const VarCod: integer);
var
  x:Extended;
begin
//  Pop(x);
  ExtendedX:=StrToFloat(VarBuf.GetVariableValue(VarCod));
end;

procedure TFormulaExecute.SetVariable(VarCod: integer; Value: string);
begin
  VarBuf.SetVariableValue(VarCod,Value);
end;

procedure TFormulaExecute.SetStrBuf(const Value: string);
begin
  FStrBuf := Value;
end;

function TFormulaExecute.ExtractString(PolskaRecord: string;
  var i: integer): string;
var
   index,
   level        : integer;
   Line:string;
begin
  line:=PolskaRecord;
  if Length(Line)=0 then
    raise Exception.Create('Ошибка при удалении скобок');
  level:=1;
  for index:=i to length(line) do
      begin
           case line[index] of
                '''':inc(level);
                '"':dec(level);
           end;
           if (level=0) then begin
             if (line[index+1]='^') or (line[index+1]='#') then begin
               result:=Copy(PolskaRecord,i,Index-i);
               if (line[index+1]='^') then
                 i:=Index+2
               else
                 i:=Index+1;
               exit;
             end else
               Raise Exception.Create('String error');
           end;
           if (level<0) then Raise Exception.Create('Неверное количество скобок');
      end;
  Raise Exception.Create('Неверное количество скобок');
end;

procedure TFormulaExecute.Pop(var Val: string);
var
   Temp:StringStackElementPointer;
begin
   SetLength(Val,StringTopValStack.StrLen);
   Move(StringTopValStack.Val^,Val[1],StringTopValStack.StrLen);
   Temp:=StringTopValStack;
   StringTopValStack:=StringTopValStack.Next;
   FreeMem(Temp.Val,Temp.StrLen);
   FreeMem(Temp,SizeOf(StringStackElement));
end;

procedure TFormulaExecute.Push(Val: String);
var
   Temp:StringStackElementPointer;
begin
  GetMem(Temp,SizeOf(StringStackElement));
  Temp.StrLen:=Length(Val);
  GetMem(Temp.Val,Temp.StrLen);
  Move(Val[1],Temp.Val^,Temp.StrLen);
  Temp.Next:=StringTopValStack;
  StringTopValStack:=Temp;
end;

{ TFormulaTester }

function TFormulaTester.ConvertToPolskaRecord(Formula: string): string;
var
   level,position,Position1,Position2,i,ParamCount,Priority:integer;
   OpCod,p1,p2,a:integer;
   StrOpCod:string;
   FunCod:string;
   Quotes:boolean;
begin
   DeleteBrackets(Formula);
   Quotes:=DeleteQuotes(Formula);
   level:=0;
   position:=0;
   Position1:=0;
   Position2:=0;
   ParamCount:=0;
   Priority:=100000;
   i:=1;
   while i<=length(Formula) do begin
      case Formula[i] of
         '(':inc(level);
         ')':dec(level);
         ';':if (level=0) then begin position:=i; position1:=i; end;
{         '+',NewMinusSymbol:if (level=0) and (Formula[position]<>';') then position:=i;
         '*','/':if (level=0) and (Formula[position]<>'+') and
                (Formula[position]<>NewMinusSymbol) and (Formula[position]<>';') then
                   position:=i;
         '^':if (level=0) and (Formula[position]<>'+') and
                (Formula[position]<>NewMinusSymbol) and (Formula[position]<>'*')
                and (Formula[position]<>'/') and (Formula[position]<>'+') then
                   position:=i;}
         '@': begin
               a:=i-1;
               inc(i);
               OpCod:=StrToInt(TranslateVal(Formula,i));
               if (level=0)and(Priority>=FunDefs[OpCod].ArgNum) then begin
                 Position:=a;
                 Priority:=FunDefs[OpCod].ArgNum;
                 Position1:=Position;
                 Position2:=i+1;
                 StrOpCod:=IntToStr(OpCod);
               end;
             end;
      end;
      inc(i);
   end;
   if Position1=0 then begin
       if Formula[1]='#'then begin
         FunCod:='';
         for i:=2 to Length(Formula) do begin
               if (Formula[i]>='0')and(Formula[i]<='9') then
                  FunCod:=FunCod+Formula[i]
               else begin
                  Position:=i;
                  break;
               end;
         end;
         if Position=0 then
           result:=Formula
         else
           result:=ConvertToPolskaRecord(Copy(Formula,Position,Length(Formula)))+
                 Copy(Formula,1,Position-1)
       end else
         result:=Formula;
   end else if Formula[Position]=ParametrSeparator then begin
     result:=ConvertToPolskaRecord(Copy(Formula,1,Position-1))+'^'+
         ConvertToPolskaRecord(Copy(Formula,Position+1,Length(Formula)));

   end else begin
{     result:=ConvertToPolskaRecord(Copy(Formula,1,Position-1))+'^'+
       ConvertToPolskaRecord(Copy(Formula,Position+1,Length(Formula)))+
       '#'+StrOpCod;//GetOpCod(Formula[Position]);}
      result:=ConvertToPolskaRecord(Copy(Formula,1,Position1))+'^'+
       ConvertToPolskaRecord(Copy(Formula,Position2,Length(Formula)))+
       '#'+StrOpCod;
   end;
   if Quotes then
     Result:=''''+Result+'"';
end;

procedure TFormulaTester.DelReturnSpace(var Formula:string);
var
  i,n,j:integer;
  NewFormula:string;
begin
  n:=Length(Formula);
  SetLength(NewFormula,n);
  SetLength(ExpressionIndexer,n+1);
  j:=1;
  for i:=1 to n do
    if {(Formula[i]<>' ')and }(Formula[i]<>#$0D)and(Formula[i]<>#$0A) then begin
      NewFormula[j]:=Formula[i];
      ExpressionIndexer[j]:=i;
      inc(j);
    end;
  Dec(j);  
  SetLength(NewFormula,j);
  SetLength(ExpressionIndexer,j+1);
  Formula:=NewFormula;
end;

procedure TFormulaTester.DeleteBrackets(var line: string);
var
   index,
   level        : integer;
   haveto       : boolean;
begin
     haveto:=true;
     if Length(Line)=0 then
       raise Exception.Create('Ошибка при удалении скобок');
     if line[1]<>'(' then haveto:=false;
     level:=0;
     for index:=1 to length(line) do
         begin
              case line[index] of
                   '(':inc(level);
                   ')':dec(level);
              end;
              if (level=0) and (index<>length(line)) then haveto:=false;
              if (level<0) then Raise Exception.Create('Неверное количество скобок');
         end;
     if level<>0 then
          Raise Exception.Create('Неверное количество скобок');
     if haveto then
        begin
             delete(line,1,1);
             delete(line,length(line),1);
             DeleteBrackets(line);
        end;
end;


function TFormulaTester.DeleteQuotes(var line: string):boolean;
var
   index,
   level        : integer;
   haveto       : boolean;
begin
     line:=Trim(line);
     haveto:=true;
     if Length(Line)=0 then
       raise Exception.Create('Ошибка при удалении скобок');
     if line[1]<>'''' then haveto:=false;
     level:=0;
     for index:=1 to length(line) do
         begin
              case line[index] of
                   '''':inc(level);
                   '"':dec(level);
              end;
              if (level=0) and (index<>length(line)) then haveto:=false;
              if (level<0) then Raise Exception.Create('Неверное количество скобок');
         end;
     if level<>0 then
          Raise Exception.Create('Неверное количество скобок');
     if haveto then
        begin
             delete(line,1,1);
             delete(line,length(line),1);
             DeleteQuotes(line);
        end;
    Result:=haveto;
end;


function TFormulaTester.GetCell(var i: integer): extended;
var
   x,y:string;
begin
    inc(i);
    while PolskaRecord[i]<>'Y' do begin
        x:=x+PolskaRecord[i];
        inc(i);
    end;
    inc(i);
    while (PolskaRecord[i]<='9')and(PolskaRecord[i]>='0') do begin
        y:=y+PolskaRecord[i];
        inc(i);
    end;
    result:=GetVal(StrToInt(x),StrToInt(y));
end;

function TFormulaTester.GetFunCod(s: string; var Cod,ArgNum: integer): boolean;
var
   j:integer;
begin
   for j:=Low(FunDefs) to High(FunDefs) do begin
       if s=FunDefs[j].FunId then begin
          Cod:=j;
          ArgNum:=FunDefs[j].ArgNum;
          Result:=True;
       end;
   end;
end;

function TFormulaTester.GetOpCod(c: char): string;
var
  ic:byte;
begin
  case c of
    '+':ic:=oAddition;
    NewMinusSymbol:ic:=oSubtraction;//Вычитание
    '*':ic:=oMultiplication;
    '/':ic:=oDivision;
    '^':ic:=oPower;
  end;
  result:=IntToStr(ic);
end;

function TFormulaTester.GetRangeSize(var i,x1,y1,x2,y2:integer): integer;
var
   x,y:string;
   k:integer;
begin
    x:='';
    k:=i;
    while IsHighLetter(TestFormula[i]) do begin
        x:=x+TestFormula[i];
        inc(i);
    end;
    x1:=ConvX(x);
    y:='';
    while IsDigit(TestFormula[i]) do begin
        y:=y+TestFormula[i];
        inc(i);
    end;
    y1:=StrToInt(y);
    if (x1>MaxX) or (x1<MinX) or (y1>MaxY) or (y1<MinY) then begin
       ErrorPosition:=k;
       Raise Exception.Create('Ошибка диапазона');
    end;
    k:=i;
    if TestFormula[i]=':' then begin
       x:='';
       inc(i);
       while IsHighLetter(TestFormula[i])  do begin
          x:=x+TestFormula[i];
          inc(i);
       end;
       x2:=ConvX(x);
       y:='';
       while IsDigit(TestFormula[i]) do begin
          y:=y+TestFormula[i];
          inc(i);
       end;
       y2:=StrToInt(y);
       if (x2>MaxX) or (x2<MinX) or (y2>MaxY) or (y2<MinY) then begin
          ErrorPosition:=k;
          Raise Exception.Create('Ошибка диапазона');
       end;
       result:=(x2-x1+1)*(y2-y1+1);
    end else
       result:=1;
end;

procedure TFormulaTester.IsCorrect(var i,ParamCount:integer;const Args: array of integer);
var
   Len,LenArifm:integer;
   s:string;
   Cod,ArgNum,k,RS,x1,y1,x2,y2,AN:integer;
   UnlimitedParams,Single:boolean;
   l,m,ii:integer;
   ArgsLen,ParamIndex:integer;
   SetAvailable:boolean;
begin
   SetAvailable:=false;
   if ParamCount<0 then begin
       UnlimitedParams:=true;
       ParamCount:=0;
   end;
   Len:=Length(TestFormula);
   Single:=false;
   ParamIndex:=0;
   ArgsLen:=Length(Args);
   if ArgsLen>0 then begin
     if Args[ParamIndex]=prString then
       ArifmRecord:=ArifmRecord+''''
     else if Args[ParamIndex]=prConstString then begin
       ArifmRecord:=ArifmRecord+TranslateConstString(i);
       Dec(ParamCount);
     end;
   end;
   while (i<=Len) and (TestFormula[i]<>')')  do begin
       while TestFormula[i]=' ' do
         inc(i);
       if IsHighLetter(TestFormula[i]) then begin//Функция, переменная или константа
           k:=i;
           s:=TranslateId(i,TestFormula);
  //         ArifmRecord:=ArifmRecord+s;
           if GetFunCod(s,Cod,ArgNum) then begin//Функция
             if (ParamIndex<ArgsLen) then
               if Args[ParamIndex]=prVariable then begin
                 ErrorPosition:=i;
                 Raise Exception.Create('Variable expected but function found.');//Ожидалась переменная, найдена функция
               end;
              if ArgNum>80 then begin
                ErrorPosition:=i;
                Raise Exception.Create('Inadmissible identifier using.');//Недопустимое применение идентификатора
              end;
              ArifmRecord:=ArifmRecord+'#'+IntToStr(Cod);
              if ArgNum<>0 then begin
                 while TestFormula[i]=' ' do
                   inc(i);
                 if TestFormula[i]='(' then begin
                     ArifmRecord:=ArifmRecord+TestFormula[i];
                     inc(i);
                     if ArgNum>0 then begin
                         if oPlot=Cod then
                           IsCorrect(i,ArgNum,[prString,prVariable])
                         else if oZPlot=Cod then
                           IsCorrect(i,ArgNum,[prString,prVariable,prValue,prValue,prVariable])
                         else if Cod in [oH,oO,oB] then
                           IsCorrect(i,ArgNum,[prConstString])
                         else if Cod=oXBase then
                           IsCorrect(i,ArgNum,[prValue,prConstString])
                         else
                           IsCorrect(i,ArgNum,[]);
                         if ArgNum>0 then begin
                             ErrorPosition:=i;
                             Raise Exception.Create('Not enough actual parameters');//Недостаточно параметров
                         end
                     end else begin//Неопределенное число параметров
                        k:=i;
                        LenArifm:=Length(ArifmRecord);
                        IsCorrect(i,ArgNum,[]);
                        {ArifmRecord:=Copy(ArifmRecord,1,LenArifm)+
                             IntToStr(ArgNum)+';'+Copy(TestFormula,k,i-k+1);}
                        SetLength(ArifmRecord,Length(ArifmRecord)-1);
                        if ArgNum>0 then
                          ArifmRecord:=ArifmRecord+ParametrSeparator+
                              IntToStr(ArgNum)+')'
                        else begin
                          ErrorPosition:=i;
                          Raise Exception.Create('Not enough actual parameters');//Недостаточно параметров
                        end;
                     end;
                     if (i>len) then begin
                        ErrorPosition:=i;
                        Raise Exception.Create('Unexpected completion');//Неожиданное завершение
                     end else
                        inc(i);
                 end else begin
                     ErrorPosition:=i;
                     Raise Exception.Create('Not enough actual parameters');//Недостаточно параметров
                 end;
              end;
           end else begin// Переменная или константа
//todo: Проверить код константы, если нет то обработать как переменную
             GetConstantCod(s,Cod);
             if Cod>-1 then begin
               if (ParamIndex<ArgsLen) then
                 if Args[ParamIndex]=prVariable then begin
                   ErrorPosition:=i;
                   Raise Exception.Create('Variable expected but value found.');//Ожидалась переменная, найдено число
                 end;
               ArifmRecord:=ArifmRecord+GetConstantByCod(Cod);
             end else begin
               GetVariableCod(s,Cod);
               ii:=0;
               while TestFormula[i+ii]=' ' do
                 inc(ii);
               if TestFormula[i+ii]='=' then begin
                 ArifmRecord:=ArifmRecord+IntToStr(Cod);
                 SetAvailable:=true;
               end else begin
                 if (ParamIndex<ArgsLen) then begin
                   if Args[ParamIndex]=prVariable then
                     ArifmRecord:=ArifmRecord+IntToStr(Cod)
                   else
                     ArifmRecord:=ArifmRecord+'#'+IntToStr(Cod);
                 end else
                   ArifmRecord:=ArifmRecord+'#'+IntToStr(Cod);
               end;
             end;

           {   Raise Exception.Create('Неизвестный идентификатор');
               i:=k;
               k:=i-1;
               x1:=0;y1:=0;x2:=0;y2:=0;
               RS:=GetRangeSize(i,x1,y1,x2,y2);
               if RS=1 then
                 ArifmRecord:=ArifmRecord+'X'+IntToStr(x1)+'Y'+IntToStr(y1);
               if RS=2 then
                 ArifmRecord:=ArifmRecord+ParametrSeparator+'X'+IntToStr(x1)+
                            'Y'+IntToStr(y1)+'X'+IntToStr(x2)+'Y'+IntToStr(y2)
               else if RS>2 then begin
                 //ArifmRecord:=ArifmRecord+':'+'X'+IntToStr(x2)+'Y'+IntToStr(y2);
                 for m:=y1 to y2 do for l:=x1 to x2 do
                   ArifmRecord:=ArifmRecord+'X'+IntToStr(l)+'Y'+IntToStr(m)+';';
                 SetLength(ArifmRecord,Length(ArifmRecord)-1);
               end;
               if k>0 then if (RS>1) and ((TestFormula[k]<>ParametrSeparator) and
               (TestFormula[k]<>'(') or Single) then begin
                     ErrorPosition:=k;
                     Raise Exception.Create('Диапазон задан ошибочно');
               end;
               if (i=Len)and(TestFormula[i]=')') then
                      Dec(ParamCount);
               if (TestFormula[i]=ParametrSeparator) or (TestFormula[i]=')')then
                 if UnlimitedParams then
                     ParamCount:=ParamCount+RS
                 else
                     ParamCount:=ParamCount-RS;
               if (TestFormula[i]=ParametrSeparator) then begin
                  ArifmRecord:=ArifmRecord+TestFormula[i];
                  inc(i);
                  Continue;
               end else if (TestFormula[i]<>')') and (RS>1) then begin
                     ErrorPosition:=i;
                     Raise Exception.Create('Неожиданный символ');
               end;}

           end;
       end else if IsDigit(TestFormula[i]) then begin //Число
           if (ParamIndex<ArgsLen) then
             if Args[ParamIndex]=prVariable then begin
               ErrorPosition:=i;
               Raise Exception.Create('Variable expected but value found.');//Ожидалась переменная, найдено число
             end;
           s:=TranslateVal(TestFormula,i);
           ArifmRecord:=ArifmRecord+s;
       end else if (TestFormula[i]='(') then begin //Выражение
           if (ParamIndex<ArgsLen) then
             if Args[ParamIndex]=prVariable then begin
               ErrorPosition:=i;
               Raise Exception.Create('Variable expected but expression found.');//Ожидалась переменная, найдено выражение
             end;
           ArifmRecord:=ArifmRecord+TestFormula[i];
           inc(i);
           AN:=1;
           IsCorrect(i,AN,[]);
           if (AN<>0)or(i>len) then begin
                ErrorPosition:=i;
                Raise Exception.Create('Unexpected completion');//Неожиданное завершение
           end;
           //ArifmRecord:=ArifmRecord+TestFormula[i];
           inc(i);
       end else begin
           ErrorPosition:=i;
           Raise Exception.Create('Unexpected symbol');//Неожиданный символ
       end;
       while TestFormula[i]=' ' do
         inc(i);
       if (i<Len) then begin
           if (TestFormula[i]=ParametrSeparator) or (TestFormula[i]=')') then begin
               if (ParamIndex<ArgsLen) then begin
                 if Args[ParamIndex]=prString then
                   ArifmRecord:=ArifmRecord+'"'
                 else if Args[ParamIndex]=prConstString then begin
                   ArifmRecord:=ArifmRecord+TranslateConstString(i);
                   Dec(ParamCount);
                 end;
                 inc(ParamIndex);
               end;
               if UnlimitedParams then
                      ParamCount:=ParamCount+1
               else
                      ParamCount:=ParamCount-1;
               if (TestFormula[i]=ParametrSeparator) then begin
                  ArifmRecord:=ArifmRecord+TestFormula[i];
                  inc(i);
                 if (ParamIndex<ArgsLen) then begin
                   if Args[ParamIndex]=prString then
                     ArifmRecord:=ArifmRecord+''''
                   else if Args[ParamIndex]=prConstString then begin
                     ArifmRecord:=ArifmRecord+TranslateConstString(i);
                     Dec(ParamCount);
                   end;
                 end;
              end;
              continue;
           end else  if (TestFormula[i] in ['+','-','*','/','^','%','|','=','?','>','<'])or
              IsHighLetter(TestFormula[i]) then begin
              Single:=true;
              if IsHighLetter(TestFormula[i]) then
                s:=TranslateOperandId(i,TestFormula)
              else begin
                s:=TestFormula[i];
                inc(i);
              end;
              if (GetFunCod(s,Cod,ArgNum))and (SetAvailable or (s<>'=')) then
                ArifmRecord:=ArifmRecord+'@'+IntToStr(Cod)+'@'
              else begin
                ErrorPosition:=i;
                Raise Exception.Create('Unknown identifier');//Неизвестный идентификатор
              end;
              {end else begin
                s:=TestFormula[i];
                if TestFormula[i]='-' then
                  ArifmRecord:=ArifmRecord+NewMinusSymbol
                else
                  ArifmRecord:=ArifmRecord+TestFormula[i];
                inc(i);
                Continue;
              end;}
              {if TestFormula[i]='-' then
                ArifmRecord:=ArifmRecord+NewMinusSymbol
              else
                ArifmRecord:=ArifmRecord+TestFormula[i];}
              Continue;
           end;
       end;
       while TestFormula[i]=' ' do
         inc(i);
       if (i<=Len) and not(TestFormula[i]=')') then begin
           ErrorPosition:=i;
           Raise Exception.Create('Unexpected symbol');
           //Raise Exception.Create('Неожиданный символ');
       end;
       if (i=Len)and(TestFormula[i]=')') then begin
             if UnlimitedParams then
               ParamCount:=ParamCount+1
             else
               ParamCount:=ParamCount-1;
       end;
   end;
   if i<=Len then
      if TestFormula[i]=')' then
         ArifmRecord:=ArifmRecord+TestFormula[i];
end;

function TFormulaTester.Test(Formula: string): integer;
var
  i:integer;
  ParamCount:integer;
begin
   DelReturnSpace(Formula);
   if Length(Formula)=0 then begin
     PolskaRecord:='';
     result:=1;
     exit;
   end;
   Formula:=UpperCase(Formula);
   TestFormula:=Formula;
   i:=1;
   result:=0;
   ParamCount:=1;
   try
      IsCorrect(i,ParamCount,[]);
      if i<=length(Formula) then begin
          ErrorPosition:=i;
          Raise Exception.Create('Неожиданный символ');
      end;
   except
      result:=ErrorPosition;
     // ShowMessage(IntToStr(result));
      raise;
   end;
   PolskaRecord:=ConvertToPolskaRecord(ArifmRecord);
end;

function TFormulaTester.TranslateId(var i: integer; s: string): string;
begin
   result:='';
   while (s[i]>='A')and(s[i]<='Z') or (s[i]>='0')and(s[i]<='9') or
         (s[i]='_') do begin
       result:=result+s[i];
       inc(i);
   end;
end;

procedure TFormulaTester.SetErrorPosition(const Value: integer);
begin
  FErrorPosition := Value;
  ErrPosInTestEpress:= Value;
end;

function TFormulaTester.TranslateOperandId(var i: integer;
  s: string): string;
begin
   result:='';
   while (s[i]>='A')and(s[i]<='Z')do begin
       result:=result+s[i];
       inc(i);
   end;
end;

procedure TFormulaTester.GetVariableCod(s: string; var Cod: integer);
begin
  Cod:=VarBuf.GetVariableCod(s);
  if Cod=-1 then
    Cod:=VarBuf.AddVariable(s);
end;

procedure TFormulaTester.GetConstantCod(const s: string; var Cod: integer);
begin
  Cod:=ConstBuf.GetCod(s);
end;

function TFormulaTester.GetConstantByCod(const Cod: integer): string;
begin
  Result:=ConstBuf.GetConst(Cod);
end;

function TFormulaTester.TranslateConstString(var i: integer): string;
var
  Len:integer;
begin
  Result:='';
  Len:=Length(TestFormula);
  while (i<=Len) and (TestFormula[i]<>')')and (TestFormula[i]<>';') do begin
    if not (IsDigit(TestFormula[i])or ((TestFormula[i]>='A')and
      (TestFormula[i]<='Z')or (TestFormula[i]=ExpSymbol)or
      (TestFormula[i]=DecimalSeparator))) then begin
         ErrorPosition:=i;
         Raise Exception.Create('Unexpected symbol');
    end;
    Result:=Result+TestFormula[i];
    inc(i);
  end;
  Result:=''''+Result+'"';
end;

end.
