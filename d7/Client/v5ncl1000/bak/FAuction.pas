unit FAuction;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, Deftype;

type
    TdataListclass = class;
    Tlistdata = class
        rid:integer;
        //  ritemname:string;
         // ritemcount:integer;
         // rItemImg:integer;          //物品
         // ritemcolor:word;           //颜色
        rPricetype:integer;
        rPrice:integer;            //价格
        rTime:integer;             //剩余时间
        ritem:Titemdata;
        rBargainorName:string;     //出售人名字
    end;

    TfrmAuction = class(TForm)
        Panel_new:TPanel;
        A2ListBox1:TA2ListBox;
        Panel_getlist:TPanel;
        A2ListBox_getlist:TA2ListBox;
        A2Form:TA2Form;
        A2Button5:TA2Button;
        A2Button4:TA2Button;
        A2ButtonSousuo:TA2Button;
        A2EditsousuoText:TA2Edit;
        A2Button6:TA2Button;
        A2Button1:TA2Button;
        btnCommand2:TA2Button;
        A2Button3:TA2Button;
        A2ButtonWinClose:TA2Button;
        A2ILabelItemList:TA2ILabel;
        A2ILabel_newitemlist:TA2ILabel;
        A2LabelItemCount:TA2Label;
        A2Button7:TA2Button;
        A2Button8:TA2Button;
        A2Button9:TA2Button;
        A2Button10:TA2Button;
        A2LabelnewListCount:TA2Label;
        procedure FormCreate(Sender:TObject);
        procedure A2ButtonSousuoClick(Sender:TObject);
        procedure A2EditsousuoTextChange(Sender:TObject);
        procedure A2ListBox_getlistAdxDrawItem(ASurface:TA2Image; index:Integer;
            aStr:string; Rect:TRect; State:TDrawItemState; fx, fy:Integer);
        procedure A2Button5Click(Sender:TObject);
        procedure FormDestroy(Sender:TObject);
        procedure A2ListBox1AdxDrawItem(ASurface:TA2Image; index:Integer;
            aStr:string; Rect:TRect; State:TDrawItemState; fx, fy:Integer);
        procedure A2Button1Click(Sender:TObject);
        procedure btnCommand2Click(Sender:TObject);
        procedure A2Button3Click(Sender:TObject);
        procedure A2ButtonWinCloseClick(Sender:TObject);
        procedure A2ListBox1Hint(Sender:TObject; aindex:Integer);
        procedure A2ListBox_getlistHint(Sender:TObject; aindex:Integer);
        procedure A2Button7Click(Sender:TObject);
        procedure A2Button8Click(Sender:TObject);
        procedure A2Button9Click(Sender:TObject);
        procedure A2Button6Click(Sender:TObject);
        procedure A2Button10Click(Sender:TObject);
        procedure A2Button4Click(Sender:TObject);
        procedure A2ListBox_getlistMouseDown(Sender:TObject;
            Button:TMouseButton; Shift:TShiftState; X, Y:Integer);
        procedure A2ILabelItemListMouseMove(Sender:TObject;
            Shift:TShiftState; X, Y:Integer);
        procedure A2EditsousuoTextMouseMove(Sender:TObject;
            Shift:TShiftState; X, Y:Integer);
        procedure A2Button7MouseMove(Sender:TObject; Shift:TShiftState; X,
            Y:Integer);
    private
        { Private declarations }
    public
        { Public declarations }
        Fsousuotext:string;
        FsousuoIndex:integer;
        Itemnamelist:TdataListclass;
        Bargainoritemlist:TdataListclass;

        ItemlistTA2Image:TA2Image; //图片
        NEWItemlistTA2Image:TA2Image; //图片
        fpoundage:integer;
        procedure MessageProcess(var code:TWordComData);

        procedure SendConsignmentDel(aid:integer); //撤消寄售
        procedure sendGetNameListbargainor(); //获取 寄售人 物品列表
        procedure SendgetItemText(aid:integer); //获取 物品详细 描述

        procedure newAuction();
        procedure ListAuction();
        procedure sendGetNameListItem(atext:string; atype:byte; aid:integer);
        procedure outTA2ListBox(sender:TA2ListBox; ASurface:TA2Image; index:Integer;
            aStr:string; Rect:TRect; State:TDrawItemState; fx,
            fy:Integer);

        procedure SetNewVersion;
        //procedure SetOldVersion;

    end;
    TdataListclass = class
    private
        fdata:tlist;
        FTA2ListBox:TA2ListBox;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Clear();
        function GetIndex(aindex:integer):pointer;
        procedure Add(aid, aprice, atime:integer; aBargainorName:string; apricetype:integer; var aitem:titemdata);
        procedure insert(aid, aprice, atime:integer; aBargainorName:string; apricetype:integer; var aitem:titemdata);
        function Get(aid:integer):pointer;
        procedure DEl(aid:integer);
        function count():integer;
        procedure updataitem(aid:integer; aitem:titemdata);
    end;

