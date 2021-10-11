object SkinForm: TSkinForm
  Left = 415
  Top = 278
  BorderStyle = bsNone
  Caption = 'SkinForm'
  ClientHeight = 340
  ClientWidth = 266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 266
    Height = 340
    Align = alClient
    OnPaint = PaintBox1Paint
  end
  object Button1: TButton
    Left = 128
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    Visible = False
    OnClick = Button1Click
  end
  object EditIndicator: TEdit
    Left = 32
    Top = 16
    Width = 121
    Height = 21
    BorderStyle = bsNone
    TabOrder = 1
  end
end
