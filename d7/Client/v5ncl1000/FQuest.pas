unit FQuest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, Deftype, AUtil32, BaseUIForm;

type
  TQuestdatalist = record
    qid: integer;
    mainTitle: string[255];
    mainText: string[255];
    subTitle: string[255];
    subText: string[255];
    subRequest: string[255];
    Request: string[255];
    ShowCount: integer;
  end;
  pTQuestdatalist = ^TQuestdatalist;
  TfrmQuest = class(TfrmBaseUI)
    A2Form: TA2Form;
    A2ILabelRequest: TA2ILabel;
    A2ListBoxList: TA2ListBox;
    A2ListBoxText: TA2ListBox;
    A2Button1: TA2Button;
    A2Button6: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure A2Button6Click(Sender: TObject);
    procedure A2ListBoxListClick(Sender: TObject);
    procedure A2Button1Click(Sender: TObject);
    procedure h(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

        { Private declarations }
  public
        { Public declarations }
    QuesttempArr: array[0..19] of integer; //新 任务 临时变量
    fdata: tlist;
    procedure MessageProcess(var code: TWordComData);

    procedure sendDELQuest(akey: integer);

    procedure fdataClear;
    procedure fdatadel(atitle: string);
    procedure fdataadd(qid: integer; mtitle, mtext, stitle, stext, srequest, Request: string);
    function fdataget(atitl: string): pTQuestdatalist;
    function fdatagetIndex(aid: integer): pTQuestdatalist;


    //procedure SetOldVersion;
    procedure onQuestItemUPdate(var aitem: titemdata);
    procedure SetNewVersion(); override;


    //procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
  end;

var
  frmQuest: TfrmQuest;

implementation

uses Fbl, FMain, filepgkclass, uPersonBat, FAttrib,
  FLittleMap;

{$R *.dfm}

procedure TfrmQuest.fdataClear;
var
  i: integer;
  p: pTQuestdatalist;
begin
  for i := 0 to fdata.Count - 1 do
  begin

    p := fdata.Items[i];
    Dispose(p);
  end;
  fdata.Clear;
  A2ListBoxList.Clear;
end;

procedure TfrmQuest.fdatadel(atitle: string);
var
  i: integer;
  p: pTQuestdatalist;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.mainTitle = atitle then
    begin
      fdata.Delete(i);
      A2ListBoxList.DeleteItem(i);
      Dispose(p);
      exit;
    end;
  end;

end;

function SplitString(const source, ch: string): string;
var
  temp, t2: string;
  i: integer;
 // result1:TStringList;
begin
 // result1 := TStringList.Create;
  temp := source;
  i := pos(ch, source);
  while i <> 0 do
  begin
    t2 := copy(temp, 0, i - 1);
    if (t2 <> '') then
      FrmM.questlist.Add(t2);
    delete(temp, 1, i - 1 + Length(ch));
    i := pos(ch, temp);
  end;
  FrmM.questlist.Add(temp);
  result := FrmM.questlist.Text;
end;

procedure TfrmQuest.fdataadd(qid: integer; mtitle, mtext, stitle, stext, srequest, Request: string);
var
  p: pTQuestdatalist;
begin

  fdatadel(mtitle);
  new(p);
  p.qid := qid;
  p.mainTitle := mtitle;
  p.mainText := mtext;
  p.subTitle := stitle;
  p.subText := stext;
  p.subRequest := srequest;
  p.Request := Request;
  p.ShowCount := 0;
  fdata.Add(p);
  A2ListBoxList.AddItem(p.mainTitle);

  //  FrmM.questlist.clear;
  if mtitle = '主线' then
  begin
    FrmM.list1 := mtitle + '，' + mtext + '，' + stitle + '，' + stext + '，' + srequest + '，' + Request + '，';
    // FrmM.list2:='';
  end;
  if mtitle = '随机任务' then
  begin
   // FrmM.list1:='';
    FrmM.list2 := mtitle + '，' + mtext + '，' + stitle + '，' + stext + '，' + srequest + '，' + Request + '，';
  end;
  FrmM.DrawquestList;
  {
 SplitString(FrmM.list1,'，');
    SplitString(FrmM.list2,'，');

 //  if mtitle='主线' then FrmM.list1:= FrmM.questlist.text else  FrmM.list1:='';
 //  if mtitle='随机任务' then FrmM.list2:= FrmM.questlist.text else FrmM.list2:='';

 //  FrmM.questlist.Clear;
//   FrmM.questlist.Add(FrmM.list1);
//   FrmM.questlist.Add(FrmM.list2);
    FrmM.DrawquestList ;  }
end;

function TfrmQuest.fdatagetIndex(aid: integer): pTQuestdatalist;
var
  p: pTQuestdatalist;
begin
  result := nil;
  if (aid < 0) or (aid >= fdata.Count) then exit;
  result := fdata.Items[aid];
end;

function TfrmQuest.fdataget(atitl: string): pTQuestdatalist;
var
  i: integer;
  p: pTQuestdatalist;
begin
  result := nil;
  for i := 0 to fdata.Count - 1 do
  begin

    p := fdata.Items[i];
    if p.mainTitle = atitl then
    begin
      result := p;
      exit;
    end;
  end;

end;

procedure TfrmQuest.sendDELQuest(akey: integer);
var
  tempsend: TWordComData;
begin
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, CM_Quest);
  WordComData_ADDbyte(tempsend, Quest_del);
  WordComData_ADDdword(tempsend, akey);
  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TfrmQuest.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  n, i, id, akey, qid: integer;
  mtitle, mtext, stitle, stext, srequest, Request: string;
