{	Математические процедуры и функции, необходимые в работе }
{$N+}
{.$Define THD}
{$Define Delphi32}
Unit GpMath;

InterFace

Type	Matrix = Array [1..6,1..6] of Extended;
	Vector = Array [1..6] of Extended;
	IntVector = Array [1..6] of Integer;

Function  GpTrunc(const x : Extended):LongInt;

Function  GpDistance(const xs,ys,xf,yf : Extended):Extended;

Procedure Crout(var a : Matrix; n : Integer; var b,y : Vector; 
 var pivot : IntVector; var det : Extended);
{
Procedure WriteMatrix(var A : Matrix; n : Integer);
}
Procedure MultMatrixVector(var A : Matrix; n : Integer; var B,Res : Vector);

{	Вычисление угла отрезка }
Function GetAngle(x1,y1,x2,y2 : Single):Single;
{	Вычисление угла отрезка }
Function GetAngleI(x1,y1,x2,y2 : Integer):LongInt;
{	Вычисление угла отрезка }
Function GetAngleExt(x1,y1,x2,y2 : Extended):Extended;
{	Корни квадратного уравнения }
Procedure SqEq(A,B,C : Single; var X1,X2 : Single; var Ex : Boolean);

Function ArcSin(X : Single):Single;
Function ArcCos(X : Single):Single;
{	Максимальные и минимальные значения }
{	Перестановки чисел }

Function MaxI(X,Y : Integer):Integer;
Function MinI(X,Y : Integer):Integer;
Function MaxR(X,Y : Real):Real;
Function MinR(X,Y : Real):Real;
Function MaxD(X,Y : Double):Double;
Function MinD(X,Y : Double):Double;
Function MaxE(X,Y : Extended):Extended;
Function MinE(X,Y : Extended):Extended;
Function MaxS(X,Y : Single):Single;
Function MinS(X,Y : Single):Single;

Procedure SwapR(var X,Y : Real);
Procedure SwapS(var X,Y : Single);
Procedure SwapD(var X,Y : Double);
Procedure SwapE(var X,Y : Extended);

{ Изменение байтов в целом }
{$Ifndef Delphi32}
Function RevertInteger(x : Integer):Integer;
{$Else}
Function RevertInteger(x : SmallInt):SmallInt;
{$Endif}
Function RevertLongInt(L : LongInt):LongInt;

function Revert(var x : Integer):Integer;overload;

function Revert(var x : SmallInt):SmallInt;oVerload;

function MakeLongInt(H, L : Word) : LongInt;
{$Ifndef Delphi32}
  {-Constructs a LongInt from two Words}
  inline(
    $58/                     {pop ax  ;low word into AX}
    $5A);                    {pop dx  ;high word into DX}
{$Endif}
{$Ifndef Delphi32}
function MakeInteger(H, L : Byte): Integer;
  {-Constructs an integer from two bytes}
  inline(
    $58/                     {pop ax    ;low byte into AL}
    $5B/                     {pop bx    ;high byte into BL}
    $88/$DC);                {mov ah,bl ;high byte into AH}
{$Else}
function MakeInteger(H, L : Byte): SmallInt;
{$Endif}
function MakeWord(H, L : Byte) : Word;
{$Ifndef Delphi32}
  {-Constructs a word from two bytes}
  inline(
    $58/                     {pop ax    ;low byte into AL}
    $5B/                     {pop bx    ;high byte into BL}
    $88/$DC);                {mov ah,bl ;high byte into AH}
{$Endif}
{$Ifndef Delphi32}
function Array2Str(var A; Len : Byte) : string;
  {-Convert an array of char to a string}
  inline(
    $8C/$DB/                 {mov bx,ds ;save DS}
    $59/                     {pop cx    ;CX = Len}
    $30/$ED/                 {xor ch,ch}
    $5E/                     {pop si    ;ds:si => A}
    $1F/                     {pop ds}
    $5F/                     {pop di    ;es:di => result}
    $07/                     {pop es}
    $06/                     {push es   ;put the pointer back on the stack}
    $57/                     {push di}
    $FC/                     {cld       ;go forward}
    $88/$C8/                 {mov al,cl ;set the length byte}
    $AA/                     {stosb}
    $F2/$A4/                 {rep movsb ;move data into string}
    $8E/$DB);                {mov ds,bx ;restore DS}

function SwapWord(L : LongInt) : LongInt;
  {-Swap low- and high-order words of L}
  inline(
    $5A/                     {pop dx ;pop low word into DX}
    $58);                    {pop ax ;pop high word into AX}

