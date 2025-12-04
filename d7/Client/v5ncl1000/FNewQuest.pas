unit FNewQuest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseUIForm, ExtCtrls, A2Form, NativeXml, deftype, StdCtrls, A2Img, uKeyClass, uAnsTick, AUtil32, Charcls, Atzcls;

type
  TcQuestListClass = class
  private
    DataList: TList;
    NameIndex: TStringKeyClass;
    procedure add(var aQuest: TNewQuestdata);
    procedure clear;
  public
    constructor Create;
    destructor Destroy; override;
    function get(aname: string): pTNewQuestdata;
    function Delete(Aname: string): Boolean;
    function getCount: Integer;
    function getDataByIndex(AIndex: Integer): pTNewQuestdata;
    function AddQuestData(aQuestId: Integer; agid: Byte; AQuestTitle: string; AQuestDes: string; AComplete: Boolean; aFollow: Boolean): Boolean;
  end;
  TfrmNewQuest = class(TfrmBaseUI)
    A2Form: TA2Form;
    QuestListA2List: TA2ListBox;
    QuestInfoA2List: TA2ListBox;
    btnClose: TA2Button;
    QuestPageBackA2ILabel: TA2ILabel;
    QuestPage1A2ILabel: TA2ILabel;
    QuestPage2A2ILabel: TA2ILabel;
    QuestPage3A2ILabel: TA2ILabel;
    QuestFollow_A2Button: TA2Button;
    QuestComplete_A2Button: TA2Button;
    Item1A2ILabel: TA2ILabel;
    Item2A2ILabel: TA2ILabel;
    Item3A2ILabel: TA2ILabel;
    Item4A2ILabel: TA2ILabel;
    Item5A2ILabel: TA2ILabel;
    Item6A2ILabel: TA2ILabel;
    MainTitleA2Label: TA2Label;
    SubTitleA2Label: TA2Label;
    QuestItemA2ILabel: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QuestPage1A2ILabelClick(Sender: TObject);
    procedure QuestPage2A2ILabelClick(Sender: TObject);
    procedure QuestPage3A2ILabelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure QuestListA2ListClick(Sender: TObject);
    procedure Item1A2ILabelMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Item1A2ILabelMouseLeave(Sender: TObject);
    procedure QuestComplete_A2ButtonClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    QuestPage1_img: TA2Image;
    QuestPage2_img: TA2Image;
    QuestPage3_img: TA2Image;
    ItemBack: TA2Image;
    FCurQuestPage: Byte;
    FStick: Integer;
    FItemArray: array[1..6] of TA2ILabel;
    FItemList: TStringList;
    FQuestId: Integer;
    FKeyDownPage: Byte;
  public
    procedure MessageProcess(var code: TWordComData);
    procedure SetNewVersion(); override;
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure UpdateQuestList;
    procedure SendCmdGetQuestList();
    procedure DrawFollow(p: pTNewQuestdata);
    procedure ShowQuestData(P: pTNewQuestdata);
    procedure SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape, shapeRdown, shapeLUP: word);
    procedure ShowKeyDownPageDefaultData();
    procedure Move(Sender: TObject; x, y: integer);
    procedure ClearUi; 
  end;

var
  frmNewQuest: TfrmNewQuest;
  G_TcQuestListClass1: TcQuestListClass;
  G_TcQuestListClass2: TcQuestListClass;
  G_TcQuestListClass3: TcQuestListClass;
implementation

uses FMain, fbl, FBottom, FAttrib, FMiniMap;

{$R *.dfm}

function GetLeftStr(CellStr, FlagStr: string): string;
var
  FlagPos: integer;
begin
  FlagPos := Pos(FlagStr, CellStr);
  Result := Copy(CellStr, 1, FlagPos - 1);

end;

function GetRightStr(CellStr, FlagStr: string): string;
var
  FlagPos: integer;
begin
  FlagPos := Pos(FlagStr, CellStr);
  Result := Copy(CellStr, FlagPos + Length(FlagStr), Length(CellStr));

end;

function GetMidStr(sSource, sStr1,
  sStr2: string): string;
var
  nPos1, nPos2, i: integer;
begin
  i := 0;
  nPos1 := Pos(sStr1, sSource);
  nPos2 := Pos(sStr2, sSource);
  Result := Copy(sSource, nPos1 + Length(sStr1), nPos2 - nPos1 - Length(sStr1));
  repeat
    i := Pos(sStr1, Result);
    Result := GetRightStr(Result, sStr1);
  until i = 0;
