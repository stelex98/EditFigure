object FormMain: TFormMain
  Left = 343
  Top = 143
  Width = 1038
  Height = 734
  Caption = '2D '#1060#1080#1075#1091#1088#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    1022
    695)
  PixelsPerInch = 96
  TextHeight = 13
  object imgWin: TImage
    Left = 312
    Top = 8
    Width = 705
    Height = 681
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object btnPoint: TSpeedButton
    Tag = 101
    Left = 8
    Top = 8
    Width = 24
    Height = 24
    Hint = #1057#1086#1079#1076#1072#1090#1100' '#1058#1086#1095#1082#1091
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333300003333333333333333333300003333333333333333333300003333
      3333333333333333000033333333333333333333000033333333333333333333
      0000333333333333333333330000333333333333333333330000333333333003
      3333333300003333333300003333333300003333333300003333333300003333
      3333300333333333000033333333333333333333000033333333333333333333
      0000333333333333333333330000333333333333333333330000333333333333
      3333333300003333333333333333333300003333333333333333333300003333
      33333333333333330000}
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonClickHandler
  end
  object btnLine: TSpeedButton
    Tag = 102
    Left = 40
    Top = 8
    Width = 24
    Height = 24
    Hint = #1057#1086#1079#1076#1072#1090#1100' '#1051#1080#1085#1080#1102
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333300003333333333333333300300003333333333333333003300003333
      3333333333300333000033333333333333003333000033333333333330033333
      0000333333333333003333330000333333333330033333330000333333333300
      3333333300003333333330033333333300003333333300333333333300003333
      3330033333333333000033333300333333333333000033333003333333333333
      0000333300333333333333330000333003333333333333330000330033333333
      3333333300003003333333333333333300003033333333333333333300003333
      33333333333333330000}
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonClickHandler
  end
  object btnSquare: TSpeedButton
    Tag = 105
    Left = 72
    Top = 8
    Width = 24
    Height = 24
    Hint = #1057#1086#1079#1076#1072#1090#1100' '#1050#1074#1072#1076#1088#1072#1090
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000000000000000000000000
      BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333300003000000000000000000300003033333333333333330300003033
      3333333333333303000030333333333333333303000030333333333333333303
      0000303333333333333333030000303333333333333333030000303333333333
      3333330300003033333333333333330300003033333333333333330300003033
      3333333333333303000030333333333333333303000030333333333333333303
      0000303333333333333333030000303333333333333333030000303333333333
      3333330300003033333333333333330300003000000000000000000300003333
      33333333333333330000}
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonClickHandler
  end
  object btnMulty: TSpeedButton
    Tag = 106
    Left = 104
    Top = 8
    Width = 24
    Height = 24
    Hint = #1057#1086#1079#1076#1072#1090#1100' '#1052#1085#1086#1075#1086#1091#1075#1086#1083#1100#1085#1080#1082
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333300003033333333333333333000003300333333333333300300003303
      0033333333300303000033303303333333033033000033303330033300333033
      0000333303333030333303330000333303333303333303330000333330333333
      3330333300003333303333333330333300003333033333333333033300003300
      3333333333333003000030000003333333000000000033333330333330333333
      0000333333330333033333330000333333330333033333330000333333333030
      3333333300003333333330303333333300003333333333033333333300003333
      33333333333333330000}
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonClickHandler
  end
  object btnCircle: TSpeedButton
    Tag = 108
    Left = 136
    Top = 8
    Width = 24
    Height = 24
    Hint = #1057#1086#1079#1076#1072#1090#1100' '#1050#1088#1091#1075
    Glyph.Data = {
      4E010000424D4E01000000000000760000002800000012000000120000000100
      040000000000D800000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
      3333330000003333003333330033330000003330333333333303330000003303
      3333333333303300000030333333333333330300000030333333333333330300
      0000033333333333333330000000033333333333333330000000033333333333
      3333300000000333333333333333300000000333333333333333300000000333
      3333333333333000000030333333333333330300000030333333333333330300
      0000330333333333333033000000333033333333330333000000333300333333
      003333000000333333000000333333000000}
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonClickHandler
  end
  object btnEdit: TSpeedButton
    Tag = 201
    Left = 192
    Top = 8
    Width = 24
    Height = 24
    Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1092#1080#1075#1091#1088#1091
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333300003000000000000000000300003033333333333333330300003033
      3333333333333303000030330000000000003303000030330333333333303303
      0000303303333333333033030000303303333333333033030000303303333333
      3330330300003033033333333330330300003033033333333330330300003033
      0333333333303303000030330333333333303303000030330333333333303303
      0000303303333333333033030000303300000000000033030000303333333333
      3333330300003033333333333333330300003000000000000000000300003333
      33333333333333330000}
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonClickHandler
  end
  object bntDel: TSpeedButton
    Tag = 301
    Left = 224
    Top = 8
    Width = 24
    Height = 24
    Hint = #1059#1076#1072#1083#1080#1090#1100' '#1092#1080#1075#1091#1088#1091
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333300003333333333333333333300003333333333333333333300003311
      1133333333111133000033111113333331111133000033111111333311111133
      0000333111111331111113330000333311111111111133330000333331111111
      1113333300003333331111111133333300003333333111111333333300003333
      3311111111333333000033333111111111133333000033331111111111113333
      0000333111111331111113330000331111113333111111330000331111133333
      3111111300003311113333333311111300003333333333333331111300003333
      33333333333333330000}
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonClickHandler
  end
  object btnTransf: TSpeedButton
    Tag = 401
    Left = 272
    Top = 8
    Width = 24
    Height = 24
    Hint = #1058#1088#1072#1085#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1092#1080#1075#1091#1088#1091
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333300003000000333333333333300003033330333333333333300003033
      3303333303333333000030333303333000333333000030333303330030033333
      0000300000033003330033330000333333330033333003330000333333300333
      3333003300003333330033333333300300003333300333333333330000003333
      0033333333333003000033300333333333330033000033330033333333300333
      0000333330033333330033330000333333003333300333330000333333300333
      0033333300003333333300300333333300003333333330003333333300003333
      33333303333333330000}
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonClickHandler
  end
  object lvFigures: TListView
    Left = 8
    Top = 40
    Width = 289
    Height = 529
    Anchors = [akLeft, akTop, akBottom]
    Columns = <
      item
        AutoSize = True
        Caption = #1060#1080#1075#1091#1088#1099
      end>
    GridLines = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = lvFiguresDblClick
    OnSelectItem = lvFiguresSelectItem
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 576
    Width = 289
    Height = 89
    Anchors = [akLeft, akBottom]
    Caption = ' '#1061#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1080' '#1092#1080#1075#1091#1088#1099' '
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 53
      Height = 13
      Caption = #1055#1083#1086#1097#1072#1076#1100' :'
    end
    object Label2: TLabel
      Left = 20
      Top = 40
      Width = 57
      Height = 13
      Caption = #1055#1077#1088#1080#1084#1077#1090#1088' :'
    end
    object Label3: TLabel
      Left = 40
      Top = 56
      Width = 37
      Height = 13
      Caption = #1062#1077#1085#1090#1088' :'
    end
    object lblPloschad: TLabel
      Left = 88
      Top = 24
      Width = 66
      Height = 13
      Caption = 'lblPloschad'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPerimetr: TLabel
      Left = 88
      Top = 40
      Width = 60
      Height = 13
      Caption = 'lblPerimetr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCentr: TLabel
      Left = 88
      Top = 56
      Width = 44
      Height = 13
      Caption = 'lblCentr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object cbPaintTriangles: TCheckBox
    Left = 8
    Top = 672
    Width = 289
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1054#1090#1088#1080#1089#1086#1074#1082#1072' '#1090#1088#1080#1072#1085#1075#1091#1083#1103#1094#1080#1080' ('#1054#1090#1083#1072#1076#1082#1072')'
    TabOrder = 2
    OnClick = cbPaintTrianglesClick
  end
end