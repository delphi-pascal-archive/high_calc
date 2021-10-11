

{------------------------- FORMULA.PAS --------------------------}
{ (C) Alex V. Krasnov, Troitsk, 1996, verion 1.2b                }

{ формат формулы такой же как и в Turbo Pascal'e                 }
{ но вместо переменных используються x1,x2,...,x[MaxDifferents]  }
{ это нужно для того чтоб не переразбирать всю формулу           }
{ формула не оптимизируеться (5+10+12 будут считаться при каждом }
{ запросе ответа), степени считаются только от неотрицательных   }
{ значений (иначе ошибка вычислений)                             }
{ еще один отрицательный момент у ^, * и / одинаковый приоритет  }
{ что вообщем легко поправить :)                                 }

unit sw;
interface
uses SysUtils;
const
     { максимальное количество переменных }
     maxdifferents              = 15;
     nothing= 1;
     logarifm=2;
     exponent=3;
     cosinus= 4;
     sinus=   5;
     arctangens=6;
type
    Ppoint      = ^Tpoint;
    nextpart    = record
                functions       : integer;//╩юф ЇєэъЎшш
                { следующий аргумент: раздвоение, значение, номер переменной }
                case style      : (point,value,different) of
                     point      : (nextpoint:Ppoint);
                     value      : (value:extended);
                     different  : (number:byte);
    end;

    Tpoint      = record
                { операция: минус, плюс, степень, умножить, делить }
                operation       : (minus,plus,extent,
                                   division,multiplication);
                { правая и левая части }
                left,right      : nextpart;
    end;

    Tformula    = class
                { переменные }
                x               : array[1..maxdifferents] of extended;
                { вершина дерева }
                tree            : Ppoint;
    public
                { true если ошибка вычислений }
                errorcount      : boolean;

                { true если ошибка построения дерева (разбора выражения) }
                errorsyntax     : boolean;

                { создать дерево line }
                procedure init(line:string);

                { рассчитать формулу }
                function Res:extended;

                { удалить формулу }
                procedure done;

                { устаноить в переменную c номером number значение value }
                procedure setdifferent(number:byte;value:extended);

                { возвращает true если переменная присутствует в дереве }
                function existdifferent(number:byte):boolean;
    private
                { удаляет лишние скобки справа и слева }
                procedure delbrackets(var line:string);

                { рассчет дерева }
                function resultpart(part:nextpart):extended;
                function count(start:Ppoint):extended;

                { формирование дерева }
                procedure convert(line:string;var start:Ppoint);
                procedure makepart(line:string;var part:nextpart);
                function GetFunCod(operand:string):integer;
                { возвращает true если переменная присутствует в дереве }
                function exist(start:nextpart;number:byte):boolean;

                { удалить формулу }
                procedure deltree(var start:Ppoint);
    end;

implementation

procedure Tformula.init(line:string);
var
   index                : byte;
begin
     tree:=nil;
     errorsyntax:=false;
     while pos(' ',line)<>0 do delete(line,pos(' ',line),1);
     for index:=1 to length(line) do line[index]:=upcase(line[index]);
     convert(line,tree);
end;

function Tformula.Res:extended;
begin
     errorcount:=false;
     if not errorsyntax then Res:=count(tree);
end;

procedure Tformula.setdifferent(number:byte;value:extended);
begin
     x[number]:=value;
end;

procedure Tformula.done;
begin
     deltree(tree);
end;

function Tformula.resultpart(part:nextpart):extended;
var
   tmp                  : extended;
begin
     case part.style of
          value         : tmp:=part.value;
          different     : tmp:=x[part.number];
          point         : tmp:=count(part.nextpoint);
     end;
     case part.functions of
          {nothing} 1      : ;
          {logarifm}2      : if tmp>0 then tmp:=ln(tmp) else errorcount:=true;
          {exponent}3      : tmp:=exp(tmp);
          {cosinus} 4      : tmp:=cos(tmp);
          {sinus}   5      : tmp:=sin(tmp);
          {arctangens}6    : tmp:=arctan(tmp);
     end;
     resultpart:=tmp;
end;

function Tformula.count(start:Ppoint):extended;
var
   left,right   : extended;
   tmp          : extended;
begin
     left:=resultpart(start^.left);
     right:=resultpart(start^.right);
     case start^.operation of
          minus         : tmp:=left-right;
          plus          : tmp:=left+right;
          division      : if right=0 then errorcount:=true
                                     else tmp:=left/right;
          multiplication: tmp:=left*right;
          extent        : begin
                               if left=0 then tmp:=0;
                               if left>0 then tmp:=exp(right*ln(left));
                               if left<0 then errorcount:=true;
                          end;
     end;
     count:=tmp;
end;

procedure Tformula.delbrackets(var line:string);
var
   index,
   level        : integer;
   haveto       : boolean;
