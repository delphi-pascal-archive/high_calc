unit UnlimitedInt;

interface
uses
  Dialogs,SysUtils,Math;
type
TUnlimitedIntegerBuf=array of LongWord;
TLongWordArr=array[0..100] of LongWord;
PLongWordArr=^TLongWordArr;
TByteArray=array[0..1000] of byte;
PByteArray=^TByteArray;
TUnlimitedInteger=class
private
  Buf:TUnlimitedIntegerBuf;
    FOverflow: boolean;
    FSigned: boolean;
  function GetHexStr: string;
  procedure SetHexStr(Value: string);
  function HexToByte(c:char):byte;
  function ByteToHex(b:byte):char;
  function GetDecStr: string;
  procedure SetDecStr(const Value: string);
  function LongWordToDec(Value:LongWord):string;
  procedure SetSign(Value:boolean);
  function GetSign: boolean;
  procedure SetDecSignStr(Value: string);
  function GetDecSignStr: string;
  procedure SetPrecision(const Value: Longword);
  function GetPrecision: Longword;
  procedure RoundAsFraction(Size: integer; var Overflow: boolean);
  procedure SetOverflow(const Value: boolean);
  procedure SetSigned(const Value: boolean);
  function GetFractionHexStr: string;
  procedure SetFractionHexStr(Value: string);
public
  property HexStr:string read GetHexStr write SetHexStr;
  property FractionHexStr:string read GetFractionHexStr write SetFractionHexStr;
  property DecStr:string read GetDecStr write SetDecStr;
  property DecSignStr:string read GetDecSignStr write SetDecSignStr;
  property Sign:boolean read GetSign write SetSign;
  property Precision:Longword read GetPrecision write SetPrecision;
  property Overflow: boolean read FOverflow write SetOverflow;
  property Signed:boolean read FSigned write SetSigned;
  procedure Plus (Value:TUnlimitedInteger);overload;
  procedure Plus (Value:integer);overload;
  procedure Multiply (Value:TUnlimitedInteger);overload;
  procedure Multiply (Value:integer);overload;
  procedure Substract (Value:TUnlimitedInteger);overload;
  procedure Substract (Value:integer);overload;
  procedure Divide (Value:TUnlimitedInteger;
    Remainder:TUnlimitedInteger);overload;
  procedure Divide (Value:integer;var Remainder:LongWord);overload;
//  procedure Let(var Value:TUnlimitedInteger);
  procedure Let(Value:TUnlimitedInteger);Overload;
  procedure Let(Value:integer);Overload;
  function LoInteger:integer;
  function GetBuf:TUnlimitedIntegerBuf;
  function Zero:boolean;
  procedure Optimize;
  procedure Abs;
  procedure BitNot;
  procedure DelZeroes(var s:string);
  function Comparison(Value:TUnlimitedInteger):Shortint;overload;
  function Comparison(Value:Integer):Shortint;overload;
  {Self>Value=>1;Self<Value=>-1;Self=Value=>0}
  constructor Create(Value:TUnlimitedInteger=nil);overload;
  constructor Create(Value:integer);overload;
  procedure Round(Size:integer;var Overflow:boolean);
  function TruncPrevZeros:integer;
  function TruncPostZeros:integer;
end;
implementation

{ TUnlimitedInteger }

procedure TUnlimitedInteger.Abs;
begin
  if Sign then begin
    BitNot;
    Substract(1);
  end else
end;

function TUnlimitedInteger.ByteToHex(b: byte): char;
begin
  if b<10 then
    result := char(b+byte('0'))
  else if b<16 then
    result := char(b-10+byte('A'))
  else
    raise Exception.Create('Величина '+IntToStr(b)+
            ' не может быть выражена шестнадцатеричной цифрой');
end;

procedure TUnlimitedInteger.Divide(Value: TUnlimitedInteger;
  Remainder:TUnlimitedInteger);
label
  D2,D4,D6,D7,D8,L1,L2,L3,LoopI,LoopJ,DecB,TestQ,ResReady,Decq,MulSubL,BegLoop;
var
  x,x1:PLongWordArr;
  y,y1:PLongWordArr;
  q:PLongWordArr;
  r:PLongWordArr;
  ZBuf,X1Buf,Y1Buf:TUnlimitedIntegerBuf;
  n,m,n4,m4:integer;
  MinJ:LongWord;
  k:LongWord;
  rr:LongWord;
  d:LongWord;
  sr:boolean;