begin
  pckey := @Code.Data;
  case pckey^.rmsg of
    SM_Quest:
      begin
        id := 1;
        n := WordComData_GETbyte(code, id);
        case n of
          Quest_GETlist:
            begin
              akey := WordComData_GETbyte(code, id);
              fdataClear;
              for i := 0 to akey - 1 do
              begin
                qid := WordComData_GETdword(code, id);
                mtitle := WordComData_GETstring(code, id);
                mtext := WordComData_GETstring(code, id);
                stitle := WordComData_GETstring(code, id);
                stext := WordComData_GETstring(code, id);
                srequest := WordComData_GETstring(code, id);
                Request := WordComData_GETstring(code, id);
                fdataadd(qid, mtitle, mtext, stitle, stext, srequest, Request);
              end;
              A2ListBoxListClick(nil);
            end;
          Quest_listDEL:
            begin

            end;
          Quest_listadd:
            begin

            end;
          QuestTempArrUPdate:
            begin
              akey := WordComData_GETbyte(code, id);
              qid := WordComData_GETdword(code, id);
              QuesttempArr[akey] := qid;
              A2ListBoxListClick(nil);
            end;
          QuestTempArrList:
            begin
              akey := WordComData_GETbyte(code, id);
              for i := 0 to akey - 1 do
              begin
                qid := WordComData_GETdword(code, id);
                QuesttempArr[i] := qid;
              end;
              A2ListBoxListClick(nil);
            end;
        end;

      end;
  end;
end;

procedure TfrmQuest.SetNewVersion;
begin
  inherited;

end;

//procedure TfrmQuest.SetOldVersion;
//begin
//  pgkBmp.getBmp('Quest.bmp', A2form.FImageSurface);
//  A2form.boImagesurface := true;
//end;

procedure TfrmQuest.FormCreate(Sender: TObject);
begin
  inherited;
 
  fdata := tlist.Create;
  fillchar(QuesttempArr, sizeof(QuesttempArr), 0);
  FrmM.AddA2Form(Self, A2form);
  A2ILabelRequest.Transparent := true;
  if WinVerType = wvtNew then
  begin
    SetNewVersion;