begin
     if errorsyntax then exit;
     haveto:=true;
     if line[1]<>'(' then haveto:=false;
     level:=0;
     for index:=1 to length(line) do
         begin
              case line[index] of
                   '(':inc(level);
                   ')':dec(level);
              end;
              if (level=0) and (index<>length(line)) then haveto:=false;
              if (level<0) then errorsyntax:=true;
         end;
     if level<>0 then //errorsyntax:=true;
          Raise Exception.Create('═хтхЁэюх ъюышўхёЄтю ёъюсюъ');
     if haveto then
        begin
             delete(line,1,1);
             delete(line,length(line),1);
             delbrackets(line);
        end;
end;

procedure Tformula.makepart(line:string;var part:nextpart);
var
   index,
   level                : integer;
   position             : byte;
   figure               : extended;
   number,
   error                : integer;
   operand              : string;
   haveto               : boolean;
begin
     if line='' then errorsyntax:=true;
     if errorsyntax then exit;
     delbrackets(line);
     position:=pos('*',line)+pos('/',line)+
               pos('-',line)+pos('+',line)+pos('^',line);
     part.functions:=nothing;
     operand:=copy(line,1,pos('(',line)-1);

     level:=0;
     if (pos('(',line)>1) then haveto:=true else haveto:=false;
     for index:=pos('(',line) to length(line) do
         begin
              case line[index] of
                   '(':inc(level);
                   ')':dec(level);
              end;
              if (level=0) and (index<>length(line)) then
                 haveto:=false;
         end;
     if haveto then
        begin
             part.functions:=GetFunCod(operand);
             if part.functions<>nothing then
                begin
                     delete(line,1,pos('(',line)-1);
                     part.style:=point;
                     convert(line,part.nextpoint);
                     exit;
                end;
        end;

     if (position=0) then
        begin
             if line[1]='X' then
                begin
                     val(copy(line,2,length(line)-1),number,error);
                     if error<>0 then errorsyntax:=true
                        else if (number<1) or (number>maxdifferents)
                             then errorsyntax:=true;
                     part.style:=different;
                     part.number:=number;
                end
             else
                 begin
                      val(line,figure,error);
                      if error<>0 then errorsyntax:=true;
                      part.style:=value;
                      part.value:=figure;
                 end;
        end
     else begin
               part.style:=point;
               convert(line,part.nextpoint);
          end;
end;

procedure Tformula.convert(line:string;var start:Ppoint);
var
   index        : integer;
   position,
   level        : integer;
   left,right   : string;
begin
     delbrackets(line);
     if errorsyntax then exit;
     new(start);
     start^.left.style:=point;
     start^.left.nextpoint:=nil;
     start^.right.style:=point;
     start^.right.nextpoint:=nil;

     level:=0;
     position:=0;
     for index:=1 to length(line) do
         case line[index] of
              '(':inc(level);
              ')':dec(level);
              '+','-':if (level=0) then position:=index;
              '*','/','^':if (level=0) and (line[position]<>'+') and
                             (line[position]<>'-') then position:=index;
         end;

     case line[position] of
          '+':start^.operation:=plus;
          '-':start^.operation:=minus;
          '*':start^.operation:=multiplication;
          '/':start^.operation:=division;
          '^':start^.operation:=extent;
     end;

     left:='';
     if position=0 then
        begin
             right:=line;
             start^.operation:=plus;
        end
     else
         begin
              left:=copy(line,1,position-1);
              right:=copy(line,position+1,length(line));
         end;
     if (left='') and ((start^.operation=plus) or
        (start^.operation=minus)) then left:='0';

     makepart(left,start^.left);
     makepart(right,start^.right);
end;

procedure Tformula.deltree(var start:Ppoint);
begin
     if start=nil then exit;
     if start^.left.style=point then
        deltree(start^.left.nextpoint);
     if start^.right.style=point then
        deltree(start^.right.nextpoint);
     dispose(start);
     start:=nil;
end;

function Tformula.exist(start:nextpart;number:byte):boolean;
begin
     if (start.style=different) and (start.number=number)
        then exist:=true
        else exist:=false;
     if start.style=point then exist:=exist(start.nextpoint^.left,number) or
                                      exist(start.nextpoint^.right,number);
end;

function Tformula.existdifferent(number:byte):boolean;
begin
     existdifferent:=exist(tree^.left,number) or
                     exist(tree^.right,number);
end;

function Tformula.GetFunCod(operand: string): integer;
begin
   result:=nothing;
   if operand='LN' then result:=logarifm else
   if operand='COS' then result:=cosinus else
   if operand='SIN' then result:=sinus else
   if operand='EXP' then result:=exponent else
   if operand='ARCTAN' then result:=arctangens;
end;

end.
