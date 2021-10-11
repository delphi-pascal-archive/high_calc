program SkinEditor;

uses
  Forms,
  SkinMain in 'SkinMain.pas' {MainForm},
  Skintypes in '..\Skintypes.pas',
  ShpPropDlg in 'ShpPropDlg.pas' {ShapeDlgForm},
  CalcForm in 'CalcForm.pas' {CalcMainForm},
  ButCodes in '..\..\common\ButCodes.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TShapeDlgForm, ShapeDlgForm);
  Application.CreateForm(TCalcMainForm, CalcMainForm);
  Application.Run;
end.
