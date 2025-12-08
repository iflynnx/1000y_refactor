unit fSkill;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics,
    Controls, Forms, Dialogs, StdCtrls, A2Form, A2Img, deftype, ExtCtrls,AUtil32;
type
    TMaterialData = record
        rName: TNameString;
        rShape: integer;
        rGrade: integer;
        rItemNameArr: array[0..10 - 1] of TNameString;
        rItemCountArr: array[0..10 - 1] of integer;
    end;
    pTMaterialData = ^TMaterialData;

    TMaterialclass = class
    private
        dataList: tlist;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Add(var aMaterialData: TMaterialData);
        procedure clear;
        function get(aname: string): pTMaterialData;
        function getIndex(aindex: integer): pTMaterialData;
        function getMenu(): string;
        procedure Load(astr: string);
    end;


    TfrmSkill = class(TForm)
        lbJob: TA2Label;
        A2Form: TA2Form;
        A2Button_Exit: TA2Button;
        lbLevel: TA2Label;
        list_blueprint: TA2ListBox;
        A2Button_create: TA2Button;
        Gauge1: TA2Gauge;
        Timer1: TTimer;
        list_Material: TA2ListBox;
        A2CheckBox_sex_nan: TA2CheckBox;
        A2CheckBox_sex_nv: TA2CheckBox;
        Lb_Create_Atz: TA2ILabel;
        Lb_blueprint: TA2ILabel;
    Timer2: TTimer;
    A2Button1: TA2Button;
    A2Edit_inPower: TA2Edit;
    A2Button2: TA2Button;
    A2Button3: TA2Button;
        procedure FormCreate(Sender: TObject);
        procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2Button_ExitClick(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure list_blueprintAdxDrawItem(ASurface: TA2Image; index: Integer;
            aStr: string; Rect: TRect; State: TDrawItemState; fx, fy: Integer);
        procedure A2Button_createClick(Sender: TObject);
        procedure list_blueprintClick(Sender: TObject);
        procedure A2CheckBox_sex_nanClick(Sender: TObject);
        procedure A2CheckBox_sex_nvClick(Sender: TObject);
        procedure Lb_Create_AtzMouseMove(Sender: TObject; Shift: TShiftState;
            X, Y: Integer);
        procedure A2Button_createMouseMove(Sender: TObject; Shift: TShiftState;
            X, Y: Integer);
    procedure Timer2Timer(Sender: TObject);
   procedure create;
    procedure A2Button1Click(Sender: TObject);
    procedure A2Edit_inPowerChange(Sender: TObject);
    procedure A2Edit_inPowerKeyPress(Sender: TObject; var Key: Char);
    procedure A2Button2Click(Sender: TObject);
    procedure A2Button3Click(Sender: TObject);
    private
        procedure send_Job_create(aname: string);
        { Private declarations }
    public
        { Public declarations }
        JobKInd: integer;
        JobMaxItemGrade: integer;
        Job_level: integer;
        Job_Grade: integer;
        Job_shape: integer;
        jobTools: string;
        jobName: string;
        Materialclass: TMaterialclass;

        jobcreateState: integer;
        jobcreateTick: integer;
        jobcreateId: integer;
        A2ImageLib: TA2ImageLib;
        procedure send_Get_Job_blueprint_Menu;
        procedure SetNewVersion;
        procedure MessageProcess(var code: TWordComData);
        procedure onHaveitemUPdate(akey: integer; aitem: titemdata);
    end;

var
    frmSkill: TfrmSkill;
    xcount:Integer=0;
    icount:Integer=0;
implementation

uses UserSdb, FMain, FBottom, FAttrib, Fbl, filepgkclass, CharCls, AtzCls;

{$R *.DFM}



procedure TfrmSkill.SetNewVersion;
var
    temping, tempUp, tempDown: TA2Image;

begin
    temping := TA2Image.Create(32, 32, 0, 0);
    tempUp := TA2Image.Create(32, 32, 0, 0);
    tempDown := TA2Image.Create(32, 32, 0, 0);
    try
       pgkBmp.getBmp('制造窗口底框.bmp', A2form.FImageSurface);
      // A2form.FImageSurface.LoadFromFile(ExtractFilePath(ParamStr(0))+'\bmp\制造窗口底框.bmp');
        A2form.boImagesurface := true;

        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
        A2Button_Exit.A2Up := temping;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
        A2Button_Exit.A2Down := temping;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
        A2Button_Exit.A2Mouse := temping;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
        A2Button_Exit.A2NotEnabled := temping;

        pgkBmp.getBmp('登陆界面_确认_弹起.bmp', temping);
        A2Button_create.A2Up := temping;
        pgkBmp.getBmp('登陆界面_确认_按下.bmp', temping);
        A2Button_create.A2Down := temping;
        pgkBmp.getBmp('登陆界面_确认_鼠标.bmp', temping);
        A2Button_create.A2Mouse := temping;
        pgkBmp.getBmp('登陆界面_确认_禁止.bmp', temping);
        A2Button_create.A2NotEnabled := temping;

        pgkBmp.getBmp('登陆界面_取消_弹起.bmp', temping);
        A2Button1.A2Up := temping;
        pgkBmp.getBmp('登陆界面_取消_按下.bmp', temping);
        A2Button1.A2Down := temping;
        pgkBmp.getBmp('登陆界面_取消_鼠标.bmp', temping);
        A2Button1.A2Mouse := temping;
        pgkBmp.getBmp('登陆界面_取消_禁止.bmp', temping);
        A2Button1.A2NotEnabled := temping;


        pgkBmp.getBmp('制造窗口_男子_鼠标.bmp', temping);
        A2CheckBox_sex_nan.SelectImage := temping;
        pgkBmp.getBmp('制造窗口_男子_按下.bmp', temping);
        A2CheckBox_sex_nan.SelectImage := temping;

        pgkBmp.getBmp('制造窗口_女子_鼠标.bmp', temping);
        A2CheckBox_sex_nv.SelectImage := temping;
        pgkBmp.getBmp('制造窗口_女子_按下.bmp', temping);
        A2CheckBox_sex_nv.SelectImage := temping;

        pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
        list_blueprint.SetScrollTopImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
        list_blueprint.SetScrollTrackImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
        list_blueprint.SetScrollBottomImage(tempUp, tempDown);
        pgkBmp.getBmp('制造窗口下拉条底框.bmp', temping);

        pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', temping);
        A2Button2.A2Up :=temping;
        pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', temping);
        A2Button2.A2Down := temping;
        pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp',temping);
        A2Button2.A2Mouse := temping;
        pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', temping);
        A2Button3.A2Up := temping;
        pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', temping);
        A2Button3.A2Down :=temping;
        pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', temping);
        A2Button3.A2Mouse :=temping;



        list_blueprint.SetScrollBackImage(temping);

        list_blueprint.FFontSelBACKColor := 15;
        //list_blueprint.FLayout := tlCenter;
        list_blueprint.Font.Color := WinRGB(31, 31, 31);


        A2CheckBox_sex_nan.Checked := true;
    finally
        temping.Free;
        tempUp.Free;
        tempDown.Free;
    end;

end;


procedure TfrmSkill.FormCreate(Sender: TObject);
begin
    A2Edit_inPower.Text := IntToStr(1);
    JobKInd := 0;
    Job_level := 0;
    FrmM.AddA2Form(Self, A2form);
    Left := 20;
    Top := 20;
    SetNewVersion;
    Lb_blueprint.Transparent := true;
    Lb_Create_Atz.Transparent := true;
    Materialclass := TMaterialclass.Create;
    A2ImageLib := TA2ImageLib.Create;
end;

procedure TfrmSkill.FormMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmSkill.A2Button_ExitClick(Sender: TObject);
begin
    Visible := false;
end;




{ TMaterialclass }

function FdataGrade(Item1, Item2: Pointer): Integer;
begin
    if pTMaterialData(Item1).rGrade > pTMaterialData(Item2).rGrade then Result := 1
    else if pTMaterialData(Item1).rGrade < pTMaterialData(Item2).rGrade then Result := -1
    else Result := 0;
end;

procedure TMaterialclass.Add(var aMaterialData: TMaterialData);
var
    p: pTMaterialData;
begin
    if get(aMaterialData.rName) <> nil then exit;
    new(p);
    p^ := aMaterialData;
    dataList.Add(p);
end;

procedure TMaterialclass.clear;
var
    i: integer;
    p: pTMaterialData;
begin
    for i := 0 to dataList.Count - 1 do
    begin
        p := dataList.Items[i];
        dispose(p);
    end;
    dataList.Clear;
end;


constructor TMaterialclass.Create;
begin
    dataList := TList.Create;
end;

destructor TMaterialclass.Destroy;
begin
    clear;
    dataList.Free;
    inherited;
end;

function TMaterialclass.getMenu: string;
var
    i: integer;
    p: pTMaterialData;
begin
    result := '';
    for i := 0 to dataList.Count - 1 do
    begin
        p := dataList.Items[i];
        result := result + '' + #13#10;
    end;

end;

procedure TMaterialclass.Load(astr: string);
var
    i, j: Integer;
    temp: TMaterialData;
    filesdb: TUserStringDb;
    iName: string;
    tempString: tstringlist;
begin
    clear;
    //name,shape,Grade,mn1,mc1,mn2,mc2,mn3,mc3,mn4,mc4,
    tempString := tstringlist.Create;
    filesdb := TUserStringDb.Create;
    try
        tempString.Text := astr;
        filesdb.LoadFromStringList(tempString);
        for i := 0 to filesdb.Count - 1 do
        begin
            iName := filesdb.GetIndexName(i);
            FillChar(temp, sizeof(temp), 0);
            temp.rName := filesdb.GetFieldValueString(iName, 'Name');
            temp.rShape := filesdb.GetFieldValueInteger(iName, 'shape');
            temp.rGrade := filesdb.GetFieldValueInteger(iName, 'Grade');
            for j := 0 to 4 - 1 do
            begin
                temp.rItemNameArr[j] := filesdb.GetFieldValueString(iName, 'mn' + inttostr(j + 1));
                temp.rItemCountArr[j] := filesdb.GetFieldValueInteger(iName, 'mc' + inttostr(j + 1));
            end;
            Add(temp);
        end;
    finally
        tempString.Free;
        filesdb.free;
    end;
    dataList.Sort(FdataGrade);

end;

function TMaterialclass.get(aname: string): pTMaterialData;
var
    i: integer;
    p: pTMaterialData;
begin
    result := nil;
    for i := 0 to dataList.Count - 1 do
    begin
        p := dataList.Items[i];
        if p.rName = aname then
        begin
            result := p;
            exit;
        end;
    end;
end;

procedure TfrmSkill.FormDestroy(Sender: TObject);
begin
    Materialclass.Free;
    A2ImageLib.Free;
end;
{
    Job_Item_Material = 1;                                                      //物品 生产 材料表
    Jog_Skill = 2;                                                              //职业 技能 属性
    Job_blueprint_Menu = 3;                                                     //生产 图纸菜单}

procedure TfrmSkill.send_Get_Job_blueprint_Menu();
var
    temp: TWordComData;
begin

 //   if JobKInd = 0 then exit;     //2013年1月22日修改
    if Materialclass.dataList.Count > 0 then exit;
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Job);
    WordComData_ADDbyte(temp, Job_blueprint_Menu);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmSkill.send_Job_create(aname: string);
var
    temp: TWordComData;
begin
    if JobKInd = 0 then exit;
    if aname = '' then exit;
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Job);
    WordComData_ADDbyte(temp, Job_create);
    WordComData_ADDString(temp, aname);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmSkill.MessageProcess(var code: TWordComData);
