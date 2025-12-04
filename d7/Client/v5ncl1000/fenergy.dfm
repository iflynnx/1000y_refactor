object FrmEnergy: TFrmEnergy
  Left = 666
  Top = 348
  BorderStyle = bsNone
  Caption = 'jj'
  ClientHeight = 129
  ClientWidth = 116
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object A2ILabel1: TA2ILabel
    Left = 0
    Top = 0
    Width = 100
    Height = 49
    AutoSize = False
    Transparent = False
    OnMouseDown = A2ILabel1MouseDown
    OnMouseMove = A2ILabel1MouseMove
    ADXForm = A2Form
  end
  object A2Form: TA2Form
    Color = clBlack
    ShowMethod = FSM_NONE
    TransParent = True
    Left = 8
    Top = 16
  end
end
