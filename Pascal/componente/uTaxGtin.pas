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
  Vcl.Imaging.jpeg, // Para JPEG
  Vcl.Imaging.pngimage,  // Para PNG
  Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls;

type
  Tfrmconsulta = class(TForm)
    Button1: TButton;
    gtin: TEdit;
    ncm: TEdit;
    descricao: TEdit;
    Label1: TLabel;
    cest: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Button3: TButton;
    imgproduto: TImage;
    consultaimagem: TCheckBox;
    ComboBoxUF: TComboBox;
    consultaibpt: TCheckBox;
    nacionalfederal: TEdit;
    importadosfederal: TEdit;
    Label5: TLabel;
    estadual: TEdit;
    municipal: TEdit;
    versao: TEdit;
    vigenciafim: TDateTimePicker;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure carregaimagem(AImage: TImage; const Arquivo: string);
    procedure PreencherComboUF(Combo: TComboBox);
  end;

var
  frmconsulta: Tfrmconsulta;

implementation

uses
  taxgtinaux;

{$R *.dfm}

procedure Tfrmconsulta.PreencherComboUF(Combo: TComboBox);
const
  UFs: array[0..26] of string = (
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
    'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN',
    'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO');
var
  i: Integer;
begin
  Combo.Items.Clear;
  for i := Low(UFs) to High(UFs) do
    Combo.Items.Add(UFs[i]);
  Combo.ItemIndex := 0; // seleciona a primeira UF por padrão
end;


procedure Tfrmconsulta.Button1Click(Sender: TObject);
var
  taxGtin : TtaxGtin;
  i : integer;
  baixaimagem : boolean;
  cconsultaibpt : boolean ;
  UF : string ;
begin
  taxGtin := TtaxGtin.Create(nil);
  try
    baixaimagem    := consultaimagem.Checked;
    cconsultaibpt  := consultaibpt.Checked;
    UF             := ComboBoxUF.Items[ComboBoxUF.ItemIndex];

   taxGtin.ean      := gtin.text;
   taxGtin.executar(baixaimagem , cconsultaibpt, UF );
   ncm.Text         := taxGtin.ncm;
   descricao.text   := taxGtin.descricao;
   cest.text        := taxGtin.cest;
   taxGtin.ean      := '';

   if cconsultaibpt then
   begin
    nacionalfederal.Text     := taxgtin.NacionalFederal;
    importadosfederal.Text   := taxgtin.importadosfederal;
    estadual.Text            := taxgtin.estadual;
    municipal.Text           := taxgtin.municipal;
    vigenciafim.date         := taxgtin.vigenciafim;
    versao.Text              := taxgtin.versao;
   end;

   if baixaimagem then
   begin
     if fileexists(taxgtin.pathimagem) then
     begin
      carregaimagem (imgproduto, taxgtin.pathimagem);
     end;
   end;
  finally
   taxGtin.Free;
  end;
end;

procedure Tfrmconsulta.Button3Click(Sender: TObject);
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

procedure Tfrmconsulta.carregaimagem(AImage: TImage; const Arquivo: string);
var
  Extensao: string;
  Img: TGraphic;
begin
  if not FileExists(Arquivo) then
    Exit;

  AImage.Picture := nil;
  Extensao := LowerCase(ExtractFileExt(Arquivo));

  if Extensao = '.jpg' then
    Img := TJPEGImage.Create
  else if Extensao = '.jpeg' then
    Img := TJPEGImage.Create
  else if Extensao = '.png' then
    Img := TPngImage.Create
  else
    Img := TBitmap.Create; // Para .bmp, .img ou outras genéricas

  try
    Img.LoadFromFile(Arquivo);
    AImage.Picture.Assign(Img);
  finally
    Img.Free;
  end;
end;

procedure Tfrmconsulta.FormCreate(Sender: TObject);
begin
  self.Caption   := 'Consulta NCM, CEST via site www.systax.com.br | http://www.buscacest.com.br';
  Label4.Caption := 'Fonte : '+ self.Caption;
  PreencherComboUF(ComboBoxUF);
  vigenciafim.Date := date;
end;

end.
