object frmfb: Tfrmfb
  Left = 598
  Top = 341
  Width = 339
  Height = 200
  Caption = #27426#36814#36827#20837#28216#25103#30340#19990#30028
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 0
    Top = 0
    Width = 323
    Height = 113
    Align = alTop
    Caption = #20998#36776#29575#36873#25321
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 1
    Items.Strings = (
      '800*600  '#20998#36776#29575#23567#31383#21475
      '1024*768 '#20998#36776#29575#22823#31383#21475)
    ParentFont = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 216
    Top = 128
    Width = 89
    Height = 25
    Caption = #36827#20837#28216#25103
    TabOrder = 1
    OnClick = Button1Click
  end
end
