unit frmEmail;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, deftype, uDBAdapter, uKeyClass ;

type
    TUserEmailData = record
        rname: string[64];
        rid: integer;
        rtitle: string[64];
        rEmaitText: string[64];
        rSourceName: string[64];
        rtime: TdateTime;
        rmoney: integer;
        rItemName: string[64];
    end;
    pTUserEmailData = ^TUserEmailData;



  //个人邮件列表
    TUserEmailClass = class
    private
        fdata: Tlist;
        fname: string;
        procedure clear;
    public

        constructor Create;
        destructor Destroy; override;

        procedure add(adata: TUserEmailData);

        function Get(aid: integer): pTUserEmailData;
        function GetIndex(aindex: integer): pTUserEmailData;
        function getCount(): integer;

    end;
 //全部邮件列表
    TUserEmailListClass = class
    private
        fdata: Tlist;
        fIndexName: TStringKeyClass;
        procedure add(aname: string);
        procedure clear;

    public
        constructor Create;
        destructor Destroy; override;

        function Get(aname: string): TUserEmailClass;
        function GetCount(): integer;
        procedure loaddb;
    end;


    TFormEmail = class(TForm)
        Panel1: TPanel;
        Label1: TLabel;
        Edit_find_Email_ID: TEdit;
        Button_find_Email_ID: TButton;
        Panel_update: TPanel;
        Button_change_Email: TButton;
        StringGrid_Email: TStringGrid;
        Label2: TLabel;
        Edit_Email_find_name: TEdit;
        Button_find_Email_Name: TButton;
        Button_Reload: TButton;
        Panel3: TPanel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;
        Label7: TLabel;
        Label8: TLabel;
        Label9: TLabel;
        Label10: TLabel;
        Label12: TLabel;
        Edit_Email_ID: TEdit;
        Edit_Email_DestName: TEdit;
        Edit_Email_Title: TEdit;
        Edit_Email_Text: TEdit;
        Edit_Email_SourceName: TEdit;
        Edit_Email_Time: TEdit;
        Edit_Email_ItemName: TEdit;
        Button_Email_Save: TButton;
        Button_Email_Close: TButton;
        Edit_Email_GoldMoney: TEdit;
        Button_item_edit: TButton;
        procedure Button_find_Email_IDClick(Sender: TObject);

        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure Button_find_Email_NameClick(Sender: TObject);
        procedure Button_ReloadClick(Sender: TObject);
        procedure Button_Email_CloseClick(Sender: TObject);
        procedure Button_Email_SaveClick(Sender: TObject);
        procedure Button_change_EmailClick(Sender: TObject);
        procedure Button_item_editClick(Sender: TObject);
    private
        procedure clear;
    public
        fAllEmail: TUserEmailListClass;
        tempEmailData: TEmaildata;

        procedure WriteAllEmailData();
        procedure WritePersonEmailData();
        procedure ShowEmailData(fEmailData: TEmailData);
        procedure showPersonEmailData(arow: integer; auseremail: TUserEmailData);

    end;

var
    FormEmail: TFormEmail;

implementation
uses UnitItemEditWin;
{$R *.dfm}



//==========================TPersonUserEmailItemListClass====================================================//

constructor TUserEmailClass.Create;
begin
    fdata := TList.Create;
end;


destructor TUserEmailClass.Destroy;
begin
    clear;
    fdata.Free;
    inherited;
end;

procedure TUserEmailClass.add(adata: TUserEmailData);
var
    p: pTUserEmailData;
begin
    if Get(adata.rid) <> nil then exit;
    new(p);
    p^ := adata;
    fdata.Add(p);

end;

procedure TUserEmailClass.clear;
var
    i: Integer;
    p: pTUserEmailData;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        dispose(p);
    end;
    fdata.Clear;

end;


function TUserEmailClass.Get(aid: integer): pTUserEmailData;
var
    i: Integer;
    p: pTUserEmailData;
begin
    result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rid = aid then
        begin
            result := p;
            exit;
        end;
    end;

end;

//获取个人所有邮件数量

function TUserEmailClass.GetCount(): integer;
begin
    Result := fdata.Count;
end;

function TUserEmailClass.GetIndex(aindex: integer): pTUserEmailData;
begin
    result := nil;
    if (aindex < 0) or (aindex >= fdata.Count) then exit;
    result := fdata.Items[aindex];
end;

//==========================TAllUserEmailItemListClass====================================================//
{ TAllUserEmailItemListClass }

constructor TUserEmailListClass.Create;
begin
    fdata := TList.Create;
    fIndexName := TStringKeyClass.Create;
end;

destructor TUserEmailListClass.Destroy;
begin
    clear;
    fdata.Free;
    fIndexName.Free;
    inherited;
end;