var
    frmAuction      :TfrmAuction;

implementation
uses FMain, FAttrib, Fbl, AUtil32, AtzCls, cltype, uAnsTick, CharCls, FBottom, FQuantity,
    FItemTreeView, AuctionBuy, filepgkclass;
{$R *.dfm}

constructor TdataListclass.Create;
begin
    fdata := tlist.create;
    FTA2ListBox := nil;
end;

destructor TdataListclass.Destroy;
begin
    Clear;
    fdata.Free;
    inherited destroy;
end;

procedure TdataListclass.Clear();
var
    i               :integer;

begin
    for i := 0 to fdata.Count - 1 do
    begin
        Tlistdata(fdata.Items[i]).Free;
    end;
    FTA2ListBox.Clear;
    fdata.Clear;
end;

function TdataListclass.count():integer;
begin
    result := fdata.Count;
end;

procedure TdataListclass.DEl(aid:integer);
var
    i               :integer;
    pp              :Tlistdata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        if pp.rid = aid then
        begin
            pp.Free;
            fdata.Delete(i);
            FTA2ListBox.DeleteItem(0);
            exit;
        end;

    end;

end;

procedure TdataListclass.updataitem(aid:integer; aitem:titemdata);
var
    pp              :Tlistdata;
begin
    pp := get(aid);
    if pp = nil then exit;
    pp.ritem := aitem;

end;

function TdataListclass.Get(aid:integer):pointer;
var
    i               :integer;
    pp              :Tlistdata;
begin
    result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        if pp.rid = aid then
        begin
            result := fdata.Items[i];
            exit;
        end;

    end;

end;

function TdataListclass.GetIndex(aindex:integer):pointer;
begin
    result := nil;
    if (aindex < 0) or (aindex >= fdata.Count) then exit;
    result := fdata.Items[aindex];
end;

procedure TdataListclass.Add(aid, aprice, atime:integer; aBargainorName:string; apricetype:integer; var aitem:titemdata);
var
    pp              :Tlistdata;
begin
    pp := Get(aid);
    if pp <> nil then
    begin
        exit;
    end;
    pp := Tlistdata.Create;
    pp.rid := aid;
    // pp.rItemImg := aitemImg;
   //  pp.ritemcolor := aitemColor;
    pp.rPrice := aprice;
    pp.rTime := atime;
    pp.ritem := aitem;
    // pp.ritemname := aitemname;
    // pp.ritemcount := acount;
    pp.rBargainorName := aBargainorName;
    pp.rPricetype := apricetype;
    fdata.add(pp);
    FTA2ListBox.AddItem(' ');
end;

procedure TdataListclass.insert(aid, aprice, atime:integer; aBargainorName:string; apricetype:integer; var aitem:titemdata);
var
    pp              :Tlistdata;
begin
    pp := Get(aid);
    if pp <> nil then
    begin
        exit;
    end;
    pp := Tlistdata.Create;
    pp.rid := aid;
    // pp.rItemImg := aitemImg;
    // pp.ritemcolor := aitemColor;
    pp.rPrice := aprice;
    pp.rTime := atime;
    pp.ritem := aitem;
    // pp.ritemname := aitemname;
    // pp.ritemcount := acount;
    pp.rBargainorName := aBargainorName;
    pp.rPricetype := apricetype;
    fdata.Insert(0, pp);
    FTA2ListBox.AddItem(' ');
end;

procedure TfrmAuction.MessageProcess(var code:TWordComData);
var
    pckey           :PTCKey;
    id, akey, i, alen:integer;
    aid, aitemimg, acolor, aprice, apricetype, acount, atime:integer;
    aname, aBargainorName:string;
    aitem           :titemdata;
