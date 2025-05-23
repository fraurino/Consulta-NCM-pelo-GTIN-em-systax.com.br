program Demo;

uses
  Vcl.Forms,
  uTaxGtin in '..\componente\uTaxGtin.pas' {frmconsulta},
  taxgtinaux in '..\componente\taxgtinaux.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrmconsulta, frmconsulta);
  Application.Run;
end.
