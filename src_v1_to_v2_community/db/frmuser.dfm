object FormUser: TFormUser
  Left = 251
  Top = 136
  Width = 888
  Height = 650
  Caption = #35282#33394#20449#24687
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Panel_sum_count: TPanel
    Left = 4
    Top = 49
    Width = 720
    Height = 533
    TabOrder = 7
    Visible = False
    object Memo1: TMemo
      Left = 1
      Top = 42
      Width = 718
      Height = 490
      Align = alClient
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 718
      Height = 41
      Align = alTop
      TabOrder = 0
      object Button1: TButton
        Left = 24
        Top = 8
        Width = 145
        Height = 25
        Caption = #36733#20837#25152#26377#29289#21697
        TabOrder = 0
        OnClick = Button1Click
      end
      object Edit_itemcount_find: TEdit
        Left = 184
        Top = 8
        Width = 121
        Height = 23
        TabOrder = 1
      end
      object Button_itemcount_find: TButton
        Left = 328
        Top = 8
        Width = 75
        Height = 25
        Caption = #26597#25214
        TabOrder = 2
        OnClick = Button_itemcount_findClick
      end
      object btn_bq: TButton
        Left = 408
        Top = 8
        Width = 90
        Height = 25
        Caption = #32479#35745#32465#38065'(>10W)'
        TabOrder = 3
        OnClick = btn_bqClick
      end
    end
  end
  object pageEdit: TPageControl
    Left = 4
    Top = 49
    Width = 720
    Height = 521
    ActivePage = TabSheet_basic
    Enabled = False
    TabOrder = 3
    object TabSheet_basic: TTabSheet
      Caption = #22522#26412
      object Label2: TLabel
        Left = 16
        Top = 18
        Width = 48
        Height = 15
        Caption = #35282#33394#21517#23383
      end
      object Label3: TLabel
        Left = 16
        Top = 57
        Width = 12
        Height = 15
        Caption = 'ID'
      end
      object Label4: TLabel
        Left = 16
        Top = 82
        Width = 24
        Height = 15
        Caption = #36134#21495
      end
      object Label5: TLabel
        Left = 16
        Top = 108
        Width = 48
        Height = 15
        Caption = #32972#21253#23494#30721
      end
      object Label6: TLabel
        Left = 16
        Top = 132
        Width = 36
        Height = 15
        Caption = #22242#38431'ID'
      end
      object Label7: TLabel
        Left = 16
        Top = 156
        Width = 24
        Height = 15
        Caption = #38376#27966
      end
      object Label8: TLabel
        Left = 16
        Top = 181
        Width = 48
        Height = 15
        Caption = #30331#38470#26102#38388
      end
      object Label9: TLabel
        Left = 16
        Top = 207
        Width = 48
        Height = 15
        Caption = #21019#24314#26102#38388
      end
      object Label10: TLabel
        Left = 16
        Top = 231
        Width = 24
        Height = 15
        Caption = #24615#21035
      end
      object Label11: TLabel
        Left = 16
        Top = 257
        Width = 36
        Height = 15
        Caption = #22320#22270'ID'
      end
      object Label12: TLabel
        Left = 16
        Top = 282
        Width = 7
        Height = 15
        Caption = 'X'
      end
      object Label13: TLabel
        Left = 16
        Top = 308
        Width = 7
        Height = 15
        Caption = 'Y'
      end
      object Label14: TLabel
        Left = 16
        Top = 332
        Width = 24
        Height = 15
        Caption = #20803#23453
      end
      object Label32: TLabel
        Left = 16
        Top = 356
        Width = 24
        Height = 15
        Caption = #22768#26395
      end
      object Label33: TLabel
        Left = 16
        Top = 381
        Width = 23
        Height = 15
        Caption = 'light'
      end
      object Label34: TLabel
        Left = 16
        Top = 407
        Width = 24
        Height = 15
        Caption = 'dark'
      end
      object Label35: TLabel
        Left = 16
        Top = 431
        Width = 48
        Height = 15
        Caption = #20803#27668#26368#22823
      end
      object Label36: TLabel
        Left = 184
        Top = 57
        Width = 48
        Height = 15
        Caption = #20869#21151#26368#22823
      end
      object Label37: TLabel
        Left = 184
        Top = 82
        Width = 48
        Height = 15
        Caption = #22806#21151#26368#22823
      end
      object Label38: TLabel
        Left = 184
        Top = 108
        Width = 48
        Height = 15
        Caption = #27494#21151#26368#22823
      end
      object Label39: TLabel
        Left = 184
        Top = 132
        Width = 48
        Height = 15
        Caption = #27963#21147#26368#22823
      end
      object Label40: TLabel
        Left = 184
        Top = 156
        Width = 33
        Height = 15
        Caption = 'Talent'
      end
      object Label41: TLabel
        Left = 184
        Top = 181
        Width = 57
        Height = 15
        Caption = 'GoodChar'
      end
      object Label42: TLabel
        Left = 184
        Top = 207
        Width = 49
        Height = 15
        Caption = 'BadChar'
      end
      object Label43: TLabel
        Left = 184
        Top = 231
        Width = 46
        Height = 15
        Caption = 'Adaptive'
      end
      object Label44: TLabel
        Left = 184
        Top = 257
        Width = 39
        Height = 15
        Caption = 'Revival'
      end
      object Label45: TLabel
        Left = 184
        Top = 282
        Width = 50
        Height = 15
        Caption = 'Immunity'
      end
      object Label46: TLabel
        Left = 184
        Top = 308
        Width = 24
        Height = 15
        Caption = #28009#28982
      end
      object Label47: TLabel
        Left = 184
        Top = 332
        Width = 48
        Height = 15
        Caption = #20803#27668#24403#21069
      end
      object Label48: TLabel
        Left = 184
        Top = 356
        Width = 48
        Height = 15
        Caption = #20869#21151#24403#21069
      end
      object Label49: TLabel
        Left = 184
        Top = 381
        Width = 48
        Height = 15
        Caption = #22806#21151#24403#21069
      end
      object Label50: TLabel
        Left = 184
        Top = 407
        Width = 48
        Height = 15
        Caption = #27494#21151#24403#21069
      end
      object Label51: TLabel
        Left = 184
        Top = 431
        Width = 48
        Height = 15
        Caption = #27963#21147#24403#21069
      end
      object Label52: TLabel
        Left = 360
        Top = 57
        Width = 36
        Height = 15
        Caption = 'Health'
      end
      object Label53: TLabel
        Left = 360
        Top = 82
        Width = 36
        Height = 15
        Caption = 'Satiety'
      end
      object Label54: TLabel
        Left = 360
        Top = 108
        Width = 56
        Height = 15
        Caption = 'Poisoning'
      end
      object Label55: TLabel
        Left = 360
        Top = 132
        Width = 36
        Height = 15
        Caption = #22836#38450#24481
      end
      object Label56: TLabel
        Left = 360
        Top = 156
        Width = 36
        Height = 15
        Caption = #25163#38450#24481
      end
      object Label57: TLabel
        Left = 360
        Top = 181
        Width = 36
        Height = 15
        Caption = #33151#38450#24481
      end
      object Label58: TLabel
        Left = 360
        Top = 207
        Width = 47
        Height = 15
        Caption = 'ExtraExp'
      end
      object Label59: TLabel
        Left = 360
        Top = 231
        Width = 100
        Height = 15
        Caption = 'AddablestatePoint'
      end
      object Label60: TLabel
        Left = 360
        Top = 281
        Width = 82
        Height = 15
        Caption = 'TotalStatePoint'
      end
      object Label61: TLabel
        Left = 360
        Top = 332
        Width = 75
        Height = 15
        Caption = 'CurrentGrade'
      end
      object Label62: TLabel
        Left = 360
        Top = 388
        Width = 48
        Height = 15
        Caption = #26102#35013#27169#24335
      end
      object Label63: TLabel
        Left = 360
        Top = 412
        Width = 24
        Height = 15
        Caption = #32844#19994
      end
      object Label132: TLabel
        Left = 16
        Top = 464
        Width = 24
        Height = 15
        Caption = #22825#39746
      end
      object Label133: TLabel
        Left = 216
        Top = 465
        Width = 24
        Height = 15
        Caption = #22320#39746
      end
      object Label134: TLabel
        Left = 392
        Top = 466
        Width = 24
        Height = 15
        Caption = #20154#39746
      end
      object Label150: TLabel
        Left = 528
        Top = 57
        Width = 36
        Height = 15
        Caption = #22825#36171#28857
      end
      object Label151: TLabel
        Left = 528
        Top = 81
        Width = 48
        Height = 15
        Caption = #22825#36171#32463#39564
      end
      object Label152: TLabel
        Left = 528
        Top = 105
        Width = 48
        Height = 15
        Caption = #22825#36171#32423#21035
      end
      object Label153: TLabel
        Left = 528
        Top = 129
        Width = 24
        Height = 15
        Caption = #26681#39592
      end
      object Label154: TLabel
        Left = 528
        Top = 153
        Width = 24
        Height = 15
        Caption = #36523#27861
      end
      object Label155: TLabel
        Left = 528
        Top = 177
        Width = 24
        Height = 15
        Caption = #24735#24615
      end
      object Label156: TLabel
        Left = 528
        Top = 201
        Width = 24
        Height = 15
        Caption = #27494#23398
      end
      object Label157: TLabel
        Left = 528
        Top = 225
        Width = 48
        Height = 15
        Caption = #32465#23450#38065#24065
      end
      object Label158: TLabel
        Left = 528
        Top = 249
        Width = 48
        Height = 15
        Caption = #32463#39564#20493#25968
      end
      object Label159: TLabel
        Left = 528
        Top = 273
        Width = 48
        Height = 15
        Caption = #32463#39564#26102#38388
      end
      object lblLabel160: TLabel
        Left = 528
        Top = 297
        Width = 42
        Height = 15
        Caption = 'VIP'#31561#32423
      end
      object lblLabel161: TLabel
        Left = 528
        Top = 321
        Width = 42
        Height = 15
        Caption = 'VIP'#26102#38388
      end
      object lbl1: TLabel
        Left = 528
        Top = 345
        Width = 60
        Height = 15
        Caption = #21512#25104#29087#32451#24230
      end
      object lbl2: TLabel
        Left = 528
        Top = 369
        Width = 48
        Height = 15
        Caption = #38376#27966#36129#29486
      end
      object Edit_db_name: TEdit
        Left = 72
        Top = 12
        Width = 121
        Height = 23
        BevelKind = bkTile
        BevelOuter = bvRaised
        BiDiMode = bdLeftToRight
        Color = clMoneyGreen
        DragMode = dmAutomatic
        Enabled = False
        ParentBiDiMode = False
        ReadOnly = True
        TabOrder = 0
      end
      object Edit_ID: TEdit
        Left = 72
        Top = 51
        Width = 90
        Height = 23
        Color = clMoneyGreen
        Enabled = False
        ReadOnly = True
        TabOrder = 1
      end
      object Edit_MasterName: TEdit
        Left = 72
        Top = 76
        Width = 90
        Height = 23
        MaxLength = 20
        TabOrder = 2
      end
      object Edit_Password: TEdit
        Left = 72
        Top = 100
        Width = 90
        Height = 23
        MaxLength = 20
        TabOrder = 3
      end
      object Edit_GroupKey: TEdit
        Left = 72
        Top = 126
        Width = 90
        Height = 23
        TabOrder = 4
      end
      object Edit_Guild: TEdit
        Left = 72
        Top = 150
        Width = 90
        Height = 23
        MaxLength = 20
        TabOrder = 5
      end
      object Edit_LastDate: TEdit
        Left = 72
        Top = 175
        Width = 90
        Height = 23
        TabOrder = 6
      end
      object Edit_CreateDate: TEdit
        Left = 72
        Top = 201
        Width = 90
        Height = 23
        TabOrder = 7
      end
      object Edit_ServerId: TEdit
        Left = 72
        Top = 251
        Width = 90
        Height = 23
        TabOrder = 8
      end
      object Edit_x: TEdit
        Left = 72
        Top = 276
        Width = 90
        Height = 23
        TabOrder = 9
      end
      object Edit_y: TEdit
        Left = 72
        Top = 302
        Width = 90
        Height = 23
        TabOrder = 10
      end
      object Edit_GOLD_Money: TEdit
        Left = 72
        Top = 326
        Width = 90
        Height = 23
        TabOrder = 11
      end
      object Edit_prestige: TEdit
        Left = 72
        Top = 350
        Width = 90
        Height = 23
        TabOrder = 12
      end
      object Edit_Light: TEdit
        Left = 72
        Top = 375
        Width = 90
        Height = 23
        TabOrder = 13
      end
      object Edit_dark: TEdit
        Left = 72
        Top = 401
        Width = 90
        Height = 23
        TabOrder = 14
      end
      object Edit_Energy: TEdit
        Left = 72
        Top = 425
        Width = 90
        Height = 23
        TabOrder = 15
      end
      object Edit_InPower: TEdit
        Left = 248
        Top = 51
        Width = 90
        Height = 23
        TabOrder = 16
      end
      object Edit_OutPower: TEdit
        Left = 248
        Top = 76
        Width = 90
        Height = 23
        TabOrder = 17
      end
      object Edit_Magic: TEdit
        Left = 248
        Top = 102
        Width = 90
        Height = 23
        TabOrder = 18
      end
      object Edit_Life: TEdit
        Left = 248
        Top = 126
        Width = 90
        Height = 23
        TabOrder = 19
      end
      object Edit_Talent: TEdit
        Left = 248
        Top = 150
        Width = 90
        Height = 23
        TabOrder = 20
      end
      object Edit_GoodChar: TEdit
        Left = 248
        Top = 175
        Width = 90
        Height = 23
        TabOrder = 21
      end
      object Edit_BadChar: TEdit
        Left = 248
        Top = 201
        Width = 90
        Height = 23
        TabOrder = 22
      end
      object Edit_Adaptive: TEdit
        Left = 248
        Top = 225
        Width = 90
        Height = 23
        TabOrder = 23
      end
      object Edit_Revival: TEdit
        Left = 248
        Top = 251
        Width = 90
        Height = 23
        TabOrder = 24
      end
      object Edit_Immunity: TEdit
        Left = 248
        Top = 276
        Width = 90
        Height = 23
        TabOrder = 25
      end
      object Edit_Virtue: TEdit
        Left = 248
        Top = 302
        Width = 90
        Height = 23
        TabOrder = 26
      end
      object Edit_CurEnergy: TEdit
        Left = 248
        Top = 326
        Width = 90
        Height = 23
        TabOrder = 27
      end
      object Edit_CurInPower: TEdit
        Left = 248
        Top = 350
        Width = 90
        Height = 23
        TabOrder = 28
      end
      object Edit_CurOutPower: TEdit
        Left = 248
        Top = 375
        Width = 90
        Height = 23
        TabOrder = 29
      end
      object Edit_CurMagic: TEdit
        Left = 248
        Top = 401
        Width = 90
        Height = 23
        TabOrder = 30
      end
      object Edit_CurLife: TEdit
        Left = 248
        Top = 425
        Width = 90
        Height = 23
        TabOrder = 31
      end
      object Edit_CurHealth: TEdit
        Left = 424
        Top = 51
        Width = 90
        Height = 23
        TabOrder = 32
      end
      object Edit_CurSatiety: TEdit
        Left = 424
        Top = 76
        Width = 90
        Height = 23
        TabOrder = 33
      end
      object Edit_CurPoisoning: TEdit
        Left = 424
        Top = 102
        Width = 90
        Height = 23
        TabOrder = 34
      end
      object Edit_CurHeadSeek: TEdit
        Left = 424
        Top = 126
        Width = 90
        Height = 23
        TabOrder = 35
      end
      object Edit_CurArmSeek: TEdit
        Left = 424
        Top = 150
        Width = 90
        Height = 23
        TabOrder = 36
      end
      object Edit_CurLegSeek: TEdit
        Left = 424
        Top = 175
        Width = 90
        Height = 23
        TabOrder = 37
      end
      object Edit_ExtraExp: TEdit
        Left = 424
        Top = 201
        Width = 90
        Height = 23
        TabOrder = 38
      end
      object Edit_AddableStatePoint: TEdit
        Left = 424
        Top = 249
        Width = 90
        Height = 23
        TabOrder = 39
      end
      object Edit_TotalStatePoint: TEdit
        Left = 424
        Top = 299
        Width = 90
        Height = 23
        TabOrder = 40
      end
      object Edit_CurrentGrade: TEdit
        Left = 424
        Top = 350
        Width = 90
        Height = 23
        TabOrder = 41
      end
      object Edit_FashionableDress: TEdit
        Left = 424
        Top = 382
        Width = 90
        Height = 23
        TabOrder = 42
      end
      object Edit_JobKind: TEdit
        Left = 424
        Top = 406
        Width = 90
        Height = 23
        TabOrder = 43
      end
      object ComboBox_Sex: TComboBox
        Left = 72
        Top = 225
        Width = 49
        Height = 23
        Style = csDropDownList
        ItemHeight = 15
        ItemIndex = 0
        TabOrder = 44
        Text = #30007
        Items.Strings = (
          #30007
          #22899)
      end
      object Button_basic_save: TButton
        Left = 512
        Top = 8
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 45
        OnClick = Button_basic_saveClick
      end
      object Button3: TButton
        Left = 424
        Top = 8
        Width = 75
        Height = 25
        Caption = #21478#23384#21040#25991#20214
        TabOrder = 46
        OnClick = Button3Click
      end
      object Edit_tian: TEdit
        Left = 64
        Top = 463
        Width = 121
        Height = 23
        TabOrder = 47
      end
      object Edit_di: TEdit
        Left = 254
        Top = 462
        Width = 121
        Height = 23
        TabOrder = 48
      end
      object Edit_ren: TEdit
        Left = 440
        Top = 459
        Width = 121
        Height = 23
        TabOrder = 49
      end
      object Edit_newTalent: TEdit
        Left = 592
        Top = 51
        Width = 90
        Height = 23
        TabOrder = 50
      end
      object Edit_newTalentExp: TEdit
        Left = 592
        Top = 75
        Width = 90
        Height = 23
        TabOrder = 51
      end
      object Edit_newTalentLv: TEdit
        Left = 592
        Top = 99
        Width = 90
        Height = 23
        TabOrder = 52
      end
      object Edit_newBone: TEdit
        Left = 592
        Top = 123
        Width = 90
        Height = 23
        TabOrder = 53
      end
      object Edit_newLeg: TEdit
        Left = 592
        Top = 147
        Width = 90
        Height = 23
        TabOrder = 54
      end
      object Edit_newSavvy: TEdit
        Left = 592
        Top = 171
        Width = 90
        Height = 23
        TabOrder = 55
      end
      object Edit_newAttackPower: TEdit
        Left = 592
        Top = 195
        Width = 90
        Height = 23
        TabOrder = 56
      end
      object Edit_newBindMoney: TEdit
        Left = 592
        Top = 219
        Width = 90
        Height = 23
        TabOrder = 57
      end
      object Edit_MagicExpMulCount: TEdit
        Left = 592
        Top = 243
        Width = 90
        Height = 23
        TabOrder = 58
      end
      object Edit_MagicExpMulEndTime: TEdit
        Left = 592
        Top = 267
        Width = 90
        Height = 23
        TabOrder = 59
      end
      object Edit_VipUseLevel: TEdit
        Left = 592
        Top = 291
        Width = 90
        Height = 23
        TabOrder = 60
        Text = ' '
      end
      object Edit_VipUseTime: TEdit
        Left = 592
        Top = 315
        Width = 90
        Height = 23
        TabOrder = 61
        Text = ' '
      end
      object Edit_ComplexExp: TEdit
        Left = 592
        Top = 339
        Width = 90
        Height = 23
        TabOrder = 62
        Text = ' '
      end
      object Edit_guildPoint: TEdit
        Left = 592
        Top = 363
        Width = 90
        Height = 23
        TabOrder = 63
        Text = ' '
      end
      object btnjiazai: TButton
        Left = 600
        Top = 8
        Width = 83
        Height = 25
        Caption = #25991#20214#21152#36733#25968#25454
        TabOrder = 64
        OnClick = btnjiazaiClick
      end
    end
    object TabSheet_Magic: TTabSheet
      Caption = #27494#21151
      ImageIndex = 1
      object StringGrid_Magic: TStringGrid
        Left = 0
        Top = 41
        Width = 712
        Height = 450
        Align = alClient
        ColCount = 3
        DefaultColWidth = 80
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        TabOrder = 0
        RowHeights = (
          24
          24
          24
          24
          29)
      end
      object Panel_Magic: TPanel
        Left = 0
        Top = 0
        Width = 712
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object ComboBox_Magic: TComboBox
          Left = 8
          Top = 8
          Width = 145
          Height = 23
          BevelOuter = bvRaised
          Style = csDropDownList
          DragMode = dmAutomatic
          ItemHeight = 15
          TabOrder = 0
          OnChange = ComboBox_MagicChange
          Items.Strings = (
            #22522#26412
            #19981#32641
            #27494#21151
            #19978#23618)
        end
        object Button_edit_Magic_update: TButton
          Left = 200
          Top = 8
          Width = 75
          Height = 25
          Caption = #20462#25913
          TabOrder = 1
          OnClick = Button_edit_Magic_updateClick
        end
      end
    end
    object TabSheet_Item: TTabSheet
      Caption = #29289#21697
      ImageIndex = 3
      object StringGrid_Item: TStringGrid
        Left = 0
        Top = 41
        Width = 712
        Height = 450
        Align = alClient
        DefaultColWidth = 80
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        TabOrder = 0
        OnClick = StringGrid_ItemClick
        OnSelectCell = StringGrid_ItemSelectCell
      end
      object Panel_Item: TPanel
        Left = 0
        Top = 0
        Width = 712
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object ComboBox_Item: TComboBox
          Left = 0
          Top = 7
          Width = 145
          Height = 23
          Style = csDropDownList
          ItemHeight = 15
          ItemIndex = 0
          TabOrder = 0
          Text = #32972#21253
          OnChange = ComboBox_ItemChange
          Items.Strings = (
            #32972#21253
            #20179#24211
            #31359#25140
            #26102#35013)
        end
        object Button_Change_Item: TButton
          Left = 200
          Top = 8
          Width = 75
          Height = 25
          Caption = #20462#25913
          TabOrder = 1
          OnClick = Button_Change_ItemClick
        end
      end
    end
    object TabSheet_Quest: TTabSheet
      Caption = #20219#21153
      ImageIndex = 3
      object Panel_Quest: TPanel
        Left = 0
        Top = 0
        Width = 712
        Height = 491
        Align = alClient
        TabOrder = 0
        object Label93: TLabel
          Left = 72
          Top = 24
          Width = 68
          Height = 19
          Caption = #20027#32447#20219#21153
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label95: TLabel
          Left = 24
          Top = 115
          Width = 90
          Height = 15
          Caption = 'CurrentQuestNo'
        end
        object Label96: TLabel
          Left = 32
          Top = 319
          Width = 71
          Height = 15
          Caption = 'QuestTemp1'
        end
        object Label97: TLabel
          Left = 32
          Top = 342
          Width = 71
          Height = 15
          Caption = 'QuestTemp2'
        end
        object Label98: TLabel
          Left = 40
          Top = 139
          Width = 58
          Height = 15
          Caption = 'QuestStep'
        end
        object Label99: TLabel
          Left = 32
          Top = 293
          Width = 71
          Height = 15
          Caption = 'QuestTemp0'
        end
        object Label100: TLabel
          Left = 8
          Top = 87
          Width = 107
          Height = 15
          Caption = 'compeleteQuestNo'
        end
        object Label101: TLabel
          Left = 32
          Top = 366
          Width = 71
          Height = 15
          Caption = 'QuestTemp3'
        end
        object Label102: TLabel
          Left = 254
          Top = 66
          Width = 71
          Height = 15
          Caption = 'QusetTemp5'
        end
        object Label103: TLabel
          Left = 38
          Top = 396
          Width = 71
          Height = 15
          Caption = 'QuestTemp4'
        end
        object Label104: TLabel
          Left = 254
          Top = 88
          Width = 71
          Height = 15
          Caption = 'QusetTemp6'
        end
        object Label105: TLabel
          Left = 252
          Top = 182
          Width = 78
          Height = 15
          Caption = 'QusetTemp10'
        end
        object Label106: TLabel
          Left = 252
          Top = 204
          Width = 77
          Height = 15
          Caption = 'QusetTemp11'
        end
        object Label107: TLabel
          Left = 252
          Top = 229
          Width = 78
          Height = 15
          Caption = 'QusetTemp12'
        end
        object Label108: TLabel
          Left = 252
          Top = 253
          Width = 78
          Height = 15
          Caption = 'QusetTemp13'
        end
        object Label109: TLabel
          Left = 252
          Top = 277
          Width = 78
          Height = 15
          Caption = 'QusetTemp14'
        end
        object Label110: TLabel
          Left = 252
          Top = 112
          Width = 71
          Height = 15
          Caption = 'QusetTemp7'
        end
        object Label111: TLabel
          Left = 255
          Top = 399
          Width = 78
          Height = 15
          Caption = 'QusetTemp19'
        end
        object Label112: TLabel
          Left = 253
          Top = 134
          Width = 71
          Height = 15
          Caption = 'QusetTemp8'
        end
        object Label113: TLabel
          Left = 252
          Top = 159
          Width = 71
          Height = 15
          Caption = 'QusetTemp9'
        end
        object Label118: TLabel
          Left = 252
          Top = 302
          Width = 78
          Height = 15
          Caption = 'QusetTemp15'
        end
        object Label119: TLabel
          Left = 252
          Top = 327
          Width = 78
          Height = 15
          Caption = 'QusetTemp16'
        end
        object Label120: TLabel
          Left = 252
          Top = 351
          Width = 78
          Height = 15
          Caption = 'QusetTemp17'
        end
        object Label121: TLabel
          Left = 252
          Top = 376
          Width = 78
          Height = 15
          Caption = 'QusetTemp18'
        end
        object Label124: TLabel
          Left = 8
          Top = 200
          Width = 112
          Height = 15
          Caption = 'SubCurrentQuestNo'
        end
        object Label125: TLabel
          Left = 16
          Top = 227
          Width = 79
          Height = 15
          Caption = 'SubQueststep'
        end
        object Label127: TLabel
          Left = 72
          Top = 176
          Width = 68
          Height = 19
          Caption = #25903#32447#20219#21153
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label122: TLabel
          Left = 72
          Top = 255
          Width = 68
          Height = 19
          Caption = #20020#26102#21464#37327
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Button_Quest_save: TButton
          Left = 516
          Top = 13
          Width = 75
          Height = 25
          Caption = #20445#23384
          TabOrder = 0
          OnClick = Button_Quest_saveClick
        end
        object Edit_Quest_Temp9: TEdit
          Left = 340
          Top = 158
          Width = 121
          Height = 23
          TabOrder = 1
        end
        object Edit_Quest_Temp8: TEdit
          Left = 340
          Top = 134
          Width = 121
          Height = 23
          TabOrder = 2
        end
        object Edit_Quest_Temp19: TEdit
          Left = 341
          Top = 400
          Width = 120
          Height = 23
          TabOrder = 3
        end
        object Edit_Quest_Temp7: TEdit
          Left = 340
          Top = 110
          Width = 120
          Height = 23
          TabOrder = 4
        end
        object Edit_Quest_Temp14: TEdit
          Left = 340
          Top = 278
          Width = 122
          Height = 23
          TabOrder = 5
        end
        object Edit_Quest_Temp13: TEdit
          Left = 340
          Top = 254
          Width = 122
          Height = 23
          TabOrder = 6
        end
        object Edit_Quest_Temp12: TEdit
          Left = 340
          Top = 230
          Width = 121
          Height = 23
          TabOrder = 7
        end
        object Edit_Quest_Temp11: TEdit
          Left = 340
          Top = 206
          Width = 121
          Height = 23
          TabOrder = 8
        end
        object Edit_Quest_Temp10: TEdit
          Left = 340
          Top = 182
          Width = 121
          Height = 23
          TabOrder = 9
        end
        object Edit_Quest_Temp6: TEdit
          Left = 341
          Top = 85
          Width = 119
          Height = 23
          TabOrder = 10
        end
        object Edit_Quest_Temp5: TEdit
          Left = 341
          Top = 61
          Width = 119
          Height = 23
          TabOrder = 11
        end
        object Edit_Quest_Temp4: TEdit
          Left = 125
          Top = 387
          Width = 119
          Height = 23
          TabOrder = 12
        end
        object Edit_Quest_Temp3: TEdit
          Left = 125
          Top = 360
          Width = 119
          Height = 23
          TabOrder = 13
        end
        object Edit_Quest_Temp2: TEdit
          Left = 125
          Top = 336
          Width = 119
          Height = 23
          TabOrder = 14
        end
        object Edit_Quest_Temp1: TEdit
          Left = 125
          Top = 312
          Width = 118
          Height = 23
          TabOrder = 15
        end
        object Edit_Quest_Temp0: TEdit
          Left = 125
          Top = 288
          Width = 118
          Height = 23
          TabOrder = 16
        end
        object Edit_Quest_Step: TEdit
          Left = 125
          Top = 136
          Width = 118
          Height = 23
          TabOrder = 17
        end
        object Edit_Quest_CurNo: TEdit
          Left = 125
          Top = 112
          Width = 118
          Height = 23
          TabOrder = 18
        end
        object Edit_Quest_ComNo: TEdit
          Left = 125
          Top = 88
          Width = 118
          Height = 23
          TabOrder = 19
        end
        object Edit_Quest_Temp15: TEdit
          Left = 340
          Top = 302
          Width = 122
          Height = 23
          TabOrder = 20
        end
        object Edit_Quest_Temp16: TEdit
          Left = 340
          Top = 326
          Width = 122
          Height = 23
          TabOrder = 21
        end
        object Edit_Quest_Temp17: TEdit
          Left = 340
          Top = 350
          Width = 122
          Height = 23
          TabOrder = 22
        end
        object Edit_Quest_Temp18: TEdit
          Left = 340
          Top = 374
          Width = 122
          Height = 23
          TabOrder = 23
        end
        object Edit_SubQuest_SubNo: TEdit
          Left = 125
          Top = 200
          Width = 121
          Height = 23
          TabOrder = 24
        end
        object Edit_SubQuest_Step: TEdit
          Left = 125
          Top = 224
          Width = 121
          Height = 23
          TabOrder = 25
        end
      end
    end
    object TabSheet_key: TTabSheet
      Caption = #28909#38190
      ImageIndex = 4
      object StringGrid_key: TStringGrid
        Left = 0
        Top = 41
        Width = 712
        Height = 450
        Align = alClient
        TabOrder = 0
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 712
        Height = 41
        Align = alTop
        TabOrder = 1
        object Button_change_key: TButton
          Left = 200
          Top = 8
          Width = 75
          Height = 25
          Caption = #20462#25913
          TabOrder = 0
          OnClick = Button_change_keyClick
        end
      end
    end
    object TabSheet_ShortcutKey: TTabSheet
      Caption = #21151#33021#38190
      ImageIndex = 5
      object StringGrid_ShortcutKey: TStringGrid
        Left = 0
        Top = 41
        Width = 712
        Height = 450
        Align = alClient
        DefaultColWidth = 80
        TabOrder = 0
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 712
        Height = 41
        Align = alTop
        TabOrder = 1
        object Button_change_CutKey: TButton
          Left = 200
          Top = 8
          Width = 75
          Height = 25
          Caption = #20462#25913
          TabOrder = 0
          OnClick = Button_change_CutKeyClick
        end
      end
    end
  end
  object Panel_head: TPanel
    Left = 0
    Top = 0
    Width = 872
    Height = 49
    Align = alTop
    TabOrder = 0
    object Button_save: TButton
      Left = 376
      Top = 9
      Width = 75
      Height = 25
      Caption = #20889#20837#25968#25454#24211
      TabOrder = 0
      OnClick = Button_saveClick
    end
    object Panel_find: TPanel
      Left = 1
      Top = 1
      Width = 304
      Height = 47
      Align = alLeft
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      object Label1: TLabel
        Left = 16
        Top = 14
        Width = 48
        Height = 15
        Caption = #35282#33394#21517#23383
      end
      object Button_find: TButton
        Left = 213
        Top = 9
        Width = 75
        Height = 25
        Caption = #26597#25214
        TabOrder = 0
        OnClick = Button_findClick
      end
      object Edit_name: TEdit
        Left = 80
        Top = 9
        Width = 121
        Height = 21
        TabOrder = 1
      end
    end
    object Button2: TButton
      Left = 296
      Top = 9
      Width = 75
      Height = 25
      Caption = #32479#35745
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button4: TButton
      Left = 456
      Top = 9
      Width = 75
      Height = 25
      Caption = #21024#38500#24080#21495
      TabOrder = 3
      OnClick = Button4Click
    end
    object btnyace: TButton
      Left = 536
      Top = 9
      Width = 75
      Height = 25
      Caption = #21019#24314#21387#27979#35282#33394
      TabOrder = 4
      OnClick = btnyaceClick
    end
  end
  object Panel_log: TPanel
    Left = 0
    Top = 570
    Width = 872
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel_log'
    TabOrder = 1
    object Memo_log: TMemo
      Left = 0
      Top = 0
      Width = 872
      Height = 41
      Align = alClient
      Lines.Strings = (
        'Memo_log')
      TabOrder = 0
    end
  end
  object Panel_item_edit: TPanel
    Left = 1136
    Top = 73
    Width = 393
    Height = 472
    TabOrder = 2
    Visible = False
    object Label15: TLabel
      Left = 17
      Top = 67
      Width = 12
      Height = 15
      Caption = 'ID'
    end
    object Label16: TLabel
      Left = 17
      Top = 92
      Width = 24
      Height = 15
      Caption = #21517#23383
    end
    object Label17: TLabel
      Left = 17
      Top = 116
      Width = 24
      Height = 15
      Caption = #25968#37327
    end
    object Label18: TLabel
      Left = 17
      Top = 141
      Width = 24
      Height = 15
      Caption = #39068#33394
    end
    object Label19: TLabel
      Left = 17
      Top = 166
      Width = 24
      Height = 15
      Caption = #25345#20037
    end
    object Label20: TLabel
      Left = 17
      Top = 191
      Width = 47
      Height = 15
      Caption = 'MAX'#25345#20037
    end
    object Label21: TLabel
      Left = 17
      Top = 272
      Width = 48
      Height = 15
      Caption = #35013#22791#31561#32423
    end
    object Label22: TLabel
      Left = 17
      Top = 220
      Width = 48
      Height = 15
      Caption = #38468#21152#23646#24615
    end
    object Label23: TLabel
      Left = 193
      Top = 244
      Width = 36
      Height = 15
      Caption = #38145#29366#24577
    end
    object Label24: TLabel
      Left = 193
      Top = 269
      Width = 36
      Height = 15
      Caption = #38145#26102#38388
    end
    object Label25: TLabel
      Left = 17
      Top = 246
      Width = 48
      Height = 15
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
      Height = 23
      TabOrder = 1
    end
    object Edit_item_name: TEdit
      Left = 73
      Top = 86
      Width = 103
      Height = 23
      MaxLength = 20
      TabOrder = 2
    end
    object Edit_item_count: TEdit
      Left = 73
      Top = 110
      Width = 103
      Height = 23
      TabOrder = 3
    end
    object Edit_item_color: TEdit
      Left = 73
      Top = 135
      Width = 103
      Height = 23
      TabOrder = 4
    end
    object Edit_item_durability: TEdit
      Left = 73
      Top = 160
      Width = 103
      Height = 23
      TabOrder = 5
    end
    object Edit_item_durabilitymax: TEdit
      Left = 73
      Top = 185
      Width = 103
      Height = 23
      TabOrder = 6
    end
    object Edit_item_smithingLevel: TEdit
      Left = 73
      Top = 266
      Width = 103
      Height = 23
      TabOrder = 7
    end
    object Edit_item_Additional: TEdit
      Left = 73
      Top = 214
      Width = 103
      Height = 23
      TabOrder = 8
    end
    object edit_item_LockState: TEdit
      Left = 249
      Top = 238
      Width = 103
      Height = 23
      TabOrder = 9
    end
    object Edit_item_Locktime: TEdit
      Left = 249
      Top = 263
      Width = 103
      Height = 23
      TabOrder = 10
    end
    object Edit_item_DataTime: TEdit
      Left = 73
      Top = 240
      Width = 103
      Height = 23
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
        Height = 15
        Caption = #38262#23884#25968#37327
      end
      object Label27: TLabel
        Left = 16
        Top = 45
        Width = 31
        Height = 15
        Caption = #38262#23884'1'
      end
      object Label28: TLabel
        Left = 16
        Top = 69
        Width = 31
        Height = 15
        Caption = #38262#23884'2'
      end
      object Label29: TLabel
        Left = 16
        Top = 93
        Width = 31
        Height = 15
        Caption = #38262#23884'3'
      end
      object Label30: TLabel
        Left = 16
        Top = 117
        Width = 31
        Height = 15
        Caption = #38262#23884'4'
      end
      object Edit_item_SettingCount: TEdit
        Left = 69
        Top = 15
        Width = 96
        Height = 23
        TabOrder = 0
      end
      object Edit_item_Setting1: TEdit
        Left = 69
        Top = 39
        Width = 96
        Height = 23
        MaxLength = 20
        TabOrder = 1
      end
      object Edit_item_Setting2: TEdit
        Left = 69
        Top = 63
        Width = 96
        Height = 23
        MaxLength = 20
        TabOrder = 2
      end
      object Edit_item_Setting3: TEdit
        Left = 69
        Top = 87
        Width = 96
        Height = 23
        MaxLength = 20
        TabOrder = 3
      end
      object Edit_item_Setting4: TEdit
        Left = 69
        Top = 111
        Width = 96
        Height = 23
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
        Height = 15
        Caption = #25915#20987#36523
      end
      object Label94: TLabel
        Left = 9
        Top = 42
        Width = 36
        Height = 15
        Caption = #25915#20987#22836
      end
      object Label114: TLabel
        Left = 9
        Top = 66
        Width = 36
        Height = 15
        Caption = #25915#20987#25163
      end
      object Label115: TLabel
        Left = 9
        Top = 90
        Width = 36
        Height = 15
        Caption = #25915#20987#33050
      end
      object Label116: TLabel
        Left = 9
        Top = 114
        Width = 48
        Height = 15
        Caption = #25915#20987#36895#24230
      end
      object Label117: TLabel
        Left = 9
        Top = 138
        Width = 24
        Height = 15
        Caption = #36530#36991
      end
      object Label123: TLabel
        Left = 177
        Top = 18
        Width = 36
        Height = 15
        Caption = #38450#24481#36523
      end
      object Label126: TLabel
        Left = 177
        Top = 42
        Width = 36
        Height = 15
        Caption = #38450#24481#22836
      end
      object Label128: TLabel
        Left = 177
        Top = 66
        Width = 36
        Height = 15
        Caption = #38450#24481#25163
      end
      object Label129: TLabel
        Left = 177
        Top = 90
        Width = 36
        Height = 15
        Caption = #38450#24481#33050
      end
      object Label130: TLabel
        Left = 177
        Top = 114
        Width = 24
        Height = 15
        Caption = #24674#22797
      end
      object Label131: TLabel
        Left = 177
        Top = 138
        Width = 24
        Height = 15
        Caption = #21629#20013
      end
      object Edit_item_damageBody: TEdit
        Left = 65
        Top = 13
        Width = 103
        Height = 23
        TabOrder = 0
      end
      object Edit_item_damageHead: TEdit
        Left = 65
        Top = 37
        Width = 103
        Height = 23
        TabOrder = 1
      end
      object Edit_item_damageArm: TEdit
        Left = 65
        Top = 61
        Width = 103
        Height = 23
        TabOrder = 2
      end
      object Edit_item_damageLeg: TEdit
        Left = 65
        Top = 85
        Width = 103
        Height = 23
        TabOrder = 3
      end
      object Edit_item_AttackSpeed: TEdit
        Left = 65
        Top = 109
        Width = 103
        Height = 23
        TabOrder = 4
      end
      object Edit_item_avoid: TEdit
        Left = 65
        Top = 133
        Width = 103
        Height = 23
        TabOrder = 5
      end
      object Edit_item_armorBody: TEdit
        Left = 233
        Top = 13
        Width = 103
        Height = 23
        TabOrder = 6
      end
      object Edit_item_armorHead: TEdit
        Left = 233
        Top = 37
        Width = 103
        Height = 23
        TabOrder = 7
      end
      object Edit_item_armorArm: TEdit
        Left = 233
        Top = 61
        Width = 103
        Height = 23
        TabOrder = 8
      end
      object Edit_item_armorLeg: TEdit
        Left = 233
        Top = 85
        Width = 103
        Height = 23
        TabOrder = 9
      end
      object Edit_item_recovery: TEdit
        Left = 233
        Top = 109
        Width = 103
        Height = 23
        TabOrder = 10
      end
      object Edit_item_accuracy: TEdit
        Left = 233
        Top = 133
        Width = 103
        Height = 23
        TabOrder = 11
      end
    end
  end
  object Panel_cutkey_edit: TPanel
    Left = 1160
    Top = 560
    Width = 313
    Height = 361
    TabOrder = 4
    Visible = False
    object Label82: TLabel
      Left = 24
      Top = 176
      Width = 41
      Height = 15
      Caption = 'cutkey3'
    end
    object Label83: TLabel
      Left = 24
      Top = 272
      Width = 41
      Height = 15
      Caption = 'cutkey7'
    end
    object Label84: TLabel
      Left = 24
      Top = 296
      Width = 41
      Height = 15
      Caption = 'cutkey8'
    end
    object Label85: TLabel
      Left = 24
      Top = 200
      Width = 41
      Height = 15
      Caption = 'cutkey4'
    end
    object Label86: TLabel
      Left = 24
      Top = 224
      Width = 41
      Height = 15
      Caption = 'cutkey5'
    end
    object Label87: TLabel
      Left = 24
      Top = 248
      Width = 41
      Height = 15
      Caption = 'cutkey6'
    end
    object Label88: TLabel
      Left = 24
      Top = 104
      Width = 41
      Height = 15
      Caption = 'cutkey0'
    end
    object Label89: TLabel
      Left = 24
      Top = 72
      Width = 21
      Height = 15
      Caption = 'lkey'
      Color = cl3DLight
      Enabled = False
      ParentColor = False
    end
    object Label90: TLabel
      Left = 24
      Top = 128
      Width = 41
      Height = 15
      Caption = 'cutkey1'
    end
    object Label91: TLabel
      Left = 24
      Top = 152
      Width = 41
      Height = 15
      Caption = 'cutkey2'
    end
    object Label92: TLabel
      Left = 24
      Top = 320
      Width = 41
      Height = 15
      Caption = 'cutkey9'
    end
    object Panel10: TPanel
      Left = 1
      Top = 1
      Width = 311
      Height = 41
      Align = alTop
      TabOrder = 0
      object Label81: TLabel
        Left = 16
        Top = 8
        Width = 102
        Height = 19
        Caption = #21151#33021#38190#32534#36753#26694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Button_change_cutkey_save: TButton
        Left = 128
        Top = 8
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 0
        OnClick = Button_change_cutkey_saveClick
      end
      object Button_change_cutkey_close: TButton
        Left = 208
        Top = 8
        Width = 75
        Height = 25
        Caption = #20851#38381
        TabOrder = 1
        OnClick = Button_change_cutkey_closeClick
      end
    end
    object Edit_cutkey7: TEdit
      Left = 96
      Top = 264
      Width = 121
      Height = 23
      TabOrder = 1
    end
    object Edit_cutkey2: TEdit
      Left = 96
      Top = 144
      Width = 121
      Height = 23
      TabOrder = 2
    end
    object Edit_cutkey6: TEdit
      Left = 96
      Top = 240
      Width = 121
      Height = 23
      TabOrder = 3
    end
    object Edit_cutkey5: TEdit
      Left = 96
      Top = 216
      Width = 121
      Height = 23
      TabOrder = 4
    end
    object Edit_cutkey4: TEdit
      Left = 96
      Top = 192
      Width = 121
      Height = 23
      TabOrder = 5
    end
    object Edit_cutkey3: TEdit
      Left = 96
      Top = 168
      Width = 121
      Height = 23
      TabOrder = 6
    end
    object Edit_cutkey8: TEdit
      Left = 96
      Top = 288
      Width = 121
      Height = 23
      TabOrder = 7
    end
    object Edit_cutlkey: TEdit
      Left = 96
      Top = 72
      Width = 121
      Height = 23
      Color = cl3DLight
      Enabled = False
      TabOrder = 8
    end
    object Edit_cutkey0: TEdit
      Left = 96
      Top = 96
      Width = 121
      Height = 23
      TabOrder = 9
    end
    object Edit_cutkey9: TEdit
      Left = 96
      Top = 312
      Width = 121
      Height = 23
      TabOrder = 10
    end
    object Edit_cutkey1: TEdit
      Left = 96
      Top = 120
      Width = 121
      Height = 23
      TabOrder = 11
    end
  end
  object Panel_key: TPanel
    Left = 743
    Top = 104
    Width = 282
    Height = 361
    TabOrder = 5
    Visible = False
    object Label69: TLabel
      Left = 16
      Top = 96
      Width = 25
      Height = 15
      Caption = 'key0'
    end
    object Label70: TLabel
      Left = 16
      Top = 168
      Width = 25
      Height = 15
      Caption = 'key3'
    end
    object Label71: TLabel
      Left = 16
      Top = 216
      Width = 25
      Height = 15
      Caption = 'key5'
    end
    object Label72: TLabel
      Left = 16
      Top = 243
      Width = 25
      Height = 15
      Caption = 'key6'
    end
    object Label73: TLabel
      Left = 16
      Top = 272
      Width = 25
      Height = 15
      Caption = 'key7'
    end
    object Label74: TLabel
      Left = 16
      Top = 144
      Width = 25
      Height = 15
      Caption = 'key2'
    end
    object Label75: TLabel
      Left = 16
      Top = 296
      Width = 25
      Height = 15
      Caption = 'key8'
    end
    object Label76: TLabel
      Left = 16
      Top = 72
      Width = 21
      Height = 15
      Caption = 'lkey'
      Enabled = False
    end
    object Label77: TLabel
      Left = 16
      Top = 120
      Width = 25
      Height = 15
      Caption = 'key1'
    end
    object Label78: TLabel
      Left = 16
      Top = 192
      Width = 25
      Height = 15
      Caption = 'key4'
    end
    object Label80: TLabel
      Left = 16
      Top = 320
      Width = 25
      Height = 15
      Caption = 'key9'
    end
    object Panel9: TPanel
      Left = 1
      Top = 1
      Width = 280
      Height = 41
      Align = alTop
      TabOrder = 0
      object Label68: TLabel
        Left = 16
        Top = 8
        Width = 85
        Height = 19
        Caption = #28909#38190#32534#36753#26694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Button_key_save: TButton
        Left = 120
        Top = 8
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 0
        OnClick = Button_key_saveClick
      end
      object Button_key_close: TButton
        Left = 200
        Top = 8
        Width = 75
        Height = 25
        Caption = #20851#38381
        TabOrder = 1
        OnClick = Button_key_closeClick
      end
    end
    object Edit_key0: TEdit
      Left = 112
      Top = 96
      Width = 121
      Height = 23
      TabOrder = 1
    end
    object Edit_key1: TEdit
      Left = 112
      Top = 120
      Width = 121
      Height = 23
      TabOrder = 2
    end
    object Edit_key4: TEdit
      Left = 112
      Top = 192
      Width = 121
      Height = 23
      TabOrder = 3
    end
    object Edit_key5: TEdit
      Left = 112
      Top = 216
      Width = 121
      Height = 23
      TabOrder = 4
    end
    object Edit_key6: TEdit
      Left = 112
      Top = 240
      Width = 121
      Height = 23
      TabOrder = 5
    end
    object Edit_key7: TEdit
      Left = 112
      Top = 264
      Width = 121
      Height = 23
      TabOrder = 6
    end
    object Edit_key8: TEdit
      Left = 112
      Top = 288
      Width = 121
      Height = 23
      TabOrder = 7
    end
    object Edit_lkey: TEdit
      Left = 112
      Top = 72
      Width = 121
      Height = 23
      Color = clBtnFace
      Enabled = False
      TabOrder = 8
    end
    object Edit_key3: TEdit
      Left = 112
      Top = 168
      Width = 121
      Height = 23
      TabOrder = 9
    end
    object Edit_key2: TEdit
      Left = 112
      Top = 144
      Width = 121
      Height = 23
      TabOrder = 10
    end
    object Edit_key9: TEdit
      Left = 112
      Top = 312
      Width = 121
      Height = 23
      TabOrder = 11
    end
  end
  object Panel_Edit_Magic: TPanel
    Left = 735
    Top = 512
    Width = 369
    Height = 161
    TabOrder = 6
    Visible = False
    object Label65: TLabel
      Left = 32
      Top = 56
      Width = 12
      Height = 15
      Caption = 'ID'
    end
    object Label66: TLabel
      Left = 24
      Top = 80
      Width = 32
      Height = 15
      Caption = 'name'
    end
    object Label67: TLabel
      Left = 32
      Top = 112
      Width = 22
      Height = 15
      Caption = 'skill'
    end
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 367
      Height = 41
      Align = alTop
      TabOrder = 0
      object Label64: TLabel
        Left = 24
        Top = 8
        Width = 85
        Height = 19
        Caption = #27494#21151#32534#36753#26694
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowFrame
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Button_Edit_Magic_save: TButton
        Left = 200
        Top = 8
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 0
        OnClick = Button_Edit_Magic_saveClick
      end
      object Button_Edit_Magic_close: TButton
        Left = 280
        Top = 8
        Width = 75
        Height = 25
        Caption = #20851#38381
        TabOrder = 1
        OnClick = Button_Edit_Magic_closeClick
      end
    end
    object Edit_Magic_ID: TEdit
      Left = 112
      Top = 56
      Width = 121
      Height = 23
      Color = clScrollBar
      Enabled = False
      TabOrder = 1
    end
    object Edit_Magic_Name: TEdit
      Left = 112
      Top = 80
      Width = 121
      Height = 23
      Color = clWhite
      MaxLength = 20
      TabOrder = 2
    end
    object Edit_Magic_Skill: TEdit
      Left = 112
      Top = 104
      Width = 121
      Height = 23
      TabOrder = 3
    end
  end
  object btnloaduserlist: TButton
    Left = 736
    Top = 56
    Width = 113
    Height = 25
    Caption = #21152#36733#35282#33394#21015#34920
    TabOrder = 8
    OnClick = btnloaduserlistClick
  end
  object UserList: TListBox
    Left = 728
    Top = 88
    Width = 137
    Height = 473
    ItemHeight = 15
    TabOrder = 9
    OnDblClick = UserListDblClick
  end
  object SaveDialog1: TSaveDialog
    Left = 356
    Top = 147
  end
  object dlgOpen1: TOpenDialog
    Left = 392
    Top = 147
  end
end
