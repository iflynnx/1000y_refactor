unit AuctionBuy;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, Deftype;

type
    Tnewmaxtimestate = (ntstime1, ntstime2, ntstime3);
    TnewGoldestate = (ngsGold, ngsGoldMoney);
    TAuctionBuytype = (abtBuy, abtSell);
    TfrmAuctionBuy = class(TForm)
        A2Form: TA2Form;
        A2ListBox1: TA2ListBox;
        A2Button3: TA2Button;
        A2Button1: TA2Button;
        A2ILabelbuyitemprice: TA2ILabel;
        A2ILabelbuyItem: TA2ILabel;
        A2ILabelbuyitemrenname: TA2ILabel;
        A2ILabelbuyitemcount: TA2ILabel;
        Panel_buy: TPanel;
        Panel_sell: TPanel;
        A2ILabelNEWitem: TA2ILabel;
        A2EditPrice: TA2Edit;
        A2ButtonGold: TA2Button;
        A2ButtonGoldMoney: TA2Button;
        A2Buttontime1: TA2Button;
        A2Buttontime2: TA2Button;
        A2Buttontime3: TA2Button;
        A2Button10: TA2Button;
        A2Button11: TA2Button;
        Image_Ok: TImage;
        Image_no: TImage;
        A2ILabenewback: TA2ILabel;
        A2ILabelBuyback: TA2ILabel;
        A2Buttonbuygold: TA2ILabel;
        A2Buttonbuymoney: TA2ILabel;
        A2Buttonbuy_close: TA2Button;
        A2Buttonsell_close: TA2Button;
        A2ILabelitemname: TA2Label;
        A2ILabelitemCount: TA2Label;
    A2ILabeldecPrice: TA2Label;
    A2ILabelbuyitemname: TA2Label;
        procedure FormCreate(Sender: TObject);
        procedure A2ILabelNEWitemDragDrop(Sender, Source: TObject; X, Y: Integer);
        procedure A2Button11Click(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure A2ILabelNEWitemDragOver(Sender, Source: TObject; X,
            Y: Integer; State: TDragState; var Accept: Boolean);
        procedure A2Buttontime1Click(Sender: TObject);
        procedure A2Buttontime2Click(Sender: TObject);
        procedure A2Buttontime3Click(Sender: TObject);
        procedure A2ButtonGoldClick(Sender: TObject);
        procedure A2ButtonGoldMoneyClick(Sender: TObject);
        procedure A2EditPriceChange(Sender: TObject);
        procedure A2Button1Click(Sender: TObject);
        procedure A2Button3Click(Sender: TObject);
        procedure A2Button10Click(Sender: TObject);
        procedure A2Buttonbuy_closeClick(Sender: TObject);
        procedure A2Buttonsell_closeClick(Sender: TObject);
        procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2ILabelbuyItemMouseMove(Sender: TObject; Shift: TShiftState;
            X, Y: Integer);
        procedure A2Button1MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
    private
        { Private declarations }
    public
        { Public declarations }
        atype: TAuctionBuytype;
        FOKTA2Image: TA2Image;                                                  //图片
        FNoTA2Image: TA2Image;                                                  //图片
        Fnewmaxtimestate: Tnewmaxtimestate;
        FnewGoldestate: TnewGoldestate;
        FNEWItemKey: integer;                                                   //物品 背包 位置
        FNEWItemKeyCount: integer;                                              //数量
        FNEWitemTA2Image: TA2Image;                                             //图片

        backnewTA2Image: TA2Image;                                              //图片
        backBuyTA2Image: TA2Image;                                              //图片

        FbuyGoldestate: TnewGoldestate;
        FBUyitemTA2Image: TA2Image;                                             //图片
        FBUYAuctionID: integer;
        procedure ShowVisible(temptype: TAuctionBuytype);
        procedure NEWitemClear();
        procedure NEWitemDraw();
        procedure newmaxtimestate(atemp: Tnewmaxtimestate);
        procedure newGoldstate(atemp: TnewGoldestate);
        procedure SendConsignment(aitemkey, aitemkeycount, aprice, amaxtime, agoldtype: integer);

        procedure buygoldtypestate(atemp: TnewGoldestate);
        procedure BUYitemClear();
        procedure BUYitemset(gid: integer);
        procedure buyitemDraw(pp: pointer);
        procedure SendBuy(aid: integer);

        procedure SetNewVersion;
        //procedure SetOldVersion;
    end;

var
    frmAuctionBuy: TfrmAuctionBuy;

implementation

uses FMain, FAttrib, Fbl, AUtil32, AtzCls, cltype, uAnsTick, CharCls, FBottom, FQuantity,
    FAuction, filepgkclass;

{$R *.dfm}

procedure TfrmAuctionBuy.SetNewVersion;
var
    temping: TA2Image;
begin
    FNEWitemTA2Image := TA2Image.Create(32, 32, 0, 0);
    A2ILabelNEWitem.A2Image := FNEWitemTA2Image;

    backnewTA2Image := TA2Image.Create(32, 32, 0, 0);                           //图片
    pgkBmp.getBmp('寄售窗口.bmp', backnewTA2Image);
    backBuyTA2Image := TA2Image.Create(32, 32, 0, 0);                           //图片
    pgkBmp.getBmp('购买窗口.bmp', backBuyTA2Image);
    A2ILabenewback.A2Image := backnewTA2Image;
    A2ILabelBuyback.A2Image := backBuyTA2Image;

    FBUyitemTA2Image := TA2Image.Create(32, 32, 0, 0);                          //图片
    A2ILabelbuyItem.A2Image := FBUyitemTA2Image;

    FNoTA2Image := TA2Image.Create(32, 32, 0, 0);                               //图片
    FOKTA2Image := TA2Image.Create(32, 32, 0, 0);                               //图片
    temping := TA2Image.Create(36, 36, 0, 0);
    try
        //购买
        A2ILabelbuyItem.Left := 37;
        A2ILabelbuyItem.Top := 45;
        A2ILabelbuyItem.Width := 36;
        A2ILabelbuyItem.Height := 36;

        A2ILabelbuyitemname.Left := 101;
        A2ILabelbuyitemname.Top := 54;
        A2ILabelbuyitemname.Width := 106;
        A2ILabelbuyitemname.Height := 15;

        A2ILabelbuyitemcount.Left := 101;
        A2ILabelbuyitemcount.Top := 118;
        A2ILabelbuyitemcount.Width := 106;
        A2ILabelbuyitemcount.Height := 15;

        A2ILabelbuyitemprice.Left := 101;
        A2ILabelbuyitemprice.Top := 146;
        A2ILabelbuyitemprice.Width := 106;
        A2ILabelbuyitemprice.Height := 15;

        A2ILabelbuyitemrenname.Left := 101;
        A2ILabelbuyitemrenname.Top := 175;
        A2ILabelbuyitemrenname.Width := 106;
        A2ILabelbuyitemrenname.Height := 15;

        A2ListBox1.Left := 23;
        A2ListBox1.Top := 199;
        A2ListBox1.Width := 204;
        A2ListBox1.Height := 62;

        pgkBmp.getBmp('购买物品_确认购买_弹起.bmp', temping);
        A2Button1.A2Up := temping;
        pgkBmp.getBmp('购买物品_确认购买_按下.bmp', temping);
        A2Button1.A2Down := temping;
        pgkBmp.getBmp('购买物品_确认购买_鼠标.bmp', temping);
        A2Button1.A2Mouse := temping;
        pgkBmp.getBmp('购买物品_确认购买_禁止.bmp', temping);
        A2Button1.A2NotEnabled := temping;
        A2Button1.Left := 108;
        A2Button1.Top := 265;
        A2Button1.Width := 56;
        A2Button1.Height := 22;

        pgkBmp.getBmp('通用_取消_弹起.bmp', temping);
        A2Button3.A2Up := temping;
        pgkBmp.getBmp('通用_取消_按下.bmp', temping);
        A2Button3.A2Down := temping;
        pgkBmp.getBmp('通用_取消_鼠标.bmp', temping);
        A2Button3.A2Mouse := temping;
        pgkBmp.getBmp('通用_取消_禁止.bmp', temping);
        A2Button3.A2NotEnabled := temping;
        A2Button3.Left := 169;
        A2Button3.Top := 265;
        A2Button3.Width := 56;
        A2Button3.Height := 22;

        pgkBmp.getBmp('寄售系统_空白.bmp', FNoTA2Image);
        A2Buttonbuygold.A2Image := FNoTA2Image;
        pgkBmp.getBmp('寄售系统_打勾.bmp', FOKTA2Image);
        A2Buttonbuygold.A2Image := FOKTA2Image;
        A2Buttonbuygold.Left := 95;
        A2Buttonbuygold.Top := 89;

        pgkBmp.getBmp('寄售系统_空白.bmp', FNoTA2Image);
        A2Buttonbuymoney.A2Image := FNoTA2Image;
        pgkBmp.getBmp('寄售系统_打勾.bmp', FOKTA2Image);
        A2Buttonbuymoney.A2Image := FOKTA2Image;
        A2Buttonbuymoney.Left := 154;
        A2Buttonbuymoney.Top := 89;

        A2Buttonbuy_close.Left := 210;
        A2Buttonbuy_close.Top := 9;
        A2Buttonbuy_close.Width := 17;
        A2Buttonbuy_close.Height := 17;
        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
        A2Buttonbuy_close.A2Up := temping;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
        A2Buttonbuy_close.A2Down := temping;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
        A2Buttonbuy_close.A2Mouse := temping;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
        A2Buttonbuy_close.A2NotEnabled := temping;
        A2Buttonbuy_close.Caption := '';
        A2Buttonbuy_close.Visible := true;

        //寄售
        pgkBmp.getBmp('寄售物品_确认寄售_弹起.bmp', temping);
        A2Button11.A2Up := temping;
        pgkBmp.getBmp('寄售物品_确认寄售_按下.bmp', temping);
        A2Button11.A2Down := temping;
        pgkBmp.getBmp('寄售物品_确认寄售_鼠标.bmp', temping);
        A2Button11.A2Mouse := temping;
        pgkBmp.getBmp('寄售物品_确认寄售_禁止.bmp', temping);
        A2Button11.A2NotEnabled := temping;
        A2Button11.Left := 108;
        A2Button11.Top := 265;
        A2Button11.Width := 56;
        A2Button11.Height := 22;

        pgkBmp.getBmp('通用_取消_弹起.bmp', temping);
        A2Button10.A2Up := temping;
        pgkBmp.getBmp('通用_取消_按下.bmp', temping);
        A2Button10.A2Down := temping;
        pgkBmp.getBmp('通用_取消_鼠标.bmp', temping);
        A2Button10.A2Mouse := temping;
        pgkBmp.getBmp('通用_取消_禁止.bmp', temping);
        A2Button10.A2NotEnabled := temping;
        A2Button10.Left := 169;
        A2Button10.Top := 265;
        A2Button10.Width := 56;
        A2Button10.Height := 22;

        A2ILabelNEWitem.Left := 37;
        A2ILabelNEWitem.Top := 45;
        A2ILabelNEWitem.Width := 32;
        A2ILabelNEWitem.Height := 32;

        A2ILabelitemname.Left := 101;
        A2ILabelitemname.Top := 54;
        A2ILabelitemname.Width := 106;
        A2ILabelitemname.Height := 15;

        A2ILabelitemCount.Left := 101;
        A2ILabelitemCount.Top := 118;
        A2ILabelitemCount.Width := 106;
        A2ILabelitemCount.Height := 15;

        A2EditPrice.Left := 101;
        A2EditPrice.Top := 146;
        A2EditPrice.Width := 106;
        A2EditPrice.Height := 15;

        A2ILabeldecPrice.Left := 101;
        A2ILabeldecPrice.Top := 238;
        A2ILabeldecPrice.Width := 106;
        A2ILabeldecPrice.Height := 15;

        pgkBmp.getBmp('寄售系统_空白.bmp', temping);
        A2ButtonGold.A2Up := temping;
        pgkBmp.getBmp('寄售系统_打勾.bmp', temping);
        A2ButtonGold.A2Down := temping;
        A2ButtonGold.Left := 97;
        A2ButtonGold.Top := 91;

        pgkBmp.getBmp('寄售系统_空白.bmp', temping);
        A2ButtonGoldMoney.A2Up := temping;
        pgkBmp.getBmp('寄售系统_打勾.bmp', temping);
        A2ButtonGoldMoney.A2Down := temping;
        A2ButtonGoldMoney.Left := 158;
        A2ButtonGoldMoney.Top := 91;

        pgkBmp.getBmp('寄售系统_空白.bmp', temping);
        A2Buttontime1.A2Up := temping;
        pgkBmp.getBmp('寄售系统_打勾.bmp', temping);
        A2Buttontime1.A2Down := temping;
        A2Buttontime1.Left := 29;
        A2Buttontime1.Top := 205;

        pgkBmp.getBmp('寄售系统_空白.bmp', temping);
        A2Buttontime2.A2Up := temping;
        pgkBmp.getBmp('寄售系统_打勾.bmp', temping);
        A2Buttontime2.A2Down := temping;
        A2Buttontime2.Left := 97;
        A2Buttontime2.Top := 205;

        pgkBmp.getBmp('寄售系统_空白.bmp', temping);
        A2Buttontime3.A2Up := temping;
        pgkBmp.getBmp('寄售系统_打勾.bmp', temping);
        A2Buttontime3.A2Down := temping;
        A2Buttontime3.Left := 166;
        A2Buttontime3.Top := 205;

        A2Buttonsell_close.Left := 210;
        A2Buttonsell_close.Top := 9;
        A2Buttonsell_close.Width := 17;
        A2Buttonsell_close.Height := 17;
        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
        A2Buttonsell_close.A2Up := temping;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
        A2Buttonsell_close.A2Down := temping;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
        A2Buttonsell_close.A2Mouse := temping;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
        A2Buttonsell_close.A2NotEnabled := temping;
        A2Buttonsell_close.Caption := '';
        A2Buttonsell_close.Visible := true;
    finally
        temping.Free;
    end;

end;

//procedure TfrmAuctionBuy.SetOldVersion;
//begin
//    FNEWitemTA2Image := TA2Image.Create(32, 32, 0, 0);
//    A2ILabelNEWitem.A2Image := FNEWitemTA2Image;
//    FOKTA2Image := TA2Image.Create(32, 32, 0, 0);                               //图片
//    FOKTA2Image.LoadFromBitmap(Image_Ok.Picture.Bitmap);
//    FNoTA2Image := TA2Image.Create(32, 32, 0, 0);                               //图片
//    FNoTA2Image.LoadFromBitmap(Image_NO.Picture.Bitmap);
//    backnewTA2Image := TA2Image.Create(32, 32, 0, 0);                           //图片
//    //backnewTA2Image.LoadFromFile('Auctionsell.bmp');
//    pgkBmp.getBmp('Auctionsell.bmp', backnewTA2Image);
//    backBuyTA2Image := TA2Image.Create(32, 32, 0, 0);                           //图片
//    //backBuyTA2Image.LoadFromFile('Auctionbuy.bmp');
//    pgkBmp.getBmp('Auctionbuy.bmp', backBuyTA2Image);
//    A2ILabenewback.A2Image := backnewTA2Image;
//    A2ILabelBuyback.A2Image := backBuyTA2Image;
//
//    FBUyitemTA2Image := TA2Image.Create(32, 32, 0, 0);                          //图片
//    A2ILabelbuyItem.A2Image := FBUyitemTA2Image;
//end;

procedure TfrmAuctionBuy.FormCreate(Sender: TObject);
begin
    FrmM.AddA2Form(Self, A2Form);
    if WinVerType = wvtnew then
    begin
        SetNewVersion;
//    end
//    else
//    begin
//        SetOldVersion;
    end;
    A2ILabelNEWitem.Transparent := true;
end;

procedure TfrmAuctionBuy.FormDestroy(Sender: TObject);
begin
    FNEWitemTA2Image.Free;

    FOKTA2Image.Free;
    FNoTA2Image.Free;
    backnewTA2Image.Free;
    backBuyTA2Image.Free;

    FBUyitemTA2Image.Free;
end;

procedure TfrmAuctionBuy.ShowVisible(temptype: TAuctionBuytype);
begin
    Visible := true;

    FrmM.SetA2Form(self, A2form);
    FrmM.move_win_form_Align(frmAuctionBuy, mwfCenter);
    atype := temptype;
    if atype = abtBuy then
    begin
        Panel_buy.Visible := true;
        Panel_sell.Visible := not Panel_buy.Visible;
    end else
    begin

        Panel_buy.Visible := false;
        Panel_sell.Visible := not Panel_buy.Visible;
        newitemClear;
    end;
end;

procedure TfrmAuctionBuy.BUYitemset(gid: integer);
var
    pp: Tlistdata;
begin
    FBUYAuctionID := -1;
    pp := frmAuction.Itemnamelist.Get(gid);
    if pp = nil then
    begin
        Visible := false;
        exit;
    end;
    FBUYAuctionID := pp.rid;
    A2ILabelbuyitemname.Caption := pp.ritem.rViewName;

    A2ILabelbuyitemcount.Caption := inttostr(pp.ritem.rCount);
    A2ILabelbuyitemprice.Caption := inttostr(pp.rPrice);
    A2ILabelbuyitemrenname.Caption := pp.rBargainorName;

//    A2ListBox1.StringList.Text := TItemDataToStr(pp.ritem);
    A2ListBox1.AddItem(pp.ritem.rViewName);

    A2ListBox1.DrawItem;
    if pp.rPricetype = 1 then buygoldtypestate(ngsGoldMoney);
    if pp.rPricetype = 0 then buygoldtypestate(ngsGold);
    buyitemDraw(pp);
end;

procedure TfrmAuctionBuy.buyitemDraw(pp: pointer);
var
    FGreenCol, FGreenAdd: integer;
    tt: TA2Image;
begin

    FBUyitemTA2Image.Clear(0);

    tt := AtzClass.GetItemImage(Tlistdata(pp).rItem.rShape);
    if tt <> nil then
    begin
        FBUyitemTA2Image.Resize(32, 32);
        GetGreenColorAndAdd(Tlistdata(pp).ritem.rcolor, FGreenCol, FGreenAdd);
        if FGreenCol = 0 then
            FBUyitemTA2Image.DrawImage(tt, 0, 0, TRUE)
        else
            FBUyitemTA2Image.DrawImageGreenConvert(tt, 0, 0, FGreenCol, FGreenAdd);
        FBUyitemTA2Image.Optimize;
    end;
    A2ILabelbuyItem.A2Image := FBUyitemTA2Image;
end;

procedure TfrmAuctionBuy.BUYitemClear();
begin
    A2ILabelbuyitemname.Caption := '';
    FBUyitemTA2Image.Clear(0);
    A2ILabelbuyItem.Caption := '';
    A2ILabelbuyItem.Hint := '';
    A2ILabelbuyitemcount.Caption := '0';
    A2ILabelbuyitemprice.Caption := '0';
    A2ILabelbuyitemrenname.Caption := '';
    A2ListBox1.Clear;
    buygoldtypestate(ngsGold);
    A2ILabelbuyItem.A2Image := FBUyitemTA2Image;
end;

procedure TfrmAuctionBuy.buygoldtypestate(atemp: TnewGoldestate);
begin
    FbuyGoldestate := atemp;
    A2Buttonbuygold.A2Image := FNoTA2Image;
    A2Buttonbuymoney.A2Image := FNoTA2Image;

    if FbuyGoldestate = ngsGold then
        A2Buttonbuygold.A2Image := FOKTA2Image;
    if FbuyGoldestate = ngsGoldMoney then
        A2Buttonbuymoney.A2Image := FOKTA2Image;
end;

procedure TfrmAuctionBuy.newmaxtimestate(atemp: Tnewmaxtimestate);
begin
    Fnewmaxtimestate := atemp;
    A2Buttontime1.A2Up := FNoTA2Image;
    A2Buttontime2.A2Up := FNoTA2Image;
    A2Buttontime3.A2Up := FNoTA2Image;
    A2Buttontime1.A2Down := FNoTA2Image;
    A2Buttontime2.A2Down := FNoTA2Image;
    A2Buttontime3.A2Down := FNoTA2Image;
    if Fnewmaxtimestate = ntstime1 then
    begin
        A2Buttontime1.A2Up := FOkTA2Image;
    end;
    if Fnewmaxtimestate = ntstime2 then
    begin
        A2Buttontime2.A2Up := FOkTA2Image;
    end;
    if Fnewmaxtimestate = ntstime3 then
    begin
        A2Buttontime3.A2Up := FOkTA2Image;
    end;
end;

procedure TfrmAuctionBuy.newGoldstate(atemp: TnewGoldestate);
begin
    FnewGoldestate := atemp;
    A2ButtonGold.A2Up := FNoTA2Image;
    A2ButtonGoldMoney.A2Up := FNoTA2Image;
    A2ButtonGold.A2Down := FNoTA2Image;
    A2ButtonGoldMoney.A2Down := FNoTA2Image;
    if FnewGoldestate = ngsGold then
        A2ButtonGold.A2Up := FOKTA2Image;
    if FnewGoldestate = ngsGoldMoney then
        A2ButtonGoldMoney.A2Up := FOKTA2Image;
end;

procedure TfrmAuctionBuy.newitemClear();
begin
    newmaxtimestate(ntstime1);
    newGoldstate(ngsGold);
    FNEWItemKey := -1;                                                          //物品 背包 位置
    FNEWItemKeyCount := 0;                                                      //数量
    FNEWitemTA2Image.Clear(0);                                                  //图片
    A2ILabelNEWitem.A2Image := FNEWitemTA2Image;
    A2ILabelitemname.Caption := '';
    A2ILabelitemCount.Caption := '';
    A2EditPrice.Text := '0';
    A2ILabeldecPrice.Caption := '0';
    A2ILabelNEWitem.Caption := '';
    A2ILabelNEWitem.Hint := '';
    A2ILabeldecPrice.Caption := inttostr(frmAuction.fpoundage);
end;

procedure TfrmAuctionBuy.NEWitemDraw();
var
    FGreenCol, FGreenAdd: integer;
    tt: TA2Image;
    temppTSHaveItem: PTItemdata;
begin
    A2ILabelitemCount.Caption := inttostr(FNEWItemKeyCount);
    FNEWitemTA2Image.Clear(0);
    temppTSHaveItem := HaveItemclass.getid(FNEWItemKey);
    if temppTSHaveItem = nil then exit;
    tt := AtzClass.GetItemImage(temppTSHaveItem.rShape);
    if tt <> nil then
    begin
        FNEWitemTA2Image.Resize(32, 32);
        GetGreenColorAndAdd(temppTSHaveItem.rColor, FGreenCol, FGreenAdd);
        if FGreenCol = 0 then
            FNEWitemTA2Image.DrawImage(tt, 0, 0, TRUE)
        else
            FNEWitemTA2Image.DrawImageGreenConvert(tt, 0, 0, FGreenCol, FGreenAdd);
        FNEWitemTA2Image.Optimize;

    end;
    A2ILabelNEWitem.A2Image := FNEWitemTA2Image;
end;

procedure TfrmAuctionBuy.A2ILabelNEWitemDragDrop(Sender, Source: TObject; X,
    Y: Integer);
var
    tp: TDragItem;
    sourceid: integer;
    tt: PTItemdata;
begin
    if Source = nil then exit;

    tp := pointer(Source);
    case tp.SourceID of
        WINDOW_ITEMS:
            begin
                newitemClear;
                sourceid := tp.Selected;
                tt := HaveItemclass.getid(sourceid);
                if tt = nil then
                begin
                    FrmBottom.AddChat('错误！无此种物品', WinRGB(22, 22, 0), 0);
                    exit;
                end;
                FNEWItemKey := sourceid;
                FNEWItemKeyCount := 0;
                A2ILabelitemname.Caption := tt.rViewName;
                A2ILabelitemCount.Caption := inttostr(FNEWItemKeyCount);
                A2EditPrice.Text := '0';
                A2ILabeldecPrice.Caption := inttostr(frmAuction.fpoundage);

                NEWitemDraw;
                if tt.rCount > 10000 then FrmQuantity.CountMax := 10000
                else FrmQuantity.CountMax := tt.rCount;

                FrmQuantity.Visible := true;
                FrmQuantity.ShowType := SH_NewAuction;

                FrmQuantity.LbCountName.Caption := (Tt.rViewName);
                FrmQuantity.EdCount.Text := IntToStr(tt.rCount);
                FrmQuantity.EdCount.SetFocus;
                FrmQuantity.EdCount.SelectAll;
                FrmQuantity.BringToFront;
            end;

    end;
end;

procedure TfrmAuctionBuy.SendConsignment(aitemkey, aitemkeycount, aprice, amaxtime, agoldtype: integer);
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Auction);
    WordComData_ADDbyte(temp, Auction_Consignment);
    WordComData_ADDbyte(temp, aitemkey);
    WordComData_ADDword(temp, aitemkeycount);
    WordComData_ADDdword(temp, aprice);
    WordComData_ADDbyte(temp, amaxtime);
    WordComData_ADDbyte(temp, agoldtype);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmAuctionBuy.A2Button11Click(Sender: TObject);
