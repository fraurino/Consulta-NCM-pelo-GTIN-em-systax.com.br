object frmconsulta: Tfrmconsulta
  Left = 0
  Top = 0
  Cursor = crHandPoint
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmconsulta'
  ClientHeight = 490
  ClientWidth = 829
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    829
    490)
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 111
    Width = 21
    Height = 15
    Caption = 'cest'
  end
  object Label2: TLabel
    Left = 8
    Top = 58
    Width = 24
    Height = 15
    Caption = 'ncm'
  end
  object Label4: TLabel
    Left = 0
    Top = 475
    Width = 829
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
    ExplicitTop = 142
    ExplicitWidth = 293
  end
  object imgproduto: TImage
    Left = 692
    Top = 8
    Width = 129
    Height = 147
    Center = True
    Proportional = True
  end
  object Label5: TLabel
    Left = 120
    Top = 58
    Width = 14
    Height = 15
    Caption = 'UF'
  end
  object Button1: TButton
    Left = 224
    Top = 130
    Width = 337
    Height = 25
    Caption = 'Consulta c'#243'digo de barras'
    TabOrder = 0
    OnClick = Button1Click
  end
  object gtin: TEdit
    Left = 8
    Top = 1
    Width = 106
    Height = 23
    TabOrder = 1
    Text = '7506195196489'
    TextHint = 'c'#243'digo ean/gtin'
  end
  object ncm: TEdit
    Left = 8
    Top = 79
    Width = 106
    Height = 23
    TabOrder = 2
    TextHint = 'c'#243'digo ncm'
  end
  object descricao: TEdit
    Left = 8
    Top = 30
    Width = 553
    Height = 23
    CharCase = ecUpperCase
    TabOrder = 3
    TextHint = 'descricao do produto'
  end
  object cest: TEdit
    Left = 8
    Top = 132
    Width = 106
    Height = 23
    TabOrder = 4
    TextHint = 'c'#243'digo cest'
  end
  object Memo1: TMemo
    Left = 135
    Top = 192
    Width = 686
    Height = 277
    Anchors = [akLeft, akTop, akRight, akBottom]
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 5
    WordWrap = False
    ExplicitWidth = 579
  end
  object Memo2: TMemo
    Left = 8
    Top = 192
    Width = 121
    Height = 277
    Anchors = [akLeft, akTop, akBottom]
    Lines.Strings = (
      '7891000325858'
      '7896256603699'
      '7896051130116'
      '7891000100103'
      '7898215152002')
    ScrollBars = ssVertical
    TabOrder = 6
    ExplicitHeight = 323
  end
  object Button3: TButton
    Left = 8
    Top = 161
    Width = 813
    Height = 25
    Caption = 'Consulta Lote'
    TabOrder = 7
    OnClick = Button3Click
  end
  object consultaimagem: TCheckBox
    Left = 573
    Top = 8
    Width = 113
    Height = 17
    Cursor = crHandPoint
    BiDiMode = bdRightToLeft
    Caption = 'Baixar imagem'
    Checked = True
    ParentBiDiMode = False
    State = cbChecked
    TabOrder = 8
  end
  object ComboBoxUF: TComboBox
    Left = 120
    Top = 79
    Width = 49
    Height = 23
    Cursor = crHandPoint
    Style = csDropDownList
    TabOrder = 9
    TextHint = 'UF'
  end
  object consultaibpt: TCheckBox
    Left = 589
    Top = 31
    Width = 97
    Height = 17
    Cursor = crHandPoint
    BiDiMode = bdRightToLeft
    Caption = 'Consulta IBPT'
    Checked = True
    ParentBiDiMode = False
    State = cbChecked
    TabOrder = 10
  end
  object nacionalfederal: TEdit
    Left = 175
    Top = 79
    Width = 60
    Height = 23
    TabStop = False
    Color = clInfoBk
    TabOrder = 11
  end
  object importadosfederal: TEdit
    Left = 241
    Top = 79
    Width = 60
    Height = 23
    TabStop = False
    Color = clInfoBk
    TabOrder = 12
  end
  object estadual: TEdit
    Left = 307
    Top = 79
    Width = 60
    Height = 23
    TabStop = False
    Color = clInfoBk
    TabOrder = 13
  end
  object municipal: TEdit
    Left = 373
    Top = 79
    Width = 60
    Height = 23
    TabStop = False
    Color = clInfoBk
    TabOrder = 14
  end
  object versao: TEdit
    Left = 567
    Top = 79
    Width = 60
    Height = 23
    TabStop = False
    Color = clInfoBk
    TabOrder = 16
  end
  object vigenciafim: TDateTimePicker
    Left = 439
    Top = 79
    Width = 122
    Height = 23
    Cursor = crHandPoint
    Date = 45800.000000000000000000
    Time = 0.022172418983245730
    Color = clInfoBk
    TabOrder = 15
  end
end
