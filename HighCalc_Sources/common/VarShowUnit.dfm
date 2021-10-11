object VarShowForm: TVarShowForm
  Left = 483
  Top = 440
  Width = 262
  Height = 191
  Caption = 'Variables in memory'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  DesignSize = (
    254
    157)
  PixelsPerInch = 96
  TextHeight = 13
  object VariablesStringGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 254
    Height = 122
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 2
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 0
    OnKeyPress = VariablesStringGridKeyPress
    OnSelectCell = VariablesStringGridSelectCell
    OnSetEditText = VariablesStringGridSetEditText
  end
  object NewButton: TButton
    Left = 8
    Top = 127
    Width = 41
    Height = 25
    Hint = 'New variable'
    Anchors = [akLeft, akBottom]
    Caption = 'New '
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = NewButtonClick
  end
  object DelButton: TButton
    Left = 112
    Top = 127
    Width = 33
    Height = 25
    Hint = 'Delete variable'
    Anchors = [akLeft, akBottom]
    Caption = 'Del'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = DelButtonClick
  end
  object SaveButton: TButton
    Left = 152
    Top = 127
    Width = 41
    Height = 25
    Hint = 'Save variables to file'
    Anchors = [akLeft, akBottom]
    Caption = 'Save'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = SaveButtonClick
  end
  object LoadButton: TButton
    Left = 200
    Top = 127
    Width = 41
    Height = 25
    Hint = 'Load variables from file'
    Anchors = [akLeft, akBottom]
    Caption = 'Load'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = LoadButtonClick
  end
  object ChangeValButton: TButton
    Left = 56
    Top = 127
    Width = 49
    Height = 25
    Hint = 'Change variable value'
    Anchors = [akLeft, akBottom]
    Caption = 'Change'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = ChangeValButtonClick
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.txt'
    Filter = 'TXT|*.TXT|All Files|*.*'
    Left = 160
    Top = 40
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.txt'
    Filter = 'TXT|*.TXT|All Files|*.*'
    Left = 40
    Top = 56
  end
end
