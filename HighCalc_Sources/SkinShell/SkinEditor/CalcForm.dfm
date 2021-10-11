object CalcMainForm: TCalcMainForm
  Left = 343
  Top = 130
  BorderStyle = bsNone
  Caption = 'CalcMainForm'
  ClientHeight = 255
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object IndicatorEdit: TEdit
    Left = 24
    Top = 16
    Width = 121
    Height = 21
    BorderStyle = bsNone
    TabOrder = 0
    Visible = False
  end
  object InputMemo: TMemo
    Left = 40
    Top = 56
    Width = 89
    Height = 65
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = 5987163
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object OutMemo: TMemo
    Left = 40
    Top = 144
    Width = 89
    Height = 81
    BevelInner = bvNone
    BorderStyle = bsNone
    Color = 5987163
    TabOrder = 2
  end
  object FunctTree: TTreeView
    Left = 176
    Top = 72
    Width = 121
    Height = 97
    BevelInner = bvNone
    BorderStyle = bsNone
    Color = 5987163
    Indent = 19
    TabOrder = 3
  end
end
