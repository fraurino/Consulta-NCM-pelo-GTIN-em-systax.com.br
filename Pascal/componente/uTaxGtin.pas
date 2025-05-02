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
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,  System.Threading,
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
    Memo1: TMemo;
    Memo2: TMemo;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
  i : integer;
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

procedure TForm1.Button3Click(Sender: TObject);
var
  taxGtin: TtaxGtin;
  Resultado: string;
  gtin: string;
  i : integer;
 begin
        try
          Memo1.Lines.Add('🚀 Iniciando a busca... ' + FormatDateTime('dd-mm-yyyy hh:nn:ss', Now));
          for i := 0 to Memo2.Lines.Count - 1 do
          begin
            taxGtin := TtaxGtin.Create(nil);
            try
              gtin := '';
              gtin := Memo2.Lines[i];
              taxGtin.ean := gtin;
              taxGtin.executar;
              Resultado := Format('[%d]: %s |%s | %s | %s | %s',
                [i, FormatDateTime('dd-mm-yyyy hh:nn:ss', Now), taxGtin.ean, taxGtin.descricao, taxGtin.ncm, taxGtin.cest]);
                if (taxGtin.descricao.IsEmpty) and (taxGtin.descricao.IsEmpty) and (taxGtin.descricao.IsEmpty) then
                begin
                  Resultado := taxGtin.ean + ' não encontrado';
                end  ;
                if taxGtin.descricao.IsEmpty then
                begin
                    Resultado := Format('[%d]: %s |%s | %s | %s | %s',
                   [i, FormatDateTime('dd-mm-yyyy hh:nn:ss', Now), taxGtin.ean, 'sem descricao', taxGtin.ncm, taxGtin.cest]);
                end;
                if taxGtin.ncm.IsEmpty then
                begin
                    Resultado := Format('[%d]: %s |%s | %s | %s | %s',
                   [i, FormatDateTime('dd-mm-yyyy hh:nn:ss', Now), taxGtin.ean, taxgtin.descricao, 'sem ncm', taxGtin.cest]);
                end;
                if taxGtin.cest.IsEmpty then
                begin
                    Resultado := Format('[%d]: %s |%s | %s | %s | %s',
                   [i, FormatDateTime('dd-mm-yyyy hh:nn:ss', Now), taxGtin.ean, taxGtin.descricao, taxGtin.ncm, 'sem cest']);
                end;
               Memo1.Lines.Add(Resultado);
            finally
              taxGtin.Free;
            end;
          end;
          Memo1.Lines.Add('✅ Todas as buscas concluídas! ' + FormatDateTime('dd-mm-yyyy hh:nn:ss', Now));
        except
          on E: Exception do
          begin
            Memo1.Lines.Add('❌ Erro ao buscar GTIN ' + gtin + ': ' + E.Message);
          end;
        end;
 end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  self.Caption   := 'Consulta NCM, CEST via site www.systax.com.br | http://www.buscacest.com.br';
  Label4.Caption := 'Fonte : '+ self.Caption;
end;

end.
