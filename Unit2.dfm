object frmID: TfrmID
  Left = 192
  Top = 107
  Width = 467
  Height = 387
  BorderIcons = [biSystemMenu]
  Caption = #1048#1075#1088#1086#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object igroki: TStringGrid
    Left = 8
    Top = 8
    Width = 441
    Height = 265
    ColCount = 4
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goTabs, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 0
    OnDblClick = startClick
    OnKeyPress = igrokiKeyPress
    OnSelectCell = igrokiSelectCell
    ColWidths = (
      158
      90
      83
      85)
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 275
    Width = 137
    Height = 81
    Caption = #1048#1075#1088#1086#1082#1080
    TabOrder = 1
    object add: TSpeedButton
      Left = 16
      Top = 16
      Width = 105
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1080#1075#1088#1086#1082#1072
      OnClick = addClick
    end
    object del: TSpeedButton
      Left = 16
      Top = 48
      Width = 105
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1080#1075#1088#1086#1082#1072
      OnClick = delClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 320
    Top = 275
    Width = 129
    Height = 81
    Caption = #1048#1075#1088#1072
    TabOrder = 2
    object start: TSpeedButton
      Left = 16
      Top = 16
      Width = 97
      Height = 25
      Caption = #1053#1072#1095#1072#1090#1100' '#1080#1075#1088#1091
      OnClick = startClick
    end
    object exit: TSpeedButton
      Left = 16
      Top = 48
      Width = 97
      Height = 25
      Caption = #1042#1099#1093#1086#1076' '#1080#1079' '#1080#1075#1088#1099
      OnClick = exitClick
    end
  end
  object cards: TRadioGroup
    Left = 160
    Top = 275
    Width = 145
    Height = 81
    Caption = #1050#1086#1083#1086#1076#1072' '#1080#1075#1088#1086#1082#1072
    ItemIndex = 0
    Items.Strings = (
      #1057#1090#1072#1085#1076#1072#1090#1085#1072#1103' '#1082#1086#1083#1086#1076#1072
      #1069#1088#1086#1090#1080#1095#1077#1089#1082#1072#1103' '#1082#1086#1083#1086#1076#1072)
    TabOrder = 3
    OnClick = cardsClick
  end
end
