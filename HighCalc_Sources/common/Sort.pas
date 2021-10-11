unit Sort;

interface
type
  TCompare=function (P1,P2:Pointer):boolean;//p1^>p2^ = true
  TPointerArray=array of pointer;
procedure QSort(var Buf:TPointerArray;Compare:TCompare);
implementation
procedure QSort(var Buf:TPointerArray;Compare:TCompare);
  procedure QuickSort(var Buf: TPointerArray; iLo, iHi: Integer);
  var
    Lo, Hi: Integer;
    Mid,T:pointer;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := Buf[(Lo + Hi) div 2];
    repeat
      while Compare(Mid,Buf[Lo]) do
            Inc(Lo);
      while Compare(Buf[Hi],Mid) do
            Dec(Hi);
      if Lo <= Hi then
      begin
        T := Buf[Lo];
        Buf[Lo] := Buf[Hi];
        Buf[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(Buf, iLo, Hi);
    if Lo < iHi then QuickSort(Buf, Lo, iHi);
  end;
begin
  if Length(Buf)>0 then
      QuickSort(Buf, Low(Buf), High(Buf));
end;

end.
