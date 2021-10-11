unit ShpPropDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,ButCodes;

type
  TNameCod=record
    Name:string;
    Cod:integer;
  end;
  TNameCodArray = array of TNameCod;
const
  NameCodArray:array[0..31] of TNameCod=(
    (Name:'Контур окна';Cod:FrameCod),
    (Name:'Индикатор выражения';Cod:IndicatorCod),
    (Name:'Индикатор результата';Cod:IndResCod),
    (Name:'Дерево функций';Cod:IndTreeCod),
    (Name:'Контур индикатора выражения';Cod:Indicator1Cod),
    (Name:'Контур индикатора результата';Cod:IndRes1Cod),
    (Name:'Контур дерева функций';Cod:IndTree1Cod),
    (Name:'0';Cod:bt_0),
    (Name:'1';Cod:bt_1),
    (Name:'2';Cod:bt_2),
    (Name:'3';Cod:bt_3),
    (Name:'4';Cod:bt_4),
    (Name:'5';Cod:bt_5),
    (Name:'6';Cod:bt_6),
    (Name:'7';Cod:bt_7),
    (Name:'8';Cod:bt_8),
    (Name:'9';Cod:bt_9),
    (Name:'+';Cod:bt_Plus),
    (Name:'-';Cod:bt_Minus),
    (Name:'*';Cod:bt_Mul),
    (Name:'/';Cod:bt_Div),
    (Name:'Получить результат (=)';Cod:bt_Exe),
    (Name:'Десятичная точка';Cod:bt_DecSeparator),
    (Name:'Закрыть форму';Cod:bt_CloseForm),
    (Name:'Очистка окна выражения';Cod:bt_Clear),
    (Name:'Файл';Cod:bt_File),
    (Name:'Редактирование';Cod:bt_Edit),
    (Name:'Просмотр';Cod:bt_View),
    (Name:'Опции';Cod:bt_Options),
    (Name:'Справка';Cod:bt_Help),
    (Name:'Предыдущая операция';Cod:bt_PrevOp),
    (Name:'Следующая операция';Cod:bt_NextOp));

{  NameCodArray:array[0..42] of TNameCod=(
    (Name:'Контур окна';Cod:0),
    (Name:'Индикатор';Cod:0),
    (Name:'0';Cod:bt_0),
    (Name:'1';Cod:bt_1),
    (Name:'2';Cod:bt_2),
    (Name:'3';Cod:bt_3),
    (Name:'4';Cod:bt_4),
    (Name:'5';Cod:bt_5),
    (Name:'6';Cod:bt_6),
    (Name:'7';Cod:bt_7),
    (Name:'8';Cod:bt_8),
    (Name:'9';Cod:bt_9),
    (Name:'+';Cod:bt_Plus),
    (Name:'-';Cod:bt_Minus),
    (Name:'*';Cod:bt_Mul),
    (Name:'/';Cod:bt_Div),
    (Name:'Exe';Cod:bt_Exe),
    (Name:'Десятичная точка';Cod:bt_DecSeparator),
    (Name:'Закрыть форму';Cod:bt_CloseForm),
    (Name:'Пказать список переменных';Cod:bt_ShowMemList),
    (Name:'Добавить переменную';Cod:bt_AddToMemList),
    (Name:'Sin';Cod:bt_Sin),
    (Name:'Cos';Cod:bt_Cos),
    (Name:'ArcSin';Cod:bt_ArcSin),
    (Name:'ArcCos';Cod:bt_ArcCos),
    (Name:'Tg';Cod:bt_tg),
    (Name:'Ctg';Cod:bt_Ctg),
    (Name:'ArcTg';Cod:bt_ArcTg),
    (Name:'ArcCtg';Cod:bt_ArcCtg),
    (Name:'Ln';Cod:bt_Ln),
    (Name:'Log';Cod:bt_Log),
    (Name:'lg';Cod:bt_Lg),
    (Name:'Power';Cod:bt_Power),
    (Name:'Sqr';Cod:bt_Sqr),
    (Name:'Sqrt';Cod:bt_Sqrt),
    (Name:'Сброс';Cod:bt_Clear),

    (Name:'%';Cod:bt_Percent),
    (Name:'+/-';Cod:bt_ChangeSign),
    (Name:'Log';Cod:bt_LogFile),
    (Name:'Ms';Cod:bt_Ms),
    (Name:'Mr';Cod:bt_Mr),
    (Name:'MPlus';Cod:bt_MPlus),
    (Name:'MMinus';Cod:bt_MMinus));}


type
  TShapeDlgForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    CodEdit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    OperationComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
  private
    procedure SetCod(const Value: integer);
    procedure SetShapeType(const Value: integer);
    function GetCod: integer;
    function GetShapeType: integer;
    procedure InitOperationComboBox;
    { Private declarations }
  public
    { Public declarations }
    property ShapeType:integer read GetShapeType write SetShapeType;
    property Cod:integer read GetCod write SetCod;
  end;

var
  ShapeDlgForm: TShapeDlgForm;
function ShapeDialog:boolean;
implementation

{$R *.DFM}

{ TForm2 }

function TShapeDlgForm.GetCod: integer;
begin
//  result := StrToInt(CodEdit.Text);
  result := integer(OperationComboBox.Items.
    Objects[OperationComboBox.ItemIndex]);
end;

function TShapeDlgForm.GetShapeType: integer;
begin
  result := ComboBox1.ItemIndex;
end;

procedure TShapeDlgForm.InitOperationComboBox;
var
  i,n:integer;
begin
  OperationComboBox.Items.Clear;
  for i:=Low(NameCodArray) to High(NameCodArray) do
    OperationComboBox.Items.AddObject(NameCodArray[i].Name,
      TObject(NameCodArray[i].Cod));
end;

procedure TShapeDlgForm.SetCod(const Value: integer);
begin
//  CodEdit.Text:=IntToStr(Value);
  OperationComboBox.ItemIndex := OperationComboBox.Items.IndexOfObject(
    TObject(Value));
end;

procedure TShapeDlgForm.SetShapeType(const Value: integer);
begin
  ComboBox1.ItemIndex:=Value;
end;

function ShapeDialog:boolean;
begin
  result:=ShapeDlgForm.ShowModal=mrYes;
end;
procedure TShapeDlgForm.FormCreate(Sender: TObject);
begin
  InitOperationComboBox;
end;

end.
