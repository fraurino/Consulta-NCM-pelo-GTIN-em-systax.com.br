program TaxGtin;

uses
  Vcl.Forms,
  uTaxGtin in '..\componente\uTaxGtin.pas',
  taxgtin in '..\componente\taxgtin.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
