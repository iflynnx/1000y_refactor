unit FProcession;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, Deftype, uKeyClass, BaseUIForm;

type
  TProcessiondata = record
    rid: integer;
    rname: string[32];
    rA2Image: TA2Image;
    rcolor: tcolor;
  end;
  pTProcessiondata = ^TProcessiondata;
  TCharListNAME = class;
  TfrmProcession = class(TfrmBaseUI)
    A2Form: TA2Form;
    A2ListBox1: TA2ListBox;
    A2ButtonClose: TA2Button;
    A2Buttonadd: TA2Button;
    A2ButtonHeadmanid: TA2Button;
    A2ButtonDel: TA2Button;
    A2ButtonExit: TA2Button;
    A2Buttondisband: TA2Button;
    A2ListBoxclList: TA2ListBox;
    A2Button1: TA2Button;
    A2Button2: TA2Button;
    A2Button3: TA2Button;
    A2Buttonguildadd: TA2Button;
    A2Button5: TA2Button;
    A2ButtonProcessionAdd: TA2Button;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ButtonCloseClick(Sender: TObject);
    procedure A2ListBox1AdxDrawItem(ASurface: TA2Image; index: Integer;
      aStr: string; Rect: TRect; State: TDrawItemState; fx, fy: Integer);
    procedure A2ButtonExitClick(Sender: TObject);
    procedure A2ButtondisbandClick(Sender: TObject);
    procedure A2ButtonHeadmanidClick(Sender: TObject);
    procedure A2ButtonaddClick(Sender: TObject);
    procedure A2ButtonDelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure A2ListBoxclListAdxDrawItem(ASurface: TA2Image;
      index: Integer; aStr: string; Rect: TRect; State: TDrawItemState; fx,
      fy: Integer);
    procedure A2Button1Click(Sender: TObject);
    procedure A2ButtonguildaddClick(Sender: TObject);
    procedure A2Button3Click(Sender: TObject);
    procedure A2Button5Click(Sender: TObject);
    procedure A2ButtonProcessionAddClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClick(Sender: TObject);

  private
        { Private declarations }
  public
        { Public declarations }
    FCharList: TCharListNAME;
    ftitleW, ftitleH: integer;
    ftextcolor: tcolor;
    fheadmantextcolor: tcolor;
    headmanid: integer;
    FDATA: tlist;
    temping, tempup, tempdown: TA2Image;
    procedure FDATAClear();
    procedure FDATAdel(aid: integer);
    procedure fdataadd(aid: integer; aname: string);
    function GETid(aid: integer): PTProcessiondata;
    function GETIndex(aid: integer): PTProcessiondata;
    function GETname(aname: string): PTProcessiondata;
    procedure buttonstate();

    procedure ButtonShowAdd();
    procedure Buttonheadman(findex: integer);
    procedure sendSay(astr: string);
    procedure Buttondel(findex: integer);
    procedure MessageProcess(var code: TWordComData);

    procedure sendProcessionAdd(aname: string);


   // procedure SetOldVersion();

    procedure SetNewVersion(); override;


   // procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
  end;

  TCharListdata = record
    rid: integer;
    rname: string[64];
    rGuildName: string[64];
    rConsortName: string[64];
  end;
  pTCharListdata = ^TCharListdata;
  TCharListNAME = class
  private
    FDATA: TLIST;

  public
    tempTA2ListBox: TA2ListBox;
    constructor Create;
    destructor Destroy; override;
    procedure Clear();
    procedure ADD(aid: integer; aname, aGuildName: string);
    procedure ChangeProperty(str: string; PP: pTCharListdata);
    procedure del(aid: integer);
    function get(aname: string): pTCharListdata;
    function getindex(aindex: integer): pTCharListdata;
  end;

var
  frmProcession: TfrmProcession;

implementation

uses FBottom, FMain, FConfirmDialog, CharCls, Fbl, FShowPopMsg,
  FProcessionList, FProcessionButton, filepgkclass, AUtil32, FAttrib, FGuild,
  FWearItemUser, uPersonBat;

{$R *.dfm}

function TCharListNAME.get(aname: string): pTCharListdata;
var
  I: INTEGER;
  PP: pTCharListdata;
begin
  result := nil;
  for I := 0 to FDATA.Count - 1 do
  begin
    PP := FDATA.Items[I];
    if PP.rname = ANAME then
    begin
      result := pp;
      EXIT;
    end;
  end;