var
    pckey: PTCKey;
    n, i, id, akey: integer;
    str: string;
begin
    pckey := @Code.Data;
    case pckey^.rmsg of
        SM_Job:
            begin
                id := 1;
                n := WordComData_GETbyte(code, id);
                case n of

                    Job_Skill:                                                  //职业 技能 属性
                        begin
                        {
    WordComData_ADDbyte(ComData, SM_Job);
    WordComData_ADDbyte(ComData, Job_Skill);

    WordComData_ADDbyte(ComData, ajobKind);
    WordComData_ADDbyte(ComData, aMaxItemGrade);
    WordComData_ADDbyte(ComData, aGrade);

    WordComData_ADDdword(ComData, ajobLevel);
    WordComData_ADDString(ComData, sname);
    WordComData_ADDString(ComData, stools);}
                            JobKInd := WordComData_GETbyte(code, id);
                            JobMaxItemGrade := WordComData_GETbyte(code, id);
                            Job_Grade := WordComData_GETbyte(code, id);

                            Job_level := WordComData_GETdword(code, id);
                            Job_shape := WordComData_GETword(code, id);

                            jobName := WordComData_GETString(code, id);
                            jobTools := WordComData_GETString(code, id);


                            lbJob.Caption := '';
                            case JobKInd of
                                1: lbJob.Caption := '铸造师';
                                2: lbJob.Caption := '炼丹师';
                                3: lbJob.Caption := '裁缝';
                                4: lbJob.Caption := '工匠';
                            else
                                begin
                                    lbJob.Caption := '';
                                    lbLevel.Caption := '';
                                    A2ImageLib.Clear;
                                    Lb_Create_Atz.A2Image := A2ImageLib.Images[0];
                                    list_Material.Clear;
