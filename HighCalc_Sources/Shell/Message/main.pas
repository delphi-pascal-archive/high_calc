unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXShell, Menus, ComCtrls, ExtCtrls, ToolWin, ImgList, Buttons,
  CaptUnt,VclUtils,ExeUnit,ExprBuf,SystemVer,QHlpClUn,VarUnit,GrumbUnit,
  OptUnit,AboutUnit,Registry,Skintypes,grMath,ButCodes,SkinMath,Math;
const
  HookHandle: hHook = 0;
//  ChangeNumLock:boolean=false;
  v:boolean=false;
  TimerCounter:integer=100;
  Gold=1.618;
  Gold1=0.618;
  ControlsCount=22;
  TreeFileName:TFileName='abc.tree';
  OptionsFileName:TFileName='Calc.Opt';
  CompiledHelpFileName = 'calc.chm';
  CloseMainForm:boolean=false;
type
  TControlSize=record
    Left,Top,Width,Height:integer;
    FontSize:integer;
    Control:TControl;
  end;
  WParameter=Longword;
  TKey_Hook = function : Longint;stdcall;
{  TStringListBuffer=array of TStringList;
  TExpressionBuffer=class
  private
    StringListBuffer:TStringListBuffer;
    ExpressionIndex:integer;
  public
    Procedure AddExpression (Memo : TMemo);
    Procedure GetExpression (Memo : TMemo);
    Procedure Up;
    Procedure Down;
    constructor Create;
    destructor Destroy;override;
  end;}
  TMainCalcForm = class(TForm)
    RxTrayIcon1: TRxTrayIcon;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    ExpressionMemo: TMemo;
    FuncsTreeView: TTreeView;
    MainMenu1: TMainMenu;
    File_N2: TMenuItem;
    View_N3: TMenuItem;
    Options_N4: TMenuItem;
    Edit_N5: TMenuItem;
    Help_N6: TMenuItem;
    ButtonPanel1: TPanel;
    ResultMemo: TMemo;
    SystemInputPopupMenuPopupMenu: TPopupMenu;
    MainPopupMenu: TPopupMenu;
    Hex1: TMenuItem;
    Dec1: TMenuItem;
    Oct1: TMenuItem;
    Bin1: TMenuItem;
    ImageList1: TImageList;
    Basic1: TMenuItem;
    Pascal1: TMenuItem;
    C1: TMenuItem;
    Timer1: TTimer;
    Exit_N7: TMenuItem;
    DownBitBtn: TBitBtn;
    UpBitBtn: TBitBtn;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    FuncListBox: TListBox;
    CalcButton: TButton;
    ClearButton: TButton;
    HelpEdit: TEdit;
    Variables1: TMenuItem;
    DigitsPanel: TPanel;
    Dig7: TButton;
    Dig8: TButton;
    Dig9: TButton;
    Dig4: TButton;
    Dig5: TButton;
    Dig6: TButton;
    Dig1: TButton;
    Dig2: TButton;
    Dig3: TButton;
    DigS: TButton;
    Dig0: TButton;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete: TMenuItem;
    Functions1: TMenuItem;
    About1: TMenuItem;
    Howto1: TMenuItem;
    Registration1: TMenuItem;
    Show1: TMenuItem;
    HideMn: TMenuItem;
    File1: TMenuItem;
    Edit1: TMenuItem;
    View1: TMenuItem;
    Options1: TMenuItem;
    Help1: TMenuItem;
    Exit1: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    Delete1: TMenuItem;
    Variables2: TMenuItem;
    Functions2: TMenuItem;
    About2: TMenuItem;
    Registration2: TMenuItem;
    SkinsMnu: TMenuItem;
    NormalMnu: TMenuItem;
    LoadSkin1: TMenuItem;
    OpenDialog1: TOpenDialog;
    FilePopupMenu: TPopupMenu;
    Exit2: TMenuItem;
    EditPopupMenu: TPopupMenu;
    ViewPopupMenu: TPopupMenu;
    HelpPopupMenu: TPopupMenu;
    Cut3: TMenuItem;
    Copy3: TMenuItem;
    Paste3: TMenuItem;
    Delete2: TMenuItem;
    Variables3: TMenuItem;
    Skins1: TMenuItem;
    Functions3: TMenuItem;
    About3: TMenuItem;
    Registration3: TMenuItem;
    Normal1: TMenuItem;
    LoadSkin2: TMenuItem;
    Saveexpression1: TMenuItem;
    Loadexpression1: TMenuItem;
    Saveexpression2: TMenuItem;
    Loadexpression2: TMenuItem;
    Saveexpression3: TMenuItem;
    Loadexpression3: TMenuItem;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure RxTrayIcon1Click(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Hex1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Exit_N7Click(Sender: TObject);
    procedure CalcButtonClick(Sender: TObject);
    procedure UpBitBtnClick(Sender: TObject);
    procedure DownBitBtnClick(Sender: TObject);
    procedure ExpressionMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ExpressionMemoKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Help_N6Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FuncListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FuncListBoxDblClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure Options_N4Click(Sender: TObject);
    procedure Variables1Click(Sender: TObject);
    procedure FuncsTreeViewDblClick(Sender: TObject);
    procedure FuncsTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure FuncsTreeViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FuncListBoxClick(Sender: TObject);
    procedure Dig7Click(Sender: TObject);
    procedure DigSClick(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure Functions1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FuncsTreeViewExit(Sender: TObject);
    procedure Registration1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure HideMnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure LoadSkin1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Exit2Click(Sender: TObject);
    procedure Cut3Click(Sender: TObject);
    procedure Copy3Click(Sender: TObject);
    procedure Paste3Click(Sender: TObject);
    procedure Delete2Click(Sender: TObject);
    procedure Variables3Click(Sender: TObject);
    procedure Normal1Click(Sender: TObject);
    procedure LoadSkin2Click(Sender: TObject);
    procedure Functions3Click(Sender: TObject);
    procedure About3Click(Sender: TObject);
    procedure Registration3Click(Sender: TObject);
    procedure ExpressionMemoMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure NormalMnuClick(Sender: TObject);
    procedure Saveexpression2Click(Sender: TObject);
    procedure Loadexpression2Click(Sender: TObject);
    procedure FuncsTreeViewEnter(Sender: TObject);
  private
    FilePoint,EditPoint,ViewPoint,HelpPoint:TPoint;
    FirstTest:boolean;
    FNumLock: boolean;
    ExpressionBuffer:TExpressionBuffer;
    IsNT:boolean;
    SendKeyDLL:HMODULE;
    Key_Hook:TKey_Hook;
    SelStart:integer;
    TestCanRunQHLP:boolean;
    RunQHLPIndex:integer;
    ControlSizes:array[0..ControlsCount-1] of TControlSize;
    QuickHelp:TQuickHelp;
    HtmlHelpFileName:TFileName;
    FChangeNumLock: integer;
    Cod1,Cod2,Cod3:byte;
    FMainMenuVisible: boolean;
//  Переменные и функции для работы со скинами
    MainBitMap:TBitMap;
    TempBitMap:TBitMap;
    MemoryStream:TMemoryStream;
    MouseDown:boolean;
    x,y:integer;
    ButtonCount:integer;
    ButtonInfos:TButtonInfos;
    PrevLightCod:integer;
    ButtonIndex:integer;
    PressedButtonIndex:integer;
    IndicatorRect:TRect;
    OutMemoRect:TRect;
    FuncTreeRect:TRect;
    FUseSkin: boolean;
    procedure PressCalcButton(ButtonIndex:integer);
    procedure AddSymbolToIndicator(s:string);
    procedure ClearIndicator;
    procedure ExecuteExpression(var ErrorPosition:integer);
    procedure LoadMainBitMap(Stream:TStream);
    procedure LoadRegion(const Stream:TStream;var Region:TButtonRegion;
      var ShapeType:integer);
    procedure SetMainFormRegion(const RegType:integer;
      const Region:TButtonRegion);
    procedure SetIndicatorRegion(const RegType:integer;
      const Region:TButtonRegion);
    procedure SetOutMemoRegion(const RegType:integer;
      const Region:TButtonRegion);
    procedure SetFuncTreeRegion(const RegType:integer;
      const Region:TButtonRegion);
    procedure LoadButtonInfo(Stream:TStream;i:integer);
    procedure DrawBitMap(Region:TRegInfo;BitMap:TBytes);
    procedure DrawLite (const Point:TPoint;DrawAny:boolean);
// Конец Переменных и функций для работы со скинами
    procedure WMShowCalc (Var M : TMessage); message wm_ShowCalc_Event;
    procedure WMGotoHint (Var M : TMessage); message wm_GotoHint_Event;
    procedure WMSysCommand(var Msg:TWMSYSCOMMAND);message WM_SYSCOMMAND;
    procedure SetNumLock(const Value: boolean);
    procedure LoadSendKeyDLL;
    procedure RunQHLP;
    function GetControlSize(Control:TControl):TControlSize;
    procedure SaveControlsSizes;
    procedure ResizeControl(const Control:TControlSize;const kw,kh:double);
    procedure SetChangeNumLock(const Value: integer);
    procedure SetMainMenuVisible(const Value: boolean);
    function GetMainMenuVisible: boolean;
    procedure SetUseSkin(const Value: boolean);
//    procedure ResizeControl(const Control:TControl;
//      const Width,Height,Left,Top:integer;const kw,kh:double);
  public
    { Public declarations }
    function WinHook(var Message:TMessage):boolean;
    property NumLock:boolean read FNumLock write SetNumLock;
    property ChangeNumLock:integer read FChangeNumLock write SetChangeNumLock;
    procedure Hide1;
    procedure CalcExpression;
    procedure CalcExtendedExpression;
    procedure ChangeWordInExpressionMemo(NewWord:string;WordBegin,
      WordEnd:integer);
    procedure RecountControlSizes;
    procedure ShowQuickFuncHelp(const Wrd: string; WordBegin,WordEnd:integer);
    procedure RefreshExpressionIndex;
    procedure InsertToExpressionMemo(const s:string);
    procedure DeleteExpressionMemoSelection;
    procedure SaveOptions;
    function GetTempDir:string;
    procedure TestRegCod;
    procedure ShowCalc;
    property MainMenuVisible:boolean read GetMainMenuVisible write SetMainMenuVisible;
    //Функции для работы со скинами
    procedure LoadSkin(FileName:TFileName);
    property UseSkin:boolean read FUseSkin write SetUseSkin;
    procedure CreateSkinVariables;
    procedure SetFuncListBoxSize;
    procedure SetEditOptions;
    procedure SetFont(Const Font:TFont;FontInfo:TFontInfo);
    function TestBadCodes:boolean;

  end;

//procedure SetHook;
//procedure UnloadHook;
var
  MainCalcForm: TMainCalcForm;
  OldWindowProc :Pointer;
  FormH:HWND;
  Vis:boolean;
  P:Pointer;
  FirstRun:boolean;
  ErrorReg:boolean;


function CompiledHelpFile:string;

implementation

{$R *.DFM}
uses
  FunLib,sw,Formula, UnlimitedFloat, QHlpFunc,QHlpThrd, VarShowUnit,
  FunDefConst,HtmlHlp,RegUnit,DecodeUnit,CodeConst,AllMessages, Types;

{function NewWindowProc(WindowHandle : hWnd;
	TheMessage   : WParameter;
	ParamW : WParameter;
	ParamL : WParameter) : LongInt;stdcall;
begin
  if (TheMessage=WM_Close)then begin
    ShowMessage('Close');
    result:=1;
    exit;
  end;
    NewWindowProc := CallWindowProc(OldWindowProc, WindowHandle, TheMessage,
                                  ParamW, ParamL);
end;}


//function Key_Hook : Longint;stdcall;external 'SendKey.dll';
{ TForm1 }


procedure TMainCalcForm.WMSysCommand(var Msg: TWMSYSCOMMAND);
begin
  if Msg.CmdType=SC_CLOSE then begin
    if HelpFuncForm.Visible then
      HelpFuncForm.Hide;
    hide;
  end else
    inherited
end;

procedure SetWord(Item:string;WordBegin,WordEnd:integer);
begin
  MainCalcForm.ChangeWordInExpressionMemo(Item,WordBegin,WordEnd);
end;

procedure TMainCalcForm.FormCreate(Sender: TObject);
begin
  PressedButtonIndex:=-1;
  CreateSkinVariables;
  ExpressionMemo.Clear;
  HtmlHelpFileName:='MainForm.htm';
  KeyPreview:=true;
  Options:=TOptionsSaver.Create;
  Options.LoadOptions(ExtractFilePath(Application.ExeName)+OptionsFileName);
 // Options.Free;
  SetEditOptions;
  Options.SetDate;
  if Options.Registred then
    InitNewFuncs;
{  else if GetRestDays<0 then begin
    InputRegCod;
    if not RegCodInput then
      Application.Terminate;
  end;}
  Timer1.Enabled:=false;
//  if not ShowGrumblingForm then Application.Terminate;
//  ExtendedOperations[GrumbShow](nil);
  Timer1.Enabled:=true;
//  ExeUnit.Options.UseCoProcessor := True;
//  ExeUnit.Options.Precision := 32;
  DecimalSeparator:=ExeUnit.Options.DecimalSeparator;
  ExpSymbol:=ExeUnit.Options.ExpSymbol;
  QuickHelp:=TQuickHelp.Create(FuncListBox,HelpEdit, SetWord);
  SaveControlsSizes;
  TestCanRunQHLP:=false;
  SelStart:=0;
  LoadSendKeyDLL;
  IsNT:=IsWinNT;
//  Application.HookMainWindow(WinHook);
//  P:=@Key_Hook;
  Caption:=MainFormCaption;
  ExpressionBuffer:=TExpressionBuffer.Create;
  ConstBuf:=TConstBuf.Create;
  ConstBuf.LoadFromFile(ExtractFilePath(Application.ExeName)+ConstFileName);
  VarBuf:=TVarBuf.Create(RefreshVarShowForm);
  TreeFileName:=GetTempDir+TreeFileName;
  FuncsTreeView.SaveToFile(TreeFileName);
  InitTree(FuncsTreeView,TreeFileName,true);
  DigS.Caption:=DecimalSeparator;
  FirstTest:=true;
  if Options.KeepOnTop then
    FormStyle:=fsStayOnTop
  else
    FormStyle:=fsNormal;

  if (not Options.NormalView) and FileExists(Options.SkinFileName) then
    MainCalcForm.LoadSkin(Options.SkinFileName);

  InitTree(FuncsTreeView,TreeFileName,true);  

//  MainMenuVisible:=False;
{  if (ParamCount=1) then
    if (ParamStr(1)='h') then
       Visible:=false;}

//  QuickHelpThread:=TQuickHelpThread.Create(false);
end;

function TMainCalcForm.WinHook(var Message: TMessage): boolean;
begin
  result:=false;
  if (Message.Msg=WM_Close)then begin
    Hide;
    result:=true;
  end else if (Message.Msg=WM_KEYDOWN)then begin
  //  ExpressionMemo.Lines.Add('Down');
    if Message.WParam=VK_F2 then
//      Button3Click(nil)
{    else if Message.WParam=VK_NumLock then
      Hide;}
    else if Message.WParam=VK_DOWN then begin
      //HelpFuncForm.Activate;
      
//      ExpressionMemo.Lines.Add('Down');
    end;
  end;
{  if (Message.Msg=wm_ShowCalc_Event)then begin
    Show;
    BringToFront;
    Application.BringToFront;
    result:=false;
  end;}
end;

procedure TMainCalcForm.RxTrayIcon1Click(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if Visible then
    hide
  else begin
    WindowState:=wsNormal;
    Show;
    Application.BringToFront;
//    WindowState:=wsNormal;
  end;
end;

procedure TMainCalcForm.N1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainCalcForm.WMShowCalc(var M: TMessage);
begin
//  Label1.Caption:=format('%x',[M.LParam]);
//  ResultMemo.Lines.Add('WMShowCalc  M.LParam='+IntToStr(M.LParam and $80000000));
  if not Options.UseNumLock then
    exit;
  if ChangeNumLock>0 then begin
//    dec(ChangeNumLock);
    ChangeNumLock := ChangeNumLock-1;
//    ChangeNumLock:=false;
    exit;
  end;
  if M.LParam and $80000000 = $80000000 then
    exit;
//  ResultMemo.Lines.Add('WMShowCalc  '+IntToStr(ChangeNumLock));
//  ResultMemo.Lines.Add('M.LParam and $80000000 = $80000000');
  ChangeNumLock:=0;
  //ResultMemo.Lines.Add('ChangeNumLock=0');
  if {Visible}Active then begin
    Hide;
  end else begin
    Show;
    WindowState:=wsNormal;
    Application.Restore;
    Application.BringToFront;
    SetForegroundWindow(Handle);
{    FormStyle:=fsStayOnTop;
    while not Application.Active do
      Application.BringToFront;}

//    FormStyle:=fsNormal;
//    SendMessage(MainCalcForm.Handle,WM_SYSCOMMAND,SC_RESTORE,0);
  end;
  
  MainCalcForm.Refresh;
  Timer1.Enabled:=false;
  TimerCounter:=100;
  Timer1.Enabled:=true;
end;

(*
function Key_Hook(Code: integer; wParam: Longint; lParam: Longint): Longint stdcall;
var
 H: HWND;
begin
 {если Code>=0, то ловушка может обработать событие}
 if (Code >= 0)and Not ChangeNumLock then
 begin
  Result:=0;
  {если 0, то система должна дальше обработать это событие}
  {если 1 - нет}
   {это те клавиши?}
   if (wParam = VK_NumLock) and (lParam and $40000000 = 0)
   then begin
     {ищем окно по имени класса и по заголовку}
     H := FindWindow('TForm1', MainFormCaption);
     {посылаем сообщение}
     if wParam = VK_NumLock then begin
{       if Vis then
         SendMessage(H,WM_SYSCOMMAND,SC_Close,0)
       else}
         SendMessage(H, wm_ShowCalc_Event, 0, 0);
//       SendMessage(H,WM_SYSCOMMAND,SC_RESTORE,0);
       v:=true;
     end
   end;
 end else
   {если Code<0, то нужно вызвать следующую ловушку}
   Result := CallNextHookEx(HookHandle,Code, wParam, lParam);
end;


procedure SetHook;
begin
 {устанавливаем ловушку}
 if HookHandle=0 then begin
   HookHandle := SetWindowsHookEx(wh_Keyboard, Key_Hook,
                                                   hInstance, 0);
   if HookHandle = 0 then
     Raise Exception.Create('Unable to set hook!')
 end;
end;

procedure UnloadHook;
begin
 if HookHandle<>0 then
 begin
   UnhookWindowsHookEx(HookHandle);
   HookHandle:=0;
 end;
end;
*)

procedure TMainCalcForm.FormDestroy(Sender: TObject);
begin
//  UnloadHook;
  DeleteFile(TreeFileName);
  FreeLibrary(SendKeyDLL);
  QuickHelp.Free;
  if Length(OptionsFileName)>0 then
    Options.SaveOptions(ExtractFilePath(Application.ExeName)+OptionsFileName);
end;

procedure TMainCalcForm.Hex1Click(Sender: TObject);
var
  i:integer;
begin
  i:=(Sender as TMenuItem).MenuIndex;
  (Sender as TMenuItem).Checked:=true;
//  SysInputToolButton.ImageIndex:=i;
end;

procedure TMainCalcForm.SetNumLock(const Value: boolean);
begin
  FNumLock := Value;
  if (GetKeyState(VK_NumLock)=1)<>Value then begin
//    inc(ChangeNumLock);
    keybd_event( VK_NUMLOCK,$45,KEYEVENTF_EXTENDEDKEY or 0,0 );
   // Simulate a key release
    keybd_event( VK_NUMLOCK,$45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0);
  end;
end;


procedure SetNumLock1( bState:boolean);
var
  keyState:TKeyboardState;
  bScan: Byte;
  ErrorCode:Bool;
  c:SHORT;
  c1:boolean;
begin
  if not Options.UseNumLock then
    exit;
//  ErrorCode:=GetKeyboardState(keyState);
  c:=GetKeyState(VK_NUMLOCK);
  c1:=(c and 1)=1;
  if MainCalcForm.IsNT then begin//WinNT
    if (bState and not c1) or
       (not bState and c1) then
(*    if((bState and ((keyState[144{VK_NUMLOCK}] and 1)=0)) or
       (not bState and ((keyState[144{VK_NUMLOCK}] and 1)=1))) then *) begin
      bScan:=MapVirtualKey(VK_NUMLOCK,0);
    // Simulate a key press
//      inc(ChangeNumLock);
      MainCalcForm.ChangeNumLock:=MainCalcForm.ChangeNumLock+1;
//      MainCalcForm.ResultMemo.Lines.Add('inc(ChangeNumLock);  '+IntToStr(MainCalcForm.ChangeNumLock));

//      ChangeNumLock:=1;
      ErrorCode:=GetKeyboardState(keyState);
      keybd_event( VK_NUMLOCK,$45,KEYEVENTF_EXTENDEDKEY or 0,0 );
    // Simulate a key release
      keybd_event( VK_NUMLOCK,$45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0);
    end;
  end else begin //win9x
    GetKeyboardState(KeyState);
    if bState then
      KeyState[VK_NUMLOCK] := KeyState[VK_NUMLOCK] or 1
    else
      KeyState[VK_NUMLOCK] := KeyState[VK_NUMLOCK] and 0;
//   KeyState[VK_NUMLOCK] := KeyState[VK_NUMLOCK] xor 1;
    SetKeyboardState(KeyState);
  end;

end;

(*
procedure SetNumLock1( bState:boolean);
var
  keyState:TKeyboardState;
  bScan: Byte;
  ErrorCode:Bool;
  c:SHORT;
begin
//  ErrorCode:=GetKeyboardState(keyState);
  c:=GetKeyState(VK_NUMLOCK);
  if MainCalcForm.IsNT then begin//WinNT
    if( (bState and ((keyState[144{VK_NUMLOCK}] and 1)=0)) or
       (not bState and ((keyState[144{VK_NUMLOCK}] and 1)=1))) then begin
      bScan:=MapVirtualKey(VK_NUMLOCK,0);
    // Simulate a key press
//      inc(ChangeNumLock);
      MainCalcForm.ChangeNumLock:=MainCalcForm.ChangeNumLock+1;
//      MainCalcForm.ResultMemo.Lines.Add('inc(ChangeNumLock);  '+IntToStr(MainCalcForm.ChangeNumLock));

//      ChangeNumLock:=1;
      ErrorCode:=GetKeyboardState(keyState);
      keybd_event( VK_NUMLOCK,$45,KEYEVENTF_EXTENDEDKEY or 0,0 );
    // Simulate a key release
      keybd_event( VK_NUMLOCK,$45,KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,0);
    end;
  end else begin //win9x
    GetKeyboardState(KeyState);
    KeyState[VK_NUMLOCK] := KeyState[VK_NUMLOCK] or 1;
//   KeyState[VK_NUMLOCK] := KeyState[VK_NUMLOCK] xor 1;
    SetKeyboardState(KeyState);
  end;

end;
*)

procedure TMainCalcForm.FormShow(Sender: TObject);
begin
  SetNumLock1(true);
  Label2.Caption:='Show';
  RxTrayIcon1.Active:=true;
  ShowCalc;
//  NumLock:=true;
 // Timer1.Enabled:=true;
end;



procedure TMainCalcForm.Button1Click(Sender: TObject);
begin
//  keybd_event(VK_NUMLOCK,0,0,0);
  SetNumLock1(true);
end;

procedure TMainCalcForm.Timer1Timer(Sender: TObject);
begin
//  Timer1.Enabled:=false;
//  NumLock:=true;
//  Vis:=Visible;
 // dec(TimerCounter);
 // if TimerCounter<0 then
//    Timer1.Enabled:=false;
//  ShowMessage(IntToStr(TimerCounter));
//  Label1.Caption:=IntToStr(TimerCounter);
//  Refresh;
  if ErrorReg then begin
    ErrorReg:=false;
    ShowErrorRegistration;
    InputRegCod;
    if not RegCodInput then
       Close;
    RxTrayIcon1.Show;
    exit;
  end;
  if Visible then begin
    SetNumLock1(Visible);
    if FirstTest then
      if (ParamCount=1) then begin
        if (ParamStr(1)='h') then begin
          FirstTest:=false;
          WindowState:=wsMinimized;
//          SendMessage(MainCalcForm.Handle,SC_CLOSE,0,0);
          Hide;
        end;
      end;
  end else
    SetNumLock1(Options.NumLockAlwaysOn);

    //NumLock:=true;
{  if (GetKeyState(VK_NumLock)=1) then
    Visible:=true
  else
    Visible:=false;}
  if HelpFuncForm=nil then
    exit;  
  if HelpFuncForm.Visible {and (not HelpFuncForm.Active)} then begin
    SetActiveWindow(MainCalcForm.Handle);
    windows.SetFocus(MainCalcForm.Handle);
  end;
  if RegCodInput then
    TestRegCod;
  if TestCanRunQHLP then begin
    SetActiveWindow(MainCalcForm.Handle);
    dec(RunQHLPIndex);
    if RunQHLPIndex<0 then
      RunQHLP;
    SetActiveWindow(MainCalcForm.Handle);
    MainCalcForm.BringToFront;
    MainCalcForm.Refresh;
    SetActiveWindow(MainCalcForm.Handle);
    windows.SetFocus(MainCalcForm.Handle);
  end;
end;

procedure TMainCalcForm.Hide1;
var
  H:HWND;
begin
  H := FindWindow('TMainCalcForm', MainFormCaption);
  SendMessage(H,WM_SYSCOMMAND,SC_TaskList,0);
end;

procedure TMainCalcForm.Exit_N7Click(Sender: TObject);
begin
  Close;
end;

procedure TMainCalcForm.CalcButtonClick(Sender: TObject);
var
  ErrorPosition:integer;
begin
  ExecuteExpression(ErrorPosition);
  if ErrorPosition>0 then begin
    ExpressionMemo.SetFocus;
    ExpressionMemo.SelStart:=ErrorPosition-1;
    exit;
  end;
  ResultMemo.SetFocus;
  ResultMemo.SelStart:=0;
  ResultMemo.SelLength:=1;
  ResultMemo.SelLength:=0;
  ExpressionMemo.SetFocus;
end;
{procedure TForm1.Button3Click(Sender: TObject);
var
   FT:TFormulaTester;
   FE:TFormulaExecute;
   Res:TUnlimitedFloat;
   PolskaRecord:String;
   s:string;
   r:integer;
   Cursor:TCursor;
begin
  Cursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    FT:=TFormulaTester.Create;
    try
      r:=FT.Test(ExpressionMemo.Text);
      if r=1 then //Пустое выражение
        exit;
      PolskaRecord:=FT.PolskaRecord;
    finally
      FT.Free;
    end;
    FT:=TFormulaTester.Create;
    try
      Res:=TUnlimitedFloat.Create;
      try
        Res.DecPrecision:=1000;
   //     Res.ExponentLen:=2;
        FT.Execute(PolskaRecord,Res);
        s:=Res.DecStr;
        ResultMemo.Lines.Clear;
        ResultMemo.Lines.Add(s);
      finally
        Res.Free;
      end;
    finally
      FT.Free;
    end;
    ExpressionBuffer.AddExpression(ExpressionMemo);
  finally
    Screen.Cursor:=Cursor;
  end;
end;
}
procedure TMainCalcForm.CalcExpression;
var
   FT:TFormulaTester;
   FE:TFormulaExecute;
   Res:TUnlimitedFloat;
   PolskaRecord:String;
   s:string;
begin
  FT:=TFormulaTester.Create;
  try
    FT.Test(ExpressionMemo.Text);
    PolskaRecord:=FT.PolskaRecord;
  finally
    FT.Free;
  end;
  Res:=TUnlimitedFloat.Create;
  try
    Res.DecPrecision:=500;
//    Res.ExponentLen:=2;
    FT:=TFormulaTester.Create;
    try
      FT.Execute(PolskaRecord,Res);
    finally
      FT.Free;
    end;
    s:=Res.DecStr;
    ResultMemo.Lines.Add(s);
  finally
    Res.Free;
  end;
  ExpressionBuffer.AddExpression(ExpressionMemo);
end;

procedure TMainCalcForm.CalcExtendedExpression;
var
   FT:TFormulaTester;
   FE:TFormulaExecute;
   Res:Extended;
   PolskaRecord:String;
   s:string;
begin
  FT:=TFormulaTester.Create;
  try
    FT.Test(ExpressionMemo.Text);
    PolskaRecord:=FT.PolskaRecord;
  finally
    FT.Free;
  end;
  FT:=TFormulaTester.Create;
  try
    Res:=FT.Execute(PolskaRecord);
  finally
      FT.Free;
  end;
  s:=FloatToStr(Res);
  ResultMemo.Lines.Add(s);
  ExpressionBuffer.AddExpression(ExpressionMemo);
end;

{ TExpressionBuffer }
{
procedure TExpressionBuffer.AddExpression(Memo: TMemo);
var
  n:integer;
begin
  n:=Length(StringListBuffer);
  SetLength(StringListBuffer,n+1);
  if (n-ExpressionIndex>1) then
    Move(StringListBuffer[ExpressionIndex+1],StringListBuffer[ExpressionIndex+2],
      (n-ExpressionIndex-1)*SizeOf(TStringList));
  inc(ExpressionIndex);
  StringListBuffer[ExpressionIndex]:=TStringList.Create;
  StringListBuffer[ExpressionIndex].AddStrings(Memo.Lines);
end;

constructor TExpressionBuffer.Create;
begin
  inherited;
  ExpressionIndex:=-1;
end;

destructor TExpressionBuffer.Destroy;
var
  i,n:integer;
begin
  inherited;
  n:=Length(StringListBuffer)-1;
  for i:=0 to n do
    StringListBuffer[i].Free;
end;

procedure TExpressionBuffer.Down;
begin
  Inc(ExpressionIndex);
  if ExpressionIndex>=Length(StringListBuffer) then begin
    if Length(StringListBuffer)>0 then
      ExpressionIndex:=0
    else
      ExpressionIndex:=-1;
  end;
end;

procedure TExpressionBuffer.GetExpression(Memo: TMemo);
begin
  if ExpressionIndex>=0 then begin
    Memo.Lines.Clear;
    Memo.Lines.AddStrings(StringListBuffer[ExpressionIndex]);
  end;
end;

procedure TExpressionBuffer.Up;
begin
  Dec(ExpressionIndex);
  if ExpressionIndex<0 then
    ExpressionIndex:=Length(StringListBuffer)-1;
end;
}
procedure TMainCalcForm.UpBitBtnClick(Sender: TObject);
begin
  ExpressionBuffer.Up;
  ExpressionBuffer.GetExpression(ExpressionMemo);
  RefreshExpressionIndex;
end;

procedure TMainCalcForm.DownBitBtnClick(Sender: TObject);
begin
  ExpressionBuffer.Down;
  ExpressionBuffer.GetExpression(ExpressionMemo);
  RefreshExpressionIndex;
end;

procedure TMainCalcForm.ExpressionMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_EXECUTE then begin
    CalcButtonClick(Sender);
    Key:=0;
  end;
end;

procedure TMainCalcForm.ToolButton1Click(Sender: TObject);
begin
  CalcExpression;
end;

procedure TMainCalcForm.ToolButton2Click(Sender: TObject);
begin
  CalcExtendedExpression;
end;

function IsLitera(c:char):boolean;
begin
  result:=(c>='a')and(c<='z')or(c>='A')and(c<='Z')or(c='_');
end;

procedure TMainCalcForm.ExpressionMemoKeyPress(Sender: TObject; var Key: Char);
var
  s:string;
  i,sp,sp1:integer;
begin
  sp:=ExpressionMemo.SelStart;
  try
    if Key=#13 then begin
      CalcButtonClick(Sender);
      Key:=#0;
      HelpFuncForm.Hide;
      sp:=ExpressionMemo.SelStart;
    end else if IsLitera(Key)or (Key=#8) then begin
//      if HelpFuncForm.Visible then begin
        TestCanRunQHLP:=false;
        s:=Key;
        i:=ExpressionMemo.SelStart;
        sp1:=i+1;
        if Key=#8 then begin
          s:='';
          dec(i);
          sp1:=i;
        end;
        if Length(ExpressionMemo.Text)>0 then
          while IsLitera(ExpressionMemo.Text[i]) do begin
            s:=ExpressionMemo.Text[i]+s;
            dec(i);
          end;
        QuickHelp.SetWord(s,i,sp1,Options.UseCoProcessor);
    //      RefreshQHlpThread(s,i,sp1);
  //      end;
{        HelpFuncForm.Enabled:=false;
        try
          HelpFuncForm.Refresh;
          HelpFuncForm.SetWord(s,i,sp1);
          //HelpFuncForm.Show;
          HelpFuncForm.Top:=Top+ExpressionMemo.Top+ExpressionMemo.Height;
          HelpFuncForm.Left:=Left+ExpressionMemo.Left;
          BringToFront;
        finally
          HelpFuncForm.Enabled:=true;
         end;}
  {    end else begin
        TestCanRunQHLP:=true;
        RunQHLPIndex:=10;
      end;}
    end else begin
      QuickHelp.Hide;
      if Key=#27 then
        ExpressionMemo.Clear;
    end;  
//      HelpFuncForm.Hide;
  finally
//    ExpressionMemo.SelStart:=sp;
  end;
  MainCalcForm.BringToFront;
end;

procedure TMainCalcForm.FormActivate(Sender: TObject);
begin
  ExpressionMemo.SelStart:=SelStart;
//  delay(5);
//  NumLock:=true;
end;

procedure TMainCalcForm.Button2Click(Sender: TObject);
begin
  SetNumLock1(false);
end;

procedure TMainCalcForm.Help_N6Click(Sender: TObject);
begin
  //HelpFuncForm.Show;
end;

procedure TMainCalcForm.FormHide(Sender: TObject);
begin
  Label2.Caption:='Hide';
  HelpFuncForm.Hide;
 // Timer1.Enabled:=False;
  SetNumLock1(Options.NumLockAlwaysOn);
end;

procedure TMainCalcForm.LoadSendKeyDLL;
begin
  SendKeyDLL:=LoadLibrary('SendKey.DLL');
//  Key_Hook:=GetProcAddress(SendKeyDLL,'Key_Hook');
//  FreeLibrary(SendKeyDLL);
end;

procedure TMainCalcForm.WMGotoHint(var M: TMessage);
begin
  if (FuncListBox.Visible)and(ActiveControl<>FuncListBox) then begin
    ActiveControl:=FuncListBox;
    FuncListBox.ItemIndex:=0;
    QuickHelp.GetHelpString;
  end;
{  if HelpFuncForm.Visible then begin
    SelStart:=ExpressionMemo.SelStart;
    HelpFuncForm.BringToFront;
  end;}
  //Label3.Caption:='down';
end;

procedure TMainCalcForm.FormDeactivate(Sender: TObject);
begin
  SelStart:=ExpressionMemo.SelStart;
end;

procedure TMainCalcForm.ChangeWordInExpressionMemo(NewWord: string; WordBegin,
  WordEnd: integer);
var
  s1,s2:string;
begin
  s1:=Copy(ExpressionMemo.Text,1,WordBegin);
  s2:=Copy(ExpressionMemo.Text,WordEnd+1,Length(ExpressionMemo.Text));
  if (NewWord[1]=' ')and((s1='')or(s1[Length(s1)]<>' ')) then begin
    s1:=s1+' ';
    Inc(WordBegin);
  end;
  if (NewWord[Length(NewWord)]=' ') then begin
    if s2='' then begin
      s2:=' '+s2;
      Inc(WordBegin);
    end else if s2[1]<>' ' then begin
      s2:=' '+s2;
      Inc(WordBegin);
    end;
  end;
  NewWord:=Trim(NewWord);
  ExpressionMemo.Text:=s1+NewWord+s2;
  SelStart:=WordBegin+Length(NewWord);
  ExpressionMemo.SelStart:=SelStart;
end;

procedure TMainCalcForm.RunQHLP;
var
  i,sp1,sp:integer;
  s:string;
begin
  windows.SetFocus(MainCalcForm.Handle);
  TestCanRunQHLP:=false;
  sp:=ExpressionMemo.SelStart;
  try
    s:='';
    i:=ExpressionMemo.SelStart;
    sp1:=i;
    if Length(ExpressionMemo.Text)>0 then
      while IsLitera(ExpressionMemo.Text[i]) do begin
        s:=ExpressionMemo.Text[i]+s;
        dec(i);
      end;
    HelpFuncForm.Enabled:=false;
    try
      HelpFuncForm.Refresh;
      HelpFuncForm.SetWord(s,i,sp1);
      //HelpFuncForm.Show;
      HelpFuncForm.Top:=Top+ExpressionMemo.Top+ExpressionMemo.Height;
      HelpFuncForm.Left:=Left+ExpressionMemo.Left;
      BringToFront;
      Activate;
    finally
      HelpFuncForm.Enabled:=true;
    end;
  finally
    ExpressionMemo.SelStart:=sp;
  end;
  windows.SetFocus(MainCalcForm.Handle);
end;

procedure TMainCalcForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
//  if Abs(NewWidth-Width)<Abs(NewHeight-Height) then
  if not FUseSkin then begin
    NewWidth:=Round(Gold*(NewHeight-(Height-ClientHeight)))+(Width-ClientWidth);
    RecountControlSizes;
  end;
//  else
//    NewHeight:=Round(NewWidth/Gold);
end;

procedure TMainCalcForm.RecountControlSizes;
var
  kw,kh:double;
  i,n:integer;
begin
  kw:=ClientWidth/414;
  kh:=ClientHeight/256;
  n:=ControlsCount-1;
  for i:=0 to n do
    ResizeControl(ControlSizes[i],kw,kh);
{  ResizeControl(ExpressionMemo,185,105,1,8,kw,kh);
  ResizeControl(ResultMemo,144,89,1,122,kw,kh);
  ResizeControl(FuncsTreeView,124,201,280,8,kw,kh);
  ResizeControl(ButtonPanel1,64,105,195,8,kw,kh);
  ResizeControl(UpBitBtn,40,25,12,8,kw,kh);
  ResizeControl(DownBitBtn,40,25,12,40,kw,kh);
  ResizeControl(CalcButton,40,25,12,72,kw,kh);
  ResizeControl(GroupBox1,55,89,152,120,kw,kh);
  ResizeControl(GroupBox2,55,89,216,120,kw,kh);
  ResizeControl(ToolBar3,44,34,8,15,kw,kh);
  ResizeControl(SysInputToolButton,40,26,0,0,kw,kh);}


{  ExpressionMemo.Width:=round(185*k);
  ExpressionMemo.Top:=round(8*k);
  ExpressionMemo.Left:=round(k);
  ExpressionMemo.Height:=Round(ExpressionMemo.Width/Gold);}
end;

{procedure TForm1.ResizeControl(const Control: TControl; const Width,Height,
  Left, Top: integer; const kw,kh: double);
begin
  Control.Width:=round(Width*kw);
  Control.Height:=round(Height*kh);
  Control.Left:=round(Left*kw);
  Control.Top:=round(Top*kh);
end;}

procedure TMainCalcForm.SaveControlsSizes;
var
  i,k:integer;
begin
  ControlSizes[0]:=GetControlSize(ExpressionMemo);
  ControlSizes[1]:=GetControlSize(ResultMemo);
  ControlSizes[2]:=GetControlSize(FuncsTreeView);
  ControlSizes[3]:=GetControlSize(ButtonPanel1);
  ControlSizes[4]:=GetControlSize(UpBitBtn);
  ControlSizes[5]:=GetControlSize(DownBitBtn);
  ControlSizes[6]:=GetControlSize(CalcButton);
  ControlSizes[7]:=ControlSizes[1];
  ControlSizes[7].Control:=FuncListBox;
  ControlSizes[8]:=GetControlSize(HelpEdit);
  ControlSizes[9]:=GetControlSize(ClearButton);
  k:=10;
  for i:=0 to ComponentCount-1 do
    if Components[i].Tag=1 then begin
      ControlSizes[k]:=GetControlSize(Components[i] as TControl);
      inc(k);
    end;
//  ControlSizes[8]:=GetControlSize(GroupBox2);
//  ControlSizes[7]:=GetControlSize(ToolBar3);
end;

function TMainCalcForm.GetControlSize(Control: TControl): TControlSize;
begin
  Result.Left:=Control.Left;
  Result.Top:=Control.Top;
  Result.Width:=Control.Width;
  Result.Height:=Control.Height;
  Result.Control:=Control;
  if Control is TEdit then
    Result.FontSize:=(Control as TEdit).Font.Size
  else if Control is TButton then
    Result.FontSize:=(Control as TButton).Font.Size

end;

procedure TMainCalcForm.ResizeControl(const Control: TControlSize;const kw,kh:double);
begin
  if Control.Control=nil then
    exit;
  with Control.Control do begin
    Width:=round(Control.Width*kw);
    Height:=round(Control.Height*kh);
    Left:=round(Control.Left*kw);
    Top:=round(Control.Top*kh);
  end;
  if (Control.Control is TEdit)  then
    (Control.Control as TEdit).Font.Size:=Round(Control.FontSize*kh)
  else if (Control.Control is TButton){and(Control.Control.Tag=1)} then
    (Control.Control as TButton).Font.Size:=Round(Control.FontSize*kh)

end;

procedure TMainCalcForm.ShowQuickFuncHelp(const Wrd: string; WordBegin,
  WordEnd:integer);
begin

end;

procedure TMainCalcForm.FuncListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s:string;
begin
  if Key=VK_ESCAPE then begin
    s:=MainCalcForm.ExpressionMemo.Text;
    Hide;
    MainCalcForm.ExpressionMemo.Text:=s;
  end else if Key=VK_RETURN then begin
    QuickHelp.ReturnFunc;
    ActiveControl:=ExpressionMemo;
  end;
end;

procedure TMainCalcForm.FuncListBoxDblClick(Sender: TObject);
begin
  QuickHelp.ReturnFunc;
  ActiveControl:=ExpressionMemo;
end;

procedure TMainCalcForm.ClearButtonClick(Sender: TObject);
begin
  ClearIndicator;
end;

procedure TMainCalcForm.Options_N4Click(Sender: TObject);
begin
  if ShowOptions(Options) then begin
    if Options.KeepOnTop then
      FormStyle:=fsStayOnTop
    else
      FormStyle:=fsNormal;

    InitTree(FuncsTreeView,TreeFileName,
      Options.UseCoProcessor);
    if DecimalSeparator<>Options.DecimalSeparator then begin
      DecimalSeparator:=Options.DecimalSeparator;
      ConstBuf.ChangeDecSepAll(DecimalSeparator);
    end;
    ExpSymbol:=Options.ExpSymbol;
    DigS.Caption:=Options.DecimalSeparator;
    if not FileExists(Options.SkinFileName) then
      Options.NormalView:=true;
    if Options.NormalView then begin
        if UseSkin then
          NormalMnuClick(nil);
      end else
        LoadSkin(Options.SkinFileName);
    SetEditOptions;
  end;
  if Length(OptionsFileName)>0 then
    Options.SaveOptions(ExtractFilePath(Application.ExeName)+OptionsFileName);

  //todo: Сохранить Options в реестр;
end;

procedure TMainCalcForm.Variables1Click(Sender: TObject);
begin
  if VarShowForm=nil then
    VarShowForm:=TVarShowForm.Create(nil);
  VarShowForm.SetVarBuf(VarBuf);
  VarShowForm.Show;
end;

procedure TMainCalcForm.RefreshExpressionIndex;
begin
end;

procedure TMainCalcForm.FuncsTreeViewDblClick(Sender: TObject);
var
  i1,i2:integer;
  FuncDesc:PFuncDesc;
  B,s1,s2:string;
begin
  if FuncsTreeView.Selected.Data=nil then
    exit;
  if PGroupRec(FuncsTreeView.Selected.Data).Id =1 then
    exit;
  FuncDesc:=PFuncDesc(FuncsTreeView.Selected.Data);
  i1:=ExpressionMemo.SelStart;
  i2:=i1+ExpressionMemo.SelLength+1;
  s1:=Copy(ExpressionMemo.Text,1,i1);
  s2:=Copy(ExpressionMemo.Text,i2,Length(ExpressionMemo.Text));
  if PGroupRec(FuncsTreeView.Selected.Data).Id =3 then begin
    B:=PConstant(FuncsTreeView.Selected.Data).Name;
    if (s1='')or(s1[Length(s1)]<>' ') then
      B:=' '+B;
    if (s2='')or(s2[1]<>' ') then
      B:=B+' ';
  end else begin
    if FuncDesc.NeedBrackets then
      B:=FuncDesc.FunId+'()'
    else begin
      B:=FuncDesc.FunId;
      if IsLitera(FuncDesc.FunId[1]) then begin
        if (s1='')or(s1[Length(s1)]<>' ') then
          B:=' '+B;
        if (s2='')or(s2[1]<>' ') then
          B:=B+' ';
      end;
    end;
  end;
  ExpressionMemo.Text:=s1+B+s2;
  ExpressionMemo.SelStart:=Length(s1+B);
  ActiveControl:=ExpressionMemo;
  QuickHelp.Hide;
//  FuncsTreeView.Selected:=FuncsTreeView.Items[0];
end;

procedure TMainCalcForm.FuncsTreeViewChange(Sender: TObject;
  Node: TTreeNode);
begin
  if Node=nil then
    exit;
  if Node.Data<>nil then begin
    if PGroupRec(Node.Data).id=2 then begin
      HelpEdit.Text:=PFuncDesc(Node.Data).FunDesc;
      HtmlHelpFileName:=PFuncDesc(Node.Data).HtmlHelp;
    end else if PGroupRec(Node.Data).id=1 then begin
      HelpEdit.Text:='Press F1 for help.';
      HtmlHelpFileName:=PGroupRec(Node.Data).HtmlHelp;
    end
  end else begin
    HelpEdit.Text:='Press F1 for help.';
    HtmlHelpFileName:='';
  end;
end;

procedure TMainCalcForm.FuncsTreeViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key=VK_RETURN then begin
    FuncsTreeViewDblClick(nil);
    Key:=0;
  end else if Key=VK_F1 then begin
    Functions1Click(nil);
    Key:=0;
  end;
end;

procedure TMainCalcForm.FuncListBoxClick(Sender: TObject);
begin
  HelpEdit.Text:=QuickHelp.GetHelpString;
end;

procedure TMainCalcForm.Dig7Click(Sender: TObject);
begin
  ActiveControl:=ExpressionMemo;
  InsertToExpressionMemo((Sender as TButton).Caption);
end;

procedure TMainCalcForm.InsertToExpressionMemo(const s: string);
var
  i1,i2:integer;
  s1,s2:string;
begin
  i1:=ExpressionMemo.SelStart;
  i2:=i1+ExpressionMemo.SelLength+1;
  s1:=Copy(ExpressionMemo.Text,1,i1);
  s2:=Copy(ExpressionMemo.Text,i2,Length(ExpressionMemo.Text));
  ExpressionMemo.Text:=s1+s+s2;
  ExpressionMemo.SelStart:=Length(s1+s);
end;

procedure TMainCalcForm.DigSClick(Sender: TObject);
begin
  ActiveControl:=ExpressionMemo;
  InsertToExpressionMemo(DecimalSeparator);
end;

procedure TMainCalcForm.Cut1Click(Sender: TObject);
begin
  ExpressionMemo.CutToClipboard;
end;

procedure TMainCalcForm.Copy1Click(Sender: TObject);
begin
  ExpressionMemo.CopyToClipboard;
end;

procedure TMainCalcForm.Paste1Click(Sender: TObject);
begin
  ExpressionMemo.PasteFromClipboard;
end;

procedure TMainCalcForm.DeleteClick(Sender: TObject);
begin
  DeleteExpressionMemoSelection;
end;

procedure TMainCalcForm.DeleteExpressionMemoSelection;
var
  cp:integer;
begin
  if ExpressionMemo.SelLength>0 then
    with ExpressionMemo do begin
      cp:=SelStart;
      Text:=Copy(Text,1,SelStart)+Copy(Text,SelStart+1+SelLength,Length(Text));
      SelStart:=cp;
    end;
end;

procedure TMainCalcForm.SaveOptions;
var
  FileName:TFileName;
  FileStream:TFileStream;
begin
//  FileName:=ExtractFilePath(Application.ExeName)
end;

procedure TMainCalcForm.Functions1Click(Sender: TObject);
var
  URL: string;
begin
//  HtmlHelp(0, nil, HH_CLOSE_ALL, 0);
  URL := CompiledHelpFile;
//  if ComboUrls.Text <> '' then URL := URL + '::/' + ComboUrls.Text;
  if HtmlHelpFileName <> '' then
    URL := URL + '::/' + HtmlHelpFileName
  else
    URL := URL + '::/MainForm.htm';
  HtmlHelp(0, PChar(URL), HH_DISPLAY_TOC, 0);
end;

procedure TMainCalcForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_F1 then begin
    Functions1Click(nil);
    Key:=0;
  end;
end;

procedure TMainCalcForm.SetChangeNumLock(const Value: integer);
begin
  FChangeNumLock := Value;
//  ResultMemo.Lines.Add('SetChangeNumLock  '+IntToStr(Value));
end;

procedure TMainCalcForm.FuncsTreeViewExit(Sender: TObject);
begin
  HtmlHelpFileName:='MainForm.htm';
end;

procedure TMainCalcForm.Registration1Click(Sender: TObject);
begin
  InputRegCod;
end;

procedure TMainCalcForm.TestRegCod;
var
  b1,b2,b3:byte;
  i:integer;
begin
  RegCodInput:=false;
  for i:=0 to 15 do
    RegCod[i]:=RegCod[i] xor Signatura[i];
  ArrayToByte(b1,ByteIndexs1);
  if TestBadCodes then
    b1:=$13;
  if b1=FirstByte then begin
    ShowRegistrationThanks;
    for i:=0 to 15 do
      RegCod[i]:=RegCod[i] xor Signatura[i];
    Options.RegCod:=RegCod;
    Options.Signatura:=Signatura;
  end else begin
    RxTrayIcon1.Hide;
//    ShowErrorRegistration;
    ErrorReg:=true;
    Hide;
  end;
end;

function CompiledHelpFile:string;
begin
  Result:=ExtractFilePath(Application.ExeName)+CompiledHelpFileName;
end;

function TMainCalcForm.GetTempDir: string;
var
  Res: String[200];
  L:integer;
begin
  L:=GetTempPath(200,@Res[1]);
  SetLength(Res,L);
  Result:=Res;
end;

procedure TMainCalcForm.About1Click(Sender: TObject);
begin
  ShowAbout;
end;


procedure TMainCalcForm.ShowCalc;
begin
  Show;
  WindowState:=wsNormal;
  Application.Restore;
  Application.BringToFront;
  SetForegroundWindow(Handle);
end;

procedure TMainCalcForm.Show1Click(Sender: TObject);
begin
  ShowCalc;
end;

procedure TMainCalcForm.HideMnClick(Sender: TObject);
begin
  Hide;
end;

procedure TMainCalcForm.SetMainMenuVisible(const Value: boolean);
begin
  FMainMenuVisible := Value;
  File_N2.Visible:=FMainMenuVisible;
  Edit_N5.Visible:=FMainMenuVisible;
  View_N3.Visible:=FMainMenuVisible;
  Options_N4.Visible:=FMainMenuVisible;
  Help_N6.Visible:=FMainMenuVisible;
end;

function TMainCalcForm.GetMainMenuVisible: boolean;
begin
  result:=File_N2.Visible or Edit_N5.Visible or View_N3.Visible or
    Options_N4.Visible or Help_N6.Visible;
end;


//Функции для работы со скинами
procedure TMainCalcForm.PressCalcButton(ButtonIndex: integer);
var
  Cod:integer;
begin
  PrevLightCod:=-1;
{  DrawBitMap(ButtonInfos[ButtonIndex].SelectRegion,
    ButtonInfos[ButtonIndex].SelectBitMap);}
  Cod:=ButtonInfos[PressedButtonIndex].Cod;
//  PressedButtonIndex:=ButtonIndex;
  if (Cod>=bt_0) and (Cod<=bt_9) then
    AddSymbolToIndicator(IntToStr(Cod-bt_0))
  else Case Cod of
    bt_Plus:AddSymbolToIndicator('+');
    bt_Minus:AddSymbolToIndicator('-');
    bt_Mul:AddSymbolToIndicator('*');
    bt_Div:AddSymbolToIndicator('/');
    bt_Exe:CalcButtonClick(nil);
    bt_DecSeparator:AddSymbolToIndicator(DecimalSeparator);
    bt_CloseForm:hide;
    bt_ShowMemList:;
    bt_AddToMemList:;
    bt_Sin:;
    bt_Cos:;
    bt_ArcSin:;
    bt_ArcCos:;
    bt_tg:;
    bt_Ctg:;
    bt_ArcTg:;
    bt_ArcCtg:;
    bt_Ln:;
    bt_Log:;
    bt_lg:;
    bt_Power:;
    bt_Sqr:;
    bt_Sqrt:;
    bt_Clear:ClearIndicator;
    bt_Percent:;
    bt_ChangeSign:;
    bt_LogFile:;
    bt_Ms:;
    bt_Mr:;
    bt_MPlus:;
    bt_MMinus:;
    bt_File:FilePopupMenu.Popup(Left+FilePoint.x,Top+FilePoint.y);
    bt_Edit:EditPopupMenu.Popup(Left+EditPoint.x,Top+EditPoint.y);
    bt_View:ViewPopupMenu.Popup(Left+ViewPoint.x,Top+ViewPoint.y);
    bt_Options:Options_N4Click(nil);
    bt_Help:HelpPopupMenu.Popup(Left+HelpPoint.x,Top+HelpPoint.y);
    bt_PrevOp:UpBitBtnClick(nil);
    bt_NextOp:DownBitBtnClick(nil);
  end;

end;

procedure TMainCalcForm.AddSymbolToIndicator(s: string);
var
  eqPos:integer;
begin
  ActiveControl:=ExpressionMemo;
  InsertToExpressionMemo(s);

{  eqPos:=Pos('=',IndicatorEdit.Text);
  if eqPos>0 then
    IndicatorEdit.Text:=Copy(IndicatorEdit.Text,eqPos+1,
      Length(IndicatorEdit.Text));
  IndicatorEdit.Text:=IndicatorEdit.Text+s;
  IndicatorEdit.SelStart:=Length(IndicatorEdit.Text);}
end;

procedure TMainCalcForm.ClearIndicator;
begin
  ExpressionMemo.Clear;
  MainCalcForm.ActiveControl:=ExpressionMemo;
end;

procedure TMainCalcForm.ExecuteExpression(var ErrorPosition:integer);
var
  s:string;
  p:integer;
begin
//  FuncListBox.Visible:=false;
  QuickHelp.Hide;
  try
    s:=ExecExpresion(ExpressionMemo.Text,ErrorPosition);
    ResultMemo.Lines.Clear;
    ResultMemo.Lines.Add(s);
    ResultMemo.SetFocus;
    ResultMemo.SelStart:=0;
    ExpressionBuffer.AddExpression(ExpressionMemo);
    RefreshExpressionIndex;
    MainCalcForm.ActiveControl:=ExpressionMemo;
  except
    on a:Exception do begin
      try
        p:=ErrorPosition;
//        ExpressionMemo.SetFocus;
//        ExpressionMemo.SelStart:=p;
//        ShowMessage(IntToStr(ExpressionMemo.SelStart));
//        ExpressionMemo.Refresh;
//        ExpressionMemo.SelLength:=1;
//        ExpressionMemo.Refresh;
      except
      end;
      ShowMessage(a.Message);
//      Raise;
    end;
  end;
end;

procedure TMainCalcForm.LoadMainBitMap(Stream: TStream);
var
  Size,j0,j1:integer;
  n,i:integer;
  r:TRect;
  ShapeType:integer;
  MainFormRegion:TButtonRegion;
begin
  Stream.Read(Size,sizeOf(integer));
  MemoryStream.SetSize(Size);
  Stream.Read(MemoryStream.Memory^,Size);
  MemoryStream.Position:=0;
  MainBitMap.LoadFromStream(MemoryStream);
  Width:=MainBitMap.Width;
  Height:=MainBitMap.Height;
  Stream.Read(ButtonCount,SizeOf(integer));
  Stream.Read(j0,SizeOf(integer));
  if j0=1 then begin
    LoadRegion(Stream,MainFormRegion,ShapeType);
    SetMainFormRegion(ShapeType,MainFormRegion);
    dec(ButtonCount);
  end;
  Stream.Read(j1,SizeOf(integer));
  if j1=j0+1 then begin //Задан прямоугольник индикатора
    LoadRegion(Stream,MainFormRegion,ShapeType);
    SetIndicatorRegion(ShapeType,MainFormRegion);
    dec(ButtonCount);
    LoadRegion(Stream,MainFormRegion,ShapeType);
    SetOutMemoRegion(ShapeType,MainFormRegion);
    LoadRegion(Stream,MainFormRegion,ShapeType);
    SetFuncTreeRegion(ShapeType,MainFormRegion);
    dec(ButtonCount,2);
  end;

end;

procedure TMainCalcForm.LoadRegion(const Stream:TStream;
  var Region: TButtonRegion;var ShapeType:integer);
var
  n:integer;
  r:TRect;
begin
  Stream.Read(ShapeType,SizeOf(Integer));
  Stream.Read(n,SizeOf(Integer));
  Stream.Read(r,SizeOf(TRect));
  SetLength(Region,n);
  Stream.Read(Region[0],n*SizeOf(Windows.TPoint));
end;

procedure TMainCalcForm.SetMainFormRegion(const RegType:integer;
  const Region:TButtonRegion);
var
  Rgn: HRGN;
begin
  case RegType of
    shCircle:Rgn:=CreateCircleRegion(Region);
    shEllipse:Rgn:=CreateEllipsRegion(Region);//Эллипс
    shRectangle:Rgn:=CreateRectRegion(Region);//Прямоугольник
    shRoundRectangle:Rgn:=CreateRoundRectRegion(Region);//Закругленный прямоугольник
    shPolygon:Rgn:=CreatePolygonRegion(Region);//Многоугольник
  end;
  SetWindowRgn(Handle,Rgn,True);
  DeleteObject(Rgn);
end;

procedure TMainCalcForm.SetIndicatorRegion(const RegType: integer;
  const Region: TButtonRegion);
var
  n:integer;
begin
  n:=Length(Region);
  if n<>2 then
    Raise Exception.Create('Неверное число точек в контуре индикатора -'+
      IntToStr(n));
  IndicatorRect:=PRect(@Region[0])^;
  with ExpressionMemo do begin
    Left:=Min(IndicatorRect.Left,IndicatorRect.Right);
    Top:=Min(IndicatorRect.Top,IndicatorRect.Bottom);
    with IndicatorRect do begin
      Width:=Abs(Left-Right)+1;
      Height:=Abs(Top-Bottom)+1;
    end;
  end;
end;

procedure TMainCalcForm.SetOutMemoRegion(const RegType: integer;
  const Region: TButtonRegion);
var
  n:integer;
begin
  n:=Length(Region);
  if n<>2 then
    Raise Exception.Create('Неверное число точек в контуре индикатора -'+
      IntToStr(n));
  OutMemoRect:=PRect(@Region[0])^;
  with ResultMemo do begin
    Left:=Min(OutMemoRect.Left,OutMemoRect.Right);
    Top:=Min(OutMemoRect.Top,OutMemoRect.Bottom);
    with OutMemoRect do begin
      Width:=Abs(Left-Right)+1;
      Height:=Abs(Top-Bottom)+1;
    end;
  end;
end;

procedure TMainCalcForm.SetFuncTreeRegion(const RegType: integer;
  const Region: TButtonRegion);
var
  n:integer;
begin
  n:=Length(Region);
  if n<>2 then
    Raise Exception.Create('Неверное число точек в контуре индикатора -'+
      IntToStr(n));
  FuncTreeRect:=PRect(@Region[0])^;
  with FuncsTreeView do begin
    Left:=Min(FuncTreeRect.Left,FuncTreeRect.Right);
    Top:=Min(FuncTreeRect.Top,FuncTreeRect.Bottom);
    with FuncTreeRect do begin
      Width:=Abs(Left-Right)+1;
      Height:=Abs(Top-Bottom)+1;
    end;
  end;
end;

procedure TMainCalcForm.LoadButtonInfo(Stream:TStream;i:integer);
var
  BitMapSize:integer;
  r:TRect;
begin
  Stream.Read (ButtonInfos[i].Cod,SizeOf(integer));

  LoadRegInfo(Stream,ButtonInfos[i].FindRegion);

{  Stream.Read (BitMapSize,SizeOf(integer));
  SetLength(ButtonInfos[i].DisableBitMap,BitMapSize);
  Stream.Read (ButtonInfos[i].DisableBitMap[0],BitMapSize);
  LoadRegInfo(Stream,ButtonInfos[i].DisableRegion);}

  Stream.Read (BitMapSize,SizeOf(integer));
  SetLength(ButtonInfos[i].SelectBitMap,BitMapSize);
  Stream.Read (ButtonInfos[i].SelectBitMap[0],BitMapSize);
  LoadRegInfo(Stream,ButtonInfos[i].SelectRegion);

  Stream.Read (BitMapSize,SizeOf(integer));
  SetLength(ButtonInfos[i].LightBitMap,BitMapSize);
  Stream.Read (ButtonInfos[i].LightBitMap[0],BitMapSize);
  LoadRegInfo(Stream,ButtonInfos[i].LightRegion);
  with ButtonInfos[i] do
    Case Cod of
      bt_File:begin
                r:=GetBoundedRect(FindRegion.Region);
                FilePoint.x:=r.Left;
                FilePoint.y:=r.Bottom;
              end;
      bt_Edit:begin
                r:=GetBoundedRect(FindRegion.Region);
                EditPoint.x:=r.Left;
                EditPoint.y:=r.Bottom;
              end;
      bt_View:begin
                r:=GetBoundedRect(FindRegion.Region);
                ViewPoint.x:=r.Left;
                ViewPoint.y:=r.Bottom;
              end;
      bt_Options:;
      bt_Help:begin
                r:=GetBoundedRect(FindRegion.Region);
                HelpPoint.x:=r.Left;
                HelpPoint.y:=r.Bottom;
              end;
    end;

end;

procedure TMainCalcForm.DrawBitMap(Region: TRegInfo; BitMap: TBytes);
var
  Rgn: HRGN;
  Size:integer;
begin
  case Region.ShapeType of
    shCircle:Rgn:=CreateCircleRegion(Region.Region);
    shEllipse:Rgn:=CreateEllipsRegion(Region.Region);//Эллипс
    shRectangle:Rgn:=CreateRectRegion(Region.Region);//Прямоугольник
    shRoundRectangle:Rgn:=CreateRoundRectRegion(Region.Region);//Закругленный прямоугольник
    shPolygon:Rgn:=CreatePolygonRegion(Region.Region);//Многоугольник
  end;
  try
    SelectClipRgn(Canvas.Handle,Rgn);
    Size:=Length(BitMap);
    MemoryStream.SetSize(0);
    MemoryStream.Write(BitMap[0],Size);
    MemoryStream.Position:=0;
    TempBitMap.LoadFromStream(MemoryStream);
    with Region do
      Canvas.Draw(BoundedRect.Left,BoundedRect.Top,TempBitMap);
  finally
    DeleteObject(Rgn);
  end;
end;

procedure TMainCalcForm.DrawLite(const Point:Windows.TPoint;DrawAny:boolean);
var
  i:integer;
begin
  for i:=0 to ButtonCount do
    if IsPtInRegion (ButtonInfos[i].FindRegion,Point) then begin
      if (PrevLightCod<>ButtonInfos[i].Cod)or DrawAny then begin
        if PressedButtonIndex=i then
          exit;
        if (PrevLightCod<>-1)or (PressedButtonIndex<>-1) then
          Canvas.Draw(0,0,MainBitMap);
//          Canvas.StretchDraw(rect(0,0,Width-1,Height-1),MainBitMap);
        DrawBitMap(ButtonInfos[i].LightRegion,ButtonInfos[i].LightBitMap);
        PrevLightCod:=ButtonInfos[i].Cod;
        ButtonIndex:=i;
      end;
      exit;
    end;
  if PrevLightCod<>-1 then begin
    Canvas.Draw(0,0,MainBitMap);
//    Canvas.StretchDraw(rect(0,0,Width-1,Height-1),MainBitMap);
    PrevLightCod:=-1;
  end;
  if (PrevLightCod<>-1)or (PressedButtonIndex<>-1) then begin
     Canvas.Draw(0,0,MainBitMap);
     PrevLightCod:=-1;
     PressedButtonIndex:=-1;
  end;
end;

procedure TMainCalcForm.LoadSkin(FileName: TFileName);
var
  FileStream:TFileStream;
  i:integer;
begin
  MainCalcForm.Visible:=false;
  try
    UseSkin := true;
    FileStream:=TFileStream.Create(FileName,fmOpenRead);
    try
      LoadMainBitMap(FileStream);
      SetLength(ButtonInfos,ButtonCount);
      dec(ButtonCount);
      for i:=0 to ButtonCount do
        LoadButtonInfo(FileStream,i);
      SetFuncListBoxSize;  
    finally
      FileStream.Free;
    end;
  finally
    MainCalcForm.Visible:=true;
  end;
end;

// Конец Переменных и функций для работы со скинами


procedure TMainCalcForm.FormPaint(Sender: TObject);
begin
  if FUseSkin then
    Canvas.Draw(0,0,MainBitMap)
end;

procedure TMainCalcForm.SetUseSkin(const Value: boolean);
begin
  Options.NormalView:=not Value;
  FUseSkin := Value;
  MainMenuVisible:= not FUseSkin;
  DigitsPanel.Visible:=not FUseSkin;
  ButtonPanel1.Visible:=not FUseSkin;
  CalcButton.Visible:=not FUseSkin;
  ClearButton.Visible:=not FUseSkin;
  HelpEdit.Visible:=not FUseSkin;
  if FUseSkin then begin
    BorderStyle:=bsNone;
    ExpressionMemo.BorderStyle:=bsNone;
    ResultMemo.BorderStyle:=bsNone;
    FuncsTreeView.BorderStyle:=bsNone;
  end else begin
    BorderStyle:=bsSizeable;
    AutoScroll:=false;
    ExpressionMemo.BorderStyle:=bsSingle;
    ResultMemo.BorderStyle:=bsSingle;
    FuncsTreeView.BorderStyle:=bsSingle;
  end;
  InitTree(FuncsTreeView,TreeFileName,Options.UseCoProcessor);
end;

procedure TMainCalcForm.LoadSkin1Click(Sender: TObject);
begin
  OpenDialog1.InitialDir:=ExtractFilePath(Application.ExeName)+'Skins';
  if OpenDialog1.Execute then begin
    LoadSkin(OpenDialog1.FileName);
    Options.SkinFileName:=OpenDialog1.FileName;
  end;
end;

procedure TMainCalcForm.CreateSkinVariables;
begin
  MainBitMap:=TBitMap.Create;
  TempBitMap:=TBitMap.Create;
  MemoryStream:=TMemoryStream.Create;
  MouseDown:=false;
  PrevLightCod:=-1;
end;

procedure TMainCalcForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Point:Windows.TPoint;
begin
  if FUseSkin then begin
    if PrevLightCod=-1 then begin
      MouseDown:=true;
      GetCursorPos(Point);
      Self.x:=Point.x;
      Self.y:=Point.y;
      Canvas.Draw(0,0,MainBitMap);
    end else begin
      DrawBitMap(ButtonInfos[ButtonIndex].SelectRegion,
        ButtonInfos[ButtonIndex].SelectBitMap);
      PressedButtonIndex:=ButtonIndex;
//      PressCalcButton(ButtonIndex);
    end;
  end;
end;

procedure TMainCalcForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  dx,dy:integer;
  Point:Windows.TPoint;
begin
  if FUseSkin then begin
    if MouseDown then begin
      GetCursorPos(Point);
      dx:=Point.x-Self.x;
      dy:=Point.y-Self.y;
      Left:=Left+dx;
      Top:=Top+dy;
      Self.x:=Point.x;
      Self.y:=Point.y;
    end else begin
      Point.x:=x;
      Point.y:=y;
      DrawLite(Point,false);
    end;
  end;
end;

procedure TMainCalcForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  dx,dy:integer;
  Point:Windows.TPoint;
begin
  if FUseSkin then begin
    if MouseDown then begin
      GetCursorPos(Point);
      dx:=Point.x-Self.x;
      dy:=Point.y-Self.y;
      Left:=Left+dx;
      Top:=Top+dy;
      MouseDown:=false;
    end;
    if PressedButtonIndex<>-1 then begin
      PressCalcButton(PressedButtonIndex);
      Canvas.Draw(0,0,MainBitMap);
    end;
    if PrevLightCod<>-1 then begin
      Point.x:=x;
      Point.y:=y;
      DrawLite(Point,true);
    end;
    PressedButtonIndex:=-1;
  end;
end;

procedure TMainCalcForm.Exit2Click(Sender: TObject);
begin
  PrevLightCod:=bt_File;
  Close;
end;

procedure TMainCalcForm.Cut3Click(Sender: TObject);
begin
  PrevLightCod:=bt_Edit;
  ExpressionMemo.CutToClipboard;
end;

procedure TMainCalcForm.Copy3Click(Sender: TObject);
begin
  PrevLightCod:=bt_Edit;
  ExpressionMemo.CopyToClipboard;
end;

procedure TMainCalcForm.Paste3Click(Sender: TObject);
begin
  PrevLightCod:=bt_Edit;
  ExpressionMemo.PasteFromClipboard;
end;

procedure TMainCalcForm.Delete2Click(Sender: TObject);
begin
  PrevLightCod:=bt_Edit;
  DeleteExpressionMemoSelection;
end;

procedure TMainCalcForm.Variables3Click(Sender: TObject);
begin
  PrevLightCod:=bt_View;
  Variables1Click(nil);
end;

procedure TMainCalcForm.Normal1Click(Sender: TObject);
begin
  PrevLightCod:=bt_View;
  NormalMnuClick(nil);
end;

procedure TMainCalcForm.LoadSkin2Click(Sender: TObject);
begin
  PrevLightCod:=bt_View;
  LoadSkin1Click(nil);
end;

procedure TMainCalcForm.Functions3Click(Sender: TObject);
begin
  PrevLightCod:=bt_Help;
  Functions1Click(nil);
end;

procedure TMainCalcForm.About3Click(Sender: TObject);
begin
  PrevLightCod:=bt_Help;
  ShowAbout;
end;

procedure TMainCalcForm.Registration3Click(Sender: TObject);
begin
  PrevLightCod:=bt_Help;
  InputRegCod;
end;

procedure TMainCalcForm.ExpressionMemoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  FormMouseMove(nil,Shift,0,0);
end;

procedure TMainCalcForm.NormalMnuClick(Sender: TObject);
begin
  AutoScroll:=false;
  UseSkin:=false;
  Refresh;
  Invalidate;
  Width:=Round(Gold*(Height-(Height-ClientHeight)))+(Width-ClientWidth);
  RecountControlSizes;
end;

procedure TMainCalcForm.Saveexpression2Click(Sender: TObject);
var
  Strings:TStrings;
begin
  SaveDialog1.Filter:='Expression files|*.exp|All Files|*.*';
  SaveDialog1.DefaultExt:='.exp';
  if SaveDialog1.Execute then begin
    Strings:=TStringList.Create;
    try
      Strings.AddStrings(ExpressionMemo.Lines);
      CalcButtonClick(nil);
      Strings.Add('Result:');
      Strings.AddStrings(ResultMemo.Lines);
      Strings.SaveToFile(SaveDialog1.FileName);
    finally
      Strings.Free;
    end;
  end;

end;

procedure TMainCalcForm.Loadexpression2Click(Sender: TObject);
var
  Strings:TStrings;
  i,i1,n:integer;
begin
  OpenDialog1.Filter:='Expression files|*.exp|All Files|*.*';
  OpenDialog1.DefaultExt:='.exp';
  if OpenDialog1.Execute then begin
    ExpressionMemo.Lines.Clear;
    ResultMemo.Lines.Clear;
    Strings:=TStringList.Create;
    try
      Strings.LoadFromFile(OpenDialog1.FileName);
      n:=Strings.Count-1;
      for i:=0 to n do
        if Strings[i]<>'Result:' then
          ExpressionMemo.Lines.Add(Strings[i])
        else begin
          i1:=i+1;
          break;
        end;
      for i:=i1 to n do
        ResultMemo.Lines.Add(Strings[i]);
    finally
      Strings.Free;
    end;
  end;
end;

procedure TMainCalcForm.SetFuncListBoxSize;
begin
  FuncListBox.Left:=ResultMemo.Left;
  FuncListBox.Top:=ResultMemo.Top;
  FuncListBox.Width:=ResultMemo.Width;
  FuncListBox.Height:=ResultMemo.Height;
end;

procedure TMainCalcForm.SetEditOptions;
begin
  with Options do begin
    SetFont(ExpressionMemo.Font,Fonts[0]);
    SetFont(ResultMemo.Font,Fonts[1]);
    SetFont(FuncsTreeView.Font,Fonts[2]);
    ExpressionMemo.Color:=Fonts[0].BackColor;
    ResultMemo.Color:=Fonts[1].BackColor;
    FuncsTreeView.Color:=Fonts[2].BackColor;
  end;
end;

procedure TMainCalcForm.SetFont(const Font: TFont; FontInfo: TFontInfo);
begin
  Font.Size:=FontInfo.Size;
  Font.Color:=FontInfo.Color;
  Font.Style:=FontInfo.Style;
  Font.Name:=FontInfo.Name;
end;

procedure TMainCalcForm.FuncsTreeViewEnter(Sender: TObject);
begin
  FuncsTreeViewChange(nil,FuncsTreeView.Selected);
end;

function TMainCalcForm.TestBadCodes: boolean;
var
  i,j,n,m:integer;
begin
  m:=15;
  result:=true;
  n:=Length(BadCodes)-1;
  for i:=0 to n do begin
    result:=true;
    for j:=0 to m do begin
      Result:=Result and (BadCodes[i,j]=RegCod[j]);
    end;
    if Result then
      exit;
  end;
end;

end.
