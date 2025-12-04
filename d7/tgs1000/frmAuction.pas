unit frmAuction;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, deftype, uAuction, uKeyClass;

type
    TUserAuctionData = record
        rname: string[20];
        rid: integer;
        rItemID: Integer;
        rItemName: string[20];
        rPrice: integer;
        rTime: TDateTime;
        rMaxTime: integer;
        rBargainorName: string[20];
    end;
    PTUserAuctionData = ^TUserAuctionData;

  //个人拍卖列表
    TUserAuctionClass = class
    private
        fdata: Tlist;
        fname: string;
        procedure clear;
    public
        constructor Create;
        destructor Destroy; override;
        procedure add(adata: TUserAuctionData);
        function Get(aid: integer): PTUserAuctionData;
        function GetIndex(aindex: integer): PTUserAuctionData;
        function getCount(): integer;

    end;

  //全部拍卖列表
    TUserAuctionListClass = class
    private
        fdata: Tlist;
        fIndexName: TStringKeyClass;

        procedure clear;
    public
        constructor Create;
        destructor Destroy; override;
        procedure add(aname: string);
        function Get(aname: string): TUserAuctionClass;
        function GetCount(): integer;
        procedure loaddb;
        function GetMenu(): string;
    end;


    TFormAuction = class(TForm)
        Panel1: TPanel;
        Panel2: TPanel;
        Panel_update: TPanel;
        Button_change_Auction: TButton;
        StringGrid_Auction: TStringGrid;
        Label2: TLabel;
        Edit_Auction__find_name: TEdit;
        Button_find_Auction_name: TButton;
        Button_ReLoad: TButton;
        Panel_Auction_Edit: TPanel;
        Label3: TLabel;
        Button_Auction_Save: TButton;
        Button_Auction_Close: TButton;
        Label4: TLabel;
        Label5: TLabel;
        Edit_Auction_ID: TEdit;
        Edit_Auction_IMG: TEdit;
        Edit_Auction_MaxTime: TEdit;
        Edit_Auction_Itemtime: TEdit;
        Edit_Auction_Price: TEdit;
        Edit_Auction_DateTime: TEdit;
        Label19: TLabel;
        Label20: TLabel;
        Label21: TLabel;
        Label22: TLabel;
        Label23: TLabel;
        Label26: TLabel;
        Edit_Auction_Name: TEdit;
        ComboBox_Auction_PriceType: TComboBox;
        Panel_find: TPanel;
        Button_find_Auction_ID: TButton;
        Edit_Auction__find_ID: TEdit;
        Label1: TLabel;
        Button_item_edit: TButton;
        Label6: TLabel;
        Edit_item_name: TEdit;
        ListBox1: TListBox;

        procedure Button_Auction_CloseClick(Sender: TObject);
        procedure Button_change_AuctionClick(Sender: TObject);
        procedure Button_Auction_SaveClick(Sender: TObject);
        procedure Button_ReLoadClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure Button_find_Auction_IDClick(Sender: TObject);
        procedure Button_find_Auction_nameClick(Sender: TObject);
        procedure Button_item_editClick(Sender: TObject);
        procedure ListBox1Click(Sender: TObject);

    private
        procedure WriteAuctionInfo();
        procedure WriteUserNameInfo();
        procedure clear;
    public
        fAuctionList: TUserAuctionListClass;
        tempAuctionData: TAuctionData;
        procedure ShowAuctionData(fAuctionData: TAuctionData);
        procedure ShowUserAuctionData(arow: integer; temp: TUserAuctionData);


    end;



implementation
uses UnitItemEditWin;
{$R *.dfm}
//==============================TAuctionClass================================================//

 { TAuctionClass }

constructor TUserAuctionClass.Create;
begin
    fdata := TList.Create;
end;

destructor TUserAuctionClass.Destroy;
begin
    clear;
    fdata.Free;
    inherited;
end;

procedure TUserAuctionClass.add(adata: TUserAuctionData);
var
    p: PTUserAuctionData;
begin
    if Get(adata.rid) <> nil then exit;
    New(p);
    p^ := adata;
    fdata.Add(p);

end;

procedure TUserAuctionClass.clear;
var
    i: integer;
    p: PTUserAuctionData;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        dispose(p);
    end;
    fdata.Clear;