//                                    list_Material.DrawItem;
                                    list_blueprint.Clear;
  //                                  list_blueprint.DrawItem;
                                    exit;
                                end;
                            end;
                          //  lbJob.Caption := lbJob.Caption + '(' + jobName + ')';
                            lbLevel.Caption :=  Get10000To100(Job_level);
                            A2ImageLib.Clear;
                            str := inttostr(Job_shape);
                            if length(str) = 1 then str := '0' + str;
                            str := format('.\res\m%s.atz', [str]);
                            if FileExists(str) then A2ImageLib.LoadFromFile(str);
                            Lb_Create_Atz.A2Image := A2ImageLib.Images[0];
                            list_blueprint.DrawItem;
                        end;
                    Job_blueprint_Menu:                                         //生产 图纸菜单
                        begin
                            str := WordComData_GETStringPro(code, id);
                            Materialclass.Load(str);
                            list_blueprint.Clear;
                            list_blueprint.StringList.Text := Materialclass.getMenu;
                            list_blueprint.DrawItem;
                        end;
                end;

            end;
    end;

end;

{
 FA2ImageLib.Clear;
    pgksprite.getImageLib('m09.atz', FA2ImageLib);
}

procedure TfrmSkill.Timer1Timer(Sender: TObject);
var
    p: pTMaterialData;
    i: integer;
    str: string;
