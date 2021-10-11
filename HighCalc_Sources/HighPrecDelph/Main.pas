unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,UnlimitedInt,UnlimitedFloat,Math;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Memo1: TMemo;
    Label4: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label5: TLabel;
    Button6: TButton;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Memo2: TMemo;
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button5Click(Sender: TObject);
var
  UnlimitedInteger:TUnlimitedInteger;
begin
  UnlimitedInteger:=TUnlimitedInteger.Create;
  try
    UnlimitedInteger.HexStr:=Edit1.Text;
    Edit3.Text:=UnlimitedInteger.HexStr;
  finally
    UnlimitedInteger.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  UnlimitedInteger1,UnlimitedInteger2:TUnlimitedInteger;
begin
  UnlimitedInteger1:=TUnlimitedInteger.Create;
  try
    UnlimitedInteger2:=TUnlimitedInteger.Create;
    try
      UnlimitedInteger1.HexStr:=Edit1.Text;
      UnlimitedInteger2.HexStr:=Edit2.Text;
      UnlimitedInteger1.Plus(UnlimitedInteger2);
      Edit3.Text:=UnlimitedInteger1.HexStr;
      Edit5.Text:=UnlimitedInteger1.DecSignStr;
    finally
      UnlimitedInteger2.Free;
    end;
  finally
    UnlimitedInteger1.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  UnlimitedInteger1,UnlimitedInteger2:TUnlimitedInteger;
begin
  UnlimitedInteger1:=TUnlimitedInteger.Create;
  try
    UnlimitedInteger2:=TUnlimitedInteger.Create;
    try
      UnlimitedInteger1.HexStr:=Edit1.Text;
      UnlimitedInteger2.HexStr:=Edit2.Text;
      UnlimitedInteger1.Substract(UnlimitedInteger2);
      Edit3.Text:=UnlimitedInteger1.HexStr;
      Edit5.Text:=UnlimitedInteger1.DecSignStr;
    finally
      UnlimitedInteger2.Free;
    end;
  finally
    UnlimitedInteger1.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  UnlimitedInteger1,UnlimitedInteger2:TUnlimitedInteger;
  v:LongWord;
begin
  UnlimitedInteger1:=TUnlimitedInteger.Create;
  try
    UnlimitedInteger2:=TUnlimitedInteger.Create;
    try
      UnlimitedInteger1.HexStr:=Edit1.Text;
      UnlimitedInteger2.HexStr:=Edit2.Text;
{      UnlimitedInteger1.DecSignStr:=Edit1.Text;
      UnlimitedInteger2.DecSignStr:=Edit2.Text;}
      UnlimitedInteger1.Multiply(UnlimitedInteger2);
{      v:=StrToInt(Edit2.Text);
      UnlimitedInteger1.Multiply(v);}
      Edit3.Text:=UnlimitedInteger1.HexStr;
      Edit5.Text:=UnlimitedInteger1.DecSignStr;
    finally
      UnlimitedInteger2.Free;
    end;
  finally
    UnlimitedInteger1.Free;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  UnlimitedInteger1,UnlimitedInteger2,UnlimitedInteger3:TUnlimitedInteger;
begin
  UnlimitedInteger1:=TUnlimitedInteger.Create;
  try
    UnlimitedInteger2:=TUnlimitedInteger.Create;
    try
      UnlimitedInteger1.HexStr:=Edit1.Text;
      UnlimitedInteger2.HexStr:=Edit2.Text;
      UnlimitedInteger3:=TUnlimitedInteger.Create;
      try
        UnlimitedInteger1.Divide(UnlimitedInteger2,UnlimitedInteger3);
        Edit3.Text:=UnlimitedInteger1.HexStr;
        Edit4.Text:=UnlimitedInteger3.HexStr;
        Edit5.Text:=UnlimitedInteger1.DecSignStr;


      finally
        UnlimitedInteger3.Free;
      end;
    finally
      UnlimitedInteger2.Free;
    end;
  finally
    UnlimitedInteger1.Free;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  UnlimitedInteger1:TUnlimitedInteger;
begin
  UnlimitedInteger1:=TUnlimitedInteger.Create;
  try
      UnlimitedInteger1.HexStr:=Edit3.Text;
      UnlimitedInteger1.Sign:=not UnlimitedInteger1.Sign;
      Edit3.Text:=UnlimitedInteger1.HexStr;
      Edit5.Text:=UnlimitedInteger1.DecSignStr;
  finally
    UnlimitedInteger1.Free;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  UnlimitedFloat1,UnlimitedFloat2:TUnlimitedFloat;
  a:int64;