begin
  sr:=sign xor Value.Sign;
  Sign:=false;
  Value.Sign:=false;
  n:=Length(Value.Buf);
  if n=1 then begin
    Divide(Value.Buf[0],rr);
    SetLength(Remainder.Buf,1);
    Remainder.Buf[0]:=rr;
    exit;
  end;
  m:=Length(Buf);
  SetLength(ZBuf,m+1);
  SetLength(X1Buf,m+1);
  SetLength(Y1Buf,n);
  SetLength(Remainder.Buf,n);
  x:=@Buf[0];
  y:=@Value.Buf[0];
  x1:=@X1Buf[0];
  y1:=@Y1Buf[0];
  q:=@ZBuf[0];
  r:=@Remainder.Buf[0];
  n4:=n shl 2;
  m4:=m shl 2;
  asm
                push Ecx
                push Ebx
                push Edi
                push esi
                push edx
                push eax

                Mov     ECX,y
                Add     ECX,n4
                Cmp     DWord ptr [ECX-4],$FFFFFFFF
                je      D2
                Xor     EAX,EAX
                Mov     EDX,1
                Mov     EBX,DWord ptr [ECX-4]//(Vn-1)
                Inc     EBX
                Div     EBX
                Mov     EBX,EAX //d=b/((Vn-1)+1)
                Mov     d,EBX

                Mov     ESI,x
                Mov     EDI,x1
                Mov     ECX,ESI
                Add     ECX,m4
                Sub     ECX,4
    L1:
                Mov     EAX,[ESI]//U
                Mul     EBX
                Add     [EDI],EAX
                Adc     [EDI+4],EDX
                Add     ESI,4
                Add     EDI,4
                Cmp     ESI,ECX
                Jbe     l1

                Mov     ESI,y
                Mov     EDI,y1
                Mov     ECX,ESI
                Add     ECX,n4
                Sub     ECX,8
    L2:
                Mov     EAX,[ESI]//V
                Mul     EBX
                Add     [EDI],EAX
                Adc     [EDI+4],EDX
                Add     ESI,4
                Add     EDI,4
                Cmp     ESI,ECX
                Jbe     l2
                Mov     EAX,[ESI]
                Mul     EBX
                Add     [EDI],EAX
    D2:
                Mov     ESI,x1
                Mov     EAX,ESI
                Add     ESI,m4
                Add     EAX,n4
                Mov     MinJ,EAX
    LoopI:
                Mov     EDX,[ESI]//Uj+n
                Mov     EDI,y1
                Add     EDI,n4
                Mov     EBX,[EDI-4]
                Cmp     EBX,EDX
                Jbe     DecB //<=
                Mov     EAX,[ESI-4]//Uj+n-1
                Div     EBX
    TestQ:
                Mov     ECX,EAX//q^;EDX=r^
                Mul     DWord ptr [EDI-8]//q^*Vn-2
                Cmp     EDX,EBX
                Ja      Decq//>
                jb      ResReady//<
                Cmp     EAX,[ESI-8]
                Ja      Decq//>
    ResReady:
                Mov     EAX,ECX
                Jmp     D4
    Decq:
                Dec     ECX
                Mov     EAX,ECX
                Add     EDX,[EDI-4]
                Jc      D4
                Jmp     TestQ
    DecB:
                Mov     EAX,$FFFFFFFF //b-1
    D4:
                Push    ESI//j
                Sub     ESI,n4
                Mov     EBX,y1
                Xor     ECX,ECX
                Mov     k,ECX
                Mov     EDI,EAX//q
    MulSubL:    Mov     EAX,[EBX+ECX]
                Mul     EDI
                Add     EAX,k
                Adc     EDX,0
                Sub     [ESI+ECX],EAX
                Adc     EDX,0
                Mov     k,EDX
                Add     ECX,4
                cmp     ECX,n4
                jb      MulSubL
                Add     ECX,ESI
                Sub     ESI,x1
                Add     ESI,q
                Mov     [ESI],EDI//qj
                Mov     EAX,k
                Sub     [ECX],EAX
                Jc      D6
    D7:
                Pop     ESI //j
                Sub     ESI,4
                Cmp     ESI,MinJ
                Jae     LoopI//>=
                Jmp     D8
    D6:
                Dec     DWord ptr [ESI]
                Mov     EDI,y1
                Pop     ESI//j
                Push    ESI
                Sub     ESI,n4
                Xor     ECX,ECX
                clc
                Lahf
    L3:
                Sahf
                Mov     EAX,[EDI+ECX]
                Adc     [ESI+ECX],EAX
                Lahf
                Add     ECX,4
                cmp     ECX,n4
                jb      L3//<
                Xor     EDI,EDI
                Sahf
                Adc     [ESI+ECX],EDI
                Jmp     D7
    D8:
                Mov     ECX,n
                dec     ECX
                Shl     ECX,2
                Mov     ESI,x1//U
                Mov     EDI,d
                Mov     EBX,r
                Xor     EDX,EDX
                clc
 BegLoop:
                Mov     EAX,[ESI+ECX]
                Div     EDI
                Mov     [EBX+ECX],EAX
                Sub     ECX,4
                jae     BegLoop //>=
                Mov     rr,EDX
                pop eax
                pop edx
                pop esi
                pop edi
                pop ebx
                pop ecx

  end;
  if rr > 0 then
    raise Exception.Create('Внутренняя ошибка');
  SetLength(ZBuf,m);//todo : Проверить
  Buf:=ZBuf;
  Sign:=sr;