end;



{ TfrmNewQuest }

procedure TfrmNewQuest.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  n, i, id, akey, qid, gid: integer;
  mtitle, mtext, stitle, sdec, srequest, Request: string;
  bcomplete, bfollow: Boolean;
  pqdata: pTNewQuestdata;
  pqinfo: PTSQuestInfo;
  psHaveItem: PTSHaveItem;
  aitem: TItemData;
begin
 
  pckey := @Code.Data;
  case pckey^.rmsg of
    SM_NewQuest:
      begin
        id := 1;
        n := WordComData_GETbyte(code, id);
        case n of
          Quest_listadd:
            begin
              self.QuestListA2List.ScrollBarView:=True;
               self.QuestInfoA2List.ScrollBarView:=True;
              pqinfo := @Code.data;
              qid := pqinfo^.rqid;
              gid := pqinfo^.rgid;
              stitle := pqinfo^.rTitle;
              sdec := GetWordString(pqinfo^.rDec);
              bcomplete := pqinfo^.rbComplete;
              bfollow := pqinfo^.rbFollow;
              case gid of
                0: begin
                    G_TcQuestListClass1.AddQuestData(qid, gid, stitle, sdec, bcomplete, bfollow);
                  end;
                1: begin
                    G_TcQuestListClass2.AddQuestData(qid, gid, stitle, sdec, bcomplete, bfollow);
                  end;
                2: begin
                    G_TcQuestListClass3.AddQuestData(qid, gid, stitle, sdec, bcomplete, bfollow);
                  end;

              end;
              UpdateQuestList;
            end;
          Quest_ListUpdate:
            begin
              pqinfo := @Code.data;
              qid := pqinfo^.rqid;
              gid := pqinfo^.rgid;
              stitle := pqinfo^.rTitle;
              sdec := GetWordString(pqinfo^.rDec);
              bcomplete := pqinfo^.rbComplete;
              bfollow := pqinfo^.rbFollow;
              case gid of
                0: begin
                    pqdata := G_TcQuestListClass1.get(IntToStr(qid));  
                    if pqdata = nil then exit;
                    pqdata^.rQuestTitle := stitle;
                    pqdata^.rQuestDes := sdec;
                    pqdata^.rComplete := bcomplete;
                    pqdata^.rFollow := bfollow;
                  end;
                1: begin
                    pqdata := G_TcQuestListClass2.get(IntToStr(qid));  
                    if pqdata = nil then exit;
                    pqdata^.rQuestTitle := stitle;
                    pqdata^.rQuestDes := sdec;
                    pqdata^.rComplete := bcomplete;
                    pqdata^.rFollow := bfollow;
                  end;
                2: begin
                    pqdata := G_TcQuestListClass3.get(IntToStr(qid));
                    if pqdata = nil then exit;
                    pqdata^.rQuestTitle := stitle;
                    pqdata^.rQuestDes := sdec;
                    pqdata^.rComplete := bcomplete;
                    pqdata^.rFollow := bfollow;
                  end;

              end;
              UpdateQuestList;
            end;
          Quest_listDEL: begin
              pqinfo := @Code.data;
              qid := pqinfo^.rqid;
              gid := pqinfo^.rgid;

              case gid of
                0: begin
                    pqdata := G_TcQuestListClass1.get(IntToStr(qid));
                    if pqdata = nil then exit;
                    G_TcQuestListClass1.Delete(IntToStr(qid));
                    ClearUi;
                  end;
                1: begin           
                    pqdata := G_TcQuestListClass2.get(IntToStr(qid));
                    if pqdata = nil then exit;
                    G_TcQuestListClass2.Delete(IntToStr(qid));
                    ClearUi;
                  end;
                2: begin         
                    pqdata := G_TcQuestListClass3.get(IntToStr(qid));
                    if pqdata = nil then exit;
                    G_TcQuestListClass3.Delete(IntToStr(qid));
                    ClearUi;
                  end;

              end;
              UpdateQuestList;
            end;
        end;
      end;
    SM_ITEMDATA:
      begin
        psHaveItem := @Code.Data;
        with pshaveitem^ do
        begin
          if rdel then
          begin
            HaveItemclass.del(rkey);
          end else
          begin
            i := sizeof(tsHaveItem);
            TWordComDataToTItemData(i, code, aitem);

            G_BufferItemDataClass.add(aitem);
            i := self.FItemList.IndexOf(aitem.rName);
            if i <> -1 then
            begin

              Self.SetItemLabel(Self.FItemArray[i + 1], aitem.rViewName, aitem.rcolor, aitem.rShape, 0, 0);
            end;
          end;
        end;
      end;
  end;
