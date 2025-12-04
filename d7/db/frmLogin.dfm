object FormLogin: TFormLogin
  Left = 229
  Top = 146
  AutoScroll = False
  Caption = #36134#21495#20449#24687
  ClientHeight = 446
  ClientWidth = 532
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
  object panel_account: TPanel
    Left = 0
    Top = 57
    Width = 532
    Height = 389
    Align = alClient
    TabOrder = 0
    object Label2: TLabel
      Left = 32
      Top = 18
      Width = 24
      Height = 13
      Caption = #36134#21495
      Color = cl3DLight
      Enabled = False
      ParentColor = False
    end
    object Label3: TLabel
      Left = 24
      Top = 67
      Width = 52
      Height = 13
      Caption = 'PrimaryKey'
      Color = cl3DLight
      Enabled = False
      ParentColor = False
    end
    object Label4: TLabel
      Left = 24
      Top = 89
      Width = 49
      Height = 13
      Caption = 'PassWord'
    end
    object Label5: TLabel
      Left = 24
      Top = 114
      Width = 50
      Height = 13
      Caption = 'UserName'
    end
    object Label6: TLabel
      Left = 32
      Top = 139
      Width = 21
      Height = 13
      Caption = 'Birth'
    end
    object Label7: TLabel
      Left = 24
      Top = 164
      Width = 38
      Height = 13
      Caption = 'Address'
    end
    object Label8: TLabel
      Left = 8
      Top = 187
      Width = 68
      Height = 13
      Caption = 'NativeNumber'
    end
    object Label9: TLabel
      Left = 24
      Top = 212
      Width = 50
      Height = 13
      Caption = 'MasterKey'
    end
    object Label10: TLabel
      Left = 32
      Top = 236
      Width = 25
      Height = 13
      Caption = 'Email'
    end
    object Label11: TLabel
      Left = 32
      Top = 256
      Width = 31
      Height = 13
      Caption = 'Phone'
    end
    object Label12: TLabel
      Left = 17
      Top = 283
      Width = 59
      Height = 13
      Caption = 'ParentName'
    end
    object Label13: TLabel
      Left = 2
      Top = 307
      Width = 99
      Height = 13
      Caption = 'ParentNativeNumber'
    end
    object Label14: TLabel
      Left = 14
      Top = 331
      Width = 60
      Height = 13
      Caption = 'Char1_name'
    end
    object Label16: TLabel
      Left = 249
      Top = 116
      Width = 60
      Height = 13
      Caption = 'Char4_name'
    end
    object Label17: TLabel
      Left = 251
      Top = 140
      Width = 60
      Height = 13
      Caption = 'Char5_name'
    end
    object Label18: TLabel
      Left = 243
      Top = 164
      Width = 71
      Height = 13
      Caption = 'Server1_Name'
    end
    object Label20: TLabel
      Left = 248
      Top = 333
      Width = 43
      Height = 13
      Caption = 'LastDate'
    end
    object Label21: TLabel
      Left = 240
      Top = 190
      Width = 71
      Height = 13
      Caption = 'Server2_Name'
    end
    object Label22: TLabel
      Left = 240
      Top = 213
      Width = 71
      Height = 13
      Caption = 'Server3_Name'
    end
    object Label23: TLabel
      Left = 240
      Top = 236
      Width = 71
      Height = 13
      Caption = 'Server4_Name'
    end
    object Label24: TLabel
      Left = 240
      Top = 261
      Width = 71
      Height = 13
      Caption = 'Server5_Name'
    end
    object Label25: TLabel
      Left = 248
      Top = 308
      Width = 50
      Height = 13
      Caption = 'MakeDate'
    end
    object Label26: TLabel
      Left = 256
      Top = 285
      Width = 31
      Height = 13
      Caption = 'IpAddr'
    end
    object Label19: TLabel
      Left = 250
      Top = 93
      Width = 60
      Height = 13
      Caption = 'Char3_name'
    end
    object Label15: TLabel
      Left = 250
      Top = 67
      Width = 60
      Height = 13
      Caption = 'Char2_name'
    end
    object Edit_db_primary: TEdit
      Left = 96
      Top = 12
      Width = 121
      Height = 21
      BevelKind = bkTile
      BevelOuter = bvRaised
      BiDiMode = bdLeftToRight
      Color = cl3DLight
      DragMode = dmAutomatic
      Enabled = False
      ParentBiDiMode = False
      TabOrder = 0
    end
    object Edit_Primarkey: TEdit
      Left = 102
      Top = 64
      Width = 121
      Height = 21
      Color = cl3DLight
      Enabled = False
      TabOrder = 1
    end
    object Edit_password: TEdit
      Left = 102
      Top = 88
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 2
    end
    object Edit_UserName: TEdit
      Left = 102
      Top = 112
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 3
    end
    object Edit_Birth: TEdit
      Left = 102
      Top = 136
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 4
    end
    object Edit_Address: TEdit
      Left = 102
      Top = 160
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 5
    end
    object Edit_NativeNumber: TEdit
      Left = 102
      Top = 184
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 6
    end
    object Edit_MasterKey: TEdit
      Left = 102
      Top = 208
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 7
    end
    object Edit_Email: TEdit
      Left = 102
      Top = 232
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 8
    end
    object Edit_Phone: TEdit
      Left = 102
      Top = 256
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 9
    end
    object Edit_ParentName: TEdit
      Left = 102
      Top = 280
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 10
    end
    object Edit_ParentNativeNumber: TEdit
      Left = 102
      Top = 304
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 11
    end
    object Edit_Char1_name: TEdit
      Left = 102
      Top = 328
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 12
    end
    object Edit_Char3_name: TEdit
      Left = 320
      Top = 88
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 13
    end
    object Edit_Char4_name: TEdit
      Left = 320
      Top = 112
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 14
    end
    object Edit_Char5_name: TEdit
      Left = 320
      Top = 136
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 15
    end
    object Edit_Server1_Name: TEdit
      Left = 320
      Top = 160
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 16
    end
    object Edit_Server2_Name: TEdit
      Left = 320
      Top = 184
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 17
    end
    object Edit_Server3_Name: TEdit
      Left = 320
      Top = 208
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 18
    end
    object Edit_Server4_Name: TEdit
      Left = 320
      Top = 232
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 19
    end
    object Edit_Server5_Name: TEdit
      Left = 320
      Top = 256
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 20
    end
    object Edit_IpAddr: TEdit
      Left = 320
      Top = 280
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 21
    end
    object Edit_MakeDate: TEdit
      Left = 320
      Top = 304
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 22
    end
    object Edit_LastDate: TEdit
      Left = 320
      Top = 328
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 23
    end
    object Edit_Char2_name: TEdit
      Left = 318
      Top = 64
      Width = 121
      Height = 21
      MaxLength = 20
      TabOrder = 24
    end
    object Button_Save_account: TButton
      Left = 400
      Top = 8
      Width = 75
      Height = 25
      Caption = #20445#23384
      TabOrder = 25
      OnClick = Button_Save_accountClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 532
    Height = 57
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 14
      Width = 24
      Height = 13
      Caption = #36134#21495
    end
    object Edit_find_PrimaryKey: TEdit
      Left = 80
      Top = 9
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Button_account_find: TButton
      Left = 216
      Top = 9
      Width = 75
      Height = 25
      Caption = #26597#25214
      TabOrder = 1
      OnClick = Button_account_findClick
    end
    object Button_account_save: TButton
      Left = 398
      Top = 9
      Width = 91
      Height = 25
      Caption = #20889#20837#25968#25454#24211
      Enabled = False
      TabOrder = 2
      OnClick = Button_account_saveClick
    end
  end
end