//  end
//  else if WinVerType = wvtOld then
//  begin
//    SetOldVersion;
  end;

    //Parent := FrmM;
  Left := 0;
  Top := 0;
  A2ListBoxList.FontColor := WinRGB(22, 22, 0);
  A2ListBoxList.FontSelColor := WinRGB(22, 22, 0);
  A2ListBoxList.FFontSelBACKColor := ColorSysToDxColor(clred);
  A2ListBoxText.FontColor := WinRGB(22, 22, 0);
  A2ListBoxText.FontSelColor := WinRGB(22, 22, 0);
  A2ILabelRequest.Font.Color := ColorDxColorToSys(WinRGB(22, 22, 0));
end;

procedure TfrmQuest.A2Button6Click(Sender: TObject);
begin
  Visible := false;
end;



procedure TfrmQuest.A2ListBoxListClick(Sender: TObject);
var
  p: pTQuestdatalist;
  s: string;
  rs: string;
  i: Integer;
  procedure Request(str: string);
  var
    s1, s2: string;
    i: integer;
    temp, tempsub: TStringlist;
    p: ptitemdata;
  begin
    temp := TStringlist.Create;
    try
      ExtractStrings(['(', ')'], [#13, #10], pchar(str), temp);
      if temp.Count > 0 then A2ListBoxText.AddItem(format('【%s】', ['完成状态']));
      for i := 0 to temp.Count - 1 do
      begin
        str := temp.Strings[i];
        tempsub := TStringlist.Create;
        try
          ExtractStrings(['|'], [#13, #10], pchar(str), tempsub);
                    //1,任务背包无物品替换文字,2物品真实名字()
          if tempsub.Count >= 2 then
          begin
            s1 := tempsub.Strings[0];
            p := HaveItemQuestClass.getname(tempsub.Strings[1]);
            if p <> nil then
            begin
              s1 := format('%s:%d/%d', [p.rViewName, p.rCount, p.rMaxCount]);
            end;
            A2ListBoxText.AddItem(s1);
          end;
        finally
          tempsub.Free;
        end;
      end;
     {       for i := 0 to temp.Count - 1 do
            begin
                str := temp.Strings[i];
                tempsub := TStringlist.Create;
                try                                                             //(完成状态:1:/:2:牛)
                    ExtractStrings([':'], [#13, #10], pchar(str), tempsub);
                    if tempsub.Count >= 5 then
                    begin
                        s1 := format('%s:%d%s%d%s', [
                            tempsub.Strings[0]
                                , QuesttempArr[_StrToInt(tempsub.Strings[1])]
                                , tempsub.Strings[2]
                                , QuesttempArr[_StrToInt(tempsub.Strings[3])]
                                , tempsub.Strings[4]
                                ]);

                        A2ListBoxText.AddItem(s1);
                        //  PersonBat.LeftMsgListadd2(format('%s(%s)', [p.mainTitle, s1]), WinRGB(22, 22, 0));
                    end;
                finally
                    tempsub.Free;
                end;
            end;}
    finally
      temp.Free;
    end;

  end;

begin
  rs := '';
  A2ListBoxText.Clear;
  A2ILabelRequest.Caption := '';
  p := fdatagetIndex(A2ListBoxList.ItemIndex);
  if p = nil then Exit;
   { begin
      FrmLittleMap.A2ILabelRequest1.Visible:=False;
      FrmLittleMap.A2ILabelRequest2.Visible:=False;
    FrmLittleMap.ClientHeight:=170;
     exit;
     end;           }
  rs := rs + (formatStr(p.mainText, A2ListBoxText.Width));

    // stradd(' ');
  if p.subTitle <> '' then
    rs := rs + (formatStr(format('【%s】', [p.subTitle]), A2ListBoxText.Width));
    //  stradd(' ');
  if p.subText <> '' then
    rs := rs + (formatStr(p.subText, A2ListBoxText.Width));
  A2ListBoxText.StringList.Text := rs;
  if p.Request <> '' then
    Request(p.Request);
  A2ILabelRequest.Caption := p.subRequest;
  A2ListBoxText.DrawItem;

  FrmM.questlist.Clear;
  for i := 0 to A2ListBoxList.Count - 1 do
  begin
    p := fdatagetIndex(i);
    if p = nil then exit;
//    if p.mainTitle = '主线' then SplitString(FrmM.list1, '，');
//    if p.mainTitle = '随机任务' then SplitString(FrmM.list2, '，');
   // FrmM.DrawquestList ;
  end;
     //////////////////////////////////   下面内容是新加的任务提示
 {   rs:='';
     s:='';
    for i:=0 to  A2ListBoxList.Count-1 do
    begin
    p := fdatagetIndex(i);
    if p = nil then exit;
    if p.mainTitle='随机任务' then     s:='随机任务：'+  p.subText
    else    rs:='主线：'+ p.subRequest   ;
    FrmLittleMap.A2ILabelRequest1.Caption:=rs  ;
    FrmLittleMap.A2ILabelRequest2.Caption:=s   ;
    end;
    if (rs='')  then
    begin
    if  FrmLittleMap.A2ILabelRequest1.Visible then
    begin
     FrmLittleMap.A2ILabelRequest1.Visible:=False;
     FrmLittleMap.clientHeight:=FrmLittleMap.clientHeight-30;
     end;
     end else
     begin
      if FrmLittleMap.A2ILabelRequest1.Visible= false then
       begin
     FrmLittleMap.A2ILabelRequest1.Visible:=True;
     FrmLittleMap.clientHeight:=FrmLittleMap.clientHeight+30 ;
     end;
     end;
    if (s='')  then
    begin
    if  FrmLittleMap.A2ILabelRequest2.Visible then
    begin
     FrmLittleMap.A2ILabelRequest2.Visible:=False;
     FrmLittleMap.clientHeight:=FrmLittleMap.clientHeight-30;
     end;
     end else
     begin
      if FrmLittleMap.A2ILabelRequest2.Visible= false then
       begin
     FrmLittleMap.A2ILabelRequest2.Visible:=True;
     FrmLittleMap.clientHeight:=FrmLittleMap.clientHeight+30 ;
     end;
     end;    }
/////////////////////////////////////////////////////////////////

end;

procedure TfrmQuest.onQuestItemUPdate(var aitem: titemdata);
var
  p: pTQuestdatalist;
  i: integer;
  function _Request(str: string): boolean;
  var
    s1, s2: string;
    i: integer;
    temp, tempsub: TStringlist;
    p: ptitemdata;
    bostate: boolean;
  begin
    result := false;
    temp := TStringlist.Create;
    tempsub := TStringlist.Create;
    try
      ExtractStrings(['(', ')'], [#13, #10], pchar(str), temp);
      if temp.Count <= 0 then exit;
      bostate := false;
      for i := 0 to temp.Count - 1 do
      begin
        str := temp.Strings[i];
        tempsub.Clear;
        ExtractStrings(['|'], [#13, #10], pchar(str), tempsub); //1,任务背包无物品替换文字,2物品真实名字()
        if tempsub.Count >= 2 then
        begin
          s1 := tempsub.Strings[1];
          if aitem.rName = s1 then
          begin
            bostate := true;
            Break;
          end;
        end;
      end;
      if bostate = false then exit;

      for i := 0 to temp.Count - 1 do
      begin
        str := temp.Strings[i];
        tempsub.Clear;
        ExtractStrings(['|'], [#13, #10], pchar(str), tempsub); //1,任务背包无物品替换文字,2物品真实名字()
        if tempsub.Count >= 2 then
        begin
          s1 := tempsub.Strings[0];
          p := HaveItemQuestClass.getname(tempsub.Strings[1]);
          if p = nil then exit;
          if p.rCount < p.rMaxCount then Exit;
        end;
      end;
      result := true;
    finally
      temp.Free;
      tempsub.Free;
    end;

  end;
begin
  if aitem.rName = '' then exit;
  A2ListBoxListClick(nil);
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.ShowCount >= 1 then Continue;
    if _Request(p.Request) then
    begin
      p.ShowCount := p.ShowCount + 1;
//      frmMsgBoxTemp.ShowBox(p.mainTitle,
//        '【' + p.subTitle + '】^              〖任务完成〗^'
////                + p.subText + '^'
//        + ' ^【任务提示】^              ' + p.subRequest + '^'
//        );
    end;
  end;


end;

procedure TfrmQuest.A2Button1Click(Sender: TObject);
var
  p: pTQuestdatalist;
begin
    {    p := fdatagetIndex(A2ListBoxList.ItemIndex);
        if p = nil then exit;
        sendDELQuest(p.qid);
        fdatadel(p.mainTitle);
        A2ListBoxListClick(nil);}
end;

procedure TfrmQuest.h(Sender: TObject);
begin
  fdataClear;
  fdata.Free;
end;

procedure TfrmQuest.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmQuest.SetConfigFileName;
begin
  FConfigFileName := 'Quest.xml';

end;

//procedure TfrmQuest.SetNewVersionOld;
//var
//  temping, tempUp, tempDown: TA2Image;
//begin
//  tempUp := TA2Image.Create(32, 32, 0, 0);
//  tempDown := TA2Image.Create(32, 32, 0, 0);
//  temping := TA2Image.Create(32, 32, 0, 0);
//  try
//    pgkBmp.getBmp('任务信息窗口.bmp', A2Form.FImageSurface);
//    A2Form.boImagesurface := True;
//
//        //新布局位置
//    A2ListBoxList.Left := 22;
//    A2ListBoxList.Top := 74;
//    A2ListBoxList.Width := 100;
//    A2ListBoxList.Height := 151;
//
//    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
//    A2ListBoxList.SetScrollTopImage(tempUp, tempDown);
//    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
//    A2ListBoxList.SetScrollTrackImage(tempUp, tempDown);
//    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
//    A2ListBoxList.SetScrollBottomImage(tempUp, tempDown);
//    pgkBmp.getBmp('任务信息_下拉条底框A.bmp', temping);
//    A2ListBoxList.SetScrollBackImage(temping);
//
//    A2ListBoxText.Left := 138;
//    A2ListBoxText.Top := 74;
//    A2ListBoxText.Width := 260;
//    A2ListBoxText.Height := 151;
//
//    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
//    A2ListBoxText.SetScrollTopImage(tempUp, tempDown);
//    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
//    A2ListBoxText.SetScrollTrackImage(tempUp, tempDown);
//    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
//    A2ListBoxText.SetScrollBottomImage(tempUp, tempDown);
//    pgkBmp.getBmp('任务信息_下拉条底框B.bmp', temping);
//    A2ListBoxText.SetScrollBackImage(temping);
//
//    A2ILabelRequest.Left := 24;
//    A2ILabelRequest.Top := 253;
//    A2ILabelRequest.Width := 376;
//    A2ILabelRequest.Height := 50;
//
//    A2Button6.Left := 380;
//    A2Button6.Top := 17;
//    a2button6.Width := 32;
//    A2Button6.Height := 32;
//
//    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
//    A2Button6.A2Up := temping;
//    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
//    A2Button6.A2Down := temping;
//    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
//    A2Button6.A2Mouse := temping;
//    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
//    A2Button6.A2NotEnabled := temping;
//
//  finally
//    temping.Free;
//    tempUp.Free;
//    tempDown.Free;
//  end;
//end;

procedure TfrmQuest.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := True;
  SetControlPos(A2ListBoxList);
   SetControlPos(A2ListBoxText);
   SetControlPos(A2ILabelRequest);
 
   SetControlPos(A2Button6);
   SetControlPos(A2Button6);

 
end;

procedure TfrmQuest.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

end.

