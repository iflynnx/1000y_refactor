object FrmChat: TFrmChat
  Left = 649
  Top = 332
  HorzScrollBar.Visible = False
  BorderStyle = bsNone
  ClientHeight = 158
  ClientWidth = 120
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button_world_choose: TA2Button
    Left = 8
    Top = 129
    Width = 65
    Height = 17
    AutoSize = False
    OnClick = Button_world_chooseClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object Button_scrip__choose: TA2Button
    Left = 8
    Top = 33
    Width = 65
    Height = 17
    AutoSize = False
    OnClick = Button_scrip__chooseClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object Button_procession_choose: TA2Button
    Left = 8
    Top = 57
    Width = 65
    Height = 17
    AutoSize = False
    OnClick = Button_procession_chooseClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object Button_present_choose: TA2Button
    Left = 0
    Top = 1
    Width = 65
    Height = 17
    AutoSize = False
    OnClick = Button_present_chooseClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object Button_Map_choose: TA2Button
    Left = 8
    Top = 105
    Width = 65
    Height = 17
    AutoSize = False
    Enabled = False
    OnClick = Button_Map_chooseClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object Button_guild_choose: TA2Button
    Left = 8
    Top = 81
    Width = 65
    Height = 17
    AutoSize = False
    OnClick = Button_guild_chooseClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Form: TA2Form
    Color = clBlack
    ShowMethod = FSM_NONE
    TransParent = True
    Left = 80
    Top = 40
  end
end
