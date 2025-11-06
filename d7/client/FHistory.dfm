object frmHistory: TfrmHistory
  Left = 181
  Top = 148
  BorderStyle = bsNone
  Caption = 'frmHistory'
  ClientHeight = 361
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  PixelsPerInch = 96
  TextHeight = 13
  object lblTop: TA2ILabel
    Left = 0
    Top = 0
    Width = 460
    Height = 20
    AutoSize = False
    Color = clPurple
    ParentColor = False
    ADXForm = A2Form
  end
  object lblBottom: TA2ILabel
    Left = 0
    Top = 340
    Width = 460
    Height = 23
    AutoSize = False
    Color = clPurple
    ParentColor = False
    ADXForm = A2Form
  end
  object lblLeft: TA2ILabel
    Left = 0
    Top = 20
    Width = 16
    Height = 320
    AutoSize = False
    Color = clPurple
    ParentColor = False
    ADXForm = A2Form
  end
  object lblRight: TA2ILabel
    Left = 444
    Top = 20
    Width = 16
    Height = 320
    AutoSize = False
    Color = clPurple
    ParentColor = False
    ADXForm = A2Form
  end
  object listHistory: TA2ListBox
    Left = 16
    Top = 20
    Width = 436
    Height = 320
    ADXForm = A2Form
    FontColor = 32767
    FontSelColor = 255
    ItemHeight = 16
    ItemMerginX = 0
    ItemMerginY = 0
    FontEmphasis = False
    ScrollBarView = True
    OnMouseDown = listHistoryMouseDown
    OnAdxDrawItem = listHistoryAdxDrawItem
  end
  object A2Form: TA2Form
    Color = clBlack
    ShowMethod = FSM_NONE
    TransParent = False
    Left = 8
    Top = 8
  end
end
