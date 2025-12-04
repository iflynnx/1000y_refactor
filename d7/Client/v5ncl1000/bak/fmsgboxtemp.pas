unit fmsgboxtemp;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, A2Form, StdCtrls, ExtCtrls, deftype;

type
    TfrmMsgBoxTemp = class(TForm)
        A2Label1: TA2Label;
        A2Button1: TA2Button;
        A2Form: TA2Form;
        A2ListBox1: TA2ListBox;
        procedure FormCreate(Sender: TObject);
        procedure A2Button1Click(Sender: TObject);
    private

        { Private declarations }
    public
        { Public declarations }
        procedure MessageProcess(var code: TWordComData);
        procedure ShowBox(aCaption, astr: string);
    end;

var
    frmMsgBoxTemp: TfrmMsgBoxTemp;

implementation
uses FMain, filepgkclass, A2IMG, FAttrib;

{$R *.dfm}



procedure TfrmMsgBoxTemp.ShowBox(aCaption, astr: string);
begin
    A2Label1.Caption := aCaption;
    A2ListBox1.StringList.Text := formatStr(astr, A2ListBox1.Width);
    A2ListBox1.DrawItem;
    Visible := true;
end;

procedure TfrmMsgBoxTemp.MessageProcess(var code: TWordComData);
var
    pckey: PTCKey;
    aCaption, astr: string;
    i: integer;
begin
    pckey := @Code.Data;
    case pckey^.rmsg of
        SM_MsgBoxTemp:
            begin
                i := 1;
                aCaption := WordComData_GETStringPro(code, i);
                astr := WordComData_GETStringPro(code, i);
                A2Label1.Caption := aCaption;
                A2ListBox1.StringList.Text := astr;
                A2ListBox1.DrawItem;
                Visible := true;
            end;
    end;
end;

procedure TfrmMsgBoxTemp.FormCreate(Sender: TObject);
var
    temping, temping2: TA2Image;
begin

    FrmM.AddA2Form(Self, A2form);
    Left := 0;
    Top := 0;
   // if WinVerType <> wvtNew then exit;
    pgkBmp.getBmp('温馨提示窗口.bmp', A2Form.FImageSurface);
    A2Form.boImagesurface := true;
    temping := TA2Image.Create(32, 32, 0, 0);
    temping2 := TA2Image.Create(32, 32, 0, 0);
    try
        pgkBmp.getBmp('温馨提示_下拉条底框.bmp', temping);
        A2ListBox1.SetScrollBackImage(temping);
        pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', temping);
        pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', temping2);
        A2ListBox1.SetScrollTopImage(temping, temping2);
        pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', temping);
        pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', temping2);
        A2ListBox1.SetScrollTrackImage(temping, temping2);
        pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', temping);
        pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', temping2);
        A2ListBox1.SetScrollBottomImage(temping, temping2);

        pgkBmp.getBmp('温馨提示_确认_弹起.bmp', temping);
        A2Button1.A2Up := temping;
        pgkBmp.getBmp('温馨提示_确认_鼠标.bmp', temping);
        A2Button1.A2Mouse := temping;
        pgkBmp.getBmp('温馨提示_确认_按下.bmp', temping);
        A2Button1.A2Down := temping;
        pgkBmp.getBmp('温馨提示_确认_禁止.bmp', temping);
        A2Button1.A2NotEnabled := temping;
    finally
        temping.Free;
        temping2.Free;
    end;

end;

procedure TfrmMsgBoxTemp.A2Button1Click(Sender: TObject);
begin
    Visible := false;
end;

end.