end;

function TCharListNAME.getindex(aindex: integer): pTCharListdata;
begin
  result := nil;
  if (aindex >= 0) and (aindex < FDATA.Count) then
    result := FDATA.Items[aindex];
end;

procedure TCharListNAME.ChangeProperty(str: string; PP: pTCharListdata);
var
  strs: string;
begin
    // str := GetWordString(pd.rWordString);
  str := GetValidStr3(str, strs, ',');
  PP.rname := copy(strs, 1, 64);
  str := GetValidStr3(str, strs, ',');
  PP.rGuildName := copy(strs, 1, 64);
  str := GetValidStr3(str, strs, ',');
  pp.rConsortName := copy(strs, 1, 64);

end;

procedure TCharListNAME.ADD(aid: integer; aname, aGuildName: string);
var
  PP: pTCharListdata;
begin
  if get(aname) <> nil then exit;
  New(pp);
  pp.rid := aid;
  ChangeProperty(aname, pp);
    //    pp.rname := copy(aname, 1, 64);
      //  pp.rGuildName := copy(aGuildName, 1, 64);
  FDATA.add(pp);
  tempTA2ListBox.AddItem(' ');
    //tempTA2ListBox.DrawItem;
end;

procedure TCharListNAME.del(aid: integer);
var
  I: INTEGER;
  PP: pTCharListdata;
begin
  for I := 0 to FDATA.Count - 1 do
  begin
    PP := FDATA.Items[I];
    if pp.rid = aid then
    begin
      DISPOSE(PP);
      FDATA.Delete(i);
      tempTA2ListBox.DeleteItem(0);
      exit;
    end;
  end;

end;

procedure TCharListNAME.Clear();
var
  I: INTEGER;
  PP: pTCharListdata;
begin
  for I := 0 to FDATA.Count - 1 do
  begin
    PP := FDATA.Items[I];
    DISPOSE(PP);
  end;
  FDATA.Clear;
  tempTA2ListBox.Clear;
    // tempTA2ListBox.DrawItem;
end;

constructor TCharListNAME.Create;
begin
  inherited Create;
  FDATA := Tlist.Create;
end;

destructor TCharListNAME.Destroy;
begin
  Clear;
  FDATA.Free;
  inherited Destroy;
end;
/////////////////////////////////////////////////////////////////////////////////

procedure TfrmProcession.buttonstate();
var
  p: PTProcessiondata;
begin
  A2ButtonExit.Visible := true;
  p := GETname(CharCenterName);

  if p <> nil then
  begin
    if p.rid <> headmanid then
    begin

      A2ButtonDel.Enabled := false;
      A2ButtonHeadmanid.Enabled := false;
      A2Buttonadd.Enabled := false;
      A2Buttondisband.Enabled := false;

    end else
    begin
      A2ButtonDel.Enabled := true;
      A2ButtonHeadmanid.Enabled := true;
      A2Buttonadd.Enabled := true;
      A2Buttondisband.Enabled := true;
    end;
  end else
  begin
    FDATAClear;

    A2ButtonDel.Enabled := true;
    A2ButtonHeadmanid.Enabled := true;
    A2Buttonadd.Enabled := true;
    A2Buttondisband.Enabled := true;

  end;

  A2ButtonProcessionAdd.Enabled := A2Buttonadd.Enabled;

  frmProcessionButton.A2ButtonDel.Enabled := A2ButtonDel.Enabled;
  frmProcessionButton.A2ButtonHeadmanid.Enabled := A2ButtonHeadmanid.Enabled;
  frmProcessionButton.A2Buttonadd.Enabled := A2Buttonadd.Enabled;
  frmProcessionButton.A2Buttondisband.Enabled := A2Buttondisband.Enabled;
  A2ListBox1.DrawItem;
  frmProcessionList.ListDrawItem;
end;

procedure TfrmProcession.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  aeid, id, akey, i, alen: integer;
  atitle, aname: string;
  p: PTProcessiondata;