function HiWord(L : LongInt) : Word;
  {-Return high-order word of L}
  inline(
    $58/                     {pop ax ;ignore low word}
    $58);                    {pop ax ;pop high word into AX}

function LoWord(L : LongInt) : Word;
  {-Return low-order word of L}
  inline(
    $58/                     {pop ax ;pop low word into AX}
    $5A);                    {pop dx ;ignore high word}

Function MaxW(X,Y : Word):Word;
inline(
 $58/
 $5B/
 $39/$C3/
 $76/$02/
 $89/$D8);

Function MinW(X,Y : Word):Word;
inline(
 $58/
 $5B/
 $39/$C3/
 $73/$02/
 $89/$D8);

Function MaxL(X,Y : LongInt):LongInt;
inline(
 $5B/		{pop bx	; cx:bx = Y}
 $59/		{pop cx }
 $58/		{pop ax ; dx:ax = X}
 $5A/		{pop dx }
 $39/$CA/	{cmp dx,cx	; compare high byte }
 $7F/$0A/	{jg  done2	; X>Y ?}
 $7C/$04/	{jl  less	; X<Y ?}
 $39/$D8/	{cmp ax,bx	; compare low byte }
 $73/$04/	{jae done2	; X>=Y ?}
		{less: }
 $89/$CA/	{mov dx,cx	; Y is greater }
 $89/$D8);	{mov ax,bx }
		{done2:}

Function MinL(X,Y : LongInt):LongInt;
inline(
 $5B/		{pop bx	; cx:bx = Y}
 $59/		{pop cx }
 $58/		{pop ax ; dx:ax = X}
 $5A/		{pop dx }
 $39/$CA/	{cmp dx,cx	; compare high byte }
 $7C/$0A/	{jl  done1	; X<Y ?}
 $7F/$04/	{jg  greater	; X>Y ?}
 $39/$D8/	{cmp ax,bx	; compare low byte }
 $76/$04/	{jbe done1	; X<=Y }
		{greater: }
 $89/$CA/	{mov dx,cx	; X is greater }
 $89/$D8);	{mov ax,bx }
		{done1:}

procedure ExchangeBytes(var I, J : Byte);
  {-Exchange bytes I and J}
  inline(
    $8C/$DB/                 {mov bx,ds       ;save DS}
    $5E/                     {pop si}
    $1F/                     {pop ds          ;DS:SI => J}
    $5F/                     {pop di}
    $07/                     {pop es          ;ES:DI => I}
    $8A/$04/                 {mov al,[si]     ;AL = J}
    $26/$86/$05/             {xchg al,es:[di] ;I = J, AL = I}
    $88/$04/                 {mov [si],al     ;J = I}
    $8E/$DB);                {mov ds,bx       ;restore DS}

procedure ExchangeWords(var I, J : Word);
  {-Exchange words I and J}
  inline(
    $8C/$DB/                 {mov bx,ds       ;save DS}
    $5E/                     {pop si}
    $1F/                     {pop ds          ;DS:SI => J}
    $5F/                     {pop di}
    $07/                     {pop es          ;ES:DI => I}
    $8B/$04/                 {mov ax,[si]     ;AX = J}
    $26/$87/$05/             {xchg ax,es:[di] ;I = J, AX = I}
    $89/$04/                 {mov [si],ax     ;J = I}
    $8E/$DB);                {mov ds,bx       ;restore DS}

procedure ExchangeIntegers(var I, J : Integer);
  {-Exchange words I and J}
  inline(
    $8C/$DB/                 {mov bx,ds       ;save DS}
    $5E/                     {pop si}
    $1F/                     {pop ds          ;DS:SI => J}
    $5F/                     {pop di}
    $07/                     {pop es          ;ES:DI => I}
    $8B/$04/                 {mov ax,[si]     ;AX = J}
    $26/$87/$05/             {xchg ax,es:[di] ;I = J, AX = I}
    $89/$04/                 {mov [si],ax     ;J = I}
    $8E/$DB);                {mov ds,bx       ;restore DS}


procedure ExchangeLongInts(var I, J : LongInt);
  {-Exchange LongInts I and J}
  inline(
    $8C/$DB/               {mov bx,ds       ;save DS}
    $5E/                   {pop si}
    $1F/                   {pop ds          ;DS:SI => J}
    $5F/                   {pop di}
    $07/                   {pop es          ;ES:DI => I}
    $FC/                   {cld}
    $26/$8B/$05/           {mov ax,es:[di]}
    $A5/                   {movsw}
    $89/$44/$FE/           {mov [si-2],ax}
    $8B/$04/               {mov ax,[si]}
    $26/$87/$05/           {xchg ax,es:[di]}
    $89/$04/               {mov [si],ax}
    $8E/$DB);              {mov ds,bx       ;restore DS}

