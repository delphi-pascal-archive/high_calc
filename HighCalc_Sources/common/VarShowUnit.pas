unit VarShowUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, VarUnit, StdCtrls,HtmlHlp;

type
  TVarShowForm = class(TForm)
    VariablesStringGrid: TStringGrid;
    NewButton: TButton;
    DelButton: TButton;
    SaveButton: TButton;
    LoadButton: TButton;
    ChangeValButton: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure VariablesStringGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure VariablesStringGridSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure VariablesStringGridKeyPress(Sender: TObject; var Key: Char);
    procedure DelButtonClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure ChangeValButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SaveButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
//    VarBuf: TVarBuf;
    SelectedVarCod:integer;
    ARow:integer;
  public
    { Public declarations }
    procedure InitVariablesStringGrid;
    procedure SetVarBuf(const VarBuf:TVarBuf);
  end;

var
  VarShowForm: TVarShowForm;
procedure RefreshVarShowForm;
implementation
uses
  SetVarUn,Main;
{$R *.dfm}

{ TVarShowForm }

procedure TVarShowForm.InitVariablesStringGrid;
begin
  VariablesStringGrid.Cells[0,0]:='Name';
  VariablesStringGrid.Cells[1,0]:='Value';
end;

procedure TVarShowForm.FormCreate(Sender: TObject);
begin
  InitVariablesStringGrid;
  KeyPreview:=true;
end;


procedure TVarShowForm.SetVarBuf(const VarBuf: TVarBuf);
var
  i,n:integer;
  Buf:TVariables;
begin
  SelectedVarCod:=-1;
  Self.ARow:=-1;
//  Self.VarBuf:=VarBuf;
  Buf:=VarBuf.GetVariables;
  n:=Length(Buf)-1;
  if n<0 then begin
    VariablesStringGrid.RowCount:=2;
    VariablesStringGrid.Cells[0,1]:='';
    VariablesStringGrid.Cells[1,1]:='';
    exit;
  end;
  VariablesStringGrid.RowCount:=n+2;
  for i:=0 to n do begin
    VariablesStringGrid.Cells[0,i+1]:=Buf[i].FD.FunId;
    VariablesStringGrid.Cells[1,i+1]:=Buf[i].Value;
  end;
  SelectedVarCod:=MinVariableCod;
//  Self.ARow:=1;
  Self.ARow:=VariablesStringGrid.Row;
end;

procedure TVarShowForm.FormResize(Sender: TObject);
begin
  VariablesStringGrid.ColWidths[1]:=VariablesStringGrid.Width-
    VariablesStringGrid.ColWidths[0]-5;
end;

procedure TVarShowForm.VariablesStringGridSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: String);
begin
  if SelectedVarCod<MinVariableCod then begin
    if ACol=0 then begin
      SelectedVarCod:=VarBuf.AddVariable(VariablesStringGrid.Cells[0,ARow]);
      VarBuf.SetVariableValue(SelectedVarCod,VariablesStringGrid.Cells[1,ARow]);
    end;
    exit;
  end;
  if ACol=0 then begin
    VarBuf.SetVariableName(SelectedVarCod,VariablesStringGrid.Cells[0,ARow]);
  end else if ACol=1 then begin
    VarBuf.SetVariableValue(SelectedVarCod,VariablesStringGrid.Cells[1,ARow]);
  end;
end;

procedure TVarShowForm.VariablesStringGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  SelectedVarCod:=VarBuf.GetVariableCod(VariablesStringGrid.Cells[0,ARow]);
  Self.ARow:=ARow;
end;

procedure TVarShowForm.VariablesStringGridKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key:=UpperCase(Key)[1];
end;

procedure TVarShowForm.DelButtonClick(Sender: TObject);
begin
  if ARow<0 then
    exit;
  SelectedVarCod:=VarBuf.GetVariableCod(VariablesStringGrid.Cells[0,ARow]);
  if SelectedVarCod>=MinVariableCod then begin
    VarBuf.DeleteVariable(SelectedVarCod);
    SetVarBuf(VarBuf);
  end;
end;

procedure TVarShowForm.NewButtonClick(Sender: TObject);
var
  Variable:TVariable;
  VarCod:integer;