begin
    pckey := @Code.Data;
    case pckey^.rmsg of
        SM_Auction:
            begin
                id := 1;
                akey := WordComData_GETbyte(code, id);
                case akey of
                    Auction_WindowsClose:
                        begin
                            Visible := false;

                        end;
                    Auction_WindowsOpen:
                        begin
                            fpoundage := WordComData_GETdword(code, id);
                            ListAuction;
                            FrmM.move_win_form_Align(self, mwfCenter);
                        end;
                    {Auction_getItemText:
                        begin
                            aid := WordComData_getdword(Code, id);

                            TWordComDataToTItemData(id, code, aitem);
                            Itemnamelist.upitem(aid, aitem);
                            Bargainoritemlist.upitem(aid, aitem);
                            //ItemHint.setText(aname);
                        end;
                     }
                    Auction_Item_ListDel:
                        begin
                            aid := WordComData_getdword(Code, id);

                            Itemnamelist.DEl(aid);
                            A2LabelItemCount.Caption := format('搜索到 %d 条寄售信息', [Itemnamelist.count]);
                        end;
                    Auction_Item_GetList: //列表
                        begin

                            Fsousuotext := WordComData_getstring(Code, id);

                            alen := WordComData_getdword(Code, id);
                            FsousuoIndex := WordComData_getdword(Code, id);
                            Itemnamelist.Clear;
                            if alen > 0 then
                            begin
                                for i := 0 to alen - 1 do
                                begin
                                    aid := WordComData_getdword(Code, id);
                                    //  aname := WordComData_getstring(Code, id);
                                     // aitemimg := WordComData_getdword(Code, id);
                                      //acolor := WordComData_getdword(Code, id);
                                    aprice := WordComData_getdword(Code, id);
                                    atime := WordComData_getdword(Code, id);
                                    //acount := WordComData_getdword(Code, id);
                                    aBargainorName := WordComData_getstring(Code, id);
                                    TWordComDataToTItemData(id, code, aitem);
                                    apricetype := WordComData_getbyte(Code, id);
                                    Itemnamelist.Add(aid, aprice, atime, aBargainorName, apricetype, aitem);

                                end;
                            end;
                            A2LabelItemCount.Caption := format('搜索到 %d 条寄售信息', [Itemnamelist.count]);
                        end;
                    Auction_Bargainor_GetNameList: //寄售列表
                        begin
                            Bargainoritemlist.Clear;

                            alen := WordComData_getdword(Code, id);
                            if alen > 0 then
                            begin
                                for i := 0 to alen - 1 do
                                begin
                                    aid := WordComData_getdword(Code, id);
                                    //  aname := WordComData_getstring(Code, id);
                                     // aitemimg := WordComData_getdword(Code, id);
                                     // acolor := WordComData_getdword(Code, id);
                                    aprice := WordComData_getdword(Code, id);
                                    atime := WordComData_getdword(Code, id);
                                    // acount := WordComData_getdword(Code, id);
                                    aBargainorName := WordComData_getstring(Code, id);
                                    TWordComDataToTItemData(id, code, aitem);
                                    apricetype := WordComData_getbyte(Code, id);
                                    Bargainoritemlist.insert(aid, aprice, atime, aBargainorName, apricetype, aitem);

                                end;
                            end;
                            A2LabelnewListCount.Caption := format('寄售信息 %d 条', [Bargainoritemlist.count]);
                        end;
                    Auction_Bargainor_ListAdd: //寄售列表 增加1个
                        begin
                            aid := WordComData_getdword(Code, id);
                            //   aname := WordComData_getstring(Code, id);
                              // aitemimg := WordComData_getdword(Code, id);
                             //  acolor := WordComData_getdword(Code, id);
                            aprice := WordComData_getdword(Code, id);
                            atime := WordComData_getdword(Code, id);
                            // acount := WordComData_getdword(Code, id);
                            aBargainorName := WordComData_getstring(Code, id);
                            TWordComDataToTItemData(id, code, aitem);
                            apricetype := WordComData_getbyte(Code, id);
                            Bargainoritemlist.insert(aid, aprice, atime, aBargainorName, apricetype, aitem);
                            A2LabelnewListCount.Caption := format('寄售信息 %d 条', [Bargainoritemlist.count]);
                        end;
                    Auction_Bargainor_ListDel: //寄售列表 减少1个
                        begin
                            aid := WordComData_getdword(Code, id);

                            Bargainoritemlist.DEl(aid);
                            A2LabelnewListCount.Caption := format('寄售信息 %d 条', [Bargainoritemlist.count]);
                        end;
                    Auction_Consignment: //寄售
                        begin

                        end;
                    Auction_ConsignmentCancel: //寄售 取消
                        begin

                        end;
                    Auction_buy:   //购买
                        begin

                        end;

                end;

            end;
    end;
end;

procedure TfrmAuction.FormDestroy(Sender:TObject);
begin

    ItemlistTA2Image.Free;

    Itemnamelist.Free;
    Bargainoritemlist.free;
    NEWItemlistTA2Image.Free;

end;

procedure TfrmAuction.SetNewVersion;
var
    temping, tempUp, tempDown:TA2Image;