begin
  pckey := @Code.Data;
  case pckey^.rmsg of
    SM_Procession:
      begin
        id := 1;
        akey := WordComData_GETbyte(code, id);
        case akey of
          Procession_AddExp:
            begin
              i := WordComData_GETdword(code, id);
              atitle := format('组队经验 %d', [i]);
              PersonBat.LeftMsgListadd3(atitle, WinRGB(22, 22, 0));
            end;
          Procession_say:
            begin
              aname := WordComData_GETstring(code, id);
              atitle := WordComData_GETstring(code, id);
              FrmBottom.AddChat(format('[队伍]%s:%s', [aname, atitle]), ColorSysToDxColor(clLime), 0);
            end;
          Procession_ADD:
            begin
              aeid := WordComData_GETdword(code, id);
              aname := WordComData_GETstring(code, id);
              FDATAadd(aeid, aname);
              FrmBottom.AddChat(format('%S 加入队伍', [aname]), WinRGB(22, 22, 0), 0);
              buttonstate;

            end;
          Procession_del:
            begin
              p := GETname(CharCenterName);
              if p = nil then
              begin
                FDATAClear;
                FrmBottom.AddChat('Procession_del错误，自己没队伍', WinRGB(22, 22, 0), 0);
                exit;
              end;
              aeid := WordComData_GETdword(code, id);
              if p.rid = aeid then
              begin
                FDATAClear;
                FrmBottom.AddChat('队伍被解散', WinRGB(22, 22, 0), 0);
                exit;
              end;
              FDATAdel(aeid);
              buttonstate;
            end;
          Procession_LIST:
            begin
              FDATAClear;
              alen := WordComData_GETbyte(code, id);
              for i := 0 to alen - 1 do
              begin
                aeid := WordComData_GETdword(code, id);
                aname := WordComData_GETstring(code, id);
                FDATAadd(aeid, aname);
              end;
              buttonstate;
            end;
          Procession_disband:
            begin
              FDATAClear;
              FrmBottom.AddChat('队伍被解散', WinRGB(22, 22, 0), 0);
              buttonstate;
            end;
          Procession_ADDMsg:
            begin
              frmPopMsg.MessageProcess(code);
            end;
          Procession_headman:
            begin
              p := GETid(headmanid);
              if p <> nil then p.rcolor := ftextcolor;
              aeid := WordComData_GETdword(code, id);
              headmanid := aeid;
              p := GETid(headmanid);
              if p <> nil then p.rcolor := fheadmantextcolor;
              A2ListBox1.DrawItem;

              FrmBottom.AddChat('队伍队长改变', WinRGB(22, 22, 0), 0);
              if p <> nil then
                FrmBottom.AddChat('队伍新队长' + p.rname, WinRGB(22, 22, 0), 0);
              buttonstate;
            end;
          Procession_additem:
            begin
              aeid := WordComData_GETdword(code, id);
              p := GETid(aeid);
              if p = nil then exit;

              aname := WordComData_GETstring(code, id);
              i := WordComData_GETdword(code, id);
              atitle := format('%s 获得 %s %d个', [p.rname, aname, i]);
              PersonBat.LeftMsgListadd3(atitle, WinRGB(22, 22, 0));
            end;
        end;
      end;
  end;

end;

procedure TfrmProcession.fdataadd(aid: integer; aname: string);
var
  p: PTProcessiondata;
begin
  if GETid(aid) <> nil then exit;
  new(p);
  p.rid := aid;
  p.rname := aname;
  p.rcolor := ftextcolor;
  p.rA2Image := TA2Image.Create(ftitleW, ftitleH, 0, 0);
  fdata.Add(p);
  A2ListBox1.AddItem(' ');
  A2ListBox1.DrawItem;
  frmProcessionList.ListDrawItem;
end;

function TfrmProcession.GETIndex(aid: integer): PTProcessiondata;
begin
  result := nil;
  if (aid < 0) or (aid > FDATA.Count - 1) then exit;
  result := fdata.Items[aid];
end;

function TfrmProcession.GETid(aid: integer): PTProcessiondata;
var
  i: integer;
  p: PTProcessiondata;
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

function TfrmProcession.GETname(aname: string): PTProcessiondata;
var
  i: integer;
  p: PTProcessiondata;
begin
  result := nil;
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.rname = aname then
    begin
      result := p;
      exit;
    end;
  end;

end;

procedure TfrmProcession.FDATAdel(aid: integer);
var
  i: integer;
  p: PTProcessiondata;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.rid = aid then
    begin
      FrmBottom.AddChat(format('%S 离开队伍', [p.rname]), WinRGB(22, 22, 0), 0);
      fdata.Delete(i);
      A2ListBox1.DeleteItem(i);
      p.rA2Image.Free;
      Dispose(p);
      exit;
    end;
  end;
  A2ListBox1.DrawItem;
  if Assigned(frmProcessionList) then frmProcessionList.ListDrawItem;