begin

    if Visible = false then exit;
    case jobcreateState of
        1:
            begin
             //   A2Button_create.Visible := false;
            //    A2Button1.Visible:=True;
                jobcreateState := 2;
                jobcreateId := 0;
                Gauge1.Progress := 0;
                list_blueprint.Enabled := false;
            end;
        2:
            begin
                if jobcreateId >= A2ImageLib.Count then
                begin
                    jobcreateId := 0;
                    jobcreateState := 3;
                end;
                Lb_Create_Atz.A2Image := A2ImageLib.Images[jobcreateId];
                if A2ImageLib.Count > 0 then
                    Gauge1.Progress := (jobcreateId * 100) div A2ImageLib.Count;
                inc(jobcreateId);
            end;
        3:
            begin
                i := list_blueprint.ItemIndex;
                p := Materialclass.getIndex(i);
                if p = nil then exit;
                send_Job_create(p.rName);
                jobcreateState := 4;
                jobcreateId := 0;
            end;
        4:
            begin
                if jobcreateId >= A2ImageLib.Count then
                begin
                    jobcreateId := 0;
                    jobcreateState := 100;
                end;
                Lb_Create_Atz.A2Image := A2ImageLib.Images[jobcreateId];
                if A2ImageLib.Count > 0 then
                    Gauge1.Progress := (jobcreateId * 100) div A2ImageLib.Count;
                inc(jobcreateId);
            end;
        100:
            begin
                jobcreateState := 0;
             //   A2Button_create.Visible := true;
             //   A2Button1.Visible:=false;
                list_blueprint.Enabled := true;
                Lb_Create_Atz.A2Image := A2ImageLib.Images[0];
            end;
    else
        begin


        end;
    end;

