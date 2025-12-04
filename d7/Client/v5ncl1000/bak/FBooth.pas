unit FBooth;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, A2Form, StdCtrls, ExtCtrls, A2img, cltype, deftype, CharCls,
    AUtil32, ClipBrd, FAttrib;

type
    TcBoothListClass = class
    private
        BoothArr: TBoothItemDataArr;
        function getPriceSum: int64;
    public
        constructor Create;
        destructor Destroy; override;
        procedure clear;
        procedure add(akey: integer; aitem: TBoothItemData);
        procedure upCount(akey, acount: integer);
        procedure del(akey: integer);
        function get(akey: integer): PTBoothItemData;
        function count: integer;
    end;
    bootFormlockstate = (bfls_lock, bfls_unlock);
    bootformstate = (bfs_edit, bfs_user);
    bootinputstate = (bis_edit_buy, bis_edit_sell, bis_user_buy, bis_user_sell);
    TFrmBooth = class(TForm)
        A2Form: TA2Form;
        A2ILabel0: TA2ILabel;
        A2ILabel1: TA2ILabel;
        A2ILabel2: TA2ILabel;
        A2ILabel3: TA2ILabel;
        A2ILabel4: TA2ILabel;
        A2ILabel5: TA2ILabel;
        A2ILabel6: TA2ILabel;
        A2ILabel7: TA2ILabel;
        A2ILabel8: TA2ILabel;
        A2ILabel9: TA2ILabel;
        A2ILabel10: TA2ILabel;
        A2ILabel11: TA2ILabel;
        A2ILabelS0: TA2ILabel;
        A2ILabelS1: TA2ILabel;
        A2ILabelS2: TA2ILabel;
        A2ILabelS3: TA2ILabel;
        A2ILabelS4: TA2ILabel;
        A2ILabelS5: TA2ILabel;
        A2ILabelS6: TA2ILabel;
        A2ILabelS7: TA2ILabel;
        A2ILabelS8: TA2ILabel;
        A2ILabelS9: TA2ILabel;
        A2ILabelS10: TA2ILabel;
        A2ILabelS11: TA2ILabel;
        A2ListBox_Message: TA2ListBox;
        A2Edit_AddMsg: TA2Edit;
        A2Button_MessageClear: TA2Button;
        A2Panel_Sell: TA2Panel;
        SellBackimg: TA2ILabel;
        A2ILabel_Sell_item: TA2ILabel;
        A2Label_Sell_Total: TA2Label;
        A2Edit_Sell_Count: TA2Edit;
        A2Edit_Sell_Price: TA2Edit;
        BtnCancel: TA2Button;
        BtnStartBooth: TA2Button;
        BtnCancelBooth: TA2Button;
        BtnClearBooth: TA2Button;
        BoothBackimg: TA2ILabel;
        BoothName: TA2Edit;
        A2Button_Message: TA2Button;
        BtnOK: TA2Button;
        BtnClose: TA2Button;
        LbBoothName: TA2Label;
        procedure FormCreate(Sender: TObject);
        procedure A2ILabel0DragDrop(Sender, Source: TObject; X, Y: Integer);
        procedure FormDestroy(Sender: TObject);
        procedure A2ILabel0DragOver(Sender, Source: TObject; X, Y: Integer;
            State: TDragState; var Accept: Boolean);
        procedure A2ILabel0MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure A2ILabel0MouseLeave(Sender: TObject);
        procedure A2ILabel0MouseEnter(Sender: TObject);
        procedure A2ILabel0MouseUp(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2Button_Sell_OKClick(Sender: TObject);
        procedure BtnStartBoothClick(Sender: TObject);
        procedure BtnCancelBoothClick(Sender: TObject);
        procedure A2Button_MessageClearClick(Sender: TObject);
        procedure BtnClearBoothClick(Sender: TObject);
        procedure A2Button_MessageClick(Sender: TObject);
        procedure BtnCloseClick(Sender: TObject);
        procedure A2Edit_Sell_PriceKeyPress(Sender: TObject; var Key: Char);
        procedure A2Edit_Sell_CountKeyPress(Sender: TObject; var Key: Char);
        procedure A2Edit_Sell_PriceChange(Sender: TObject);
        procedure A2ListBox_MessageClick(Sender: TObject);
        procedure A2ILabelS0Click(Sender: TObject);
        procedure A2ILabelS0DblClick(Sender: TObject);
        procedure A2ILabelS0DragDrop(Sender, Source: TObject; X, Y: Integer);
        procedure A2ILabelS0DragOver(Sender, Source: TObject; X, Y: Integer;
            State: TDragState; var Accept: Boolean);
        procedure A2ILabelS0MouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2ILabelS0MouseEnter(Sender: TObject);
        procedure A2ILabelS0MouseLeave(Sender: TObject);
        procedure A2ILabelS0MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure A2ILabelS0MouseUp(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2ILabel0MouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2ILabel0DblClick(Sender: TObject);
        procedure BoothBackimgMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure A2Edit_AddMsgMouseMove(Sender: TObject; Shift: TShiftState;
            X, Y: Integer);
        procedure A2ListBox_MessageMouseMove(Sender: TObject;
            Shift: TShiftState; X, Y: Integer);
        procedure A2Button_MessageClearMouseMove(Sender: TObject;
            Shift: TShiftState; X, Y: Integer);
        procedure SellBackimgMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure BtnCloseMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure A2ILabel_Sell_itemMouseMove(Sender: TObject;
            Shift: TShiftState; X, Y: Integer);
        procedure BoothBackimgMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure LbBoothNameMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure BtnCancelClick(Sender: TObject);
        procedure BoothNameMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
    private
        { Private declarations }
        A2ILabelArrBuy: array[0..11] of TA2ILabel;
        A2ILabelArrSell: array[0..11] of TA2ILabel;
        SellItemKeyArr: array[0..11] of integer;
        BuyItemKeyArr: array[0..11] of integer;

        procedure SetItemShape(Lb: TA2ILabel; aitem: pTItemData);
        procedure SetWindowState;

        procedure LockBooth;
        procedure UnLockBooth;

        procedure clear;
        procedure hintDraw(Sender: TObject; akey: integer; atype: bootinputstate);
        function CheckItem(akey: integer): boolean;
        function getMoneyCount: integer;
        function CheckWearItemExist(ahavekey: integer): boolean;
        procedure InputWindowClear;
        procedure InputWindowClose;
        procedure InputWindowOpen(ainputtype: bootinputstate; akey,
            ahavekey: integer);

    public
        { Public declarations }
        boothusername: string;
        ItemBackImg: TA2Image;
        CurState: bootformstate;
        CurWndState: bootFormlockstate;

        Inputtype: bootinputstate;
        InputKey, InputHaveKey: integer;


        procedure SendStartBooth;
        procedure SendStopBooth;
        procedure SendBuy(akey, acount: integer);
        procedure SendSell(akey, ahavekey, acount: integer);
        procedure SendMessage(astr: string);
        //procedure SendOpenWindow;
        //procedure SendCloseWindow;

        procedure MessageProcess(var code: TWordComData);

        procedure edit_Windows_Close;
        procedure edit_Windows_Open;
        procedure user_Windows_close;
        procedure user_Windows_Open(aname: string);

        procedure SendOpenWindowEdit;
        procedure SendCloseWindowEdit;
        procedure SendOpenWindowUser(aname: string);
        procedure SendCloseWindowUser;

        procedure onupitem(akey: integer; aitem: titemdata);
    end;

var
    FrmBooth: TFrmBooth;

    BuyShopItemList: TcBoothListClass;
    SellShopItemList: TcBoothListClass;

    BoothUserBuyList: TcItemListClass;
    BoothUserSellList: TcItemListClass;

implementation

uses FMain, filepgkclass, FBottom, FQuantity, Fbl;

{$R *.dfm}
{ TcBoothListClass }

procedure updatedraw;
var
    i: integer;
    tt: titemdata;
    temp: pTBoothItemData;
begin
    GameHint.Close;
    with FrmBooth do
    begin
        case CurState of
            bfs_edit:
                begin
                    for i := 0 to buyShopItemList.count - 1 do
                    begin
                        SetItemShape(A2ILabelArrbuy[i], nil);
                        temp := buyShopItemList.get(i);
                        if temp = nil then Continue;
                        tt := HaveItemclass.get(temp.rKey);
                        if tt.rName = '' then Continue;
                        SetItemShape(A2ILabelArrbuy[i], @tt);
                    end;
                    for i := 0 to sellShopItemList.count - 1 do
                    begin
                        SetItemShape(A2ILabelArrsell[i], nil);
                        temp := sellShopItemList.get(i);
                        if temp = nil then Continue;
                        tt := HaveItemclass.get(temp.rKey);
                        if tt.rName = '' then Continue;
                        SetItemShape(A2ILabelArrsell[i], @tt);
                    end;
                end;
            bfs_user:
                begin
                    for i := 0 to BoothUserBuyList.count - 1 do
                    begin
                        SetItemShape(A2ILabelArrbuy[i], nil);
                        tt := BoothUserBuyList.get(i);
                        if tt.rName = '' then Continue;
                        SetItemShape(A2ILabelArrbuy[i], @tt);

                    end;
                    for i := 0 to BoothUserSellList.count - 1 do
                    begin
                        SetItemShape(A2ILabelArrsell[i], nil);
                        tt := BoothUserSellList.get(i);
                        if tt.rName = '' then Continue;
                        SetItemShape(A2ILabelArrsell[i], @tt);

                    end;
                end;
        end;
    end;
end;

function TcBoothListClass.getPriceSum(): int64;
var
    i: integer;
begin
    result := 0;
    for i := 0 to high(bootharr) do
    begin
        if bootharr[i].rKey = 255 then Continue;
        result := result + bootharr[i].rPrice * bootharr[i].rCount;
    end;

end;

procedure TcBoothListClass.add(akey: integer; aitem: TBoothItemData);
begin
    if (akey < 0) or (akey > high(bootharr)) then exit;
    bootharr[akey] := aitem;
    updatedraw;
end;

procedure TcBoothListClass.upCount(akey, acount: integer);
begin
    if (akey < 0) or (akey > high(bootharr)) then exit;
    BoothArr[akey].rCount := acount;
    updatedraw;
end;

procedure TcBoothListClass.clear;
begin
    FillChar(BoothArr, sizeof(BoothArr), 255);
    updatedraw;
end;

constructor TcBoothListClass.Create;
begin

end;

destructor TcBoothListClass.Destroy;
begin

    inherited;
end;

function TcBoothListClass.get(akey: integer): PTBoothItemData;
begin
    result := nil;
    if (akey < 0) or (akey > high(bootharr)) then exit;
    if BoothArr[akey].rKey = 255 then exit;
    Result := @BoothArr[akey];
end;

procedure TcBoothListClass.del(akey: integer);
begin
    if (akey < 0) or (akey > high(bootharr)) then exit;
    BoothArr[akey].rKey := 255;
    updatedraw;
end;

//------------------TFrmBooth----------------------------------

procedure TFrmBooth.FormCreate(Sender: TObject);
var
    i: integer;
    outing: TA2Image;
begin
    FrmM.AddA2Form(Self, Self.A2Form);
    Left := 50;
    Top := 50;

    A2Label_Sell_Total.FontColor := ColorSysToDxColor($00999999);
    A2Edit_Sell_Price.FontColor := ColorSysToDxColor($00009900);
    A2Edit_Sell_Count.FontColor := ColorSysToDxColor($00009900);
    A2Panel_Sell.Left := (Self.Width - A2Panel_Sell.Width) div 2;
    A2Panel_Sell.Top := 80;

    A2ILabelArrSell[0] := A2ILabel0;
    A2ILabelArrSell[1] := A2ILabel1;
    A2ILabelArrSell[2] := A2ILabel2;
    A2ILabelArrSell[3] := A2ILabel3;
    A2ILabelArrSell[4] := A2ILabel4;
    A2ILabelArrSell[5] := A2ILabel5;
    A2ILabelArrSell[6] := A2ILabel6;
    A2ILabelArrSell[7] := A2ILabel7;
    A2ILabelArrSell[8] := A2ILabel8;
    A2ILabelArrSell[9] := A2ILabel9;
    A2ILabelArrSell[10] := A2ILabel10;
    A2ILabelArrSell[11] := A2ILabel11;

    A2ILabelArrBuy[0] := A2ILabelS0;
    A2ILabelArrBuy[1] := A2ILabelS1;
    A2ILabelArrBuy[2] := A2ILabelS2;
    A2ILabelArrBuy[3] := A2ILabelS3;
    A2ILabelArrBuy[4] := A2ILabelS4;
    A2ILabelArrBuy[5] := A2ILabelS5;
    A2ILabelArrBuy[6] := A2ILabelS6;
    A2ILabelArrBuy[7] := A2ILabelS7;
    A2ILabelArrBuy[8] := A2ILabelS8;
    A2ILabelArrBuy[9] := A2ILabelS9;
    A2ILabelArrBuy[10] := A2ILabelS10;
    A2ILabelArrBuy[11] := A2ILabelS11;

    ItemBackImg := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('通用道具底框A.BMP', ItemBackImg);

    for i := 0 to High(A2ILabelArrBuy) do
    begin
        A2ILabelArrBuy[i].Width := 40;
        A2ILabelArrBuy[i].Height := 40;
        A2ILabelArrBuy[i].Tag := i;
        A2ILabelArrBuy[i].A2Image := ItemBackImg;
        A2ILabelArrBuy[i].A2Imageback := ItemBackImg;
    end;

    for i := 0 to High(A2ILabelArrSell) do
    begin
        A2ILabelArrSell[i].Width := 40;
        A2ILabelArrSell[i].Height := 40;
        A2ILabelArrSell[i].Tag := i;
        A2ILabelArrSell[i].A2Image := ItemBackImg;
        A2ILabelArrSell[i].A2Imageback := ItemBackImg;
    end;

    outing := TA2Image.Create(32, 32, 0, 0);
    try
        //摆摊背景
        pgkBmp.getBmp('摆摊窗口底框.bmp', outing);
        BoothBackimg.A2Image := outing;

        //按钮
        pgkBmp.getBmp('摆摊底框 _清空留言_弹起.bmp', outing);
        A2Button_MessageClear.A2Up := outing;
        pgkBmp.getBmp('摆摊底框 _清空留言_按下.bmp', outing);
        A2Button_MessageClear.A2Down := outing;
        pgkBmp.getBmp('摆摊底框 _清空留言_鼠标.bmp', outing);
        A2Button_MessageClear.A2Mouse := outing;
        pgkBmp.getBmp('摆摊底框 _清空留言_禁止.bmp', outing);
        A2Button_MessageClear.A2NotEnabled := outing;

        pgkBmp.getBmp('摆摊底框 _清空商品_弹起.bmp', outing);
        BtnClearBooth.A2Up := outing;
        pgkBmp.getBmp('摆摊底框 _清空商品_按下.bmp', outing);
        BtnClearBooth.A2Down := outing;
        pgkBmp.getBmp('摆摊底框 _清空商品_鼠标.bmp', outing);
        BtnClearBooth.A2Mouse := outing;
        pgkBmp.getBmp('摆摊底框 _清空商品_禁止.bmp', outing);
        BtnClearBooth.A2NotEnabled := outing;

        pgkBmp.getBmp('摆摊底框 _摆摊_弹起.bmp', outing);
        BtnStartBooth.A2Up := outing;
        pgkBmp.getBmp('摆摊底框 _摆摊_按下.bmp', outing);
        BtnStartBooth.A2Down := outing;
        pgkBmp.getBmp('摆摊底框 _摆摊_鼠标.bmp', outing);
        BtnStartBooth.A2Mouse := outing;
        pgkBmp.getBmp('摆摊底框 _摆摊_禁止.bmp', outing);
        BtnStartBooth.A2NotEnabled := outing;

        pgkBmp.getBmp('摆摊底框 _收摊_弹起.bmp', outing);
        BtnCancelBooth.A2Up := outing;
        pgkBmp.getBmp('摆摊底框 _收摊_按下.bmp', outing);
        BtnCancelBooth.A2Down := outing;
        pgkBmp.getBmp('摆摊底框 _收摊_鼠标.bmp', outing);
        BtnCancelBooth.A2Mouse := outing;
        pgkBmp.getBmp('摆摊底框 _收摊_禁止.bmp', outing);
        BtnCancelBooth.A2NotEnabled := outing;

        pgkBmp.getBmp('摆摊道具数量底框.bmp', outing);
        SellBackimg.A2Image := outing;
        A2ILabel_Sell_item.A2Image := ItemBackImg;
        A2ILabel_Sell_item.A2Imageback := ItemBackImg;

        pgkBmp.getBmp('通用_确认_弹起.BMP', outing);
        BtnOK.A2Up := outing;
        pgkBmp.getBmp('通用_确认_按下.BMP', outing);
        BtnOK.A2Down := outing;
        pgkBmp.getBmp('通用_确认_鼠标.BMP', outing);
        BtnOK.A2Mouse := outing;
        pgkBmp.getBmp('通用_确认_禁止.BMP', outing);
        BtnOK.A2NotEnabled := outing;

        pgkBmp.getBmp('通用_取消_弹起.BMP', outing);
        BtnCancel.A2Up := outing;
        pgkBmp.getBmp('通用_取消_按下.BMP', outing);
        BtnCancel.A2Down := outing;
        pgkBmp.getBmp('通用_取消_鼠标.BMP', outing);
        BtnCancel.A2Mouse := outing;
        pgkBmp.getBmp('通用_取消_禁止.BMP', outing);
        BtnCancel.A2NotEnabled := outing;

        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', outing);
        BtnClose.A2Up := outing;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', outing);
        BtnClose.A2Down := outing;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', outing);
        BtnClose.A2Mouse := outing;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', outing);
        BtnClose.A2NotEnabled := outing;

        pgkBmp.getBmp('摆摊底框 _留言_弹起.bmp', outing);
        A2Button_Message.A2Up := outing;
        pgkBmp.getBmp('摆摊底框 _留言_按下.bmp', outing);
        A2Button_Message.A2Down := outing;
        pgkBmp.getBmp('摆摊底框 _留言_鼠标.bmp', outing);
        A2Button_Message.A2Mouse := outing;
        pgkBmp.getBmp('摆摊底框 _留言_禁止.bmp', outing);
        A2Button_Message.A2NotEnabled := outing;

        BtnOK.Left := SellBackimg.Left + 40;
        BtnOK.Top := SellBackimg.Top + 94;
        BtnCancel.Left := SellBackimg.Left + 157;
        BtnCancel.Top := SellBackimg.Top + 94;

        A2Edit_Sell_Price.Left := SellBackimg.Left + 119;
        A2Edit_Sell_Price.Top := SellBackimg.Top + 33;
        A2Edit_Sell_Count.Left := SellBackimg.Left + 119;
        A2Edit_Sell_Count.Top := SellBackimg.Top + 54;
        A2Label_Sell_Total.Left := SellBackimg.Left + 119;
        A2Label_Sell_Total.Top := SellBackimg.Top + 75;

        A2ILabel_Sell_item.Left := SellBackimg.Left + 28;
        A2ILabel_Sell_item.Top := SellBackimg.Top + 28;
    finally
        outing.Free;
    end;

    BuyShopItemList := TcBoothListClass.Create;
    SellShopItemList := TcBoothListClass.Create;
    BoothUserBuyList := TcItemListClass.Create(12);
    BoothUserBuyList.onUPdate := onupitem;
    BoothUserSellList := TcItemListClass.Create(12);
    BoothUserSellList.onUPdate := onupitem;
end;

procedure TFrmBooth.SetItemShape(Lb: TA2ILabel; aitem: pTItemData);
var
    idx: integer;
begin
    Lb.A2Image := ItemBackImg;
    Lb.A2Imageback := ItemBackImg;
    Lb.A2ImageRDown := nil;
    Lb.A2ImageLUP := nil;
    Lb.Hint := '';
    Lb.Caption := '';
    if aitem = nil then exit;
    FrmAttrib.SetItemLabel(lb
        , ''
        , aitem.rColor
        , aitem.rShape
        , 0, 0
        );

end;

function TFrmBooth.CheckItem(akey: integer): boolean;
var
    aitem: TItemData;
begin
    result := false;
    aitem := HaveItemclass.get(akey);
    if aitem.rName = '' then
    begin
        FrmBottom.AddChat('无效的物品', WinRGB(255, 255, 0), 0);
        exit;
    end;
    if aitem.rlock = true then
    begin
        FrmBottom.AddChat('该物品有密码锁定', WinRGB(255, 255, 0), 0);
        exit;
    end;
    if aitem.rboNotTrade = true then
    begin
        FrmBottom.AddChat('该物品不能出售', WinRGB(255, 255, 0), 0);
        exit;
    end;
    if aitem.rboNotExchange = true then
    begin
        FrmBottom.AddChat('该物品不能交易', WinRGB(255, 255, 0), 0);
        exit;
    end;
    result := true;
end;

procedure TFrmBooth.A2ILabel0DragDrop(Sender, Source: TObject; X, Y: Integer);
var
    akey: integer;
    ahavekey: integer;
begin
    if CurWndState = bfls_lock then exit;
    case CurState of
        bfs_edit:
            begin
                if Source = nil then exit;

                with Source as TDragItem do
                begin
                    if SourceID <> WINDOW_ITEMS then exit;
                    akey := TA2ILabel(Sender).Tag;
                    ahavekey := Selected;

                    if CheckWearItemExist(ahavekey) = false then
                    begin
                        FrmBottom.AddChat('该物品已经在摊位上', WinRGB(255, 255, 0), 0);
                        exit;
                    end;
                    if CheckItem(ahavekey) = false then exit;

                    InputWindowopen(bis_edit_sell, akey, ahavekey);
                end;
            end;
        bfs_user: ;
    end;

end;

procedure TFrmBooth.FormDestroy(Sender: TObject);
begin
    ItemBackImg.Free;

    BuyShopItemList.Free;
    SellShopItemList.Free;

    BoothUserBuyList.free;
    BoothUserSellList.free;
end;

procedure TFrmBooth.A2ILabel0DragOver(Sender, Source: TObject; X,
    Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := FALSE;
    if CurWndState = bfls_lock then exit;
    case CurState of
        bfs_edit:
            begin

                if Source <> nil then
                begin
                    with Source as TDragItem do
                    begin
                        if SourceID = WINDOW_ITEMS then
                        begin
                            Accept := TRUE;
                        end;
                    end;
                end;
            end;
        bfs_user:
            begin

            end;
    end;

end;

procedure TFrmBooth.A2ILabel0MouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
var
    Temp: TA2ILabel;
begin
    Temp := Ta2ILabel(Sender);
    case CurState of
        bfs_edit:
            begin
                hintDraw(Sender, temp.Tag, bis_edit_buy);
            end;
        bfs_user:
            begin
                hintDraw(Sender, temp.Tag, bis_user_buy);
            end;
    end;

end;

procedure TFrmBooth.A2ILabel0MouseLeave(Sender: TObject);
begin
    GameHint.Close;
end;

procedure TFrmBooth.A2ILabel0MouseEnter(Sender: TObject);
begin
    GameHint.Close;
end;

procedure TFrmBooth.A2ILabel0MouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    //
end;

procedure TFrmBooth.InputWindowClose();
begin

    UnLockBooth;
    InputWindowClear;
end;

procedure TFrmBooth.InputWindowClear();
begin
    A2Panel_Sell.Visible := false;
    A2Edit_Sell_Price.Text := '1';
    A2Label_Sell_Total.Caption := '1';
    A2Edit_Sell_Count.Text := '1';
    SetItemShape(A2ILabel_Sell_item, nil);

end;

procedure TFrmBooth.InputWindowOpen(ainputtype: bootinputstate; akey, ahavekey: integer);
var
    tt: TItemdata;
    price, key: integer;

begin
    Inputtype := ainputtype;
    InputKey := akey;                                                           //商品位置
    InputHaveKey := ahavekey;                                                   //背包位置

    A2Edit_Sell_Price.Text := '1';
    A2Label_Sell_Total.Caption := '1';
    A2Edit_Sell_Count.Text := '1';
    SetItemShape(A2ILabel_Sell_item, nil);
    case Inputtype of
        bis_edit_buy, bis_edit_sell:
            begin
                A2Edit_Sell_Price.ReadOnly := false;
                tt := HaveItemclass.get(InputHaveKey);
                if tt.rName = '' then exit;
                SetItemShape(A2ILabel_Sell_item, @tt);
               // A2Edit_Sell_Price.SetFocus;
            end;
        bis_user_buy:
            begin
                tt := BoothUserBuyList.get(InputKey);
                if tt.rName = '' then exit;
                A2Edit_Sell_Price.Text := IntToStr(tt.rPrice);
                A2Edit_Sell_Price.ReadOnly := true;
                SetItemShape(A2ILabel_Sell_item, @tt);
              //  A2Edit_Sell_Count.SetFocus;
            end;
        bis_user_sell:
            begin
                tt := BoothUserSellList.get(InputKey);
                if tt.rName = '' then exit;
                A2Edit_Sell_Price.Text := IntToStr(tt.rPrice);
                A2Edit_Sell_Price.ReadOnly := true;
                SetItemShape(A2ILabel_Sell_item, @tt);
              //  A2Edit_Sell_Count.SetFocus;
            end;
    end;
    A2Panel_Sell.Visible := true;
    LockBooth;
end;

function TFrmBooth.getMoneyCount: integer;                                      //获得钱币的数量
var
    tt: PTItemdata;
begin
    result := 0;
    tt := HaveItemclass.getname('钱币');
    if tt = nil then exit;
    Result := tt.rCount;
end;

procedure TFrmBooth.A2Button_Sell_OKClick(Sender: TObject);
var
    aitem: TBoothItemData;
    tt, ahaveitem: TItemData;
    ShopPos, i, acount, apriceSum: integer;
    asum: int64;
begin
    if (A2Edit_Sell_Price.Text = '')
        or (A2Edit_Sell_Count.Text = '')
        or (A2Label_Sell_Total.Caption = '') then
    begin
        FrmBottom.AddChat('商品信息不全', WinRGB(255, 255, 0), 0);

        exit;
    end;
    case Inputtype of
        bis_edit_buy:
            begin
                tt := HaveItemclass.get(InputHaveKey);
                if tt.rName = '' then
                begin
                    FrmBottom.AddChat('无效的物品', WinRGB(255, 255, 0), 0);
                    exit;
                end;
                aitem.rKey := InputHaveKey;
                aitem.rPrice := _StrToInt(A2Edit_Sell_Price.Text);
                aitem.rCount := _StrToInt(A2Edit_Sell_Count.Text);
                asum := buyShopItemList.getPriceSum + aitem.rPrice * aitem.rCount;
                if (asum > getMoneyCount) or (asum <= 0) then
                begin
                    FrmBottom.AddChat('你身上携带的钱不够', WinRGB(255, 255, 0), 0);
                    exit;
                end;
                buyShopItemList.add(InputKey, aitem);
            end;
        bis_edit_sell:
            begin
                tt := HaveItemclass.get(InputHaveKey);
                if tt.rName = '' then
                begin
                    FrmBottom.AddChat('无效的物品', WinRGB(255, 255, 0), 0);
                    exit;
                end;
                aitem.rKey := InputHaveKey;
                aitem.rPrice := _StrToInt(A2Edit_Sell_Price.Text);
                aitem.rCount := _StrToInt(A2Edit_Sell_Count.Text);
                if (aitem.rCount > tt.rCount) or (aitem.rCount <= 0) then
                begin
                    FrmBottom.AddChat('物品数量问题', WinRGB(255, 255, 0), 0);
                    exit;
                end;
                if (aitem.rPrice <= 0) then
                begin
                    FrmBottom.AddChat('物品价格问题', WinRGB(255, 255, 0), 0);
                    exit;
                end;
                asum := SellShopItemList.getPriceSum + getMoneyCount + aitem.rPrice * aitem.rCount;
                if (asum <= 0) or (asum > 2000000000) then
                begin
                    FrmBottom.AddChat('注意：钱已经超出20亿', WinRGB(255, 255, 0), 0);
                    exit;
                end;
                SellShopItemList.add(InputKey, aitem);
            end;
        bis_user_buy:
            begin
                tt := BoothUserBuyList.get(InputKey);
                if tt.rName = '' then
                begin
                    FrmBottom.AddChat('无效的物品', WinRGB(255, 255, 0), 0);
                    exit;
                end;
                ahaveitem := HaveItemclass.get(InputHaveKey);
                if ahaveitem.rName = '' then
                begin
                    FrmBottom.AddChat('无效的物品', WinRGB(255, 255, 0), 0);
                    exit;
                end;

                acount := _StrToInt(A2Edit_Sell_Count.Text);
                if (acount <= 0) or (acount > tt.rCount) or (acount > ahaveitem.rCount) then
                begin
                    FrmBottom.AddChat('物品数量问题', WinRGB(255, 255, 0), 0);
                    exit;
                end;

                SendSell(InputKey, InputHaveKey, acount);
            end;
        bis_user_sell:
            begin
                tt := BoothUserSellList.get(InputKey);
                if tt.rName = '' then
                begin
                    FrmBottom.AddChat('无效的物品', WinRGB(255, 255, 0), 0);
                    exit;
                end;
                acount := _StrToInt(A2Edit_Sell_Count.Text);
                apriceSum := tt.rPrice * acount;
                if (apriceSum <= 0) or (apriceSum > getMoneyCount) then
                begin
                    FrmBottom.AddChat('物品数量问题', WinRGB(255, 255, 0), 0);
                    exit;
                end;
                SendBuy(InputKey, acount);
            end;
    end;
    InputWindowClose;
end;

procedure TFrmBooth.SetWindowState;
var
    temp: TObject;
    i: integer;
begin
    for i := 0 to self.ComponentCount - 1 do
    begin
        temp := Components[i];
        if temp is TA2Button then Continue;

        TA2ILabel(temp).Enabled := false;
        TA2Label(temp).Enabled := false;
        TA2Edit(temp).Enabled := false;
    end;
end;

procedure TFrmBooth.LockBooth;
var
    i: integer;
begin
    BoothName.ReadOnly := true;
    BtnStartBooth.Enabled := false;
    BtnClearBooth.Enabled := false;
    BtnCancelBooth.Enabled := false;
    CurWndState := bfls_lock;
end;

procedure TFrmBooth.UnLockBooth;
var
    I: integer;
begin
    BoothName.ReadOnly := false;
    BtnCancelBooth.Enabled := false;
    BtnClearBooth.Enabled := true;
    BtnStartBooth.Enabled := true;
    CurWndState := bfls_unlock;
end;

procedure TFrmBooth.BtnStartBoothClick(Sender: TObject);
begin
    LockBooth;
    SendStartBooth;
end;

procedure TFrmBooth.BtnCancelBoothClick(Sender: TObject);
begin
    SendStopBooth;
end;

//发送买

procedure TFrmBooth.SendBuy(akey, acount: integer);
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_BOOTH);
    WordComData_ADDbyte(temp, Booth_user_Buy_OK);
    WordComData_ADDdword(temp, akey);
    WordComData_ADDdword(temp, acount);

    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

//发送卖

procedure TFrmBooth.SendSell(akey, ahavekey, acount: integer);
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_BOOTH);
    WordComData_ADDbyte(temp, Booth_user_Sell_OK);
    WordComData_ADDdword(temp, akey);
    WordComData_ADDdword(temp, acount);
    WordComData_ADDdword(temp, ahavekey);

    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

//开始摆摊

procedure TFrmBooth.SendStartBooth();
var
    temp: TBoothData;
    str: string;
begin
    LockBooth;
    temp.rMsg := CM_Booth;
    temp.rType := Booth_edit_Begin;

    str := BoothName.Text;
    temp.rBoothName := copy(str, 1, 32);
    temp.BuyArr := BuyShopItemList.BoothArr;
    temp.SellArr := sellShopItemList.BoothArr;
    Frmfbl.SocketAddData(sizeof(temp), @temp);
end;

//收摊

procedure TFrmBooth.SendStopBooth;
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_BOOTH);
    WordComData_ADDbyte(temp, Booth_edit_End);

    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