end;

procedure TfrmProcession.FDATAClear();
var
  i: integer;
  p: pTProcessiondata;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    p.rA2Image.Free;
    dispose(p);

  end;
  fdata.Clear;
  A2ListBox1.Clear;
  A2ListBox1.DrawItem;
  if Assigned(frmProcessionList) then frmProcessionList.ListDrawItem;
end;

procedure TfrmProcession.FormCreate(Sender: TObject);
begin
  inherited;
  FCharList := TCharListNAME.Create;
  FCharList.tempTA2ListBox := A2ListBoxclList;
  frmProcessionButton := TfrmProcessionButton.Create(frmm);
  frmProcessionList := TfrmProcessionList.Create(FrmM);
  ftitleW := frmProcessionList.A2ILabelTitle.Width;
  ftitleH := 20;
  FDATA := tlist.Create;
  FrmM.AddA2Form(Self, A2Form);
  if WinVerType = wvtnew then
  begin
    SetNewVersion;
//  end
//  else if WinVerType = wvtold then
//  begin
//    SetOldVersion;
  end;
  A2ListBoxclList.FFontSelBACKColor := ColorSysToDxColor($9B7781);
  buttonstate;
end;

procedure TfrmProcession.SetNewVersion;
begin
  inherited;
end;

//procedure TfrmProcession.SetOldVersion;
//begin
//  pgkBmp.getBmp('Procession.bmp', A2Form.FImageSurface);
//  A2Form.boImagesurface := true;
//    //Parent := FrmM;
//  Top := 30;
//  Left := 0;
//  ftextcolor := clWhite;
//  fheadmantextcolor := clWhite;
//    //  A2ListBox1.SetScrollTopImage(getviewImage(7), getviewImage(6));
//   //   A2ListBox1.SetScrollTrackImage(getviewImage(4), getviewImage(5));
//    //  A2ListBox1.SetScrollBottomImage(getviewImage(9), getviewImage(8));
//  A2ListBox1.FFontSelBACKColor := ColorSysToDxColor($9B7781);
//
//  A2ListBoxclList.SetScrollTopImage(getviewImage(7), getviewImage(6));
//  A2ListBoxclList.SetScrollTrackImage(getviewImage(4), getviewImage(5));
//  A2ListBoxclList.SetScrollBottomImage(getviewImage(9), getviewImage(8));
//
//end;

procedure TfrmProcession.FormDestroy(Sender: TObject);
begin
  FCharList.Free;
  FDATAClear;
  FDATA.Free;
  frmProcessionList.Free;
  frmProcessionButton.Free;
  temping.Free;
  tempup.Free;
  tempdown.Free;
end;

procedure TfrmProcession.ButtonShowAdd();
var
  frmConfirmDialog: TfrmConfirmDialog;
  p: pTProcessiondata;
begin
  if FDATA.Count = 0 then
  begin

  end else
  begin
    p := GETname(CharCenterName);
    if p = nil then exit;
    if p.rid <> headmanid then
    begin
      FrmBottom.AddChat(format('%s 你没权限！', [p.rName]), WinRGB(22, 22, 0), 0);
      exit;
    end;

  end;
    //创建 输入 窗口
  frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
    //FrmM.SetA2Form(frmConfirmDialog,frmConfirmDialog.A2Form);
  frmConfirmDialog.ShowFrom(cdtProcession_ADD, '输入要加入玩家名字', '');
end;

procedure TfrmProcession.sendSay(astr: string);
var
  p, p2: pTProcessiondata;
  tempsend: TWordComData;
begin
  astr := copy(astr, 2, length(astr));
  p := GETname(CharCenterName);
  if p = nil then exit;

  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, CM_Procession);
  WordComData_ADDbyte(tempsend, Procession_say);

  WordComData_ADDstring(tempsend, astr);
  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TfrmProcession.Buttonheadman(findex: integer);
var
  p, p2: pTProcessiondata;
  tempsend: TWordComData;
