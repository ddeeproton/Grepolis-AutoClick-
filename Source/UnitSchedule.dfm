object FormSchedule: TFormSchedule
  Left = 186
  Top = 320
  Width = 438
  Height = 253
  Caption = 'FormSchedule'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    430
    219)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 368
    Top = 144
    Width = 6
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'h'
  end
  object ButtonClose: TButton
    Left = 328
    Top = 184
    Width = 89
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Fermer'
    TabOrder = 0
    OnClick = ButtonCloseClick
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 313
    Height = 201
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
  end
  object ButtonAjouter: TButton
    Left = 328
    Top = 8
    Width = 91
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Ajouter'
    TabOrder = 2
    OnClick = ButtonAjouterClick
  end
  object ButtonSupprimer: TButton
    Left = 328
    Top = 40
    Width = 91
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Supprimer'
    TabOrder = 3
  end
  object ButtonMonter: TButton
    Left = 328
    Top = 72
    Width = 91
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Monter'
    TabOrder = 4
  end
  object ButtonDescendre: TButton
    Left = 328
    Top = 104
    Width = 91
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Descendre'
    TabOrder = 5
  end
  object SpinEditHeure: TSpinEdit
    Left = 328
    Top = 136
    Width = 41
    Height = 22
    Anchors = [akTop, akRight]
    MaxValue = 0
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
  object SpinEdit2: TSpinEdit
    Left = 376
    Top = 136
    Width = 41
    Height = 22
    Anchors = [akTop, akRight]
    MaxValue = 0
    MinValue = 0
    TabOrder = 7
    Value = 0
  end
  object CheckBoxStopTimer: TCheckBox
    Left = 328
    Top = 160
    Width = 97
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Stop Timer'
    TabOrder = 8
  end
  object OpenDialog1: TOpenDialog
    Left = 288
    Top = 16
  end
end