end;

procedure TfrmSkill.list_blueprintAdxDrawItem(ASurface: TA2Image;
    index: Integer; aStr: string; Rect: TRect; State: TDrawItemState; fx,
    fy: Integer);
var
    tt: TA2Image;
    i1, x, y: integer;
    t1: pTMaterialData;
    str1, strGrade: string;
    R: TRect;
    aFontColor: integer;
begin
    if index = list_blueprint.ItemIndex then list_blueprintClick(nil);
    R := list_blueprint.ClientRect;
    OffsetRect(R, left, top);

    t1 := Materialclass.getIndex(index);
    if t1 = nil then
    begin
        i1 := 0;
        str1 := aStr;
        aFontColor := list_blueprint.FontColor;
        strGrade := '';
    end
    else
    begin
        i1 := t1.rShape;
        str1 := t1.rName;
        if t1.rGrade <= JobMaxItemGrade then
            aFontColor := list_blueprint.FontColor
        else
            aFontColor := ColorSysToDxColor($00575757);
        strGrade := inttostr(t1.rGrade) + '品';
    end;

    tt := AtzClass.GetItemImage(i1);

    x := (list_blueprint.ItemHeight - tt.Width) div 2;
    y := (list_blueprint.ItemHeight - tt.Height) div 2;
    ASurface.DrawImage(tt, x, y, TRUE);

    ATextOut(ASurface, fx + 33, fy, aFontColor, str1);
    ATextOut(ASurface, fx + 33, fy + 15, aFontColor, strGrade);
end;

function TMaterialclass.getIndex(aindex: integer): pTMaterialData;
begin
    result := nil;
    if (aindex < 0) or (aindex >= dataList.Count) then exit;
    result := dataList.Items[aindex];
end;

procedure TfrmSkill.A2Button_createClick(Sender: TObject);
var
s :string;
begin
  if Timer2.Enabled then
  begin
    Timer2.Enabled:=False;
    Exit;
    end;

      try
      xcount:=_StrToInt(trim(A2Edit_inPower.Text));
      except
      xcount:=1;
      end;
   if xcount=0 then Exit;
   create;
  if xcount=1 then  Exit;
  A2Button_create.Visible := false;
  A2Button1.Visible:=True;
  Timer2.Enabled:=True;

end;

procedure TfrmSkill.list_blueprintClick(Sender: TObject);
var
    p: pTMaterialData;
    i, hcount: integer;
    str: string;
    tp: PTItemData;
begin
    list_Material.Clear;
    i := list_blueprint.ItemIndex;
    p := Materialclass.getIndex(i);
    if p = nil then exit;
    for i := 0 to high(p.rItemNameArr) do
    begin

        if p.rItemNameArr[i] = '' then Break;
        hcount := 0;

        tp := HaveItemclass.getname(p.rItemNameArr[i]);
        if tp <> nil then
        begin
            hcount := tp.rCount;
        end;
        str := format('%s:%d个', [p.rItemNameArr[i], p.rItemCountArr[i]]);
        list_Material.AddItem(str);
        if hcount <> 0 then
        begin
            str := format(' (背包:%d个)', [hcount]);
            list_Material.AddItem(str);
        end;
    end;