end;

procedure TUnlimitedInteger.Divide(Value: integer;var Remainder:LongWord);
label
  BegLoop;
var
  x:PLongWordArr;
  z:PLongWordArr;
  Quotient:TUnlimitedIntegerBuf;
  y:LongWord;
  r:LongWord;
  n:integer;
  sr:boolean;
begin

  sr:=sign xor (Value<0);
  Sign:=false;
  Value:=System.Abs(Value);
  n:=Length(Buf);
  SetLength(Quotient,n);
  x:=@Buf[0];
  y:=Value;
  z:=@Quotient[0];
  asm
                push Ecx
                push Ebx
                push Edi
                push esi
                push edx
                push eax
                Mov ECX,n
                dec ECX
                Shl ECX,2
                Mov EBX,x
                Mov EDI,y
                Mov ESI,z
                Xor EDX,EDX
                clc
 BegLoop:
                Mov EAX,[EBX+ECX]
                Div EDI
                Mov [ESI+ECX],EAX
                Sub ECX,4
                jae BegLoop //>=
                Mov r,EDX
                pop eax
                pop edx
                pop esi
                pop edi
                pop ebx
                pop ecx
  end;
  Buf:=Quotient;
  Remainder:=r;
  Sign:=sr;
end;

function TUnlimitedInteger.GetDecStr: string;
const
  MaxDecInt=1000000000;
var
  TmpBuf:TUnlimitedIntegerBuf;
  n:integer;
  Remainder:LongWord;
begin
  n:=Length(Buf);
  SetLength(TmpBuf,n);
  Move(Buf[0],TmpBuf[0],n shl 2);
  result:='';
  while not Zero do begin
    Divide(MaxDecInt,Remainder);
//    result:=IntToStr(Remainder)+result;
    result:=Format('%.9d',[Remainder])+result;
  end;
  DelZeroes(result);
  Buf:=TmpBuf;
end;

function TUnlimitedInteger.GetHexStr: string;
var
  n,l,i,j:integer;
  PBuf:PByteArray;
  Value:string;
begin
  n:=length (Buf);
  l:=n shl 3;
  SetLength(Value,l);
  PBuf:=@Buf[0];
  j:=(n shl 2)-1;
  for i:=1 to l do
    if i and 1 = 1 then
      Value[i]:=ByteToHex(PBuf[j] shr 4)
    else begin
      Value[i]:=ByteToHex(PBuf[j] and $F);
      dec(j);
    end;
  for i:=1 to l do
    if Value[i]='0' then
      Value[i]:=' '
    else
      break;
  Value:=trim(Value);
  if (Value='') and (n>0) then
    Value:='0';
  result:=Value;
end;

function TUnlimitedInteger.HexToByte(c: char): byte;
begin
  if (c>='0')and(c<='9') then
    result:=byte(c)-byte('0')
  else begin
    c:=UpperCase(c)[1];
    if (c>='A')and(c<='F') then
      result:=byte(c)-byte('A')+10
    else
      raise Exception.Create('Символ '+c+
        ' не является шестнадцатеричной цифрой');
  end;
