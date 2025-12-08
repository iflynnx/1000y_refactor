unit Unit_console;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  logtype = (lt_draw, lt_net, lt_move, lt_have, lt_littlemap, lt_gametools
    , lt_RPacket);
  TFrmConsole = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    CheckBoxdraw: TCheckBox;
    CheckBoxhave: TCheckBox;
    CheckBoxlittlemap: TCheckBox;
    CheckBoxNet: TCheckBox;
    CheckBox_WG: TCheckBox;
    CheckBox_RPacket: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure cprint(atype: logtype; astr: string);
  end;

var
  FrmConsole: TFrmConsole;

implementation

{$R *.dfm}

procedure TFrmConsole.cprint(atype: logtype; astr: string);
begin
  if not Visible then exit;
  case atype of
    lt_draw: if CheckBoxdraw.Checked = false then exit;
    lt_have: if CheckBoxhave.Checked = false then exit;
    lt_littlemap: if CheckBoxlittlemap.Checked = false then exit;
    lt_net: if CheckBoxNet.Checked = false then exit;
    lt_gametools: if CheckBox_WG.Checked = false then exit;
    lt_RPacket: if CheckBox_RPacket.Checked = false then exit;
  end;
  case atype of
    lt_draw: astr := '[绘制]' + astr;
    lt_have: astr := '[背包]' + astr;
    lt_littlemap: astr := '[小地图]' + astr;
    lt_net: astr := '[网络]' + astr;
    lt_gametools: astr := '[WG]' + astr;
    lt_RPacket: astr := '[重发包类]' + astr;
  end;
  Memo1.Lines.Add(datetimetostr(Now()) + astr);
end;

end.

