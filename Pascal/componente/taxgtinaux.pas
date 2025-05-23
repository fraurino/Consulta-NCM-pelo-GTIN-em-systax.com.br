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

unit taxgtinaux;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, StrUtils,  StdCtrls,  System.RegularExpressions,
  System.Net.HttpClient, System.Net.URLClient, System.NetConsts,  forms, dialogs,
  {$IFDEF FPC}
  fphttp, fphttpclient, opensslsockets, sslsockets, DOM, XMLRead
  {$ELSE}
  DateUtils, System.JSON, IdHTTP, IdSSL, IdSSLOpenSSL
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
    //imagem do produto
    fpathimagem : string ;
    //ibpt
    fCodigo: string;
    fNacionalFederal: string;
    fImportadosFederal: string;
    fEstadual: string;
    fMunicipal: string;
    fVigenciaInicio: tdate;
    fVigenciaFim: tdate;
    fVersao: string;
    fFonte: string;
    fUF: string;

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
    procedure NCMToCEST;
    function EANinCosmosbluesoft(const CodigoBarra: string): string;
    function BuscarInfoIBPT(const NCM, UF: string): boolean ;

  public
    procedure executar (const getimg : boolean = false; const getibpt : boolean = false; const Estado : string = 'MA');
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ean: string read fEAN write setEAN;
    property descricao: string read fDESCRICAO;
    property ncm: string read fNCM;
    property pathimagem: string read fpathimagem;
    property cest: string read fCEST;
    property retorno: string read fretorno;
    property Codigo: string read fCodigo;
    property NacionalFederal: string read fNacionalFederal;
    property ImportadosFederal: string read fImportadosFederal;
    property Estadual: string read fEstadual;
    property Municipal: string read fMunicipal;
    property VigenciaInicio: tdate read fVigenciaInicio;
    property VigenciaFim: tdate read fVigenciaFim;
    property Versao: string read fVersao;
    property Fonte: string read fFonte;
    property UF: string read fUF;


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

function TtaxGtin.BuscarInfoIBPT(const NCM, UF: string): boolean;
var
  HttpClient: THTTPClient;
  Response: IHTTPResponse;
  JSON: TJSONObject;
  URL: string;
begin
  FillChar(Result, SizeOf(Result), 0); // Zera o record
  URL := Format('https://api-ibpt.seunegocionanuvem.com.br/api_ibpt.php?codigo=%s&uf=%s',
    [NCM, UF]);

  HttpClient := THTTPClient.Create;
  try
    Response := HttpClient.Get(URL);
    if Response.StatusCode = 200 then
    begin
      JSON := TJSONObject.ParseJSONValue(Response.ContentAsString()) as TJSONObject;
      try
        fCodigo := JSON.GetValue<string>('codigo');
        fNacionalFederal := JSON.GetValue<string>('nacionalfederal');
        fImportadosFederal := JSON.GetValue<string>('importadosfederal');
        fEstadual := JSON.GetValue<string>('estadual');
        fMunicipal := JSON.GetValue<string>('municipal');
        fVigenciaInicio := ISO8601ToDate(JSON.GetValue<string>('vigenciainicio'));
        fVigenciaFim    := ISO8601ToDate(JSON.GetValue<string>('vigenciafim'));
        fVersao := JSON.GetValue<string>('versao');
        fFonte := JSON.GetValue<string>('fonte');
        fUF := JSON.GetValue<string>('uf');
      finally
        JSON.Free;
      end;
    end
    else
      raise Exception.Create('Erro ao acessar a api-ibpt: ' + Response.StatusText);
  finally
    HttpClient.Free;
  end;
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



procedure TtaxGtin.executar(const getimg : boolean = false; const getibpt : boolean = false; const Estado : string = 'MA');
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

      subtrairdados(VRetorno);
    end
    else
      raise Exception.CreateFmt('Erro ao consultar EAN %s. Código HTTP: %d', [fEAN, Response.StatusCode]);
  finally
    HTTPClient.Free;
  end;
  {$ENDIF}

  /// baixa a imagem primeiro....
  if getimg then
  EANinCosmosbluesoft(fEAN); //baixar imagem;

  if getibpt then
  begin
   BuscarInfoIBPT (fNCM, Estado);
  end;

end;


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

function TtaxGtin.EANinCosmosbluesoft(const CodigoBarra: string): string;
var
  HttpClient: THTTPClient;
  Response: IHTTPResponse;
  Stream: TMemoryStream;
  URL, Extensao, NomeArquivo, Diretorio, ContentType: string;
  Signature: array[0..3] of Byte;
begin
  Result := '';
  URL := 'https://cdn-cosmos.bluesoft.com.br/products/' + CodigoBarra;
  Diretorio := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'imagens');
  ForceDirectories(Diretorio);

  HttpClient := THTTPClient.Create;
  Stream := TMemoryStream.Create;
  try
    try
      Response := HttpClient.Get(URL);
      if Response.StatusCode = 200 then
      begin
        Response.ContentStream.Position := 0;
        Stream.CopyFrom(Response.ContentStream, Response.ContentStream.Size);
        Stream.Position := 0;

        // Detecta a extensão a partir do Content-Type
        ContentType := LowerCase(Response.HeaderValue['Content-Type']);

        if ContentType.Contains('image/jpeg') then
          Extensao := '.jpg'
        else if ContentType.Contains('image/png') then
          Extensao := '.png'
        else if ContentType.Contains('image/gif') then
          Extensao := '.gif'
        else if ContentType.Contains('image/webp') then
          Extensao := '.webp'
        else
        begin
          // Heurística baseada na assinatura do arquivo
          Stream.Read(Signature, 4);
          Stream.Position := 0;

          if (Signature[0] = $89) and (Signature[1] = $50) then // PNG
            Extensao := '.png'
          else if (Signature[0] = $FF) and (Signature[1] = $D8) then // JPEG
            Extensao := '.jpg'
          else if (Signature[0] = $47) and (Signature[1] = $49) then // GIF
            Extensao := '.gif'
          else
            Extensao := '.img'; // fallback genérico
        end;


        NomeArquivo := Diretorio + CodigoBarra + Extensao;
        Stream.SaveToFile(NomeArquivo);
        Result     := NomeArquivo;
        fpathimagem := nomearquivo;
      end;
    except
      on E: Exception do
        showmessage('Erro ao baixar imagem: ' + E.Message);
    end;
  finally
    Stream.Free;
    HttpClient.Free;
  end;
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

