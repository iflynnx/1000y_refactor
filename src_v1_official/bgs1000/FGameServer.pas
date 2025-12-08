unit FGameServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TfrmGSState = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblCreateSendB: TLabel;
    lblCreateReceiveB: TLabel;
    lblCreateWBC: TLabel;
    shpCreateWBSign: TShape;
    Label7: TLabel;
    Bevel1: TBevel;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblRevivalSendB: TLabel;
    lblRevivalReceiveB: TLabel;
    lblRevivalWBC: TLabel;
    shpRevivalWBSign: TShape;
    Label11: TLabel;
    Bevel2: TBevel;
    GroupBox3: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lblLifeSendB: TLabel;
    lblLifeReceiveB: TLabel;
    lblLifeWBC: TLabel;
    shpLifeWBSign: TShape;
    Label18: TLabel;
    Bevel3: TBevel;
    GroupBox4: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    lblMythSendB: TLabel;
    lblMythReceiveB: TLabel;
    lblMythWBC: TLabel;
    shpMythWBSign: TShape;
    Label25: TLabel;
    Bevel4: TBevel;
    GroupBox5: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    lblWorldSendB: TLabel;
    lblWorldReceiveB: TLabel;
    lblWorldWBC: TLabel;
    shpWorldWBSign: TShape;
    Label32: TLabel;
    Bevel5: TBevel;
    GroupBox6: TGroupBox;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    lblSkySendB: TLabel;
    lblSkyReceiveB: TLabel;
    lblSkyWBC: TLabel;
    shpSkyWBSign: TShape;
    Label39: TLabel;
    Bevel6: TBevel;
    GroupBox7: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    lblTestSendB: TLabel;
    lblTestReceiveB: TLabel;
    lblTestWBC: TLabel;
    shpTestWBSign: TShape;
    Label22: TLabel;
    Bevel7: TBevel;
    GroupBox8: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    lblExSendB: TLabel;
    lblExReceiveB: TLabel;
    lblExWBC: TLabel;
    shpExWBSign: TShape;
    Label30: TLabel;
    Bevel8: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGSState: TfrmGSState;

implementation

{$R *.DFM}

end.
