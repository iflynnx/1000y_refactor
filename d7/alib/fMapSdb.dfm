object frmMapsdb: TfrmMapsdb
  Left = 294
  Top = 248
  Width = 166
  Height = 452
  Caption = 'frmMap.sdb'
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
  object ListBox1: TListBox
    Left = 0
    Top = 41
    Width = 158
    Height = 247
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
    OnDblClick = ListBox1DblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 158
    Height = 41
    Align = alTop
    TabOrder = 1
    object Button2: TButton
      Left = 80
      Top = 8
      Width = 75
      Height = 25
      Caption = #36733#20837#22320#22270
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 0
      Top = 8
      Width = 75
      Height = 25
      Caption = #35835#20837
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 288
    Width = 158
    Height = 137
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
end