begin
    temping := TA2Image.Create(32, 32, 0, 0);
    tempUp := TA2Image.Create(32, 32, 0, 0);
    tempDown := TA2Image.Create(32, 32, 0, 0);
    try
        //寄售系统
        pgkBmp.getBmp('寄售系统窗口.bmp', ItemlistTA2Image);
        A2ILabelItemList.A2Image := ItemlistTA2Image;
        pgkBmp.getBmp('寄售管理窗口.bmp', NEWItemlistTA2Image);
        A2ILabel_newitemlist.A2Image := NEWItemlistTA2Image;

        pgkBmp.getBmp('寄售系统_搜索_弹起.bmp', temping);
        A2ButtonSousuo.A2Up := temping;
        pgkBmp.getBmp('寄售系统_搜索_按下.bmp', temping);
        A2ButtonSousuo.A2Down := temping;
        pgkBmp.getBmp('寄售系统_搜索_鼠标.bmp', temping);
        A2ButtonSousuo.A2Mouse := temping;
        pgkBmp.getBmp('寄售系统_搜索_禁止.bmp', temping);
        A2ButtonSousuo.A2NotEnabled := temping;
        A2ButtonSousuo.Left := 24;
        A2ButtonSousuo.Top := 287;
        A2ButtonSousuo.Width := 56;
        A2ButtonSousuo.Height := 22;

        pgkBmp.getBmp('寄售系统_发布寄售_弹起.bmp', temping);
        A2Button10.A2Up := temping;
        pgkBmp.getBmp('寄售系统_发布寄售_按下.bmp', temping);
        A2Button10.A2Down := temping;
        pgkBmp.getBmp('寄售系统_发布寄售_鼠标.bmp', temping);
        A2Button10.A2Mouse := temping;
        pgkBmp.getBmp('寄售系统_发布寄售_禁止.bmp', temping);
        A2Button10.A2NotEnabled := temping;
        A2Button10.Left := 215;
        A2Button10.Top := 281;
        A2Button10.Width := 56;
        A2Button10.Height := 22;

        pgkBmp.getBmp('寄售系统_购买物品_弹起.bmp', temping);
        A2Button4.A2Up := temping;
        pgkBmp.getBmp('寄售系统_购买物品_按下.bmp', temping);
        A2Button4.A2Down := temping;
        pgkBmp.getBmp('寄售系统_购买物品_鼠标.bmp', temping);
        A2Button4.A2Mouse := temping;
        pgkBmp.getBmp('寄售系统_购买物品_禁止.bmp', temping);
        A2Button4.A2NotEnabled := temping;
        A2Button4.Left := 273;
        A2Button4.Top := 281;
        A2Button4.Width := 56;
        A2Button4.Height := 22;

        pgkBmp.getBmp('寄售系统_寄售管理_弹起.bmp', temping);
        A2Button5.A2Up := temping;
        pgkBmp.getBmp('寄售系统_寄售管理_按下.bmp', temping);
        A2Button5.A2Down := temping;
        pgkBmp.getBmp('寄售系统_寄售管理_鼠标.bmp', temping);
        A2Button5.A2Mouse := temping;
        pgkBmp.getBmp('寄售系统_寄售管理_禁止.bmp', temping);
        A2Button5.A2NotEnabled := temping;
        A2Button5.Left := 331;
        A2Button5.Top := 281;
        A2Button5.Width := 56;
        A2Button5.Height := 22;

        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
        A2ButtonWinClose.A2Up := temping;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
        A2ButtonWinClose.A2Down := temping;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
        A2ButtonWinClose.A2Mouse := temping;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
        A2ButtonWinClose.Enabled:=True;
      //   A2ButtonWinClose.A2NotEnabled := temping;  //20130902修改
        A2ButtonWinClose.Left := 378;
        A2ButtonWinClose.Top := 19;
        A2ButtonWinClose.Width := 17;
        A2ButtonWinClose.Height := 17;

        pgkBmp.getBmp('寄售系统_向左_弹起.bmp', temping);
        A2Button9.A2Up := temping;
        pgkBmp.getBmp('寄售系统_向左_按下.bmp', temping);
        A2Button9.A2Down := temping;
        A2Button9.Left := 137;
        A2Button9.Top := 292;
        A2Button9.Width := 21;
        A2Button9.Height := 15;

        pgkBmp.getBmp('寄售系统_向右_弹起.bmp', temping);
        A2Button8.A2Up := temping;
        pgkBmp.getBmp('寄售系统_向右_按下.bmp', temping);
        A2Button8.A2Down := temping;
        A2Button8.Left := 172;
        A2Button8.Top := 292;
        A2Button8.Width := 21;
        A2Button8.Height := 15;

        A2EditsousuoText.Left := 86;
        A2EditsousuoText.Top := 274;
        A2EditsousuoText.Width := 106;
        A2EditsousuoText.Height := 15;

        A2LabelItemCount.Left := 23;
        A2LabelItemCount.Top := 50;
        A2LabelItemCount.Width := 141;
        A2LabelItemCount.Height := 15;

        A2ListBox_getlist.Left := 18;
        A2ListBox_getlist.Top := 93;
        A2ListBox_getlist.Width := 385;
        A2ListBox_getlist.Height := 170;
        pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
        A2ListBox_getlist.SetScrollTopImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
        A2ListBox_getlist.SetScrollTrackImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
        A2ListBox_getlist.SetScrollBottomImage(tempUp, tempDown);
        pgkBmp.getBmp('温馨提示_下拉条底框.bmp', temping);
        A2ListBox_getlist.SetScrollBackImage(temping);

        //寄售管理
        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
        A2Button3.A2Up := temping;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
        A2Button3.A2Down := temping;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
        A2Button3.A2Mouse := temping;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
        A2Button3.A2NotEnabled := temping;
        A2Button3.Left := 378;
        A2Button3.Top := 19;
        A2Button3.Width := 17;
        A2Button3.Height := 17;

        pgkBmp.getBmp('寄售管理_寄售系统_弹起.bmp', temping);
        A2Button1.A2Up := temping;
        pgkBmp.getBmp('寄售管理_寄售系统_按下.bmp', temping);
        A2Button1.A2Down := temping;
        pgkBmp.getBmp('寄售管理_寄售系统_鼠标.bmp', temping);
        A2Button1.A2Mouse := temping;
        pgkBmp.getBmp('寄售管理_寄售系统_禁止.bmp', temping);
        A2Button1.A2NotEnabled := temping;
        A2Button1.Left := 331;
        A2Button1.Top := 281;
        A2Button1.Width := 56;
        A2Button1.Height := 22;

        pgkBmp.getBmp('寄售系统_发布寄售_弹起.bmp', temping);
        A2Button6.A2Up := temping;
        pgkBmp.getBmp('寄售系统_发布寄售_按下.bmp', temping);
        A2Button6.A2Down := temping;
        pgkBmp.getBmp('寄售系统_发布寄售_鼠标.bmp', temping);
        A2Button6.A2Mouse := temping;
        pgkBmp.getBmp('寄售系统_发布寄售_禁止.bmp', temping);
        A2Button6.A2NotEnabled := temping;
        A2Button6.Left := 215;
        A2Button6.Top := 281;
        A2Button6.Width := 56;
        A2Button6.Height := 22;

        pgkBmp.getBmp('寄售管理_取消寄售_弹起.bmp', temping);
        btnCommand2.A2Up := temping;
        pgkBmp.getBmp('寄售管理_取消寄售_按下.bmp', temping);
        btnCommand2.A2Down := temping;
        pgkBmp.getBmp('寄售管理_取消寄售_鼠标.bmp', temping);
        btnCommand2.A2Mouse := temping;
        pgkBmp.getBmp('寄售管理_取消寄售_禁止.bmp', temping);
        btnCommand2.A2NotEnabled := temping;
        btnCommand2.Left := 273;
        btnCommand2.Top := 281;
        btnCommand2.Width := 56;
        btnCommand2.Height := 22;

        A2ListBox1.Left := 18;
        A2ListBox1.Top := 93;
        A2ListBox1.Width := 385;
        A2ListBox1.Height := 170;
        pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
        A2ListBox1.SetScrollTopImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
        A2ListBox1.SetScrollTrackImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
        A2ListBox1.SetScrollBottomImage(tempUp, tempDown);
        pgkBmp.getBmp('温馨提示_下拉条底框.bmp', temping);
        A2ListBox1.SetScrollBackImage(temping);
    finally
        temping.Free;
        tempUp.Free;
        tempDown.Free;
    end;