//留言

procedure TFrmBooth.SendMessage(astr: string);
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_BOOTH);
    WordComData_ADDbyte(temp, Booth_user_Message);
    WordComData_ADDString(temp, astr);

    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmBooth.A2Button_MessageClearClick(Sender: TObject);
begin
    A2ListBox_Message.Clear;
end;

//卖家打开窗口

procedure TFrmBooth.SendOpenWindowEdit;
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_BOOTH);
    WordComData_ADDbyte(temp, Booth_edit_Windows_Open);

    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

//卖家关闭窗口

procedure TFrmBooth.SendCloseWindowEdit;
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_BOOTH);
    WordComData_ADDbyte(temp, Booth_edit_Windows_Close);

    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

//买家打开窗口

procedure TFrmBooth.SendOpenWindowUser(aname: string);
var
    temp: TWordComData;
begin
    boothusername := aname;
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_BOOTH);
    WordComData_ADDbyte(temp, Booth_user_Windows_Open);
    WordComData_ADDString(temp, aname);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

//买家关闭窗口

procedure TFrmBooth.SendCloseWindowUser;
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_BOOTH);
    WordComData_ADDbyte(temp, Booth_user_Windows_Close);

    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

//

procedure TFrmBooth.BtnClearBoothClick(Sender: TObject);
begin
    clear;

