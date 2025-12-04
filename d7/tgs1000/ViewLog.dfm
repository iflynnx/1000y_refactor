object frmLog: TfrmLog
  Left = 230
  Top = 106
  Width = 576
  Height = 561
  Caption = 'Log'
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
    Width = 560
    Height = 330
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 330
    Width = 560
    Height = 193
    ActivePage = TabSheet2
    Align = alBottom
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #20154#29289#30417#35270
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 60
        Height = 13
        Caption = #30417#35270#20154#21517#23383
      end
      object Edit1: TEdit
        Left = 88
        Top = 16
        Width = 169
        Height = 21
        TabOrder = 0
        OnChange = Edit1Change
      end
      object Button1: TButton
        Left = 288
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20844#21578
      ImageIndex = 1
      object Button2: TButton
        Left = 336
        Top = 16
        Width = 75
        Height = 25
        Caption = #21457#36865'1'
        TabOrder = 0
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 336
        Top = 48
        Width = 75
        Height = 25
        Caption = #21457#36865'2'
        TabOrder = 1
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 336
        Top = 80
        Width = 75
        Height = 25
        Caption = #21457#36865'3'
        TabOrder = 2
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 336
        Top = 112
        Width = 75
        Height = 25
        Caption = #21457#36865'4'
        TabOrder = 3
        OnClick = Button5Click
      end
      object ComboBox1: TComboBox
        Left = 16
        Top = 16
        Width = 297
        Height = 21
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 4
        Text = '30'#20998#38047#21518#32500#25252#65292#20572#26426#32500#25252'5'#20998#38047#65292#35831#21040#23433#20840#21306#19979#32447
        Items.Strings = (
          '30'#20998#38047#21518#32500#25252#65292#20572#26426#32500#25252'5'#20998#38047#65292#35831#21040#23433#20840#21306#19979#32447
          '1'#23567#26102#21518#32500#25252#65292#20572#26426#32500#25252'5'#20998#38047#65292#35831#21040#23433#20840#21306#19979#32447)
      end
      object Button6: TButton
        Left = 120
        Top = 88
        Width = 89
        Height = 25
        Caption = #33258#23450#20041#28040#24687
        TabOrder = 5
        OnClick = Button6Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
    end
  end
end