var
    aprice, agoldtype, amaxtime: integer;
begin
    aprice := _StrToInt(A2EditPrice.Text);
    if aprice <= 0 then
    begin
        FrmBottom.AddChat('价格不能为零。', WinRGB(22, 22, 0), 0);
        exit;
    end;

    case Fnewmaxtimestate of
        ntstime1: amaxtime := 24;
        ntstime2: amaxtime := 24*3;
        ntstime3: amaxtime := 24*7;
    else exit;
    end;
    if FnewGoldestate = ngsGold then agoldtype := 0;
    if FnewGoldestate = ngsGoldMoney then agoldtype := 1;

    if amaxtime <= 0 then
    begin
        FrmBottom.AddChat('时间不能为零小时。', WinRGB(22, 22, 0), 0);
        exit;
    end;
    if amaxtime > 24*7 then
    begin
        FrmBottom.AddChat('时间不能超过一周。', WinRGB(22, 22, 0), 0);
        exit;
    end;
    if FNEWItemKeyCount <= 0 then
    begin
        FrmBottom.AddChat('物品数量不能为零。', WinRGB(22, 22, 0), 0);
        exit;
    end;
    if FNEWItemKey < 0 then
    begin
        FrmBottom.AddChat('你还没发布物品。', WinRGB(22, 22, 0), 0);
        exit;
    end;

    SendConsignment(FNEWItemKey, FNEWItemKeyCount, aprice, amaxtime, agoldtype);
    frmAuction.newAuction;
    Visible := false;
