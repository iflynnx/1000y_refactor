unit FChat;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    deftype, StdCtrls, A2Form, ExtCtrls, Autil32, A2Img, CharCls,
    uAnsTick, DXDraws, Gauges, Buttons, Cltype, ctable, log, Acibfile, clmap,
    AtzCls, uPerSonBat;

type
    TFrmChat = class(TForm)
        A2Form:TA2Form;
        Button_world_choose:TA2Button;
        Button_scrip__choose:TA2Button;
        Button_procession_choose:TA2Button;
        Button_present_choose:TA2Button;
        Button_Map_choose:TA2Button;
        Button_guild_choose:TA2Button;
        procedure FormCreate(Sender:TObject);
        procedure FormDestroy(Sender:TObject);
        procedure Button_present_chooseClick(Sender:TObject);
        procedure Button_guild_chooseClick(Sender:TObject);
        procedure Button_Map_chooseClick(Sender:TObject);
        procedure Button_procession_chooseClick(Sender:TObject);
        procedure Button_scrip__chooseClick(Sender:TObject);
        procedure Button_world_chooseClick(Sender:TObject);
    private
        { Private declarations }
    public
        { Public declarations }
        temping:TA2Image;

    end;

var
    FrmChat         :TFrmChat;

implementation
uses
    FMain, Fbl, FAttrib, FExchange, FSound, FDepository,
      FBatList, FMuMagicOffer, FCharAttrib, FHistory, FMiniMap,
    FShowPopMsg, FGuild, FWearItem, FAuction, BackScrn, FQuest,
    FBillboardcharts, FQuantity, filepgkclass, energy,
    FEmporia, FnewMagic,  FNEWHailFellow, FSearch, FConfirmDialog,
    FBottom
    {$IFDEF gm}

    {$ENDIF}
    , Fhelp_htm, FPassEtc;
{$R *.dfm}

{ TTFormChat }

procedure TFrmChat.FormCreate(Sender:TObject);
begin
    FrmM.AddA2Form(Self, A2form);

    //世界频道
    temping := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('操作界面_世界频道_弹起.bmp', temping);
    Button_world_choose.A2Up := temping;
    pgkBmp.getBmp('操作界面_世界频道_按下.bmp', temping);
    Button_world_choose.A2Down := temping;
    pgkBmp.getBmp('操作界面_世界频道_鼠标.bmp', temping);
    Button_world_choose.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_世界频道_禁止.bmp', temping);
    Button_world_choose.A2NotEnabled := temping;
    Button_world_choose.Left := 0;
    Button_world_choose.Top := 95;
    Button_world_choose.Width := 52;
    Button_world_choose.Height := 19;
    //地图频道
    pgkBmp.getBmp('操作界面_地图频道_弹起.bmp', temping);
    Button_Map_choose.A2Up := temping;
    pgkBmp.getBmp('操作界面_地图频道_按下.bmp', temping);
    Button_Map_choose.A2Down := temping;
    pgkBmp.getBmp('操作界面_地图频道_鼠标.bmp', temping);
    Button_Map_choose.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_地图频道_禁止.bmp', temping);
    Button_Map_choose.A2NotEnabled := temping;
    Button_Map_choose.Left := 0;
    Button_Map_choose.Top := 76;
    Button_Map_choose.Width := 52;
    Button_Map_choose.Height := 19;
    //门派频道
    pgkBmp.getBmp('操作界面_门派频道_弹起.bmp', temping);
    Button_guild_choose.A2Up := temping;
    pgkBmp.getBmp('操作界面_门派频道_按下.bmp', temping);
    Button_guild_choose.A2Down := temping;
    pgkBmp.getBmp('操作界面_门派频道_鼠标.bmp', temping);
    Button_guild_choose.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_门派频道_禁止.bmp', temping);
    Button_guild_choose.A2NotEnabled := temping;
    Button_guild_choose.Left := 0;
    Button_guild_choose.Top := 57;
    Button_guild_choose.Width := 52;
    Button_guild_choose.Height := 19;
    //队伍频道
    pgkBmp.getBmp('操作界面_队伍频道_弹起.bmp', temping);
    Button_procession_choose.A2Up := temping;
    pgkBmp.getBmp('操作界面_队伍频道_按下.bmp', temping);
    Button_procession_choose.A2Down := temping;
    pgkBmp.getBmp('操作界面_队伍频道_鼠标.bmp', temping);
    Button_procession_choose.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_队伍频道_禁止.bmp', temping);
    Button_procession_choose.A2NotEnabled := temping;
    Button_procession_choose.Left := 0;
    Button_procession_choose.Top := 38;
    Button_procession_choose.Width := 52;
    Button_procession_choose.Height := 19;
    //纸条频道
    pgkBmp.getBmp('操作界面_纸条频道_弹起.bmp', temping);
    Button_scrip__choose.A2Up := temping;
    pgkBmp.getBmp('操作界面_纸条频道_按下.bmp', temping);
    Button_scrip__choose.A2Down := temping;
    pgkBmp.getBmp('操作界面_纸条频道_鼠标.bmp', temping);
    Button_scrip__choose.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_纸条频道_禁止.bmp', temping);
    Button_scrip__choose.A2NotEnabled := temping;
    Button_scrip__choose.Left := 0;
    Button_scrip__choose.Top := 19;
    Button_scrip__choose.Width := 52;
    Button_scrip__choose.Height := 19;
    //当前频道
    pgkBmp.getBmp('操作界面_当前频道_弹起.bmp', temping);
    Button_present_choose.A2Up := temping;
    pgkBmp.getBmp('操作界面_当前频道_按下.bmp', temping);
    Button_present_choose.A2Down := temping;
    pgkBmp.getBmp('操作界面_当前频道_鼠标.bmp', temping);
    Button_present_choose.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_当前频道_禁止.bmp', temping);
    Button_present_choose.A2NotEnabled := temping;
    Button_present_choose.Left := 0;
    Button_present_choose.Top := 0;
    Button_present_choose.Width := 52;
    Button_present_choose.Height := 19;
end;

procedure TFrmChat.FormDestroy(Sender:TObject);
begin
    //
    temping.Free;
end;

procedure TFrmChat.Button_present_chooseClick(Sender:TObject);
begin
    FrmChat.Visible := false;
    FrmBottom.Editchannel.Caption := '当前';
    FrmBottom.EdChat.Text := '';
end;

procedure TFrmChat.Button_guild_chooseClick(Sender:TObject);
begin
    FrmChat.Visible := false;
    FrmBottom.Editchannel.Caption := '门派';
    FrmBottom.EdChat.Text := '!!';
    FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
end;

procedure TFrmChat.Button_Map_chooseClick(Sender:TObject);
begin
    FrmChat.Visible := false;
    FrmBottom.Editchannel.Caption := '地图';
    FrmBottom.EdChat.Text := '@地图' + ' ';
    FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
end;

procedure TFrmChat.Button_procession_chooseClick(Sender:TObject);
begin
    FrmChat.Visible := false;
    FrmBottom.Editchannel.Caption := '队伍';
    FrmBottom.EdChat.Text := '~';
    FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
end;

procedure TFrmChat.Button_scrip__chooseClick(Sender:TObject);
begin
    FrmChat.Visible := false;
    FrmBottom.Editchannel.Caption := '纸条';
    FrmBottom.EdChat.Text := '@纸条' + ' ';
    FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
end;

procedure TFrmChat.Button_world_chooseClick(Sender:TObject);
begin
    FrmChat.Visible := false;
    FrmBottom.Editchannel.Caption := '世界';
    FrmBottom.EdChat.Text := '!';
    FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
end;

end.