end;

procedure TfrmNewQuest.SetConfigFileName;
begin
  inherited;
  Self.FConfigFileName := 'NewQuest.xml';
end;

procedure TfrmNewQuest.SetNewVersion;
begin
  inherited;

end;

procedure TfrmNewQuest.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  SetControlPos(QuestListA2List);
  SetControlPos(QuestInfoA2List);
  SetControlPos(btnClose);
  SetA2ImgPos(QuestPage1_img);
  SetA2ImgPos(QuestPage2_img);
  SetA2ImgPos(QuestPage3_img);
  SetA2ImgPos(ItemBack);
  SetControlPos(self.QuestPageBackA2ILabel);
  SetControlPos(self.QuestPage1A2ILabel);
  SetControlPos(self.QuestPage2A2ILabel);
  SetControlPos(self.QuestPage3A2ILabel);
  SetControlPos(Item1A2ILabel);
  SetControlPos(Item2A2ILabel);
  SetControlPos(Item3A2ILabel);
  SetControlPos(Item4A2ILabel);
  SetControlPos(Item5A2ILabel);
  SetControlPos(Item6A2ILabel);
  SetControlPos(self.QuestFollow_A2Button);
  SetControlPos(self.QuestComplete_A2Button);
  Item1A2ILabel.A2Image := ItemBack;
  Item2A2ILabel.A2Image := ItemBack;
  Item3A2ILabel.A2Image := ItemBack;
  Item4A2ILabel.A2Image := ItemBack;
  Item5A2ILabel.A2Image := ItemBack;
  Item6A2ILabel.A2Image := ItemBack;
  SetControlPos(QuestItemA2ILabel);
  SetControlPos(MainTitleA2Label);
  SetControlPos(SubTitleA2Label);
end;

procedure TfrmNewQuest.settransparent(transparent: Boolean);
begin

  Self.A2Form.TransParent := transparent;
end;

procedure TfrmNewQuest.FormCreate(Sender: TObject);
var
  I: Integer;
 
begin
  inherited;
  //QuestInfoA2List.UiImgPath:='.\ui\img\';
  FKeyDownPage := 255;
  FQuestId := -1;
  self.FTestPos := True;
  FrmM.AddA2Form(Self, A2form);
  Left := 0;
  Top := 0;
  QuestPage1_img := TA2Image.Create(32, 32, 0, 0);
  QuestPage1_img.Name := 'QuestPage1_img';
  QuestPage2_img := TA2Image.Create(32, 32, 0, 0);
  QuestPage2_img.Name := 'QuestPage2_img';
  QuestPage3_img := TA2Image.Create(32, 32, 0, 0);
  QuestPage3_img.Name := 'QuestPage3_img';
  ItemBack := TA2Image.Create(32, 32, 0, 0);
  ItemBack.Name := 'ItemBack';
  SetnewVersion;
  FCurQuestPage := 255;
  FStick := 0;
  self.QuestListA2List.FontColor := 32767;
  self.QuestListA2List.FontSelColor := 32767;
  self.QuestListA2List.FontMovColor := 32767;
  self.QuestInfoA2List.FontColor := 32767;
  self.QuestInfoA2List.FontSelColor := 32767;
  self.QuestInfoA2List.FontMovColor := 32767;
  FItemArray[1] := Item1A2ILabel;
  FItemArray[2] := Item2A2ILabel;
  FItemArray[3] := Item3A2ILabel;
  FItemArray[4] := Item4A2ILabel;
  FItemArray[5] := Item5A2ILabel;
  FItemArray[6] := Item6A2ILabel;
  FItemList := TStringList.Create;
  for i := Low(FItemArray) to High(FItemArray) do
  begin
    FItemArray[i].Visible := False;
  end;
 QuestInfoA2List.OnMarkKeyDown:= Move;
end;

