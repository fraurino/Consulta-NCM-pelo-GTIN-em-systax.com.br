object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 168
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Button1: TButton
    Left = 56
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Consulta'
    TabOrder = 0
    OnClick = Button1Click
  end
  object gtin: TEdit
    Left = 137
    Top = 57
    Width = 96
    Height = 23
    TabOrder = 1
    Text = '7894900010015'
  end
  object ncm: TEdit
    Left = 239
    Top = 57
    Width = 106
    Height = 23
    TabOrder = 2
    Text = 'ncm'
  end
  object descricao: TEdit
    Left = 56
    Top = 87
    Width = 489
    Height = 23
    TabOrder = 3
    Text = 'descricao'
  end
end
