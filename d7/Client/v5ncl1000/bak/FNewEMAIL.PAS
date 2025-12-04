unit FNEWEMAIL;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, Deftype;

type

    TFrmNEWEmail = class(TForm)
        A2Form: TA2Form;
        MemoNewText: TMemo;
        A2ILabelNEWitem: TA2ILabel;
        A2ButtonNewSend: TA2Button;
        A2Button3: TA2Button;
        Image1: TImage;
        EditNewDestName: TA2Edit;
        EditNewTitle: TA2Edit;
        Labelitemcount: TA2Label;
        procedure FormCreate(Sender: TObject);

        procedure A2ButtonNewSendClick(Sender: TObject);
        procedure EditNewDestNameChange(Sender: TObject);
        procedure EditNewTitleChange(Sender: TObject);
        procedure A2ILabelNEWitemDragOver(Sender, Source: TObject; X,
            Y: Integer; State: TDragState; var Accept: Boolean);
        procedure A2ILabelNEWitemDragDrop(Sender, Source: TObject; X,

            Y: Integer);
        procedure FormDestroy(Sender: TObject);
        procedure A2Button3Click(Sender: TObject);
    private
    protected

        { Private declarations }
    public
        { Public declarations }
        Paintlock: boolean;
        tempTA2Image: TA2Image;

        FID: integer;
        FDestName: string;                                                      //目的 名字
        FTitle: string;                                                         //标题

        FText: string;                                                          //内容
        FsourceName: string;                                                    //来源 名字
        FTime: tdatetime;

        FNewItemKey: integer;                                                   //新邮件 附件物品 背包 位置  -1是不带
        FNewItemKeyCount: integer;                                              //新邮件 数量

        FNEWitemTA2Image: TA2Image;
        ItemImageKuang: TA2Image;
        temping: TBitmap;                                                       //新邮件 图片
        procedure MessageProcess(var code: TWordComData);

        procedure DrawOutNewMail();
        procedure newEmail();

        procedure EMIALNewSend(aDestName, aTitle, aText: string; aItemKey, aItemCount: integer; aGOLD_Money: integer);

        procedure SetNewVersion();
       // procedure SetOldVersion();
    end;

var
    FrmNEWEmail: TFrmNEWEmail;

implementation

uses FMain, FAttrib, Fbl, AtzCls, cltype, uAnsTick, CharCls, FBottom, filepgkclass,
    FQuantity;

{$R *.dfm}

procedure TFrmNEWEmail.newEmail();
begin
    Visible := true;
    Labelitemcount.Caption := '';

    FNEWitemTA2Image.Clear(0);
    EditNewDestName.Text := '';
    EditNewTitle.Text := '';
    MemoNewText.Text := '';
    FNEWITEMkey := -1;
    FNewItemKeyCount := 0;
    FrmM.move_win_form_Align(self, mwfCenter);
end;

procedure TFrmNEWEmail.MessageProcess(var code: TWordComData);
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
                            Visible := false;
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

procedure TFrmNEWEmail.FormCreate(Sender: TObject);
begin
//    if WinVerType = wvtOld then
//    begin
//        SetOldVersion;
//    end else
    if WinVerType = wvtnew then
    begin
        SetNewVersion;
    end;
    A2ILabelNEWitem.Transparent := true;
    tempTA2Image := TA2Image.Create(Width, Height, 0, 0);
    Parent := FrmM;
    //FrmM.AddA2Form(Self, A2Form);
    DoubleBuffered := true;
    Top := 0;
    Left := 0;
    FNEWitemTA2Image := TA2Image.Create(32, 32, 0, 0);
    FNEWitemTA2Image.Clear(0);
    FNEWitemTA2Image.Resize(A2ILabelNEWitem.Width, A2ILabelNEWitem.Height);
    A2ILabelNEWitem.A2Image := FNEWitemTA2Image;
end;

