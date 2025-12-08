unit Femailread;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, A2Form, A2Img, StdCtrls, Deftype;

type
    TfrmEmailRead = class(TForm)
        A2ILabelReadItem: TA2ILabel;
        A2ILabelFTitle: TA2ILabel;
        A2ILabelFsourceName: TA2ILabel;
        A2Button5: TA2Button;
        A2Button2: TA2Button;
        A2Form: TA2Form;
        A2ILabelEmailtext: TA2ILabel;
        A2ILabel_back: TA2ILabel;
        LabelitemReadCount: TA2ILabel;
        procedure A2Button2Click(Sender: TObject);
        procedure A2Button5Click(Sender: TObject);
        procedure A2ILabelReadItemMouseMove(Sender: TObject;
            Shift: TShiftState; X, Y: Integer);
        procedure A2ILabelreadbackMouseMove(Sender: TObject;
            Shift: TShiftState; X, Y: Integer);
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure A2ILabel_backMouseLeave(Sender: TObject);
        procedure A2ILabel_backMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2ILabel_backMouseMove(Sender: TObject; Shift: TShiftState;
            X, Y: Integer);
    private
        { Private declarations }
    public
        { Public declarations }
        aitem: TITEMDATA;
        FID: integer;
        FDestName: string;                                                      //目的 名字
        FTitle: string;                                                         //标题

        FText: string;                                                          //内容
        FsourceName: string;                                                    //来源 名字
        FTime: tdatetime;

        FbReadTA2Image: TA2Image;
        fitemTA2Image: TA2Image;
        temping: TA2Image;
        procedure MessageProcess(var code: TWordComData);
        procedure DrawOutReadMail();
        procedure readEmail();
        procedure SetNewVersion();
       // procedure SetOldVersion();
    end;

var
    frmEmailRead: TfrmEmailRead;

implementation

uses Fbl, FBottom, filepgkclass, FMain, AtzCls, CharCls, FAttrib;

{$R *.dfm}

procedure getEMIAL(eid: integer);
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_EMAIL);
    WordComData_ADDbyte(temp, EMAIL_get);
    WordComData_ADDdword(temp, eid);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmEmailRead.A2Button2Click(Sender: TObject);
begin
    getEMIAL(fid);
    Visible := false;
end;

procedure TfrmEmailRead.A2Button5Click(Sender: TObject);
begin
    Visible := false;
    SAY_EdChatFrmBottomSetFocus;
end;

procedure TfrmEmailRead.A2ILabelReadItemMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), TItemDataToStr(aitem));
end;

procedure TfrmEmailRead.A2ILabelreadbackMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
//    A2Form.FA2Hint.setText('');
end;

procedure TfrmEmailRead.readEmail();
begin

    Visible := true;

    FrmM.move_win_form_Align(self, mwfCenter);
end;

procedure TfrmEmailRead.DrawOutReadMail();
var
    FGreenCol, FGreenAdd: integer;
    tt: TA2Image;
begin
    fitemTA2Image.Clear(0);
    readEmail;
    A2ILabelFsourceName.Caption := FsourceName;                                 //来源 名字
    A2ILabelFTitle.Caption := FTitle;                                           //标题
    A2ILabelEmailtext.Caption := FText;                                         //内容

    LabelitemReadCount.Caption := inttostr(aitem.rCount);
    A2ILabelReadItem.Caption := '';
    A2ILabelReadItem.Hint := '';

    if aitem.rViewName <> '' then
    begin
        fitemTA2Image.Resize(32, 32);
        fitemTA2Image.Clear(0);
        tt := AtzClass.GetItemImage(aitem.rShape);
        if tt <> nil then
        begin
            A2ILabelReadItem.Caption := '';
            A2ILabelReadItem.Hint := A2ILabelReadItem.Caption;
            GetGreenColorAndAdd(aitem.rcolor, FGreenCol, FGreenAdd);
            if FGreenCol = 0 then
                fitemTA2Image.DrawImage(tt, 0, 0, TRUE)
            else
                fitemTA2Image.DrawImageGreenConvert(tt, 0, 0, FGreenCol, FGreenAdd);
            fitemTA2Image.Optimize;
        end;
    end;
    A2ILabelReadItem.A2Image := fitemTA2Image;
end;

procedure TfrmEmailRead.MessageProcess(var code: TWordComData);
var
    pckey: PTCKey;
    id, akey, i, alen: integer;

