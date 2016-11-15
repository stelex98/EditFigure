object FormEditPoint: TFormEditPoint
  Left = 605
  Top = 207
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1060#1080#1075#1091#1088#1099
  ClientHeight = 189
  ClientWidth = 325
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
    Width = 163
    Height = 24
    Caption = #1060#1080#1075#1091#1088#1072' "'#1058#1086#1095#1082#1072'"'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 40
    Top = 104
    Width = 88
    Height = 13
    Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1099' X Y :'
  end
  object Label5: TLabel
    Left = 16
    Top = 48
    Width = 56
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' :'
  end
  object edX: TEdit
    Left = 144
    Top = 104
    Width = 145
    Height = 21
    MaxLength = 20
    TabOrder = 1
    Text = 'edX'
  end
  object brnOk: TBitBtn
    Left = 104
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 2
    OnClick = brnOkClick
  end
  object btnCansel: TBitBtn
    Left = 216
    Top = 144
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
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
end
