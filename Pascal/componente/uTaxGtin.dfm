object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 181
  ClientWidth = 556
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 144
    Top = 93
    Width = 21
    Height = 15
    Caption = 'cest'
  end
  object Label2: TLabel
    Left = 32
    Top = 92
    Width = 24
    Height = 15
    Caption = 'ncm'
  end
  object Label3: TLabel
    Left = 32
    Top = 13
    Width = 21
    Height = 15
    Caption = 'gtin'
  end
  object Label4: TLabel
    Left = 0
    Top = 166
    Width = 556
    Height = 15
    Align = alBottom
    Alignment = taCenter
    Caption = 'site www.systax.com.br | http://www.buscacest.com.br'#39
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    StyleElements = [seBorder]
    ExplicitWidth = 293
  end
  object Button1: TButton
    Left = 134
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Consulta'
    TabOrder = 0
    OnClick = Button1Click
  end
  object gtin: TEdit
    Left = 32
    Top = 34
    Width = 96
    Height = 23
    TabOrder = 1
    Text = '7894900010015'
  end
  object ncm: TEdit
    Left = 32
    Top = 113
    Width = 106
    Height = 23
    TabOrder = 2
    Text = 'ncm'
  end
  object descricao: TEdit
    Left = 32
    Top = 63
    Width = 489
    Height = 23
    TabOrder = 3
    Text = 'descricao'
  end
  object cest: TEdit
    Left = 144
    Top = 114
    Width = 106
    Height = 23
    TabOrder = 4
    Text = 'cest'
  end
end
