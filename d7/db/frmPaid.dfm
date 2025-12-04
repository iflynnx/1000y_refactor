object FormPaid: TFormPaid
  Left = 179
  Top = 211
  Width = 367
  Height = 305
  Caption = #28857#21345#20449#24687
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 359
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 36
      Height = 13
      Caption = #36134' '#21495'   '
    end
    object Edit_find_Paid: TEdit
      Left = 50
      Top = 11
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Button_find_paid: TButton
      Left = 176
      Top = 8
      Width = 75
      Height = 25
      Caption = #26597#25214
      TabOrder = 1
      OnClick = Button_find_paidClick
    end
    object Button_SavePaid_DB: TButton
      Left = 256
      Top = 8
      Width = 89
      Height = 25
      Caption = #20889#20837#25968#25454#24211
      TabOrder = 2
      OnClick = Button_SavePaid_DBClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 359
    Height = 237
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #22312#32447#36134#21495
      object Memo_paid: TMemo
        Left = 0
        Top = 0
        Width = 137
        Height = 172
        Color = clSilver
        Ctl3D = False
        ParentCtl3D = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Panel3: TPanel
        Left = 144
        Top = 8
        Width = 169
        Height = 59
        BevelOuter = bvLowered
        TabOrder = 1
        object Label8: TLabel
          Left = 10
          Top = 9
          Width = 24
          Height = 13
          Caption = #24080#25143
        end
        object Edit_loginid: TEdit
          Left = 44
          Top = 3
          Width = 73
          Height = 21
          TabOrder = 0
        end
        object Button2: TButton
          Left = 72
          Top = 31
          Width = 42
          Height = 25
          Caption = #26597#35810
          TabOrder = 1
          OnClick = Button2Click
        end
        object Button1: TButton
          Left = 8
          Top = 32
          Width = 58
          Height = 25
          Caption = #25152#26377#29992#25143
          TabOrder = 2
          OnClick = Button1Click
        end
      end
      object Panel4: TPanel
        Left = 144
        Top = 68
        Width = 170
        Height = 60
        BevelOuter = bvLowered
        TabOrder = 2
        object Label9: TLabel
          Left = 9
          Top = 5
          Width = 24
          Height = 13
          Caption = #35282#33394
        end
        object Edit_char: TEdit
          Left = 46
          Top = 3
          Width = 69
          Height = 21
          TabOrder = 0
        end
        object Button3: TButton
          Left = 7
          Top = 30
          Width = 44
          Height = 25
          Caption = #26597#35810
          TabOrder = 1
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 63
          Top = 30
          Width = 50
          Height = 25
          Caption = #36386#19979#32447
          TabOrder = 2
          OnClick = Button4Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #25968#25454#24211#32534#36753
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 351
        Height = 209
        Align = alClient
        TabOrder = 0
        object Label2: TLabel
          Left = 56
          Top = 42
          Width = 39
          Height = 13
          Caption = ' '#36134' '#21495'   '
          Enabled = False
        end
        object Label3: TLabel
          Left = 64
          Top = 70
          Width = 19
          Height = 13
          Caption = ' I  P'
        end
        object Label4: TLabel
          Left = 46
          Top = 94
          Width = 54
          Height = 13
          Caption = #21097#20313#26102#38388'  '
        end
        object Label5: TLabel
          Left = 61
          Top = 119
          Width = 30
          Height = 13
          Caption = #31867#22411'  '
        end
        object Label6: TLabel
          Left = 55
          Top = 142
          Width = 42
          Height = 13
          Caption = 'rmaturity '
        end
        object Label7: TLabel
          Left = 58
          Top = 167
          Width = 34
          Height = 13
          Caption = 'rCode  '
        end
        object Edit_Paid_ID: TEdit
          Left = 136
          Top = 37
          Width = 121
          Height = 21
          Color = cl3DLight
          Enabled = False
          TabOrder = 0
        end
        object Edit_Paid_IP: TEdit
          Left = 136
          Top = 65
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object Edit_Paid_RemainDay: TEdit
          Left = 136
          Top = 89
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object Edit_Paid_maturity: TEdit
          Left = 136
          Top = 137
          Width = 121
          Height = 21
          TabOrder = 3
        end
        object Edit_Paid_code: TEdit
          Left = 136
          Top = 162
          Width = 121
          Height = 21
          TabOrder = 4
        end
        object Button_Paid_Save: TButton
          Left = 272
          Top = 8
          Width = 75
          Height = 25
          Caption = #20445#23384
          TabOrder = 5
          OnClick = Button_Paid_SaveClick
        end
        object ComboBox_type: TComboBox
          Left = 136
          Top = 112
          Width = 121
          Height = 21
          ItemHeight = 13
          TabOrder = 6
          Text = 'NONE'
          Items.Strings = (
            'pt_none'
            'pt_invalidate'
            'pt_validate'
            'pt_test'
            'pt_timepay')
        end
      end
    end
  end
end
