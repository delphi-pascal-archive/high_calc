unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Buttons, ExtCtrls, Formula, StdCtrls, ComCtrls,UnlimitedFloat,Math,
  ToolWin,MemCheck;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    StringGrid1: TStringGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Edit3: TEdit;
    TreeView1: TTreeView;
    Button2: TButton;
    Edit4: TEdit;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    Button5: TButton;
    Button6: TButton;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    procedure CalcExpression;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses
  FunLib,sw;
function DecTo26(a:integer):string;
begin

end;
procedure TForm1.FormCreate(Sender: TObject);
var
   i:integer;
begin
//  DecimalSeparator:='.';
    //MemCheckLogFileName:='MemCheckLog.txt';
//    MemChk;
    for i:=1 to StringGrid1.RowCount-1 do begin
        StringGrid1.Cells[0,i]:=IntToStr(i);
    end;
    for i:=1 to StringGrid1.ColCount-1 do begin
        StringGrid1.Cells[i,0]:=IntToStr(i);
    end;

    InitFunLib;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   FC:TFormulaCompiler;
   FE:TFormulaExecute;
begin
    FC:=TFormulaCompiler.Create;
    try
//      Edit2.Text:=Fc.ConvertFormula(Edit1.Text);
    finally
      FC.Free;
    end;
    FE:=TFormulaExecute.Create;
    try
//      Edit3.Text:=FloatToStr(FE.Execute(Edit1.Text));
    finally
      FE.Free;
    end;
end;
function GetVal(x,y:integer):extended;
begin
   result:=StrToFloat(Form1.StringGrid1.Cells[X,Y]);
end;
procedure TForm1.Button2Click(Sender: TObject);
var
   FT:TFormulaTester;
   FC:TFormulaCompiler;
   FE:TFormulaExecute;
begin
   FT:=TFormulaTester.Create;
   try
     FT.Test(Edit1.Text);
     Edit2.Text:=FT.PolskaRecord;//ArifmRecord;
   finally
     FT.Free;
   end;
  { FC:=TFormulaCompiler.Create;
    try
      Edit3.Text:=Fc.ConvertFormula(Edit2.Text);
    finally
      FC.Free;
    end;}
//    FE:=TFormulaExecute.Create;
    FT:=TFormulaTester.Create;
    try
      FT.GetVal:=GetVal;
//      Edit4.Text:=FloatToStr(FT.Execute(Edit2.Text));
    finally
      FT.Free;
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
   F:Tformula;
begin
   F:=Tformula.Create;
   try
      F.init(Edit1.Text);
      Edit3.Text:=FloatToStr(F.Res);
   finally
      F.Free;
   end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   FT:TFormulaTester;
  // FC:TFormulaCompiler;
   FE:TFormulaExecute;
   Res:TUnlimitedFloat;
   s:string;
begin
   FT:=TFormulaTester.Create;
   try
     FT.Test(Edit1.Text);
     Edit2.Text:=FT.PolskaRecord;//ArifmRecord;
   finally
     FT.Free;
   end;
    FT:=TFormulaTester.Create;
    try
      Res:=TUnlimitedFloat.Create;
      try
        Res.DecPrecision:=1000;
        FT.Execute(Edit2.Text,Res);
        s:=Res.DecStr;
        Memo1.Lines.Add(s);
      finally
        Res.Free;
      end;
    finally
      FT.Free;
    end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Edit3.Text:=FloatToStr(system.exp(2));
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
//  Button4Click(nil);
  CalcExpression;
end;
procedure TForm1.CalcExpression;
var
   FT:TFormulaTester;
   FE:TFormulaExecute;
   Res:TUnlimitedFloat;
   PolskaRecord:String;
   s:string;
begin
   FT:=TFormulaTester.Create;
   try
     FT.Test(Memo1.Text);
     PolskaRecord:=FT.PolskaRecord;
   finally
     FT.Free;
   end;
    FT:=TFormulaTester.Create;
    try
      Res:=TUnlimitedFloat.Create;
      try
        Res.DecPrecision:=500;
