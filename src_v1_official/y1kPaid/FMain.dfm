object frmMain: TfrmMain
  Left = 272
  Top = 134
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Paid Server'
  ClientHeight = 242
  ClientWidth = 202
  Color = clOlive
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
  object Label1: TLabel
    Left = 8
    Top = 168
    Width = 68
    Height = 13
    Caption = '0 Connections'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object cmdClose: TButton
    Left = 128
    Top = 208
    Width = 73
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = cmdCloseClick
  end
  object grdList: TStringGrid
    Left = 0
    Top = 0
    Width = 201
    Height = 153
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object timerProcess: TTimer
    OnTimer = timerProcessTimer
    Left = 40
    Top = 208
  end
  object sckAccept: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnAccept = sckAcceptAccept
    OnClientDisconnect = sckAcceptClientDisconnect
    OnClientRead = sckAcceptClientRead
    OnClientWrite = sckAcceptClientWrite
    OnClientError = sckAcceptClientError
    Left = 8
    Top = 208
  end
end
