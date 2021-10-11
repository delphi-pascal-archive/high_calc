unit OptUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin, FunDefConst,CodeConst, ComCtrls,ShellApi,
  ExtCtrls;

type

{$A-}
  TFontInfo=record
    Color:TColor;
    BackColor:TColor;
    Size:Integer;
    Style:TFontStyles;
    Name:string[32];
  end;

  TFonts=array [0..2] of TFontInfo;

  TOptions=record
    EndDate:TDateTime;//Дата окончания периода испытания
    FunDefs:TFunDefs;
    FirstDate:TDateTime;//Дата первого запуска
    UseCoProcessor:boolean;
    Precision:integer;
    DecimalSeparator:Char;
    Signatura:TSignatura;
    LastDate:TDateTime;//Дата последнего запуска
    RegCod:TRegCod;
    NumLockAlwaysOn:boolean;
    UseNumLock:boolean;
    NormalView:boolean;
    ResultBase:byte;
    ResDMS:boolean;
    Fonts:TFonts;
    KeepOnTop:boolean;
    ExpSymbol:Char;
  end;
{$A+}

  TOptionsSaver=class
  private
    Options:TOptions;
    FSkinFileName: TFileName;
    FExpSymbol: Char;
    procedure SetDecimalSeparator(const Value: Char);
    procedure SetPrecision(const Value: integer);
    procedure SetUseCoProcessor(const Value: boolean);
    function GetDecimalSeparator: Char;
    function GetPrecision: integer;
    function GetUseCoProcessor: boolean;
    procedure SetRegCod(const Value: TRegCod);
    procedure SetSignatura(const Value: TSignatura);
    function GetRegCod: TRegCod;
    function GetSignatura: TSignatura;
    procedure SetNumLockAlwaysOn(const Value: boolean);
    function GetNumLockAlwaysOn: boolean;
    procedure SetUseNumLock(const Value: boolean);
    function GetUseNumLock: boolean;
    procedure SetNormalView(const Value: boolean);
    procedure SetSkinFileName(const Value: TFileName);
    function GetSkinFileName: TFileName;
    function GetNormalView: boolean;
    procedure SetResultBase(const Value: byte);
    function GetResultBase: byte;
    procedure SetResDMS(const Value: boolean);
    function GetResDMS: boolean;
    procedure SetFonts(const Value: TFonts);
    function GetFonts: TFonts;
    procedure SetKeepOnTop(const Value: boolean);
    function GetKeepOnTop: boolean;
    procedure SetExpSymbol(const Value: Char);
    function GetExpSymbol: Char;
  public
    property Signatura:TSignatura read GetSignatura write SetSignatura;
    property RegCod:TRegCod read GetRegCod write SetRegCod;
    property UseCoProcessor:boolean read GetUseCoProcessor write SetUseCoProcessor;
    property Precision:integer read GetPrecision write SetPrecision;
    property DecimalSeparator:Char read GetDecimalSeparator write SetDecimalSeparator;
    property ExpSymbol:Char read GetExpSymbol write SetExpSymbol;
    property NumLockAlwaysOn:boolean read GetNumLockAlwaysOn write SetNumLockAlwaysOn;
    property UseNumLock:boolean read GetUseNumLock write SetUseNumLock;
    property NormalView:boolean read GetNormalView write SetNormalView;
    property SkinFileName:TFileName read GetSkinFileName write SetSkinFileName;
    property ResultBase:byte read GetResultBase write SetResultBase;
    property ResDMS:boolean read GetResDMS write SetResDMS;
    property Fonts:TFonts read GetFonts write SetFonts;
    property KeepOnTop:boolean read GetKeepOnTop write SetKeepOnTop;
    function Registred:boolean;
    procedure SaveOptions(const FileName:TFileName);
    procedure LoadOptions(const FileName:TFileName);
    procedure GenerateSignatura;
    procedure InitDates;
    procedure SetDate;
  end;


  TOptionsForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PrecisionLabel: TLabel;
    Label1: TLabel;
    CoProcessorCB: TCheckBox;
    PrecisionSpinEdit: TSpinEdit;
    DecimalSeparatorEdit: TEdit;
    NumLockAlwaysOnCB: TCheckBox;
    UseNumLockCheckBox: TCheckBox;
    Label2: TLabel;
    SkinFileNameEdit: TEdit;
    Button1: TButton;
    NormalViewCheckBox: TCheckBox;
    WinCalcLabel: TLabel;
    ResultBaseLabel: TLabel;
    BaseSpinEdit: TSpinEdit;
    ResDMSCB: TCheckBox;
    TabSheet3: TTabSheet;
    ElementListBox: TListBox;
    Label3: TLabel;
    FontButton: TButton;
    Button3: TButton;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    TestFontPanel: TPanel;
    KeepOnTopCB: TCheckBox;
    Label4: TLabel;
    ExpSymbolEdit: TEdit;
    procedure CoProcessorCBClick(Sender: TObject);
    procedure PrecisionSpinEditChange(Sender: TObject);
    procedure NormalViewCheckBoxClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure WinCalcLabelClick(Sender: TObject);
    procedure ResDMSCBClick(Sender: TObject);
    procedure FontButtonClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ElementListBoxClick(Sender: TObject);
    procedure ExpSymbolEditKeyPress(Sender: TObject; var Key: Char);
  private
    Fonts:TFonts;
    procedure SetOptions(const Value: TOptionsSaver);
    procedure SetPrecEnable;
    procedure SetTestFontPanelFont(const Value: TFontInfo);
    { Private declarations }
  public
    { Public declarations }
    procedure GetOptions(const OptionsSaver:TOptionsSaver);
    property Options:TOptionsSaver write SetOptions;
    property TestFontPanelFont:TFontInfo write SetTestFontPanelFont;
  end;

