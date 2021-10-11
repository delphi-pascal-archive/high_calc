object PlotForm: TPlotForm
  Left = 308
  Top = 179
  Width = 499
  Height = 536
  Caption = 'Plot High Precision Calculator'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PlotMathIm: TMathImage
    Left = 0
    Top = 0
    Width = 491
    Height = 431
    Align = alClient
    version = '3.0 July 98 '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    D3ViewDist = 6.4
    D3ViewAngle = 6
    D3AspectRatio = True
    OnRotating = PlotMathImRotating
    OnZooming = PlotMathImZooming
    OnZoomStop = PlotMathImZoomStop
    D2WorldX1 = -1
    D2WorldX2 = 1
    D2WorldY1 = -1
    D2WorldY2 = 1
    D3WorldX1 = -1
    D3WorldY1 = -1
    D3WorldZ1 = -1
    D3WorldX2 = 1
    D3WorldY2 = 1
    D3WorldZ2 = 1
    D3Zrotation = 45
    D3Yrotation = 45
  end
  object Panel3D: TPanel
    Left = 0
    Top = 431
    Width = 491
    Height = 78
    Align = alBottom
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 3
      Width = 100
      Height = 14
      Caption = 'Rotate Viewpoint  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 143
      Top = 3
      Width = 93
      Height = 14
      Caption = 'Zoom Viewlens  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object UpButton: TButton
      Left = 46
      Top = 18
      Width = 37
      Height = 15
      Caption = 'up'
      TabOrder = 0
      OnMouseDown = UpButtonMouseDown
      OnMouseUp = UpButtonMouseUp
    end
    object LeftButton: TButton
      Left = 87
      Top = 33
      Width = 39
      Height = 16
      Caption = 'left'
      TabOrder = 1
      OnMouseDown = LeftButtonMouseDown
      OnMouseUp = DownButtonMouseUp
    end
    object RightButton: TButton
      Left = 4
      Top = 33
      Width = 38
      Height = 16
      Caption = 'right'
      TabOrder = 2
      OnMouseDown = RightButtonMouseDown
      OnMouseUp = DownButtonMouseUp
    end
    object DownButton: TButton
      Left = 46
      Top = 49
      Width = 37
      Height = 16
      Caption = 'down'
      TabOrder = 3
      OnMouseDown = DownButtonMouseDown
      OnMouseUp = DownButtonMouseUp
    end
    object InButton: TButton
      Left = 151
      Top = 30
      Width = 31
      Height = 16
      Caption = 'in'
      TabOrder = 4
      OnMouseDown = InButtonMouseDown
      OnMouseUp = InButtonMouseUp
    end
    object OutButton: TButton
      Left = 196
      Top = 30
      Width = 31
      Height = 16
      Caption = 'out'
      TabOrder = 5
      OnMouseDown = OutButtonMouseDown
      OnMouseUp = InButtonMouseUp
    end
    object FillCheck: TCheckBox
      Left = 319
      Top = 32
      Width = 42
      Height = 15
      Caption = 'Fill'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object WareColorPanel: TPanel
      Left = 248
      Top = 8
      Width = 65
      Height = 17
      BevelOuter = bvNone
      Caption = 'Ware color'
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = FillColorPanelClick
    end
    object FillColorPanel: TPanel
      Left = 248
      Top = 24
      Width = 65
      Height = 17
      BevelOuter = bvNone
      Caption = 'Fill color'
      Color = 4259584
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = FillColorPanelClick
    end
    object RedrawButton: TButton
      Left = 152
      Top = 56
      Width = 75
      Height = 17
      Caption = 'Redraw'
      TabOrder = 9
      OnClick = RedrawButtonClick
    end
    object Aspectcheck: TCheckBox
      Left = 321
      Top = 8
      Width = 97
      Height = 14
      Caption = 'Aspect Ratio'
      Checked = True
      State = cbChecked
      TabOrder = 10
    end
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 392
    Top = 16
  end
end
