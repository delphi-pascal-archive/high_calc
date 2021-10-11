unit PaintBoxWithRubberShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,Math;

type
  TRubberChangeEvent=procedure (Sender:TObject;var Rect:TRect) of object;
  TPaintBoxWithRubberShape = class(TPaintBox)
  private
    { Private declarations }
    FOnRubberChange:TRubberChangeEvent;
    XRub1,YRub1,XRub2,YRub2:integer;
    FRubBrushStyle:TBrushStyle;
    FRubPenStyle:TPenStyle;
    FRubPenMode:TPenMode;
    FRubPenColor:TColor;
    tmpRubBrushStyle:TBrushStyle;
    tmpRubPenStyle:TPenStyle;
    tmpRubPenMode:TPenMode;
    tmpRubPenColor:TColor;
    tmpRubPenWidth:integer;
    IsRub:boolean;
    FIsRubMode:boolean;
  protected
    { Protected declarations }
    procedure MouseDown (Button: TMouseButton; Shift:TShiftState;X,Y:integer); override;
    procedure MouseMove (Shift:TShiftState;X,Y:integer); override;
    procedure MouseUp (Button: TMouseButton; Shift:TShiftState;X,Y:integer); override;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
  published
    { Published declarations }
     property OnRubberChange:TRubberChangeEvent
        read FOnRubberChange
        write FOnRubberChange;
     property  RubBrushStyle:TBrushStyle
        read   FRubBrushStyle
        write  FRubBrushStyle default bsClear;
     property  RubPenStyle:TPenStyle
        read  FRubPenStyle
        write FRubPenStyle default psDashDotDot;
     property  RubPenMode:TPenMode
        read  FRubPenMode
        write FRubPenMode default pmNot;
     property  RubPenColor:TColor
        read  FRubPenColor
        write FRubPenColor default clBlack;
     property IsRubMode: boolean
        read  FIsRubMode
        write FIsRubMode default True;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('System', [TPaintBoxWithRubberShape]);
end;
procedure TPaintBoxWithRubberShape.MouseDown (Button: TMouseButton; Shift:TShiftState;X,Y:integer);
begin
    inherited MouseDown (Button,Shift,X,Y);
//    ShowMessage('Print');
   if not(IsRubMode) then exit;
   IsRub:=True;
   XRub1:=X;
   YRub1:=Y;
   XRub2:=X;
   YRub2:=Y;
   with Canvas do
   begin
       tmpRubBrushStyle:=Brush.Style;
       tmpRubPenStyle:=Pen.Style;
       tmpRubPenMode:=Pen.Mode;
       tmpRubPenColor:=Pen.Color;
       tmpRubPenWidth:=Pen.Width;
       Pen.Mode:=RubPenMode;
       Pen.Style:= RubPenStyle;
       Pen.Color:= RubPenColor;
       Pen.Width:=0;
       Brush.Style:=RubBrushStyle;//bsClear;
       Rectangle(x,y,x,y);
   end;
end;
procedure TPaintBoxWithRubberShape.MouseMove (Shift:TShiftState;X,Y:integer);
begin
    inherited MouseMove (Shift,X,Y);
    if IsRub then
    begin
       Canvas.Rectangle(xRub1,yRub1,xRub2,yRub2);
       XRub2:=X;
       YRub2:=Y;
       Canvas.Rectangle(xRub1,yRub1,xRub2,yRub2);
       if Canvas.Brush.Style<>RubBrushStyle then
              Canvas.Brush.Style:=RubBrushStyle;
    end;
end;
procedure TPaintBoxWithRubberShape.MouseUp (Button: TMouseButton;
                                                Shift:TShiftState;X,Y:integer);
var
   r:TRect;
   CallMouseUp:boolean;
begin
    CallMouseUp:=true;
    if IsRub then
    begin
       IsRub:=False;
       Canvas.Rectangle(xRub1,yRub1,xRub2,yRub2);
       XRub2:=X;
       YRub2:=Y;
       r:=Rect(Min(xRub1,xRub2),Min(yRub1,yRub2),Max(xRub1,xRub2),
                               Max(yRub1,yRub2));
       with canvas do
       begin
          Brush.Style:=tmpRubBrushStyle;
          Pen.Style:=tmpRubPenStyle;
          Pen.Mode:=tmpRubPenMode;
          Pen.Width:=tmpRubPenWidth;
          Pen.Color:=tmpRubPenColor;
       end;
       with r do
         if Assigned(FOnRubberChange)and((Left<>Right)and(Top<>Bottom))then
         begin
             FOnRubberChange(Self,r);
             CallMouseUp:=false;
         end;
    end;
    if CallMouseUp then
       inherited MouseUp (Button,Shift,X,Y);
end;
constructor TPaintBoxWithRubberShape.Create(AOwner:TComponent);
begin
   inherited Create(AOwner);
   IsRub:=False;
   IsRubMode:=True;
   RubBrushStyle:=bsClear;
   RubPenStyle:=psDashDotDot;
   RubPenMode:=pmNot;
   RubPenColor:=clBlack;
   IsRubMode:=True;
end;

end.

