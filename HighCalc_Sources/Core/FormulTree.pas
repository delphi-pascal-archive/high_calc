unit FormulTree;

interface
uses Formula,SysUtils;
type
   PFormulaNode=^TFormulaNode;
   TFormulaNodeArr=array[0..10000] of PFormulaNode;
   PFormulaNodeArr=^TFormulaNodeArr;
   TFormulaNode=record
     case NodeType:(Equation,Variable,Constant) of
         Equation:(Fun:Operation;ParamCount:integer;NextNodes:PFormulaNodeArr);
         Variable:(x,y:integer);
         Constant:(Value:extended);
   end;
   TFormulaTree=class
       Root:TFormulaNode;
       procedure CreateSubTree(Formula:string;Root:PFormulaNode);
       procedure DeleteBrackets(var line:string);
   end;
implementation
uses
    FunLib;
{ TFormulaTree }

procedure TFormulaTree.CreateSubTree(Formula: string;Root:PFormulaNode);
var
   level,position,i:integer;
begin
   DeleteBrackets(Formula);
   level:=0;
   position:=0;
   for i:=1 to length(Formula) do
      case Formula[i] of
         '(':inc(level);
         ')':dec(level);
         '+','-':if (level=0) then position:=i;
         '*','/':if (level=0) and (Formula[position]<>'+') and
                (Formula[position]<>'-') then position:=i;
         '^':if (level=0) and (Formula[position]<>'+') and
                (Formula[position]<>'-') and (Formula[position]<>'*')
                and (Formula[position]<>'/') then position:=i;

      end;
   if Position=0 then begin

   end else begin
     Root.NodeType:=Equation;
     Root.ParamCount:=2;
     case Formula[position] of
          '+':Root.Fun:=Operations[Plus];
          '-':Root.Fun:=Operations[Minus];
          '*':Root.Fun:=Operations[Multiplication];
          '/':Root.Fun:=Operations[Division];
          '^':Root.Fun:=Operations[Extent];
     end;
     GetMem(Root.NextNodes,2*SizeOf(PFormulaNode));
     GetMem(Root.NextNodes[0],SizeOf(TFormulaNode));//Left
     GetMem(Root.NextNodes[1],SizeOf(TFormulaNode));//Right
     CreateSubTree(Copy(Formula,1,Position-1),Root.NextNodes[0]);
     CreateSubTree(Copy(Formula,Position+1,Length(Formula)-Position),
                                                            Root.NextNodes[1]);
   end;
end;
procedure TFormulaTree.DeleteBrackets(var line:string);
var
   index,
   level        : integer;
   haveto       : boolean;
begin
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
              if (level<0) then Raise Exception.Create('Неверное количество скобок');
         end;
     if level<>0 then
          Raise Exception.Create('Неверное количество скобок');
     if haveto then
        begin
             delete(line,1,1);
             delete(line,length(line),1);
             DeleteBrackets(line);
        end;
end;

end.
