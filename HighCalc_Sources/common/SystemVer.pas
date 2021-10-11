unit SystemVer;

interface
uses
  Windows,SysUtils;
function IsWinNT : boolean;
implementation

function IsWinNT : boolean;
var
  VI: TOSVersionInfo;
begin
  result := true;
  VI.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  if GetVersionEx(VI) then begin
    if VI.dwPlatformId = VER_PLATFORM_WIN32_NT then exit;
    result := false;
  end else
    RaiseLastWin32Error;
end;

end.