//        Res.ExponentLen:=2;
        FT.Execute(PolskaRecord,Res);
        s:=Res.DecStr;
        Memo1.Lines.Add(s);
      finally
        Res.Free;
      end;
    finally
      FT.Free;
    end;
//    ExpressionBuffer.AddExpression(ExpressionMemo);
end;


procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  Button4Click(nil);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  UnlimitedFloat1,UnlimitedFloat2:TUnlimitedFloat;
  a:int64;
  s:string;
begin
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
    UnlimitedFloat2:=TUnlimitedFloat.Create;
    try
//      UnlimitedFloat1.ExponentLen:=2;
//      UnlimitedFloat2.ExponentLen:=2;
      UnlimitedFloat1.DecPrecision:=200;
      UnlimitedFloat2.DecPrecision:=200;
      a:=10000;//($100000000 shr 1)-1;
      UnlimitedFloat1.Surplus:=a;
      UnlimitedFloat2.Surplus:=a;
      UnlimitedFloat1.DecStr:=Edit1.Text;
      UnlimitedFloat2.DecStr:=Edit2.Text;
      UnlimitedFloat1.Plus(UnlimitedFloat2);
//      Edit8.Text:=UnlimitedFloat1.FractionAsHex;
//      Edit.Text:=IntToStr(UnlimitedFloat1.Exponent-a);
      s:=UnlimitedFloat1.DecStr;
      Memo1.Lines.Add(s);
    finally
      UnlimitedFloat2.Free;
    end;
  finally
    UnlimitedFloat1.Free;
  end;
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  UnlimitedFloat1,UnlimitedFloat2:TUnlimitedFloat;
  a:int64;
  s:string;
begin
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
    UnlimitedFloat2:=TUnlimitedFloat.Create;
    try
//      UnlimitedFloat1.ExponentLen:=2;
//      UnlimitedFloat2.ExponentLen:=2;
      UnlimitedFloat1.DecPrecision:=200;
      UnlimitedFloat2.DecPrecision:=200;
      a:=10000;//($100000000 shr 1)-1;
      UnlimitedFloat1.Surplus:=a;
      UnlimitedFloat2.Surplus:=a;
      UnlimitedFloat1.DecStr:=Edit1.Text;
      UnlimitedFloat2.DecStr:=Edit2.Text;
      UnlimitedFloat1.Divide(UnlimitedFloat2);
//      Edit8.Text:=UnlimitedFloat1.FractionAsHex;
//      Edit.Text:=IntToStr(UnlimitedFloat1.Exponent-a);
      s:=UnlimitedFloat1.DecStr;
      Memo1.Lines.Add(s);
    finally
      UnlimitedFloat2.Free;
    end;
  finally
    UnlimitedFloat1.Free;
  end;
end;
procedure aa(UnlimitedFloat2:TUnlimitedFloat);
var
  UnlimitedFloat1:TUnlimitedFloat;
  a:int64;
  s:string;
begin
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
      UnlimitedFloat1.Let(UnlimitedFloat2);
//      UnlimitedFloat1.DecPrecision:=20;
//      UnlimitedFloat1.DecStr:='123';
      ShowMessage(UnlimitedFloat1.DecStr);
      ShowMessage(UnlimitedFloat1.DecStr);
      ShowMessage(UnlimitedFloat2.DecStr);
      ShowMessage(UnlimitedFloat2.DecStr);

  finally
    UnlimitedFloat1.Free;
  end;
end;
procedure TForm1.Button11Click(Sender: TObject);
var
  UnlimitedFloat1:TUnlimitedFloat;
  a:int64;
  s:string;
begin
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
      UnlimitedFloat1.DecPrecision:=20;
      UnlimitedFloat1.DecStr:='123';
      ShowMessage(UnlimitedFloat1.DecStr);
//      ShowMessage(UnlimitedFloat1.DecStr);
//      aa(UnlimitedFloat1);
  finally
    UnlimitedFloat1.Free;
  end;
end;

end.