begin
  p := GETname(CharCenterName);
  p2 := GETIndex(findex);
  if p2 = nil then exit;
  if p = nil then exit;
  if p.rid <> headmanid then
  begin
    FrmBottom.AddChat(format('%s 你没权限！', [p.rName]), WinRGB(22, 22, 0), 0);
    exit;
  end;

  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, CM_Procession);
  WordComData_ADDbyte(tempsend, Procession_headman);
  WordComData_ADDdword(tempsend, p2.rid);

  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TfrmProcession.Buttondel(findex: integer);
var
  p, p2: pTProcessiondata;
  tempsend: TWordComData;
begin
  p := GETname(CharCenterName);
  p2 := GETIndex(A2ListBox1.ItemIndex);
  if p2 = nil then exit;
  if p = nil then exit;
  if p.rid <> headmanid then
  begin
    FrmBottom.AddChat(format('%s 你没权限！', [p.rName]), WinRGB(22, 22, 0), 0);
    exit;
  end;

  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, CM_Procession);
  WordComData_ADDbyte(tempsend, Procession_DEL);
  WordComData_ADDdword(tempsend, p2.rid);

  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TfrmProcession.A2ButtonCloseClick(Sender: TObject);
begin
  Visible := false;
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TfrmProcession.A2ListBox1AdxDrawItem(ASurface: TA2Image;
  index: Integer; aStr: string; Rect: TRect; State: TDrawItemState; fx,
  fy: Integer);
var
  P: pTProcessiondata;
begin
  P := GETIndex(index);
  if P = nil then EXIT;
  ATextOut(ASurface, 0, 0, A2ListBox1.FontColor, p.rname);
  if p.rid = headmanid then
    ATextOut(ASurface, 120, 0, A2ListBox1.FontColor, '队长')
  else
    ATextOut(ASurface, 120, 0, A2ListBox1.FontColor, '队员');
end;

procedure TfrmProcession.A2ButtonExitClick(Sender: TObject);
var
  p2: pTProcessiondata;
  tempsend: TWordComData;
begin

    //  p2 := GETIndex(A2ListBox1.ItemIndex);
     // if p2 = nil then exit;

  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, CM_Procession);
  WordComData_ADDbyte(tempsend, Procession_exit);
  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TfrmProcession.A2ButtondisbandClick(Sender: TObject);
var
  p: pTProcessiondata;
  tempsend: TWordComData;
begin
  p := GETname(CharCenterName);
  if p = nil then exit;
  if p.rid <> headmanid then
  begin
    FrmBottom.AddChat(format('%s 你没权限！', [p.rName]), WinRGB(22, 22, 0), 0);
    exit;
  end;

  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, CM_Procession);
  WordComData_ADDbyte(tempsend, Procession_disband);

  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TfrmProcession.A2ButtonHeadmanidClick(Sender: TObject);
begin
  Buttonheadman(A2ListBox1.ItemIndex);
end;

procedure TfrmProcession.sendProcessionAdd(aname: string);
var
  tempsend: TWordComData;
begin
  if aname = '' then exit;
  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, CM_Procession);
  WordComData_ADDbyte(tempsend, Procession_ADDMsg);

  WordComData_ADDstring(tempsend, aname);
  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
  FrmBottom.AddChat(format('邀请[%s]加入队伍,等待对方应答!', [aname]), WinRGB(22, 22, 0), 0);
end;

procedure TfrmProcession.A2ButtonaddClick(Sender: TObject);
begin
  ButtonShowAdd;
end;

procedure TfrmProcession.A2ButtonDelClick(Sender: TObject);
begin
  Buttondel(A2ListBox1.ItemIndex);
end;

procedure TfrmProcession.FormShow(Sender: TObject);
begin
  buttonstate;
end;

procedure TfrmProcession.Timer1Timer(Sender: TObject);
begin
  A2Buttonguildadd.Enabled := frmGuild.isSysop or frmGuild.isSubSysop;
end;

procedure TfrmProcession.A2ListBoxclListAdxDrawItem(ASurface: TA2Image;
  index: Integer; aStr: string; Rect: TRect; State: TDrawItemState; fx,
  fy: Integer);
var
  P: pTCharListdata;
begin
  P := FCharList.getindex(index);
  if P = nil then EXIT;

  ATextOut(ASurface, 0, 0, A2ListBox1.FontColor, p.rname);
  ATextOut(ASurface, 100, 0, A2ListBox1.FontColor, p.rGuildName);
end;

procedure TfrmProcession.A2Button1Click(Sender: TObject);
var
  P: pTCharListdata;