end;

procedure TfrmAuctionBuy.A2ILabelNEWitemDragOver(Sender, Source: TObject;
    X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := FALSE;
    if Source <> nil then
    begin
        with Source as TDragItem do
        begin
            case SourceID of
                WINDOW_ITEMS: Accept := TRUE;
            end;

        end;
    end;
end;

procedure TfrmAuctionBuy.A2Buttontime1Click(Sender: TObject);
begin
    newmaxtimestate(ntstime1);
end;

procedure TfrmAuctionBuy.A2Buttontime2Click(Sender: TObject);
begin
    newmaxtimestate(ntstime2);
end;

procedure TfrmAuctionBuy.A2Buttontime3Click(Sender: TObject);
begin
    newmaxtimestate(ntstime3);
end;

procedure TfrmAuctionBuy.A2ButtonGoldClick(Sender: TObject);
begin
    newGoldstate(ngsGold);
end;

procedure TfrmAuctionBuy.A2ButtonGoldMoneyClick(Sender: TObject);
begin
    newGoldstate(ngsGoldMoney);
end;

procedure TfrmAuctionBuy.A2EditPriceChange(Sender: TObject);
var
    i: integer;
begin
    A2EditPrice.Text := trim(A2EditPrice.Text);
    i := _StrToInt(A2EditPrice.Text);
    if i > 0 then
        A2EditPrice.Text := inttostr(i);
end;

procedure TfrmAuctionBuy.SendBuy(aid: integer);
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Auction);
    WordComData_ADDbyte(temp, Auction_buy);
    WordComData_ADDdword(temp, aid);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmAuctionBuy.A2Button1Click(Sender: TObject);
begin
    if FBUYAuctionID > 0 then
    begin
        SendBuy(FBUYAuctionID);
        A2Button3Click(Sender);
    end;
end;

procedure TfrmAuctionBuy.A2Button3Click(Sender: TObject);
begin
    NEWitemClear;
    BUYitemClear;
    Visible := false;
end;

procedure TfrmAuctionBuy.A2Button10Click(Sender: TObject);
begin
    NEWitemClear;
    BUYitemClear;
    Visible := false;
end;

procedure TfrmAuctionBuy.A2Buttonbuy_closeClick(Sender: TObject);
begin
    Visible := false;
end;

procedure TfrmAuctionBuy.A2Buttonsell_closeClick(Sender: TObject);
begin
    Visible := false;
end;

procedure TfrmAuctionBuy.FormMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmAuctionBuy.A2ILabelbuyItemMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
var
    pp: Tlistdata;
begin
    pp := frmAuction.Itemnamelist.Get(FBUYAuctionID);
    if pp = nil then
    begin
        GameHint.Close;
        exit;
    end;
    GameHint.settext(integer(Sender), TItemDataToStr(pp.ritem));
end;

procedure TfrmAuctionBuy.A2Button1MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

end.

