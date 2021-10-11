unit QHlpClUn;

interface
uses
  StdCtrls,SysUtils,Sort,FunDefConst,VarUnit;
type
  TChangeWordInExpressionMemo=procedure(Item:string;WordBegin,WordEnd:integer);
  TFuncIndex=record
//    Id:string;
    Index:integer;
    FD:PFuncDesc;
  end;

  PFuncIndex=^TFuncIndex;

  TFuncIndexs=array of TFuncIndex;

  TQuickHelp=class
  private
    { Private declarations }
    FuncIndexs:TFuncIndexs;
    WordBegin:integer;
    WordEnd:integer;
    FuncListBox: TListBox;
    HelpEdit: TEdit;
    ChangeWordInExpressionMemo:TChangeWordInExpressionMemo;
    procedure SortFuncIndexs;
    procedure Show;
  public
    procedure Hide;
    procedure ReturnFunc;
    procedure InitFuncIndexs;
    procedure SetWord(const Wrd:string;WordBegin,WordEnd:integer;CoProc:boolean);
    function GetHelpString:string;
    constructor Create(FuncListBox: TListBox;HelpEdit: TEdit;SetWord:TChangeWordInExpressionMemo);
  end;
implementation

{ TQuickHelp }

constructor TQuickHelp.Create(FuncListBox: TListBox;HelpEdit: TEdit;SetWord:TChangeWordInExpressionMemo);
begin
  Self.FuncListBox:=FuncListBox;
  Self.HelpEdit:=HelpEdit;
  ChangeWordInExpressionMemo:=SetWord;
  InitFuncIndexs;
end;

function TQuickHelp.GetHelpString: string;
var
  FD:PFuncIndex;
begin
  FD:=PFuncIndex(FuncListBox.Items.Objects[FuncListBox.ItemIndex]);
  Result:=Fd.FD.FunDesc;
  HelpEdit.Text:=Result;
end;

procedure TQuickHelp.Hide;
begin
  FuncListBox.Visible:=False;
  HelpEdit.Text:='Press F1 for help.';
end;

procedure TQuickHelp.InitFuncIndexs;
var
  i,j,n:integer;
begin
  n:=Length(FunDefs);
  SetLength(FuncIndexs,n);
  j:=0;
  for i:=Low(FunDefs) to High(FunDefs) do begin
//    FuncIndexs[j].Id:=FunDefs[i].FunId;
    FuncIndexs[j].FD:=@FunDefs[i];
    FuncIndexs[j].Index:=i;
    inc(j);
  end;
  SortFuncIndexs;
end;

procedure TQuickHelp.ReturnFunc;
var
  FD:PFuncIndex;
  s:string;
begin
  FD:=PFuncIndex(FuncListBox.Items.Objects[FuncListBox.ItemIndex]);
  s:=Fd.FD.FunId;
  if Fd.FD.NeedBrackets then
    s:=s+'()'
  else
    s:=' '+s+' ';  
  ChangeWordInExpressionMemo(s,WordBegin,WordEnd);
  Hide;
end;

procedure TQuickHelp.SetWord(const Wrd: string; WordBegin,
  WordEnd: integer;CoProc:boolean);
var
  p:integer;
  i,k,n:integer;
  w:string;
begin
  Self.WordBegin:=WordBegin;
  Self.WordEnd:=WordEnd;
  w:=UpperCase(wrd);
  FuncListBox.Items.Clear;
  n:=Length(FuncIndexs)-1;
  for i:=0 to n do begin
    p:=pos(w,FuncIndexs[i].Fd.FunId);
    if p=1 then begin
      k:=i;
      while (p=1) do begin
        if ((FuncIndexs[k].Fd.MathCoProc and CoProc)or
          (FuncIndexs[k].Fd.HighPrec and (not CoProc)))  then
          FuncListBox.Items.AddObject(FuncIndexs[k].Fd.FunId,@FuncIndexs[k]);
        inc(k);
        p:=pos(w,FuncIndexs[k].Fd.FunId);
      end;
      if FuncListBox.Items.Count > 1 then begin
        Show;
      end else begin
        if FuncListBox.Items.Count<1 then
          Hide
        else if FuncListBox.Items[0]=w then
          Hide
        else begin
          Show;
        end;
      end;
      exit;
    end;
  end;
  Hide;
end;

procedure TQuickHelp.Show;
begin
  FuncListBox.Visible:=True;
//  FuncListBox.ItemIndex:=0;
//  GetHelpString;
end;

function CompareFuncIndexs(P1,P2:Pointer):boolean;
begin
  result:=PFuncIndex(P1).Fd.FunId>PFuncIndex(P2).Fd.FunId;
end;

procedure TQuickHelp.SortFuncIndexs;
var
  n,i:integer;
  a:TPointerArray;
  t:TFuncIndexs;
begin
  n:=Length(FuncIndexs);
  SetLength(a,n);
  SetLength(t,n);
  dec(n);
  for i:=0 to n do
    a[i]:=@FuncIndexs[i];
  QSort(a,CompareFuncIndexs);
  for i:=0 to n do
    t[i]:=PFuncIndex(a[i])^;
  FuncIndexs:=t;
end;

end.
