object OptionsForm: TOptionsForm
  Left = 483
  Top = 265
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Options'
  ClientHeight = 286
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    301
    286)
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 8
    Top = 254
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 0
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 216
    Top = 254
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    Kind = bkCancel
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 301
    Height = 241
    ActivePage = TabSheet1
    Align = alTop
    TabIndex = 0
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'General'
      object PrecisionLabel: TLabel
        Left = 24
        Top = 48
        Width = 43
        Height = 13
        Caption = 'Precision'
      end
      object Label1: TLabel
        Left = 24
        Top = 136
        Width = 85
        Height = 13
        Caption = 'Decimal separator'
      end
      object ResultBaseLabel: TLabel
        Left = 24
        Top = 104
        Width = 56
        Height = 13
        Caption = 'Result base'
      end
      object Label4: TLabel
        Left = 184
        Top = 136
        Width = 45
        Height = 13
        Caption = 'Exponent'
      end
      object CoProcessorCB: TCheckBox
        Left = 24
        Top = 16
        Width = 177
        Height = 17
        Caption = 'Use mathematical coprocessor'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = CoProcessorCBClick
      end
      object PrecisionSpinEdit: TSpinEdit
        Left = 80
        Top = 40
        Width = 105
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
        OnChange = PrecisionSpinEditChange
      end
      object DecimalSeparatorEdit: TEdit
        Left = 120
        Top = 128
        Width = 25
        Height = 21
        TabOrder = 2
        Text = ','
      end
      object NumLockAlwaysOnCB: TCheckBox
        Left = 23
        Top = 176
        Width = 137
        Height = 17
        Caption = 'NumLock always on'
        TabOrder = 3
      end
      object UseNumLockCheckBox: TCheckBox
        Left = 22
        Top = 156
        Width = 155
        Height = 17
        Caption = 'Popup on NumLock click'
        TabOrder = 4
      end
      object BaseSpinEdit: TSpinEdit
        Left = 88
        Top = 96
        Width = 49
        Height = 22
        MaxValue = 32
        MinValue = 2
        TabOrder = 5
        Value = 10
        OnChange = PrecisionSpinEditChange
      end
      object ResDMSCB: TCheckBox
        Left = 24
        Top = 72
        Width = 169
        Height = 17
        Caption = 'Result format Deg Min Sec'
        TabOrder = 6
        OnClick = ResDMSCBClick
      end
      object KeepOnTopCB: TCheckBox
        Left = 184
        Top = 156
        Width = 97
        Height = 17
        Caption = 'Always on top'
        TabOrder = 7
      end
      object ExpSymbolEdit: TEdit
        Left = 248
        Top = 128
        Width = 25
        Height = 21
        TabOrder = 8
        Text = '$'
        OnKeyPress = ExpSymbolEditKeyPress
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Skins'
      ImageIndex = 1
      object Label2: TLabel
        Left = 8
        Top = 72
        Width = 69
        Height = 13
        Caption = 'Skin file name:'
      end
      object WinCalcLabel: TLabel
        Left = 8
        Top = 136
        Width = 143
        Height = 13
        Cursor = crHandPoint
        Caption = 'http://www.HighCalc.narod.ru'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        Transparent = True
        OnClick = WinCalcLabelClick
      end
      object SkinFileNameEdit: TEdit
        Left = 8
        Top = 96
        Width = 241
        Height = 21
        TabOrder = 0
      end
      object Button1: TButton
        Left = 260
        Top = 96
        Width = 20
        Height = 20
        Caption = '...'
        TabOrder = 1
        OnClick = Button1Click
      end
      object NormalViewCheckBox: TCheckBox
        Left = 8
        Top = 24
        Width = 97
        Height = 17
        Caption = 'Normal view'
        TabOrder = 2
        OnClick = NormalViewCheckBoxClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Editor'
      ImageIndex = 2
      object Label3: TLabel
        Left = 8
        Top = 24
        Width = 41
        Height = 13
        Caption = 'Element:'
      end
      object ElementListBox: TListBox
        Left = 8
        Top = 48
        Width = 137
        Height = 81
        ItemHeight = 13
        Items.Strings = (
          'Expression field'
          'Result field'
          'Function tree')
        TabOrder = 0
        OnClick = ElementListBoxClick
      end
      object FontButton: TButton
        Left = 168
        Top = 48
        Width = 83
        Height = 25
        Caption = 'Font'
        TabOrder = 1
        OnClick = FontButtonClick
      end
      object Button3: TButton
        Left = 168
        Top = 104
        Width = 83
        Height = 25
        Caption = 'Color'
        TabOrder = 2
        OnClick = Button3Click
      end
      object TestFontPanel: TPanel
        Left = 16
        Top = 144
        Width = 241
        Height = 57
        Caption = 'Test Font'
        TabOrder = 3
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 168
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 240
  end
end
