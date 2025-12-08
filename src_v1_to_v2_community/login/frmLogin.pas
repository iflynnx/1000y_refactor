unit frmLogin;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, deftype, uSQLDBAdapter;

type
    TFormLogin = class(TForm)
        panel_account: TPanel;
        Panel1: TPanel;
        Edit_find_PrimaryKey: TEdit;
        Label1: TLabel;
        Button_account_find: TButton;
        Button_account_save: TButton;
        Label2: TLabel;
        Edit_db_primary: TEdit;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;
        Label7: TLabel;
        Label8: TLabel;
        Label9: TLabel;
        Label10: TLabel;
        Label11: TLabel;
        Label12: TLabel;
        Label13: TLabel;
        Label14: TLabel;
        Label16: TLabel;
        Label17: TLabel;
        Label18: TLabel;
        Label20: TLabel;
        Label21: TLabel;
        Label22: TLabel;
        Label23: TLabel;
        Label24: TLabel;
        Label25: TLabel;
        Label26: TLabel;
        Label19: TLabel;
        Edit_Primarkey: TEdit;
        Edit_password: TEdit;
        Edit_UserName: TEdit;
        Edit_Birth: TEdit;
        Edit_Address: TEdit;
        Edit_NativeNumber: TEdit;
        Edit_MasterKey: TEdit;
        Edit_Email: TEdit;
        Edit_Phone: TEdit;
        Edit_ParentName: TEdit;
        Edit_ParentNativeNumber: TEdit;
        Edit_Char1_name: TEdit;
        Edit_Char3_name: TEdit;
        Edit_Char4_name: TEdit;
        Edit_Char5_name: TEdit;
        Edit_Server1_Name: TEdit;
        Edit_Server2_Name: TEdit;
        Edit_Server3_Name: TEdit;
        Edit_Server4_Name: TEdit;
        Edit_Server5_Name: TEdit;
        Edit_IpAddr: TEdit;
        Edit_MakeDate: TEdit;
        Edit_LastDate: TEdit;
        Edit_Char2_name: TEdit;
        Label15: TLabel;
        Button_Save_account: TButton;
        Button1: TButton;
        Button2: TButton;
        CheckBoxCHANGECharName1: TCheckBox;
        CheckBoxCHANGECharName2: TCheckBox;
        CheckBoxCHANGECharName3: TCheckBox;
        CheckBoxCHANGECharName4: TCheckBox;
        CheckBoxCHANGECharName5: TCheckBox;
    Button3: TButton;
        procedure Button_account_findClick(Sender: TObject);
        procedure Button_account_saveClick(Sender: TObject);
        procedure Button_Save_accountClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    private
        procedure clear();
    public
        LgRecord: TLGRecord;
        procedure ShowUseraccount;
    end;

var
    FormLogin: TFormLogin;

implementation

{$R *.dfm}
 //===============================account1000y===============================================//

procedure TFormLogin.clear;
begin
    panel_account.Enabled := false;
    Button_account_save.Enabled := false;
    Edit_find_PrimaryKey.Enabled := true;
    Button_account_find.Enabled := true;
    FillChar(LgRecord, sizeof(LgRecord), 0);
end;

procedure TFormLogin.ShowUseraccount;
begin
    Edit_db_primary.Text := LgRecord.PrimaryKey;
    Edit_Primarkey.Text := LgRecord.PrimaryKey;
    Edit_password.Text := LgRecord.passWord;
    Edit_UserName.Text := LgRecord.UserName;
    Edit_Birth.Text := LgRecord.Birth;
    Edit_Address.Text := LgRecord.Address;
    Edit_NativeNumber.Text := LgRecord.NativeNumber;
    Edit_MasterKey.Text := LgRecord.MasterKey;
    Edit_Email.Text := LgRecord.Email;
    Edit_Phone.Text := LgRecord.Phone;
    Edit_ParentName.Text := LgRecord.ParentName;
    Edit_ParentNativeNumber.Text := LgRecord.ParentNativeNumber;
    Edit_Char1_name.Text := LgRecord.Charinfo[0].CharName;
    Edit_Char2_name.Text := LgRecord.Charinfo[1].CharName;
    Edit_Char3_name.Text := LgRecord.Charinfo[2].CharName;
    Edit_Char4_name.Text := LgRecord.Charinfo[3].CharName;
    Edit_Char5_name.Text := LgRecord.Charinfo[4].CharName;

    Edit_Server1_Name.Text := LgRecord.Charinfo[0].ServerName;
    Edit_Server2_Name.Text := LgRecord.Charinfo[1].ServerName;
    Edit_Server3_Name.Text := LgRecord.Charinfo[2].ServerName;
    Edit_Server4_Name.Text := LgRecord.Charinfo[3].ServerName;
    Edit_Server5_Name.Text := LgRecord.Charinfo[4].ServerName;




    Edit_IpAddr.Text := LgRecord.IpAddr;
    Edit_MakeDate.Text := LgRecord.MakeDate;
    Edit_LastDate.Text := LgRecord.LastDate;
end;

procedure TFormLogin.Button_account_findClick(Sender: TObject);
var
    fresult: integer;
