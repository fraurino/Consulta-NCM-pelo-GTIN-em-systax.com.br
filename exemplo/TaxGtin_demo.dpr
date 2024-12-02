program TaxGtin_demo;

uses
  Vcl.Forms,
  uTaxGtin in '..\componente\uTaxGtin.pas' {Form1},
  taxgtin in '..\componente\taxgtin.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