begin
    pckey := @Code.Data;
    case pckey^.rmsg of
        SM_email:
            begin
                id := 1;
                akey := WordComData_GETbyte(code, id);
                case akey of
                    EMAIL_read:                                                 //阅读
                        begin
                            FID := WordComData_getdword(code, id);
                            FTitle := WordComData_getstring(code, id);
                            FText := WordComData_getstring(code, id);
                            FText := StringReplace(FText, '<br>', #13#10, [rfReplaceAll]);
                            FsourceName := WordComData_getstring(code, id);
                            FTime := WordComData_getdatetime(code, id);

                            akey := WordComData_getbyte(code, id);
                            if akey = 1 then
                            begin
                                TWordComDataToTItemData(id, code, aitem);
                            end else
                            begin
                                fillchar(aitem, sizeof(aitem), 0);
                            end;

                            DrawOutReadMail;
                            Visible := true;
                            FrmM.move_win_form_Align(self, mwfCenter);
                            FrmM.SetA2Form(Self, A2form);
                        end;

                    EMAIL_del:                                                  //删除
                        begin
                            Visible := false;
                        end;
                    EMAIL_get:                                                  //收取
                        begin
                            Visible := false;
                        end;
                end;

            end;
    end;
end;

procedure TfrmEmailRead.FormCreate(Sender: TObject);
begin
    FrmM.AddA2Form(Self, A2Form);
//    if WinVerType = wvtOld then
//    begin
//        SetoldVersion;
//    end else
    if WinVerType = wvtnew then
    begin
        SetnewVersion;
    end;
    A2ILabelReadItem.Transparent := true;
    A2ILabelFsourceName.Transparent := true;
    A2ILabelFTitle.Transparent := true;
    A2ILabelEmailtext.Transparent := true;
    LabelitemReadCount.Transparent := true;
    fitemTA2Image := TA2Image.Create(32, 32, 0, 0);
    fitemTA2Image.Clear(0);
    A2ILabelReadItem.A2Image := fitemTA2Image;

//    A2Form.FA2Hint.Ftype := hstTransparent;
end;

procedure TfrmEmailRead.SetNewVersion();
begin
    temping := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('收件箱窗口.bmp', temping);
    A2ILabel_back.A2Image := temping;

    //收取
    pgkBmp.getBmp('邮箱_收取_弹起.bmp', temping);
    A2Button2.A2Up := temping;
    pgkBmp.getBmp('邮箱_收取_按下.bmp', temping);
    A2Button2.A2Down := temping;
    pgkBmp.getBmp('邮箱_收取_鼠标.bmp', temping);
    A2Button2.A2Mouse := temping;
    pgkBmp.getBmp('邮箱_收取_禁止.bmp', temping);
    A2Button2.A2NotEnabled := temping;
    A2Button2.Left := 113;
    A2Button2.Top := 263;
    //关闭
    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
    A2Button5.A2Up := temping;
    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
    A2Button5.A2Down := temping;
    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
    A2Button5.A2Mouse := temping;
    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
    A2Button5.A2NotEnabled := temping;
    A2Button5.Left := 207;
    A2Button5.Top := 9;
    A2Button5.Width := 17;
    A2Button5.Height := 17;
    //
    A2ILabelFsourceName.Left := 67;
    A2ILabelFsourceName.Top := 43;
    A2ILabelFsourceName.Width := 158;
    A2ILabelFsourceName.Height := 15;
    //
    A2ILabelFTitle.Left := 67;
    A2ILabelFTitle.Top := 65;
    A2ILabelFTitle.Width := 158;
    A2ILabelFTitle.Height := 15;

    //
    A2ILabelReadItem.Left := 20;
    A2ILabelReadItem.Top := 240;
    A2ILabelReadItem.Width := 40;
    A2ILabelReadItem.Height := 40;
    //数量
    LabelitemReadCount.Left := 110;
    LabelitemReadCount.Top := 238;
    LabelitemReadCount.Width := 106;
    LabelitemReadCount.Height := 15;

    //内容框
    A2ILabelEmailtext.Left := 18;
    A2ILabelEmailtext.Top := 95;
    A2ILabelEmailtext.Width := 212;
    A2ILabelEmailtext.Height := 134;
end;

//procedure TfrmEmailRead.SetOldVersion();
//begin
//    FbReadTA2Image := TA2Image.Create(32, 32, 0, 0);
//    pgkBmp.getBmp('emailread.bmp', FbReadTA2Image);
//    A2ILabel_back.A2Image := FbReadTA2Image;
//end;

procedure TfrmEmailRead.FormDestroy(Sender: TObject);
begin
    FbReadTA2Image.Free;
    fitemTA2Image.Free;
    temping.Free;
end;

procedure TfrmEmailRead.A2ILabel_backMouseLeave(Sender: TObject);
begin
//    A2Form.FA2Hint.setText('');
end;

procedure TfrmEmailRead.A2ILabel_backMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmEmailRead.A2ILabel_backMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

end.