procedure ExchangeStructs(var I, J; Size : Word);
  {-Exchange structures I and J. Useful in sorts}
  inline(
    $FC/                     {cld       ;go forward}
    $8C/$DA/                 {mov dx,ds       ;save DS}
    $59/                     {pop cx          ;CX = Size}
    $5E/                     {pop si}
    $1F/                     {pop ds          ;DS:SI => J}
    $5F/                     {pop di}
    $07/                     {pop es          ;ES:DI => I}
    $D1/$E9/                 {shr cx,1        ;move by words}
    $E3/$0C/                 {jcxz odd}
    $9C/                     {pushf}
                             {start:}
    $89/$F3/                 {mov bx,si}
    $26/$8B/$05/             {mov ax,es:[di]  ;exchange words}
    $A5/                     {movsw}
    $89/$07/                 {mov [bx],ax}
    $E2/$F6/                 {loop start      ;again?}
    $9D/                     {popf}
                             {odd:}
    $73/$07/                 {jnc exit}
    $8A/$04/                 {mov al,[si]     ;exchange the odd bytes}
    $26/$86/$05/             {xchg al,es:[di]}
    $88/$04/                 {mov [si],al}
                             {exit:}
    $8E/$DA);                {mov ds,dx       ;restore DS}
{$Endif}
Implementation
{Uses GOutf;}
{$Ifdef Delphi32} Uses Windows; {$Endif}

{$Ifdef THD}
var Outf : Text;

Procedure OpF;
begin
 {$I-} Assign(Outf,'tt.txt'); Append(Outf);
  If IOResult<>0 then Rewrite(Outf);
  If IOResult<>0 then Halt(1);
 {$I+}
end;

Procedure CF;
begin
 Close(Outf);
end;
{$Endif}

Function  GpTrunc(const x : Extended):LongInt;
begin
   If x<0 then
    GpTrunc:=-Trunc(Abs(x))-1 else
    GpTrunc:=Trunc(x);
end;

{$Ifndef Delphi32}
Function MaxI(X,Y : Integer):Integer;
begin
 asm
	mov ax,X
	mov cx,Y
	cmp ax,cx
	jg  @1
	xchg ax,cx
 @1:	mov @Result,ax
 end;
end;

Function MinI(X,Y : Integer):Integer;
begin
 asm
	mov ax,X
	mov cx,Y
	cmp ax,cx
	jl  @1
	xchg ax,cx
 @1:	mov @Result,ax
 end;
end;
{$Else}
Function MaxI(X,Y : Integer):Integer;
begin If X<Y then Result:=Y else Result:=X; end;
Function MinI(X,Y : Integer):Integer;
begin If X>Y then Result:=Y else Result:=X; end;
{$Endif}
Function MaxR(X,Y : Real):Real;
begin If X<Y then MaxR:=Y else MaxR:=X; end;

Function MinR(X,Y : Real):Real;
begin If X<Y then MinR:=X else MinR:=Y; end;

Function MaxD(X,Y : Double):Double;
begin If X<Y then MaxD:=Y else MaxD:=X; end;

Function MinD(X,Y : Double):Double;
begin If X<Y then MinD:=X else MinD:=Y; end;

Function MaxE(X,Y : Extended):Extended;
begin If X<Y then MaxE:=Y else MaxE:=X; end;

Function MinE(X,Y : Extended):Extended;
begin If X<Y then MinE:=X else MinE:=Y; end;

Function MaxS(X,Y : Single):Single;
begin If X<Y then MaxS:=Y else MaxS:=X; end;

Function MinS(X,Y : Single):Single;
begin If X<Y then MinS:=X else MinS:=Y; end;

Procedure SwapR(var X,Y : Real);
{$Ifndef Delphi32}
begin
 ExchangeStructs(X,Y,SizeOf(Real));
{$Else}
var Temp : Real;
begin
 Temp:=X; X:=Y; Y:=Temp;
{$Endif}
end;

Procedure SwapS(var X,Y : Single);
{$Ifndef Delphi32}
begin
 ExchangeStructs(X,Y,SizeOf(Single));
{$Else}
var Temp : Single;
begin
 Temp:=X; X:=Y; Y:=Temp;
{$Endif}
end;

Procedure SwapD(var X,Y : Double);
{$Ifndef Delphi32}
begin
 ExchangeStructs(X,Y,SizeOf(Double));
{$Else}
var Temp : Double;
begin
 Temp:=X; X:=Y; Y:=Temp;
{$Endif}
end;