end;

function TUnlimitedInteger.LongWordToDec(Value: LongWord): string;
label
  BegLoop;
var
  r:string;
  pr:PChar;
begin
  SetLength(r,10);
  FillChar(r[1],10,Ord(' '));
  pr:=@r[1];
  asm
                push EAX
                push EBX
                push ECX
                push EDX
                push ESI
                push EDI

                Mov     ECX,9
                Mov     ESI,pr
                Mov     EDI,$30//'0'=$30
                Mov     EAX,Value
                Mov     EBX,10
    BegLoop:    Xor     EDX,EDX
                Div     EBX
                Add     EDX,EDI
                Mov     [ESI+ECX],DL
                Dec     ECX
                Cmp     EAX,0
                Jnz     BegLoop

                pop EDI
                pop ESI
                pop EDX
                pop ECX
                pop EBX
                pop EAX
  end;
  result:=Trim(r);
end;

procedure TUnlimitedInteger.Multiply(Value: TUnlimitedInteger);
label
  LoopI,LoopJ;
var
  x:PLongWordArr;
  y:PLongWordArr;
  z:PLongWordArr;
  ZBuf:TUnlimitedIntegerBuf;
  n,m,n4,m4:integer;
  sr:boolean;
  ValueSign:boolean;
begin
  sr:=sign xor Value.Sign;
  Sign:=false;
  ValueSign:=Value.Sign;
  Value.Sign:=false;
  n:=Length(Buf);
  m:=Length(Value.Buf);
  SetLength(ZBuf,n+m);
  x:=@Buf[0];
  y:=@Value.Buf[0];
  z:=@ZBuf[0];
  n4:=n shl 2;
  m4:=m shl 2;
  asm
                push EAX
                push EBX
                push ECX
                push EDX
                push ESI
                push EDI

                Xor ESI,ESI
                Mov EDX,n
                SHL EDX,2
                Mov n4,EDX
 LoopJ:
                Xor ECX,ECX
                Xor EDI,EDI
 LoopI:
                Mov EBX,x
                Mov EAX,[EBX+ECX]
                mov EBX,y
                Mul Dword ptr [EBX+ESI]
                mov EBX,z
                Add EBX,ESI
                Add EAX,[EBX+ECX]
                Adc EDX,0
                Add EAX,EDI
                Adc EDX,0
                Mov [EBX+ECX],EAX
                Mov EDI,EDX
                Add ECX,4
                Cmp ECX,n4
                jne LoopI
                Mov [EBX+ECX],EDI

                Add ESI,4
                Cmp ESI,m4
                jne LoopJ

                pop EDI
                pop ESI
                pop EDX
                pop ECX
                pop EBX
                pop EAX
  end;
  Buf:=ZBuf;
  Sign:=sr;
  Value.Sign:=ValueSign;
end;

procedure TUnlimitedInteger.Plus(Value: TUnlimitedInteger);
label
  BegLoop;
var
  x:PLongWordArr;
  y:PLongWordArr;
  n,m:integer;
  a:byte;
  Sx,Sy:boolean;
begin
  n:=Length(Buf);
  m:=Length(Value.Buf);
  if n>m then
    SetLength(Value.Buf,n)
  else if n<m then begin
    SetLength(Buf,m);
    n:=m;
  end;
  Sx:=Sign;
  Sy:=Value.Sign;
  x:=@Buf[0];
  y:=@Value.Buf[0];
  asm
                push EBX
                push EAX
                push EBP
                push ECX
                push EDX

                Xor ECX,ECX
                Mov EDX,n
                Mov EBX,x
                Mov EBP,y
                SHL EDX,2
                clc
                Lahf

 BegLoop:
                Sahf
                Mov EAX,[EBX+ECX]
                Adc EAX,[EBP+ECX]
                Mov [EBX+ECX],EAX
                Lahf
                Add ECX,4
                Cmp ECX,EDX
                jne BegLoop

                and AH,1
                pop EDX
                pop ECX
                pop EBP
                mov a,ah
                pop EAX
                pop EBX
  end;
  if Sx and Sy and not(Sign) then
    raise Exception.Create('Ошибка - переполнение')
  else
    if not Sx and not Sy and Sign then
      raise Exception.Create('Ошибка - переполнение')


{  if (a and 1)=1 then begin
    SetLength(Buf,n+1);
    Buf[n]:=1;
  end;}