end;

procedure TFrmBooth.A2Button_MessageClick(Sender: TObject);
var
    str: string;
begin
    str := A2Edit_AddMsg.Text;
    if str = '' then exit;
    SendMessage(str);
    A2Edit_AddMsg.Text := '';
end;

procedure TFrmBooth.BtnCloseClick(Sender: TObject);
begin
    Visible := false;
    case CurState of
        bfs_edit: SendCloseWindowEdit;
        bfs_user: SendCloseWindowUser;
    end;
end;

procedure TFrmBooth.edit_Windows_Open();
var
    cl: TCharClass;
    str: string;
begin
    UnLockBooth;
    clear;

    str := '';
    cl := CharList.CharGet(CharCenterId);
    if cl <> nil then str := cl.rName;
    BoothName.FontColor := ColorSysToDxColor($00FFFF00);
    BoothName.Text := str + '的商店';

    A2ListBox_Message.Visible := true;
    BoothName.Visible := true;
    A2Button_MessageClear.Visible := true;
    BtnStartBooth.Visible := true;
    BtnCancelBooth.Visible := true;
    BtnClearBooth.Visible := true;

    A2Edit_AddMsg.Visible := false;
    A2Button_Message.Visible := false;
    LbBoothName.Visible := false;

    CurState := bfs_edit;
    CurWndState := bfls_unlock;
    Visible := true;