end;

//procedure TfrmAuction.SetOldVersion;
//begin
//    pgkBmp.getBmp('Auctionlist.bmp', ItemlistTA2Image);
//    pgkBmp.getBmp('Auctionnew.bmp', NEWItemlistTA2Image);
//
//    A2ILabelItemList.A2Image := ItemlistTA2Image;
//    A2ILabel_newitemlist.A2Image := NEWItemlistTA2Image;
//
//    A2ListBox1.SetScrollTopImage(getviewImage(7), getviewImage(6));
//    A2ListBox1.SetScrollTrackImage(getviewImage(4), getviewImage(5));
//    A2ListBox1.SetScrollBottomImage(getviewImage(9), getviewImage(8));
//end;

procedure TfrmAuction.FormCreate(Sender:TObject);
begin
    //Parent := FrmM;

    FrmM.AddA2Form(Self, A2Form);

    NEWItemlistTA2Image := TA2Image.Create(Width, Height, 0, 0); //图片
    ItemlistTA2Image := TA2Image.Create(Width, Height, 0, 0); //图片

    Itemnamelist := TdataListclass.Create;
    Itemnamelist.FTA2ListBox := A2ListBox_getlist;
    Bargainoritemlist := TdataListclass.Create;
    Bargainoritemlist.FTA2ListBox := A2ListBox1;

    if WinVerType = wvtnew then
    begin
        SetNewVersion;