procedure TUserEmailListClass.add(aname: string);
var
    p: TUserEmailClass;
begin
    if Get(aname) <> nil then exit;
    p := TUserEmailClass.Create;
    p.fname := aname;
    fdata.Add(p);
    fIndexName.Insert(p.fname, p);
end;


procedure TUserEmailListClass.clear;
var
    i: Integer;
    p: TUserEmailClass;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        p.Free;
    end;
    fdata.Clear;
    fIndexName.Clear;
end;


function TUserEmailListClass.Get(aname: string): TUserEmailClass;
begin
    result := fIndexName.Select(aname);
end;

function TUserEmailListClass.GetCount: integer;
begin
    result := fdata.Count;
end;

procedure TUserEmailListClass.loaddb;
var
    templist: tstringlist;
    i: integer;
    tempdb: TEmaildata;
    p: TUserEmailClass;
    tempemail: TUserEmailData;
begin

    templist := tstringlist.Create;
    try
        templist.Text := EmailDBAdapter.SelectAllName;
        for i := 0 to templist.Count - 1 do
        begin
            if EmailDBAdapter.Select(templist.Strings[i], @tempdb) <> DB_OK then Continue;
            p := Get(tempdb.FDestName);
            if p = nil then
            begin
                add(tempdb.FDestName);
                p := Get(tempdb.FDestName);
                if p = nil then continue;
            end;
            tempemail.rname := tempdb.FDestName;
            tempemail.rtitle := tempdb.FTitle;
            tempemail.rid := tempdb.FID;
            tempemail.rEmaitText := tempdb.FEmailText;
            tempemail.rSourceName := tempdb.FsourceName;
            tempemail.rtime := tempdb.FTime;
            tempemail.rmoney := tempdb.FGOLD_Money;
            tempemail.rItemName := tempdb.Fbuf.rName;
            p.add(tempemail);
        end;

    finally
        templist.Free;
    end;

end;
//===================TFormEmail=========================================================//

procedure TFormEmail.FormCreate(Sender: TObject);
begin
    fAllEmail := TUserEmailListClass.Create;
    fAllEmail.loaddb;
end;

procedure TFormEmail.FormDestroy(Sender: TObject);
begin
    fAllEmail.Free;
end;

//重新载入数据库

procedure TFormEmail.Button_ReloadClick(Sender: TObject);
begin
    fAllEmail.clear;
    fAllEmail.loaddb;
end;

procedure TFormEmail.clear;
var
    i: integer;
    j: integer;
begin
    Button_change_Email.Enabled := false;
    for i := 0 to StringGrid_Email.RowCount do
    begin
        for j := 0 to StringGrid_Email.ColCount do
        begin
            StringGrid_Email.Rows[i].Strings[j] := '';
        end;
    end;
end;

//以名字作为索引进行查找

procedure TFormEmail.Button_find_Email_NameClick(Sender: TObject);
var
    p: TUserEmailClass;
    fEmailData: tEmailData;
    i: integer;
    pEmaildata: pTUserEmailData;
begin
    clear;
    Edit_Email_find_name.Text := trim(Edit_Email_find_name.Text);
    p := fAllEmail.Get(Edit_Email_find_name.Text);
    if p = nil then
    begin
        ShowMessage('角色名不存在');
        exit;
    end;
    StringGrid_Email.RowCount := p.getCount + 1;
    WritePersonEmailData();
    for i := 0 to p.getCount - 1 do
    begin
        pemaildata := p.GetIndex(i);
        if pEmaildata = nil then Continue;
     //   if EmailDBAdapter.Select(inttostr(pEmaildata.rid), @fEmailData) <> DB_OK then Continue;
        showPersonEmailData(i + 1, pEmaildata^);
    end;
    Button_change_Email.Enabled := false;
end;
 //邮件内容(NAME ID TITLE)

procedure TFormEmail.showPersonEmailData(arow: integer; auseremail: TUserEmailData);
begin
    StringGrid_Email.Rows[arow].Strings[0] := IntToStr(arow);
    StringGrid_Email.Rows[arow].Strings[1] := auseremail.rname;
    StringGrid_Email.Rows[arow].Strings[2] := IntToStr(auseremail.rid);
    StringGrid_Email.Rows[arow].Strings[3] := auseremail.rtitle;
    StringGrid_Email.Rows[arow].Strings[4] := auseremail.rEmaitText;
    StringGrid_Email.Rows[arow].Strings[5] := auseremail.rSourceName;
    StringGrid_Email.Rows[arow].Strings[6] := DateTimeToStr(auseremail.rtime);
    StringGrid_Email.Rows[arow].Strings[7] := IntToStr(auseremail.rmoney);
    StringGrid_Email.Rows[arow].Strings[8] := auseremail.rItemName;
end;

