object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 157
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    528
    157)
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
    Top = 142
    Width = 528
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
  object Memo1: TMemo
    Left = 159
    Top = 192
    Width = 356
    Height = 0
    Anchors = [akLeft, akTop, akRight, akBottom]
    CharCase = ecUpperCase
    ScrollBars = ssVertical
    TabOrder = 5
    WordWrap = False
  end
  object Memo2: TMemo
    Left = 32
    Top = 192
    Width = 121
    Height = 0
    Anchors = [akLeft, akTop, akBottom]
    Lines.Strings = (
      '590123412'
      '3457  '
      '400638133'
      '3931  '
      '471951200'
      '2880  '
      '690123456'
      '7894  '
      '890123456'
      '7893  '
      '360002914'
      '57  '
      '978020137'
      '9624  '
      '501234567'
      '8900  '
      '880123456'
      '7892  '
      '930123456'
      '7899  '
      '750103131'
      '1309  '
      '841003196'
      '0100  '
      '560123456'
      '7894  '
      '690314802'
      '6585  '
      '761303530'
      '9735  '
      '471305116'
      '7452  '
      '300123456'
      '7890  '
      '541118811'
      '5117  '
      '869123456'
      '7891  '
      '761040006'
      '3229  '
      '843700823'
      '4153  '
      '735135371'
      '4568  '
      '570123456'
      '7890  '
      '999123456'
      '7890  '
      '709123456'
      '7891  '
      '850123456'
      '7890  '
      '612345678'
      '9012  '
      '409123456'
      '7892  '
      '789123456'
      '7895  '
      '599123456'
      '7896  '
      '779123456'
      '7898  '
      '869743465'
      '2724  '
      '930060157'
      '2063  '
      '950110153'
      '0003  '
      '476123456'
      '7892  '
      '544900013'
      '1805  '
      '871256123'
      '1004  '
      '501023402'
      '5346  '
      '899123456'
      '7895  '
      '789894012'
      '3456  '
      '764015284'
      '0123  '
      '100123456'
      '7890  '
      '870123456'
      '7893  '
      '888888888'
      '8881  '
      '789123654'
      '9870  '
      '590999009'
      '1921  '
      '500011254'
      '6422  '
      '933123456'
      '7890  '
      '501123456'
      '7893  '
      '770123456'
      '7892  '
      '789642314'
      '5678  '
      '803252400'
      '1498  '
      '786341256'
      '9874  '
      '785412369'
      '8741  '
      '741258963'
      '1470  '
      '789732456'
      '8100  '
      '871256123'
      '1004  '
      '503123456'
      '7891  '
      '789345678'
      '1235  '
      '502765400'
      '0882  '
      '880112345'
      '6789  '
      '600123456'
      '7890  '
      '400098765'
      '4321  '
      '789102345'
      '6785  '
      '843332400'
      '9876  '
      '471210810'
      '3452  '
      '482002345'
      '6789  '
      '402123456'
      '7895  '
      '603423455'
      '6782  '
      '452345678'
      '9012  '
      '789789789'
      '7896  '
      '843900123'
      '6782  '
      '978123456'
      '7897  '
      '501278987'
      '9876  '
      '780123498'
      '7652  '
      '789654123'
      '8765  '
      '802702300'
      '0096  '
      '786515122'
      '3452  '
      '482003459'
      '8764  '
      '789601248'
      '6532  '
      '750108656'
      '3211  '
      '506008888'
      '8888  '
      '786159489'
      '6214  '
      '789015123'
      '7894  '
      '789321456'
      '9871  '
      '779602123'
      '4567  '
      '745601234'
      '5678  '
      '869866600'
      '1028  '
      '843123456'
      '1230  '
      '769051123'
      '4568  '
      '505123789'
      '6541  '
      '890123450'
      '9876  '
      '502129896'
      '5234  '
      '789998877'
      '6654  '
      '689123456'
      '7891  '
      '799998877'
      '6654  '
      '801250123'
      '4568  '
      '543219876'
      '5432  '
      '789753159'
      '6842  '
      '471234567'
      '8901  '
      '780123456'
      '7896  ')
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object Button3: TButton
    Left = 32
    Top = 161
    Width = 483
    Height = 25
    Caption = 'Consulta Lote'
    TabOrder = 7
    OnClick = Button3Click
  end
end
