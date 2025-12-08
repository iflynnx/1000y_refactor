unit FUPdateItemLevel;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, A2Form, StdCtrls, deftype, ExtCtrls, A2Img;

type
    TFrmUPdateItemLevel = class(TForm)
        A2Form: TA2Form;
        A2Button6: TA2Button;
        A2Label_text: TA2Label;
        A2ListBox_result: TA2ListBox;
        A2Label_caption: TA2Label;
        A2ListBox_NPCtext: TA2ListBox;
        Panel_UPDATEITEM: TPanel;
        A2ILabel_UPDATE: TA2ILabel;
        A2Label1: TA2Label;
        Panel_Setting: TPanel;
        A2ILabel_setting: TA2ILabel;
        A2Label2: TA2Label;
        Panel_Setting_del: TPanel;
        A2ILabel_setting_del: TA2ILabel;
        A2Label3: TA2Label;
        A2ILabel_setting_additem: TA2ILabel;
        A2Label4: TA2Label;
        A2ILabel_ATZ1: TA2ILabel;
        A2ILabel2: TA2ILabel;
        A2ILabel3: TA2ILabel;
        Timer1: TTimer;
        A2ILabel4: TA2ILabel;
        A2ILabel_ATZ2: TA2ILabel;
        A2ProgressBar1: TA2ProgressBar;
        A2Button1: TA2Button;
        procedure FormCreate(Sender: TObject);
        procedure A2ILabel_UPDATEDragOver(Sender, Source: TObject; X, Y: Integer;
            State: TDragState; var Accept: Boolean);
        procedure A2ILabel_UPDATEDragDrop(Sender, Source: TObject; X, Y: Integer);
        procedure A2Button1Click(Sender: TObject);
        procedure A2ILabel_UPDATEMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure A2Button6Click(Sender: TObject);
        procedure A2ILabel_UPDATEDblClick(Sender: TObject);
        procedure A2ILabel_setting_delDblClick(Sender: TObject);
        procedure A2ILabel_settingDblClick(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
        FbackImg: TA2Image;
        typeWindows: integer;
        SelectItemId: integer;
        SelectaddItemId: integer;
        FA2ImageLib: TA2ImageLib;
        FA2ImageLib2: TA2ImageLib;
        procedure MessageProcess(var code: TWordComData);
        procedure sendUPitemLevelSelect(aindex: integer);
        procedure sendUPitemLevel(aindex: integer);
        procedure sendWINDOWScolse;
        procedure ItemPaint();
        procedure CLEAR();

        procedure DrawNPCcaption(acaption, atext: string);
        procedure DrawNPCSELECTresult(atext: string);
        procedure DrawNPCUPDATAITEMresult(atext: string);

        procedure sendSettingselect(aindex: integer);
        procedure sendSetting(aitem, aadditem: integer);

        procedure sendSettingselect_del(aindex: integer);
        procedure sendSettingDEL(aindex: integer);

        procedure setitemshpe(Lb: TA2ILabel; aitemid: integer);
    end;

var
    FrmUPdateItemLevel: TFrmUPdateItemLevel;

implementation

uses FMain, Fbl, cltype, FAttrib, AUtil32, uAnsTick, filepgkclass;

{$R *.dfm}

procedure TFrmUPdateItemLevel.sendSettingselect_Del(aindex: integer);
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_UPdataItem);
    WordComData_ADDbyte(temp, UPdateItem_Setting_delselect);
    WordComData_ADDbyte(temp, aindex);

    Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TFrmUPdateItemLevel.sendSettingselect(aindex: integer);
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_UPdataItem);
    WordComData_ADDbyte(temp, UPdateItem_Settingselect);
    WordComData_ADDbyte(temp, aindex);

    Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TFrmUPdateItemLevel.sendUPitemLevelSelect(aindex: integer);
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_UPdataItem);
    WordComData_ADDbyte(temp, UPdateItem_UPLevelselect);
    WordComData_ADDbyte(temp, aindex);

    Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TFrmUPdateItemLevel.sendSetting(aitem, aadditem: integer);
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_UPdataItem);
    WordComData_ADDbyte(temp, UPdateItem_Setting);
    WordComData_ADDbyte(temp, aitem);
    WordComData_ADDbyte(temp, aadditem);

    Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TFrmUPdateItemLevel.sendSettingDEL(aindex: integer);
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_UPdataItem);
    WordComData_ADDbyte(temp, UPdateItem_Setting_del);
    WordComData_ADDbyte(temp, aindex);

    Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TFrmUPdateItemLevel.sendUPitemLevel(aindex: integer);
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_UPdataItem);
    WordComData_ADDbyte(temp, UPdateItem_UPLevel);
    WordComData_ADDbyte(temp, aindex);

    Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TFrmUPdateItemLevel.sendWINDOWScolse;
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_UPdataItem);
    WordComData_ADDbyte(temp, UPdateItem_Windows_close);
    Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TFrmUPdateItemLevel.ItemPaint();