procedure TFormEmail.WritePersonEmailData;
begin
    StringGrid_Email.ColCount := 9;
    StringGrid_Email.Rows[0].Strings[0] := 'id';
    StringGrid_Email.Rows[0].Strings[1] := 'rname';
    StringGrid_Email.Rows[0].Strings[2] := 'rid';
    StringGrid_Email.Rows[0].Strings[3] := 'rtitle';
    StringGrid_Email.Rows[0].Strings[4] := 'rEmaitText';
    StringGrid_Email.Rows[0].Strings[5] := 'rSourceName';
    StringGrid_Email.Rows[0].Strings[6] := 'rtime';
    StringGrid_Email.Rows[0].Strings[7] := 'rmoney';
    StringGrid_Email.Rows[0].Strings[8] := 'rItemName';
end;

//以ID作为索引进行查找

procedure TFormEmail.Button_find_Email_IDClick(Sender: TObject);
var
    fEmailData: tEmailData;
begin
    Edit_find_Email_ID.Text := trim(Edit_find_Email_ID.Text);
    if EmailDBAdapter.Select(Edit_find_Email_ID.Text, @fEmailData) = DB_OK then
    begin
        Edit_Email_find_name.Text := fEmailData.FDestName;
        Button_find_Email_NameClick(Sender);
    end else
    begin
        ShowMessage('无纪录');
    end;
end;

procedure TFormEmail.ShowEmailData(fEmailData: TEmailData);
begin
    StringGrid_Email.Rows[1].Strings[0] := IntToStr(1);
    StringGrid_Email.Rows[1].Strings[1] := IntToStr(fEmailData.FID);
    StringGrid_Email.Rows[1].Strings[2] := fEmailData.FDestName;
    StringGrid_Email.Rows[1].Strings[3] := fEmailData.FTitle;
    StringGrid_Email.Rows[1].Strings[4] := fEmailData.FEmailText;
    StringGrid_Email.Rows[1].Strings[5] := fEmailData.FsourceName;
    StringGrid_Email.Rows[1].Strings[6] := DateTimeToStr(fEmailData.FTime);
    StringGrid_Email.Rows[1].Strings[7] := IntToStr(fEmailData.FGOLD_Money);
    StringGrid_Email.Rows[1].Strings[8] := IntToStr(fEmailData.Fbuf.rID);
    StringGrid_Email.Rows[1].Strings[9] := fEmailData.Fbuf.rName; ;
    StringGrid_Email.Rows[1].Strings[10] := IntToStr(fEmailData.Fbuf.rCount);
    StringGrid_Email.Rows[1].Strings[11] := IntToStr(fEmailData.Fbuf.rColor);
    StringGrid_Email.Rows[1].Strings[12] := IntToStr(fEmailData.Fbuf.rDurability);
    StringGrid_Email.Rows[1].Strings[13] := IntToStr(fEmailData.Fbuf.rDurabilityMAX);
    StringGrid_Email.Rows[1].Strings[14] := IntToStr(fEmailData.Fbuf.rSmithingLevel);
    StringGrid_Email.Rows[1].Strings[15] := IntToStr(fEmailData.Fbuf.rAttach);
    StringGrid_Email.Rows[1].Strings[16] := IntToStr(fEmailData.Fbuf.rlockState);
    StringGrid_Email.Rows[1].Strings[17] := IntToStr(fEmailData.Fbuf.rlocktime);
    StringGrid_Email.Rows[1].Strings[18] := IntToStr(fEmailData.Fbuf.rSetting.rsettingcount);
    StringGrid_Email.Rows[1].Strings[19] := fEmailData.Fbuf.rSetting.rsetting1;
    StringGrid_Email.Rows[1].Strings[20] := fEmailData.Fbuf.rSetting.rsetting2;
    StringGrid_Email.Rows[1].Strings[21] := fEmailData.Fbuf.rSetting.rsetting3;
    StringGrid_Email.Rows[1].Strings[22] := fEmailData.Fbuf.rSetting.rsetting4;
    StringGrid_Email.Rows[1].Strings[23] := DateTimeToStr(fEmailData.Fbuf.rDateTime);
end;