begin
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
    UnlimitedFloat2:=TUnlimitedFloat.Create;
    try
{      UnlimitedFloat1.ExponentLen:=2;
      UnlimitedFloat2.ExponentLen:=2;
      UnlimitedFloat1.FractionLen:=4;
      UnlimitedFloat2.FractionLen:=4;
      a:=10000;//($100000000 shr 1)-1;
      UnlimitedFloat1.Surplus:=a;
      UnlimitedFloat2.Surplus:=a;
      UnlimitedFloat1.FractionAsHex:=Edit6.Text;
      UnlimitedFloat2.FractionAsHex:=Edit7.Text;
      UnlimitedFloat1.Exponent:=StrToInt(Edit9.Text)+a;
      UnlimitedFloat2.Exponent:=StrToInt(Edit10.Text)+a;
      UnlimitedFloat1.Plus(UnlimitedFloat2);
      Edit8.Text:=UnlimitedFloat1.FractionAsHex;
      Edit11.Text:=IntToStr(UnlimitedFloat1.Exponent-a);}
    finally
      UnlimitedFloat2.Free;
    end;
  finally
    UnlimitedFloat1.Free;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  UnlimitedFloat1,UnlimitedFloat2:TUnlimitedFloat;
  a:int64;
begin
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
    UnlimitedFloat2:=TUnlimitedFloat.Create;
    try
{      UnlimitedFloat1.ExponentLen:=2;
      UnlimitedFloat2.ExponentLen:=2;
      UnlimitedFloat1.FractionLen:=4;
      UnlimitedFloat2.FractionLen:=4;
      a:=($100000000 shr 1);
      UnlimitedFloat1.Surplus:=a;
      UnlimitedFloat2.Surplus:=a;
      UnlimitedFloat1.FractionAsHex:=Edit6.Text;
      UnlimitedFloat2.FractionAsHex:=Edit7.Text;
      UnlimitedFloat1.Exponent:=StrToInt(Edit9.Text)+a;
      UnlimitedFloat2.Exponent:=StrToInt(Edit10.Text)+a;
      UnlimitedFloat1.Multiply(UnlimitedFloat2);
      Edit8.Text:=UnlimitedFloat1.FractionAsHex;
      Edit11.Text:=IntToStr(UnlimitedFloat1.Exponent-a); }
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
begin
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
    UnlimitedFloat2:=TUnlimitedFloat.Create;
    try
{      UnlimitedFloat1.ExponentLen:=2;
      UnlimitedFloat2.ExponentLen:=2;
      UnlimitedFloat1.FractionLen:=4;
      UnlimitedFloat2.FractionLen:=4;
      a:=10000;//($100000000 shr 1)-1;
      UnlimitedFloat1.Surplus:=a;
      UnlimitedFloat2.Surplus:=a;
      UnlimitedFloat1.FractionAsHex:=Edit6.Text;
      UnlimitedFloat2.FractionAsHex:=Edit7.Text;
      UnlimitedFloat1.Exponent:=StrToInt(Edit9.Text)+a;
      UnlimitedFloat2.Exponent:=StrToInt(Edit10.Text)+a;
      UnlimitedFloat1.Substract(UnlimitedFloat2);
      Edit8.Text:=UnlimitedFloat1.FractionAsHex;
      Edit11.Text:=IntToStr(UnlimitedFloat1.Exponent-a);     }
    finally
      UnlimitedFloat2.Free;
    end;
  finally
    UnlimitedFloat1.Free;
  end;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  UnlimitedFloat1,UnlimitedFloat2:TUnlimitedFloat;
  a:int64;
  s:string;