procedure TfrmNewQuest.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmNewQuest.QuestPage1A2ILabelClick(Sender: TObject);
begin
  inherited;
  if FStick + 50 > mmAnsTick then
  begin
    FrmBottom.AddChat('请勿频繁切换任务列表', WinRGB(22, 22, 0), 0);
    Exit;
  end;
  FStick := mmAnsTick;
  self.QuestPageBackA2ILabel.A2Image := QuestPage1_img;
  FCurQuestPage := 0;
  QuestComplete_A2Button.Visible := False;
  FQuestId := -1;
  FKeyDownPage := 0;
  SendCmdGetQuestList();
 // UpdateQuestList;
end;

procedure TfrmNewQuest.QuestPage2A2ILabelClick(Sender: TObject);
begin
  inherited;
  if FStick + 50 > mmAnsTick then
  begin
    FrmBottom.AddChat('请勿频繁切换任务列表', WinRGB(22, 22, 0), 0);
    Exit;
  end;
  FStick := mmAnsTick;
  self.QuestPageBackA2ILabel.A2Image := QuestPage2_img;
  FCurQuestPage := 1;
  QuestComplete_A2Button.Visible := False;
  FQuestId := -1;
  FKeyDownPage := 1;
  SendCmdGetQuestList();
 // UpdateQuestList;
end;

procedure TfrmNewQuest.QuestPage3A2ILabelClick(Sender: TObject);
begin
  inherited;
  if FStick + 50 > mmAnsTick then
  begin
    FrmBottom.AddChat('请勿频繁切换任务列表', WinRGB(22, 22, 0), 0);
    Exit;
  end;
  FStick := mmAnsTick;
  self.QuestPageBackA2ILabel.A2Image := QuestPage3_img;
  FCurQuestPage := 2;
  QuestComplete_A2Button.Visible := False;
  FQuestId := -1;
  FKeyDownPage := 2;
  SendCmdGetQuestList();
 // UpdateQuestList;
end;

procedure TfrmNewQuest.UpdateQuestList;
var
  i: Integer;
  p: pTNewQuestdata;
begin
  case FCurQuestPage of
    0: begin
        self.QuestListA2List.Clear;
        for I := 0 to G_TcQuestListClass1.getCount - 1 do
        begin
          p := G_TcQuestListClass1.getDataByIndex(i);
          QuestListA2List.AddItem(p.rQuestTitle);
          DrawFollow(p);

        end;

      end;
    1: begin
        self.QuestListA2List.Clear;
        for I := 0 to G_TcQuestListClass2.getCount - 1 do
        begin
          p := G_TcQuestListClass2.getDataByIndex(i);
          QuestListA2List.AddItem(p.rQuestTitle);
          DrawFollow(p);

        end;
      end;
    2: begin
        self.QuestListA2List.Clear;
        for I := 0 to G_TcQuestListClass3.getCount - 1 do
        begin
          p := G_TcQuestListClass3.getDataByIndex(i);
          QuestListA2List.AddItem(p.rQuestTitle);
          DrawFollow(p);

        end;
      end;
  end;
  QuestListA2List.Loaded;
  QuestListA2List.ItemIndex := 0;
  for i := Low(FItemArray) to High(FItemArray) do
  begin
    FItemArray[i].Visible := False;
  end;
  QuestInfoA2List.Clear;
  ShowKeyDownPageDefaultData;
end;

procedure TfrmNewQuest.SendCmdGetQuestList;

var
  PQuestGet: TCQuestGet;
  cnt: Integer;
begin
  ClearUi;
  PQuestGet.rmsg := CM_GETQUESTLIST;
  PQuestGet.rkey := NewQuest_CM_GETLIST;
  PQuestGet.rqid := 0;
  PQuestGet.rgid := FCurQuestPage;

  cnt := SizeOf(TCQuestGet);
  Frmfbl.SocketAddData(cnt, @PQuestGet);
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

procedure TfrmNewQuest.DrawFollow(p: pTNewQuestdata);
begin
//  if p.rFollow then
//  begin
//    case p.rQuestGid of
//      0:
//        1:
//        2:
//    end;
//    FrmM.list1 := '主线' + '，' + p.rQuestDes + '，' + p.rQuestTitle + '，' + p.rQuestDes + '，' + '' + '，' + '' + '，';
//    SplitString(FrmM.list1, '，');
//
//    FrmM.DrawquestList;
//  end;

