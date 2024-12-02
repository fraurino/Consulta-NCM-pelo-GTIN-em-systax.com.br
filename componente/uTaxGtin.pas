{####################################################################################################################
                              TaxGtin get website  https://www.systax.com.br/ean/7894900010015
####################################################################################################################
    Owner.....: Francisco Aurino - franciscoaurino@gmail.com   - +55 98 9 8892-3379
####################################################################################################################
  Obs:
     - Código aberto a comunidade Delphi/Lazarus, desde que mantenha os dados dos autores e
       mantendo sempre o nome do IDEALIZADOR Francisco Aurino
     - Colocar na evolução as Modificação juntamente com as informaçoes do colaborador: Data, Nova Versao, Autor;
     - Mantenha sempre a versao mais atual acima das demais;
     - Todo Commit ao repositório deverá ser declarado as mudança na UNIT e ainda o Incremento da Versão de
       compilação (último digito);
####################################################################################################################
                                  Evolução do Código
####################################################################################################################
  Autor........:
  Email........:
  Data.........:
  Identificador:
  Modificação..:
####################################################################################################################
}



unit uTaxGtin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    gtin: TEdit;
    ncm: TEdit;
    descricao: TEdit;
    Label1: TLabel;
    cest: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  taxgtin;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  taxGtin : TtaxGtin;

begin
  taxGtin := TtaxGtin.Create(nil);
  try
    taxGtin.ean      := gtin.text;
    taxGtin.executar ;
    ncm.Text         := taxGtin.ncm;
    descricao.text   := taxGtin.descricao;
    cest.text        := taxGtin.cest;
    taxGtin.ean      := '';
  finally
    taxGtin.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  self.Caption   := 'Consulta NCM, CEST via site www.systax.com.br | http://www.buscacest.com.br';
  Label4.Caption := 'Fonte : '+ self.Caption;
end;

end.