Procedure SwapE(var X,Y : Extended);
{$Ifndef Delphi32}
begin
 ExchangeStructs(X,Y,SizeOf(Extended));
{$Else}
var Temp : Extended;
begin
 Temp:=X; X:=Y; Y:=Temp;
{$Endif}
end;

{
Procedure WriteMatrix(var A : Matrix; n : Integer);
var i,j : Integer;
begin
 Writeln(Outf,'Матрица : ');
 For i:=1 to n do begin
  For j:=1 to n do Write(Outf,A[i,j]:10:6);
  Writeln(Outf);
 end;
end;
}
Procedure Crout(var a : Matrix; n : Integer; var b,y : Vector; 
 var pivot : IntVector; var det : Extended);
var t,h : Extended;
    i,k,imax,p : Integer;
label 999;
begin
 det:=1; imax:=1;
 for k:=1 to n do begin
   t:=0;
   for i:=k to n do begin
    h:=0; for p:=1 to k-1 do h:=h+a[i,p]*a[p,k];
     a[i,k]:=a[i,k]-h;
     if abs(a[i,k])>t then begin
       t:=abs(a[i,k]); imax:=i;
     end; {if abs() }
   end; {for i:=k to n}
   pivot[k]:=imax;
   if imax<>k then begin
     det:=-det;
     for i:=1 to n do begin
       t:=a[k,i]; a[k,i]:=a[imax,i]; a[imax,i]:=t;
     end;
     t:=b[k]; b[k]:=b[imax]; b[imax]:=t;
   end; {if imax<>k}
   if a[k,k]=0 then begin det:=0; goto 999; end;
{$Ifdef THD} OpF; Writeln(Outf,'Crout : a[',k,',',k,'] = ',a[k,k]:8:6);
 CF;
{$Endif}
   t:=1/a[k,k];
   for i:=k+1 to n do a[i,k]:=t*a[i,k];
   for i:=k+1 to n do begin
    h:=0; for p:=1 to k-1 do h:=h+a[k,p]*a[p,i];
     a[k,i]:=a[k,i]-h;
   end;
   h:=0; for p:=1 to k-1 do h:=h+a[k,p]*b[p];
   b[k]:=b[k]-h;
 end; {for k:=1 to n}
 for k:=1 to n do y[k]:=0;
 for k:=n downto 1 do begin
  det:=a[k,k]*det;
  h:=0; for p:=k+1 to n do h:=h+a[k,p]*y[p];
{$Ifdef THD} OpF; Writeln(Outf,'Crout Last: a[',k,',',k,'] = ',a[k,k]:8:6);
 CF;
{$Endif}
  If a[k,k]=0 then begin det:=0; goto 999; end;
  y[k]:=(b[k]-h)/a[k,k];
 end;
999:
end; {Crout}

Procedure MultMatrixVector(var A : Matrix; n : Integer; var B,Res : Vector);
var I,J : Integer; t : Extended;
begin
 For I:=1 to n do begin
  t:=0;
  For J:=1 to n do t:=t+A[I,J]*B[J];
  Res[I]:=t;
 end;
end;

{	Вычисление угла отрезка }
Function GetAngleI(x1,y1,x2,y2 : Integer):LongInt;
var SA,CA,S : Extended;
begin
 S:=Sqrt(Sqr(0.01*(x1-x2))+Sqr(0.01*(y1-y2)));
 If Abs(S)<1.0E-07 then begin GetAngleI:=0; Exit; end;
 CA:=0.01*(x2-x1)/S; SA:=0.01*(y2-y1)/S;
 If Abs(CA)>Abs(SA) then 
  S:=ArcTan(Abs(SA/CA)) else 
  S:=Pi/2-ArcTan(Abs(CA/SA));
 S:=180*Abs(S)/Pi;
 If (CA>=0) then begin
  If (SA>=0) then GetAngleI:=Round(S*100) else 
                  GetAngleI:=36000-Round(S*100);
 end else begin
  If (SA>=0) then GetAngleI:=18000-Round(S*100) else 
                  GetAngleI:=18000+Round(S*100);
 end;
end;

{	Вычисление угла отрезка }
Function GetAngle(x1,y1,x2,y2 : Single):Single;
var SA,CA,S : Single;
begin
 S:=Sqrt(Sqr(x1-x2)+Sqr(y1-y2));
 If Abs(S)<1.0E-07 then begin GetAngle:=0; Exit; end;
 CA:=(x2-x1)/S; SA:=(y2-y1)/S;
 If Abs(CA)>Abs(SA) then 
  S:=ArcTan(Abs(SA/CA)) else 
  S:=Pi/2-ArcTan(Abs(CA/SA));
 S:=180*Abs(S)/Pi;
 If (CA>=0) then begin
  If (SA>=0) then GetAngle:=S else GetAngle:=360-S;
 end else begin
  If (SA>=0) then GetAngle:=180-S else GetAngle:=180+S;
 end;