end;

procedure TUnlimitedInteger.SetDecStr(const Value: string);
begin
  SetDecSignStr(Value);
end;

procedure TUnlimitedInteger.SetHexStr(Value: string);
var
  n,m,l,i,j:integer;
  PBuf:PByteArray;
begin
  Value:=Trim(Value);
  l:=length (Value);
  n:=l div 8;
  m:=l mod 8;
  if m > 0 then
    inc(n);
  Buf:=nil;
  SetLength(Buf,n);
  PBuf:=@Buf[0];
  j:=0;
  n:=l-1;
  for i:=0 to n do
  begin
    if i and 1 = 1 then begin
      PBuf[j]:=PBuf[j]+HexToByte(Value[l-i])shl 4;
      inc(j)
    end else
      PBuf[j]:=HexToByte(Value[l-i]);
  end;
end;

function TUnlimitedInteger.GetSign: boolean;
begin
  if Buf<>nil then
    result:=(Buf[length(Buf)-1]shr 31)=1
  else
    Raise Exception.Create('Buf=nil при определении знака');  
end;

procedure TUnlimitedInteger.Substract(Value: TUnlimitedInteger);
label
  BegLoop;
var
  x:PLongWordArr;
  y:PLongWordArr;
  n,m:integer;
  a:byte;
begin
  n:=Length(Buf);
  m:=Length(Value.Buf);
  if n>m then
    SetLength(Value.Buf,n)
  else if n<m then begin
    SetLength(Buf,m);
    n:=m;
  end;
  x:=@Buf[0];
  y:=@Value.Buf[0];
  asm
                push EBX
                push EAX
                push EBP
                push ECX
                push EDX

                Xor ECX,ECX
                Mov EDX,n
                Mov EBX,x[0]
                Mov EBP,y[0]
                SHL EDX,2
                clc
                Lahf

 BegLoop:
                Sahf
                Mov EAX,[EBX+ECX]
                Sbb EAX,[EBP+ECX]
                Mov [EBX+ECX],EAX
                Lahf
                Add ECX,4
                Cmp ECX,EDX
                jne BegLoop

                pop EDX
                pop ECX
                pop EBP
                mov a,ah
                pop EAX
                pop EBX
  end;
{  if (a and 1) = 1 then begin
    SetLength (Buf,n+1);
    Buf[n]:=1;
  end;}
end;

function TUnlimitedInteger.Zero: boolean;
var
  i,n:integer;
begin
  result:=true;
  n:=Length(Buf)-1;
  for i:=0 to n do
    if Buf[i]<>0 then begin
      result:=false;
      exit;
    end;
end;

procedure TUnlimitedInteger.Substract(Value: integer);
label
  BegLoop,EndProc;
var
  x:PLongWordArr;
  n:integer;
begin
  n:=Length(Buf);
  x:=@Buf[0];
  asm
                push EAX
                push EBX
                push ECX
                push EDX
                push ESI
                push EDI

                Mov EBX,x
                Mov EAX,[EBX]
                Sub EAX,Value
                Mov [EBX],EAX
                jnc EndProc
                Lahf
                Mov ECX,4
                Cmp ECX,EDX
                je EndProc
                Mov EDX,n
                SHL EDX,2
 BegLoop:
                Sahf
                Mov EAX,[EBX+ECX]
                Sbb EAX,0
                Mov [EBX+ECX],EAX
                jnc EndProc
                Lahf
                Add ECX,4
                Cmp ECX,EDX
                jne BegLoop
  EndProc:
                pop EDI
                pop ESI
                pop EDX
                pop ECX
                pop EBX
                pop EAX
  end;
end;

procedure TUnlimitedInteger.BitNot;
label
  BegLoop;
var
  x:PLongWordArr;
  n:integer;
begin
  n:=Length(Buf);
  x:=@Buf[0];
  asm
                push EAX
                push EBX
                push ECX
                push EDX

                Mov EBX,x
                Xor ECX,ECX
                Mov EDX,n
                SHL EDX,2
 BegLoop:
                Mov EAX,[EBX+ECX]
                Not EAX
                Mov [EBX+ECX],EAX
                Add ECX,4
                Cmp ECX,EDX
                jne BegLoop

                pop EDX
                pop ECX
                pop EBX
                pop EAX
  end;
end;

