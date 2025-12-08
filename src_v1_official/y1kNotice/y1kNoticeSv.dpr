program y1kNoticeSv;

uses
  Forms,
  FUdpMain in 'FUdpMain.pas' {FrmScreen},
  FSUdpM in '..\1000ydef\FSUdpM.pas' {FrmUdpM},
  deftype in '..\1000ydef\deftype.pas',
  FHer in 'FHer.pas' {FrmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmUdpM, FrmUdpM);
  Application.CreateForm(TFrmScreen, FrmScreen);
  Application.Run;
end.
