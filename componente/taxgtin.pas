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

unit taxGtin;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, StrUtils,
  {$IFDEF FPC}
  fphttp, fphttpclient, opensslsockets, sslsockets, DOM, XMLRead
  {$ELSE}
  IdHTTP, IdSSL, IdSSLOpenSSL
  {$ENDIF}
  ;

type
  { TtaxGtin }
  TtaxGtin = class(TComponent)
  private
    fDESCRICAO: string;
    fEAN: string;
    fNCM: string;
    fretorno: string;
    const
      Furl = 'https://www.systax.com.br/ean/';
    procedure setEAN(AValue: string);
    procedure subtrairdados(informacao: string);
    function RemoverEspacosDuplos(const AString: String): String;
    function RetornarConteudoEntre(const Frase, Inicio, Fim: String; IncluiInicioFim: Boolean): string;
    function CharIsNum(const C: Char): Boolean;
    function OnlyNumber(const AValue: String): String;
  public
    procedure executar;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ean: string read fEAN write setEAN;
    property descricao: string read fDESCRICAO;
    property ncm: string read fNCM;
    property retorno: string read fretorno;
  end;

procedure register;

implementation

procedure register;
begin
  RegisterComponents('Systax', [TtaxGtin]);
end;

{ TtaxGtin }
function TtaxGtin.RetornarConteudoEntre(const Frase, Inicio, Fim: String; IncluiInicioFim: Boolean): string;
var
  i, j: Integer;
  s: string;
begin
  Result := '';

  // Procurar a posição do início
  i := Pos(Inicio, Frase);
  if i = 0 then
    Exit;

  // Ajustar a string de acordo com a posição do início
  if IncluiInicioFim then
  begin
    s := Copy(Frase, i, Length(Frase) - i + 1); // Pegamos a partir do início até o final
    j := Pos(Fim, s); // Procurar o término dentro da substring ajustada
    if j > 0 then
      Result := Copy(s, 1, j + Length(Fim) - 1); // Retorna incluindo início e fim
  end
  else
  begin
    s := Copy(Frase, i + Length(Inicio), Length(Frase) - i - Length(Inicio) + 1); // Ajusta para ignorar o início
    j := Pos(Fim, s); // Procurar o término dentro da substring ajustada
    if j > 0 then
      Result := Copy(s, 1, j - 1); // Retorna apenas o conteúdo entre início e fim
  end;

  // Garantir que o resultado seja tratado como UTF-8
  Result := UTF8ToString(Result);
end;

    {
function TtaxGtin.RetornarConteudoEntre(const Frase, Inicio, Fim: String; IncluiInicioFim: Boolean): string;
var
  i: integer;
  s: string;
begin
  result := '';
  i := pos(Inicio, Frase);
  if i = 0 then
    Exit;

  if IncluiInicioFim then
  begin
    s := Copy(Frase, i, maxInt);
    result := Copy(s, 1, pos(Fim, s) + Length(Fim) - 1);
  end
  else
  begin
    s := Copy(Frase, i + length(Inicio), maxInt);
    result := Copy(s, 1, pos(Fim, s) - 1);
  end;
end;   }

function TtaxGtin.RemoverEspacosDuplos(const AString: String): String;
begin
  Result := Trim(AString);
  while Pos('  ', Result) > 0 do
    Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
end;

function TtaxGtin.CharIsNum(const C: Char): Boolean;
begin
  {$IFDEF FPC}
  Result := C in ['0'..'9'];
  {$ELSE}
  Result := CharInSet(C, ['0'..'9']);
  {$ENDIF}
end;

function TtaxGtin.OnlyNumber(const AValue: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AValue) do
  begin
    if CharIsNum(AValue[I]) then
      Result := Result + AValue[I];
  end;
end;

procedure TtaxGtin.setEAN(AValue: string);
begin
  if fEAN = AValue then Exit;
  fEAN := AValue;
end;

procedure TtaxGtin.executar;
{$IFDEF FPC}
var
  HTTPClient: TFPHTTPClient;
{$ELSE}
var
  HTTPClient: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
{$ENDIF}
begin
  {$IFDEF FPC}
  HTTPClient := TFPHTTPClient.Create(nil);
  try
    subtrairdados(HTTPClient.Get(Furl + fEAN));
  except
    raise Exception.Create('Erro ao consultar EAN ' + fEAN);
  finally
    HTTPClient.Free;
  end;
  {$ELSE}

  HTTPClient := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    SSLHandler.SSLOptions.Method := sslvTLSv1_2;
    SSLHandler.SSLOptions.Mode := sslmClient;
    HTTPClient.IOHandler := SSLHandler;

    // Obtemos o conteúdo do servidor
    var Response: string := HTTPClient.Get(Furl + fEAN);

    // Decodificar o conteúdo para UTF-8
    {$IF CompilerVersion >= 23.0} // Delphi XE2 ou superior
    Response := TEncoding.UTF8.GetString(TEncoding.UTF8.GetBytes(Response));
    {$ELSE}
    Response := UTF8Decode(Response);
    {$IFEND}

    // Processar os dados
    subtrairdados(Response);
  finally
    SSLHandler.Free;
    HTTPClient.Free;
  end;


  {$ENDIF}
end;

procedure TtaxGtin.subtrairdados(informacao: string);
begin
  fretorno := informacao;

  if AnsiContainsText(informacao, '01001345450801') then
  begin
    fDescricao := 'Código de barra inválido!';
    fDescricao := '';
    fNCM := '';
  end;

  fNCM := RetornarConteudoEntre(fretorno, 'NCM:', '</a>', false);
  fNCM := OnlyNumber(fNCM);
  fNCM := Copy(fNCM, 1, 8);

  fDescricao := RemoverEspacosDuplos(
  RetornarConteudoEntre(fretorno, '<h2 class="fonte-open-title h1-title" style="text-align:center;">', '</h2>', false));
end;

constructor TtaxGtin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TtaxGtin.Destroy;
begin
  inherited Destroy;
end;

end.

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
}
