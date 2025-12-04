object FormAuction: TFormAuction
  Left = 209
  Top = 148
  AutoScroll = False
  Caption = #23492#21806#20449#24687
  ClientHeight = 453
  ClientWidth = 688
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
    Width = 688
    Height = 57
    Align = alTop
    TabOrder = 0
    object Button_ReLoad: TButton
      Left = 536
      Top = 16
      Width = 121
      Height = 25
      Caption = #37325#26032#35835#20986#25968#25454
      TabOrder = 0
      OnClick = Button_ReLoadClick
    end
    object Panel_find: TPanel
      Left = 1
      Top = 1
      Width = 312
      Height = 55
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 13
        Top = 19
        Width = 44
        Height = 13
        Caption = #23492#21806'ID   '
      end
      object Button_find_Auction_ID: TButton
        Left = 192
        Top = 13
        Width = 75
        Height = 25
        Caption = 'ID'#26597#25214
        TabOrder = 0
        OnClick = Button_find_Auction_IDClick
      end
      object Edit_Auction__find_ID: TEdit
        Left = 64
        Top = 16
        Width = 121
        Height = 21
        TabOrder = 1
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 688
    Height = 396
    Align = alClient
    TabOrder = 1
    object Panel_update: TPanel
      Left = 1
      Top = 1
      Width = 686
      Height = 41
      Align = alTop
      TabOrder = 0
      object Label2: TLabel
        Left = 2
        Top = 12
        Width = 60
        Height = 13
        Caption = #35282#33394#21517#31216'    '
      end
      object Button_change_Auction: TButton
        Left = 305
        Top = 5
        Width = 75
        Height = 25
        Caption = #20462#25913
        Enabled = False
        TabOrder = 0
        OnClick = Button_change_AuctionClick
      end
      object Edit_Auction__find_name: TEdit
        Left = 62
        Top = 8
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object Button_find_Auction_name: TButton
        Left = 192
        Top = 5
        Width = 73
        Height = 25
        Caption = #21517#31216#26597#25214
        TabOrder = 2
        OnClick = Button_find_Auction_nameClick
      end
    end
    object StringGrid_Auction: TStringGrid
      Left = 1
      Top = 42
      Width = 686
      Height = 353
      Align = alClient
      ColCount = 2
      RowCount = 2
      TabOrder = 1
    end
    object Panel_Auction_Edit: TPanel
      Left = 160
      Top = 32
      Width = 345
      Height = 281
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
      object Label3: TLabel
        Left = 16
        Top = 16
        Width = 116
        Height = 20
        Caption = #25293#21334#32534#36753#26694'      '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 86
        Top = 57
        Width = 14
        Height = 13
        Caption = 'ID '
        Enabled = False
      end
      object Label5: TLabel
        Left = 80
        Top = 84
        Width = 20
        Height = 13
        Caption = 'IMG'
      end
      object Label19: TLabel
        Left = 51
        Top = 105
        Width = 49
        Height = 13
        Caption = 'DateTime '
      end
      object Label20: TLabel
        Left = 53
        Top = 129
        Width = 47
        Height = 13
        Caption = 'Pricetype '
      end
      object Label21: TLabel
        Left = 76
        Top = 152
        Width = 24
        Height = 13
        Caption = 'Price'
      end
      object Label22: TLabel
        Left = 54
        Top = 199
        Width = 46
        Height = 13
        Caption = 'MaxTime '
      end
      object Label23: TLabel
        Left = 21
        Top = 223
        Width = 79
        Height = 13
        Caption = 'BargainorName  '
      end
      object Label26: TLabel
        Left = 74
        Top = 176
        Width = 26
        Height = 13
        Caption = 'Time '
      end
      object Label6: TLabel
        Left = 69
        Top = 247
        Width = 27
        Height = 13
        Caption = #38468#20214' '
        Enabled = False
      end
      object Button_Auction_Save: TButton
        Left = 136
        Top = 16
        Width = 99
        Height = 25
        Caption = #20889#20837#25968#25454#24211
        TabOrder = 0
        OnClick = Button_Auction_SaveClick
      end
      object Button_Auction_Close: TButton
        Left = 248
        Top = 16
        Width = 75
        Height = 25
        Caption = #20851#38381
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = Button_Auction_CloseClick
      end
      object Edit_Auction_ID: TEdit
        Left = 106
        Top = 56
        Width = 121
        Height = 21
        Color = cl3DLight
        Enabled = False
        TabOrder = 2
      end
      object Edit_Auction_IMG: TEdit
        Left = 106
        Top = 80
        Width = 121
        Height = 21
        TabOrder = 3
      end
      object Edit_Auction_MaxTime: TEdit
        Left = 105
        Top = 196
        Width = 121
        Height = 21
        TabOrder = 4
      end
      object Edit_Auction_Itemtime: TEdit
        Left = 105
        Top = 172
        Width = 121
        Height = 21
        TabOrder = 5
      end
      object Edit_Auction_Price: TEdit
        Left = 105
        Top = 148
        Width = 121
        Height = 21
        TabOrder = 6
      end
      object Edit_Auction_DateTime: TEdit
        Left = 105
        Top = 103
        Width = 121
        Height = 21
        TabOrder = 7
      end
      object Edit_Auction_Name: TEdit
        Left = 104
        Top = 219
        Width = 121
        Height = 21
        MaxLength = 20
        TabOrder = 8
      end
      object ComboBox_Auction_PriceType: TComboBox
        Left = 105
        Top = 124
        Width = 121
        Height = 21
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 9
        Text = 'Gold'
        Items.Strings = (
          'Gold'
          'GOLD_Money')
      end
      object Button_item_edit: TButton
        Left = 232
        Top = 240
        Width = 75
        Height = 25
        Caption = #29289#21697#32534#36753
        TabOrder = 10
        OnClick = Button_item_editClick
      end
      object Edit_item_name: TEdit
        Left = 104
        Top = 243
        Width = 121
        Height = 21
        Color = cl3DLight
        Enabled = False
        TabOrder = 11
      end
    end
  end
end
