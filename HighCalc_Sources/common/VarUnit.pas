unit VarUnit;

interface
uses
  SysUtils,ComCtrls, OpString;
const
  MinVariableCod=1000;
  ConstFileName='const.txt';
type
  TFuncDesc=record
    Id:integer;//Код
    GroupId:integer;//Код группы
    FunId:string;//Название функции
    ArgNum:SmallInt;//Число аргументов
    NeedBrackets:boolean;//Использовать скобки
    FunDesc:string;//Описание функции
    HighPrec:boolean;//Наличее высокоточной реализации
    MathCoProc:boolean;//Наличее реализации с сопроцессором
    Syntax:string;
    HtmlHelp:string;//Имя Html файла
  end;

  PFuncDesc=^TFuncDesc;

  TGroupRec=record
    Id:integer;//Код
    GroupName:string;
    Node:TTreeNode;
    HtmlHelp:string;//Имя Html файла
  end;

  PGroupRec=^TGroupRec;

  TConstant=record
    Id:integer;//Код группы
    Cod:integer;
    Name:string;
    Value:string;
  end;

  PConstant=^TConstant;

  TConstants=array of TConstant;

  TVariable=class
//    VarId:string;
  public
    FD:TFuncDesc;
    Value:string;
    IsNull:boolean;
    Node: TTreeNode;
    destructor Destroy;override;
    constructor Create(const Tree:TTreeView;const RootNode: TTreeNode;const VarName:string);overload;
    constructor Create();overload;
    procedure RefreshNodeText;
  end;

//  PVariable=^TVariable;

  TVariables=array of TVariable;
  TRefreshVarShowForm=procedure;

  TVarBuf=class
    private
      Buf:TVariables;
      Tree: TTreeView;
      RootNode: TTreeNode;
      RefreshVarShowForm:TRefreshVarShowForm;
      procedure AddVarToTree(const Index:integer);
      procedure TestVariableExistance(const VarName: string;const VarCod:integer);
    public
      function GetVariableCod(const VarName: string): integer;
      function GetVariable(const VarCod:integer): TVariable;
      function AddVariable(const VarName: string): integer;
      function GetVariables:TVariables;
      procedure SetVariableValue(const VarCod:integer;const Value: string);
      procedure SetVariableName(const VarCod:integer;const Name: string);
      function GetVariableValue(const VarCod: integer): string;
      procedure DeleteVariable(const VarCod: integer);
      procedure LoadFromFile(const FileName:TFileName);
      procedure SaveToFile(const FileName:TFileName);
      procedure Clear;
      procedure LoadVariablesToTree(const Tree:TTreeView;const RootNode:TTreeNode);
      constructor Create(RefreshVarShowForm:TRefreshVarShowForm);
  end;

  TConstBuf=class
    private
      Buf:TConstants;
      TreeView:TTreeView;
      RootNode: TTreeNode;
    public
      procedure LoadFromFile(const FileName:TFileName);
      function GetConst(const Cod:integer):string;
      function GetCod(const Name:string):integer;
      procedure SetTree(const TreeView:TTreeView;const RootNode: TTreeNode);
      procedure LoadToTree;
      procedure ChangeDecSep(var s:string;const ds:char);
      procedure ChangeDecSepAll(const ds:char);
  end;

var
  VarBuf:TVarBuf;
  ConstBuf:TConstBuf;
implementation
uses
  VarShowUnit;
{ TVarBuf }

function TVarBuf.AddVariable(const VarName: string): integer;
var
  n:integer;
  P:pointer;
begin
  TestVariableExistance(VarName,-1);
  n:=Length(Buf);
  SetLength(Buf,n+1);
  Buf[n]:=TVariable.Create(Tree,RootNode,VarName);
//  Buf[n].FD.FunId:=VarName;
  result:=n+MinVariableCod;
//  AddVarToTree(n);
  RefreshVarShowForm;
end;

procedure TVarBuf.AddVarToTree(const Index: integer);
begin
  with Tree.Items,Buf[Index] do begin
    Node:=AddChild(RootNode,FD.FunId);
    Node.Data:=@FD;
  end;
end;

procedure TVarBuf.Clear;
begin
  Buf:=nil;
end;

constructor TVarBuf.Create(RefreshVarShowForm: TRefreshVarShowForm);
begin
  Self.RefreshVarShowForm:=RefreshVarShowForm;
end;

procedure TVarBuf.DeleteVariable(const VarCod: integer);
var
  n,i,k:integer;
begin
  n:=Length(Buf);
  i:=VarCod-MinVariableCod;
//  Buf[i].Node.Delete;
  Buf[i].Free;
  Move(Buf[i+1],Buf[i],SizeOf(TVariable)*(n-i-1));
{  if n-i-1>0 then
//    Move(Buf[i+1],Buf[i],SizeOf(TVariable)*(n-i-1));
    for k:=i to n-2 do
      Buf[k]:=Buf[k+1];}
  if n>0 then
    SetLength(Buf,n-1);
end;

function TVarBuf.GetVariable(const VarCod: integer): TVariable;
var
  i:integer;
begin
  i:=VarCod-MinVariableCod;
  if (i<Length(Buf))and(i>=0) then
    Result:=Buf[i]
  else
    Raise Exception.Create('Variable not found');
end;

function TVarBuf.GetVariableCod(const VarName: string): integer;
var
  i,n:integer;
