{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit fkSystaxGtin;

{$warn 5023 off : no warning about unused units}
interface

uses
  taxGtin, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('taxGtin', @taxGtin.Register);
end;

initialization
  RegisterPackage('fkSystaxGtin', @Register);
end.
