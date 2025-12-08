object FrmUserManager: TFrmUserManager
  Left = 192
  Top = 53
  Width = 928
  Height = 526
  Caption = #22312#32447#29992#25143#31649#29702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 912
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 60
      Height = 13
      AutoSize = False
      Caption = #26597#25214#23545#35937
    end
    object Label2: TLabel
      Left = 160
      Top = 16
      Width = 60
      Height = 13
      AutoSize = False
      Caption = #20851#38190#23383
    end
    object lbl1: TLabel
      Left = 344
      Top = 16
      Width = 60
      Height = 13
      AutoSize = False
      Caption = #29609#23478#25968#37327': '
    end
    object lblwj: TLabel
      Left = 408
      Top = 16
      Width = 30
      Height = 13
      AutoSize = False
      Caption = '0'
    end
    object lbl2: TLabel
      Left = 464
      Top = 16
      Width = 45
      Height = 13
      AutoSize = False
      Caption = 'IP'#25968#37327': '
    end
    object lblIP: TLabel
      Left = 512
      Top = 16
      Width = 40
      Height = 13
      AutoSize = False
      Caption = '0'
    end
    object lbl3: TLabel
      Left = 568
      Top = 16
      Width = 60
      Height = 13
      AutoSize = False
      Caption = #26426#22120#25968#37327': '
    end
    object lblJQ: TLabel
      Left = 632
      Top = 16
      Width = 40
      Height = 13
      AutoSize = False
      Caption = '0'
    end
    object edtQryName: TEdit
      Left = 160
      Top = 41
      Width = 169
      Height = 19
      ReadOnly = True
      TabOrder = 0
    end
    object cbbQryObj: TComboBox
      Left = 8
      Top = 40
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'ALL'
      OnCloseUp = cbbQryObjCloseUp
      Items.Strings = (
        'ALL'
        #30331#38470'ID'
        #35282#33394#21517#31216
        #36830#32447'IP'
        #22806#32593'IP'
        #19978#32447#26102#38388
        #26426#22120#30721)
    end
    object btnQry: TButton
      Left = 344
      Top = 38
      Width = 75
      Height = 25
      Caption = #26597#25214
      TabOrder = 2
      OnClick = btnQryClick
    end
    object btnBan: TButton
      Left = 424
      Top = 38
      Width = 75
      Height = 25
      Caption = #24378#21046#19979#32447
      TabOrder = 3
      OnClick = btnBanClick
    end
    object btnBanIP: TButton
      Tag = 1
      Left = 584
      Top = 38
      Width = 75
      Height = 25
      Caption = #23631#34109'IP'
      TabOrder = 4
      OnClick = btnBanIPClick
    end
    object btnBanID: TButton
      Left = 504
      Top = 38
      Width = 75
      Height = 25
      Caption = #23631#34109#30331#38470'ID'
      TabOrder = 5
      OnClick = btnBanIPClick
    end
    object btnBanHcode: TButton
      Tag = 2
      Left = 664
      Top = 38
      Width = 75
      Height = 25
      Caption = #23631#34109#26426#22120#30721
      TabOrder = 6
      OnClick = btnBanIPClick
    end
    object btnQryBan: TButton
      Left = 744
      Top = 38
      Width = 75
      Height = 25
      Caption = #23631#34109#21015#34920
      TabOrder = 7
      OnClick = btnQryBanClick
    end
    object btnre: TButton
      Left = 824
      Top = 38
      Width = 75
      Height = 25
      Caption = #21047#26032#21015#34920
      TabOrder = 8
      OnClick = btnreClick
    end
    object edit_copy: TEdit
      Left = 8
      Top = 73
      Width = 889
      Height = 19
      ReadOnly = True
      TabOrder = 9
    end
  end
  object sgUsers: TStringGrid
    Left = 0
    Top = 97
    Width = 912
    Height = 371
    Align = alClient
    ColCount = 7
    Ctl3D = False
    DefaultRowHeight = 18
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goThumbTracking]
    ParentCtl3D = False
    TabOrder = 1
    OnClick = sgUsersClick
    ColWidths = (
      64
      85
      102
      103
      123
      113
      294)
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 468
    Width = 912
    Height = 19
    Panels = <>
  end
  object pnlBanlist: TPanel
    Left = 232
    Top = 104
    Width = 433
    Height = 225
    TabOrder = 3
    Visible = False
    object pnlBantitle: TPanel
      Left = 1
      Top = 1
      Width = 431
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      Caption = #23631#34109#21015#34920
      Color = clNavy
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object btnBanClose: TSpeedButton
        Left = 408
        Top = 0
        Width = 23
        Height = 22
        Caption = 'X'
        Flat = True
        OnClick = btnBanCloseClick
      end
    end
    object sgBanlist: TStringGrid
      Left = 1
      Top = 25
      Width = 431
      Height = 158
      Align = alClient
      ColCount = 3
      Ctl3D = False
      DefaultRowHeight = 18
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goThumbTracking]
      ParentCtl3D = False
      TabOrder = 1
      ColWidths = (
        64
        85
        253)
    end
    object pnlBanBottom: TPanel
      Left = 1
      Top = 183
      Width = 431
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object btnBanDelete: TButton
        Left = 376
        Top = 8
        Width = 40
        Height = 25
        Caption = #21024#38500
        TabOrder = 0
        OnClick = btnBanDeleteClick
      end
      object cbb_add: TComboBox
        Left = 8
        Top = 10
        Width = 100
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = #23631#34109#30331#38470'ID'
        OnCloseUp = cbbQryObjCloseUp
        Items.Strings = (
          #23631#34109#30331#38470'ID'
          #23631#34109#22806#32593'IP'
          #23631#34109#26426#22120#30721)
      end
      object btn_ban: TButton
        Left = 312
        Top = 8
        Width = 40
        Height = 25
        Caption = #28155#21152
        TabOrder = 2
        OnClick = btn_banClick
      end
      object edt_add: TEdit
        Left = 120
        Top = 10
        Width = 169
        Height = 19
        TabOrder = 3
      end
    end
  end
end
