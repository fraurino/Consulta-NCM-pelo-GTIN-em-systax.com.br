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
  Autor........:  Alex B, Passos
  Github.......:  https://github.com/dataintsistemas
  Data.........:  02/12/2024 12:16:35
  Identificador:  Alex
  Modificação..:  Correção da acentuações
####################################################################################################################
}

unit taxGtin;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, StrUtils,  StdCtrls,
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
    fCEST: string;
    fretorno: string;
    const
      Furl = 'https://www.systax.com.br/ean/';
    procedure setEAN(AValue: string);
    procedure subtrairdados(informacao: string);
    procedure subtrairdadoscest (informacao : string );
    function RemoverEspacosDuplos(const AString: String): String;
    function RetornarConteudoEntre(const Frase, Inicio, Fim: String; IncluiInicioFim: Boolean): string;
    procedure ParseHTML(const HTMLContent: string; var DataList: TStringList);
    function CharIsNum(const C: Char): Boolean;
    function OnlyNumber(const AValue: String): String;
  public
    procedure executar;
    procedure NCMToCEST;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ean: string read fEAN write setEAN;
    property descricao: string read fDESCRICAO;
    property ncm: string read fNCM;
    property cest: string read fCEST;
    property retorno: string read fretorno;
  end;

procedure register;

implementation

procedure register;
begin
  RegisterComponents('Systax', [TtaxGtin]);
end;

procedure DisplayData(const DataList: TStringList; Memo: TListBox);
var
  I: Integer;
begin
  Memo.Clear;
  for I := 0 to DataList.Count - 1 do
    Memo.Items.Add(DataList[I]);
end;

function GetHTMLContent(const URL: string): string;
var
  HTTP: TIdHTTP;
begin
  HTTP := TIdHTTP.Create(nil);
  try
    Result := HTTP.Get(URL);
  finally
    HTTP.Free;
  end;
end;
procedure TtaxGtin.ParseHTML(const HTMLContent: string; var DataList: TStringList);
var
  StartPos, EndPos: Integer;
  RowContent : string ;
  i: Integer;  // Inicializando o contador
begin
  DataList.Clear;
  i := 0;  // Garantir que i comece com zero
  StartPos := Pos('<tr>', HTMLContent);

  while StartPos > 0 do
  begin
    // Encontra o próximo <tr> (linha da tabela)
    EndPos := PosEx('</tr>', HTMLContent, StartPos);
    if EndPos = 0 then Break;

    // Extrai o conteúdo da linha
    RowContent := Copy(HTMLContent, StartPos, EndPos - StartPos);

    // Extrai o CEST
    StartPos := Pos('<td class="text-right">', RowContent);
    if StartPos > 0 then
    begin
      StartPos := PosEx('>', RowContent, StartPos) + 1;
      EndPos := PosEx('</td>', RowContent, StartPos);
      fCEST := Trim(Copy(RowContent, StartPos, EndPos - StartPos));;
      // Incrementa o contador após extrair o CEST
      i := i + 1;
    end;

    // Se encontrarmos 3 itens, saímos do loop
    if i = 1 then
      Break;

    // Avança para o próximo <tr>
    StartPos := PosEx('<tr>', HTMLContent, EndPos);
  end;
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

  // Alex B, Passos update UTF8
  // Garantir que o resultado seja tratado como UTF-8
  {$IFDEF FPC}
    Result := UTF8ToString(Result);
  {$ELSE}
    Result := Result;
  {$ENDIF}

end;
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
  VStream : TStringStream;
  VRetorno : String;
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

  // Ajuste feito para retorno de dados com acentos
  VStream := TStringStream.Create('', TEncoding.ANSI);     // Alex B, Passos update UTF8

  HTTPClient := TIdHTTP.Create(nil);

  // Ajuste feito para retorno de dados com acentos
  HTTPClient.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 9.0)';    // Alex B, Passos update UTF8

  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    SSLHandler.SSLOptions.Method := sslvTLSv1_2;
    SSLHandler.SSLOptions.Mode := sslmClient;
    HTTPClient.IOHandler := SSLHandler;

    // Obtemos o conteúdo do servidor
    // Ajuste feito para retorno de dados com acentos
    HTTPClient.Get(Furl + fEAN, VStream);
    VRetorno := VStream.DataString;      // Alex B, Passos update UTF8
    subtrairdados(VRetorno);


  finally
    SSLHandler.Free;
    HTTPClient.Free;
  end;


  {$ENDIF}
end;


procedure TtaxGtin.NCMToCEST;
var
  i: integer;
  HTMLContent: string;
  DataList: TStringList;
{$IFDEF FPC}
var
  HTTPClient: TFPHTTPClient;
{$ELSE}
var
  HTTPClient: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
{$ENDIF}

const urlsite : string= 'http://www.buscacest.com.br/?utf8=%E2%9C%93&ncm=' ;
begin
  {$IFDEF FPC}
  HTTPClient := TFPHTTPClient.Create(nil);
  try
    subtrairdadoscest(HTTPClient.Get(urlsite + fNCM));
  except
    raise Exception.Create('Erro ao consultar EAN ' + fNCM);
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
    var Response: string := HTTPClient.Get(urlsite + fNCM);

    // Decodificar o conteúdo para UTF-8
    {$IF CompilerVersion >= 23.0} // Delphi XE2 ou superior
    Response := TEncoding.UTF8.GetString(TEncoding.UTF8.GetBytes(Response));
    {$ELSE}
    Response := UTF8Decode(Response);
    {$IFEND}

    // Processar os dados
    subtrairdadoscest(Response);


  finally
    SSLHandler.Free;
    HTTPClient.Free;
  end;

  {$ENDIF}



end;


procedure TtaxGtin.subtrairdados(informacao: string);
var
  i: integer;
  HTMLContent: string;
  DataList: TStringList;
  const //alterar tags se site sofrer alteracao;
  taginihtml : string = '<h2 class="fonte-open-title h1-title" style="text-align:center;">';
  tagimhtml  : string = '</h2>';
begin
  fretorno := informacao;

  if AnsiContainsText(informacao, '01001345450801') then
  begin
    fDescricao := 'Código de barra inválido!';
    fDescricao := '';
    fNCM := '';
  end;

  fNCM := RetornarConteudoEntre(fretorno, 'NCM:', '</a>', false) ;
  fNCM := OnlyNumber(fNCM);
  fNCM := copy(fNCM, 1,8);
  fDescricao :=  (RemoverEspacosDuplos
                    (
                    RetornarConteudoEntre(
                          fretorno,
                          taginihtml,
                          tagimhtml,
                          false)
                     )
                ) ;
  //busca CEST pelo NCM em outro site.
  NCMToCEST ;


end;

procedure TtaxGtin.subtrairdadoscest(informacao: string);
var
  i: integer;
  HTMLContent: string;
  DataList: TStringList;
begin
      // Obtendo o conteúdo HTML
      HTMLContent := informacao;
      DataList := TStringList.Create;
      try
        ParseHTML(HTMLContent, DataList);
      finally
        DataList.Free;
      end;
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

