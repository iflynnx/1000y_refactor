object Form1: TForm1
  Left = 203
  Top = 113
  Width = 394
  Height = 495
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #26032#23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 386
    Height = 461
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #26032#25991#20214
      object Label1: TLabel
        Left = 8
        Top = 64
        Width = 56
        Height = 13
        Caption = #24403#21069#25991#20214
      end
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 49
        Height = 13
        Caption = 'PGK'#25991#20214
      end
      object Image1: TImage
        Left = 201
        Top = 287
        Width = 177
        Height = 153
        Stretch = True
      end
      object ListBox1: TListBox
        Left = 8
        Top = 63
        Width = 193
        Height = 377
        ItemHeight = 13
        TabOrder = 0
        OnClick = ListBox1Click
      end
      object Edit1: TEdit
        Left = 64
        Top = 8
        Width = 313
        Height = 21
        TabOrder = 1
      end
      object PanelpGK: TPanel
        Left = 201
        Top = 96
        Width = 177
        Height = 201
        BevelOuter = bvNone
        ParentBackground = True
        ParentColor = True
        TabOrder = 2
        Visible = False
        object ButtonADD: TButton
          Left = 6
          Top = 0
          Width = 75
          Height = 25
          Caption = #22686#21152#25991#20214
          TabOrder = 0
          OnClick = ButtonADDClick
        end
        object ButtonSAVE: TButton
          Left = 86
          Top = 0
          Width = 75
          Height = 25
          Caption = #20445#23384
          TabOrder = 1
          OnClick = ButtonSAVEClick
        end
        object ButtonCLOSE: TButton
          Left = 96
          Top = 168
          Width = 75
          Height = 25
          Caption = #20851#38381'PGK'
          TabOrder = 2
          OnClick = ButtonCLOSEClick
        end
        object ButtonDEL: TButton
          Left = 6
          Top = 32
          Width = 75
          Height = 25
          Caption = #21024#38500#25991#20214
          TabOrder = 3
          OnClick = ButtonDELClick
        end
        object Button3: TButton
          Left = 88
          Top = 32
          Width = 75
          Height = 25
          Caption = 'Button3'
          TabOrder = 4
          OnClick = Button3Click
        end
      end
      object PanelCREATE: TPanel
        Left = 201
        Top = 32
        Width = 177
        Height = 41
        BevelOuter = bvNone
        TabOrder = 3
        object ButtonLOAD: TButton
          Left = 6
          Top = 8
          Width = 75
          Height = 24
          Caption = #36733#20837'/'#21019#24314
          TabOrder = 0
          OnClick = ButtonLOADClick
        end
        object CheckBox_hebing: TCheckBox
          Left = 88
          Top = 16
          Width = 97
          Height = 17
          Caption = #21512#24182#27169#24335
          TabOrder = 1
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #21512#24182
      ImageIndex = 1
      object ListBoxPGK: TListBox
        Left = 0
        Top = 268
        Width = 177
        Height = 168
        ItemHeight = 13
        TabOrder = 0
        Visible = False
      end
      object ListBoxPPP: TListBox
        Left = 192
        Top = 268
        Width = 177
        Height = 167
        ItemHeight = 13
        TabOrder = 1
        Visible = False
      end
      object ButtonPPP: TButton
        Left = 296
        Top = 240
        Width = 75
        Height = 25
        Caption = #36733#20837'PPP'
        Enabled = False
        TabOrder = 2
        Visible = False
        OnClick = ButtonPPPClick
      end
      object Memoppp: TMemo
        Left = 192
        Top = 184
        Width = 177
        Height = 52
        Color = clMenuBar
        Ctl3D = False
        Enabled = False
        Lines.Strings = (
          'Memo1')
        ParentCtl3D = False
        TabOrder = 3
        Visible = False
      end
      object Panel1: TPanel
        Left = 0
        Top = 8
        Width = 377
        Height = 161
        BevelOuter = bvLowered
        TabOrder = 4
        Visible = False
        object ButtonPgkUnite: TButton
          Left = 104
          Top = 96
          Width = 75
          Height = 25
          Caption = #21512#24182
          Enabled = False
          TabOrder = 0
          Visible = False
          OnClick = ButtonPgkUniteClick
        end
        object ButtonPgkUniteclose: TButton
          Left = 104
          Top = 128
          Width = 75
          Height = 25
          Caption = #20851#38381'PGK'
          Enabled = False
          TabOrder = 1
          Visible = False
          OnClick = ButtonPgkUnitecloseClick
        end
        object ButtonPgkUniteCREATE: TButton
          Left = 8
          Top = 96
          Width = 75
          Height = 25
          Caption = #21019#24314'PGK'
          TabOrder = 2
          Visible = False
          OnClick = ButtonPgkUniteCREATEClick
        end
        object MemoPgkUnite: TMemo
          Left = 8
          Top = 8
          Width = 177
          Height = 81
          Color = clMenuBar
          Ctl3D = False
          Enabled = False
          Lines.Strings = (
            'Memo1')
          ParentCtl3D = False
          TabOrder = 3
          Visible = False
        end
        object ListBoxUnite: TListBox
          Left = 190
          Top = 8
          Width = 177
          Height = 145
          ItemHeight = 13
          TabOrder = 4
          Visible = False
        end
      end
      object MemoPGK: TMemo
        Left = 0
        Top = 184
        Width = 177
        Height = 53
        Color = clMenuBar
        Ctl3D = False
        Enabled = False
        Lines.Strings = (
          'Memo1')
        ParentCtl3D = False
        TabOrder = 5
        Visible = False
      end
      object ButtonPGK: TButton
        Left = 103
        Top = 240
        Width = 75
        Height = 25
        Caption = #36733#20837'PGK'
        Enabled = False
        TabOrder = 6
        Visible = False
        OnClick = ButtonPGKClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = #20998#35299#25991#20214
      ImageIndex = 2
      object Button1: TButton
        Left = 232
        Top = 24
        Width = 75
        Height = 25
        Caption = 'obj'#20998#35299
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 232
        Top = 56
        Width = 75
        Height = 25
        Caption = 'TILE'#20998#35299
        TabOrder = 1
        OnClick = Button2Click
      end
      object ListBox2: TListBox
        Left = 8
        Top = 63
        Width = 193
        Height = 377
        ItemHeight = 13
        TabOrder = 2
        OnClick = ListBox1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 280
    Top = 360
  end
end
