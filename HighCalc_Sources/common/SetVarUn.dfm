object SetVar: TSetVar
  Left = 715
  Top = 211
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Set variable'
  ClientHeight = 104
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 67
    Height = 13
    Caption = 'Variable name'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 67
    Height = 13
    Caption = 'Variable value'
  end
  object VarNameEdit: TEdit
    Left = 88
    Top = 8
    Width = 201
    Height = 21
    TabOrder = 0
    OnKeyPress = VarNameEditKeyPress
  end
  object VarValueEdit: TEdit
    Left = 88
    Top = 40
    Width = 201
    Height = 21
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 32
    Top = 72
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 200
    Top = 72
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
end
