object FormEditLine: TFormEditLine
  Left = 605
  Top = 207
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1060#1080#1075#1091#1088#1099
  ClientHeight = 204
  ClientWidth = 346
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
    Width = 166
    Height = 24
    Caption = #1060#1080#1075#1091#1088#1072' "'#1051#1080#1085#1080#1103'"'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 96
    Width = 63
    Height = 13
    Caption = #1053#1072#1095#1072#1083#1086' X Y :'
  end
  object Label3: TLabel
    Left = 24
    Top = 120
    Width = 57
    Height = 13
    Caption = #1050#1086#1085#1077#1094' X Y :'
  end
  object Label5: TLabel
    Left = 24
    Top = 48
    Width = 56
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' :'
  end
  object edXYh: TEdit
    Left = 88
    Top = 96
    Width = 129
    Height = 21
    MaxLength = 20
    TabOrder = 1
    Text = 'edXYh'
  end
  object edXYe: TEdit
    Left = 88
    Top = 120
    Width = 129
    Height = 21
    MaxLength = 20
    TabOrder = 2
    Text = 'edXYe'
  end
  object brnOk: TBitBtn
    Left = 128
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 3
    OnClick = brnOkClick
  end
  object btnCansel: TBitBtn
    Left = 248
    Top = 160
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object edName: TEdit
    Left = 88
    Top = 48
    Width = 233
    Height = 21
    MaxLength = 40
    TabOrder = 0
    Text = 'edName'
  end
end