procedure TFormEmail.WriteAllEmailData;
begin
    clear;
    StringGrid_Email.ColCount := 24;
    StringGrid_Email.RowCount := 2;
    StringGrid_Email.Rows[0].Strings[0] := 'id';
    StringGrid_Email.Rows[0].Strings[1] := 'fid';
    StringGrid_Email.Rows[0].Strings[2] := 'FDestName';
    StringGrid_Email.Rows[0].Strings[3] := 'FTitle';
    StringGrid_Email.Rows[0].Strings[4] := 'FEmailText';
    StringGrid_Email.Rows[0].Strings[5] := 'FsourceName';
    StringGrid_Email.Rows[0].Strings[6] := 'FTime';
    StringGrid_Email.Rows[0].Strings[7] := 'FGOLD_Money';
    StringGrid_Email.Rows[0].Strings[8] := 'rItemID';
    StringGrid_Email.Rows[0].Strings[9] := 'rName';
    StringGrid_Email.Rows[0].Strings[10] := 'rCount';
    StringGrid_Email.Rows[0].Strings[11] := 'rColor';
    StringGrid_Email.Rows[0].Strings[12] := 'rDurability';
    StringGrid_Email.Rows[0].Strings[13] := 'rDurabilityMAX';
    StringGrid_Email.Rows[0].Strings[14] := 'rSmithingLevel';
    StringGrid_Email.Rows[0].Strings[15] := 'rAdditional';
    StringGrid_Email.Rows[0].Strings[16] := 'rlockState';
    StringGrid_Email.Rows[0].Strings[17] := 'rlocktime';
    StringGrid_Email.Rows[0].Strings[18] := 'rsettingcount';
    StringGrid_Email.Rows[0].Strings[19] := 'rsetting1';
    StringGrid_Email.Rows[0].Strings[20] := 'rsetting2';
    StringGrid_Email.Rows[0].Strings[21] := 'rsetting3';
    StringGrid_Email.Rows[0].Strings[22] := 'rsetting4';
    StringGrid_Email.Rows[0].Strings[23] := 'rDateTime';
end;

procedure TFormEmail.Button_Email_CloseClick(Sender: TObject);
begin
    Panel3.Visible := false;
    StringGrid_Email.Enabled := true;
    Panel_update.Enabled := true;
    Button_find_Email_NameClick(Sender);
end;

procedure TFormEmail.Button_Email_SaveClick(Sender: TObject);
var
    aEmailData: TEmaildata;
begin
    if tempEmailData.FID <> strtoInt(Edit_Email_ID.text) then
    begin
        ShowMessage('未知错误');
        exit;
    end;
    if EmailDBAdapter.Select(Edit_Email_ID.text, @aEmailData) <> db_ok then
    begin
        ShowMessage('当前编辑纪录不存在');
    end else
    begin
        tempEmailData.FDestName := Edit_Email_DestName.text;
        tempEmailData.FTitle := Edit_Email_Title.Text;
        tempEmailData.FEmailText := Edit_Email_Text.Text;
        tempEmailData.FsourceName := Edit_Email_SourceName.Text;
        tempEmailData.FTime := StrToDateTime(Edit_Email_Time.Text);
        tempEmailData.FGOLD_Money := StrToInt(Edit_Email_GoldMoney.Text);
        if EmailDBAdapter.Update(Edit_Email_ID.text, @aEmailData) = DB_OK then
        begin
            ShowMessage('保存成功');
        end else
        begin
            ShowMessage('保存失败！');
        end;

    end;
    Button_Email_CloseClick(Sender);
end;

procedure TFormEmail.Button_change_EmailClick(Sender: TObject);
var
    aid, arow: integer;

begin

    arow := StringGrid_Email.Selection.Top;
    aID := StrToInt(StringGrid_Email.Rows[arow].Strings[1]);
  //数据库中读

    if EmailDBAdapter.Select(InttoStr(aID), @tempEmailData) <> db_ok then
    begin
        ShowMessage('无纪录');
        exit;
    end;

    Edit_Email_ID.text := IntToStr(tempEmailData.FID);
    Edit_Email_DestName.text := tempEmailData.FDestName;
    Edit_Email_Title.Text := tempEmailData.FTitle;
    Edit_Email_Text.Text := tempEmailData.FEmailText;
    Edit_Email_SourceName.Text := tempEmailData.FsourceName;
    Edit_Email_Time.Text := DateTimeToStr(tempEmailData.FTime);
    Edit_Email_GoldMoney.Text := IntToStr(tempEmailData.FGOLD_Money);

    Edit_Email_ItemName.Text := tempEmailData.Fbuf.rName;

    Panel3.Left := 248;
    Panel3.Top := 72;
    Panel3.Visible := true;
    StringGrid_Email.Enabled := false;
    Panel_update.Enabled := false;

end;

procedure TFormEmail.Button_item_editClick(Sender: TObject);
var
    frmItemEdit: TfrmItemEdit;
begin

    frmItemEdit := TfrmItemEdit.Create(self);
    try
        frmItemEdit.Left := Left + 168;
        frmItemEdit.Top := top + 113;
        frmItemEdit.itemtowindows(tempEmailData.Fbuf);
        frmItemEdit.ShowModal;
        tempEmailData.Fbuf := frmItemEdit.tempitem;
    finally
        frmItemEdit.Free;
    end;

end;


end.