end;

function TUserAuctionClass.Get(aid: integer): PTUserAuctionData;
var
    i: integer;
    p: PTUserAuctionData;
begin
    Result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rid = aid then
        begin
            Result := p;
            exit;
        end;
    end;

end;

function TUserAuctionClass.getCount: integer;
begin
    Result := fdata.Count;
end;

function TUserAuctionClass.GetIndex(aindex: integer): PTUserAuctionData;
begin
    Result := nil;
    if (aindex < 0) or (aindex >= fdata.Count) then exit;
    Result := fdata.Items[aindex];
end;

//==============================TAuctionListClass================================================//

{ TAuctionListClass }

constructor TUserAuctionListClass.Create;
begin
    fdata := TList.Create;
    fIndexName := TStringKeyClass.Create;
end;

destructor TUserAuctionListClass.Destroy;
begin
    clear;
    fdata.Free;
    fIndexName.Free;
    inherited;
end;

procedure TUserAuctionListClass.add(aname: string);
var
    p: TUserAuctionClass;
begin
    if Get(aname) <> nil then exit;

    p := TUserAuctionClass.Create;
    p.fname := aname;
    fdata.Add(p);
    fIndexName.Insert(p.fname, p);
end;

procedure TUserAuctionListClass.clear;
var
    i: integer;
    p: TUserAuctionClass;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        p.Free;
    end;
    fdata.Clear;
    fIndexName.Clear;
end;

function TUserAuctionListClass.Get(aname: string): TUserAuctionClass;
begin
    Result := fIndexname.select(aname);
end;

function TUserAuctionListClass.GetCount: integer;
begin
    Result := fdata.Count;
end;

procedure TUserAuctionListClass.loaddb;
var
    tempList: TStringList;
    p: TUserAuctionClass;
    i: integer;
    tempData: TAuctionData;
    tempAuction: TUserAuctionData;
begin
    tempList := TStringList.Create;
    try

        tempList.Text := AuctionSystemClass.DBAuctionFile.SelectAllName;
        for i := 0 to tempList.Count - 1 do
        begin
            if AuctionSystemClass.DBAuctionFile.Select(tempList.Strings[i], @tempData) <> DB_OK then Continue;
            p := Get(tempData.rBargainorName);
            if p = nil then
            begin
                add(tempData.rBargainorName);
                p := Get(tempData.rBargainorName);
                if p = nil then continue;
            end;
            tempAuction.rname := tempData.rBargainorName;
            tempAuction.rid := tempData.rid;
            tempAuction.rItemID := tempData.rItem.rID;
            tempAuction.rItemName := tempData.rItem.rName;
            tempAuction.rPrice := tempData.rPrice;
            tempAuction.rTime := tempData.rTime;
            tempAuction.rMaxTime := tempData.rMaxTime;
            tempAuction.rBargainorName := tempData.rBargainorName;
            p.add(tempAuction);
        end;
    finally
        tempList.Free;
    end;

end;
//==============================TFormAuction================================================//

procedure TFormAuction.FormCreate(Sender: TObject);
begin
    fAuctionList := TUserAuctionListClass.Create;
    fAuctionList.loaddb;
    ListBox1.Items.Text := fAuctionList.GetMenu;

end;

procedure TFormAuction.FormDestroy(Sender: TObject);
begin
    fAuctionList.Free;
end;
 //重新载入数据库

procedure TFormAuction.Button_ReLoadClick(Sender: TObject);
begin
    fAuctionList.clear;
    fAuctionList.loaddb;
end;

procedure TFormAuction.clear;
var
    i: integer;
    j: integer;
begin
    Button_change_Auction.Enabled := false;
    StringGrid_Auction.RowCount := 2;
    StringGrid_Auction.ColCount := 2;
    for i := 0 to StringGrid_Auction.RowCount do
        for j := 0 to StringGrid_Auction.ColCount do
            StringGrid_Auction.Rows[i].Strings[j] := '';
end;

procedure TFormAuction.Button_find_Auction_nameClick(Sender: TObject);
var
    p: TUserAuctionClass;
    fAuctionData: TAuctionData;
    i: integer;
    pUserAucdata: pTUserAuctionData;