end;

procedure TFrmBooth.edit_Windows_Close();
begin
    clear;
    Visible := false;
end;

procedure TFrmBooth.clear();
begin
    InputWindowClear;
    BuyShopItemList.clear;
    SellShopItemList.clear;

    BoothUserBuyList.clear;
    BoothUserSellList.clear;
    updatedraw;
end;

procedure TFrmBooth.user_Windows_Open(aname: string);
begin
    UnLockBooth;

    clear;
    LbBoothName.FontColor := ColorSysToDxColor($00FFFF00);
    LbBoothName.Caption := aname;
    LbBoothName.Layout := tlCenter;

    A2ListBox_Message.Visible := false;
    BoothName.Visible := false;
    A2Button_MessageClear.Visible := false;
    BtnStartBooth.Visible := false;
    BtnCancelBooth.Visible := false;
    BtnClearBooth.Visible := false;

    A2Edit_AddMsg.Visible := true;
    A2Button_Message.Visible := true;
    LbBoothName.Visible := true;

    Visible := true;
    CurState := bfs_user;
    CurWndState := bfls_unlock;
end;

procedure TFrmBooth.user_Windows_close();
begin

    Visible := false;
end;

procedure TFrmBooth.MessageProcess(var code: TWordComData);
var
    i, n: integer;
    msg, imsg: Byte;
    state: byte;
    str: string;
    akey, acount, aprice, ahavekey: integer;
    astate: boolean;
    atype: boothtype;
    tempitem: TBoothItemData;
    tempuseritem: titemdata;
    Cl: TCharClass;
    psChangeFeature: PTSChangeFeature;
