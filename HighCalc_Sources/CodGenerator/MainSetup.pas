unit MainSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,{ZipMcpt,} Registry, ShlObj, ComObj,
  ActiveX, CodeConst,VarUnit, FileCtrl;
const
//  ArchivName='Calc.mth';
  ArchivName='Calc.zip';
  CalcName='High precision calculator';
  UninatallName='DelHighCalc.bat';
  NameofKey='fsdas645';
  ValueForKey='456564khhj';

//Защита  
{  TempName='467764.654456.sdffsd.com';
  SysName='5645699.654564.dll';
  AppReg='App4566455564jkjkk';}

  TempName='467764.654456.sdffsd.com1';
  SysName='5645699.654564.dll1';
  AppReg='App4566455564jkjkk1';


type
  TGetDate=function : string;
  TMainForm = class(TForm)
    PrevButton: TButton;
    NextButton: TButton;
    InfoLabel: TLabel;
    LicenseMemo: TMemo;
    FolderEdit: TEdit;
    FolderButton: TButton;
    DeskTopCheckBox: TCheckBox;
    StartUpCheckBox: TCheckBox;
    LicenseAgreeRadioGroup: TRadioGroup;
    LicenseLabel: TLabel;
    InstLabel: TLabel;
    CopyProgressBar: TProgressBar;
    CopyLabel: TLabel;
    LanchMathCalc: TCheckBox;
    NumLockAlwaysOnCB: TCheckBox;
    UseNumLockCheckBox: TCheckBox;
    UseCoProcCB: TCheckBox;
    Cancel: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure PrevButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure LicenseAgreeRadioGroupClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure FolderButtonClick(Sender: TObject);
  private
    { Private declarations }
    ScreenIndex:integer;
    DelFile:System.Text;
    OptionsFileName:TFileName;
//    procedure MiniZip1Progress(Sender: TObject; ProgrType: PrgsType;
//      Filename: String; uncompressed_size: Integer);
  public
    { Public declarations }
    function DestFolder:string;
    procedure SetAllInvisible;
    procedure SetVisible;
    procedure CopyFiles;
//    procedure UnzipTo(const Folder:string);
    procedure CreateLinks;
    procedure SetFirstDateSignatura;
    function PathObj:TFileName;
    procedure AddToDel(FileName:TFileName);
    procedure AddToDelDir(FileName:TFileName);
    procedure SetProtectRegKey;
    procedure SetProtectTempFile;
    procedure SetProtectSystemDir;
    function TestProtectRegKey:boolean;
    function TestProtectTempFile:boolean;
    function TestProtectSystemDir:boolean;
    procedure SetOptions;
  end;

var
  MainForm: TMainForm;
  GD:TGetDate;
procedure CreateDirectory(DirName: string);
procedure CreateLink(const PathObj, PathLink, Desc, Param: string);
function GetDeskTopFolder:string;
function GetProgramFileFolder:string;
function GetStartUpFolder:string;
function  GetTempDir: String;
implementation
uses
  OptUnit;
{$R *.dfm}

function  GetTempDir: String;
var
  Res: String[255];
  L:integer;
begin
  L:=GetTempPath(255,@Res[1]);
  SetLength(Res,L);
  Result:=Res;
end;

function GetDateNew:string;
begin
//  result:='21.08.2000 19:09:40';
    result:='wer=456+dsaf*$654E0';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  GD:=GetDate;
  FolderEdit.Text:=GetProgramFileFolder+CalcName+'\';
  ScreenIndex:=1;
  SetVisible;
end;

procedure TMainForm.PrevButtonClick(Sender: TObject);
begin
  Dec(ScreenIndex);
  if ScreenIndex<1 then
    ScreenIndex:=1;
  SetVisible;
end;

procedure TMainForm.NextButtonClick(Sender: TObject);
var
  PathObj:string;
begin
  Inc(ScreenIndex);
  PathObj :=DestFolder+'HighCalc.exe';
  if ScreenIndex>4 then begin
    SetRegestryFocus;
    if LanchMathCalc.Checked then
      WinExec(PChar(PathObj), SW_SHOW);
    Close;
  end;
  SetVisible;
end;

procedure TMainForm.SetAllInvisible;
begin
  PrevButton.Visible:=false;
