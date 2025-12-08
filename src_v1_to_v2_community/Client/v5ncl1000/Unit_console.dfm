object FrmConsole: TFrmConsole
  Left = 192
  Top = 107
  Width = 805
  Height = 474
  Caption = #25511#21046#21488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 789
    Height = 335
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 335
    Width = 789
    Height = 101
    Align = alBottom
    TabOrder = 1
    object CheckBoxdraw: TCheckBox
      Left = 16
      Top = 16
      Width = 97
      Height = 17
      Caption = #32426#24405#32472#21046
      TabOrder = 0
    end
    object CheckBoxhave: TCheckBox
      Left = 112
      Top = 16
      Width = 97
      Height = 17
      Caption = #32426#24405#32972#21253
      TabOrder = 1
    end
    object CheckBoxlittlemap: TCheckBox
      Left = 224
      Top = 16
      Width = 97
      Height = 17
      Caption = #23567#22320#22270
      TabOrder = 2
    end
    object CheckBoxNet: TCheckBox
      Left = 304
      Top = 16
      Width = 97
      Height = 17
      Caption = #32593#32476
      TabOrder = 3
    end
    object CheckBox_WG: TCheckBox
      Left = 400
      Top = 16
      Width = 97
      Height = 17
      Caption = 'WG'
      TabOrder = 4
    end
    object CheckBox_RPacket: TCheckBox
      Left = 472
      Top = 16
      Width = 97
      Height = 17
      Caption = 'RPacket'
      TabOrder = 5
    end
  end
end
