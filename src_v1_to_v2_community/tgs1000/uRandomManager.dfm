object FrmRandomManager: TFrmRandomManager
  Left = 152
  Top = 136
  Width = 624
  Height = 480
  Caption = #22312#32447#29190#29575#31649#29702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 608
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 80
      Height = 13
      AutoSize = False
      Caption = #36947#20855#21517#31216
    end
    object Label2: TLabel
      Left = 96
      Top = 8
      Width = 80
      Height = 13
      AutoSize = False
      Caption = #23487#20027#21517#31216
    end
    object lblitemname: TLabel
      Left = 8
      Top = 40
      Width = 80
      Height = 13
      AutoSize = False
      Caption = #36947#20855#21517#31216
    end
    object lblobjname: TLabel
      Left = 96
      Top = 40
      Width = 80
      Height = 13
      AutoSize = False
      Caption = #23487#20027#21517#31216
    end
    object Label4: TLabel
      Left = 184
      Top = 8
      Width = 80
      Height = 13
      AutoSize = False
      Caption = #24403#21069#20540
    end
    object Label5: TLabel
      Left = 272
      Top = 8
      Width = 80
      Height = 13
      AutoSize = False
      Caption = #29190#20986#20540
    end
    object lbl1: TLabel
      Left = 360
      Top = 8
      Width = 80
      Height = 13
      AutoSize = False
      Caption = #35774#23450#20540
    end
    object lblres: TLabel
      Left = 432
      Top = 8
      Width = 80
      Height = 13
      AutoSize = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object sedqz: TSpinEdit
      Left = 186
      Top = 33
      Width = 60
      Height = 24
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      MaxValue = 0
      MinValue = 0
      ParentFont = False
      TabOrder = 0
      Value = 0
    end
    object sebcz: TSpinEdit
      Left = 274
      Top = 33
      Width = 60
      Height = 24
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      MaxValue = 0
      MinValue = 0
      ParentFont = False
      TabOrder = 1
      Value = 0
    end
    object sesdz: TSpinEdit
      Left = 362
      Top = 33
      Width = 60
      Height = 24
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      MaxValue = 0
      MinValue = 0
      ParentFont = False
      TabOrder = 2
      Value = 0
    end
    object btnXg: TButton
      Left = 432
      Top = 33
      Width = 75
      Height = 24
      Caption = #20462#25913
      TabOrder = 3
      OnClick = btnXgClick
    end
    object btnSx: TButton
      Left = 520
      Top = 33
      Width = 75
      Height = 24
      Caption = #21047#26032
      TabOrder = 4
      OnClick = btnSxClick
    end
  end
  object sgUsers: TStringGrid
    Left = 0
    Top = 65
    Width = 608
    Height = 377
    Align = alClient
    ColCount = 6
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
      113)
  end
end