begin
    clear;
    Button_change_Auction.Enabled := false;
    Edit_Auction__find_name.Text := trim(Edit_Auction__find_name.Text);
    p := fAuctionList.Get(Edit_Auction__find_name.Text);
    if p = nil then
    begin
        ShowMessage('角色名不存在');
        exit;
    end;
    StringGrid_Auction.RowCount := p.getCount + 1;
    WriteUserNameInfo();
    for i := 0 to p.getCount - 1 do
    begin
        pUserAucdata := p.GetIndex(i);
        if pUserAucdata = nil then Continue;
       // if AuctionSystemClass.DBAuctionFile.Select(inttostr(pUserAucdata.rid), @fAuctionData) <> DB_OK then Continue;
        ShowUserAuctionData(i + 1, pUserAucdata^);
    end;
    Button_change_Auction.Enabled := true;
end;

procedure TFormAuction.ShowAuctionData(fAuctionData: TAuctionData);

begin
    StringGrid_Auction.Rows[1].Strings[0] := IntToStr(1);
    StringGrid_Auction.Rows[1].Strings[1] := IntToStr(fAuctionData.rid);
    StringGrid_Auction.Rows[1].Strings[2] := IntToStr(fAuctionData.ritemimg);
    StringGrid_Auction.Rows[1].Strings[3] := IntToStr(fAuctionData.rItem.rID);
    StringGrid_Auction.Rows[1].Strings[4] := fAuctionData.rItem.rName;
    StringGrid_Auction.Rows[1].Strings[5] := IntToStr(fAuctionData.rItem.rCount);
    StringGrid_Auction.Rows[1].Strings[6] := IntToStr(fAuctionData.rItem.rColor);
    StringGrid_Auction.Rows[1].Strings[7] := IntToStr(fAuctionData.rItem.rDurability);
    StringGrid_Auction.Rows[1].Strings[8] := IntToStr(fAuctionData.rItem.rDurabilityMAX);
    StringGrid_Auction.Rows[1].Strings[9] := IntToStr(fAuctionData.rItem.rSmithingLevel);
    StringGrid_Auction.Rows[1].Strings[10] := IntToStr(fAuctionData.rItem.rAttach);
    StringGrid_Auction.Rows[1].Strings[11] := IntToStr(fAuctionData.rItem.rlockState);
    StringGrid_Auction.Rows[1].Strings[12] := IntToStr(fAuctionData.rItem.rlocktime);


    StringGrid_Auction.Rows[1].Strings[13] := IntToStr(fAuctionData.rItem.rSetting.rsettingcount);
    StringGrid_Auction.Rows[1].Strings[14] := fAuctionData.rItem.rSetting.rsetting1;
    StringGrid_Auction.Rows[1].Strings[15] := fAuctionData.rItem.rSetting.rsetting2;
    StringGrid_Auction.Rows[1].Strings[16] := fAuctionData.rItem.rSetting.rsetting3;
    StringGrid_Auction.Rows[1].Strings[17] := fAuctionData.rItem.rSetting.rsetting4;
    StringGrid_Auction.Rows[1].Strings[18] := DateTimeToStr(fAuctionData.rItem.rDateTime);
    case fAuctionData.rPricetype of
        aptGold: StringGrid_Auction.Rows[1].Strings[19] := '游戏B';
        aptGOLD_Money: StringGrid_Auction.Rows[1].Strings[19] := '元宝';
    end;


    StringGrid_Auction.Rows[1].Strings[20] := IntToStr(fAuctionData.rPrice);
    StringGrid_Auction.Rows[1].Strings[21] := DateTimeToStr(fAuctionData.rTime);
    StringGrid_Auction.Rows[1].Strings[22] := IntToStr(fAuctionData.rMaxTime);
    StringGrid_Auction.Rows[1].Strings[23] := fAuctionData.rBargainorName;
end;