var
    str: string;
begin
    if SelectItemId < 0 then exit;

end;

procedure TFrmUPdateItemLevel.CLEAR();
begin
    SelectItemId := -1;
    SelectaddItemId := -1;
    A2Label_caption.Caption := '';
    A2ListBox_NPCtext.Clear;
    A2ILabel_UPDATE.A2Image := nil;
    A2ILabel_UPDATE.A2ImageRDown := nil;
    A2ILabel_UPDATE.A2ImageLUP := nil;
    //  A2ILabel1.Visible := false;
//  A2Form.FA2Hint.setText('');

    A2Label_text.Caption := '';
    A2ListBox_result.Clear;
    Panel_UPDATEITEM.Visible := FALSE;
    Panel_Setting.Visible := FALSE;
    Panel_Setting_DEL.Visible := FALSE;
end;

procedure TFrmUPdateItemLevel.DrawNPCcaption(acaption, atext: string);
var
    outimg: TA2Image;
begin
    CLEAR;
    outimg := TA2Image.Create(32, 32, 0, 0);
    try
        FA2ImageLib.Clear;
        pgksprite.getImageLib('m09.atz', FA2ImageLib);

        A2ILabel_ATZ1.FA2ImageLib := FA2ImageLib;
        A2ILabel_ATZ1.FTransparentColor := ColorSysToDxColor(RGB(8, 8, 8));
        FA2ImageLib2.Clear;
        pgksprite.getImageLib('m05.atz', FA2ImageLib2);
        A2ILabel_ATZ2.FA2ImageLib := FA2ImageLib2;
        A2ILabel_ATZ2.FTransparentColor := ColorSysToDxColor(RGB(8, 8, 8));

        case typeWindows of
            WINDOW_UPdateItemLevel:
                begin
                    Panel_UPDATEITEM.Visible := TRUE;
                    pgkBmp.getBmp('精炼UP.bmp', outimg);
                    A2Button1.A2Up := outimg;
                    pgkBmp.getBmp('精炼DOWN.bmp', outimg);
                    A2Button1.A2Down := outimg;

                end;
            WINDOW_UPdateItemSetting:
                begin
                    Panel_Setting.Visible := TRUE;
                    pgkBmp.getBmp('镶嵌UP.bmp', outimg);
                    A2Button1.A2Up := outimg;
                    pgkBmp.getBmp('镶嵌DOWN.bmp', outimg);
                    A2Button1.A2Down := outimg;
                end;
            WINDOW_UPdateItemSetting_del:
                begin
                    Panel_Setting_DEL.Visible := TRUE;
                    pgkBmp.getBmp('镶嵌UP.bmp', outimg);
                    A2Button1.A2Up := outimg;
                    pgkBmp.getBmp('镶嵌DOWN.bmp', outimg);
                    A2Button1.A2Down := outimg;
                end;
        end;
    finally
        outimg.Free;
    end;
    A2Label_caption.Caption := acaption;
    A2ListBox_NPCtext.Clear;
    A2ListBox_NPCtext.setText(atext);
    Visible := true;
    FrmM.move_win_form_Align(Self, mwfCenter);
    FrmM.SetA2Form(Self, A2form);

