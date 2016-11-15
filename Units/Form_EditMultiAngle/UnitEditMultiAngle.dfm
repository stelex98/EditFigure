object FormEditMultiAngle: TFormEditMultiAngle
  Left = 605
  Top = 207
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1060#1080#1075#1091#1088#1099
  ClientHeight = 360
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 258
    Height = 24
    Caption = #1060#1080#1075#1091#1088#1072' "'#1052#1085#1086#1075#1086#1091#1075#1086#1083#1100#1085#1080#1082'"'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 88
    Width = 108
    Height = 26
    Caption = #1050#1086#1088#1076#1080#1085#1072#1090#1099' '#1074#1077#1088#1096#1080#1085#13#10'('#1087#1086' '#1095#1072#1089' '#1089#1090#1088#1077#1083#1082#1077') X Y :'
  end
  object Label5: TLabel
    Left = 16
    Top = 48
    Width = 56
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' :'
  end
  object brnOk: TBitBtn
    Left = 32
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
    OnClick = brnOkClick
  end
  object btnCansel: TBitBtn
    Left = 208
    Top = 320
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object edName: TEdit
    Left = 80
    Top = 48
    Width = 209
    Height = 21
    MaxLength = 40
    TabOrder = 0
    Text = 'edName'
  end
  object memXY: TMemo
    Left = 136
    Top = 88
    Width = 105
    Height = 201
    Lines.Strings = (
      'memXY')
    TabOrder = 3
  end
end
