unit QHlpFunc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,FunDefConst,Sort;

type
  TFuncIndex=record
    Id:string;
    Index:integer;
  end;
  PFuncIndex=^TFuncIndex;
  TFuncIndexs=array of TFuncIndex;
  THelpFuncForm = class(TForm)
    FuncListBox: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FuncListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FuncListBoxDblClick(Sender: TObject);
  private
    { Private declarations }
    FuncIndexs:TFuncIndexs;
    WordBegin:integer;
    WordEnd:integer;
    procedure SortFuncIndexs;
    procedure ReturnFunc;
  public
    { Public declarations }
    procedure InitFuncIndexs;
    procedure SetWord(const Wrd:string;WordBegin,WordEnd:integer);
    procedure Activate;
  end;

var
  HelpFuncForm: THelpFuncForm;

implementation

uses main;

{$R *.DFM}

{ THelpFuncForm }

procedure THelpFuncForm.InitFuncIndexs;
var
  i,j,n:integer;
begin
  n:=Length(FunDefs);
  SetLength(FuncIndexs,n);
  j:=0;
  for i:=Low(FunDefs) to High(FunDefs) do begin
    FuncIndexs[j].Id:=FunDefs[i].FunId;
    FuncIndexs[j].Index:=i;
    inc(j);
  end;
  SortFuncIndexs;
end;

function CompareFuncIndexs(P1,P2:Pointer):boolean;
begin
  result:=PFuncIndex(P1).Id>PFuncIndex(P2).Id;
end;

procedure THelpFuncForm.SortFuncIndexs;
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

procedure THelpFuncForm.FormCreate(Sender: TObject);
begin
  InitFuncIndexs;
end;

procedure THelpFuncForm.SetWord(const wrd: string; WordBegin,WordEnd:integer);
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
    p:=pos(w,FuncIndexs[i].Id);
//    Application.ProcessMessages;
    if p=1 then begin
      k:=i;
      while p=1 do begin
        FuncListBox.Items.AddObject(FuncIndexs[k].Id,@FuncIndexs[k]);
        inc(k);
        p:=pos(w,FuncIndexs[k].Id);
      end;
//      Hide;
      if FuncListBox.Items.Count > 1 then begin
    //    Height:=FuncListBox.Items.Count*FuncListBox.ItemHeight;
        Show;
      end else begin
        if FuncListBox.Items.Count<1 then
          Hide
        else if FuncListBox.Items[0]=w then
          Hide
        else begin
    //      Height:=FuncListBox.Items.Count*FuncListBox.ItemHeight;
          Show;
        end;
      end;
      SetActiveWindow(MainCalcForm.Handle);
      exit;
    end;
  end;
  Hide;
  //Close;
end;

procedure THelpFuncForm.FormShow(Sender: TObject);
begin
  MainCalcForm.FormStyle:=fsNormal;
end;

procedure THelpFuncForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  MainCalcForm.FormStyle:=fsStayOnTop;
end;

procedure THelpFuncForm.Activate;
begin
  if Visible then
    BringToFront;
   SetActiveWindow(MainCalcForm.Handle);  
end;

procedure THelpFuncForm.FormActivate(Sender: TObject);
begin
  FuncListBox.ItemIndex:=0;
end;

procedure THelpFuncForm.FuncListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s:string;
begin
  if Key=VK_ESCAPE then begin
    s:=MainCalcForm.ExpressionMemo.Text;
    Hide;
    MainCalcForm.ExpressionMemo.Text:=s;
  end else if Key=VK_RETURN then begin
    ReturnFunc;
  end;
end;

procedure THelpFuncForm.FuncListBoxDblClick(Sender: TObject);
begin
  ReturnFunc;
end;

procedure THelpFuncForm.ReturnFunc;
begin
  MainCalcForm.ChangeWordInExpressionMemo(FuncListBox.Items[FuncListBox.ItemIndex],
    WordBegin,WordEnd);
  Close;
end;

end.