end;

procedure TFrmUPdateItemLevel.DrawNPCSELECTresult(atext: string);
begin
    A2Label_text.Caption := atext;
end;

procedure TFrmUPdateItemLevel.DrawNPCUPDATAITEMresult(atext: string);
begin
    A2ListBox_result.AddItem(inttostr(A2ListBox_result.Count) + atext);
end;

procedure TFrmUPdateItemLevel.setitemshpe(Lb: TA2ILabel; aitemid: integer);
var
    pp: PTItemdata;
    idx: integer;
begin
    pp := HaveItemclass.getid(aitemid);
    if pp = nil then exit;
    if pp.rlockState = 1 then idx := 24
    else if pp.rlockState = 2 then idx := 25
    else idx := 0;
    FrmAttrib.SetItemLabel(lb
        , ''
        , pp.rColor
        , pp.rShape
        , idx, 0
        );
end;

procedure TFrmUPdateItemLevel.MessageProcess(var code: TWordComData);
var
    i, n, i1, i2, i3, i4: integer;
    pckey: PTCKey;
    PSSShowSpecialWindow: PTSShowSpecialWindow;
    aitemLevel: TItemDataUPdataLevel;
    str: string;
begin
    pckey := @Code.Data;
    case pckey^.rmsg of
        SM_SHOWSPECIALWINDOW:
            begin
                PSSShowSpecialWindow := @code.data;
                case PSSShowSpecialWindow.rWindow of
                    WINDOW_Close_All:
                        begin
                            Visible := false;
                            exit;
                        end;
                    WINDOW_UPdateItemLevel,
                        WINDOW_UPdateItemSetting,
                        WINDOW_UPdateItemSetting_del:

                        begin
                            typeWindows := PSSShowSpecialWindow.rWindow;
                            DrawNPCcaption(PSSShowSpecialWindow.rCaption, GetWordString(PSSShowSpecialWindow.rWordString));
                        end;
                end;
            end;
        SM_UPDATAITEM:
            begin
                i := 1;
                n := WordComData_GETbyte(Code, i);
                case n of
                    UPdateItem_Settingselect:                                   //镶嵌 选择
                        begin
                            n := WordComData_GETbyte(Code, i);

                            case n of
                                1:
                                    begin
                                        i2 := WordComData_GETdword(Code, i);
                                        setitemshpe(A2ILabel_setting, SelectItemId);
                                        DrawNPCSELECTresult(format('费用:%d，请放入要镶嵌的宝石。', [i2]));
                                    end;
                                2: DrawNPCSELECTresult('物品不存在');
                                3: DrawNPCSELECTresult('无孔装备');
                                4: DrawNPCSELECTresult('镶嵌宝石已满');
                                50: DrawNPCSELECTresult('物品锁状态');
                                51: DrawNPCSELECTresult('背包琐状态');
                            end;

                        end;
                    UPdateItem_Setting:                                         //镶嵌
                        begin

                            n := WordComData_GETbyte(Code, i);
                            case n of

                                2: DrawNPCUPDATAITEMresult('不具备条件：物品不存在');
                                3: DrawNPCUPDATAITEMresult('不具备条件：无孔装备');
                                4: DrawNPCUPDATAITEMresult('不具备条件：无孔可镶嵌');
                                5: DrawNPCUPDATAITEMresult('不具备条件：宝石物品不存在');
                                6: DrawNPCUPDATAITEMresult('不具备条件：宝石和装备不匹配');
                                7: DrawNPCUPDATAITEMresult('不具备条件：钱币 数量不够');
                                8: DrawNPCUPDATAITEMresult('不具备条件：钱币 数量不够');
                                9: DrawNPCUPDATAITEMresult('不具备条件：钱币 扣出失败');

                                11: DrawNPCUPDATAITEMresult('操作失败：镶嵌过程失败');
                                100: DrawNPCUPDATAITEMresult('镶嵌完成：装备已经提升属性请查看。');
                                50: DrawNPCUPDATAITEMresult('物品锁状态');
                                51: DrawNPCUPDATAITEMresult('背包琐状态');
                            end;

                        end;
                    UPdateItem_Setting_delselect:                               //清除 选择
                        begin
                            n := WordComData_GETbyte(Code, i);

                            case n of
                                1:
                                    begin
                                        i2 := WordComData_GETdword(Code, i);
                                        setitemshpe(A2ILabel_setting_del, SelectItemId);
                                        DrawNPCSELECTresult(format('费用:%d', [i2]));
                                    end;
                                2: DrawNPCSELECTresult('不具备条件：物品不存在');
                                3: DrawNPCSELECTresult('不具备条件：无孔装备');
                                4: DrawNPCSELECTresult('不具备条件：没有镶嵌宝石');
                                50: DrawNPCSELECTresult('物品锁状态');
                                51: DrawNPCSELECTresult('背包琐状态');
                            end;

                        end;
                    UPdateItem_Setting_del:                                     //清除
                        begin

                            n := WordComData_GETbyte(Code, i);
                            case n of

                                2: DrawNPCUPDATAITEMresult('不具备条件：物品不存在');
                                3: DrawNPCUPDATAITEMresult('不具备条件：无孔装备');
                                4: DrawNPCUPDATAITEMresult('不具备条件：没有镶嵌宝石');
                                7: DrawNPCUPDATAITEMresult('不具备条件：钱币 数量不够');
                                8: DrawNPCUPDATAITEMresult('不具备条件：钱币 数量不够');
                                9: DrawNPCUPDATAITEMresult('不具备条件：钱币 扣出失败');

                                11: DrawNPCUPDATAITEMresult('操作失败：升级过程失败');
                                100: DrawNPCUPDATAITEMresult('清除完成：可以重新镶嵌宝石了。');
                                50: DrawNPCUPDATAITEMresult('物品锁状态');
                                51: DrawNPCUPDATAITEMresult('背包琐状态');
                            end;

                        end;
                    UPdateItem_UPLevelselect:                                   //升级  选择
                        begin
                            n := WordComData_GETbyte(Code, i);

                            case n of
                                1:
                                    begin
                                        aitemLevel.rmoney := WordComData_GETdword(Code, i);
                                        aitemLevel.rhuanxian := WordComData_GETdword(Code, i);
                                        aitemLevel.rPrestige := WordComData_GETdword(Code, i);
                                        aitemLevel.rBijou := WordComData_GETdword(Code, i);
                                        setitemshpe(A2ILabel_UPDATE, SelectItemId);
                                        DrawNPCSELECTresult(format('钱%d,幻仙%d个,荣誉%d,宝石%d', [aitemLevel.rmoney, aitemLevel.rhuanxian, aitemLevel.rPrestige, aitemLevel.rBijou]));
                                    end;
                                2: DrawNPCSELECTresult('不具备条件：物品不存在');
                                3: DrawNPCSELECTresult('不具备条件：物品不能升级');
                                4: DrawNPCSELECTresult('不具备条件：精炼等级已达到最高');
                                50: DrawNPCSELECTresult('物品锁状态');
                                51: DrawNPCSELECTresult('背包琐状态');
                                200: DrawNPCUPDATAITEMresult('精炼数据错误');
                            end;

                        end;
                    UPdateItem_UPLevel:                                         //升级
                        begin

                            n := WordComData_GETbyte(Code, i);
                            case n of

                                2: DrawNPCUPDATAITEMresult('物品不存在');
                                3: DrawNPCUPDATAITEMresult('不能升级物品');
                                4: DrawNPCUPDATAITEMresult('精炼等级已达到最高');
                                5: DrawNPCUPDATAITEMresult('幻仙宝石 数量不够');
                                6: DrawNPCUPDATAITEMresult('幻仙宝石 数量不够');
                                7: DrawNPCUPDATAITEMresult('钱币 数量不够');
                                8: DrawNPCUPDATAITEMresult('钱币 数量不够');
                                9: DrawNPCUPDATAITEMresult('钱币 扣出失败');
                                10: DrawNPCUPDATAITEMresult('不具备条件：幻仙宝石 扣出失败');
                                11: DrawNPCUPDATAITEMresult('操作失败：升级过程失败');
                                100: DrawNPCUPDATAITEMresult('精炼完成：恭喜你！升级成功物品属性有所提高。');
                                101: DrawNPCUPDATAITEMresult('精炼完成：升级失败。');
                                50: DrawNPCUPDATAITEMresult('物品锁状态');
                                51: DrawNPCUPDATAITEMresult('背包琐状态');
                                200: DrawNPCUPDATAITEMresult('精炼数据错误');
                                21: DrawNPCUPDATAITEMresult('荣誉不够');
                                22: DrawNPCUPDATAITEMresult('扣宝石失败');
                            end;

                        end;
                end;
            end;
    end;