procedure TFrmNEWEmail.SetNewVersion();
begin
    pgkBmp.getBitmap('发件箱窗口.bmp', Image1.Picture.Bitmap);

    temping := TBitmap.Create;

    //收取
    pgkBmp.getBitmap('邮箱_发送_弹起.bmp', temping);
    A2ButtonNewSend.UpImage.Bitmap := temping;
    pgkBmp.getBitmap('邮箱_发送_按下.bmp', temping);
    A2ButtonNewSend.DownImage.Bitmap := temping;
    pgkBmp.getBitmap('邮箱_发送_鼠标.bmp', temping);
    A2ButtonNewSend.ImageMouse.Bitmap := temping;
    pgkBmp.getBitmap('邮箱_发送_禁止.bmp', temping);
    A2ButtonNewSend.ImageNotEnabled.Bitmap := temping;
    A2ButtonNewSend.Left := 113;
    A2ButtonNewSend.Top := 263;
    //关闭
    pgkBmp.getBitmap('通用X关闭按钮_弹起.bmp', temping);
    A2Button3.UpImage.Bitmap := temping;
    pgkBmp.getBitmap('通用X关闭按钮_按下.bmp', temping);
    A2Button3.DownImage.Bitmap := temping;
    pgkBmp.getBitmap('通用X关闭按钮_鼠标.bmp', temping);
    A2Button3.ImageMouse.Bitmap := temping;
    pgkBmp.getBitmap('通用X关闭按钮_禁止.bmp', temping);
    A2Button3.ImageNotEnabled.Bitmap := temping;
    A2Button3.Left := 207;
    A2Button3.Top := 9;
    A2Button3.Width := 17;
    A2Button3.Height := 17;
    //
    EditNewDestName.Left := 67;
    EditNewDestName.Top := 43;
    EditNewDestName.Width := 158;
    EditNewDestName.Height := 15;
    //
    EditNewTitle.Left := 67;
    EditNewTitle.Top := 65;
    EditNewTitle.Width := 158;
    EditNewTitle.Height := 15;

    //
    A2ILabelNEWitem.Left := 24;
    A2ILabelNEWitem.Top := 243;
    A2ILabelNEWitem.Width := 32;
    A2ILabelNEWitem.Height := 32;
    //数量
    Labelitemcount.Left := 110;
    Labelitemcount.Top := 238;
    Labelitemcount.Width := 106;
    Labelitemcount.Height := 15;

    //内容框
    MemoNewText.Left := 18;
    MemoNewText.Top := 95;
    MemoNewText.Width := 212;
    MemoNewText.Height := 134;
end;

//procedure TFrmNEWEmail.SetOldVersion();
//begin
//    pgkBmp.getBitmap('emailread.bmp', Image1.Picture.Bitmap);
//end;

procedure TFrmNEWEmail.EMIALNewSend(aDestName, aTitle, aText: string; aItemKey, aItemCount: integer; aGOLD_Money: integer);
var
    temp: TWordComData;
begin
    if aDestName = '' then
    begin
        FrmBottom.AddChat('发送人名字不能为空。', WinRGB(22, 22, 0), 0);
        exit;
    end;

    if aTitle = '' then
    begin
        FrmBottom.AddChat('标题不能为空。', WinRGB(22, 22, 0), 0);
        exit;
    end;
    if aText = '' then
    begin
        FrmBottom.AddChat('邮件内容不能为空。', WinRGB(22, 22, 0), 0);
        exit;
    end;
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_EMAIL);
    WordComData_ADDbyte(temp, EMAIL_NEW);
    WordComData_ADDstring(temp, aDestName);
    WordComData_ADDstring(temp, aTitle);
    WordComData_ADDstring(temp, aText);
    WordComData_ADDdword(temp, aItemKey);
    WordComData_ADDdword(temp, aItemCount);
    WordComData_ADDdword(temp, aGOLD_Money);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
    Visible := false;
    SAY_EdChatFrmBottomSetFocus;
    FrmQuantity.Visible := false;
    A2ILabelNEWitem.Hint := '';
    A2ILabelNEWitem.A2Image := nil;
end;

procedure TFrmNEWEmail.A2ButtonNewSendClick(Sender: TObject);
var
    str, aDestName, aTitle, aText: string;
    i: integer;