begin
  P := FCharList.getindex(A2ListBoxclList.ItemIndex);
  if P = nil then EXIT;
  FrmAttrib.sendHailFellowAdd(p.rname);
end;

procedure TfrmProcession.A2ButtonguildaddClick(Sender: TObject);
var
  P: pTCharListdata;

begin
  P := FCharList.getindex(A2ListBoxclList.ItemIndex);
  if P = nil then EXIT;

  frmGuild.sendGuildAdd(p.rname);
end;

procedure TfrmProcession.A2Button3Click(Sender: TObject);
var
  P: pTCharListdata;

begin
  P := FCharList.getindex(A2ListBoxclList.ItemIndex);
  if P = nil then EXIT;
  FrmBottom.EdChat.Text := '@纸条 ' + p.rname + ' ';
  FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
end;

procedure TfrmProcession.A2Button5Click(Sender: TObject);
var
  P: pTCharListdata;
  cl: TCharClass;
begin
  P := FCharList.getindex(A2ListBoxclList.ItemIndex);
  if P = nil then EXIT;
  cl := CharList.CharGet(p.rid);
  if cl = nil then exit;

  FrmM.send_get_WearItemUser(cl.id);
end;

procedure TfrmProcession.A2ButtonProcessionAddClick(Sender: TObject);
var
  P: pTCharListdata;

begin
  P := FCharList.getindex(A2ListBoxclList.ItemIndex);
  if P = nil then EXIT;
  sendProcessionAdd(p.rname);
end;

procedure TfrmProcession.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmProcession.FormClick(Sender: TObject);
begin
    //    A2ListBox1.StringList.Text := CharList.CharGetAllName;
end;

procedure TfrmProcession.SetConfigFileName;
begin
  FConfigFileName := 'Procession.xml';

end;