begin
    Edit_find_PrimaryKey.Text := trim(Edit_find_PrimaryKey.Text);

    clear;
    fresult := SQLDBAdapter.lg_Select(Edit_find_PrimaryKey.Text, @LgRecord);
    case fresult of
        DB_OK:
            begin
                panel_account.Enabled := true;
                Button_account_save.Enabled := true;
                Edit_find_PrimaryKey.Enabled := false;
                Button_account_find.Enabled := false;
                ShowUseraccount();
            end;
        DB_ERR_NOTFOUND:
            begin
                ShowMessage('账号不存在');
                exit;
            end;
    else
        begin
            ShowMessage('其他错误');
            exit;
        end;
    end;
end;

procedure TFormLogin.Button_account_saveClick(Sender: TObject);
begin
    Edit_find_PrimaryKey.Text := trim(Edit_find_PrimaryKey.Text);
    if SQLDBAdapter.lg_Update(Edit_find_PrimaryKey.Text, @LgRecord) = DB_OK then
    begin
        ShowMessage('写入数据成功');
    end else
    begin
        ShowMessage('错误写入数据失败!');
    end;
    clear;
end;

procedure TFormLogin.Button_Save_accountClick(Sender: TObject);
begin
    LgRecord.passWord := Edit_password.Text;
    LgRecord.UserName := Edit_UserName.Text;
    LgRecord.Birth := Edit_Birth.Text;
    LgRecord.Address := Edit_Address.Text;
    LgRecord.NativeNumber := Edit_NativeNumber.Text;
    LgRecord.MasterKey := Edit_MasterKey.Text;
    LgRecord.Email := Edit_Email.Text;
    LgRecord.Phone := Edit_Phone.Text;
    LgRecord.ParentName := Edit_ParentName.Text;
    LgRecord.ParentNativeNumber := Edit_ParentNativeNumber.Text;
    LgRecord.Charinfo[0].CharName := Edit_Char1_name.Text;
    LgRecord.Charinfo[1].CharName := Edit_Char2_name.Text;
    LgRecord.Charinfo[2].CharName := Edit_Char3_name.Text;
    LgRecord.Charinfo[3].CharName := Edit_Char4_name.Text;
    LgRecord.Charinfo[4].CharName := Edit_Char5_name.Text;
    LgRecord.Charinfo[0].ServerName := Edit_Server1_Name.Text;
    LgRecord.Charinfo[1].ServerName := Edit_Server2_Name.Text;
    LgRecord.Charinfo[2].ServerName := Edit_Server3_Name.Text;
    LgRecord.Charinfo[3].ServerName := Edit_Server4_Name.Text;
    LgRecord.Charinfo[4].ServerName := Edit_Server5_Name.Text;
 

    LgRecord.IpAddr := Edit_IpAddr.Text;
    LgRecord.MakeDate := Edit_MakeDate.Text;
    LgRecord.LastDate := Edit_LastDate.Text;

    ShowMessage('保存成功');
end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin
    clear;
end;

procedure TFormLogin.Button1Click(Sender: TObject);
var
    tempLgRecord: TLGRecord;
    r: integer;
begin
    Edit_find_PrimaryKey.Text := trim(Edit_find_PrimaryKey.Text);
    fillchar(tempLgRecord, sizeof(tempLgRecord), 0);
    tempLgRecord.PrimaryKey := Edit_find_PrimaryKey.Text;
    tempLgRecord.PassWord := tempLgRecord.PrimaryKey;
    r := SQLDBAdapter.lg_Insert(Edit_find_PrimaryKey.Text, @tempLgRecord);
    case r of
        DB_ERR_DUPLICATE: ShowMessage('失败！数据存在。');
        DB_OK: ShowMessage('写入数据成功。');
    else ShowMessage('错误写入数据失败(其他错误)!');
    end;


end;

procedure TFormLogin.Button2Click(Sender: TObject);
var
    tempLgRecord: TLGRecord;
    r, i: integer;
begin
    Edit_find_PrimaryKey.Text := trim(Edit_find_PrimaryKey.Text);

    fillchar(tempLgRecord, sizeof(tempLgRecord), 0);
    for i := 0 to 99 do
    begin
        tempLgRecord.PrimaryKey := Edit_find_PrimaryKey.Text + inttostr(i);
        tempLgRecord.PassWord := Edit_find_PrimaryKey.Text + inttostr(i);
        r := SQLDBAdapter.lg_Insert(Edit_find_PrimaryKey.Text + inttostr(i), @tempLgRecord);
        case r of
            DB_ERR_DUPLICATE: ShowMessage('失败！数据存在。');
            DB_OK: ;                                                            // ShowMessage('写入数据成功。');
        else ShowMessage('错误写入数据失败(其他错误)!');
        end;
    end;



end;

procedure TFormLogin.Button3Click(Sender: TObject);
var
    tempLgRecord: TLGRecord;
    r: integer;
begin
    Edit_find_PrimaryKey.Text := trim(Edit_find_PrimaryKey.Text);
    fillchar(tempLgRecord, sizeof(tempLgRecord), 0);
    tempLgRecord.PrimaryKey := Edit_find_PrimaryKey.Text;
    tempLgRecord.PassWord := tempLgRecord.PrimaryKey;
    r := SQLDBAdapter.lg_delete(Edit_find_PrimaryKey.Text);
    case r of
        DB_OK: ShowMessage('删除数据成功。');
    else ShowMessage('错误(其他错误)!');
    end;

 Button_account_find.Enabled := true;
end;
end.

