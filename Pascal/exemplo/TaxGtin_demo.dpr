program TaxGtin_demo;

uses
  Vcl.Forms,
  uTaxGtin in '..\componente\uTaxGtin.pas' {Form1},
  taxgtin in '..\componente\taxgtin.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sky');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