procedure TUnlimitedInteger.Let(Value: TUnlimitedInteger);
var
  n:integer;
begin
  FSigned:=true;
  if Value<>nil then begin
    n:=Length(Value.Buf);
    if n>0 then begin
      SetLength(Buf,n);
      Move(Value.Buf[0],Buf[0],n*SizeOf(LongWord));
    end else
      Raise Exception.Create('Буфер пустой');
    FSigned:=Value.Signed;
  end else
    Raise Exception.Create('Присвоение TUnlimitedInteger = nil');
end;

{procedure TUnlimitedInteger.Let(var Value: TUnlimitedInteger);
begin
  if Value=nil then
    Value:=TUnlimitedInteger.Create(Self)
  else
    Value.Create(Self);
end;
}
constructor TUnlimitedInteger.Create(Value: TUnlimitedInteger);
begin
  inherited Create;
  if Value<>nil then
    Let(Value);
end;

procedure TUnlimitedInteger.SetSign(Value:boolean);
begin
  if Buf=nil then
    Raise Exception.Create('Buf=nil при установке знака');
  if GetSign=Value then
    exit;
  if (not Value)and (Buf[Length(Buf)-1]=$80000000) then
    Raise Exception.Create('Переполнение при установке знака');
  BitNot;
  Plus(1);
end;

procedure TUnlimitedInteger.Plus(Value: integer);
label
  BegLoop,EndProc;
var
  x:PLongWordArr;
  n:integer;
  o:byte;
begin
  n:=Length(Buf);
  x:=@Buf[0];
  asm
                push EAX
                push EBX
                push ECX
                push EDX
                push ESI
                push EDI

                Mov EBX,x
                Mov EAX,[EBX]
                Add EAX,Value
                Mov [EBX],EAX
                jnc EndProc
                Lahf
                Mov ECX,4
                Cmp ECX,EDX
                je EndProc
                Mov EDX,n
                SHL EDX,2
 BegLoop:
                Sahf
                Mov EAX,[EBX+ECX]
                Adc EAX,0
                Mov [EBX+ECX],EAX
                jnc EndProc
                Lahf
                Add ECX,4
                Cmp ECX,EDX
                jne BegLoop
  EndProc:      Sahf
                mov     o,ah
                pop EDI
                pop ESI
                pop EDX
                pop ECX
                pop EBX
                pop EAX
  end;
  Overflow:=(o and 1)>0;//todo:Определить флаг переноса
end;

procedure TUnlimitedInteger.SetDecSignStr(Value: string);
const
  MaxDecInt=1000000000;
  MaxDecIntLen=9;
var
  n,m,BufLen,i:integer;
  s:boolean;
  v:LongWord;
  k:integer;
begin
  s:=Value[1]='-';
  if s then
    Value:=Copy(Value,2,Length(Value));
  n:=Length(Value);
  m:=n mod MaxDecIntLen;
  BufLen:=n div MaxDecIntLen;
  n:=BufLen;
  v:=0;
  if m>0 then begin
    inc(BufLen);
    v:=StrToInt(Copy(Value,1,m));
    k:=m+1;
  end else
    k:=1;
  SetLength(Buf,BufLen);
  FillChar(Buf[0],BufLen,0);
  Buf[0]:=v;
  for i:=1 to n do begin
    Multiply(MaxDecInt);
    v:=StrToInt(Copy(Value,k,MaxDecIntLen));
    inc(k,MaxDecIntLen);
    Plus(v);
  end;
  Optimize;
  Sign:=s;
end;

function TUnlimitedInteger.GetDecSignStr: string;
const
  MaxDecInt=1000000000;
var
  TmpBuf:TUnlimitedIntegerBuf;
  n:integer;
  Remainder:LongWord;
  s:boolean;
begin
  n:=Length(Buf);
  SetLength(TmpBuf,n);
  Move(Buf[0],TmpBuf[0],n shl 2);
  result:='';
  s:=Sign;
  if s then
    Sign:=false;
  while not Zero do begin
    Divide(MaxDecInt,Remainder);
    //result:=IntToStr(Remainder)+result;
    result:=Format('%.9d',[Remainder])+result;
  end;
  DelZeroes(result);
  if s then
    result:='-'+result;
  Buf:=TmpBuf;
end;

procedure TUnlimitedInteger.Multiply(Value: integer);
label
  LoopI,LoopJ;