end;

procedure TFrmUPdateItemLevel.FormCreate(Sender: TObject);
var
    Bitmap: TBitmap;
begin
    FrmM.AddA2Form(Self, A2Form);
    SelectItemId := -1;
    FbackImg := TA2Image.Create(32, 32, 0, 0);

    pgkBmp.getBmp('镶嵌系统背景.bmp', FbackImg);
    A2ILabel4.A2Image := FbackImg;
    //
    Bitmap := TBitmap.Create;
    try
        pgkBmp.getBitmap('进度条面板.bmp', Bitmap);
        A2ProgressBar1.Picture.Assign(Bitmap);
        pgkBmp.getBitmap('进度条底板.bmp', Bitmap);
        A2ProgressBar1.BackPicture.Assign(Bitmap);
        A2ProgressBar1.Width := Bitmap.Width;
        A2ProgressBar1.Height := Bitmap.Height;
        A2ProgressBar1.Draw;
    finally
        Bitmap.Free;
    end;

    A2ListBox_NPCtext.SetScrollTopImage(getviewImage(7), getviewImage(6));
    A2ListBox_NPCtext.SetScrollTrackImage(getviewImage(4), getviewImage(5));
    A2ListBox_NPCtext.SetScrollBottomImage(getviewImage(9), getviewImage(8));
    // A2ListBox_NPCtext.FFontSelBACKColor := ColorSysToDxColor($9B7781);
   // A2ListBox_NPCtext.FontColor := ColorSysToDxColor(clMedGray);
    // A2ListBox1.FLayout := tlCenter;

    A2ListBox_result.SetScrollTopImage(getviewImage(7), getviewImage(6));
    A2ListBox_result.SetScrollTrackImage(getviewImage(4), getviewImage(5));
    A2ListBox_result.SetScrollBottomImage(getviewImage(9), getviewImage(8));
    A2ListBox_result.FFontSelBACKColor := ColorSysToDxColor($9B7781);
    A2ListBox_result.FontColor := ColorSysToDxColor($00007CF9);
    // A2ListBox1.FLayout := tlCenter;

