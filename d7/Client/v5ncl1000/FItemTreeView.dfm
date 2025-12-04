object frmItemTreeView: TfrmItemTreeView
  Left = 248
  Top = 166
  BorderStyle = bsNone
  Caption = 'frmItemTreeView'
  ClientHeight = 299
  ClientWidth = 290
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 24
    Height = 13
    Caption = #24403#21069
  end
  object TreeView1: TTreeView
    Left = 8
    Top = 40
    Width = 273
    Height = 257
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Ctl3D = False
    Indent = 19
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
    OnDblClick = TreeView1DblClick
  end
  object Edit1: TEdit
    Left = 40
    Top = 8
    Width = 81
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 128
    Top = 8
    Width = 65
    Height = 25
    Caption = #25628#32034
    TabOrder = 2
  end
  object Button2: TButton
    Left = 200
    Top = 8
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 3
  end
end
