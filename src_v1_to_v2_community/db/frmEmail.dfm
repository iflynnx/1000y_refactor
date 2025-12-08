object FormEmail: TFormEmail
  Left = 384
  Top = 293
  Width = 696
  Height = 480
  Caption = #37038#20214#20449#24687'('#20462#25913#21069#30830#35748'TGS'#26029#24320')'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 680
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 13
      Width = 11
      Height = 13
      Caption = 'ID'
    end
    object Edit_find_Email_ID: TEdit
      Left = 72
      Top = 10
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Button_find_Email_ID: TButton
      Left = 208
      Top = 8
      Width = 75
      Height = 25
      Caption = 'ID'#26597#25214
      TabOrder = 1
      OnClick = Button_find_Email_IDClick
    end
    object Button_Reload: TButton
      Left = 408
      Top = 8
      Width = 129
      Height = 25
      Caption = #37325#26032#35835#20986#25968#25454
      TabOrder = 2
      OnClick = Button_ReloadClick
    end
  end
  object Panel_update: TPanel
    Left = 0
    Top = 41
    Width = 680
    Height = 56
    Align = alTop
    TabOrder = 1
    object Label2: TLabel
      Left = 32
      Top = 24
      Width = 27
      Height = 13
      Caption = #21517#23383' '
    end
    object Button_change_Email: TButton
      Left = 408
      Top = 16
      Width = 75
      Height = 25
      Caption = #20462#25913
      Enabled = False
      TabOrder = 0
      OnClick = Button_change_EmailClick
    end
    object Edit_Email_find_name: TEdit
      Left = 70
      Top = 18
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object Button_find_Email_Name: TButton
      Left = 208
      Top = 16
      Width = 75
      Height = 25
      Caption = #21517#23383#26597#25214' '
      TabOrder = 2
      OnClick = Button_find_Email_NameClick
    end
  end
  object StringGrid_Email: TStringGrid
    Left = 0
    Top = 97
    Width = 680
    Height = 345
    Align = alClient
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 168
    Top = 136
    Width = 369
    Height = 281
    TabOrder = 3
    Visible = False
    object Label3: TLabel
      Left = 64
      Top = 8
      Width = 101
      Height = 20
      Caption = #37038#20214#20462#25913#26694'   '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 29
      Top = 50
      Width = 44
      Height = 13
      Caption = #37038#20214'ID   '
      Enabled = False
    end
    object Label5: TLabel
      Left = 11
      Top = 75
      Width = 75
      Height = 13
      Caption = #25509#25910#20154#21517#23383'     '
    end
    object Label6: TLabel
      Left = 24
      Top = 100
      Width = 51
      Height = 13
      Caption = #37038#20214#26631#39064' '
    end
    object Label7: TLabel
      Left = 22
      Top = 125
      Width = 54
      Height = 13
      Caption = #37038#20214#20869#23481'  '
    end
    object Label8: TLabel
      Left = 10
      Top = 147
      Width = 75
      Height = 13
      Caption = #21457#36865#20154#21517#23383'     '
    end
    object Label9: TLabel
      Left = 32
      Top = 172
      Width = 27
      Height = 13
      Caption = #26102#38388' '
    end
    object Label10: TLabel
      Left = 20
      Top = 195
      Width = 39
      Height = 13
      Caption = #28216#20384#24065' '
    end
    object Label12: TLabel
      Left = 20
      Top = 244
      Width = 24
      Height = 13
      Caption = #38468#20214
      Enabled = False
    end
    object Edit_Email_ID: TEdit
      Left = 88
      Top = 48
      Width = 121
      Height = 21
      Color = cl3DLight
      Enabled = False
      TabOrder = 0
    end
    object Edit_Email_DestName: TEdit
      Left = 88
      Top = 72
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object Edit_Email_Title: TEdit
      Left = 88
      Top = 96
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object Edit_Email_Text: TEdit
      Left = 88
      Top = 120
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object Edit_Email_SourceName: TEdit
      Left = 88
      Top = 144
      Width = 121
      Height = 21
      TabOrder = 4
    end
    object Edit_Email_Time: TEdit
      Left = 88
      Top = 168
      Width = 121
      Height = 21
      TabOrder = 5
    end
    object Edit_Email_ItemName: TEdit
      Left = 88
      Top = 240
      Width = 121
      Height = 21
      Color = cl3DLight
      Enabled = False
      TabOrder = 6
    end
    object Button_Email_Save: TButton
      Left = 184
      Top = 14
      Width = 89
      Height = 25
      Caption = #20889#20837#25968#25454#24211
      TabOrder = 7
      OnClick = Button_Email_SaveClick
    end
    object Button_Email_Close: TButton
      Left = 280
      Top = 12
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 8
      OnClick = Button_Email_CloseClick
    end
    object Edit_Email_GoldMoney: TEdit
      Left = 88
      Top = 191
      Width = 121
      Height = 21
      TabOrder = 9
    end
    object Button_item_edit: TButton
      Left = 224
      Top = 240
      Width = 75
      Height = 25
      Caption = #29289#21697#32534#36753
      TabOrder = 10
      OnClick = Button_item_editClick
    end
  end
end