begin
    i := 0;
    imsg := WordComData_GETbyte(code, i);
    case imsg of
        SM_Booth:
            begin
                msg := WordComData_GETbyte(code, i);
                case msg of
                    Booth_CHANGEFEATURE:
                        begin
                            N := WordComData_GETdword(code, i);
                            cl := CharList.CharGet(n);
                            if cl = nil then exit;
                            cl.rbooth := boolean(WordComData_GETbyte(code, i));
                            cl.rBoothName := (WordComData_GETString(code, i));
                            cl.rboothshape := (WordComData_GETdword(code, i));

                            if Visible = false then exit;
                            if cl.rName <> boothusername then exit;
                            if cl.rbooth then exit;
                            SendCloseWindowUser;
                        end;
                    Booth_edit_Windows_Open:
                        begin
                            edit_Windows_Open;
                        end;
                    Booth_edit_Windows_Close:
                        begin
                            edit_Windows_Close;
                        end;
                    Booth_edit_Begin:
                        begin
                            BtnCancelBooth.Enabled := true;
                        end;
                    Booth_edit_End:
                        begin
                            UnLockBooth;
                        end;
                    Booth_edit_item:
                        begin
                            atype := boothtype(WordComData_getbyte(Code, i));
                            akey := WordComData_getbyte(Code, i);
                            n := WordComData_getdword(Code, i);
                            astate := boolean(n);
                            ahavekey := WordComData_getdword(Code, i);
                            aprice := WordComData_getdword(Code, i);
                            acount := WordComData_getdword(Code, i);

                            tempitem.rKey := ahavekey;
                            tempitem.rPrice := aprice;
                            tempitem.rCount := acount;
                            if atype = bt_buy then
                            begin
                                BuyShopItemList.add(akey, tempitem);
                            end;
                            if atype = bt_sell then
                            begin
                                SellShopItemList.add(akey, tempitem);
                            end;
                        end;
                    Booth_edit_item_upcount:
                        begin
                            atype := boothtype(WordComData_getbyte(Code, i));
                            akey := WordComData_getbyte(Code, i);
                            acount := WordComData_getdword(Code, i);
                            if atype = bt_buy then
                            begin
                                BuyShopItemList.upCount(akey, acount);
                            end;
                            if atype = bt_sell then
                            begin
                                SellShopItemList.upCount(akey, acount);
                            end;
                        end;
                    Booth_edit_item_del:
                        begin
                            atype := boothtype(WordComData_getbyte(Code, i));
                            akey := WordComData_getbyte(Code, i);
                            if atype = bt_buy then
                            begin
                                BuyShopItemList.del(akey);
                            end;

                            if atype = bt_sell then
                            begin
                                SellShopItemList.del(akey);
                            end;
                        end;
                    Booth_edit_Message:
                        begin
                            str := WordComData_GETString(code, i);
                            if str = '' then exit;
                            A2ListBox_Message.AddItem(str);
                        end;
                    Booth_user_Windows_Open:
                        begin
                            str := WordComData_GETString(code, i);
                            user_Windows_Open(str);
                        end;
                    Booth_user_Windows_Close:
                        begin
                            user_Windows_close;
                        end;
                    Booth_user_Buy_OK:
                        begin

                        end;
                    Booth_user_Sell_OK:
                        begin

                        end;
                    Booth_user_item:
                        begin
                            atype := boothtype(WordComData_getbyte(Code, i));
                            akey := WordComData_getbyte(Code, i);
                            n := WordComData_getbyte(Code, i);
                            if n = 1 then
                            begin
                                if atype = bt_buy then
                                begin
                                    BoothUserBuyList.del(akey);
                                end;
                                if atype = bt_sell then
                                begin
                                    BoothUserSellList.del(akey);
                                end;
                            end;
                            if n = 2 then
                            begin
                                TWordComDataToTItemData(i, code, tempuseritem);
                                if atype = bt_buy then
                                begin
                                    BoothUserBuyList.upitem(akey, tempuseritem);
                                end;
                                if atype = bt_sell then
                                begin
                                    BoothUserSellList.upitem(akey, tempuseritem);
                                end;
                            end;
                        end;
                    Booth_user_item_upcount:
                        begin
                            atype := boothtype(WordComData_getbyte(Code, i));
                            akey := WordComData_getbyte(Code, i);
                            acount := WordComData_getdword(Code, i);
                            if atype = bt_buy then
                            begin
                                BoothUserBuyList.upitemCountUP(akey, acount);
                            end;
                            if atype = bt_sell then
                            begin
                                BoothUserSellList.upitemCountUP(akey, acount);
                            end;
                        end;
                    Booth_user_item_del:
                        begin
                            atype := boothtype(WordComData_getbyte(Code, i));
                            akey := WordComData_getbyte(Code, i);
                            if atype = bt_buy then
                            begin
                                BoothUserBuyList.del(akey);
                            end;
                            if atype = bt_sell then
                            begin
                                BoothUserSellList.del(akey);
                            end;
                        end;

                    Booth_user_Message:
                        begin
                            //A2Edit_AddMsg.ReadOnly := false;
                        end;
                end;
            end;
    end;