//  A2Form.FA2Hint.Ftype := hstTransparent;
    FA2ImageLib := TA2ImageLib.Create;
    FA2ImageLib2 := TA2ImageLib.Create;
end;

procedure TFrmUPdateItemLevel.A2ILabel_UPDATEDragOver(Sender, Source: TObject; X,
    Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := FALSE;
    if Source <> nil then
    begin
        with Source as TDragItem do
        begin
            if SourceID = WINDOW_ITEMS then Accept := TRUE;
        end;
    end;
end;

procedure TFrmUPdateItemLevel.A2ILabel_UPDATEDragDrop(Sender, Source: TObject; X,
    Y: Integer);
begin
    if Source = nil then exit;
    with Source as TDragItem do
    begin
        if SourceID <> WINDOW_ITEMS then exit;

        if tA2ILabel(Sender) = A2ILabel_UPDATE then
        begin
            SelectItemId := Selected;
            sendUPitemLevelSelect(Selected);
        end
        else if tA2ILabel(Sender) = A2ILabel_setting then
        begin
            SelectItemId := Selected;
            sendSettingselect(Selected);
        end
        else if tA2ILabel(Sender) = A2ILabel_setting_additem then
        begin
            SelectaddItemId := Selected;
            setitemshpe(A2ILabel_setting_additem, SelectaddItemId);

        end
        else if tA2ILabel(Sender) = A2ILabel_setting_del then
        begin
            SelectItemId := Selected;
            sendSettingselect_del(Selected);
        end;

    end;
end;

procedure TFrmUPdateItemLevel.A2Button1Click(Sender: TObject);
var
    pp: PTItemdata;
begin
    if SelectItemId < 0 then exit;

    pp := HaveItemclass.getid(SelectItemId);
    if pp = nil then exit;
    if pp.rViewName = '' then exit;
    case pp.rKind of
  //  ITEM_KIND_WEARITEM2                 //24号
        ITEM_KIND_WEARITEM                                                      //6号
    //  , ITEM_KIND_WEARITEM_29           //29 有头盔是29
        , ITEM_KIND_WEARITEM_GUILD                                              //60号  掉持久
            :
            begin
                case typeWindows of
                    WINDOW_UPdateItemLevel:
                        begin
                            if pp.boUpgrade then
                            begin
                                sendUPitemLevel(SelectItemId);
                                exit;
                            end;
                        end;
                    WINDOW_UPdateItemSetting:
                        begin
                            if SelectaddItemId <> -1 then
                            begin
                                sendSetting(SelectItemId, SelectaddItemId);
                                exit;
                            end;
                        end;
                    WINDOW_UPdateItemSetting_del:
                        begin
                            sendSettingDEL(SelectItemId);
                            exit;
                        end;
                end;

            end;
    end;
    A2ListBox_result.AddItem('不具备条件');
end;

procedure TFrmUPdateItemLevel.A2ILabel_UPDATEMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
var
    pp: PTItemdata;
begin
    if tA2ILabel(Sender).A2Image = nil then exit;
    if tA2ILabel(Sender) = A2ILabel_setting_additem then
        pp := HaveItemclass.getid(SelectaddItemId)
    else
        pp := HaveItemclass.getid(SelectItemId);
    if pp = nil then exit;
//  if pp.rViewName <> '' then    A2Form.FA2Hint.setText(TItemDataToStr(pp^));
end;

procedure TFrmUPdateItemLevel.A2Button6Click(Sender: TObject);
begin
    sendWINDOWScolse;
    Visible := false;
end;

procedure TFrmUPdateItemLevel.A2ILabel_UPDATEDblClick(Sender: TObject);
begin
    SelectItemId := -1;

    TA2ILabel(Sender).A2Image := nil;
    TA2ILabel(Sender).A2ImageRDown := nil;
    TA2ILabel(Sender).A2ImageLUP := nil;
//  A2Form.FA2Hint.setText('');
    A2Label_text.Caption := '';
    A2ListBox_result.Clear;

end;

procedure TFrmUPdateItemLevel.A2ILabel_setting_delDblClick(
    Sender: TObject);
begin
    SelectItemId := -1;

    TA2ILabel(Sender).A2Image := nil;
    TA2ILabel(Sender).A2ImageRDown := nil;
    TA2ILabel(Sender).A2ImageLUP := nil;
//  A2Form.FA2Hint.setText('');
    A2Label_text.Caption := '';
    A2ListBox_result.Clear;
end;

procedure TFrmUPdateItemLevel.A2ILabel_settingDblClick(Sender: TObject);
begin
    SelectItemId := -1;
    SelectaddItemId := -1;
    A2ILabel_setting.A2Image := nil;
    A2ILabel_setting.A2ImageRDown := nil;
    A2ILabel_setting.A2ImageLUP := nil;
    A2ILabel_setting_additem.A2Image := nil;
    A2ILabel_setting_additem.A2ImageRDown := nil;
    A2ILabel_setting_additem.A2ImageLUP := nil;
//  A2Form.FA2Hint.setText('');
    A2Label_text.Caption := '';
    A2ListBox_result.Clear;
end;

procedure TFrmUPdateItemLevel.FormDestroy(Sender: TObject);
begin
    FbackImg.Free;
    FA2ImageLib.Free;
    FA2ImageLib2.Free;
end;

end.

