unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, taxGtin, IdHTTP, IdSSLOpenSSL;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Descricao: TLabeledEdit;
    GTIN: TLabeledEdit;
    Label1: TLabel;
    status: TLabel;
    NCM: TLabeledEdit;
    taxGtin1: TtaxGtin;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.Button1Click(Sender: TObject);
begin
  taxGtin1.ean:= gtin.text;
  status.Caption:= 'Consultando';
  try
   taxGtin1.executar ;
  except
    status.caption := 'erro na consulta';
  end;
  ncm.Text         := taxGtin1.ncm;
  descricao.text   := taxGtin1.descricao;
  taxGtin1.ean     := '';
  status.Caption:= 'consulta realizada com sucesso';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  self.Caption:= 'www.systax.com.br';
end;

end.

