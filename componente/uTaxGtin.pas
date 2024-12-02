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
    procedure Button1Click(Sender: TObject);
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

  taxGtin.ean      := gtin.text;
  taxGtin.executar ;
  ncm.Text         := taxGtin.ncm;
  descricao.text   := taxGtin.descricao;
  taxGtin.ean      := '';

  taxGtin.Free;
end;

end.
