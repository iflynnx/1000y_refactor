object frmItemEdit: TfrmItemEdit
  Left = 500
  Top = 259
  BorderStyle = bsNone
  ClientHeight = 472
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Panel_item_edit: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 472
    TabOrder = 0
    object Label15: TLabel
      Left = 17
      Top = 67
      Width = 9
      Height = 14
      Caption = 'ID'
    end
    object Label16: TLabel
      Left = 17
      Top = 92
      Width = 24
      Height = 14
      Caption = #21517#23383
    end
    object Label17: TLabel
      Left = 17
      Top = 116
      Width = 24
      Height = 14
      Caption = #25968#37327
    end
    object Label18: TLabel
      Left = 17
      Top = 141
      Width = 24
      Height = 14
      Caption = #39068#33394
    end
    object Label19: TLabel
      Left = 17
      Top = 166
      Width = 24
      Height = 14
      Caption = #25345#20037
    end
    object Label20: TLabel
      Left = 17
      Top = 191
      Width = 47
      Height = 14
      Caption = 'MAX'#25345#20037
    end
    object Label21: TLabel
      Left = 17
      Top = 272
      Width = 48
      Height = 14
      Caption = #35013#22791#31561#32423
    end
    object Label22: TLabel
      Left = 17
      Top = 220
      Width = 48
      Height = 14
      Caption = #38468#21152#23646#24615
    end
    object Label23: TLabel
      Left = 193
      Top = 244
      Width = 36
      Height = 14
      Caption = #38145#29366#24577
    end
    object Label24: TLabel
      Left = 193
      Top = 269
      Width = 36
      Height = 14
      Caption = #38145#26102#38388
    end
    object Label25: TLabel
      Left = 17
      Top = 246
      Width = 48
      Height = 14
      Caption = #21040#26399#26102#38388
    end
    object Panel4: TPanel
      Left = 12
      Top = 12
      Width = 361
      Height = 41
      TabOrder = 0
      object Label31: TLabel
        Left = 24
        Top = 14
        Width = 85
        Height = 19
        Caption = #29289#21697#32534#36753#26694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowFrame
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Button_windows_item_close: TButton
        Left = 272
        Top = 8
        Width = 75
        Height = 25
        Caption = #20851#38381
        TabOrder = 0
        OnClick = Button_windows_item_closeClick
      end
      object Button_windows_item_save: TButton
        Left = 192
        Top = 8
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 1
        OnClick = Button_windows_item_saveClick
      end
    end
    object Edit_item_id: TEdit
      Left = 73
      Top = 61
      Width = 103
      Height = 22
      TabOrder = 1
    end
    object Edit_item_name: TEdit
      Left = 73
      Top = 86
      Width = 103
      Height = 22
      MaxLength = 20
      TabOrder = 2
    end
    object Edit_item_count: TEdit
      Left = 73
      Top = 110
      Width = 103
      Height = 22
      TabOrder = 3
    end
    object Edit_item_color: TEdit
      Left = 73
      Top = 135
      Width = 103
      Height = 22
      TabOrder = 4
    end
    object Edit_item_durability: TEdit
      Left = 73
      Top = 160
      Width = 103
      Height = 22
      TabOrder = 5
    end
    object Edit_item_durabilitymax: TEdit
      Left = 73
      Top = 185
      Width = 103
      Height = 22
      TabOrder = 6
    end
    object Edit_item_smithingLevel: TEdit
      Left = 73
      Top = 266
      Width = 103
      Height = 22
      TabOrder = 7
    end
    object Edit_item_Additional: TEdit
      Left = 73
      Top = 214
      Width = 103
      Height = 22
      TabOrder = 8
    end
    object edit_item_LockState: TEdit
      Left = 249
      Top = 238
      Width = 103
      Height = 22
      TabOrder = 9
    end
    object Edit_item_Locktime: TEdit
      Left = 249
      Top = 263
      Width = 103
      Height = 22
      TabOrder = 10
    end
    object Edit_item_DataTime: TEdit
      Left = 73
      Top = 240
      Width = 103
      Height = 22
      TabOrder = 11
    end
    object GroupBox1: TGroupBox
      Left = 184
      Top = 72
      Width = 185
      Height = 145
      Caption = #38262#23884#20449#24687
      TabOrder = 12
      object Label26: TLabel
        Left = 16
        Top = 21
        Width = 48
        Height = 14
        Caption = #38262#23884#25968#37327
      end
      object Label27: TLabel
        Left = 16
        Top = 45
        Width = 30
        Height = 14
        Caption = #38262#23884'1'
      end
      object Label28: TLabel
        Left = 16
        Top = 69
        Width = 30
        Height = 14
        Caption = #38262#23884'2'
      end
      object Label29: TLabel
        Left = 16
        Top = 93
        Width = 30
        Height = 14
        Caption = #38262#23884'3'
      end
      object Label30: TLabel
        Left = 16
        Top = 117
        Width = 30
        Height = 14
        Caption = #38262#23884'4'
      end
      object Edit_item_SettingCount: TEdit
        Left = 69
        Top = 15
        Width = 96
        Height = 22
        TabOrder = 0
      end
      object Edit_item_Setting1: TEdit
        Left = 69
        Top = 39
        Width = 96
        Height = 22
        MaxLength = 20
        TabOrder = 1
      end
      object Edit_item_Setting2: TEdit
        Left = 69
        Top = 63
        Width = 96
        Height = 22
        MaxLength = 20
        TabOrder = 2
      end
      object Edit_item_Setting3: TEdit
        Left = 69
        Top = 87
        Width = 96
        Height = 22
        MaxLength = 20
        TabOrder = 3
      end
      object Edit_item_Setting4: TEdit
        Left = 69
        Top = 111
        Width = 96
        Height = 22
        MaxLength = 20
        TabOrder = 4
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 296
      Width = 353
      Height = 169
      Caption = #38468#21152#23646#24615
      TabOrder = 13
      object Label79: TLabel
        Left = 9
        Top = 18
        Width = 36
        Height = 14
        Caption = #25915#20987#36523
      end
      object Label94: TLabel
        Left = 9
        Top = 42
        Width = 36
        Height = 14
        Caption = #25915#20987#22836
      end
      object Label114: TLabel
        Left = 9
        Top = 66
        Width = 36
        Height = 14
        Caption = #25915#20987#25163
      end
      object Label115: TLabel
        Left = 9
        Top = 90
        Width = 36
        Height = 14
        Caption = #25915#20987#33050
      end
      object Label116: TLabel
        Left = 9
        Top = 114
        Width = 48
        Height = 14
        Caption = #25915#20987#36895#24230
      end
      object Label117: TLabel
        Left = 9
        Top = 138
        Width = 24
        Height = 14
        Caption = #36530#36991
      end
      object Label123: TLabel
        Left = 177
        Top = 18
        Width = 36
        Height = 14
        Caption = #38450#24481#36523
      end
      object Label126: TLabel
        Left = 177
        Top = 42
        Width = 36
        Height = 14
        Caption = #38450#24481#22836
      end
      object Label128: TLabel
        Left = 177
        Top = 66
        Width = 36
        Height = 14
        Caption = #38450#24481#25163
      end
      object Label129: TLabel
        Left = 177
        Top = 90
        Width = 36
        Height = 14
        Caption = #38450#24481#33050
      end
      object Label130: TLabel
        Left = 177
        Top = 114
        Width = 24
        Height = 14
        Caption = #24674#22797
      end
      object Label131: TLabel
        Left = 177
        Top = 138
        Width = 24
        Height = 14
        Caption = #21629#20013
      end
      object Edit_item_damageBody: TEdit
        Left = 65
        Top = 13
        Width = 103
        Height = 22
        TabOrder = 0
      end
      object Edit_item_damageHead: TEdit
        Left = 65
        Top = 37
        Width = 103
        Height = 22
        TabOrder = 1
      end
      object Edit_item_damageArm: TEdit
        Left = 65
        Top = 61
        Width = 103
        Height = 22
        TabOrder = 2
      end
      object Edit_item_damageLeg: TEdit
        Left = 65
        Top = 85
        Width = 103
        Height = 22
        TabOrder = 3
      end
      object Edit_item_AttackSpeed: TEdit
        Left = 65
        Top = 109
        Width = 103
        Height = 22
        TabOrder = 4
      end
      object Edit_item_avoid: TEdit
        Left = 65
        Top = 133
        Width = 103
        Height = 22
        TabOrder = 5
      end
      object Edit_item_armorBody: TEdit
        Left = 233
        Top = 13
        Width = 103
        Height = 22
        TabOrder = 6
      end
      object Edit_item_armorHead: TEdit
        Left = 233
        Top = 37
        Width = 103
        Height = 22
        TabOrder = 7
      end
      object Edit_item_armorArm: TEdit
        Left = 233
        Top = 61
        Width = 103
        Height = 22
        TabOrder = 8
      end
      object Edit_item_armorLeg: TEdit
        Left = 233
        Top = 85
        Width = 103
        Height = 22
        TabOrder = 9
      end
      object Edit_item_recovery: TEdit
        Left = 233
        Top = 109
        Width = 103
        Height = 22
        TabOrder = 10
      end
      object Edit_item_accuracy: TEdit
        Left = 233
        Top = 133
        Width = 103
        Height = 22
        TabOrder = 11
      end
    end
  end
end