begin
    aText := '';
    for i := 0 to MemoNewText.Lines.Count - 1 do
    begin
        str := MemoNewText.Lines.Strings[i];
        str := StringReplacegame(str);
        aText := aText + str + '<br>';
    end;
    atitle := StringReplacegame(EditNewTitle.Text);

    EMIALNewSend(EditNewDestName.Text,
        atitle,
        aText,
        FNewItemKey,
        FNewItemKeyCount
        , 0);
end;

procedure TFrmNEWEmail.EditNewDestNameChange(Sender: TObject);
begin
    EditNewDestName.Text := trim(EditNewDestName.Text);
end;

procedure TFrmNEWEmail.EditNewTitleChange(Sender: TObject);
begin
    EditNewTitle.Text := trim(EditNewTitle.Text);
end;

procedure TFrmNEWEmail.A2ILabelNEWitemDragOver(Sender, Source: TObject; X,
    Y: Integer; State: TDragState; var Accept: Boolean);
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

procedure TFrmNEWEmail.DrawOutNewMail();
var
    FGreenCol, FGreenAdd: integer;
    tt: TA2Image;
    temppTSHaveItem: PTItemdata;
begin
    Labelitemcount.Caption := inttostr(FNewItemKeyCount);
    FNEWitemTA2Image.Clear(0);
    A2ILabelNEWitem.Caption := '';
    A2ILabelNEWitem.Hint := '';
    A2ILabelNEWitem.ShowHint := true;
    temppTSHaveItem := HaveItemclass.getid(FNewItemKey);
    if temppTSHaveItem = nil then exit;

    tt := AtzClass.GetItemImage(temppTSHaveItem.rShape);

    if tt <> nil then
    begin
        FNEWitemTA2Image.Resize(32, 32);
        FNEWitemTA2Image.Clear(0);
        //A2ILabelNEWitem.Caption := temppTSHaveItem.rViewName; //+ #13#10 + '数量' + inttostr(FNewItemKeyCount);
        A2ILabelNEWitem.Hint := temppTSHaveItem.rViewName;                      // A2ILabelNEWitem.Caption;
        GetGreenColorAndAdd(temppTSHaveItem.rColor, FGreenCol, FGreenAdd);
        if FGreenCol = 0 then
            FNEWitemTA2Image.DrawImage(tt, 0, 0, TRUE)
        else
            FNEWitemTA2Image.DrawImageGreenConvert(tt, 0, 0, FGreenCol, FGreenAdd);
        FNEWitemTA2Image.Optimize;
    end;
    A2ILabelNEWitem.A2Image := FNEWitemTA2Image;
    // A2ILabelNEWitem.
end;

procedure TFrmNEWEmail.A2ILabelNEWitemDragDrop(Sender, Source: TObject; X,
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
                sourceid := tp.Selected;
                tt := HaveItemclass.getid(sourceid);

                if tt = nil then
                begin
                    FrmBottom.AddChat('错误！无此种物品', WinRGB(22, 22, 0), 0);
                    exit;
                end;
                FNewItemKey := sourceid;
                FNewItemKeyCount := 0;
                DrawOutNewMail;
                if tt.rCount > 10000 then FrmQuantity.CountMax := 10000
                else FrmQuantity.CountMax := tt.rCount;

                FrmQuantity.Visible := true;
                FrmQuantity.ShowType := SH_NewEmail;

                FrmQuantity.LbCountName.Caption := (Tt.rViewName);
                FrmQuantity.EdCount.Text :=IntToStr(tt.rCount);
                FrmQuantity.EdCount.SetFocus;
                //FrmQuantity.EdCount.SelectAll;
                //FrmQuantity.BringToFront;
            end;

    end;
end;

procedure TFrmNEWEmail.FormDestroy(Sender: TObject);
begin
    tempTA2Image.Free;
    FNEWitemTA2Image.Free;                                                      //新邮件 图片
    temping.Free;
end;

procedure TFrmNEWEmail.A2Button3Click(Sender: TObject);
begin
    Visible := false;
    FrmQuantity.Visible := false;
    A2ILabelNEWitem.A2Image := nil;
    A2ILabelNEWitem.Caption := '';
end;

end.

