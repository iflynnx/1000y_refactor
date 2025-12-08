object FrmGameToolsNew: TFrmGameToolsNew
  Left = 660
  Top = 0
  BorderStyle = bsNone
  Caption = 'FrmGameToolsNew'
  ClientHeight = 668
  ClientWidth = 876
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object A2ILabel_bottom: TA2ILabel
    Left = 0
    Top = 236
    Width = 328
    Height = 34
    AutoSize = False
    Color = clSilver
    ParentColor = False
    ADXForm = A2Form
    DrawItemData = False
  end
  object A2ILabel_top: TA2ILabel
    Left = 0
    Top = 0
    Width = 328
    Height = 36
    AutoSize = False
    ADXForm = A2Form
    DrawItemData = False
  end
  object A2ILabel_button: TA2ILabel
    Left = 0
    Top = 36
    Width = 328
    Height = 20
    AutoSize = False
    ADXForm = A2Form
    DrawItemData = False
  end
  object A2Button_Pick: TA2Button
    Left = 54
    Top = 38
    Width = 38
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_PickClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Shout: TA2Button
    Left = 95
    Top = 38
    Width = 38
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_ShoutClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Walk: TA2Button
    Left = 136
    Top = 38
    Width = 38
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_WalkClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Attack: TA2Button
    Left = 177
    Top = 38
    Width = 38
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_AttackClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Show: TA2Button
    Left = 218
    Top = 38
    Width = 38
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_ShowClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Eat: TA2Button
    Left = 13
    Top = 38
    Width = 39
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_EatClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Close: TA2Button
    Left = 294
    Top = 16
    Width = 15
    Height = 15
    AutoSize = False
    Color = clNavy
    ParentColor = False
    OnClick = A2Button_CloseClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Read: TA2Button
    Left = 130
    Top = 240
    Width = 56
    Height = 19
    AutoSize = False
    Color = clNavy
    ParentColor = False
    OnClick = A2Button_ReadClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Save: TA2Button
    Left = 206
    Top = 240
    Width = 56
    Height = 19
    AutoSize = False
    Color = clNavy
    ParentColor = False
    OnClick = A2Button_SaveClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Panel_shout: TA2Panel
    Left = 336
    Top = 176
    Width = 327
    Height = 181
    Color = clPurple
    TabOrder = 2
    Visible = False
    ADXForm = A2Form
    object A2ILabel_shout: TA2ILabel
      Left = -1
      Top = 0
      Width = 328
      Height = 180
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_shoutMouseMove
      ADXForm = A2Form
      DrawItemData = False
    end
    object A2CheckBox12: TA2CheckBox
      Left = 16
      Top = 149
      Width = 15
      Height = 15
      AutoSize = False
      Color = clGreen
      ParentColor = False
      OnClick = A2CheckBox12Click
      ADXForm = A2Form
    end
    object A2Button21: TA2Button
      Left = 160
      Top = 147
      Width = 19
      Height = 10
      AutoSize = False
      Color = clGreen
      ParentColor = False
      OnClick = A2Button21Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button22: TA2Button
      Left = 160
      Top = 158
      Width = 19
      Height = 10
      AutoSize = False
      Color = clGreen
      ParentColor = False
      OnClick = A2Button22Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button_AddShout: TA2Button
      Left = 176
      Top = 118
      Width = 21
      Height = 22
      AutoSize = False
      Color = clGreen
      ParentColor = False
      OnClick = A2Button_AddShoutClick
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button_DelShout: TA2Button
      Left = 201
      Top = 118
      Width = 22
      Height = 22
      AutoSize = False
      Color = clGreen
      ParentColor = False
      OnClick = A2Button_DelShoutClick
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2CheckBox_BossKey: TA2CheckBox
      Left = 20
      Top = 103
      Width = 26
      Height = 11
      AutoSize = False
      Color = clBlack
      ParentColor = False
      OnClick = A2CheckBox_BossKeyClick
      ADXForm = A2Form
    end
    object A2ListBox_ShoutList: TA2ListBox
      Left = 82
      Top = 3
      Width = 195
      Height = 91
      Caption = 'A2ListBox_ShoutList'
      TabOrder = 0
      boListbox = False
      ADXForm = A2Form
      FontColor = 32767
      FontSelColor = 255
      FontMovColor = 0
      ItemHeight = 12
      ItemMerginX = 3
      ItemMerginY = 3
      ItemFontMerginX = 0
      ItemFontMerginY = 0
      FontEmphasis = False
      ScrollBarView = True
      ScrollTrack = False
      NoHotDrawItemsCount = 0
      UseNewClick = False
      LeftMouseDown = False
    end
    object A2Edit11: TA2Edit
      Left = 105
      Top = 146
      Width = 54
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 1
      OnChange = A2Edit11Change
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit_AddShout: TA2Edit
      Left = 19
      Top = 121
      Width = 149
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 2
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit_BossKey: TA2Edit
      Left = 64
      Top = 100
      Width = 149
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 3
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
  end
  object A2Panel_walk: TA2Panel
    Left = 384
    Top = -8
    Width = 327
    Height = 181
    Color = clYellow
    TabOrder = 3
    Visible = False
    ADXForm = A2Form
    object A2ILabel_walk: TA2ILabel
      Left = 0
      Top = 0
      Width = 328
      Height = 180
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_walkMouseMove
      ADXForm = A2Form
      DrawItemData = False
    end
    object A2CheckBox_MoveOpenMagic: TA2CheckBox
      Left = 21
      Top = 12
      Width = 15
      Height = 14
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2CheckBox_MoveOpenMagicClick
      ADXForm = A2Form
    end
    object A2CheckBox11: TA2CheckBox
      Left = 21
      Top = 37
      Width = 15
      Height = 15
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2CheckBox11Click
      ADXForm = A2Form
    end
    object A2Button15: TA2Button
      Left = 234
      Top = 58
      Width = 19
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button15Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button16: TA2Button
      Left = 234
      Top = 69
      Width = 19
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button16Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button17: TA2Button
      Left = 162
      Top = 86
      Width = 18
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button17Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button18: TA2Button
      Left = 162
      Top = 97
      Width = 18
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button18Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button19: TA2Button
      Left = 234
      Top = 86
      Width = 19
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button19Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button20: TA2Button
      Left = 234
      Top = 97
      Width = 19
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button20Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button13: TA2Button
      Left = 162
      Top = 58
      Width = 17
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button13Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button14: TA2Button
      Left = 162
      Top = 69
      Width = 17
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button14Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Edit7: TA2Edit
      Left = 108
      Top = 62
      Width = 52
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 0
      Text = 'A2Edit7'
      OnChange = A2Edit7Change
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit8: TA2Edit
      Left = 182
      Top = 62
      Width = 52
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 1
      Text = 'A2Edit7'
      OnChange = A2Edit8Change
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit9: TA2Edit
      Left = 108
      Top = 90
      Width = 52
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 2
      Text = 'A2Edit7'
      OnChange = A2Edit9Change
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit10: TA2Edit
      Left = 182
      Top = 90
      Width = 52
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 3
      Text = 'A2Edit7'
      OnChange = A2Edit10Change
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2ComboBox_ChangeMoveMagic: TA2ComboBox
      Left = 108
      Top = 10
      Width = 117
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      ItemHeight = 13
      TabOrder = 4
      OnDropDown = A2ComboBox_ChangeMoveMagicDropDown
      ADXForm = A2Form
    end
  end
  object A2Panel_ShouName: TA2Panel
    Left = 279
    Top = 570
    Width = 327
    Height = 181
    Color = clLime
    TabOrder = 5
    Visible = False
    ADXForm = A2Form
    object A2ILabel_show: TA2ILabel
      Left = -4
      Top = -31
      Width = 328
      Height = 180
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_showMouseMove
      ADXForm = A2Form
      DrawItemData = False
    end
    object A2CheckBox_ShowAllName: TA2CheckBox
      Left = 34
      Top = 10
      Width = 14
      Height = 15
      AutoSize = False
      Color = clYellow
      ParentColor = False
      OnClick = A2CheckBox_ShowAllNameClick
      ADXForm = A2Form
    end
    object A2CheckBox_ShowMonster: TA2CheckBox
      Left = 34
      Top = 35
      Width = 14
      Height = 15
      AutoSize = False
      Color = clYellow
      ParentColor = False
      OnClick = A2CheckBox_ShowMonsterClick
      ADXForm = A2Form
    end
    object A2CheckBox_ShowNpc: TA2CheckBox
      Left = 34
      Top = 59
      Width = 14
      Height = 15
      AutoSize = False
      Color = clYellow
      ParentColor = False
      OnClick = A2CheckBox_ShowNpcClick
      ADXForm = A2Form
    end
    object A2CheckBox_ShowPlayer1: TA2CheckBox
      Left = 34
      Top = 85
      Width = 14
      Height = 15
      AutoSize = False
      Color = clYellow
      ParentColor = False
      OnClick = A2CheckBox_ShowPlayer1Click
      ADXForm = A2Form
    end
    object A2CheckBox_ShowItem: TA2CheckBox
      Left = 34
      Top = 110
      Width = 14
      Height = 15
      AutoSize = False
      Color = clYellow
      ParentColor = False
      OnClick = A2CheckBox_ShowItemClick
      ADXForm = A2Form
    end
  end
  object A2Panel_attack: TA2Panel
    Left = 468
    Top = 390
    Width = 327
    Height = 181
    Color = clTeal
    TabOrder = 4
    Visible = False
    ADXForm = A2Form
    object A2ILabel_attack: TA2ILabel
      Left = 0
      Top = 0
      Width = 328
      Height = 180
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_attackMouseMove
      ADXForm = A2Form
      DrawItemData = False
    end
    object A2CheckBox_Hit_not_Shift: TA2CheckBox
      Left = 22
      Top = 17
      Width = 15
      Height = 16
      AutoSize = False
      Color = clBlack
      ParentColor = False
      OnClick = A2CheckBox_Hit_not_ShiftClick
      ADXForm = A2Form
    end
    object A2CheckBox_Hit_not_Ctrl: TA2CheckBox
      Left = 22
      Top = 45
      Width = 15
      Height = 15
      AutoSize = False
      Color = clBlack
      ParentColor = False
      OnClick = A2CheckBox_Hit_not_CtrlClick
      ADXForm = A2Form
    end
    object A2CheckBox_autoHIt: TA2CheckBox
      Left = 22
      Top = 74
      Width = 15
      Height = 15
      AutoSize = False
      Color = clBlack
      ParentColor = False
      OnClick = A2CheckBox_autoHItClick
      ADXForm = A2Form
    end
    object A2CheckBox_MonsterHit: TA2CheckBox
      Left = 7
      Top = 32
      Width = 15
      Height = 14
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2CheckBox_MonsterHitClick
      ADXForm = A2Form
    end
    object A2CheckBox_CounterAttack: TA2CheckBox
      Left = 7
      Top = 20
      Width = 15
      Height = 14
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2CheckBox_CounterAttackClick
      ADXForm = A2Form
    end
    object A2CheckBox_CounterAttackUser: TA2CheckBox
      Left = 91
      Top = 10
      Width = 15
      Height = 14
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2CheckBox_CounterAttackUserClick
      ADXForm = A2Form
    end
    object A2CheckBox_QieHuan: TA2CheckBox
      Left = 22
      Top = 98
      Width = 15
      Height = 15
      AutoSize = False
      Color = clBlack
      ParentColor = False
      OnClick = A2CheckBox_QieHuanClick
      ADXForm = A2Form
    end
    object A2CheckBox_CL: TA2CheckBox
      Left = 22
      Top = 122
      Width = 15
      Height = 15
      AutoSize = False
      Color = clBlack
      ParentColor = False
      OnClick = A2CheckBox_QieHuanClick
      ADXForm = A2Form
    end
    object A2Label_AddQieHuan: TA2Label
      Left = 152
      Top = 112
      Width = 129
      Height = 12
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Transparent = True
      OnClick = A2Label_AddQieHuanClick
      ADXForm = A2Form
      FontColor = 32767
      BackColor = 0
      DrawItemData = False
      ChangeLine = False
      HeightSpac = 3
      LineEndSpac = 10
    end
    object A2ComboBox_MonsterList: TA2ComboBox
      Left = 44
      Top = 28
      Width = 117
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      ItemHeight = 13
      TabOrder = 0
      OnDropDown = A2ComboBox_MonsterListDropDown
      ADXForm = A2Form
    end
    object A2ComboBox_CLWG: TA2ComboBox
      Left = 44
      Top = 116
      Width = 117
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      ItemHeight = 13
      TabOrder = 1
      ADXForm = A2Form
    end
  end
  object A2Panel_pick: TA2Panel
    Left = 72
    Top = 388
    Width = 327
    Height = 181
    Color = clOlive
    TabOrder = 1
    Visible = False
    ADXForm = A2Form
    object A2ILabel_pick: TA2ILabel
      Left = 3
      Top = -11
      Width = 328
      Height = 180
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_pickMouseMove
      ADXForm = A2Form
      DrawItemData = False
    end
    object A2CheckBox_Pick: TA2CheckBox
      Left = 178
      Top = 24
      Width = 15
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2CheckBox_PickClick
      ADXForm = A2Form
    end
    object A2CheckBox_Opposite: TA2CheckBox
      Left = 178
      Top = 45
      Width = 15
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2CheckBox_OppositeClick
      ADXForm = A2Form
    end
    object A2Button_Add: TA2Button
      Left = 117
      Top = 143
      Width = 26
      Height = 26
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button_AddClick
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button_Dec: TA2Button
      Left = 147
      Top = 143
      Width = 26
      Height = 26
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button_DecClick
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2ListBox_Itemlist: TA2ListBox
      Left = 27
      Top = 28
      Width = 142
      Height = 113
      TabOrder = 0
      boListbox = False
      ADXForm = A2Form
      FontColor = 32767
      FontSelColor = 255
      FontMovColor = 0
      ItemHeight = 12
      ItemMerginX = 3
      ItemMerginY = 3
      ItemFontMerginX = 0
      ItemFontMerginY = 0
      FontEmphasis = False
      ScrollBarView = True
      ScrollTrack = False
      NoHotDrawItemsCount = 0
      UseNewClick = False
      LeftMouseDown = False
    end
    object A2Edit6: TA2Edit
      Left = 28
      Top = 147
      Width = 82
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 1
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2ListBox_DropItemlist: TA2ListBox
      Left = 179
      Top = 34
      Width = 142
      Height = 113
      TabOrder = 2
      OnDblClick = A2ListBox_DropItemlistDblClick
      boListbox = False
      ADXForm = A2Form
      FontColor = 32767
      FontSelColor = 255
      FontMovColor = 0
      ItemHeight = 12
      ItemMerginX = 3
      ItemMerginY = 3
      ItemFontMerginX = 0
      ItemFontMerginY = 0
      FontEmphasis = False
      ScrollBarView = True
      ScrollTrack = False
      NoHotDrawItemsCount = 0
      UseNewClick = False
      LeftMouseDown = False
    end
  end
  object A2Panel_eatblood: TA2Panel
    Left = 0
    Top = 56
    Width = 327
    Height = 180
    Color = clGreen
    TabOrder = 0
    ADXForm = A2Form
    object A2ILabel_BackEat: TA2ILabel
      Left = 0
      Top = 0
      Width = 328
      Height = 181
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_BackEatMouseMove
      ADXForm = A2Form
      DrawItemData = False
    end
    object A2CheckBox_inPower: TA2CheckBox
      Left = 25
      Top = 15
      Width = 40
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2CheckBox_inPowerClick
      ADXForm = A2Form
    end
    object A2CheckBox_outPower: TA2CheckBox
      Left = 25
      Top = 43
      Width = 40
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2CheckBox_outPowerClick
      ADXForm = A2Form
    end
    object A2CheckBox_Magic: TA2CheckBox
      Left = 25
      Top = 72
      Width = 40
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2CheckBox_MagicClick
      ADXForm = A2Form
    end
    object A2CheckBox_Life: TA2CheckBox
      Left = 25
      Top = 101
      Width = 40
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2CheckBox_LifeClick
      ADXForm = A2Form
    end
    object A2Button1: TA2Button
      Left = 136
      Top = 12
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button1Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button2: TA2Button
      Left = 136
      Top = 23
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button2Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button3: TA2Button
      Left = 136
      Top = 40
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button3Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button4: TA2Button
      Left = 136
      Top = 51
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button4Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button5: TA2Button
      Left = 136
      Top = 69
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button5Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button6: TA2Button
      Left = 136
      Top = 80
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button6Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button7: TA2Button
      Left = 136
      Top = 97
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button7Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button8: TA2Button
      Left = 136
      Top = 108
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button8Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button9: TA2Button
      Left = 136
      Top = 154
      Width = 19
      Height = 10
      AutoSize = False
      Color = clBlue
      ParentColor = False
      OnClick = A2Button9Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button10: TA2Button
      Left = 136
      Top = 166
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button10Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button11: TA2Button
      Left = 137
      Top = 123
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button11Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button12: TA2Button
      Left = 137
      Top = 136
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button12Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2CheckBox1: TA2CheckBox
      Left = 25
      Top = 127
      Width = 40
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2CheckBox1Click
      ADXForm = A2Form
    end
    object A2CheckBox_ProtectMagic: TA2CheckBox
      Left = 31
      Top = 155
      Width = 15
      Height = 14
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2CheckBox_ProtectMagicClick
      ADXForm = A2Form
    end
    object A2CheckBoxThreePower: TA2CheckBox
      Left = 13
      Top = 159
      Width = 15
      Height = 15
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2CheckBoxThreePowerClick
      ADXForm = A2Form
    end
    object A2Edit_inPower: TA2Edit
      Left = 82
      Top = 15
      Width = 54
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 0
      OnChange = A2Edit_inPowerChange
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit_outPower: TA2Edit
      Left = 82
      Top = 42
      Width = 54
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 1
      OnChange = A2Edit_outPowerChange
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit_Magic: TA2Edit
      Left = 82
      Top = 71
      Width = 54
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 2
      OnChange = A2Edit_MagicChange
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit_Life: TA2Edit
      Left = 82
      Top = 99
      Width = 54
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 3
      OnChange = A2Edit_LifeChange
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit_delayTimeEat: TA2Edit
      Left = 82
      Top = 155
      Width = 54
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 4
      OnChange = A2Edit_delayTimeEatChange
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2ComboBox_inPower: TA2ComboBox
      Left = 178
      Top = 12
      Width = 74
      Height = 21
      Color = clWhite
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 5
      Text = #27748#33647
      OnChange = A2ComboBox_inPowerChange
      OnDropDown = A2ComboBox_inPowerDropDown
      Items.Strings = (
        #27748#33647)
      ADXForm = A2Form
    end
    object A2ComboBox_outPower: TA2ComboBox
      Left = 178
      Top = 40
      Width = 74
      Height = 21
      Color = clWhite
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 6
      Text = #20024#33647
      OnChange = A2ComboBox_outPowerChange
      OnDropDown = A2ComboBox_inPowerDropDown
      Items.Strings = (
        #20024#33647)
      ADXForm = A2Form
    end
    object A2ComboBox_Magic: TA2ComboBox
      Left = 210
      Top = 69
      Width = 74
      Height = 21
      Color = clWhite
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 7
      Text = #20025#33647
      OnChange = A2ComboBox_MagicChange
      OnDropDown = A2ComboBox_inPowerDropDown
      Items.Strings = (
        #20025#33647)
      ADXForm = A2Form
    end
    object A2ComboBox_Life: TA2ComboBox
      Left = 178
      Top = 97
      Width = 74
      Height = 21
      Color = clWhite
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 8
      Text = #29983#33647
      OnChange = A2ComboBox_LifeChange
      OnDropDown = A2ComboBox_inPowerDropDown
      Items.Strings = (
        #29983#33647)
      ADXForm = A2Form
    end
    object A2ComboBox1: TA2ComboBox
      Left = 178
      Top = 124
      Width = 74
      Height = 21
      Color = clWhite
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 9
      Text = #29983#33647
      OnDropDown = A2ComboBox_inPowerDropDown
      Items.Strings = (
        #29983#33647)
      ADXForm = A2Form
    end
    object A2Edit1: TA2Edit
      Left = 82
      Top = 125
      Width = 54
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      TabOrder = 10
      Text = '20'
      OnChange = A2Edit1Change
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2ComboBox_ProtectMagic: TA2ComboBox
      Left = 118
      Top = 153
      Width = 117
      Height = 21
      ImeName = #20013#25991'('#31616#20307') - '#30334#24230#36755#20837#27861
      ItemHeight = 13
      TabOrder = 11
      OnDropDown = A2ComboBox_ProtectMagicDropDown
      ADXForm = A2Form
    end
  end
  object A2Form: TA2Form
    Color = clBlack
    ShowMethod = FSM_NONE
    TransParent = False
    Top = 280
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 96
  end
end