end;

{$Ifndef Delphi32}
Function RevertInteger(x : Integer):Integer;
begin RevertInteger:=MakeInteger(Lo(x),Hi(x)); end;
{$Else}
Function RevertInteger(x : SmallInt):SmallInt;
begin
 Result:=Swap(x);
end;
{$Endif}
Function RevertLongInt(L : LongInt):LongInt;
begin
 RevertLongInt:=MakeLongInt(MakeWord(Lo(LoWord(L)),Hi(LoWord(L))),
                 MakeWord(Lo(HiWord(L)),Hi(HiWord(L))));
end;

Function ArcSin(x : Single):Single;
var Temp : Single;
begin Temp:=1-Sqr(x);
 If Temp<0 then ArcSin:=0 else
 If Temp=0 then begin
  If x<0 then ArcSin:=-Pi/2 else ArcSin:=Pi/2;
 end else
  ArcSin:=ArcTan(x/Sqrt(Temp));
end;

Function ArcCos(x : Single):Single;
begin If Abs(x)>1 then ArcCos:=0 else
 If x=0 then ArcCos:=Pi/2 else
   ArcCos:=ArcTan(Sqrt(1-Sqr(x))/x);
end;

{	Корни квадратного уравнения }
Procedure SqEq(A,B,C : Single; var X1,X2 : Single; var Ex : Boolean);
var Det : Single;
begin
 If A=0 then begin
  If B=0 then begin
   If C=0 then begin
    Ex:=True; X1:=0; X2:=0;
   end else begin
    Ex:=False;
   end;
  end else begin
    X1:=-C/B; Ex:=True;
  end;
 end else begin
  Det:=Sqr(B)-4*A*C;
  If Det<0 then begin
   Ex:=False;
  end else begin
   If A>0 then begin
    X1:=(-B-Sqrt(Det))/(2*A);
    X2:=(-B+Sqrt(Det))/(2*A);
   end else begin
    X1:=(-B+Sqrt(Det))/(2*A);
    X2:=(-B-Sqrt(Det))/(2*A);
   end;
   Ex:=True;
  end;
 end;
end;

{	Вычисление угла отрезка }
Function GetAngleExt(x1,y1,x2,y2 : Extended):Extended;
var SA,CA,S : Extended;
begin
 S:=Sqrt(Sqr(x1-x2)+Sqr(y1-y2));
 If Abs(S)<1.0E-07 then begin GetAngleExt:=0; Exit; end;
 CA:=(x2-x1)/S; SA:=(y2-y1)/S;
 If Abs(CA)>Abs(SA) then
  S:=ArcTan(Abs(SA/CA)) else
  S:=Pi/2-ArcTan(Abs(CA/SA));
 S:=Abs(S);
 If (CA>=0) then begin
  If (SA>=0) then GetAngleExt:=S else GetAngleExt:=2*Pi-S; end else begin
  If (SA>=0) then GetAngleExt:=Pi-S else GetAngleExt:=Pi+S;
 end;
end;

{$Ifdef Delphi32}
function MakeLongInt(H, L : Word) : LongInt;
begin Result:=MAKELONG(L,H); end;
{$Endif}
{$Ifdef Delphi32}
function MakeInteger(H, L : Byte): SmallInt;
var SI : Record Lo,Hi : Byte; end;
begin SI.Lo:=L; SI.Hi:=H; Result:=SmallInt(SI); end;
{$Endif}
{$Ifdef Delphi32}
function MakeWord(H, L : Byte) : Word;
var SI : Record Lo,Hi : Byte; end;
begin SI.Lo:=L; SI.Hi:=H; Result:=Word(SI); end;
{$Endif}
{$Ifdef Delphi32}
{$Endif}
{$Ifdef Delphi32}
{$Endif}

Function  GpDistance(const xs,ys,xf,yf : Extended):Extended;
begin
  Result:=Sqrt(Sqr(xf-xs)+Sqr(yf-ys));
end;

function Revert(var x : Integer):Integer;overload;
begin
  result:=RevertLongInt(x);
  x:=result;
end;

function Revert(var x : SmallInt):SmallInt;overload;
begin
  result:=RevertInteger(x);
  x:=result;
end;

end.
