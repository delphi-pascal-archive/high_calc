{текст библиотеки}
library SendKey;
uses
 WinTypes, WinProcs, Messages, CaptUnt;
const
 {пользовательские сообщения}
 wm_NextShow_Event = wm_User + 133;
 wm_PrevShow_Event = wm_User + 134;
 {handle для ловушки}
 HookHandle: hHook = 0;
var
 SaveExitProc : Pointer;
 f:System.Text;
{собственно ловушка}
function Key_Hook(Code: integer; wParam: Longint; lParam: Longint): Longint stdcall;
var
 H: HWND;
begin
 {если Code>=0, то ловушка может обработать событие}
 if (Code >= 0){and Not ChangeNumLock} then 
 begin
  Result:=0;
  {если 0, то система должна дальше обработать это событие}
  {если 1 - нет}
   {это те клавиши?}
//   if (wParam = VK_NumLock) and (lParam and $40000000 = 0)
   if (wParam in[VK_NumLock,VK_DOWN]) and (lParam and KF_UP = 0)
   then begin
     {ищем окно по имени класса и по заголовку}
     H := FindWindow('TMainCalcForm', MainFormCaption);
     {посылаем сообщение}
     if wParam = VK_NumLock then begin
//       WriteLn(f,'NumLock');
{       if Vis then
         SendMessage(H,WM_SYSCOMMAND,SC_Close,0)
       else}
         SendMessage(H, wm_ShowCalc_Event, wParam, lParam);
         Result:=1;
//       SendMessage(H,WM_SYSCOMMAND,SC_RESTORE,0);
//       v:=true;
     end else if wParam = VK_DOWN then begin
       SendMessage(H, wm_GotoHint_Event, wParam, lParam);
     end;
   end;
 end else
   {если Code<0, то нужно вызвать следующую ловушку}
   Result := CallNextHookEx(HookHandle,Code, wParam, lParam);
end;
(*
function Key_Hook(Code: integer; wParam: WPARAM; lParam: LPARAM):  LRESULT; stdcall;
var
 H: HWND;
 w:Smallint;
begin
 {если Code>=0, то ловушка может обработать событие}
 if Code >= 0 then
 begin
   {это те клавиши?}
   if ((wParam = VK_NUMLOCK)or(wParam = VK_SHIFT)) and (lParam and $40000000 = 0)
   then begin
     {ищем окно по имени класса и по заголовку}
     H := FindWindow('TForm1', 'XXX');
     {посылаем сообщение}
     if wParam = VK_SHIFT then begin
       w:=GetAsyncKeyState(VK_LShift);
       if w <0 then
         SendMessage(H, wm_NextShow_Event, 0, 0);

     end else
       SendMessage(H, wm_NextShow_Event, 0, 0);
       //SendMessage(H, wm_PrevShow_Event, 0, 0)
   end;
  {если 0, то система должна дальше обработать это событие}
  {если 1 - нет}
  Result:=0;
 end
 else
   {если Code<0, то нужно вызвать следующую ловушку}
   Result := CallNextHookEx(HookHandle,Code, wParam, lParam);
end;
*)
{при выгрузке DLL надо снять ловушку}
procedure LocalExitProc;
begin
 if HookHandle<>0 then
 begin
   UnhookWindowsHookEx(HookHandle);
   ExitProc := SaveExitProc;
   HookHandle:=0;
 end;
// CloseFile(f);
end;

exports
  Key_Hook;


{инициализация DLL при загрузке ее в память}
begin
 {устанавливаем ловушку}
// AssignFile(f,'c:\hook.txt');
// Rewrite(f);
 HookHandle := SetWindowsHookEx(wh_Keyboard, Key_Hook,
                                                   hInstance, 0);
 if HookHandle = 0 then
   MessageBox(0, 'Unable to set hook!', 'Error', mb_Ok)
 else begin
  SaveExitProc := ExitProc;
  ExitProc := @LocalExitProc;
 end;
// KeyUnhook;
end.

