object frmfbl: Tfrmfbl
  Left = 442
  Top = 283
  Width = 377
  Height = 219
  Caption = #27426#36814#36827#20837#29066#26063'OL'#30340#19990#30028
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 173
    Width = 369
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end>
    ParentColor = True
    ParentFont = True
    UseSystemFont = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 369
    Height = 173
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #30331#24405#39564#35777
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 49
        Height = 13
        AutoSize = False
        Caption = #29992#25143
      end
      object Label2: TLabel
        Left = 16
        Top = 56
        Width = 49
        Height = 13
        AutoSize = False
        Caption = #23494#30721
      end
      object Label7: TLabel
        Left = 40
        Top = 96
        Width = 241
        Height = 13
        AutoSize = False
        Caption = #33719#21462#29992#25143#23494#30721#35831#21040'www.mybr.org'
      end
      object Button1: TButton
        Left = 240
        Top = 48
        Width = 105
        Height = 25
        Caption = #24320#22987#39564#35777
        TabOrder = 0
        OnClick = Button1Click
      end
      object pass: TEdit
        Left = 98
        Top = 52
        Width = 107
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
        PasswordChar = '*'
        TabOrder = 1
      end
      object user: TEdit
        Left = 98
        Top = 9
        Width = 107
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
        TabOrder = 2
      end
      object Button3: TButton
        Left = 240
        Top = 16
        Width = 105
        Height = 25
        Caption = #21097#20313#26102#38388#26597#35810
        TabOrder = 3
        OnClick = Button3Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20462#25913#23494#30721
      ImageIndex = 1
      object Label3: TLabel
        Left = 16
        Top = 22
        Width = 41
        Height = 13
        AutoSize = False
        Caption = #29992#25143
      end
      object Label4: TLabel
        Left = 184
        Top = 22
        Width = 49
        Height = 13
        AutoSize = False
        Caption = #23494#30721
      end
      object Label5: TLabel
        Left = 8
        Top = 54
        Width = 73
        Height = 13
        AutoSize = False
        Caption = #36755#20837#26032#23494#30721
      end
      object Label6: TLabel
        Left = 176
        Top = 54
        Width = 73
        Height = 13
        AutoSize = False
        Caption = #37325#22797#26032#23494#30721
      end
      object passnew1: TEdit
        Left = 88
        Top = 48
        Width = 79
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
        PasswordChar = '*'
        TabOrder = 0
      end
      object oldpass: TEdit
        Left = 256
        Top = 21
        Width = 79
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
        PasswordChar = '*'
        TabOrder = 1
      end
      object name: TEdit
        Left = 88
        Top = 21
        Width = 79
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
        TabOrder = 2
      end
      object passnew2: TEdit
        Left = 258
        Top = 48
        Width = 79
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
        PasswordChar = '*'
        TabOrder = 3
      end
      object Button2: TButton
        Left = 224
        Top = 80
        Width = 89
        Height = 25
        Caption = #20462#25913#23494#30721
        TabOrder = 4
        OnClick = Button2Click
      end
    end
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 192
    Top = 65528
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 224
  end
end