begin
  Variable:=TVariable.Create;
  try
    if NewVariable(Variable) then begin
      VarCod:=VarBuf.GetVariableCod(Variable.FD.FunId);
      if VarCod>=MinVariableCod  then begin
        if MessageDlg('Variable '+Variable.FD.FunId+
          ' already exists. Change this value?', mtWarning,
          [mbYes, mbCancel], 0) = mrYes then begin
          VarBuf.SetVariableValue(VarCod,Variable.Value);
          SetVarBuf(VarBuf);
        end else begin
        end;
      end else begin
        SelectedVarCod:=VarBuf.AddVariable(Variable.FD.FunId);
        VarBuf.SetVariableValue(SelectedVarCod,Variable.Value);
        SetVarBuf(VarBuf);
      end;
           //todo:Проверить наличие переменной и добавть если необходимо сменить имя
    end;
  finally
    Variable.Free;
  end;
//  VariablesStringGrid.RowCount:=VariablesStringGrid.RowCount+1;
end;

procedure TVarShowForm.ChangeValButtonClick(Sender: TObject);
var
  Variable:TVariable;
  VarCod:integer;
begin
  if ARow<0 then
    exit;
  VarCod:=VarBuf.GetVariableCod(VariablesStringGrid.Cells[0,ARow]);
  if VarCod<MinVariableCod then
    exit;
  Variable:=VarBuf.GetVariable(VarCod);
//  Variable.FD.FunId:=VariablesStringGrid.Cells[0,ARow];
//  Variable.Value:=VariablesStringGrid.Cells[1,ARow];
  if SetVariable(Variable,false) then begin
    VarCod:=VarBuf.GetVariableCod(Variable.FD.FunId);
    if VarCod>=MinVariableCod  then begin
        VarBuf.SetVariableValue(VarCod,Variable.Value);
        SetVarBuf(VarBuf);
    end else begin
      SelectedVarCod:=VarBuf.AddVariable(Variable.FD.FunId);
      VarBuf.SetVariableValue(SelectedVarCod,Variable.Value);
      SetVarBuf(VarBuf);
    end;
  end;
end;

procedure TVarShowForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
  VarShowForm:=nil;
end;

procedure TVarShowForm.SaveButtonClick(Sender: TObject);
var
  i,n:integer;
  F:System.Text;
begin
  if SaveDialog1.Execute then begin
    AssignFile(f,SaveDialog1.FileName);
    Rewrite(f);
    try
      n:=VariablesStringGrid.RowCount-1;
      if (n=1)and(VariablesStringGrid.Cells[0,1]='') then
        n:=-1;
      with VariablesStringGrid do
        for i:=1 to n do
          Writeln (f,Cells[0,i],'=',Cells[1,i]);
    finally
      CloseFile(f);
    end;
  end;
end;

procedure TVarShowForm.LoadButtonClick(Sender: TObject);
var
  F:System.Text;
  VarCod:integer;
//  Variable:TVariable;
  VarName,VarValue:string;
  EqPos:integer;
  s:string;
begin
  if OpenDialog1.Execute then begin
    AssignFile(f,OpenDialog1.FileName);
    Reset(f);
    try
      VarBuf.Clear;
      while not eof(f) do begin
        Readln(f,s);
        EqPos:=Pos('=',s);
        if EqPos<1 then
          Raise Exception.Create('Error in '+OpenDialog1.FileName+' file');
        VarName:=Copy(s,1,EqPos-1);
        VarValue:=Copy(s,EqPos+1,Length(s));
        VarCod:=VarBuf.AddVariable(VarName);
        VarBuf.SetVariableValue(VarCod,VarValue);
      end;
      SetVarBuf(VarBuf);
    finally
      CloseFile(f);
    end;
  end;
end;

procedure RefreshVarShowForm;
begin
  if VarShowForm<>nil then
    VarShowForm.SetVarBuf(VarBuf);
end;

procedure ShowHelp;
var
  URL: string;
begin
  URL := CompiledHelpFile + '::/' + 'Viewing_variables.htm';
  HtmlHelp(0, PChar(URL), HH_DISPLAY_TOC, 0);
end;


procedure TVarShowForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_F1 then begin
    ShowHelp;
    Key:=0;
    BringToFront;
  end;
end;

end.