var
  OptionsForm: TOptionsForm;

function ShowOptions(const Options:TOptionsSaver):boolean;
implementation
uses
  GrumbUnit,DecodeUnit, main;
{$R *.dfm}
function ShowOptions(const Options:TOptionsSaver):boolean;
begin
  OptionsForm:=TOptionsForm.Create(nil);
  try
    OptionsForm.Options:=Options;
    OptionsForm.SkinFileNameEdit.Text:=Options.SkinFileName;
    Result:=OptionsForm.ShowModal=mrOk;
    if Result then begin
      OptionsForm.GetOptions(Options);
    end;
  finally
    OptionsForm.Free;
  end;
end;

procedure TOptionsForm.CoProcessorCBClick(Sender: TObject);
begin
  SetPrecEnable;
end;

procedure TOptionsForm.GetOptions(const OptionsSaver:TOptionsSaver);
begin
  OptionsSaver.UseCoProcessor:=CoProcessorCB.Checked;
  OptionsSaver.UseNumLock:=UseNumLockCheckBox.Checked;
  OptionsSaver.NumLockAlwaysOn:=NumLockAlwaysOnCB.Checked;
  OptionsSaver.Precision:=PrecisionSpinEdit.Value;
  OptionsSaver.NormalView:=NormalViewCheckBox.Checked;
  OptionsSaver.SkinFileName:=SkinFileNameEdit.Text;
  OptionsSaver.ResultBase:=BaseSpinEdit.Value;
  OptionsSaver.ResDMS:=ResDMSCB.Checked;
  OptionsSaver.Fonts:=Fonts;
  OptionsSaver.KeepOnTop:=KeepOnTopCB.Checked;
  if Length(DecimalSeparatorEdit.Text)<>1 then
    Raise Exception.Create('Decimal separator error.'+#13+#10+
      'One symbol required.');
  OptionsSaver.DecimalSeparator:=DecimalSeparatorEdit.Text[1];
  if Length(OptionsSaver.ExpSymbol)<>1 then
    Raise Exception.Create('Exponent symbol error.'+#13+#10+
      'One symbol required.');
  OptionsSaver.ExpSymbol:=ExpSymbolEdit.Text[1];
end;

procedure TOptionsForm.PrecisionSpinEditChange(Sender: TObject);
begin
  if PrecisionSpinEdit.Value<0 then
    PrecisionSpinEdit.Value:=0;

end;

procedure TOptionsForm.SetOptions(const Value: TOptionsSaver);
begin
  CoProcessorCB.Checked:=Value.UseCoProcessor;
  PrecisionSpinEdit.Value:=Value.Precision;
  DecimalSeparatorEdit.Text:=Value.DecimalSeparator;
  UseNumLockCheckBox.Checked:=Value.UseNumLock;
  NumLockAlwaysOnCB.Checked:=Value.GetNumLockAlwaysOn;
  NormalViewCheckBox.Checked:=Value.NormalView;
  BaseSpinEdit.Value:=Value.ResultBase;
  ResDMSCB.Checked:=Value.ResDMS;
  KeepOnTopCB.Checked:=Value.KeepOnTop;
  Fonts:=Value.Fonts;
  SetPrecEnable;
  ExpSymbolEdit.Text:=Value.ExpSymbol;
end;

procedure TOptionsForm.SetPrecEnable;
begin
  PrecisionLabel.Enabled:=not CoProcessorCB.Checked;
  PrecisionSpinEdit.Enabled:=not CoProcessorCB.Checked;
end;