var
  x:PLongWordArr;
  n,n4:integer;
  sr:boolean;
begin
  sr:=sign xor (Value<0);
  Sign:=false;
  Value:=System.Abs(Value);
  n:=Length(Buf);
  dec(n);
//  SetLength(Buf,n+1);
  x:=@Buf[0];
  asm
                push EAX
                push EBX
                push ECX
                push EDX
                push ESI
                push EDI

                Xor ESI,ESI
                Mov EDX,n
                SHL EDX,2
                Mov n4,EDX
                Mov EBX,x
                Mov EDI,Value
                Xor ECX,ECX
 LoopI:
                Mov EAX,[EBX+ESI]
                Mul EDI
                Add ECX,EAX
                Adc EDX,0
                Mov [EBX+ESI],ECX
                Mov ECX,EDX
                Add ESI,4
                Cmp ESI,n4
                jne LoopI
                Mov [EBX+ESI],ECX
                pop EDI
                pop ESI
                pop EDX
                pop ECX
                pop EBX
                pop EAX

  end;
  Sign:=sr;
end;

procedure TUnlimitedInteger.Optimize;
var
  i,n,k,m:integer;
  TempBuf:TUnlimitedIntegerBuf;
begin
  n:=Length(Buf);
  k:=n;
  m:=n-1;
  for i:=m downto 0 do begin
    if Buf[i]<>0 then
      break;
    dec(k);
  end;
  if k<>n then begin
    SetLength(TempBuf,k);
    Move(Buf[0],TempBuf[0],k shl 2);
    Buf:=TempBuf;
  end;
end;

procedure TUnlimitedInteger.DelZeroes(var s: string);
var
  i,n,k:integer;
begin
  k:=1;
  n:=Length(s);
  for i:=1 to n do begin
    if s[i]='0' then
      inc(k)
    else
      break;
  end;
  if k>1 then
    s:=Copy(s,k,n);
end;

function TUnlimitedInteger.Comparison(Value: TUnlimitedInteger): Shortint;
var{Self>Value=>1;Self<Value=>-1;Self=Value=>0}
  s1,s2:boolean;
  n,m,mm,i,r:integer;
  a,b:Longword;
begin
  result:=0;
  if Value.Sign and not Sign then begin
    result:=1;
    exit;
  end;
  if not Value.Sign and Sign then begin
    result:=-1;
    exit;
  end;
  n:=Length(Buf);
  m:=Length(Value.Buf);
  mm:=Max(n,m)-1;
  if Value.Sign then
    r:=-1
  else
    r:=1;
  for i:=mm downto 0 do begin
    if i<n then
      a:=Buf[i]
    else
      a:=0;
    if i<m then
      b:=Value.Buf[i]
    else
      b:=0;
    if a>b then begin
      result:=r;
      break;
    end;
    if a<b then begin
      result:=-r;
      break;
    end;
  end;
end;

function TUnlimitedInteger.Comparison(Value: Integer): Shortint;
var{Self>Value=>1;Self<Value=>-1;Self=Value=>0}
  s1,s2:boolean;
  n,i,r:integer;
  UnsignedValue:LongWord;
begin
  UnsignedValue:=System.Abs(Value);
  result:=0;
  if (Value<0) and not Sign then begin
    result:=1;
    exit;
  end;
  if (Value>0) and Sign then begin
    result:=-1;
    exit;
  end;
  if Length(Buf)>1 then begin
    if (UnsignedValue<Buf[0]) then begin
      if Sign then
        result:=-1
      else
        result:=1;
      exit;
    end
  end else begin
    if (Value<integer(Buf[0])) then begin
      if Sign then
        result:=-1
      else
        result:=1;
    end else if (Value>integer(Buf[0])) then begin
      if Sign then
        result:=1
      else
        result:=-1;
    end else
      result:=0;
    exit;
  end;
  n:=Length(Buf)-1;
  if Sign then
    r:=-1
  else
    r:=1;
  if (Buf[n] and $7FFFFFFF)>0 then begin//Сброшен знаковый бит у старшего байта
    result:=r;
    exit;
  end;
  dec(n);
  for i:=n downto 1 do begin
    if Buf[i]>0 then begin
      result:=r;
      exit;
    end;
  end;
  if Value>Buf[0] then begin
    if Sign then
      result:=1
    else
      result:=-1;
  end else
    result:=0;