procedure TFormAuction.WriteAuctionInfo();
begin
    StringGrid_Auction.RowCount := 2;
    StringGrid_Auction.ColCount := 24;
    StringGrid_Auction.Rows[0].Strings[0] := 'id';
    StringGrid_Auction.Rows[0].Strings[1] := 'rid';
    StringGrid_Auction.Rows[0].Strings[2] := 'ritemimg';
    StringGrid_Auction.Rows[0].Strings[3] := 'rItemID';
    StringGrid_Auction.Rows[0].Strings[4] := 'rItemName';
    StringGrid_Auction.Rows[0].Strings[5] := 'rItemCount';
    StringGrid_Auction.Rows[0].Strings[6] := 'rItemColor';
    StringGrid_Auction.Rows[0].Strings[7] := 'rDurability';
    StringGrid_Auction.Rows[0].Strings[8] := 'rDurabilityMAX';
    StringGrid_Auction.Rows[0].Strings[9] := 'rSmithingLevel';
    StringGrid_Auction.Rows[0].Strings[10] := 'rAdditional';
    StringGrid_Auction.Rows[0].Strings[11] := 'rlockState';
    StringGrid_Auction.Rows[0].Strings[12] := 'rlocktime';
    StringGrid_Auction.Rows[0].Strings[13] := 'rsettingcount';
    StringGrid_Auction.Rows[0].Strings[14] := 'rsetting1';
    StringGrid_Auction.Rows[0].Strings[15] := 'rsetting2';
    StringGrid_Auction.Rows[0].Strings[16] := 'rsetting3';
    StringGrid_Auction.Rows[0].Strings[17] := 'rsetting4';
    StringGrid_Auction.Rows[0].Strings[18] := 'rDateTime';
    StringGrid_Auction.Rows[0].Strings[19] := 'rPricetype';
    StringGrid_Auction.Rows[0].Strings[20] := 'rPrice';
    StringGrid_Auction.Rows[0].Strings[21] := 'rTime';
    StringGrid_Auction.Rows[0].Strings[22] := 'rMaxTime';
    StringGrid_Auction.Rows[0].Strings[23] := 'rBargainorName';
end;


procedure TFormAuction.Button_Auction_CloseClick(Sender: TObject);
begin
    Panel_Auction_Edit.Left := 248;
    Panel_Auction_Edit.Top := 50;
    Panel_Auction_Edit.Visible := false;
    Panel_update.Enabled := true;
    StringGrid_Auction.Enabled := true;
    Button_find_Auction_nameClick(Sender);
end;

procedure TFormAuction.Button_change_AuctionClick(Sender: TObject);
var
    aid, arow: integer;
begin
    arow := StringGrid_Auction.Selection.Top;
    aid := StrToInt(StringGrid_Auction.Rows[arow].Strings[2]);
//数据库中读
    if AuctionSystemClass.DBAuctionFile.Select(InttoStr(aid), @tempAuctionData) <> db_ok then
    begin
        ShowMessage('纪录不存在');
        exit;
    end;

    Edit_Auction_ID.Text := IntToStr(tempAuctionData.rid);
    Edit_Auction_IMG.Text := IntToStr(tempAuctionData.ritemimg);
    Edit_item_name.Text := tempAuctionData.rItem.rName;
    case tempAuctionData.rPricetype of
        aptGold: ComboBox_Auction_PriceType.Text := '游戏B';
        aptGOLD_Money: ComboBox_Auction_PriceType.Text := '元宝';
    end;
    Edit_Auction_Price.Text := IntToStr(tempAuctionData.rPrice);
    Edit_Auction_MaxTime.Text := IntToStr(tempAuctionData.rMaxTime);
    Edit_Auction_Itemtime.Text := DateTimeToStr(tempAuctionData.rMaxTime);
    Edit_Auction_Name.Text := tempAuctionData.rBargainorName;

    Panel_Auction_Edit.Left := 248;
    Panel_Auction_Edit.Top := 50;
    Panel_Auction_Edit.Visible := true;
    Panel_update.Enabled := false;
    StringGrid_Auction.Enabled := false;
end;

procedure TFormAuction.Button_Auction_SaveClick(Sender: TObject);
var
    aAuctionData: TAuctionData;
