unit taxGtin;
{$mode objfpc}{$H+}
//{$MODE Delphi}
interface

uses
  Classes, SysUtils , fphttp, fphttpclient, StrUtils, XMLRead,  DOM, opensslsockets, ssockets, sslsockets ;

type

{ TtaxGtin }

 TtaxGtin = Class(TComponent)
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
 Public
    procedure executar;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ean : string read fEAN write setEAN;
    property descricao : string read fDESCRICAO ;
    property ncm : string read fNCM ;
    property retorno : string read fretorno;
  end;

procedure register;

implementation

procedure register;
begin
  RegisterComponents('Systax',[TtaxGtin]);
end;

{ TtaxGtin }
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
end ;
function TtaxGtin.RemoverEspacosDuplos(const AString: String): String;
begin
  Result := Trim(AString);
  while Pos('  ', Result) > 0 do
    Result := StringReplace( Result, '  ', ' ', [rfReplaceAll]);
end;
function TtaxGtin.CharIsNum(const C: Char): Boolean;
begin
  Result := CharInSet( C, ['0'..'9'] ) ;
end ;
function TtaxGtin.OnlyNumber(const AValue: String): String;
Var
  I : Integer ;
  LenValue : Integer;
begin
  Result   := '' ;
  LenValue := Length( AValue ) ;
  For I := 1 to LenValue  do
  begin
     if CharIsNum( AValue[I] ) then
        Result := Result + AValue[I];
  end;
end ;
procedure TtaxGtin.setEAN(AValue: string);
begin
  if fEAN=AValue then Exit;
  fEAN:=AValue;
end;
procedure TtaxGtin.executar;
begin
  with TFPHTTPClient.Create(nil) do
  begin
   try
     subtrairdados (Get (furl + fEAN ));
   except
    raise Exception.Create('erro ao consultar ean ' + fEAN);
   end;
  end;
end;
procedure TtaxGtin.subtrairdados ( informacao : string );
begin
   fretorno := informacao;
   if AnsiContainsText(informacao, '01001345450801')= true
   then
   begin
    fDescricao := 'código de barra inválido!' ;
    fDescricao := '';
    fNcm       := '';
   end;

   fNCM := RetornarConteudoEntre(fretorno, 'NCM:', '</a>', false) ;
   fNCM := OnlyNumber(fNCM);
   fNCM := copy(fNCM, 1,8);
   //fNCM:= Copy(OnlyNumber(RetornarConteudoEntre(fretorno, 'NCM:', '</a>')  )  ,1,8 );
   fDescricao :=  (RemoverEspacosDuplos(RetornarConteudoEntre(fretorno, '<p class="fonte-open-body">', '</p>',false))) ;


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

