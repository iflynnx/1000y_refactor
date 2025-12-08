program pgk;

uses
  Forms,
  Fpgk in 'Fpgk.pas' {Form1},
  FfilePgk in 'FfilePgk.pas',
  uKeyClass in '..\..\..\common\uKeyClass.pas',
  uCrypt in '..\..\..\common\uCrypt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
