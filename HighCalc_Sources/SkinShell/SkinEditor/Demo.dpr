program Demo;

uses
  Forms,
  CalcForm in 'CalcForm.pas' {CalcMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCalcMainForm, CalcMainForm);
  CalcMainForm.LoadSkin('proj.bsk');
  Application.Run;
end.
