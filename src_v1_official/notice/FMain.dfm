object frmMain: TfrmMain
  Left = 249
  Top = 106
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'notice server'
  ClientHeight = 328
  ClientWidth = 304
  Color = clGreen
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
  object lblTotal: TLabel
    Left = 8
    Top = 300
    Width = 193
    Height = 25
    AutoSize = False
    Caption = 'User Count 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object tabView: TPageControl
    Left = 8
    Top = 8
    Width = 289
    Height = 281
    ActivePage = tsServer
    TabOrder = 0
    object tsServer: TTabSheet
      Caption = 'Servers'
      object grdServer: TStringGrid
        Left = 8
        Top = 32
        Width = 265
        Height = 217
        TabOrder = 0
      end
      object cmbServers: TComboBox
        Left = 88
        Top = 8
        Width = 185
        Height = 21
        Style = csDropDownList
        ImeName = '한국어(한글) (MS-IME98)'
        ItemHeight = 13
        TabOrder = 1
      end
      object cmdRefresh: TButton
        Left = 8
        Top = 8
        Width = 75
        Height = 21
        Caption = 'Refresh'
        TabOrder = 2
        OnClick = cmdRefreshClick
      end
    end
    object tsInfo: TTabSheet
      Caption = 'Info'
      ImageIndex = 1
      object lstInfo: TListBox
        Left = 8
        Top = 8
        Width = 265
        Height = 241
        ImeName = '한국어(한글) (MS-IME98)'
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object tsResult: TTabSheet
      Caption = 'Result'
      ImageIndex = 2
      object lstResult: TListBox
        Left = 8
        Top = 8
        Width = 265
        Height = 217
        ImeName = '한국어(한글) (MS-IME98)'
        ItemHeight = 13
        TabOrder = 0
      end
      object chkIPLImit: TCheckBox
        Left = 8
        Top = 232
        Width = 193
        Height = 17
        Caption = 'Limit Same IP User'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
    object tsGate: TTabSheet
      Caption = 'GateWays'
      ImageIndex = 3
      object grdGate: TStringGrid
        Left = 8
        Top = 8
        Width = 265
        Height = 129
        TabOrder = 0
        OnDblClick = grdGateDblClick
      end
      object lstGateUser: TListBox
        Left = 8
        Top = 144
        Width = 265
        Height = 97
        ImeName = '한국어(한글) (MS-IME98)'
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object tsUsedIP: TTabSheet
      Caption = 'Used IPs'
      ImageIndex = 4
      object lblUsedIP: TLabel
        Left = 8
        Top = 208
        Width = 129
        Height = 17
        AutoSize = False
        Caption = 'Used IP Count : 0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 8
        Top = 12
        Width = 129
        Height = 17
        AutoSize = False
        Caption = 'Used IP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 144
        Top = 12
        Width = 129
        Height = 17
        AutoSize = False
        Caption = 'Ended IP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblBanIP: TLabel
        Left = 8
        Top = 192
        Width = 265
        Height = 17
        AutoSize = False
        Caption = 'BAN IP Count : 0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lstUsedIP: TListBox
        Left = 8
        Top = 32
        Width = 129
        Height = 153
        ImeName = '한국어(한글) (MS-IME98)'
        ItemHeight = 13
        TabOrder = 0
      end
      object lstEndIP: TListBox
        Left = 144
        Top = 32
        Width = 129
        Height = 153
        ImeName = '한국어(한글) (MS-IME98)'
        ItemHeight = 13
        TabOrder = 1
      end
    end
  end
  object cmdClose: TButton
    Left = 216
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = cmdCloseClick
  end
  object sckServer: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnAccept = sckServerAccept
    OnClientDisconnect = sckServerClientDisconnect
    OnClientRead = sckServerClientRead
    OnClientWrite = sckServerClientWrite
    OnClientError = sckServerClientError
    Left = 8
    Top = 328
  end
  object timerProcess: TTimer
    Enabled = False
    OnTimer = timerProcessTimer
    Left = 40
    Top = 328
  end
  object timerDisplay: TTimer
    Enabled = False
    OnTimer = timerDisplayTimer
    Left = 72
    Top = 328
  end
  object sckARS: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnAccept = sckARSAccept
    OnClientDisconnect = sckARSClientDisconnect
    OnClientRead = sckARSClientRead
    OnClientError = sckARSClientError
    Left = 104
    Top = 328
  end
  object udpSend: TNMUDP
    RemotePort = 0
    LocalPort = 0
    ReportLevel = 1
    Left = 136
    Top = 328
  end
end
