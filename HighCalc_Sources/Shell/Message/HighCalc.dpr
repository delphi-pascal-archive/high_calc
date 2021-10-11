program HighCalc;

uses
  Windows,
  Forms,
  Dialogs,
  SysUtils,
  main in 'main.pas' {MainCalcForm},
  CaptUnt in '..\..\common\CaptUnt.pas',
  ExeUnit in '..\..\common\ExeUnit.pas',
  ExprBuf in '..\..\common\ExprBuf.pas',
  CoreClass in '..\..\Core\CoreClass.pas',
  FunDefConst in '..\..\Core\FunDefConst.pas',
  QHlpFunc in 'QHlpFunc.pas' {HelpFuncForm},
  SystemVer in '..\..\common\SystemVer.pas',
  QHlpThrd in 'QHlpThrd.pas',
  QHlpClUn in '..\..\common\QHlpClUn.pas',
  OptUnit in '..\Options\OptUnit.pas' {OptionsForm},
  VarUnit in '..\..\common\VarUnit.pas',
  VarShowUnit in '..\..\common\VarShowUnit.pas' {VarShowForm},
  mathimge in '..\..\3D\MATHIMGE.PAS',
  PlotUn in '..\..\common\PlotUn.pas' {PlotForm},
  SetVarUn in '..\..\common\SetVarUn.pas' {SetVar},
  ConfirmUn in '..\..\common\ConfirmUn.pas' {ConfirmForm},
  RegUnit in '..\..\common\RegUnit.pas' {RegForm},
  AllMessages in 'AllMessages.pas',
  GrumbUnit in '..\..\common\GrumbUnit.pas' {GrumblingForm},
  AboutUnit in 'AboutUnit.pas' {AboutForm},
  MainSetup in '..\..\Install\MainSetup.pas' {MainForm},
  FunLib in '..\..\Core\FunLib.pas',
  SkinMath in '..\..\common\SkinMath.pas',
  MandlbrUn in '..\..\common\MandlbrUn.pas' {MandelbrForm},
  AngConv in 'AngConv.pas',
  CodeConst in '..\..\CodGenerator\CodeConst.pas';

{$R *.RES}
var
  H: HWND;
  FileName:TFileName;
function GetRestDays:integer;
var
  i,n:integer;
  a:string;
begin
  Result:=-1;
  n:=Length(FirstDateSignatura);
  for i:=1 to n do
    a:=a + char((byte(FirstDateSignatura[i])xor byte(FirstDateSignaturaCode[i])));
  try
    result:=30-Round(StrToDateTime(GetDate)-StrToDateTime(Trim(a)));
  except
//    exit;
  end;
  if Result>30 then
    Result:=-1;
end;


begin
  FileName:=UpperCase(ExtractFileName(Application.ExeName));
  if FileName='SETUP.EXE' then begin
    Application.Initialize;
    Application.CreateForm(TMainForm, MainForm);
  Application.Run;
  end else begin
    firstRun:=true;
  //  H := FindWindow('TForm1', MainFormCaption);
      ErrorReg:=false;
      H := FindWindow('TMainCalcForm', MainFormCaption);
      if H=0 then begin
        Application.Initialize;
        Application.CreateForm(TMainCalcForm, MainCalcForm);
        if CloseMainForm then begin
          MainCalcForm.Free;
          exit;
        end;

  {      if Options.KeepOnTop then
          MainCalcForm.FormStyle:=fsStayOnTop
        else
          MainCalcForm.FormStyle:=fsNormal;}

        Application.CreateForm(THelpFuncForm, HelpFuncForm);
        Application.CreateForm(TAboutForm, AboutForm);
        Application.Run;
      end else
        SendMessage(H, wm_ShowCalc_Event, 0, 0);
  end;
end.