//    end
//    else
//    begin
//        SetOldVersion;
    end;

    A2ListBox1.FFontSelBACKColor := ColorSysToDxColor($9B7781);
    A2ListBox1.FontColor := ColorSysToDxColor(clMedGray);
    A2ListBox1.FLayout := tlCenter;

    //A2ListBox1.FHint.FImageOveray := 5;
   // A2ListBox_getlist.FHint.FImageOveray := 5;

    {  A2ListBox_getlist.SetScrollTopImage(getviewImage(7), getviewImage(6));
      A2ListBox_getlist.SetScrollTrackImage(getviewImage(4), getviewImage(5));
      A2ListBox_getlist.SetScrollBottomImage(getviewImage(9), getviewImage(8));
      }
    A2ListBox_getlist.FFontSelBACKColor := ColorSysToDxColor($9B7781);
    A2ListBox_getlist.FontColor := ColorSysToDxColor(clMedGray);
    A2ListBox_getlist.FLayout := tlCenter;
    //    A2ListBox_getlist.FHint.Ftype := hstTransparent;
end;

procedure TfrmAuction.sendGetNameListbargainor();
var
    temp            :TWordComData;
begin
    Bargainoritemlist.Clear;
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Auction);
    WordComData_ADDbyte(temp, Auction_Bargainor_GetNameList);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmAuction.newAuction();
begin

    Visible := true;
    Panel_new.Visible := true;
    Panel_getlist.Visible := not Panel_new.Visible;
end;

procedure TfrmAuction.ListAuction();
begin
    FrmM.SetA2Form(self, A2form);
    A2LabelItemCount.Caption := '';
    A2EditsousuoText.Text := '';
    FsousuoIndex := -1;
    Fsousuotext := '';
    Visible := true;
    Panel_new.Visible := false;
    Panel_getlist.Visible := not Panel_new.Visible;
end;

procedure TfrmAuction.sendGetNameListItem(atext:string; atype:byte; aid:integer);
var
    temp            :TWordComData;
begin
    {   Auction_getNext = 14;          //下一页
        Auction_getBack = 15;          //上一页}
    Fsousuotext := '';
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Auction);
    WordComData_ADDbyte(temp, Auction_Item_GetList);
    WordComData_ADDString(temp, atext);
    WordComData_ADDbyte(temp, atype);
    WordComData_ADDdword(temp, aid);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmAuction.A2ButtonSousuoClick(Sender:TObject);
begin

    sendGetNameListItem(A2EditsousuoText.Text, Auction_getList, 0);
    A2EditsousuoText.Text := '';
end;

procedure TfrmAuction.A2EditsousuoTextChange(Sender:TObject);
begin
    A2EditsousuoText.Text := trim(A2EditsousuoText.Text);
end;

procedure TfrmAuction.A2ListBox_getlistAdxDrawItem(ASurface:TA2Image;
    index:Integer; aStr:string; Rect:TRect; State:TDrawItemState; fx,
    fy:Integer);

begin
    outTA2ListBox(A2ListBox_getlist, ASurface, index, aStr, Rect, State, fx, fy);

end;

procedure TfrmAuction.A2Button5Click(Sender:TObject);
begin
    newAuction;
end;

procedure TfrmAuction.A2ListBox1AdxDrawItem(ASurface:TA2Image;
    index:Integer; aStr:string; Rect:TRect; State:TDrawItemState; fx,
    fy:Integer);

begin
    outTA2ListBox(A2ListBox1, ASurface, index, aStr, Rect, State, fx, fy);
end;

function _formatstr3(str:string):string;
var
    i               :integer;
    str1            :string;
begin
    result := '';
    while true do
    begin
        i := length(str);
        if i > 3 then
        begin
            str1 := copy(str, (i - 3) + 1, 3);
            str := copy(str, 1, i - 3);
            result := ',' + str1 + result;
        end else
        begin
            result := str + result;
            Exit;
        end;
    end;