begin
  result:=-1;
  n:=Length(Buf)-1;
  for i:=0 to n do
    if VarName=Buf[i].FD.FunId then begin
      Result:=i+MinVariableCod;
      exit;
    end;
end;

function TVarBuf.GetVariables: TVariables;
begin
  Result:=Buf;
end;

function TVarBuf.GetVariableValue(const VarCod: integer): string;
var
  i:integer;
begin
  i:=VarCod-MinVariableCod;
  if i<Length(Buf) then
    Result:=Buf[i].Value
  else
    Raise Exception.Create('Variable not found');
  if Result='' then
    Raise Exception.Create('Undefined variable '+Buf[i].FD.FunId);
end;

procedure TVarBuf.LoadFromFile(const FileName: TFileName);
begin

end;

procedure TVarBuf.LoadVariablesToTree(const Tree: TTreeView;
  const RootNode: TTreeNode);
var
  i:integer;
begin
  Self.Tree:=Tree;
  Self.RootNode:=RootNode;
  RootNode.DeleteChildren;
  for i:=Low(Buf) to High(Buf) do
    AddVarToTree(i);
end;

procedure TVarBuf.SaveToFile(const FileName: TFileName);
begin

end;

procedure TVarBuf.SetVariableName(const VarCod: integer;
  const Name: string);
var
  i:integer;
begin
  TestVariableExistance(Name,VarCod);
  i:=VarCod-MinVariableCod;
  if i<Length(Buf) then begin
    Buf[i].FD.FunId:=UpperCase(Name);
    Buf[i].Node.Text:=UpperCase(Name);
  end else
    Raise Exception.Create('Variable not found');
end;

procedure TVarBuf.SetVariableValue(const VarCod:integer;const Value: string);
var
  i:integer;
begin
  i:=VarCod-MinVariableCod;
  if i<Length(Buf) then
    Buf[i].Value:=Value
  else
    Raise Exception.Create('Variable not found');
  RefreshVarShowForm;
end;

procedure TVarBuf.TestVariableExistance(const VarName: string;const VarCod:integer);
var
  Cod:integer;
begin
  exit;
  Cod:=GetVariableCod(VarName);
  if (Cod<>-1)and(Cod<>VarCod) then
    Raise Exception.Create('Variable '+VarName+' already exists');
end;

{ TVariable }

constructor TVariable.Create(const Tree:TTreeView;const RootNode: TTreeNode;
  const VarName:string);
var
  s:string;
begin
  s:=RootNode.Text;
  Self.FD.FunId:=VarName;
  with Tree.Items do begin
    Node:=AddChild(RootNode,FD.FunId);
    Node.Data:=@FD;
  end;
end;

constructor TVariable.Create;
begin
  Inherited;
end;

destructor TVariable.Destroy;
begin
  if Node<>nil then
    Node.Delete;
end;

procedure TVariable.RefreshNodeText;
begin
  if Node<>nil then
    Node.Text:=FD.FunId;
end;

{ TConstBuf }

procedure TConstBuf.ChangeDecSep(var s: string;const ds:char);
var
  n,i:integer;
begin
  n:=Length(s);
  for i:=1 to n do
    if (s[i]<'0') or (s[i]>'9') then begin
      s[i]:=ds;
      exit;
    end;
end;

procedure TConstBuf.ChangeDecSepAll(const ds: char);
var
  i,n:integer;
begin
  n:=Length(Buf)-1;
  for i:=0 to n do
    ChangeDecSep(Buf[i].Value,ds);
end;

function TConstBuf.GetCod(const Name: string): integer;
var
  i,n:integer;
  Name1:string;
begin
  Name1:=UpperCase(Name);
  n:=Length(Buf)-1;
  for i:=0 to n do
    if Buf[i].Name=Name then begin
      Result:=i;
      exit;
    end;
  Result:=-1;
end;

function TConstBuf.GetConst(const Cod: integer): string;
begin
  Result:=Buf[Cod].Value;
end;

procedure TConstBuf.LoadFromFile(const FileName: TFileName);
var
  f:System.Text;
  s:string;
  n,i:integer;
  ds:char;
begin
  ds:=DecimalSeparator;
  DecimalSeparator:='.';
  try
    AssignFile(f,FileName);
    Reset(f);
    try
      Readln(f,s);
      n:=StrToInt(Trim(s));
      SetLength(Buf,n);
      dec(n);
      for i:=0 to n do begin
        ReadLn(f,s);
        Buf[i].Name:=UpperCase(ExtractWord(1,s,[' ']));
        Buf[i].Value:=ExtractWord(2,s,[' ']);
        ChangeDecSep(Buf[i].Value,ds);
        Buf[i].Id:=3;
        Buf[i].Cod:=i;
      end;
    finally
      CloseFile(f);
    end;
  finally
    DecimalSeparator:=ds;
  end;
end;

procedure TConstBuf.LoadToTree;
var
  n,i:integer;
begin
  n:=Length(Buf)-1;
  for i:=0 to n do
    TreeView.Items.AddChildObject(RootNode,Buf[i].Name,@Buf[i]);
end;

procedure TConstBuf.SetTree(const TreeView: TTreeView;
  const RootNode: TTreeNode);
begin
  Self.TreeView:=TreeView;
  Self.RootNode:=RootNode;
end;

end.