begin
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
    UnlimitedFloat2:=TUnlimitedFloat.Create;
    try
{      UnlimitedFloat1.ExponentLen:=2;
      UnlimitedFloat2.ExponentLen:=2;
      UnlimitedFloat1.DecPrecision:=200;
      UnlimitedFloat2.DecPrecision:=200;
      a:=10000;//($100000000 shr 1)-1;
      UnlimitedFloat1.Surplus:=a;
      UnlimitedFloat2.Surplus:=a;
      UnlimitedFloat1.DecStr:=Edit6.Text;
      UnlimitedFloat2.DecStr:=Edit7.Text;
{      UnlimitedFloat1.Exponent:=StrToInt(Edit9.Text)+a;
      UnlimitedFloat2.Exponent:=StrToInt(Edit10.Text)+a;}
{      UnlimitedFloat1.Divide(UnlimitedFloat2);
      Edit8.Text:=UnlimitedFloat1.FractionAsHex;
      Edit11.Text:=IntToStr(UnlimitedFloat1.Exponent-a);
      s:=UnlimitedFloat1.DecStr;
      Memo2.Lines.Add(s);}
    finally
      UnlimitedFloat2.Free;
    end;
  finally
    UnlimitedFloat1.Free;
  end;
end;

procedure TForm1.Button11Click(Sender: TObject);
var
  UnlimitedFloat1:TUnlimitedFloat;
  a:int64;
begin
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
{    UnlimitedFloat1.ExponentLen:=2;
    UnlimitedFloat1.FractionLen:=4;
    a:=10000;//($100000000 shr 1)-1;
    UnlimitedFloat1.Surplus:=a;
    UnlimitedFloat1.FractionAsHex:=Edit6.Text;
    UnlimitedFloat1.Exponent:=StrToInt(Edit9.Text)+a;
    UnlimitedFloat1.Divide(StrToInt(Edit7.Text));
    Edit8.Text:=UnlimitedFloat1.FractionAsHex;
    Edit11.Text:=IntToStr(UnlimitedFloat1.Exponent-a);   }
  finally
    UnlimitedFloat1.Free;
  end;
end;

procedure TForm1.Button12Click(Sender: TObject);
var
  UnlimitedFloat1,UnlimitedFloat2:TUnlimitedFloat;
  a:int64;
begin
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
    UnlimitedFloat2:=TUnlimitedFloat.Create;
    try
{      UnlimitedFloat1.ExponentLen:=2;
      UnlimitedFloat2.ExponentLen:=2;
      UnlimitedFloat1.FractionLen:=4;
      UnlimitedFloat2.FractionLen:=4;
      a:=10000;//($100000000 shr 1)-1;
      UnlimitedFloat1.Surplus:=a;
      UnlimitedFloat2.Surplus:=a;
      UnlimitedFloat1.FractionDecStr:=Edit6.Text;
      UnlimitedFloat2.FractionDecStr:=Edit7.Text;
      UnlimitedFloat1.Exponent:=StrToInt(Edit9.Text)+a;
      UnlimitedFloat2.Exponent:=StrToInt(Edit10.Text)+a;
      UnlimitedFloat1.Plus(UnlimitedFloat2);
      Edit8.Text:=UnlimitedFloat1.FractionDecStr;
      Edit11.Text:=IntToStr(UnlimitedFloat1.Exponent-a);  }
    finally
      UnlimitedFloat2.Free;
    end;
  finally
    UnlimitedFloat1.Free;
  end;
end;

procedure TForm1.Button13Click(Sender: TObject);
var
  UnlimitedFloat1:TUnlimitedFloat;
  a:int64;
begin
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
{    UnlimitedFloat1.ExponentLen:=2;
    UnlimitedFloat1.DecPrecision:=20;
//    UnlimitedFloat1.FractionLen:=11;
    a:=10000;//($100000000 shr 1)-1;
    UnlimitedFloat1.Surplus:=a;
    UnlimitedFloat1.FractionDecStr:=Edit6.Text;
    Edit7.Text:=UnlimitedFloat1.FractionAsHex;
    Edit8.Text:=UnlimitedFloat1.FractionDecStr;
  //  Edit8.Text:=UnlimitedFloat1.GetRoundDecStr(Edit8.Text,50); }
  finally
    UnlimitedFloat1.Free;
  end;
end;

procedure TForm1.Button14Click(Sender: TObject);
var
  UnlimitedFloat1:TUnlimitedFloat;
  a:int64;
  b:Extended;
  s:string;
begin
  UnlimitedFloat.a:=Log10(MaxInt);
  UnlimitedFloat1:=TUnlimitedFloat.Create;
  try
{    UnlimitedFloat1.ExponentLen:=2;
//    UnlimitedFloat1.FractionLen:=1040;
    UnlimitedFloat1.FractionLen:=4;
    UnlimitedFloat1.DecPrecision:=200;
    a:=10000;//($100000000 shr 1)-1;
    UnlimitedFloat1.Surplus:=a;
    UnlimitedFloat1.DecStr:=Edit6.Text;
//    UnlimitedFloat1.FractionAsHex:=Edit7.Text;
//    UnlimitedFloat1.Exponent:=StrToInt(Edit10.Text)+a;

    Edit7.Text:=UnlimitedFloat1.FractionAsHex;
//    Edit10.Text:=IntToStr(UnlimitedFloat1.Exponent-a);
//    Edit8.Text:=UnlimitedFloat1.DecStr+'   ';
    s:=UnlimitedFloat1.DecStr;
   // s:=UnlimitedFloat1.NormalizeOutDecStr(s);
    Memo2.Lines.Add(s);
//    Edit8.Text:=UnlimitedFloat1.FractionDecStr;
//    Edit8.Text:=UnlimitedFloat1.GetRoundDecStr(Edit8.Text,50);   }
  finally
    UnlimitedFloat1.Free;
  end;
end;

end.
