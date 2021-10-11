object ShapeDlgForm: TShapeDlgForm
  Left = 507
  Top = 114
  Width = 219
  Height = 165
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1082#1086#1085#1090#1091#1088#1072
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 37
    Height = 13
    Caption = #1060#1086#1088#1084#1072
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 50
    Height = 13
    Caption = #1054#1087#1077#1088#1072#1094#1080#1103
  end
  object ComboBox1: TComboBox
    Left = 10
    Top = 26
    Width = 199
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 0
    Items.Strings = (
      #1050#1088#1091#1075
      #1069#1083#1083#1080#1087#1089
      #1055#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1080#1082
      #1047#1072#1082#1088#1091#1075#1083#1077#1085#1085#1099#1081' '#1087#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1080#1082
      #1052#1085#1086#1075#1086#1091#1075#1086#1083#1100#1085#1080#1082)
  end
  object CodEdit1: TEdit
    Left = 218
    Top = 25
    Width = 89
    Height = 21
    TabOrder = 1
    Visible = False
  end
  object BitBtn1: TBitBtn
    Left = 16
    Top = 104
    Width = 75
    Height = 25
    Caption = #1044#1072
    TabOrder = 2
    Kind = bkYes
  end
  object BitBtn2: TBitBtn
    Left = 128
    Top = 104
    Width = 75
    Height = 25
    Caption = #1053#1077#1090
    TabOrder = 3
    Kind = bkCancel
  end
  object OperationComboBox: TComboBox
    Left = 10
    Top = 66
    Width = 199
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 4
  end
end
