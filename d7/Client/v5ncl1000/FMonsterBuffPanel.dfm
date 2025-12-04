inherited frmMonsterBuffPanel: TfrmMonsterBuffPanel
  Left = 402
  Top = 349
  Caption = 'frmMonsterBuffPanel'
  PixelsPerInch = 96
  TextHeight = 13
  object StructedA2ILabel: TA2ILabel [8]
    Left = 160
    Top = 32
    Width = 4
    Height = 13
    AutoSize = False
    ADXForm = A2form
    DrawItemData = False
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 392
    Top = 144
  end
end