//  NextButton.Visible:=false;
  InfoLabel.Visible:=false;
  LicenseMemo.Visible:=false;
  FolderEdit.Visible:=false;
  FolderButton.Visible:=false;
  DeskTopCheckBox.Visible:=false;
  StartUpCheckBox.Visible:=false;
  LicenseAgreeRadioGroup.Visible:=false;
  LicenseLabel.Visible:=false;
  InstLabel.Visible:=false;
  CopyLabel.Visible:=false;
  CopyProgressBar.Visible:=false;
  LanchMathCalc.Visible:=false;
  UseNumLockCheckBox.Visible:=false;
  NumLockAlwaysOnCB.Visible:=false;
  UseCoProcCB.Visible:=false;
  NextButton.Enabled:=true;
end;

procedure TMainForm.SetVisible;
begin
  SetAllInvisible;
  if (ScreenIndex>1) and(ScreenIndex<5)then
    PrevButton.Visible:=true;
  if ScreenIndex>5 then
    NextButton.Caption:='Finish'
  else
    NextButton.Caption:='Next  >>';
  if ScreenIndex=1 then
    InfoLabel.Visible:=true
  else if ScreenIndex=2 then begin
    LicenseMemo.Visible:=true;
    LicenseAgreeRadioGroup.Visible:=true;
    TestProtectRegKey;
    NextButton.Enabled:=False;
    LicenseLabel.Visible:=True;
  end else  if ScreenIndex=3 then begin
    FolderEdit.Visible:=True;
    FolderButton.Visible:=True;
    DeskTopCheckBox.Visible:=True;
    TestProtectTempFile;
    StartUpCheckBox.Visible:=True;
    InstLabel.Visible:=True;
    UseNumLockCheckBox.Visible:=True;
    NumLockAlwaysOnCB.Visible:=True;
    UseCoProcCB.Visible:=True;
  end else  if ScreenIndex=4 then begin
    CopyLabel.Visible:=True;
    CopyProgressBar.Visible:=True;
    NextButton.Visible:=false;
    TestProtectSystemDir;
    PrevButton.Visible:=false;
    NextButton.Caption:='Finish';
    Refresh;
    Application.ProcessMessages;
    CopyFiles;
    CreateLinks;
    SetFirstDateSignatura;
    LanchMathCalc.Visible:=True;
    NextButton.Visible:=True;
    AddToDelDir(DestFolder);
    AddToDel(GetTempDir+'DelDir.exe');
    AddToDel(GetStartUpFolder+'\'+UninatallName);
    CloseFile(DelFile);
    SetOptions;
  end;
end;

procedure TMainForm.LicenseAgreeRadioGroupClick(Sender: TObject);
begin
  if LicenseAgreeRadioGroup.ItemIndex=0 then
    NextButton.Enabled:=true
  else
    NextButton.Enabled:=False;
end;

procedure TMainForm.CopyFiles;
var
  SourceFolder:string;
  bFailIfExists: BOOL;
begin
  CreateDirectory(DestFolder);
  CreateDirectory(DestFolder+'Skins\');
  AssignFile(DelFile,DestFolder+UninatallName);
  ReWrite(DelFile);
  bFailIfExists:=false;
  SourceFolder:=ExtractFilePath(Application.ExeName);
  CopyProgressBar.Position:=25;
  DeleteFile(PChar(DestFolder+'HighCalc.exe'));
  CopyFile(PChar(SourceFolder+'Setup.exe'),PChar(DestFolder+'HighCalc.exe'),bFailIfExists);
  AddToDel(DestFolder+'HighCalc.exe');
  CopyProgressBar.Position:=50;
  DeleteFile(PChar(DestFolder+'Calc.chm'));
  CopyFile(PChar(SourceFolder+'Calc.chm'),PChar(DestFolder+'Calc.chm'),bFailIfExists);
  AddToDel(DestFolder+'Calc.chm');
  CopyProgressBar.Position:=75;
  DeleteFile(PChar(DestFolder+'Calc.Opt'));
  CopyFile(PChar(SourceFolder+'Calc.Op'),PChar(DestFolder+'Calc.Opt'),bFailIfExists);
  OptionsFileName:=DestFolder+'Calc.Opt';
  AddToDel(DestFolder+'Calc.Opt');
  CopyProgressBar.Position:=90;
  DeleteFile(PChar(DestFolder+'SendKey.dll'));
  CopyFile(PChar(SourceFolder+'SendKey.dll'),PChar(DestFolder+'SendKey.dll'),bFailIfExists);
  AddToDel(DestFolder+'SendKey.dll');
  DeleteFile(PChar(DestFolder+ConstFileName));
  CopyFile(PChar(SourceFolder+ConstFileName),PChar(DestFolder+ConstFileName),bFailIfExists);
  AddToDel(DestFolder+ConstFileName);
  CopyProgressBar.Position:=100;
//  UnzipTo(DestFolder);
end;


{procedure TMainForm.MiniZip1Progress(Sender: TObject; ProgrType: PrgsType;
  Filename: String; uncompressed_size: Integer);
begin
  if  ProgrType=ptUnzip then
     CopyProgressBar.Position:=CopyProgressBar.Position+uncompressed_size;
end;
}

{procedure TMainForm.UnzipTo(const Folder: string);
var
  MiniZip: TMiniZip;
begin
  MiniZip:=TMiniZip.Create(nil);
  try
    MiniZip.UnZipfile:=ArchivName;
    CopyProgressBar.Max:=MiniZip.UnzAllUnComprSize;
    CopyProgressBar.Position:= 0;
    MiniZip.OnProgress:=MiniZip1Progress;
    MiniZip.UnzipAllTo(Folder);
  finally
    MiniZip.Free;
  end;
end;}

function TMainForm.DestFolder: string;
begin
  Result:=FolderEdit.Text;
end;

procedure CreateDirectory(DirName: string);
var
  dn,dn1:string;
  Index:integer;
begin
  DirName:=Trim(DirName);
  if DirectoryExists(DirName) then
    exit;
//  ShowMessage('Папка '+DirName+' отсутствует и будет создана.');
  Index:=Length(DirName);
  if Index=0 then
    exit;
  if DirName[Index]<>'\'then
    DirName:=DirName+'\';
  dn1:=DirName;
  dn:='';
  repeat
    Index:=Pos('\',dn1);
    if Index=0 then exit;
    dn:=dn+Copy(dn1,1,Index);
    dn1:=Copy(dn1,Index+1,Length(dn1));
    if (not DirectoryExists(dn)) and (dn<>'') then
      if not CreateDir(dn) then
        raise Exception.Create('Create folder error. '+DirName);
  until false;
end;


//Создание ярлыка

//uses ShlObj, ComObj, ActiveX;
procedure CreateLink(const PathObj, PathLink, Desc, Param: string);
  var    IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;
begin
  IObject := CreateComObject(CLSID_ShellLink);
  SLink := IObject as IShellLink;
  PFile := IObject as IPersistFile;
  with SLink do begin
    SetArguments(PChar(Param));
    SetDescription(PChar(Desc));
    SetPath(PChar(PathObj));
  end;
  PFile.Save(PWChar(WideString(PathLink)), FALSE);
end;


{
//Для выяснения даты последнего изменения файла можно воспользоваться следующей функцией:

function GetFileDate(FileName: string): string;
var
  FHandle: Integer;
begin
  FHandle := FileOpen(FileName, 0);
  try
    Result := DateTimeToStr(FileDateToDateTime(FileGetDate(FHandle)));
  finally
    FileClose(FHandle);
  end;
end;
}


{
См пример. Примечание: не все файловые системы поддерживают время последнего доступа к файлу.
Пример:

procedure TForm1.Button1Click(Sender: TObject);
var
  SearchRec : TSearchRec;
  Success : integer;
  DT : TFileTime;
  ST : TSystemTime;
begin
  Success := SysUtils.FindFirst('C:\autoexec.bat', faAnyFile, SearchRec);
  if (Success = 0) and ((SearchRec.FindData.ftLastAccessTime.dwLowDateTime <> 0) or
    ( SearchRec.FindData.ftLastAccessTime.dwHighDateTime <> 0)))) then  begin
      FileTimeToLocalFileTime(SearchRec.FindData.ftLastAccessTime,DT);
      FileTimeToSystemTime(DT,ST);
      Memo1.Lines.Clear;
      Memo1.Lines.Add('AutoExec.Bat was last accessed at:');
      Memo1.Lines.Add('Year := ' + IntToStr(st.wYear));
      Memo1.Lines.Add('Month := ' + IntToStr(st.wMonth));
      Memo1.Lines.Add('DayOfWeek := ' + IntToStr(st.wDayOfWeek));
      Memo1.Lines.Add('Day := ' + IntToStr(st.wDay));
      Memo1.Lines.Add('Hour := ' + IntToStr(st.wHour));
      Memo1.Lines.Add('Minute := ' + IntToStr(st.wMinute));
      Memo1.Lines.Add('Second := ' + IntToStr(st.wSecond));
      Memo1.Lines.Add('Milliseconds := ' + IntToStr(st.wMilliseconds));
  end;
  SysUtils.FindClose(SearchRec);
end;
}


function GetWinFolder:string;
var
  lpBuffer: PChar;
  uSize: UINT;
begin
  uSize:=200;
  GetMem(lpBuffer,uSize);
  GetWindowsDirectory(lpBuffer,uSize);
  Result:=lpBuffer+'\';
end;

function GetProgramFileFolder:string;
var
  Drive :string;
begin
  Drive:=ExtractFileDrive(GetWinFolder);
  Result:=Drive+'\Program Files\';
end;

function GetDeskTopFolder:string;
var
  Registry : TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKey_Current_User;
    Registry.OpenKey('Software\Microsoft\Windows\'+  'CurrentVersion\Explorer\Shell Folders', False);
    Result := Registry.ReadString('Desktop');
//    FolderName := Registry.ReadString('StartUp');
    {Cache, Cookies, Desktop, Favorites,     Fonts, Personal, Programs, SendTo, Start Menu, Startp}
  finally
    Registry.Free;
  end;
end;

function GetStartUpFolder:string;
var
  Registry : TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKey_Current_User;
    Registry.OpenKey('Software\Microsoft\Windows\'+  'CurrentVersion\Explorer\Shell Folders', False);
    Result := Registry.ReadString('StartUp');
  finally
    Registry.Free;
  end;
end;

function GetProgramsFolder:string;
var
  Registry : TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKey_Current_User;
    Registry.OpenKey('Software\Microsoft\Windows\'+'CurrentVersion\Explorer\Shell Folders', False);
    Result := Registry.ReadString('Programs');
//    FolderName := Registry.ReadString('StartUp');
    {Cache, Cookies, Desktop, Favorites,     Fonts, Personal, Programs, SendTo, Start Menu, Startp}
  finally
    Registry.Free;
  end;
end;

procedure TMainForm.CreateLinks;
var
  PathObj, PathLink, Desc, Param: string;
begin
  PathObj:=Self.PathObj;
  Desc := CalcName;
  if DeskTopCheckBox.Checked then begin
    PathLink :=GetDeskTopFolder+'\HPCalc.lnk';
    CreateLink(PathObj, PathLink, Desc, Param);
    AddToDel(PathLink);
  end;
  if StartUpCheckBox.Checked then begin
    PathLink :=GetStartUpFolder+'\HPCalc.lnk';
    Param:='h';
    CreateLink(PathObj, PathLink, Desc, Param);
    Param:='';
    //AddToDel(PathLink);
  end;
  CreateDirectory(GetProgramsFolder+'\'+CalcName);
  PathLink :=GetProgramsFolder+'\'+CalcName+'\HPCalc.lnk';
  CreateLink(PathObj, PathLink, Desc, Param);
  AddToDel(PathLink);

  PathLink :=GetProgramsFolder+'\'+CalcName+'\Uninstall.lnk';
  Param:='del';
  CreateLink(PathObj, PathLink, Desc, Param);
  Param:='';
  AddToDel(PathLink);

  PathLink :=GetProgramsFolder+'\'+CalcName+'\Help.lnk';
  PathObj :=DestFolder+'Calc.chm';
  Desc := CalcName+' Help';
  CreateLink(PathObj, PathLink, Desc, Param);
  AddToDel(PathLink);

  AddToDelDir(GetProgramsFolder+'\'+CalcName);
end;

procedure TMainForm.SetFirstDateSignatura;
var
  i,n,j,m,Pos:integer;
  FileStream:TFileStream;
  Buf:array of char;
  r:boolean;
  DateString:string;
begin
  r:=false;
  m:=Length(FirstDateSignatura)-1;
  FileStream:=TFileStream.Create(PathObj,fmOpenReadWrite);
  try
    n:=FileStream.Size;
    SetLength(Buf,n);
    FileStream.Position:=0;
    FileStream.Read(Buf[0],n);
    dec(n);
    Pos:=System.Pos(string(FirstDateSignatura),string(Buf));
//    n:=FileStream.Size-1;
    for i:=0 to n do begin
      if Buf[i]=FirstDateSignatura[1] then begin
        r:=true;
        for j:=1 to m do
          if Buf[i+j]<>FirstDateSignatura[j+1] then begin
            r:=false;
            break;
          end;
        if r then begin
          Pos:=i;
          break;
        end;
      end;
    end;
    if not r then
      Raise Exception.Create('Error code #564456645');
    DateString:=GD;
    n:=Length(DateString);
    FillChar(Buf[Pos],m+1,' ');
    Move(DateString[1],Buf[Pos],n);
    for j:=0 to m do
      Buf[j+Pos]:=Char(byte(Buf[j+Pos]) xor byte(FirstDateSignaturaCode[j+1]));
    FileStream.Position:=0;
    n:=FileStream.Size;
    FileStream.Write(Buf[0],n);
  finally
    FileStream.Free;
  end;
end;

function TMainForm.PathObj: TFileName;
begin
  Result:=DestFolder+'HighCalc.exe';
end;


procedure TMainForm.AddToDel(FileName: TFileName);
var
  F:TFileName;
begin
  SetLength(F,Length(FileName));
  CharToOem(PChar(FileName),PChar(F));
  WriteLn(DelFile,'Del "'+ F+'" /Q');
end;

procedure TMainForm.AddToDelDir(FileName: TFileName);
var
  F:TFileName;
begin
  SetLength(F,Length(FileName));
  CharToOem(PChar(FileName),PChar(F));
  WriteLn(DelFile,GetTempDir+'DelDir.exe d "'+F+'"');
end;

procedure TMainForm.SetProtectRegKey;
var
  Reg: TRegIniFile;
begin
//  Reg:=TRegIniFile.Create('App456645564jkjkk');
  Reg:=TRegIniFile.Create(AppReg);
  try
    Reg.RootKey:=HKEY_CURRENT_USER; // Section to look for within the registry
    Reg.OpenKey(NameofKey,True);
    Reg.WriteString('Main Section','Value1',ValueForKey);
  finally
    Reg.Free;
  end;
end;

procedure TMainForm.SetProtectSystemDir;
var
  FileStream:TFileStream;
  FileName:TFileName;
begin
  FileName:=GetWinFolder+SysName;
  FileStream:=TFileStream.Create(FileName,fmCreate);
  try
    FileStream.Write('asdf',4);
  finally
    FileStream.Free;
  end;
end;

procedure TMainForm.SetProtectTempFile;
var
  FileStream:TFileStream;
  FileName:TFileName;
begin
  FileName:=GetTempDir+TempName;
  FileStream:=TFileStream.Create(FileName,fmCreate);
  try
    FileStream.Write('asdf.dll',4);
  finally
    FileStream.Free;
  end;
end;

function TMainForm.TestProtectRegKey: boolean;
var
  Reg: TRegIniFile;
begin
//  Reg:=TRegIniFile.Create('App456645564jkjkk');
    Reg:=TRegIniFile.Create(AppReg);
  try
    Reg.RootKey:=HKey_Local_Machine; // Section to look for within the registry
    result:=Reg.OpenKey(NameofKey,false);
  finally
    Reg.Free;
  end;
  if not Result then
    SetProtectRegKey
  else
    GD:=GetDateNew;
end;

function TMainForm.TestProtectSystemDir: boolean;
begin
  Result:=FileExists(GetWinFolder+SysName);
  if not Result then
    SetProtectSystemDir
  else
    GD:=GetDateNew;
end;

function TMainForm.TestProtectTempFile: boolean;
begin
  Result:=FileExists(GetTempDir+TempName);
  if not Result then
    SetProtectTempFile
  else
    GD:=GetDateNew;
end;

procedure TMainForm.SetOptions;
var
  OptionsSaver:TOptionsSaver;
begin
  OptionsSaver:=TOptionsSaver.Create;
  try
    OptionsSaver.LoadOptions(OptionsFileName);
    OptionsSaver.NumLockAlwaysOn:=NumLockAlwaysOnCB.Checked;
    OptionsSaver.UseNumLock:=UseNumLockCheckBox.Checked;
    OptionsSaver.UseCoProcessor:=UseCoProcCB.Checked;
    OptionsSaver.DecimalSeparator:=DecimalSeparator;
    OptionsSaver.SaveOptions(OptionsFileName);
  finally
//    OptionsSaver.Free;
  end;
end;

procedure TMainForm.CancelClick(Sender: TObject);
begin
  if MessageDlg('The programm installation is not complete. Exit now?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    Close;
end;

function NormalizeDir(const Dir:string):string;
begin
  Result:=Dir;
  if Length(Dir)=0 then begin
    Result:='\';
    exit;
  end;
  if Dir[Length(Dir)]<>'\' then
    Result:=Dir+'\';
end;

procedure TMainForm.FolderButtonClick(Sender: TObject);
var
  Dir:string;
begin
  Dir:=FolderEdit.Text;
  if SelectDirectory(Dir,[sdAllowCreate],0) then
    FolderEdit.Text:=NormalizeDir(Dir);
end;

end.
