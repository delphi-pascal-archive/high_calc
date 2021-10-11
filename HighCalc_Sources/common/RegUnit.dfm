object RegForm: TRegForm
  Left = 794
  Top = 419
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsNone
  Caption = 'RegForm'
  ClientHeight = 73
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 478
    Height = 73
    Align = alClient
    Brush.Color = clBtnFace
  end
  object BitBtn1: TBitBtn
    Left = 96
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Yes'
    TabOrder = 4
    Kind = bkYes
  end
  object BitBtn2: TBitBtn
    Left = 312
    Top = 40
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkCancel
  end
  object Edit3: TEdit
    Left = 24
    Top = 8
    Width = 80
    Height = 21
    TabOrder = 0
    OnChange = Edit3Change
  end
  object Edit4: TEdit
    Left = 144
    Top = 8
    Width = 80
    Height = 21
    TabOrder = 1
    OnChange = Edit4Change
  end
  object Edit5: TEdit
    Left = 264
    Top = 8
    Width = 80
    Height = 21
    TabOrder = 2
    OnChange = Edit5Change
  end
  object Edit6: TEdit
    Left = 376
    Top = 8
    Width = 80
    Height = 21
    TabOrder = 3
    OnChange = Edit6Change
  end
end