{ TOptionsSaver }

procedure TOptionsSaver.GenerateSignatura;
var
  Buf:TRegCod;
  i:integer;
begin
  InitSignatura;
  StrToArr('7CT25SPT35SPDE13',Buf[0]);
  for i:=0 to 15 do
    Buf[i]:=Buf[i] xor CodeConst.Signatura[i];
  CodeConst.RegCod:=Buf;
  Options.RegCod:=CodeConst.RegCod;
  Options.Signatura:=CodeConst.Signatura;
end;

function TOptionsSaver.GetDecimalSeparator: Char;
begin
  Result:=Options.DecimalSeparator;
end;

function TOptionsSaver.GetExpSymbol: Char;
begin
  Result:=Options.ExpSymbol;
end;

function TOptionsSaver.GetFonts: TFonts;
begin
  Result:=Options.Fonts;
end;

function TOptionsSaver.GetKeepOnTop: boolean;
begin
  Result:=Options.KeepOnTop;
end;

function TOptionsSaver.GetNormalView: boolean;
begin
  Result:=Options.NormalView;
end;

function TOptionsSaver.GetNumLockAlwaysOn: boolean;
begin
  Result:=Options.NumLockAlwaysOn;
end;

function TOptionsSaver.GetPrecision: integer;
begin
  Result:=Options.Precision;
end;

function TOptionsSaver.GetRegCod: TRegCod;
begin
  result:=Options.RegCod;
end;

function TOptionsSaver.GetResDMS: boolean;
begin
  Result:=Options.ResDMS;
end;

function TOptionsSaver.GetResultBase: byte;
begin
  Result:=Options.ResultBase;
end;

function TOptionsSaver.GetSignatura: TSignatura;
begin
  result:=Options.Signatura;
end;

function TOptionsSaver.GetSkinFileName: TFileName;
begin
  Result:=FSkinFileName;
end;

function TOptionsSaver.GetUseCoProcessor: boolean;
begin
   Result:=Options.UseCoProcessor;
end;

function TOptionsSaver.GetUseNumLock: boolean;
begin
  Result:=Options.UseNumLock;
end;

procedure TOptionsSaver.InitDates;
begin
{$ifndef BettaVersion}
  if Options.EndDate=0 then begin
    Options.FirstDate:=StrToDateTime(GetDate);
    Options.EndDate:=Options.FirstDate+30;
    Options.LastDate:=StrToDateTime(GetDate);
    Options.DecimalSeparator:=SysUtils.DecimalSeparator;
  end;
{$EndIF}  
end;

procedure TOptionsSaver.LoadOptions(const FileName: TFileName);
var
  FileStream:TFileStream;
  n:integer;
  s:integer;
begin

  if not FileExists(FileName) then begin
    GenerateSignatura;
    InitDates;
{    Options.FirstDate:=StrToDateTime(GetDate);
    Options.EndDate:=Options.FirstDate+30;
    Options.LastDate:=Options.FirstDate;  }
    exit;
  end;

  FileStream:=TFileStream.Create(FileName,fmOpenRead);
  try
    s:=FileStream.Size;
    FileStream.Read(Options,SizeOf(TOptions));
    CodeConst.RegCod:=Options.RegCod;
    CodeConst.Signatura:=Options.Signatura;
    InitDates;
    if Options.LastDate<StrToDateTime(GetDate) then
      Options.LastDate:=StrToDateTime(GetDate);
    FileStream.Read(n,SizeOf(Integer));
    SetLength(FSkinFileName,n);
    if n>0 then
      FileStream.Read(FSkinFileName[1],n);
  finally
    FileStream.Free;
  end;

end;

function TOptionsSaver.Registred: boolean;
begin
  Result:=Options.Signatura[0] xor Options.RegCod[0]>0;
end;

procedure TOptionsSaver.SaveOptions(const FileName: TFileName);
var
  FileStream:TFileStream;
  n:integer;
begin
  FileStream:=TFileStream.Create(FileName,fmCreate);
  try
    FileStream.Write(Options,SizeOf(TOptions));
    n:=Length(FSkinFileName);
    FileStream.Write(n,SizeOf(Integer));
    if n>0 then
      FileStream.Write(FSkinFileName[1],n);
  finally
    FileStream.Free;
  end;
end;

procedure TOptionsSaver.SetDate;
var
  d1,d2:TDateTime;
  d:string;
begin
  d1 := StrToDateTime (GetDate);
  d := DateTimeToStr(Options.EndDate);
  RunButtonVisible := (Options.EndDate>=d1)and
    (Options.EndDate >= Options.LastDate)and(d1>= Options.LastDate);
end;

