program UdpReceiver;

uses
  Forms,
  FUdpMain in 'FUdpMain.pas' {FrmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
