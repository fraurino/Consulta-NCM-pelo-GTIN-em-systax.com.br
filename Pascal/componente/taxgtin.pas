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
  Autor........:  Aurino
  Github.......:  https://github.com/fraurino
  Data.........:  02/05/2025 10:44
  Identificador:  Aurino
  Modificação..:  #1 - Mudanção da requisicao IDHttp para HttpClient, evitando dependencia de dll OpenSSL;
                  #2 - Melhoria na validação do codigo de barra caso nao exista no portal;
####################################################################################################################
}

unit taxGtin;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, StrUtils,  StdCtrls,  System.RegularExpressions,
  System.Net.HttpClient, System.Net.URLClient, System.NetConsts,
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
  HTTPClient: THTTPClient;
  Response: IHTTPResponse;
  VRetorno: string;
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
  HTTPClient := THTTPClient.Create;
  try
    fDESCRICAO := '';
    fNCM       := '';
    fCEST      := '';

    Response := HTTPClient.Get(Furl + fEAN);
    if Response.StatusCode = 200 then
    begin
      VRetorno := Response.ContentAsString(TEncoding.ANSI);
      //VRetorno := Response.ContentAsString(TEncoding.UTF8);

     subtrairdados(VRetorno);
    end
    else
      raise Exception.CreateFmt('Erro ao consultar EAN %s. Código HTTP: %d', [fEAN, Response.StatusCode]);
  finally
    HTTPClient.Free;
  end;
  {$ENDIF}
end;


(*
procedure TtaxGtin.executar; //dependencia de dll openssll
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

    fDESCRICAO := '';
    fNCM:= '';
    fCEST:='';

    HTTPClient.Get(Furl + fEAN, VStream);
    VRetorno := VStream.DataString;      // Alex B, Passos update UTF8
    subtrairdados(VRetorno);


  finally
    SSLHandler.Free;
    HTTPClient.Free;
  end;


  {$ENDIF}
end;

  *)

procedure TtaxGtin.NCMToCEST;
var
  HTMLContent: string;
  Response: IHTTPResponse;
  HTTPClient: THTTPClient;
const
  urlsite: string = 'http://www.buscacest.com.br/?utf8=%E2%9C%93&ncm=';
begin
  {$IFDEF FPC}
  var HTTPClient: TFPHTTPClient;
  HTTPClient := TFPHTTPClient.Create(nil);
  try
    subtrairdadoscest(HTTPClient.Get(urlsite + fNCM));
  except
    raise Exception.Create('Erro ao consultar NCM ' + fNCM);
  finally
    HTTPClient.Free;
  end;
  {$ELSE}
  HTTPClient := THTTPClient.Create;
  try
    Response := HTTPClient.Get(urlsite + fNCM);
    if Response.StatusCode = 200 then
    begin
      // Use UTF-8 para garantir acentuação correta
      HTMLContent := Response.ContentAsString(TEncoding.UTF8);
      subtrairdadoscest(HTMLContent);
    end
    else
      raise Exception.CreateFmt('Erro ao consultar NCM %s. Código HTTP: %d', [fNCM, Response.StatusCode]);
  finally
    HTTPClient.Free;
  end;
  {$ENDIF}
end;

  (*procedure TtaxGtin.NCMToCEST; //dependencia de dll openssll
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
    SSLHandler.SSLOptions.Mode   := sslmClient;
    HTTPClient.IOHandler         := SSLHandler;

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
*)

procedure TtaxGtin.subtrairdados(informacao: string);

function TagTitulo(const Html, CodigoEAN: string): Boolean;
var
  TituloInicio, TituloFim: Integer;
  Titulo: string;
begin
  // Procura onde começa e termina a tag <title>
  TituloInicio := Pos('<title>', LowerCase(Html));
  TituloFim    := Pos('</title>', LowerCase(Html));

  if (TituloInicio > 0) and (TituloFim > TituloInicio) then
  begin
    // Extrai o conteúdo entre as tags
    Titulo := Copy(Html, TituloInicio + Length('<title>'), TituloFim - TituloInicio - Length('<title>'));
    Result := Pos(CodigoEAN, Titulo) > 0;
  end
  else
    Result := False; // Não encontrou a tag <title>
end;


var
  i: integer;
  EanOK : boolean ;
  const //alterar tags se site sofrer alteracao;
  taginihtml : string = '<h2 class="fonte-open-title h1-title" style="text-align:center;">';
  tagimhtml  : string = '</h2>';
begin
  fretorno := informacao;

  eanOK := TagTitulo(informacao, fEAN);
  if eanOK then
  begin
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
    NCMToCEST
  end
  else
  begin
   fDescricao := 'Código de barra não encontrado!';
   fNCM       := '********';
   fCest      := '*******';
  end;

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