procedure TOptionsSaver.SetDecimalSeparator(const Value: Char);
begin
  Options.DecimalSeparator := Value;
end;

procedure TOptionsSaver.SetExpSymbol(const Value: Char);
begin
  Options.ExpSymbol:=Value;
end;

procedure TOptionsSaver.SetFonts(const Value: TFonts);
begin
  Options.Fonts := Value;
end;

procedure TOptionsSaver.SetKeepOnTop(const Value: boolean);
begin
  Options.KeepOnTop := Value;
end;

procedure TOptionsSaver.SetNormalView(const Value: boolean);
begin
  Options.NormalView := Value;
end;

procedure TOptionsSaver.SetNumLockAlwaysOn(const Value: boolean);
begin
  Options.NumLockAlwaysOn := Value;
end;

procedure TOptionsSaver.SetPrecision(const Value: integer);
begin
  Options.Precision := Value;
end;

procedure TOptionsSaver.SetRegCod(const Value: TRegCod);
begin
  Options.RegCod := Value;
end;

procedure TOptionsSaver.SetResDMS(const Value: boolean);
begin
  Options.ResDMS:=Value;
end;

procedure TOptionsSaver.SetResultBase(const Value: byte);
begin
  Options.ResultBase := Value;
end;

procedure TOptionsSaver.SetSignatura(const Value: TSignatura);
begin
  Options.Signatura := Value;
end;

procedure TOptionsSaver.SetSkinFileName(const Value: TFileName);
begin
  FSkinFileName := Value;
end;

procedure TOptionsSaver.SetUseCoProcessor(const Value: boolean);
begin
  Options.UseCoProcessor := Value;
end;

procedure TOptionsSaver.SetUseNumLock(const Value: boolean);
begin
  Options.UseNumLock := Value;
end;

procedure TOptionsForm.NormalViewCheckBoxClick(Sender: TObject);
begin
  Label2.Visible:=not NormalViewCheckBox.Checked;
  SkinFileNameEdit.Visible:=not NormalViewCheckBox.Checked;
  Button1.Visible:=not NormalViewCheckBox.Checked;
end;

procedure TOptionsForm.Button1Click(Sender: TObject);
begin
  MainCalcForm.OpenDialog1.InitialDir:=ExtractFilePath(Application.ExeName)+'Skins';
  if MainCalcForm.OpenDialog1.Execute then
    SkinFileNameEdit.Text:=MainCalcForm.OpenDialog1.FileName;
end;

procedure TOptionsForm.WinCalcLabelClick(Sender: TObject);
begin
  ShellExecute(handle,'open','http://www.HighCalc.narod.ru',nil,nil,SW_SHOW);
end;

procedure TOptionsForm.ResDMSCBClick(Sender: TObject);
begin
  BaseSpinEdit.Enabled:=not ResDMSCB.Checked;
  ResultBaseLabel.Enabled:=BaseSpinEdit.Enabled;
end;

procedure TOptionsForm.FontButtonClick(Sender: TObject);
var
  i:integer;
begin
  i:=ElementListBox.ItemIndex;
  if i>-1 then begin
    with FontDialog1.Font do begin
      Size:=Fonts[i].Size;
      Color:=Fonts[i].Color;
      Style:=Fonts[i].Style;
      Name:=Fonts[i].Name;
    end;
    if FontDialog1.Execute then with FontDialog1.Font do begin
      Fonts[i].Size:=Size;
      Fonts[i].Color:=Color;
      Fonts[i].Style:=Style;
      Fonts[i].Name:=Name;
      TestFontPanelFont:=Fonts[i];
    end;
  end;
end;

procedure TOptionsForm.SetTestFontPanelFont(const Value: TFontInfo);
begin
  With TestFontPanel,Value do begin
    Font.Size:=Size;
    Font.Color:=Color;
    Font.Style:=Style;
    Font.Name:=Name;
  end;
  TestFontPanel.Color:=Value.BackColor;
end;

procedure TOptionsForm.Button3Click(Sender: TObject);
var
  i:integer;
begin
  i:=ElementListBox.ItemIndex;
  if i>-1 then begin
    ColorDialog1.Color:=Fonts[i].BackColor;
    if ColorDialog1.Execute then begin
      Fonts[i].BackColor:=ColorDialog1.Color;
      TestFontPanelFont:=Fonts[i];
    end;
  end;
end;

procedure TOptionsForm.ElementListBoxClick(Sender: TObject);
begin
  TestFontPanelFont:=Fonts[ElementListBox.ItemIndex];
end;

procedure TOptionsForm.ExpSymbolEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  ExpSymbolEdit.Text:=UpperCase(Key)[1];
  Key:=#0;
end;

end.
