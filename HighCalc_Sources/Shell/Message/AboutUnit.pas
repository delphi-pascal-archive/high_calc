unit AboutUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ShellApi;
const
  HiperLinkWinCalc='http://www.HighCalc.narod.ru';
type
  TAboutForm = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;
procedure ShowAbout;
implementation

{$R *.dfm}
procedure ShowAbout;
begin
  AboutForm:=TAboutForm.Create(nil);
  try
    AboutForm.ShowModal;
  finally
    AboutForm.Free;
  end;
end;

procedure TAboutForm.Label2Click(Sender: TObject);
begin
  ShellExecute(handle,'open',HiperLinkWinCalc,nil,nil,SW_SHOW);
end;

end.