end;

function TUnlimitedInteger.LoInteger: integer;
begin
  result:=Integer(Buf[0]);
end;

function TUnlimitedInteger.GetBuf: TUnlimitedIntegerBuf;
begin
  result:=Buf;
end;

procedure TUnlimitedInteger.SetPrecision(const Value: Longword);
begin
  SetLength(Buf,Value);
end;

function TUnlimitedInteger.GetPrecision: Longword;
begin
  result:=Length(Buf);
end;

procedure TUnlimitedInteger.RoundAsFraction(Size: integer;var Overflow:boolean);
begin

end;

function TUnlimitedInteger.TruncPostZeros: integer;
var
  n,i,k:integer;
  TempBuf:TUnlimitedIntegerBuf;
begin
  n:=Length(Buf)-1;
  k:=n+1;
  for i:=0 to n do
    if Buf[i]<>0 then begin
      k:=i;
      break;
    end;
  result:=k+1;
  SetLength(TempBuf,n-k+1);
  Move(Buf[k],TempBuf[0],(n-k+1)*SizeOf(LongWord));
  Buf:=TempBuf;
end;

function TUnlimitedInteger.TruncPrevZeros: integer;
var
  n,i,k:integer;
  TempBuf:TUnlimitedIntegerBuf;
begin
  n:=Length(Buf)-1;
  k:=0;
  for i:=n downto 0 do
    if Buf[i]<>0 then begin
      k:=i;
      break;
    end;
  result:=n-k;
  SetLength(TempBuf,k+1);
  Move(Buf[0],TempBuf[0],(k+1)*SizeOf(LongWord));
  Buf:=TempBuf;
end;

procedure TUnlimitedInteger.Round(Size: integer; var Overflow: boolean);
const
  b=$80000000;
var
  n:integer;
  s:boolean;
begin
  n:=Length(Buf);
  Overflow:=false;
  if n>Size then begin
    s:=Buf[n-Size-1]>=b;
    FillChar(Buf[0],(n-Size-1)*SizeOf(LongWord),0);
    TruncPostZeros;
    if s then begin
      Plus(1);
      Overflow:=FOverflow;
    end;  
  end;
end;

procedure TUnlimitedInteger.SetOverflow(const Value: boolean);
begin
  FOverflow := Value;
end;

procedure TUnlimitedInteger.SetSigned(const Value: boolean);
begin
  FSigned := Value;
end;

constructor TUnlimitedInteger.Create(Value: integer);
var
  n:integer;
begin
  inherited Create;
  FSigned:=true;
  Let(Value);
end;

procedure TUnlimitedInteger.Let(Value: integer);
begin
  FSigned:=true;
  SetLength(Buf,1);
  Move (Value,Buf[0],SizeOf(integer));
end;

function TUnlimitedInteger.GetFractionHexStr: string;
var
  n,l,i,j:integer;
  PBuf:PByteArray;
  Value:string;
begin
  n:=length (Buf);
  l:=n shl 3;
  SetLength(Value,l);
  PBuf:=@Buf[0];
  j:=(n shl 2)-1;
  for i:=1 to l do
    if i and 1 = 1 then
      Value[i]:=ByteToHex(PBuf[j] shr 4)
    else begin
      Value[i]:=ByteToHex(PBuf[j] and $F);
      dec(j);
    end;
  for i:=l downto 1 do
    if Value[i]='0' then
      Value[i]:=' '
    else
      break;
  Value:=trim(Value);
  if (Value='') and (n>0) then
    Value:='0';
  result:=Value;
end;

procedure TUnlimitedInteger.SetFractionHexStr(Value: string);
var
  n,m,l,i,j:integer;
  PBuf:PByteArray;
begin
  Value:=Trim(Value);
  l:=length (Value);
  n:=l div 8;
  m:=l mod 8;
  if m > 0 then
    inc(n);
  if Length(Buf)<n then
    Raise Exception.Create('Не хватает точности');
  PBuf:=@Buf[0];
  n:=Length(Buf)*4-1;
  j:=n;
  for i:=1 to l do
  begin
    if i and 1 = 1 then begin
      PBuf[j]:=HexToByte(Value[i])shl 4;
    end else begin
      PBuf[j]:=PBuf[j]+HexToByte(Value[i]);
      dec(j);
    end;  
  end;
end;


end.
