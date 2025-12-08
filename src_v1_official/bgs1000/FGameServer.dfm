object frmGSState: TfrmGSState
  Left = 367
  Top = 192
  Width = 436
  Height = 366
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'GameServer State'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 1
    Top = 9
    Width = 208
    Height = 104
    Caption = '창조 GS'
    TabOrder = 0
    object Label1: TLabel
      Left = 15
      Top = 24
      Width = 65
      Height = 12
      Caption = 'Send Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 15
      Top = 40
      Width = 81
      Height = 12
      Caption = 'Receive Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 15
      Top = 56
      Width = 102
      Height = 12
      Caption = 'WouldBlock Count'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblCreateSendB: TLabel
      Left = 144
      Top = 24
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblCreateReceiveB: TLabel
      Left = 144
      Top = 40
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblCreateWBC: TLabel
      Left = 144
      Top = 56
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object shpCreateWBSign: TShape
      Left = 15
      Top = 82
      Width = 9
      Height = 9
      Brush.Color = clRed
      Shape = stCircle
    end
    object Label7: TLabel
      Left = 38
      Top = 82
      Width = 94
      Height = 12
      Caption = 'WouldBlock Sign'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 9
      Top = 73
      Width = 188
      Height = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 1
    Top = 121
    Width = 208
    Height = 104
    Caption = '부활 GS'
    TabOrder = 1
    object Label4: TLabel
      Left = 15
      Top = 24
      Width = 65
      Height = 12
      Caption = 'Send Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 15
      Top = 40
      Width = 81
      Height = 12
      Caption = 'Receive Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 15
      Top = 56
      Width = 102
      Height = 12
      Caption = 'WouldBlock Count'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblRevivalSendB: TLabel
      Left = 144
      Top = 24
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblRevivalReceiveB: TLabel
      Left = 144
      Top = 40
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblRevivalWBC: TLabel
      Left = 144
      Top = 56
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object shpRevivalWBSign: TShape
      Left = 15
      Top = 82
      Width = 9
      Height = 9
      Brush.Color = clRed
      Shape = stCircle
    end
    object Label11: TLabel
      Left = 38
      Top = 82
      Width = 94
      Height = 12
      Caption = 'WouldBlock Sign'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel2: TBevel
      Left = 9
      Top = 73
      Width = 188
      Height = 2
    end
  end
  object GroupBox3: TGroupBox
    Left = 1
    Top = 233
    Width = 208
    Height = 104
    Caption = '생명 GS'
    TabOrder = 2
    object Label12: TLabel
      Left = 15
      Top = 24
      Width = 65
      Height = 12
      Caption = 'Send Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 15
      Top = 40
      Width = 81
      Height = 12
      Caption = 'Receive Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 15
      Top = 56
      Width = 102
      Height = 12
      Caption = 'WouldBlock Count'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblLifeSendB: TLabel
      Left = 144
      Top = 24
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblLifeReceiveB: TLabel
      Left = 144
      Top = 40
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblLifeWBC: TLabel
      Left = 144
      Top = 56
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object shpLifeWBSign: TShape
      Left = 15
      Top = 82
      Width = 9
      Height = 9
      Brush.Color = clRed
      Shape = stCircle
    end
    object Label18: TLabel
      Left = 38
      Top = 82
      Width = 94
      Height = 12
      Caption = 'WouldBlock Sign'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel3: TBevel
      Left = 9
      Top = 73
      Width = 188
      Height = 2
    end
  end
  object GroupBox4: TGroupBox
    Left = 217
    Top = 9
    Width = 208
    Height = 104
    Caption = '신화 GS'
    TabOrder = 3
    object Label19: TLabel
      Left = 15
      Top = 24
      Width = 65
      Height = 12
      Caption = 'Send Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label20: TLabel
      Left = 15
      Top = 40
      Width = 81
      Height = 12
      Caption = 'Receive Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label21: TLabel
      Left = 15
      Top = 56
      Width = 102
      Height = 12
      Caption = 'WouldBlock Count'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblMythSendB: TLabel
      Left = 144
      Top = 24
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblMythReceiveB: TLabel
      Left = 144
      Top = 40
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblMythWBC: TLabel
      Left = 144
      Top = 56
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object shpMythWBSign: TShape
      Left = 15
      Top = 82
      Width = 9
      Height = 9
      Brush.Color = clRed
      Shape = stCircle
    end
    object Label25: TLabel
      Left = 38
      Top = 82
      Width = 94
      Height = 12
      Caption = 'WouldBlock Sign'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel4: TBevel
      Left = 9
      Top = 73
      Width = 188
      Height = 2
    end
  end
  object GroupBox5: TGroupBox
    Left = 217
    Top = 233
    Width = 208
    Height = 104
    Caption = '천하 GS'
    TabOrder = 4
    object Label26: TLabel
      Left = 15
      Top = 24
      Width = 65
      Height = 12
      Caption = 'Send Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label27: TLabel
      Left = 15
      Top = 40
      Width = 81
      Height = 12
      Caption = 'Receive Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label28: TLabel
      Left = 15
      Top = 56
      Width = 102
      Height = 12
      Caption = 'WouldBlock Count'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblWorldSendB: TLabel
      Left = 144
      Top = 24
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblWorldReceiveB: TLabel
      Left = 144
      Top = 40
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblWorldWBC: TLabel
      Left = 144
      Top = 56
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object shpWorldWBSign: TShape
      Left = 15
      Top = 82
      Width = 9
      Height = 9
      Brush.Color = clRed
      Shape = stCircle
    end
    object Label32: TLabel
      Left = 38
      Top = 82
      Width = 94
      Height = 12
      Caption = 'WouldBlock Sign'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel5: TBevel
      Left = 9
      Top = 73
      Width = 188
      Height = 2
    end
  end
  object GroupBox6: TGroupBox
    Left = 217
    Top = 121
    Width = 208
    Height = 104
    Caption = '하늘 GS'
    TabOrder = 5
    object Label33: TLabel
      Left = 15
      Top = 24
      Width = 65
      Height = 12
      Caption = 'Send Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label34: TLabel
      Left = 15
      Top = 40
      Width = 81
      Height = 12
      Caption = 'Receive Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label35: TLabel
      Left = 15
      Top = 56
      Width = 102
      Height = 12
      Caption = 'WouldBlock Count'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblSkySendB: TLabel
      Left = 144
      Top = 24
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblSkyReceiveB: TLabel
      Left = 144
      Top = 40
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblSkyWBC: TLabel
      Left = 144
      Top = 56
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object shpSkyWBSign: TShape
      Left = 15
      Top = 82
      Width = 9
      Height = 9
      Brush.Color = clRed
      Shape = stCircle
    end
    object Label39: TLabel
      Left = 38
      Top = 82
      Width = 94
      Height = 12
      Caption = 'WouldBlock Sign'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel6: TBevel
      Left = 9
      Top = 73
      Width = 188
      Height = 2
    end
  end
  object GroupBox7: TGroupBox
    Left = 433
    Top = 121
    Width = 208
    Height = 104
    Caption = 'TEST(32) GS'
    TabOrder = 6
    object Label8: TLabel
      Left = 15
      Top = 24
      Width = 65
      Height = 12
      Caption = 'Send Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 15
      Top = 40
      Width = 81
      Height = 12
      Caption = 'Receive Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 15
      Top = 56
      Width = 102
      Height = 12
      Caption = 'WouldBlock Count'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblTestSendB: TLabel
      Left = 144
      Top = 24
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblTestReceiveB: TLabel
      Left = 144
      Top = 40
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblTestWBC: TLabel
      Left = 144
      Top = 56
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object shpTestWBSign: TShape
      Left = 15
      Top = 82
      Width = 9
      Height = 9
      Brush.Color = clRed
      Shape = stCircle
    end
    object Label22: TLabel
      Left = 38
      Top = 82
      Width = 94
      Height = 12
      Caption = 'WouldBlock Sign'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel7: TBevel
      Left = 9
      Top = 73
      Width = 188
      Height = 2
    end
  end
  object GroupBox8: TGroupBox
    Left = 433
    Top = 9
    Width = 208
    Height = 104
    Caption = '실험 GS'
    TabOrder = 7
    object Label15: TLabel
      Left = 15
      Top = 24
      Width = 65
      Height = 12
      Caption = 'Send Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label16: TLabel
      Left = 15
      Top = 40
      Width = 81
      Height = 12
      Caption = 'Receive Bytes'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 15
      Top = 56
      Width = 102
      Height = 12
      Caption = 'WouldBlock Count'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblExSendB: TLabel
      Left = 144
      Top = 24
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblExReceiveB: TLabel
      Left = 144
      Top = 40
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblExWBC: TLabel
      Left = 144
      Top = 56
      Width = 48
      Height = 12
      AutoSize = False
      Caption = '0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object shpExWBSign: TShape
      Left = 15
      Top = 82
      Width = 9
      Height = 9
      Brush.Color = clRed
      Shape = stCircle
    end
    object Label30: TLabel
      Left = 38
      Top = 82
      Width = 94
      Height = 12
      Caption = 'WouldBlock Sign'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel8: TBevel
      Left = 9
      Top = 73
      Width = 188
      Height = 2
    end
  end
end
