object frmMain: TfrmMain
  Left = 502
  Top = 201
  Width = 341
  Height = 400
  Caption = 'Gate Balancing'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 325
    Height = 361
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'GATE'#21015#34920
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 317
        Height = 332
        Align = alClient
        Color = clMedGray
        Ctl3D = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = #35760#24405
      ImageIndex = 1
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 228
        Height = 333
        Align = alClient
        Color = clMedGray
        Ctl3D = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 228
        Top = 0
        Width = 89
        Height = 333
        Align = alRight
        TabOrder = 1
        object Button3: TButton
          Left = 6
          Top = 80
          Width = 75
          Height = 25
          Caption = #28165#38500#35760#24405
          TabOrder = 0
          OnClick = Button3Click
        end
        object Button2: TButton
          Left = 6
          Top = 40
          Width = 75
          Height = 25
          Caption = #36830#25509#35760#24405
          TabOrder = 1
          OnClick = Button2Click
        end
        object Button1: TButton
          Left = 6
          Top = 8
          Width = 75
          Height = 25
          Caption = #30331#38470#35760#24405
          TabOrder = 2
          OnClick = Button1Click
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #35774#32622
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 0
        Top = 8
        Width = 150
        Height = 105
        Caption = #30331#38470#38480#21046
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 28
          Width = 64
          Height = 14
          Caption = #26368#30701#26102#38388'-'#31186
        end
        object Label2: TLabel
          Left = 8
          Top = 76
          Width = 64
          Height = 14
          Caption = #25968#37327#38480#21046'-'#27425
        end
        object Label3: TLabel
          Left = 8
          Top = 52
          Width = 64
          Height = 14
          Caption = #20943#21009#26102#38388'-'#31186
        end
        object SpinEdit_logindectime: TSpinEdit
          Left = 80
          Top = 48
          Width = 51
          Height = 23
          MaxValue = 100
          MinValue = 1
          TabOrder = 0
          Value = 1
          OnChange = SpinEdit_logindectimeChange
        end
        object SpinEdit_logintime: TSpinEdit
          Left = 80
          Top = 24
          Width = 51
          Height = 23
          MaxValue = 100
          MinValue = 0
          TabOrder = 1
          Value = 0
          OnChange = SpinEdit_logintimeChange
        end
        object SpinEdit_logincount: TSpinEdit
          Left = 80
          Top = 74
          Width = 51
          Height = 23
          MaxValue = 10000
          MinValue = 1
          TabOrder = 2
          Value = 1
          OnChange = SpinEdit_logincountChange
        end
      end
      object GroupBox2: TGroupBox
        Left = 165
        Top = 8
        Width = 150
        Height = 105
        Caption = #36830#25509#38480#21046
        TabOrder = 1
        object Label4: TLabel
          Left = 9
          Top = 28
          Width = 64
          Height = 14
          Caption = #26368#30701#26102#38388'-'#31186
        end
        object Label5: TLabel
          Left = 9
          Top = 76
          Width = 64
          Height = 14
          Caption = #25968#37327#38480#21046'-'#27425
        end
        object Label6: TLabel
          Left = 9
          Top = 52
          Width = 64
          Height = 14
          Caption = #20943#21009#26102#38388'-'#31186
        end
        object SpinEdit_conndectime: TSpinEdit
          Left = 80
          Top = 48
          Width = 49
          Height = 23
          MaxValue = 100
          MinValue = 1
          TabOrder = 0
          Value = 1
          OnChange = SpinEdit_conndectimeChange
        end
        object SpinEdit_conntime: TSpinEdit
          Left = 80
          Top = 24
          Width = 49
          Height = 23
          MaxValue = 100
          MinValue = 0
          TabOrder = 1
          Value = 0
          OnChange = SpinEdit_conntimeChange
        end
        object SpinEdit_conncount: TSpinEdit
          Left = 80
          Top = 74
          Width = 49
          Height = 23
          MaxValue = 10000
          MinValue = 1
          TabOrder = 2
          Value = 1
          OnChange = SpinEdit_conncountChange
        end
      end
      object grp1: TGroupBox
        Left = 0
        Top = 120
        Width = 313
        Height = 105
        Caption = #30331#38470#38480#21046
        TabOrder = 2
        object lbl1: TLabel
          Left = 8
          Top = 28
          Width = 60
          Height = 14
          Caption = #23458#25143#31471#25968#37327
        end
        object SpinEdit_ClientNum: TSpinEdit
          Left = 80
          Top = 24
          Width = 51
          Height = 23
          MaxValue = 100
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnChange = SpinEdit_ClientNumChange
        end
        object chk_open: TCheckBox
          Left = 8
          Top = 52
          Width = 80
          Height = 17
          Caption = #38480#26102#30331#38470
          TabOrder = 1
        end
        object dtp_date: TDateTimePicker
          Left = 80
          Top = 48
          Width = 90
          Height = 22
          Date = 42594.640097824070000000
          Time = 42594.640097824070000000
          TabOrder = 2
          OnChange = dtp_dateChange
        end
        object dtp_time: TDateTimePicker
          Left = 176
          Top = 48
          Width = 90
          Height = 22
          Date = 42594.640097824070000000
          Time = 42594.640097824070000000
          Kind = dtkTime
          TabOrder = 3
          OnChange = dtp_dateChange
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #25805#20316
      ImageIndex = 3
      object lstInfo: TListBox
        Left = 0
        Top = 65
        Width = 317
        Height = 267
        Align = alClient
        Ctl3D = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 14
        ParentCtl3D = False
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 317
        Height = 65
        Align = alTop
        TabOrder = 1
        object Label7: TLabel
          Left = 8
          Top = 35
          Width = 36
          Height = 14
          Caption = #29256#26412#21495
        end
        object cmdClose: TButton
          Left = 184
          Top = 24
          Width = 65
          Height = 33
          Caption = 'Close'
          TabOrder = 0
          OnClick = cmdCloseClick
        end
        object Edit_ver: TEdit
          Left = 56
          Top = 29
          Width = 121
          Height = 22
          ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          TabOrder = 1
          Text = 'Edit_ver'
          OnChange = Edit_verChange
        end
        object chkUserAccept: TCheckBox
          Left = 8
          Top = 8
          Width = 97
          Height = 17
          Caption = 'Accept User'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object CheckBox_ver: TCheckBox
          Left = 128
          Top = 8
          Width = 97
          Height = 17
          Caption = #26816#26597#29256#26412#21495
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
      end
    end
  end
  object sckUser: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnAccept = sckUserAccept
    OnClientDisconnect = sckUserClientDisconnect
    OnClientRead = sckUserClientRead
    OnClientWrite = sckUserClientWrite
    OnClientError = sckUserClientError
    Left = 8
    Top = 280
  end
  object timerDisplay: TTimer
    OnTimer = timerDisplayTimer
    Left = 72
    Top = 280
  end
  object timerProcess: TTimer
    Interval = 10
    OnTimer = timerProcessTimer
    Left = 104
    Top = 280
  end
  object sckGate: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnAccept = sckGateAccept
    OnClientConnect = sckGateClientConnect
    OnClientDisconnect = sckGateClientDisconnect
    OnClientRead = sckGateClientRead
    OnClientWrite = sckGateClientWrite
    OnClientError = sckGateClientError
    Left = 72
    Top = 240
  end
end
