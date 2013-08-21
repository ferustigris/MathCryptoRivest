program rivest;

uses
  Forms,
  main in 'main.pas' {Form1},
  bnumber in 'bnumber.pas',
  simple in 'simple.pas',
  power in 'power.pas',
  unod in 'unod.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
