unit SetVarUn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,VarUnit;

type
  TSetVar = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    VarNameEdit: TEdit;
    VarValueEdit: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure VarNameEditKeyPress(Sender: TObject; var Key: Char);
  private
    procedure SetVariable(const Value: TVariable);
    procedure GetVariable(var Variable:TVariable);
    { Private declarations }
  public
    { Public declarations }
    property Variable:TVariable write SetVariable;
  end;

function NewVariable(var Variable:TVariable):boolean;
function SetVariable(var Variable:TVariable;const EditVarName:boolean):boolean;

implementation

{$R *.dfm}

{ TSetVar }

procedure TSetVar.GetVariable(var Variable:TVariable);
begin
  Variable.FD.FunId := VarNameEdit.Text;
  Variable.Value := VarValueEdit.Text;
  Variable.RefreshNodeText;
end;

procedure TSetVar.SetVariable(const Value: TVariable);
begin
  VarNameEdit.Text := Value.FD.FunId;
  VarValueEdit.Text:= Value.Value;
end;

function NewVariable(var Variable:TVariable):boolean;
begin
  Variable.FD.FunId:='';
  Variable.Value:='';
  result:=SetVariable(Variable,true);
end;

function SetVariable(var Variable:TVariable;const EditVarName:boolean):boolean;
var
  SetVar: TSetVar;
begin
  SetVar:= TSetVar.Create(nil);
  try
    if not EditVarName then begin
      SetVar.VarNameEdit.ReadOnly:=true;
      SetVar.VarNameEdit.TabOrder:=1;
    end;
    SetVar.Variable:=Variable;
    Result:=SetVar.ShowModal=mrOk;
    if Result then begin
      SetVar.GetVariable(Variable);
      if Variable.FD.FunId='' then
        Raise Exception.Create('Variable name is empty');
      if Variable.Value='' then
        Raise Exception.Create('Variable value is empty');
    end;
  finally
    SetVar.Free;
  end;
end;


procedure TSetVar.VarNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  Key:=UpCase(Key);
  if (Key>='0')and(Key<='9') and (Length(Trim((Sender as TEdit).Text))=0) then
    Key:=#0;
end;

end.