//procedure TfrmProcession.SetNewVersionOld;
//begin
//  pgkBmp.getBmp('玩家交互窗口.bmp', A2Form.FImageSurface);
//  A2Form.boImagesurface := true;
//  Top := 30;
//  Left := 0;
//  ftextcolor := clWhite;
//  fheadmantextcolor := clWhite;
//
//    //加黑名单按钮
//  temping := TA2Image.Create(32, 32, 0, 0);
//  pgkBmp.getBmp('玩家交互_加黑名单_弹起.bmp', temping);
//  A2Button2.A2Up := temping;
//  pgkBmp.getBmp('玩家交互_加黑名单_按下.bmp', temping);
//  A2Button2.A2Down := temping;
//  pgkBmp.getBmp('玩家交互_加黑名单_鼠标.bmp', temping);
//  A2Button2.A2Mouse := temping;
//  pgkBmp.getBmp('玩家交互_加黑名单_禁止.bmp', temping);
//  A2Button2.A2NotEnabled := temping;
//  A2Button2.Left := 41;
//  A2Button2.Top := 227;
//    //加好友按钮
//  pgkBmp.getBmp('玩家交互_加为好友_弹起.bmp', temping);
//  A2Button1.A2Up := temping;
//  pgkBmp.getBmp('玩家交互_加为好友_按下.bmp', temping);
//  A2Button1.A2Down := temping;
//  pgkBmp.getBmp('玩家交互_加为好友_鼠标.bmp', temping);
//  A2Button1.A2Mouse := temping;
//  pgkBmp.getBmp('玩家交互_加为好友_禁止.bmp', temping);
//  A2Button1.A2NotEnabled := temping;
//  A2Button1.Left := 120;
//  A2Button1.Top := 227;
//    //发送纸条按钮
//  pgkBmp.getBmp('玩家交互_发送纸条_弹起.bmp', temping);
//  A2Button3.A2Up := temping;
//  pgkBmp.getBmp('玩家交互_发送纸条_按下.bmp', temping);
//  A2Button3.A2Down := temping;
//  pgkBmp.getBmp('玩家交互_发送纸条_鼠标.bmp', temping);
//  A2Button3.A2Mouse := temping;
//  pgkBmp.getBmp('玩家交互_发送纸条_禁止.bmp', temping);
//  A2Button3.A2NotEnabled := temping;
//  A2Button3.Left := 41;
//  A2Button3.Top := 255;
//    //邀请入门按钮
//  pgkBmp.getBmp('玩家交互_邀请入门_弹起.bmp', temping);
//  A2Buttonguildadd.A2Up := temping;
//  pgkBmp.getBmp('玩家交互_邀请入门_按下.bmp', temping);
//  A2Buttonguildadd.A2Down := temping;
//  pgkBmp.getBmp('玩家交互_邀请入门_鼠标.bmp', temping);
//  A2Buttonguildadd.A2Mouse := temping;
//  pgkBmp.getBmp('玩家交互_邀请入门_禁止.bmp', temping);
//  A2Buttonguildadd.A2NotEnabled := temping;
//  A2Buttonguildadd.Left := 120;
//  A2Buttonguildadd.Top := 255;
//    //查看装备按钮
//  pgkBmp.getBmp('玩家交互_查看装备_弹起.bmp', temping);
//  A2Button5.A2Up := temping;
//  pgkBmp.getBmp('玩家交互_查看装备_按下.bmp', temping);
//  A2Button5.A2Down := temping;
//  pgkBmp.getBmp('玩家交互_查看装备_鼠标.bmp', temping);
//  A2Button5.A2Mouse := temping;
//  pgkBmp.getBmp('玩家交互_查看装备_禁止.bmp', temping);
//  A2Button5.A2NotEnabled := temping;
//  A2Button5.Left := 41;
//  A2Button5.Top := 283;
//    //邀请组队按钮
//  pgkBmp.getBmp('玩家交互_邀请组队_弹起.bmp', temping);
//  A2ButtonProcessionAdd.A2Up := temping;
//  pgkBmp.getBmp('玩家交互_邀请组队_按下.bmp', temping);
//  A2ButtonProcessionAdd.A2Down := temping;
//  pgkBmp.getBmp('玩家交互_邀请组队_鼠标.bmp', temping);
//  A2ButtonProcessionAdd.A2Mouse := temping;
//  pgkBmp.getBmp('玩家交互_邀请组队_禁止.bmp', temping);
//  A2ButtonProcessionAdd.A2NotEnabled := temping;
//  A2ButtonProcessionAdd.Left := 120;
//  A2ButtonProcessionAdd.Top := 283;
//    //踢出队伍按钮
//  pgkBmp.getBmp('玩家交互_踢出队伍_弹起.bmp', temping);
//  A2ButtonDel.A2Up := temping;
//  pgkBmp.getBmp('玩家交互_踢出队伍_按下.bmp', temping);
//  A2ButtonDel.A2Down := temping;
//  pgkBmp.getBmp('玩家交互_踢出队伍_鼠标.bmp', temping);
//  A2ButtonDel.A2Mouse := temping;
//  pgkBmp.getBmp('玩家交互_踢出队伍_禁止.bmp', temping);
//  A2ButtonDel.A2NotEnabled := temping;
//  A2ButtonDel.Left := 241;
//  A2ButtonDel.Top := 227;
//
//    //退出队伍按钮
//  pgkBmp.getBmp('玩家交互_退出队伍_弹起.bmp', temping);
//  A2ButtonExit.A2Up := temping;
//  pgkBmp.getBmp('玩家交互_退出队伍_按下.bmp', temping);
//  A2ButtonExit.A2Down := temping;
//  pgkBmp.getBmp('玩家交互_退出队伍_鼠标.bmp', temping);
//  A2ButtonExit.A2Mouse := temping;
//  pgkBmp.getBmp('玩家交互_退出队伍_禁止.bmp', temping);
//  A2ButtonExit.A2NotEnabled := temping;
//
//  A2ButtonExit.Left := 320;
//  A2ButtonExit.Top := 227;
//    //转移队长按钮
//  pgkBmp.getBmp('玩家交互_转移队长_弹起.bmp', temping);
//  A2ButtonHeadmanid.A2Up := temping;
//  pgkBmp.getBmp('玩家交互_转移队长_按下.bmp', temping);
//  A2ButtonHeadmanid.A2Down := temping;
//  pgkBmp.getBmp('玩家交互_转移队长_鼠标.bmp', temping);
//  A2ButtonHeadmanid.A2Mouse := temping;
//  pgkBmp.getBmp('玩家交互_转移队长_禁止.bmp', temping);
//  A2ButtonHeadmanid.A2NotEnabled := temping;
//  A2ButtonHeadmanid.Left := 241;
//  A2ButtonHeadmanid.Top := 255;
//    //解散队伍按钮
//  pgkBmp.getBmp('玩家交互_解散队伍_弹起.bmp', temping);
//  A2Buttondisband.A2Up := temping;
//  pgkBmp.getBmp('玩家交互_解散队伍_按下.bmp', temping);
//  A2Buttondisband.A2Down := temping;
//  pgkBmp.getBmp('玩家交互_解散队伍_鼠标.bmp', temping);
//  A2Buttondisband.A2Mouse := temping;
//  pgkBmp.getBmp('玩家交互_解散队伍_禁止.bmp', temping);
//  A2Buttondisband.A2NotEnabled := temping;
//  A2Buttondisband.Left := 320;
//  A2Buttondisband.Top := 255;
//    //邀请加入按钮
//  pgkBmp.getBmp('玩家交互_邀请加入_弹起.bmp', temping);
//  A2Buttonadd.A2Up := temping;
//  pgkBmp.getBmp('玩家交互_邀请加入_按下.bmp', temping);
//  A2Buttonadd.A2Down := temping;
//  pgkBmp.getBmp('玩家交互_邀请加入_鼠标.bmp', temping);
//  A2Buttonadd.A2Mouse := temping;
//  pgkBmp.getBmp('玩家交互_邀请加入_禁止.bmp', temping);
//  A2Buttonadd.A2NotEnabled := temping;
//
//  A2Buttonadd.Left := 241;
//  A2Buttonadd.Top := 283;
//    //关闭按钮
//  pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
//  A2ButtonClose.A2Up := temping;
//  pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
//  A2ButtonClose.A2Down := temping;
//  pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
//  A2ButtonClose.A2Mouse := temping;
//  pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
//  A2ButtonClose.A2NotEnabled := temping;
//
//  A2ButtonClose.Left := 382;
//  A2ButtonClose.Top := 16;
//
//    //通用下拉菜单
//  tempup := TA2Image.Create(32, 32, 0, 0);
//  tempdown := TA2Image.Create(32, 32, 0, 0);
//
//  pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempup);
//  pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempdown);
//  A2ListBoxclList.SetScrollTopImage(tempup, tempdown);
//
//  pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempup);
//  pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempdown);
//  A2ListBoxclList.SetScrollTrackImage(tempup, tempdown);
//
//  pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempup);
//  pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempdown);
//  A2ListBoxclList.SetScrollBottomImage(tempup, tempdown);
//
//  pgkBmp.getBmp('好友列表_下拉条底框.bmp', temping);
//  A2ListBoxclList.SetScrollBackImage(temping);
//
//  A2ListBoxclList.Left := 18;
//  A2ListBoxclList.Top := 86;
//  A2ListBoxclList.Width := 182;
//  A2ListBoxclList.Height := 130;
//    //通用下拉菜单
//  pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempup);
//  pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempdown);
//  A2ListBox1.SetScrollTopImage(tempup, tempdown);
//
//  pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempup);
//  pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempdown);
//  A2ListBox1.SetScrollTrackImage(tempup, tempdown);
//
//  pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempup);
//  pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempdown);
//  A2ListBox1.SetScrollBottomImage(tempup, tempdown);
//
//  pgkBmp.getBmp('好友列表_下拉条底框.bmp', temping);
//  A2ListBox1.SetScrollBackImage(temping);
//
//  A2ListBox1.Left := 217;
//  A2ListBox1.Top := 86;
//  A2ListBox1.Width := 182;
//  A2ListBox1.Height := 130;
//
//end;

procedure TfrmProcession.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  ftextcolor := clWhite;
  fheadmantextcolor := clWhite;
  SetControlPos(A2Button2);
  SetControlPos(A2Button1);
  SetControlPos(A2Button3);
  SetControlPos(A2Buttonguildadd);
  SetControlPos(A2Button5);
  SetControlPos(A2ButtonProcessionAdd);
  SetControlPos(A2ButtonDel);
  SetControlPos(A2ButtonExit);
  SetControlPos(A2ButtonHeadmanid);
  SetControlPos(A2Buttondisband);
  SetControlPos(A2Buttonadd);
  SetControlPos(A2ButtonClose);
  SetControlPos(A2ListBoxclList);
  SetControlPos(A2ListBox1);


end;

procedure TfrmProcession.settransparent(transparent: Boolean);
begin
  self.A2Form.TransParent := transparent;
end;

end.

