object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 187
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 41
    Width = 18
    Height = 13
    Caption = 'gtin'
  end
  object Label2: TLabel
    Left = 8
    Top = 75
    Width = 46
    Height = 13
    Caption = 'Descri'#231#227'o'
  end
  object Label3: TLabel
    Left = 8
    Top = 107
    Width = 22
    Height = 13
    Caption = 'NCM'
  end
  object Label4: TLabel
    Left = 8
    Top = 138
    Width = 22
    Height = 13
    Caption = 'Cest'
  end
  object Edit1: TEdit
    Left = 80
    Top = 38
    Width = 225
    Height = 21
    TabOrder = 0
    Text = '7898380920017'
  end
  object Edit2: TEdit
    Left = 80
    Top = 72
    Width = 225
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 321
    Top = 36
    Width = 75
    Height = 25
    Caption = 'Consultar'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit3: TEdit
    Left = 80
    Top = 105
    Width = 225
    Height = 21
    TabOrder = 3
  end
  object Edit4: TEdit
    Left = 80
    Top = 135
    Width = 225
    Height = 21
    TabOrder = 4
  end
  object RESTClient1: TRESTClient
    Params = <>
    Left = 272
    Top = 120
  end
  object RESTResponse1: TRESTResponse
    Left = 360
    Top = 96
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 464
    Top = 144
  end
end
