object GrumblingForm: TGrumblingForm
  Left = 336
  Top = 259
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'GrumblingForm'
  ClientHeight = 267
  ClientWidth = 582
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BuyLabel: TLabel
    Left = 0
    Top = 0
    Width = 585
    Height = 225
    AutoSize = False
    Caption = 
      '                Buy '#13#10'High Precision  Calculator '#13#10'             ' +
      '   Now!'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -53
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object DateLabel: TLabel
    Left = 32
    Top = 184
    Width = 49
    Height = 13
    Caption = 'DateLabel'
  end
  object DaysLabel: TLabel
    Left = 400
    Top = 136
    Width = 50
    Height = 13
    Caption = 'DaysLabel'
  end
  object WinCalcLabel: TLabel
    Left = 24
    Top = 208
    Width = 117
    Height = 13
    Cursor = crHandPoint
    Caption = 'http://www.wincalc.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
    OnClick = WinCalcLabelClick
    OnMouseEnter = Purchasing1MouseEnter
    OnMouseLeave = Purchasing1MouseLeave
  end
  object Purchasing1: TLabel
    Left = 368
    Top = 184
    Width = 59
    Height = 13
    Cursor = crHandPoint
    Caption = 'Purchasing1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
    OnClick = Purchasing1Click
    OnMouseEnter = Purchasing1MouseEnter
    OnMouseLeave = Purchasing1MouseLeave
  end
  object Purchasing2: TLabel
    Left = 368
    Top = 208
    Width = 59
    Height = 13
    Cursor = crHandPoint
    Caption = 'Purchasing2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
    OnClick = Purchasing2Click
    OnMouseEnter = Purchasing1MouseEnter
    OnMouseLeave = Purchasing1MouseLeave
  end
  object RunButton: TButton
    Left = 512
    Top = 232
    Width = 57
    Height = 25
    Hint = 'Run Evaluation Copy'
    Caption = 'Run'
    Enabled = False
    ModalResult = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object BuyButton: TButton
    Left = 152
    Top = 232
    Width = 153
    Height = 25
    Caption = 'Buy Now'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BuyButtonClick
  end
  object ExitButton: TButton
    Left = 8
    Top = 232
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Exit'
    ModalResult = 2
    TabOrder = 2
    OnClick = ExitButtonClick
  end
  object RegButton: TButton
    Left = 352
    Top = 232
    Width = 137
    Height = 25
    Caption = 'Input Registration Code'
    TabOrder = 3
    OnClick = RegButtonClick
  end
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 32
    Top = 16
  end
end
