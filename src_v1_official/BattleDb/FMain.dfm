object FrmMain: TFrmMain
  Left = 280
  Top = 182
  BorderStyle = bsDialog
  Caption = 'Battle DB'
  ClientHeight = 547
  ClientWidth = 711
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
  object lstComment: TListBox
    Left = 8
    Top = 8
    Width = 521
    Height = 113
    ImeName = #33540#24811#32482'('#33540#33218') (MS-IME98)'
    ItemHeight = 13
    TabOrder = 0
  end
  object cmdClose: TButton
    Left = 168
    Top = 520
    Width = 73
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = cmdCloseClick
  end
  object cmdInit: TButton
    Left = 0
    Top = 560
    Width = 75
    Height = 25
    Caption = 'Init'
    TabOrder = 2
    OnClick = cmdInitClick
  end
  object cmdSave: TButton
    Left = 8
    Top = 520
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 3
    OnClick = cmdSaveClick
  end
  object lstResult1: TListBox
    Left = 8
    Top = 128
    Width = 169
    Height = 185
    ImeName = #33540#24811#32482'('#33540#33218') (MS-IME98)'
    ItemHeight = 13
    TabOrder = 4
  end
  object cmdTest: TButton
    Left = 80
    Top = 560
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 5
    OnClick = cmdTestClick
  end
  object lstResult2: TListBox
    Left = 184
    Top = 128
    Width = 169
    Height = 185
    ImeName = #33540#24811#32482'('#33540#33218') (MS-IME98)'
    ItemHeight = 13
    TabOrder = 6
  end
  object lstResult3: TListBox
    Left = 360
    Top = 128
    Width = 169
    Height = 185
    ImeName = #33540#24811#32482'('#33540#33218') (MS-IME98)'
    ItemHeight = 13
    TabOrder = 7
  end
  object lstResult4: TListBox
    Left = 8
    Top = 320
    Width = 169
    Height = 185
    ImeName = #33540#24811#32482'('#33540#33218') (MS-IME98)'
    ItemHeight = 13
    TabOrder = 8
  end
  object lstResult5: TListBox
    Left = 184
    Top = 320
    Width = 169
    Height = 185
    ImeName = #33540#24811#32482'('#33540#33218') (MS-IME98)'
    ItemHeight = 13
    TabOrder = 9
  end
  object lstResult6: TListBox
    Left = 536
    Top = 8
    Width = 169
    Height = 537
    ImeName = #33540#24811#32482'('#33540#33218') (MS-IME98)'
    ItemHeight = 13
    TabOrder = 10
  end
  object cmdDisplay: TButton
    Left = 88
    Top = 520
    Width = 75
    Height = 25
    Caption = 'Display'
    TabOrder = 11
    OnClick = cmdDisplayClick
  end
  object sckAccept: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnAccept = sckAcceptAccept
    OnClientConnect = sckAcceptClientConnect
    OnClientDisconnect = sckAcceptClientDisconnect
    OnClientRead = sckAcceptClientRead
    OnClientWrite = sckAcceptClientWrite
    OnClientError = sckAcceptClientError
    Left = 8
    Top = 8
  end
  object timerProcess: TTimer
    OnTimer = timerProcessTimer
    Left = 40
    Top = 8
  end
  object timerSave: TTimer
    Enabled = False
    OnTimer = timerSaveTimer
    Left = 72
    Top = 8
  end
end
