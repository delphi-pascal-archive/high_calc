object MainForm: TMainForm
  Left = 403
  Top = 286
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Install High precision calculator'
  ClientHeight = 269
  ClientWidth = 382
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
  object InfoLabel: TLabel
    Left = 32
    Top = 32
    Width = 116
    Height = 39
    Caption = 
      'The program will install '#13#10'High precision calculator'#13#10'on your co' +
      'mputer'
  end
  object LicenseLabel: TLabel
    Left = 16
    Top = 8
    Width = 342
    Height = 26
    Caption = 
      'Please closely read the folllowing license agreement. Do you acc' +
      'ept ALL'#13#10'the terms of the following license areement?'
  end
  object InstLabel: TLabel
    Left = 8
    Top = 16
    Width = 93
    Height = 13
    Caption = 'Installation directory'
  end
  object CopyLabel: TLabel
    Left = 8
    Top = 8
    Width = 66
    Height = 13
    Caption = 'Coping files ...'
  end
  object PrevButton: TButton
    Left = 24
    Top = 232
    Width = 75
    Height = 25
    Caption = '<<  Prev'
    TabOrder = 0
    Visible = False
    OnClick = PrevButtonClick
  end
  object NextButton: TButton
    Left = 280
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Next  >>'
    TabOrder = 1
    OnClick = NextButtonClick
  end
  object LicenseMemo: TMemo
    Left = 8
    Top = 40
    Width = 361
    Height = 129
    Lines.Strings = (
      '   LICENSE AGREEMENT.'
      ''
      'IMPORTANT: PLEASE READ THIS AGREEMENT CAREFULLY BEFORE '
      'CONTINUING WITH THE INSTALLATION PROCESS OF THE '
      'ACCOMPANING SOFTWARE (the "Software").'
      ''
      
        '"High precision calculator" is a shareware program as defined be' +
        'low in the '
      
        '"High precision calculator" End User License Agreement. All user' +
        's have 30 '
      
        'days to evaluate this Software. After this period you should reg' +
        'ister or stop '
      'using this Software.'
      ''
      'BY INSTALLING AND USING THIS SOFTWARE, YOU ARE '
      'CONSENTING TO BE BOUND BY THIS AGREEMENT. IF YOU DO NOT '
      'AGREE TO ALL OF THE TERMS OF THIS AGREEMENT, YOU SHOULD '
      'NOT USE THIS SOFTWARE.'
      ' '
      '"High precision calculator" END USER LICENSE AGREEMENT'
      ''
      'LICENSE. The Software may be freely distributed.'
      ''
      'The Software is licensed to you, not sold. So, you may not: '
      ''
      
        '   rent, lease, grant a security interest in, or otherwise trans' +
        'fer rights to the '
      'Software; or '
      ''
      
        '   modify or remove any proprietary notices or labels on the Sof' +
        'tware; or '
      ''
      '   disassemble the Software; or'
      ''
      '   change the executable code of the Software; or'
      ''
      '   generate key-files for the Software; or '
      ''
      
        '   sell this Software both standalone and part of a purchasable ' +
        'collection of '
      'software without author'#39's explicit permission. '
      ''
      'You can:'
      ''
      
        '   use the Software for 30 days since first installation and reg' +
        'ister the '
      'Software if you decide to use it after the specified period; '
      ''
      
        '   freely redistribute this software only in whole package witho' +
        'ut any kind of '
      'modifications;'
      ''
      
        'The Software was developed at private expense, and no part of it' +
        ' was '
      'developed with governmental funds.'
      '                                                    '
      
        'TITLE. Title, ownership rights, and intellectual property rights' +
        ' in the '
      
        'Software shall remain in the author'#39's possession. The Software i' +
        's protected '
      'by copyright laws and treaties. '
      ''
      
        'TERMINATION. The license will terminate automatically if you fai' +
        'l to comply '
      
        'with the limitations described herein. On termination, you must ' +
        'stop using all '
      'copies of the Software. '
      ''
      'THE SOFTWARE IS PROVIDED TO YOU "AS IS" WITHOUT '
      'WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, '
      'INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF '
      'MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR '
      'PURPOSE.  YOU ASSUME THE ENTIRE RISK AS TO THE ACCURACY '
      'AND THE USE OF THE REDISTRIBUTABLE CODE.  AUTHOR SHALL '
      'NOT BE LIABLE FOR ANY DAMAGES WHATSOEVER ARISING OUT OF '
      'THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF '
      'AUTHOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH '
      'DAMAGE.')
    TabOrder = 2
    Visible = False
  end
  object FolderEdit: TEdit
    Left = 8
    Top = 40
    Width = 289
    Height = 21
    TabOrder = 3
    Text = 'C:\Program Files\Calc1'
  end
  object FolderButton: TButton
    Left = 304
    Top = 40
    Width = 73
    Height = 22
    Caption = 'Browse...'
    TabOrder = 4
    OnClick = FolderButtonClick
  end
  object DeskTopCheckBox: TCheckBox
    Left = 16
    Top = 88
    Width = 265
    Height = 17
    Caption = 'Create Shutcut on desktop'
    TabOrder = 5
  end
  object StartUpCheckBox: TCheckBox
    Left = 16
    Top = 112
    Width = 185
    Height = 17
    Caption = 'Add to startup menu'
    TabOrder = 6
  end
  object LicenseAgreeRadioGroup: TRadioGroup
    Left = 8
    Top = 176
    Width = 185
    Height = 49
    Items.Strings = (
      'I agree.'
      'I d'#39'not agree.')
    TabOrder = 7
    OnClick = LicenseAgreeRadioGroupClick
  end
  object CopyProgressBar: TProgressBar
    Left = 16
    Top = 40
    Width = 345
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 8
  end
  object LanchMathCalc: TCheckBox
    Left = 16
    Top = 72
    Width = 249
    Height = 17
    Caption = 'Lanch High precision calculator'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object NumLockAlwaysOnCB: TCheckBox
    Left = 16
    Top = 160
    Width = 137
    Height = 17
    Caption = 'Num Lock always on'
    TabOrder = 10
  end
  object UseNumLockCheckBox: TCheckBox
    Left = 16
    Top = 136
    Width = 265
    Height = 17
    Caption = 'Use Num Lock key for fast call calculator'
    TabOrder = 11
  end
  object UseCoProcCB: TCheckBox
    Left = 16
    Top = 184
    Width = 185
    Height = 17
    Caption = 'Use mathematical coprocessor'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object Cancel: TButton
    Left = 152
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 13
    OnClick = CancelClick
  end
  object OpenDialog1: TOpenDialog
    Left = 248
    Top = 184
  end
end
