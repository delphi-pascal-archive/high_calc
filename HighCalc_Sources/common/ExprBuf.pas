unit ExprBuf;

interface
uses
  Classes,StdCtrls;
type
  TStringListBuffer=array of TStringList;
  TExpressionBuffer=class
  private
    StringListBuffer:TStringListBuffer;
    ExpressionIndex:integer;
  public
    Procedure AddExpression (Memo : TMemo);
    Procedure GetExpression (Memo : TMemo);
    Procedure Up;
    Procedure Down;
    Function GetExpressionIndex:integer;
    constructor Create;
    destructor Destroy;override;
  end;

implementation

{ TExpressionBuffer }

procedure TExpressionBuffer.AddExpression(Memo: TMemo);
var
  n:integer;
begin
  n:=Length(StringListBuffer);
  SetLength(StringListBuffer,n+1);
  if (n-ExpressionIndex>1) then
    Move(StringListBuffer[ExpressionIndex+1],StringListBuffer[ExpressionIndex+2],
      (n-ExpressionIndex-1)*SizeOf(TStringList));
  inc(ExpressionIndex);
  StringListBuffer[ExpressionIndex]:=TStringList.Create;
  StringListBuffer[ExpressionIndex].AddStrings(Memo.Lines);
end;

constructor TExpressionBuffer.Create;
begin
  inherited;
  ExpressionIndex:=-1;
end;

destructor TExpressionBuffer.Destroy;
var
  i,n:integer;
begin
  inherited;
  n:=Length(StringListBuffer)-1;
  for i:=0 to n do
    StringListBuffer[i].Free;
end;

procedure TExpressionBuffer.Down;
begin
  Inc(ExpressionIndex);
  if ExpressionIndex>=Length(StringListBuffer) then begin
    if Length(StringListBuffer)>0 then
      ExpressionIndex:=0
    else
      ExpressionIndex:=-1;
  end;
end;

procedure TExpressionBuffer.GetExpression(Memo: TMemo);
begin
  if ExpressionIndex>=0 then begin
    Memo.Lines.Clear;
    Memo.Lines.AddStrings(StringListBuffer[ExpressionIndex]);
  end;
end;

function TExpressionBuffer.GetExpressionIndex: integer;
begin
  Result:=ExpressionIndex;
end;

procedure TExpressionBuffer.Up;
begin
  Dec(ExpressionIndex);
  if ExpressionIndex<0 then
    ExpressionIndex:=Length(StringListBuffer)-1;
end;

end.
