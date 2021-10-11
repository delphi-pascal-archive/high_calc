unit QHlpThrd;

interface
uses
  Classes;
type
  TQuickHelpThread=class(TThread)
    procedure Execute;override;
  end;
procedure RefreshQHlpThread(s:string;WrdBegin,WrdEnd:integer);
var
  QuickHelpThread:TQuickHelpThread;
implementation
uses
  QHlpFunc,Main;
var
  wrd: string;
  WordBegin,WordEnd:integer;
procedure RefreshQHlpThread(s:string;WrdBegin,WrdEnd:integer);
begin
  QuickHelpThread.Suspend;
  try
    wrd:=s;
    WordBegin:=WrdBegin;
    WordEnd:=WrdEnd;
  finally
    QuickHelpThread.Resume;
  end;
end;
{ TQuickHelpThread }

procedure TQuickHelpThread.Execute;
var
  PrevWrd: string;
  PrevWordBegin,PrevWordEnd:integer;
begin
  inherited;
  while true do begin
    if (PrevWrd<>Wrd)or(PrevWordBegin<>WordBegin)or
    (PrevWordEnd<>WordEnd) then begin
      PrevWrd:=Wrd;
      PrevWordBegin:=WordBegin;
      PrevWordEnd:=WordEnd;
      HelpFuncForm.Enabled:=false;
      try
        HelpFuncForm.Refresh;
        HelpFuncForm.SetWord(PrevWrd,PrevWordBegin,PrevWordEnd);
        //HelpFuncForm.Show;
        HelpFuncForm.Top:=MainCalcForm.Top+MainCalcForm.ExpressionMemo.Top+
          MainCalcForm.ExpressionMemo.Height;
        HelpFuncForm.Left:=MainCalcForm.Left+MainCalcForm.ExpressionMemo.Left;
        MainCalcForm.BringToFront;
      finally
        HelpFuncForm.Enabled:=true;
      end;
    end;
  end;
end;

end.