end;

procedure TfrmSkill.A2CheckBox_sex_nanClick(Sender: TObject);
begin
    A2CheckBox_sex_nan.Checked := TRUE;
    A2CheckBox_sex_nv.Checked := not A2CheckBox_sex_nan.Checked;
end;

procedure TfrmSkill.A2CheckBox_sex_nvClick(Sender: TObject);
begin
    A2CheckBox_sex_nan.Checked := FALSE;
    A2CheckBox_sex_nv.Checked := not A2CheckBox_sex_nan.Checked;
end;

procedure TfrmSkill.Lb_Create_AtzMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.settext(integer(Sender), jobTools);
end;

procedure TfrmSkill.A2Button_createMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TfrmSkill.onHaveitemUPdate(akey: integer; aitem: titemdata);
begin
    if Visible then list_blueprintClick(nil);
end;

procedure tfrmskill.create;
 var
    p: pTMaterialData;
    i: integer;
    str : string;
begin
    inc(icount);
    list_blueprintClick(nil);
    i := list_blueprint.ItemIndex;
    p := Materialclass.getIndex(i);
    if p = nil then exit;
    // send_Job_create(p.rName);
    jobcreateTick := 0;
    jobcreateState := 1;
     A2Edit_inPower.Text:=IntToStr(xcount-icount);
  if icount<xcount then
  begin
  //  FrmBottom.AddChat('已经生产：'+inttostr(icount)+'次', WinRGB(22, 22, 0), 0) ;
    end
 else
 begin
 A2Button_create.Visible:=True;
 A2Button1.Visible:=False;
// FrmBottom.AddChat('批量生产完毕', WinRGB(22, 22, 22), 0);
 end;
end;
procedure TfrmSkill.Timer2Timer(Sender: TObject);
begin
   Create ;
    if icount=xcount then
    begin
    xcount:=0;
    icount:=0;
    timer2.enabled:=False;
    A2Button_create.Visible := true;
    A2Button1.Visible:=False;
    end;
end;
procedure TfrmSkill.A2Button1Click(Sender: TObject);
begin
if Timer2.Enabled then
begin
 Timer2.Enabled:=False;
 A2Button1.Visible:=False;
 A2Button_create.Visible:=True;
  FrmBottom.AddChat('取消生产完毕', WinRGB(22, 22, 22), 0);
 end;

end;

procedure TfrmSkill.A2Edit_inPowerChange(Sender: TObject);
begin
//    if A2Edit_inPower.Text = '' then A2Edit_inPower.Text := '1';
    if _StrToInt(trim(A2Edit_inPower.Text)) < 1 then A2Edit_inPower.Text := '0';
      if _StrToInt(trim(A2Edit_inPower.Text)) >999 then A2Edit_inPower.Text := '999';

end;

procedure TfrmSkill.A2Edit_inPowerKeyPress(Sender: TObject; var Key: Char);
begin
    if not (key in ['0'..'9', #8]) then
        key := #0;
end;

procedure TfrmSkill.A2Button2Click(Sender: TObject);
begin
    if StrToInt(A2Edit_inPower.Text) <= 100 then
        A2Edit_inPower.Text := IntToStr(StrToInt(A2Edit_inPower.Text) + 1);
            xcount:=0;
    icount:=0;
end;

procedure TfrmSkill.A2Button3Click(Sender: TObject);
begin
    if StrToInt(A2Edit_inPower.Text) > 0 then
        A2Edit_inPower.Text := IntToStr(StrToInt(A2Edit_inPower.Text) - 1);
            xcount:=0;
    icount:=0;
end;

end.

