object HelpFuncForm: THelpFuncForm
  Left = 408
  Top = 435
  BorderStyle = bsNone
  Caption = 'HelpFuncForm'
  ClientHeight = 90
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FuncListBox: TListBox
    Left = 0
    Top = 0
    Width = 274
    Height = 90
    Align = alClient
    BorderStyle = bsNone
    Color = 11468799
    ItemHeight = 13
    Items.Strings = (
      'sadf'
      'sdf'
      'sdf'
      'sdf')
    TabOrder = 0
    OnDblClick = FuncListBoxDblClick
    OnKeyDown = FuncListBoxKeyDown
  end
end
