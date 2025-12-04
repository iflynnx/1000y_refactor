object FrmGameToolsAssist: TFrmGameToolsAssist
  Left = 419
  Top = 177
  Width = 495
  Height = 367
  Caption = #32451#32423#36741#21161
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 8
    Width = 84
    Height = 13
    Caption = #26410#28385#32423#27494#21151#21015#34920
  end
  object Label2: TLabel
    Left = 288
    Top = 8
    Width = 72
    Height = 13
    Caption = #20462#28860#27494#21151#21015#34920
  end
  object Label3: TLabel
    Left = 96
    Top = 296
    Width = 156
    Height = 13
    Caption = #21452#20987#27494#21151#21152#20837#21040#20462#28860#27494#21151#21015#34920
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lstPreTraining: TListBox
    Left = 96
    Top = 31
    Width = 177
    Height = 253
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = lstPreTrainingDblClick
  end
  object lstTraining: TListBox
    Left = 288
    Top = 31
    Width = 177
    Height = 253
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = lstTrainingDblClick
  end
  object btnAddAll: TButton
    Left = 288
    Top = 296
    Width = 75
    Height = 25
    Caption = #20840#37096#21152#20837
    TabOrder = 2
    OnClick = btnAddAllClick
  end
  object btnExit: TButton
    Left = 392
    Top = 296
    Width = 75
    Height = 25
    Caption = #23436#25104
    ModalResult = 1
    TabOrder = 3
    OnClick = btnExitClick
  end
  object rb1: TRadioButton
    Left = 24
    Top = 40
    Width = 54
    Height = 17
    Caption = #26080#21517
    TabOrder = 4
    OnClick = rb1Click
  end
  object rb2: TRadioButton
    Tag = 1
    Left = 24
    Top = 72
    Width = 54
    Height = 17
    Caption = #19968#23618
    TabOrder = 5
    OnClick = rb1Click
  end
  object rb3: TRadioButton
    Tag = 2
    Left = 24
    Top = 104
    Width = 54
    Height = 17
    Caption = #20108#23618
    TabOrder = 6
    OnClick = rb1Click
  end
end
