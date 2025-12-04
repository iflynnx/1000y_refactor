unit FProcessionButton;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, A2Form, ExtCtrls, A2img;

type
    TfrmProcessionButton = class(TForm)
        A2ButtonClose:TA2Button;
        A2Buttonadd:TA2Button;
        A2ButtonHeadmanid:TA2Button;
        A2ButtonDel:TA2Button;
        A2ButtonExit:TA2Button;
        A2Buttondisband:TA2Button;
        A2Form:TA2Form;
        procedure FormCreate(Sender:TObject);
        procedure FormDestroy(Sender:TObject);
        procedure A2ButtonaddClick(Sender:TObject);
        procedure A2ButtonCloseClick(Sender:TObject);
        procedure A2ButtondisbandClick(Sender:TObject);
        procedure A2ButtonExitClick(Sender:TObject);
        procedure A2ButtonHeadmanidClick(Sender:TObject);
        procedure A2ButtonDelClick(Sender:TObject);
    private
        { Private declarations }
    public
        { Public declarations }
        procedure SetNewVersion;
       // procedure SetOldVersion;
    end;

var
    frmProcessionButton:TfrmProcessionButton;

implementation

uses FMain, FProcession, FBottom, FProcessionList, filepgkclass;

{$R *.dfm}

procedure TfrmProcessionButton.SetNewVersion;
var
    temping         :TA2Image;
begin
    temping := TA2Image.Create(32, 32, 0, 0);
    try
        pgkBmp.getBmp('队伍控制底框.bmp', A2Form.FImageSurface);
        a2form.boImagesurface := true;

        pgkBmp.getBmp('玩家交互_退出队伍_弹起.bmp', temping);
        A2ButtonExit.A2Up := temping;
        pgkBmp.getBmp('玩家交互_退出队伍_按下.bmp', temping);
        A2ButtonExit.A2Down := temping;
        pgkBmp.getBmp('玩家交互_退出队伍_鼠标.bmp', temping);
        A2ButtonExit.A2Mouse := temping;
        pgkBmp.getBmp('玩家交互_退出队伍_禁止.bmp', temping);
        A2ButtonExit.A2NotEnabled := temping;

        pgkBmp.getBmp('玩家交互_解散队伍_弹起.bmp', temping);
        A2Buttondisband.A2Up := temping;
        pgkBmp.getBmp('玩家交互_解散队伍_按下.bmp', temping);
        A2Buttondisband.A2Down := temping;
        pgkBmp.getBmp('玩家交互_解散队伍_鼠标.bmp', temping);
        A2Buttondisband.A2Mouse := temping;
        pgkBmp.getBmp('玩家交互_解散队伍_禁止.bmp', temping);
        A2Buttondisband.A2NotEnabled := temping;

        pgkBmp.getBmp('玩家交互_转移队长_弹起.bmp', temping);
        A2ButtonHeadmanid.A2Up := temping;
        pgkBmp.getBmp('玩家交互_转移队长_按下.bmp', temping);
        A2ButtonHeadmanid.A2Down := temping;
        pgkBmp.getBmp('玩家交互_转移队长_鼠标.bmp', temping);
        A2ButtonHeadmanid.A2Mouse := temping;
        pgkBmp.getBmp('玩家交互_转移队长_禁止.bmp', temping);
        A2ButtonHeadmanid.A2NotEnabled := temping;

        pgkBmp.getBmp('玩家交互_踢出队伍_弹起.bmp', temping);
        A2ButtonDel.A2Up := temping;
        pgkBmp.getBmp('玩家交互_踢出队伍_按下.bmp', temping);
        A2ButtonDel.A2Down := temping;
        pgkBmp.getBmp('玩家交互_踢出队伍_鼠标.bmp', temping);
        A2ButtonDel.A2Mouse := temping;
        pgkBmp.getBmp('玩家交互_踢出队伍_禁止.bmp', temping);
        A2ButtonDel.A2NotEnabled := temping;

        pgkBmp.getBmp('玩家交互_邀请加入_弹起.bmp', temping);
        A2Buttonadd.A2Up := temping;
        pgkBmp.getBmp('玩家交互_邀请加入_按下.bmp', temping);
        A2Buttonadd.A2Down := temping;
        pgkBmp.getBmp('玩家交互_邀请加入_鼠标.bmp', temping);
        A2Buttonadd.A2Mouse := temping;
        pgkBmp.getBmp('玩家交互_邀请加入_禁止.bmp', temping);
        A2Buttonadd.A2NotEnabled := temping;

        pgkBmp.getBmp('队伍控制_关闭_弹起.bmp', temping);
        A2ButtonClose.A2Up := temping;
        pgkBmp.getBmp('队伍控制_关闭_按下.bmp', temping);
        A2ButtonClose.A2Down := temping;
        pgkBmp.getBmp('队伍控制_关闭_鼠标.bmp', temping);
        A2ButtonClose.A2Mouse := temping;
        pgkBmp.getBmp('队伍控制_关闭_禁止.bmp', temping);
        A2ButtonClose.A2NotEnabled := temping;

    finally
        temping.Free;
    end;

end;

//procedure TfrmProcessionButton.SetOldVersion;
//begin
//    pgkBmp.getBmp('ProcessionButton.bmp', A2form.FImageSurface);
//    A2form.boImagesurface := true;
//end;

procedure TfrmProcessionButton.FormCreate(Sender:TObject);
begin
    FrmM.AddA2Form(Self, A2Form);
    if WinVerType = wvtNew then
    begin
        SetNewVersion;
//    end
//    else if WinVerType = wvtOld then
//    begin
//        SetOldVersion;
    end;
    //Parent := FrmM;
    Top := 30;
    Left := 0;
end;

procedure TfrmProcessionButton.FormDestroy(Sender:TObject);
begin
    //
end;

procedure TfrmProcessionButton.A2ButtonaddClick(Sender:TObject);
begin
    frmProcession.ButtonShowAdd;
    Visible := false;
end;

procedure TfrmProcessionButton.A2ButtonCloseClick(Sender:TObject);
begin
    Visible := false;
end;

procedure TfrmProcessionButton.A2ButtondisbandClick(Sender:TObject);
begin
    frmProcession.A2ButtondisbandClick(nil);
    Visible := false;
end;

procedure TfrmProcessionButton.A2ButtonExitClick(Sender:TObject);
begin
    frmProcession.A2ButtonExitClick(nil);
    Visible := false;
end;

procedure TfrmProcessionButton.A2ButtonHeadmanidClick(Sender:TObject);
begin
    frmProcession.Buttonheadman(frmProcessionList.FSELECTINDEX);
    Visible := false;
end;

procedure TfrmProcessionButton.A2ButtonDelClick(Sender:TObject);
begin
    frmProcession.Buttondel(frmProcessionList.FSELECTINDEX);
    Visible := false;
end;

end.

