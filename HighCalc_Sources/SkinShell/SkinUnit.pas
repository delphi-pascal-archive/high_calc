unit SkinUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,Skintypes,jpeg;
const
  drPressecPict=1;
  drDisablePict=2;
  drSelectedPict=3;
type
  TSkinButton=class
    Cod:integer;
    FindRegion:TButtonRegion;
    DrawPressedRegion:TButtonRegion;
    DrawDisableRegion:TButtonRegion;
    DrawSelectedRegion:TButtonRegion;
    PressedPict,DisablePict,SelectedPict:TMemBitMap;
  end;

  TSkinForm = class(TForm)
    Button1: TButton;
    PaintBox1: TPaintBox;
    EditIndicator: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    FShapePolygon: TIntPolygon;
    BackGroundJpeg:TJpegImage;
    TempBitMap:TBitMap;
    procedure SetShapePolygon(const Value: TIntPolygon);
    procedure TestBackground;
    { Private declarations }
  public
    { Public declarations }
    property ShapePolygon:TIntPolygon read FShapePolygon write SetShapePolygon;
    procedure SetBackGroundBitMap(Stream:TStream);
    procedure DrawAll;
  end;

var
  SkinForm: TSkinForm;

implementation

{$R *.DFM}

{ TSkinForm }

procedure TSkinForm.SetShapePolygon(const Value: TIntPolygon);
var
  PolygonRgn:HRGN;
  n:integer;
begin
  FShapePolygon := Value;
  n:=Length(FShapePolygon);
  if n>2 then begin
    PolygonRgn:=CreatePolygonRgn(FShapePolygon[0],n,WINDING);
    SetWindowRgn(Handle,PolygonRgn,True);
    DeleteObject(PolygonRgn);
  end;  
end;

procedure TSkinForm.Button1Click(Sender: TObject);
var
  TempShapePolygon: TIntPolygon;
begin
  SetLength(TempShapePolygon,3);
  TempShapePolygon[0].x:=0;
  TempShapePolygon[0].y:=0;
  TempShapePolygon[1].x:=Width;
  TempShapePolygon[1].y:=0;
  TempShapePolygon[2].x:=Width div 2;
  TempShapePolygon[2].y:=Height;
  ShapePolygon:=TempShapePolygon;
end;

procedure TSkinForm.FormCreate(Sender: TObject);
begin
  BackGroundJpeg:=TJpegImage.Create;
  TempBitMap:=TBitMap.Create;
  TestBackground;

//  Button1Click(nil);

end;

procedure TSkinForm.SetBackGroundBitMap(Stream: TStream);
begin
  BackGroundJpeg.LoadFromStream(Stream);
  Width:=BackGroundJpeg.Width;
  Height:=BackGroundJpeg.Height;
end;

procedure TSkinForm.PaintBox1Paint(Sender: TObject);
begin
  DrawAll;
end;

procedure TSkinForm.DrawAll;
begin
  PaintBox1.Canvas.Draw(0,0,BackGroundJpeg);
end;

procedure TSkinForm.TestBackground;
var
  Stream:TFileStream;
begin
  Stream:=TFileStream.Create(
    'C:\Work\Calc\SkinShell\skins\CIRCLES\default.jpg',fmOpenRead);
  try
    SetBackGroundBitMap(Stream);
  finally
    Stream.Free;
  end;
end;

end.