end;

procedure TfrmAuction.outTA2ListBox(sender:TA2ListBox; ASurface:TA2Image; index:Integer;
    aStr:string; Rect:TRect; State:TDrawItemState; fx,
    fy:Integer);
var
    tt              :TA2Image;
    x, y, x1, y1, x2, y2
        , xc, yc    :integer;
    FGreenCol,
        FGreenAdd   :integer;
    t1              :Tlistdata;
    str             :string;
    price           :single;
begin
    if sender = A2ListBox1 then
        t1 := Bargainoritemlist.GetIndex(index)
    else
        t1 := Itemnamelist.GetIndex(index);
    if t1 = nil then
    begin
        ATextOut(ASurface, 0, 0, ColorSysToDxColor(clred), '错误');
        exit;
    end;

    GetGreenColorAndAdd(t1.ritem.rcolor, FGreenCol, FGreenAdd);
    x2 := 0;
    y2 := sender.ItemHeight div 2;
    x1 := 0;
    y1 := 0;
    xc := 0;
    yc := (sender.ItemHeight - ATextHeight('错')) div 2;
    //ID
    ATextOut(ASurface, xc, yc, tA2ListBox(sender).FontColor, inttostr(t1.rid + $0E000000));
    //寄售人
   // ATextOut(ASurface, 70, yc, ColorSysToDxColor(clWhite), t1.rBargainorName);

    //物品 图片
    tt := AtzClass.GetItemImage(t1.rItem.rShape);
    if tt = nil then
    begin
        ATextOut(ASurface, 0, 0, ColorSysToDxColor(clred), '错误');
        exit;
    end;
    x := (sender.ItemHeight - tt.Width) div 2;
    y := (sender.ItemHeight - tt.Height) div 2;

    if FGreenCol = 0 then ASurface.DrawImage(tt, 60 + x, y, TRUE)
    else ASurface.DrawImageGreenConvert(tt, 60 + x, y, FGreenCol, FGreenAdd);

    //物品名字 上
    if t1.ritem.rNameColor > 0 then
        ATextOut(ASurface, 100, 0, ColorSysToDxColor(t1.ritem.rNameColor), t1.ritem.rViewName)
    else
        ATextOut(ASurface, 100, 0, tA2ListBox(sender).FontColor, t1.ritem.rViewName);
    //寄售人  下
    ATextOut(ASurface, 100, y2, tA2ListBox(sender).FontColor, '' + t1.rBargainorName + '');

    //数量
    str := inttostr(t1.ritem.rcount);
    x := (40 - ATextWidth(str)) div 2;
    ATextOut(ASurface, 200 + x, yc, tA2ListBox(sender).FontColor, str);
    //价钱 上
    if t1.rPricetype = 1 then
    begin
        str := _formatstr3(inttostr(t1.rPrice));
        str := '元宝' + str;
        x := ATextWidth(str);
        ATextOut(ASurface, 305 - x, yc, ColorSysToDxColor($000080FF), str);
    end else
    begin
        str := _formatstr3(inttostr(t1.rPrice));
        x := ATextWidth(str);
        ATextOut(ASurface, 305 - x, 0, tA2ListBox(sender).FontColor, str);
//        if t1.rPrice > 100000000 then //亿
//            str := format('≈%d亿', [trunc(t1.rPrice / 100000000)])
//        else str := format('≈%d万', [trunc(t1.rPrice / 10000)]);
        //价钱 下
        x := ATextWidth(str);
        ATextOut(ASurface, 305 - x, y2, ColorSysToDxColor($000080FF), str);
    end;

    //时间
    str := Format('%.2f小时', [t1.rTime / 3600]);
    x := ATextWidth(str);
    ATextOut(ASurface, 365 - x, yc, tA2ListBox(sender).FontColor, str);
end;

procedure TfrmAuction.A2Button1Click(Sender:TObject);
begin
    ListAuction;
end;

procedure TfrmAuction.SendgetItemText(aid:integer);
var
    temp            :TWordComData;
begin
    //  FrmBottom.AddChat('获取物品详细' + inttostr(aid), WinRGB(22, 22, 0), 0);
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Auction);
    WordComData_ADDbyte(temp, Auction_getItemText);
    WordComData_ADDdword(temp, aid);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmAuction.SendConsignmentDel(aid:integer);
var
    temp            :TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Auction);
    WordComData_ADDbyte(temp, Auction_ConsignmentCancel);
    WordComData_ADDdword(temp, aid);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmAuction.btnCommand2Click(Sender:TObject);
var
    pp              :Tlistdata;
    aid             :integer;