end;

procedure TfrmNewQuest.ShowQuestData(P: pTNewQuestdata);
var
  title: string;
  des, sitem: string;
  tmpstrlist: TStringList;
  i: Integer;
  sitemname, sitemnum, sitemcolor, sitemshape: string;
  sourceitem: PTItemdata;
  iteminfolist: TStringList;
begin
  FQuestId := p.rQuestId;
  QuestItemA2ILabel.Visible:=True;
  QuestComplete_A2Button.Visible := True;
  if p.rComplete then
    QuestComplete_A2Button.Enabled := False
  else
    QuestComplete_A2Button.Enabled := True;
  //副标题<任务描述>?<物品名称:奖励数量^物品名称:奖励数量^物品名称:奖励数量>
  MainTitleA2Label.Caption:= p^.rQuestTitle;
  SubTitleA2Label.Caption:=GetLeftStr(p^.rQuestDes,'<');
  des := GetLeftStr(p^.rQuestDes, '?');
  des := GetMidStr(des, '<', '>');
  QuestInfoA2List.ClearMarkList;
  self.QuestInfoA2List.Clear;
  try
    tmpstrlist := TStringList.Create;
    tmpstrlist.CommaText := StringReplace(des, '#13#10', #13#10, [rfReplaceAll]); ;

    for i := 0 to tmpstrlist.Count - 1 do
    begin
      QuestInfoA2List.AddItem(tmpstrlist[i]);
    end;
    QuestInfoA2List.Loaded;
    QuestInfoA2List.ItemIndex := 0;
  finally
    tmpstrlist.Free;
  end;
  FItemList.Clear;
  try
    tmpstrlist := TStringList.Create;
    sitem := GetRightStr(p^.rQuestDes, '?');
    sitem := GetMidStr(sitem, '<', '>');
    tmpstrlist.CommaText := StringReplace(sitem, '^', #13#10, [rfReplaceAll]);
    for i := Low(FItemArray) to High(FItemArray) do
    begin
      FItemArray[i].Visible := False;
    end;
    for i := 0 to tmpstrlist.Count - 1 do
    begin
      try
        iteminfolist := TStringList.Create;
        iteminfolist.CommaText := StringReplace(tmpstrlist[i], ':', #13#10, [rfReplaceAll]);
        sitemname := iteminfolist[0];
        sitemnum := iteminfolist[1];
        sitemcolor := iteminfolist[2];
        sitemshape := iteminfolist[3];
      finally
        iteminfolist.Free;
      end;


//      if sitemname <> '' then
//      begin
//        sourceitem := G_BufferItemDataClass.get(sitemname);
//        if sourceitem = nil then
//        begin
//          FrmBottom.SendGetItemData(sitemname);
//          Exit;
//        end;
      Self.SetItemLabel(Self.FItemArray[i + 1], sitemname, StrToIntDef(sitemcolor, 0), StrToIntDef(sitemshape, 0), 0, 0);



      FItemArray[i + 1].Visible := True;
      FItemArray[i + 1].Tag := i;
      FItemList.Add(tmpstrlist[i]);

    end;
  finally
    tmpstrlist.Free;
  end;


end;

procedure TfrmNewQuest.SetItemLabel(Lb: TA2ILabel; aname: string;
  acolor: byte; shape, shapeRdown, shapeLUP: word);
var
  gc, ga: integer;

  new, tmp, back: TA2Image;
begin
//  FrmConsole.cprint(lt_have, format('%s,%d', ['SetItemLabel', mmAnsTick]));
    //savekeyImagelib[idx]
  Lb.Caption := '';
  Lb.Font.Color := shapeLUP;
 // Lb.Font.Size:=2;
  GetGreenColorAndAdd(acolor, gc, ga);

  Lb.GreenCol := gc;
  Lb.GreenAdd := ga;
    // Lb.BColor := Color;
  //  Lb.A2Imageback := A2ImageitemBack;
   // Lb.A2Image := A2ImageitemBack;
  if shape = 0 then
  begin
    Lb.A2Image := nil;
    Lb.A2ImageRDown := nil;

        // lb.Visible := false;
    exit;
  end else
  begin
    lb.Visible := true;
    Lb.A2Image := AtzClass.GetItemImage(shape);


    tmp := AtzClass.GetItemImage(shape);

    if tmp <> nil then
    begin
      try
        new := TA2Image.Create(lb.Width, lb.Height, 0, 0);

        if gc = 0 then
        begin

          new.DrawImage(ItemBack, (new.Width - back.Width) div 2, (new.Height - ItemBack.Height) div 2, true);

          new.DrawImage(tmp, (Lb.Width - tmp.Width) div 2, (Lb.Height - tmp.Height) div 2, true);
        end
        else
        begin

         //         new.DrawImage(ItemBack, (new.Width - ItemBack.Width) div 2, (new.Height - ItemBack.Height) div 2, true);

         // new.DrawImage(tmp, (Lb.Width - tmp.Width) div 2, (Lb.Height - tmp.Height) div 2, true);
          new.DrawImageGreenConvert(ItemBack, (new.Width - ItemBack.Width) div 2, (new.Height - ItemBack.Height) div 2, gc, ga);
          new.DrawImageGreenConvert(tmp, (Lb.Width - tmp.Width) div 2, (Lb.Height - tmp.Height) div 2, gc, ga);
        end;
        Lb.A2Image := new;
      finally

        new.Free;
      end;
    end;

  end;



end;

procedure TfrmNewQuest.ShowKeyDownPageDefaultData;
var
  I:Integer;
    p: pTNewQuestdata;
begin
//  if FKeyDownPage=255 then Exit;

    i := QuestListA2List.ItemIndex;
  if i = -1 then Exit;
  try
  case FKeyDownPage of
    0:
      begin
        p := G_TcQuestListClass1.getDataByIndex(i);
        if p = nil then Exit;
        ShowQuestData(p);
      end;
    1: begin
        p := G_TcQuestListClass2.getDataByIndex(i);
        if p = nil then Exit;
        ShowQuestData(p);
      end;
    2: begin
        p := G_TcQuestListClass3.getDataByIndex(i);
        if p = nil then Exit;
        ShowQuestData(p);
      end;
  end;
  except
    end;
 // FKeyDownPage := 255;
end;

procedure TfrmNewQuest.Move(Sender: TObject; x, y: integer);
begin
   FrmMiniMap.AIPathcalc_paoshishasbi(x, y);
end;

procedure TfrmNewQuest.ClearUi;
var
  i:Integer;
begin
  MainTitleA2Label.Caption:='';
  SubTitleA2Label.Caption:='';
  QuestItemA2ILabel.Visible:=False;
  QuestListA2List.ClearMarkList;
  QuestListA2List.Clear;
  QuestListA2List.ScrollBarView:=False;
  QuestListA2List.DrawItem;
  for i := Low(FItemArray) to High(FItemArray) do
  begin
    FItemArray[i].Visible := False;
  end;
   QuestInfoA2List.ClearMarkList;
  QuestInfoA2List.Clear;
  QuestInfoA2List.ScrollBarView:=False;
  QuestInfoA2List.DrawItem;
  QuestComplete_A2Button.Visible:=False;
end;

{ TcQuestListClass }

procedure TcQuestListClass.add(var aQuest: TNewQuestdata);

var
  p: pTNewQuestdata;
  mark: string;
begin
  mark := IntToStr(aQuest.rQuestId);
  if get(mark) <> nil then exit;
  new(p);

  p^ := aQuest;

  DataList.Add(p);
  NameIndex.Insert(mark, p);
end;

function TcQuestListClass.AddQuestData(aQuestId: Integer; agid: Byte; AQuestTitle,
  AQuestDes: string; AComplete, aFollow: Boolean): Boolean;
var
  aquest: TNewQuestdata;
begin
  aquest.rQuestId := aQuestId;
  aquest.rQuestGid := agid;

  aquest.rQuestTitle := AQuestTitle; // copy(AQuestTitle, 1, 255); // AQuestTitle;
  aquest.rQuestDes := AQuestDes; // copy(AQuestDes, 1, 255); //AQuestDes;
  aquest.rComplete := AComplete;
  aquest.rFollow := aFollow;
  self.add(aquest);
end;

procedure TcQuestListClass.clear;
var
  i: integer;
  p: pTNewQuestdata;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;
  NameIndex.Clear;
end;

constructor TcQuestListClass.Create;
begin
  DataList := TList.Create;
  NameIndex := TStringKeyClass.Create;
end;

function TcQuestListClass.Delete(Aname: string): Boolean;
var
  i: Integer;
  p: Pointer;
begin
  p := self.NameIndex.Select(Aname);
  Result := self.NameIndex.Delete(Aname);
  i := DataList.IndexOf(p);
  DataList.Delete(i);
end;

destructor TcQuestListClass.Destroy;
begin
  clear;
  DataList.free;
  NameIndex.free;

  inherited;
end;

function TcQuestListClass.get(aname: string): pTNewQuestdata;
begin
  result := NameIndex.Select(aname);
end;

function TcQuestListClass.getCount: Integer;
begin
  Result := self.NameIndex.Count;
end;

function TcQuestListClass.getDataByIndex(AIndex: Integer): pTNewQuestdata;
begin

  Result := self.NameIndex.SelectByIndex(AIndex);
end;

procedure TfrmNewQuest.FormShow(Sender: TObject);
begin
  inherited;
//  if FCurQuestPage = 255 then
//  begin
//    QuestPage1A2ILabelClick(nil);
//    exit;
//  end;
  case FCurQuestPage of
    0: QuestPage1A2ILabelClick(Sender);
    1: QuestPage2A2ILabelClick(Sender);
    2: QuestPage3A2ILabelClick(Sender);
  else
    QuestPage1A2ILabelClick(nil);
  end;
end;

procedure TfrmNewQuest.QuestListA2ListClick(Sender: TObject);
var
  i: Integer;
  p: pTNewQuestdata;
begin
  inherited;
  i := QuestListA2List.ItemIndex;
  if (i = -1) or (i>=QuestListA2List.Count) then Exit;
  case FCurQuestPage of
    0:
      begin
        p := G_TcQuestListClass1.getDataByIndex(i);
        if p = nil then Exit;
        ShowQuestData(p);
      end;
    1: begin
        p := G_TcQuestListClass2.getDataByIndex(i);
        if p = nil then Exit;
        ShowQuestData(p);
      end;
    2: begin
        p := G_TcQuestListClass3.getDataByIndex(i);
        if p = nil then Exit;
        ShowQuestData(p);
      end;
  end;

end;

procedure TfrmNewQuest.Item1A2ILabelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  tmpitem: TItemData;
  itemname, num: string;
  sourceitem: PTItemdata;
  iteminfolist: TStringList;
begin
  inherited;
  itemname := FItemList[TA2ILabel(Sender).Tag];
  if itemname <> '' then
  begin
    try
      iteminfolist := TStringList.Create;
      iteminfolist.CommaText := StringReplace(itemname, ':', #13#10, [rfReplaceAll]);
      itemname := iteminfolist[0];
      num := iteminfolist[1];

    finally
      iteminfolist.Free;
    end;
  end;
  sourceitem := G_BufferItemDataClass.get(itemname);
  if sourceitem = nil then
  begin
    FrmBottom.SendGetItemData(itemname);
    Exit;
  end;
  CopyMemory(@tmpitem, sourceitem, SizeOf(TItemData));
  tmpitem.rCount := StrToIntDef(num, 1);
  GameHint.settext(Integer(Sender), TItemDataToStr(tmpitem));
end;

procedure TfrmNewQuest.Item1A2ILabelMouseLeave(Sender: TObject);
begin
  inherited;
  GameHint.Close;
end;

procedure TfrmNewQuest.QuestComplete_A2ButtonClick(Sender: TObject);

var
  PQuestGet: TCQuestGet;
  cnt: Integer;
begin
  if FQuestId = -1 then Exit;
  PQuestGet.rmsg := CM_GETQUESTLIST;
  PQuestGet.rkey := NewQuest_CM_COMPLETE;
  PQuestGet.rqid := FQuestId;
  PQuestGet.rgid := FCurQuestPage;

  cnt := SizeOf(TCQuestGet);
  Frmfbl.SocketAddData(cnt, @PQuestGet);
end;

procedure TfrmNewQuest.btnCloseClick(Sender: TObject);
begin
  inherited;
  self.Close;
end;

initialization
  G_TcQuestListClass1 := TcQuestListClass.Create;
  G_TcQuestListClass2 := TcQuestListClass.Create;
  G_TcQuestListClass3 := TcQuestListClass.Create;
finalization
  G_TcQuestListClass1.Free;
  G_TcQuestListClass2.Free;
  G_TcQuestListClass3.Free;
end.