end;

procedure TFrmBooth.A2Edit_Sell_PriceKeyPress(Sender: TObject;
    var Key: Char);
begin
    if not (key in ['0'..'9', #8]) then
        key := #0;
end;

procedure TFrmBooth.A2Edit_Sell_CountKeyPress(Sender: TObject;
    var Key: Char);
begin
    if not (key in ['0'..'9', #8]) then
        key := #0;
end;

procedure TFrmBooth.A2Edit_Sell_PriceChange(Sender: TObject);
var
    aPrice: integer;
    aCount: integer;
    apricesum: int64;
    item: TItemData;
begin
    if (A2Edit_Sell_Price.Text = '') or (A2Edit_Sell_Count.Text = '') then
    begin
        A2Label_Sell_Total.Caption := '';
        exit;
    end;
    //检查单价
    aPrice := _StrToInt(Trim(A2Edit_Sell_Price.Text));
    if aPrice > 400000000 then
    begin
        aprice := 400000000;
        A2Edit_Sell_Price.Text := IntToStr(aprice);
    end;
    aCount := _StrToInt(Trim(A2Edit_Sell_Count.Text));
    if aCount > 60000 then
    begin
        aCount := 60000;
        A2Edit_Sell_Count.Text := IntToStr(aCount);
    end;

    //检查数量是否超过背包数量
    case Inputtype of
        bis_edit_buy:
            begin

            end;
        bis_edit_sell:
            begin

                item := HaveItemclass.get(InputHaveKey);
                if aCount >= item.rCount then
                begin
                    aCount := item.rCount;
                    A2Edit_Sell_Count.Text := IntToStr(aCount);
                end;
            end;
        bis_user_buy:
            begin
                aCount := _StrToInt(Trim(A2Edit_Sell_Count.Text));
                item := HaveItemclass.get(InputHaveKey);
                if aCount >= item.rCount then
                begin
                    aCount := item.rCount;
                    A2Edit_Sell_Count.Text := IntToStr(aCount);
                end;
            end;
        bis_user_sell:
            begin
                aCount := _StrToInt(Trim(A2Edit_Sell_Count.Text));
                item := BoothUserSellList.get(InputKey);
                if aCount >= item.rCount then
                begin
                    aCount := item.rCount;
                    A2Edit_Sell_Count.Text := IntToStr(aCount);
                end;
            end;
    end;
    if (aPrice <= 0) or (aCount <= 0) then
    begin
        A2Edit_Sell_Price.Text := IntToStr(aprice);
        A2Edit_Sell_Count.Text := IntToStr(aCount);
        exit;
    end;
    if aCount > (2000000000 / aPrice) then
    begin
        FrmBottom.AddChat('数量问题', WinRGB(255, 255, 0), 0);
        A2Edit_Sell_Price.Text := '1';
        A2Edit_Sell_Count.Text := '1';
        A2Label_Sell_Total.Caption := '1';
        exit;
    end;
    apricesum := aPrice * aCount;
    if apricesum <= 0 then
    begin
        FrmBottom.AddChat('总价问题', WinRGB(255, 255, 0), 0);
        A2Edit_Sell_Price.Text := '1';
        A2Edit_Sell_Count.Text := '1';
        A2Label_Sell_Total.Caption := '1';
        exit;
    end;
    //检查总价格是否超过限制
    if apricesum > 2000000000 then
    begin
        FrmBottom.AddChat('总价超过20亿', WinRGB(255, 255, 0), 0);
        A2Edit_Sell_Price.Text := '1';
        A2Edit_Sell_Count.Text := '1';
        A2Label_Sell_Total.Caption := '1';
        exit;
    end;
    A2Label_Sell_Total.Caption := IntToStr(apricesum);
end;

procedure TFrmBooth.A2ListBox_MessageClick(Sender: TObject);
var
    s, sname, s1, s2, s3: string;
begin
    FrmBottom.SetFocus;
    FrmBottom.EdChat.SetFocus;
    sname := '';
    s := A2ListBox_Message.GetItem(A2ListBox_Message.ItemIndex);
    if ReverseFormat(s, '%s:%s', s1, s2, s3, 2) then                            //纸条
        sname := s1;

    if sname <> '' then
    begin
        Clipboard.AsText := sname;
        FrmBottom.AddChat('该玩家名字已复制', WinRGB(255, 255, 0), 0);
        FrmBottom.Editchannel.Caption := '纸条';
        FrmBottom.EdChat.Text := '@纸条 ' + sname + ' ';
    end;

    FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
end;

procedure TFrmBooth.A2ILabelS0Click(Sender: TObject);
begin
    //
end;

procedure TFrmBooth.A2ILabelS0DblClick(Sender: TObject);
begin
    //
end;

//检查列表中是否存在该物品

function TFrmBooth.CheckWearItemExist(ahavekey: integer): boolean;
var
    i: integer;
begin
    Result := false;
    for i := 0 to high(BuyShopItemList.BoothArr) do
    begin
        if BuyShopItemList.BoothArr[i].rKey = ahavekey then exit;

    end;
    for i := 0 to high(SellShopItemList.BoothArr) do
    begin
        if SellShopItemList.BoothArr[i].rKey = ahavekey then exit;

    end;
    Result := true;

end;

procedure TFrmBooth.A2ILabelS0DragDrop(Sender, Source: TObject; X,
    Y: Integer);
var
    akey: integer;
    ahavekey: integer;
begin
    if CurWndState = bfls_lock then exit;
    case CurState of
        bfs_edit:
            begin
                if Source = nil then exit;

                with Source as TDragItem do
                begin
                    if SourceID <> WINDOW_ITEMS then exit;
                    akey := TA2ILabel(Sender).Tag;
                    ahavekey := Selected;

                    if CheckWearItemExist(ahavekey) = false then
                    begin
                        FrmBottom.AddChat('该物品已经在摊位上', WinRGB(255, 255, 0), 0);
                        exit;
                    end;
                    if CheckItem(ahavekey) = false then exit;

                    InputWindowopen(bis_edit_buy, akey, ahavekey);
                end;
            end;
        bfs_user:
            begin
                if Source = nil then exit;

                with Source as TDragItem do
                begin
                    if SourceID <> WINDOW_ITEMS then exit;
                    akey := TA2ILabel(Sender).Tag;
                    ahavekey := Selected;

                    InputWindowopen(bis_user_buy, akey, ahavekey);
                end;
            end;
    end;

end;

procedure TFrmBooth.A2ILabelS0DragOver(Sender, Source: TObject; X,
    Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := FALSE;
    if CurWndState = bfls_lock then exit;

    if Source <> nil then
    begin
        with Source as TDragItem do
        begin
            if SourceID = WINDOW_ITEMS then
            begin
                Accept := TRUE;
            end;
        end;
    end;
end;

procedure TFrmBooth.A2ILabelS0MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if CurWndState = bfls_lock then exit;
    case CurState of
        bfs_edit:
            begin
                if Button = mbRight then
                begin
                    BuyShopItemList.del(TA2ILabel(sender).Tag);
                end;
            end;
        bfs_user: ;
    end;

end;

procedure TFrmBooth.A2ILabelS0MouseEnter(Sender: TObject);
begin
    //
end;

procedure TFrmBooth.A2ILabelS0MouseLeave(Sender: TObject);
begin
    //
end;

procedure TFrmBooth.A2ILabelS0MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
var
    Temp: TA2ILabel;
begin
    Temp := Ta2ILabel(Sender);
    case CurState of
        bfs_edit:
            begin
                hintDraw(Sender, temp.Tag, bis_edit_sell);
            end;
        bfs_user:
            begin
                hintDraw(Sender, temp.Tag, bis_user_sell);
            end;
    end;

end;

procedure TFrmBooth.A2ILabelS0MouseUp(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //
end;

procedure TFrmBooth.A2ILabel0MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if CurWndState = bfls_lock then exit;
    case CurState of
        bfs_edit:
            begin
                if Button = mbRight then
                begin
                    SellShopItemList.del(TA2ILabel(Sender).Tag);
                end;
            end;
        bfs_user: ;
    end;

end;

function TcBoothListClass.count: integer;
begin
    result := high(BoothArr) + 1;
end;

procedure TFrmBooth.onupitem(akey: integer; aitem: titemdata);
begin
    updatedraw;

end;

procedure TFrmBooth.A2ILabel0DblClick(Sender: TObject);
var
    akey: integer;
begin
    //
    if CurWndState = bfls_lock then exit;
    case CurState of
        bfs_edit:
            begin
            end;
        bfs_user:
            begin
                akey := TA2ILabel(Sender).Tag;
                InputWindowopen(bis_user_sell, akey, 0);
            end;
    end;
end;

procedure TFrmBooth.BoothBackimgMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TFrmBooth.A2Edit_AddMsgMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TFrmBooth.A2ListBox_MessageMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TFrmBooth.A2Button_MessageClearMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TFrmBooth.SellBackimgMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TFrmBooth.BtnCloseMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TFrmBooth.hintDraw(Sender: TObject; akey: integer; atype: bootinputstate);
var
    aitem: titemdata;
    tt: PTBoothItemData;
    str: string;
begin
    case atype of
        bis_edit_buy:
            begin
                tt := SellShopItemList.get(akey);
                if tt = nil then
                begin
                    GameHint.Close;
                    exit;
                end;
                aitem := HaveItemclass.get(tt.rKey);
                if aitem.rName = '' then
                begin
                    GameHint.Close;
                    exit;
                end;
                str := '';

                str := format('<$000080FF>出售单价：<$00F0F0F0>%d ', [tt.rPrice]);
                if tt.rPrice > 100000000 then str := str + format(' <$000080FF>(%.2f亿)', [tt.rPrice / 100000000])
                else if tt.rPrice > 10000 then str := str + format(' <$000080FF>(%.2f万)', [tt.rPrice / 10000]);
                str := str + #13#10;

                str := str + '<$000080FF>出售数量：<$00F0F0F0>' + IntToStr(tt.rcount) + #13#10;
                str := str + '<$000080FF>商品详细' + #13#10;

                str := str + TItemDataToStr(aitem);
                GameHint.setText(integer(Sender), str);
            end;
        bis_edit_sell:
            begin
                tt := buyShopItemList.get(akey);
                if tt = nil then
                begin
                    GameHint.Close;
                    exit;
                end;
                aitem := HaveItemclass.get(tt.rKey);
                if aitem.rName = '' then
                begin
                    GameHint.Close;
                    exit;
                end;
                str := '';

                str := format('<$000080FF>收购单价：<$00F0F0F0>%d ', [tt.rPrice]);
                if tt.rPrice > 100000000 then str := str + format(' <$000080FF>(%.2f亿)', [tt.rPrice / 100000000])
                else if tt.rPrice > 10000 then str := str + format(' <$000080FF>(%.2f万)', [tt.rPrice / 10000]);
                str := str + #13#10;
                str := str + '<$000080FF>收购数量：<$00F0F0F0>' + IntToStr(tt.rcount) + #13#10;
                str := str + '<$000080FF>商品详细' + #13#10;

                str := str + TItemDataToStr(aitem);
                GameHint.setText(integer(Sender), str);
            end;
        bis_user_buy:
            begin
                aitem := BoothUserSellList.get(akey);
                if aitem.rName = '' then
                begin
                    GameHint.Close;
                    exit;
                end;
                str := str + '<$000080FF>摊主出售商品' + #13#10;
                str := str + TItemDataToStr(aitem);
                GameHint.setText(integer(Sender), str);
            end;
        bis_user_sell:
            begin
                aitem := BoothUserBuyList.get(akey);
                if aitem.rName = '' then
                begin
                    GameHint.Close;
                    exit;
                end;
                str := str + '<$000080FF>摊主收购商品' + #13#10;
                str := str + TItemDataToStr(aitem);
                GameHint.setText(integer(Sender), str);
            end;
    end;

end;

procedure TFrmBooth.A2ILabel_Sell_itemMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    hintDraw(Sender, InputKey, Inputtype);
end;

procedure TFrmBooth.BoothBackimgMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

procedure TFrmBooth.FormMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

procedure TFrmBooth.LbBoothNameMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if CurState = bfs_edit then exit;
    if Button = mbLeft then FrmM.move_win_form_set(self, LbBoothName.Left + x, LbBoothName.Top + y);
    FrmM.SetA2Form(Self, A2form);
end;


procedure TFrmBooth.BtnCancelClick(Sender: TObject);
begin
    InputWindowClose;
end;

procedure TFrmBooth.BoothNameMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
begin
    GameHint.Close;
end;

end.