begin
    aid := A2ListBox1.ItemIndex;
    if (aid < 0) or (aid >= A2ListBox1.Count) then exit;
    pp := Bargainoritemlist.GetIndex(aid);
    if pp = nil then exit;
    aid := pp.rid;
    SendConsignmentDel(aid);

end;

procedure TfrmAuction.A2Button3Click(Sender:TObject);
begin
    A2ButtonWinCloseClick(nil);
end;

procedure TfrmAuction.A2ButtonWinCloseClick(Sender:TObject);
var
    temp            :TWordComData;
begin
    Visible := false;
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Auction);
    WordComData_ADDbyte(temp, Auction_WindowsClose);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmAuction.A2ListBox1Hint(Sender:TObject; aindex:Integer);
var
    pp              :Tlistdata;
begin
    // A2Form.FA2Hint.setText('');
    pp := Bargainoritemlist.GetIndex(aindex);
    if pp = nil then
    begin
        GameHint.Close;
        exit;
    end;
    if pp.ritem.rViewName = '' then
    begin
        //  SendgetItemText(pp.rid);
        GameHint.Close;
        exit;
    end;
    // A2Form.FA2Hint.Ftype := hstTransparent;

    GameHint.setText(integer(Sender), '<33023>寄售编号:' + inttostr(pp.rid + $0E000000) + #13#10 + TItemDataToStr(pp.ritem));
end;

procedure TfrmAuction.A2ListBox_getlistHint(Sender:TObject;
    aindex:Integer);
var
    pp              :Tlistdata;
begin
    //    A2Form.FA2Hint.setText('');
    pp := Itemnamelist.GetIndex(aindex);
    if pp = nil then
    begin
        GameHint.Close;
        exit;
    end;
    if pp.ritem.rViewName = '' then
    begin
        //  SendgetItemText(pp.rid);
        GameHint.Close;
        exit;
    end;
    //  A2Form.FA2Hint.Ftype := hstTransparent;

      //A2Form.FA2Hint.setText(TItemDataToStr(pp.ritem));
    GameHint.settext(integer(Sender), '<33023>寄售编号:' + inttostr(pp.rid + $0E000000) + #13#10 + TItemDataToStr(pp.ritem));

end;

procedure TfrmAuction.A2Button7Click(Sender:TObject);
begin

    frmItemTreeView.Visible := true;
    frmItemTreeView.BringToFront;
    FrmM.move_win_form_Align(frmItemTreeView, mwfCenter);
end;

procedure TfrmAuction.A2Button8Click(Sender:TObject);
begin
    sendGetNameListItem(Fsousuotext, Auction_getNext, FsousuoIndex);
end;

procedure TfrmAuction.A2Button9Click(Sender:TObject);
begin
    sendGetNameListItem(Fsousuotext, Auction_getBack, FsousuoIndex);
end;

procedure TfrmAuction.A2Button6Click(Sender:TObject);
begin
    frmAuctionBuy.ShowVisible(abtSell);
end;

procedure TfrmAuction.A2Button10Click(Sender:TObject);
begin
    frmAuctionBuy.ShowVisible(abtSell);
end;

procedure TfrmAuction.A2Button4Click(Sender:TObject);
var
    pp              :Tlistdata;
begin

    pp := Itemnamelist.GetIndex(A2ListBox_getlist.ItemIndex);
    if pp = nil then exit;
    frmAuctionBuy.ShowVisible(abtBUY);
    frmAuctionBuy.BUYitemset(pp.rid);
end;

procedure TfrmAuction.A2ListBox_getlistMouseDown(Sender:TObject;
    Button:TMouseButton; Shift:TShiftState; X, Y:Integer);
begin
    {  A2ListBox_getlist.FHint.Ftype := hstImageOveray;
      if Button = mbLeft then
      begin
          if A2ListBox_getlist.FHint.FImageOveray < 99 then
              inc(A2ListBox_getlist.FHint.FImageOveray);
      end else
      begin
          if A2ListBox_getlist.FHint.FImageOveray > 1 then
              dec(A2ListBox_getlist.FHint.FImageOveray);
      end;
      }
end;

procedure TfrmAuction.A2ILabelItemListMouseMove(Sender:TObject;
    Shift:TShiftState; X, Y:Integer);
begin
    GameHint.Close;
end;

procedure TfrmAuction.A2EditsousuoTextMouseMove(Sender:TObject;
    Shift:TShiftState; X, Y:Integer);
begin
    GameHint.Close;
end;

procedure TfrmAuction.A2Button7MouseMove(Sender:TObject;
    Shift:TShiftState; X, Y:Integer);
begin
    GameHint.Close;
end;

end.