begin
  //读最 新
    if tempAuctionData.rid <> StrToInt(Edit_Auction_ID.Text) then
    begin
        ShowMessage('未知错误');
        exit;
    end;
    if AuctionSystemClass.DBAuctionFile.Select(Edit_Auction_ID.Text, @aAuctionData) = db_ok then
    begin
        ShowMessage('当前编辑纪录不存在');
    end else
    begin
       //修改
        tempAuctionData.ritemimg := StrToInt(Edit_Auction_IMG.Text);
        if ComboBox_Auction_PriceType.Text = '游戏B' then
        begin
            tempAuctionData.rPricetype := aptGold;
        end else if ComboBox_Auction_PriceType.Text = '元宝' then
        begin
            tempAuctionData.rPricetype := aptGOLD_Money;
        end;
        tempAuctionData.rPrice := StrToInt(Edit_Auction_Price.Text);
        tempAuctionData.rMaxTime := StrToInt(Edit_Auction_MaxTime.Text);
        tempAuctionData.rTime := StrToDateTime(Edit_Auction_Itemtime.Text);
        tempAuctionData.rBargainorName := Edit_Auction_Name.Text;
        //保存
        if AuctionSystemClass.DBAuctionFile.Update(Edit_Auction_ID.Text, @tempAuctionData) = DB_OK then
        begin
            ShowMessage('保存成功');
        end else
        begin
            ShowMessage('保存失败');
        end;
    end;
    Button_Auction_CloseClick(Sender);
end;

procedure TFormAuction.Button_find_Auction_IDClick(Sender: TObject);
var
    aAuctionData: TAuctionData;
begin
    clear;
    Edit_Auction__find_ID.Text := Trim(Edit_Auction__find_ID.Text);
    if AuctionSystemClass.DBAuctionFile.Select(Edit_Auction__find_ID.Text, @aAuctionData) = DB_OK then
    begin
        Edit_Auction__find_name.Text := aAuctionData.rBargainorName;
        Button_find_Auction_nameClick(Sender);
    end else
    begin
        ShowMessage('无纪录');
    end;

end;



procedure TFormAuction.ShowUserAuctionData(arow: integer; temp: TUserAuctionData);
begin
    StringGrid_Auction.Rows[arow].Strings[0] := IntToStr(arow);
    StringGrid_Auction.Rows[arow].Strings[1] := temp.rname;
    StringGrid_Auction.Rows[arow].Strings[2] := IntToStr(temp.rid);
    StringGrid_Auction.Rows[arow].Strings[3] := IntToStr(temp.rItemID);
    StringGrid_Auction.Rows[arow].Strings[4] := temp.rItemName;
    StringGrid_Auction.Rows[arow].Strings[5] := IntToStr(temp.rPrice);
    StringGrid_Auction.Rows[arow].Strings[6] := DateTimeToStr(temp.rTime);
    StringGrid_Auction.Rows[arow].Strings[7] := IntToStr(temp.rMaxTime);
    StringGrid_Auction.Rows[arow].Strings[8] := temp.rBargainorName;

end;

procedure TFormAuction.WriteUserNameInfo();
begin
    StringGrid_Auction.ColCount := 9;
    StringGrid_Auction.Rows[0].Strings[0] := 'id';
    StringGrid_Auction.Rows[0].Strings[1] := 'rname';
    StringGrid_Auction.Rows[0].Strings[2] := 'rID';
    StringGrid_Auction.Rows[0].Strings[3] := 'rItemID';
    StringGrid_Auction.Rows[0].Strings[4] := 'rItemName';
    StringGrid_Auction.Rows[0].Strings[5] := 'rPrice';
    StringGrid_Auction.Rows[0].Strings[6] := 'rTime';
    StringGrid_Auction.Rows[0].Strings[7] := 'rMaxTime';
    StringGrid_Auction.Rows[0].Strings[8] := 'rBargainorName';
end;

procedure TFormAuction.Button_item_editClick(Sender: TObject);
var
    frmItemEdit: TfrmItemEdit;
begin

    frmItemEdit := TfrmItemEdit.Create(self);
    try
        frmItemEdit.Left := Left + 168;
        frmItemEdit.Top := top + 113;
        frmItemEdit.itemtowindows(tempAuctionData.rItem);
        frmItemEdit.ShowModal;
        tempAuctionData.rItem := frmItemEdit.tempitem;
    finally
        frmItemEdit.Free;
    end;

end;

procedure TFormAuction.ListBox1Click(Sender: TObject);
begin
    if ListBox1.ItemIndex < 0 then exit;
    Edit_Auction__find_name.Text := ListBox1.Items.Strings[ListBox1.ItemIndex];
end;

function TUserAuctionListClass.GetMenu: string;
var
    i: integer;
    p: TUserAuctionClass;
begin
    result := '';
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        result := result + p.fname + #13#10;
    end;

end;

end.

