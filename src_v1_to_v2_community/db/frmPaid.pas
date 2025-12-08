unit frmPaid;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, deftype, uDBAdapter;


type
    TFormPaid = class(TForm)
        Panel1: TPanel;
        Label1: TLabel;
        Edit_find_Paid: TEdit;
        Button_find_paid: TButton;
        Button_SavePaid_DB: TButton;
        PageControl1: TPageControl;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        Panel2: TPanel;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;
        Label7: TLabel;
        Edit_Paid_ID: TEdit;
        Edit_Paid_IP: TEdit;
        Edit_Paid_RemainDay: TEdit;
        Edit_Paid_maturity: TEdit;
        Edit_Paid_code: TEdit;
        Button_Paid_Save: TButton;
        ComboBox_type: TComboBox;
        Memo_paid: TMemo;
        Panel3: TPanel;
        Label8: TLabel;
        Edit_loginid: TEdit;
        Button2: TButton;
        Button1: TButton;
        Panel4: TPanel;
        Label9: TLabel;
        Edit_char: TEdit;
        Button3: TButton;
        Button4: TButton;
        procedure Button_find_paidClick(Sender: TObject);
        procedure Button_SavePaid_DBClick(Sender: TObject);
        procedure Button_Paid_SaveClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure Button4Click(Sender: TObject);
    private
    { Private declarations }
        procedure clear();
    public
        fPaidData: TPaidData;
        procedure showPaidData();
    end;

var
    FormPaid: TFormPaid;

implementation
uses uPaidConnector;
{$R *.dfm}

procedure TFormPaid.Button_find_paidClick(Sender: TObject);
var
    fresult: integer;
begin
    clear;
    Edit_find_Paid.Text := Trim(Edit_find_Paid.Text);
    fresult := PaidDBAdapter.Select(Edit_find_Paid.Text, @fPaidData);
    case fresult of
        DB_OK:
            begin
                showPaidData;
                Button_SavePaid_DB.Enabled := true;
                Panel2.Enabled := true;
                Button_find_paid.Enabled := false;
                Edit_find_Paid.Enabled := false;
            end;
        DB_ERR_NOTFOUND: ShowMessage('账号不存在');
    else ShowMessage('其他错误');
    end;
end;

procedure TFormPaid.clear;
begin
    Button_SavePaid_DB.Enabled := false;
    Panel2.Enabled := false;
    Button_find_paid.Enabled := true;
    Edit_find_Paid.Enabled := true;
    FillChar(fPaidData, sizeof(fPaidData), 0);
end;

procedure TFormPaid.showPaidData;
begin

    Edit_Paid_ID.Text := fPaidData.rLoginId;
    Edit_Paid_IP.Text := fPaidData.rIpAddr;
    Edit_Paid_RemainDay.Text := IntToStr(fPaidData.rRemainDay);
    case fPaidData.rPaidType of
        pt_none: ComboBox_type.Text := 'pt_none';
        pt_invalidate: ComboBox_type.Text := 'pt_invalidate';
        pt_validate: ComboBox_type.Text := 'pt_validate';
        pt_test: ComboBox_type.Text := 'pt_test';
        pt_timepay: ComboBox_type.Text := 'pt_timepay';
    end;
    Edit_Paid_maturity.Text := DateTimeToStr(fPaidData.rmaturity);
    Edit_Paid_code.Text := IntToStr(fPaidData.rCode);
end;

procedure TFormPaid.Button_SavePaid_DBClick(Sender: TObject);
begin
    Edit_find_Paid.Text := Trim(Edit_find_Paid.Text);
    if fPaidData.rLoginId <> Edit_find_Paid.Text then
    begin
        ShowMessage('未知错误');
        exit;
    end;
    if PaidDBAdapter.Update(Edit_find_Paid.Text, @fPaidData) = DB_OK then
    begin
        ShowMessage('保存成功');
    end else
    begin
        ShowMessage('错误保存失败');
    end;
    clear;
end;

procedure TFormPaid.Button_Paid_SaveClick(Sender: TObject);
begin
   // fPaidData.rLoginId := Edit_Paid_ID.Text;
    fPaidData.rIpAddr := Edit_Paid_IP.Text;
    fPaidData.rRemainDay := StrToInt(Edit_Paid_RemainDay.Text);
    fPaidData.rMakeDate := Edit_Paid_RemainDay.Text;

    if ComboBox_type.Text = 'pt_none' then fPaidData.rPaidType := pt_none
    else if ComboBox_type.Text = 'pt_invalidate' then fPaidData.rPaidType := pt_invalidate
    else if ComboBox_type.Text = 'pt_validate' then fPaidData.rPaidType := pt_validate
    else if ComboBox_type.Text = 'pt_test' then fPaidData.rPaidType := pt_test
    else if ComboBox_type.Text = 'pt_timepay' then fPaidData.rPaidType := pt_timepay;
    fPaidData.rmaturity := StrToDateTime(Edit_Paid_maturity.Text);
    fPaidData.rCode := StrToInt(Edit_Paid_code.Text);
end;

procedure TFormPaid.FormCreate(Sender: TObject);
begin
    clear;
end;

procedure TFormPaid.Button1Click(Sender: TObject);
begin
    if PaidConnectorList = nil then exit;
    Memo_paid.Lines.Text := PaidConnectorList.getmenu;
end;

procedure TFormPaid.Button2Click(Sender: TObject);
var
    temp: TuserList;
begin
    if PaidConnectorList = nil then exit;
    Memo_paid.Clear;
    temp := PaidConnectorList.getPaidLoginid(Edit_loginid.Text);
    if temp = nil then
    begin
        Memo_paid.Lines.Text := '无记录';
        exit;
    end;
    Memo_paid.Lines.Text := temp.getmenu;
end;

procedure TFormPaid.Button3Click(Sender: TObject);
var
    temp: PTNoticeData;
    tempuserlist: TuserList;
begin
    if PaidConnectorList = nil then exit;
    Memo_paid.Clear;
    temp := PaidConnectorList.getPaidUsername(Edit_char.Text);
    if temp = nil then exit;

    tempuserlist := PaidConnectorList.getPaidLoginid(temp.rLoginID);
    if tempuserlist = nil then
    begin
        Memo_paid.Lines.Text := '无记录';
        exit;
    end;
    Memo_paid.Lines.Text := tempuserlist.getmenu;
end;

procedure TFormPaid.Button4Click(Sender: TObject);
var
    temp: PTNoticeData;
begin
    if PaidConnectorList = nil then exit;
    Memo_paid.Clear;
    temp := PaidConnectorList.getPaidUsername(Edit_char.Text);
    if temp = nil then exit;

    PaidConnectorList.loginidCLOSEUser(temp.rCharName);
end;

end.

