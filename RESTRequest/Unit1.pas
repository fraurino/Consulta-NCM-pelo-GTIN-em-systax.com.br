{
Autor........:  Marcelo Henrique
Github.......:  https://github.com/Marcelohgs
Data.........:  02/12/2024 14:19:35
Identificador: 
Modificação..: Demo com RESTRequest
}
unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IPPeerClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Rest.types, System.json;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    RESTClient1: TRESTClient;
    RESTResponse1: TRESTResponse;
    RESTRequest1: TRESTRequest;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  const
  Furl = 'https://www.systax.com.br/ean/';
var
  Form1: TForm1;

implementation

{$R *.dfm}

uses taxgtin;

procedure TForm1.Button1Click(Sender: TObject);
var
  TaxRequest: TtaxGtin;
  statuscode: integer;
begin
  TaxRequest := TtaxGtin.Create(NIL);
  TaxRequest.SendGet(Edit1.Text, statuscode);

  if statuscode in [200] then
  begin
    Edit2.Text := TaxRequest.descricao;
    Edit3.Text := TaxRequest.ncm;
    Edit4.Text := TaxRequest.cest;
  end;
end;


end.
