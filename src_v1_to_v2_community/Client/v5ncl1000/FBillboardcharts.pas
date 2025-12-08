unit FBillboardcharts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, StdCtrls, ExtCtrls, Deftype, A2Img, BaseUIForm, NativeXml;

type
    //TBillboardchartsdata
  TfrmBillboardcharts = class(TfrmBaseUI)
    A2Form: TA2Form;
    A2ButtonEnergy: TA2Button;
    A2ButtonPrestige: TA2Button;
    A2Button2: TA2Button;
    A2ListBox1: TA2ListBox;
    A2ButtonNEXT: TA2Button;
    ComboBox: TA2ComboBox;
    A2Button3: TA2Button;
    A2ILabelTitle: TA2ILabel;
    A2ILabelfield: TA2ILabel;
    A2ButtonGuild: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ButtonEnergyClick(Sender: TObject);
    procedure A2ButtonPrestigeClick(Sender: TObject);
    procedure A2ButtonNEXTClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure A2ListBox1AdxDrawItem(ASurface: TA2Image; index: Integer;
      aStr: string; Rect: TRect; State: TDrawItemState; fx, fy: Integer);
    procedure A2Button2Click(Sender: TObject);
    procedure A2Button3Click(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2ButtonGuildClick(Sender: TObject);
  private
    FRankName1X, FRankName1Y: Integer;
    FRoleName1X, FRoleName1Y: Integer;
    FRankName2X, FRankName2Y: Integer;
    FRoleName2X, FRoleName2Y: Integer;
    FSex1X, FSex1Y: Integer;
    FSex2X, FSex2Y: Integer;
    FYuanQi1X, FYuanQi1Y: Integer;
    FYuanQi2X, FYuanQi2Y: Integer;
    FRongYu1X, FRongYu1Y: Integer;
    FRongYu2X, FRongYu2Y: Integer;
    FSM_Command: Integer;
    procedure updateTitle;
  public
        { Public declarations }
    Findex: integer;
    fdata: tlist;
    fdata2: tlist;
    ftype: TBillboardchartstype;

    temptitle1: TA2Image;
    temptitle2: TA2Image; 
    temptitle3: TA2Image;

    procedure FDATAClear();
    procedure FDATAClear2();
    procedure fdataadd(aid: integer; aname: string; aEnergy, aprestige, anewTalent: integer; aGuildName: string);
    procedure fdataadd2(aid: integer; asysopname: string; aEnergy, acount: integer; aGuildName: string);
    function GETIndex2(aid: integer): pTBillboardGuildsData;
    function GETname2(aname: string): pTBillboardGuildsData;
    function GETIndex(aid: integer): pTBillboardchartsdata;
    function GETname(aname: string): pTBillboardchartsdata;

    procedure MessageProcess(var code: TWordComData);


   // procedure SetOldVersion;

    procedure SetNewVersion(); override;
   // procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;
    procedure SetTextPos(AControl: TControl);
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
  end;

var
  frmBillboardcharts: TfrmBillboardcharts;

implementation

uses FBottom, Fbl, FMain, filepgkclass, CharCls;

{$R *.dfm}

procedure TfrmBillboardcharts.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  id, akey, i, alen: integer;
  pp: TBillboardchartsdata;
  pp2:TBillboardGuildsData;
begin
  pckey := @Code.Data;
  case pckey^.rmsg of

    SM_BillboardGuilds:
    begin
      FSM_Command:=SM_BillboardGuilds;
        id := 1;
          alen := WordComData_GETdword(code, id);
             Findex := WordComData_GETdword(code, id);
                for i := 0 to alen - 1 do
        begin
          pp2.rid := WordComData_getdword(code, id);
          pp2.rSysopname := WordComData_getstring(code, id);
          pp2.rEnergy := WordComData_getdword(code, id);
          pp2.rcount := WordComData_getdword(code, id);

          pp2.rGuildName := WordComData_getstring(code, id);
          fdataadd2(pp2.rid, pp2.rSysopname, pp2.rEnergy, pp2.rcount , pp2.rGuildName);
        end;

    end;  
    SM_Billboardcharts:
      begin
        FSM_Command:=SM_Billboardcharts;
        id := 1;
        akey := WordComData_GETbyte(code, id);

        case akey of
          Billboardcharts_Energy:
            begin
              A2ILabelTitle.A2Image := temptitle2;
            end;
          Billboardcharts_Prestige:
            begin
              A2ILabelTitle.A2Image := temptitle1;
            end;
          Billboardcharts_newTalent:
            begin
              A2ILabelTitle.A2Image := temptitle3;
            end;
        end;
        alen := WordComData_GETdword(code, id);
        Findex := WordComData_GETdword(code, id);
        for i := 0 to alen - 1 do
        begin
          pp.rid := WordComData_getdword(code, id);
          pp.rname := WordComData_getstring(code, id);
          pp.rEnergy := WordComData_getdword(code, id);
          pp.rPrestige := WordComData_getdword(code, id);
          pp.rnewTalent := WordComData_getdword(code, id);
          pp.rGuildName := WordComData_getstring(code, id);
          fdataadd(pp.rid, pp.rname, pp.rEnergy, pp.rPrestige, pp.rnewTalent, pp.rGuildName);
        end;

      end;
  end;
end;

procedure TfrmBillboardcharts.fdataadd(aid: integer; aname: string; aEnergy, aprestige, anewTalent: integer; aGuildName: string);
var
  p: pTBillboardchartsdata;
begin
  if GETname(aname) <> nil then exit;
  new(p);
  p.rid := aid;
  p.rname := aname;
  p.rEnergy := aEnergy;
  p.rPrestige := aprestige;
  p.rnewTalent := anewTalent;
  p.rGuildName := aGuildName;

  fdata.Add(p);
  A2ListBox1.AddItem(' ');
  A2ListBox1.DrawItem;
end;

function TfrmBillboardcharts.GETIndex(aid: integer): pTBillboardchartsdata;
begin
  result := nil;
  if (aid < 0) or (aid > FDATA.Count - 1) then exit;
  result := fdata.Items[aid];
end;

function TfrmBillboardcharts.GETname(aname: string): pTBillboardchartsdata;
var
  i: integer;
  p: pTBillboardchartsdata;
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

procedure TfrmBillboardcharts.FDATAClear();
var
  i: integer;
  p: pTBillboardchartsdata;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    dispose(p);
  end;
  fdata.Clear;
  A2ListBox1.Clear;
  A2ListBox1.DrawItem;
end;

procedure TfrmBillboardcharts.SetNewVersion;
begin
  inherited;
end;

//procedure TfrmBillboardcharts.SetOldVersion;
//begin
//  temptitle1 := TA2Image.Create(32, 32, 0, 0);
//
//  pgkBmp.getBmp('Billboardcharts.bmp', A2form.FImageSurface);
//  A2form.boImagesurface := true;
//    // temptitle1.LoadFromFile('.\BillboardchartsPrestige.bmp');
//  pgkBmp.getBmp('BillboardchartsPrestige.bmp', temptitle1);
//  temptitle2 := TA2Image.Create(32, 32, 0, 0);
//    //temptitle2.LoadFromFile('.\Billboardchartsage.bmp');
//  pgkBmp.getBmp('Billboardchartsage.bmp', temptitle2);
//  A2ILabelTitle.A2Image := temptitle1;
//end;

procedure TfrmBillboardcharts.FormCreate(Sender: TObject);
var
  temp: TA2Image;
begin
  inherited;
  Findex := -1;
  fdata := tlist.Create;
  fdata2 := tlist.Create;
  FTestPos := True;
    //Parent := FrmM;
  Top := 30;
  Left := 30;

  FrmM.AddA2Form(Self, A2Form);

  if WinVerType = wvtNew then
  begin
    SetNewVersion;
//  end
//  else if WinVerType = wvtOld then
//  begin
//    SetOldVersion;
  end;


  temp := TA2Image.Create(A2ILabelfield.Width, A2ILabelfield.Height, 0, 0);
  try
      //年龄榜标题
    ATextOut(temp, 10 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '排名');
    ATextOut(temp, 70 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '昵称');
    ATextOut(temp, 160 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '门派');
    ATextOut(temp, 235 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '元气');
    ATextOut(temp, 294 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '天赋等级');

      //标题阴影
    ATextOut(temp, 10, 6, ColorSysToDxColor($003C9DFF), '排名');
    ATextOut(temp, 70, 6, ColorSysToDxColor($003C9DFF), '昵称');
    ATextOut(temp, 160, 6, ColorSysToDxColor($003C9DFF), '门派');
    ATextOut(temp, 235, 6, ColorSysToDxColor($003C9DFF), '元气');
    ATextOut(temp, 294, 6, ColorSysToDxColor($003C9DFF), '天赋等级');
    A2ILabelfield.A2Image := temp;
  finally
    temp.Free;
  end;

//  temp := TA2Image.Create(A2ILabelfield.Width, A2ILabelfield.Height, 0, 0);
//  try
//    if FTestPos then
//    begin
//      //标题
//      ATextOut(temp, FRankName1X, FRankName1Y, ColorSysToDxColor($000A0A0A), '排名');
//      ATextOut(temp, FRoleName1X, FRoleName1Y, ColorSysToDxColor($000A0A0A), '角色名字');
//      ATextOut(temp, FSex1X, FSex1Y, ColorSysToDxColor($000A0A0A), '性别');
//      ATextOut(temp, FYuanQi1X, FYuanQi1Y, ColorSysToDxColor($000A0A0A), '元气');
//      ATextOut(temp, FRongYu1X, FRongYu1Y, ColorSysToDxColor($000A0A0A), '荣誉');
//
//      //标题阴影
//
//      ATextOut(temp, FRankName2X, FRankName2Y, ColorSysToDxColor($003C9DFF), '排名');
//      ATextOut(temp, FRoleName2X, FRoleName2Y, ColorSysToDxColor($003C9DFF), '角色名字');
//      ATextOut(temp, FSex2X, FSex2Y, ColorSysToDxColor($003C9DFF), '性别');
//      ATextOut(temp, FYuanQi2X, FYuanQi2Y, ColorSysToDxColor($003C9DFF), '元气');
//      ATextOut(temp, FRongYu2X, FRongYu2Y, ColorSysToDxColor($003C9DFF), '荣誉');
//    end else
//    begin
//      ATextOut(temp, 0 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), '排名');
//      ATextOut(temp, 70 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), '角色名字');
//      ATextOut(temp, 170 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), '性别');
//      ATextOut(temp, 230 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), '元气');
//      ATextOut(temp, 300 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), '天赋等级');
//
//      ATextOut(temp, 0, 0, ColorSysToDxColor($003C9DFF), '排名');
//      ATextOut(temp, 70, 0, ColorSysToDxColor($003C9DFF), '角色名字');
//      ATextOut(temp, 170, 0, ColorSysToDxColor($003C9DFF), '性别');
//      ATextOut(temp, 230, 0, ColorSysToDxColor($003C9DFF), '元气');
//      ATextOut(temp, 300, 0, ColorSysToDxColor($003C9DFF), '天赋等级');
//    end;
//    A2ILabelfield.A2Image := temp;
//  finally
//    temp.Free;
//  end;

end;

procedure TfrmBillboardcharts.FormDestroy(Sender: TObject);
begin
  FDATAClear;
  fdata.Free;
  fdata2.Free;
  temptitle1.Free;
  temptitle2.Free;
  temptitle3.Free;
end;

procedure TfrmBillboardcharts.A2ButtonEnergyClick(Sender: TObject);  
var
  temp: TA2Image;
begin

  ftype := bctEnergy;
  Findex := -1;
  A2ButtonNEXTClick(nil);
end;

procedure TfrmBillboardcharts.A2ButtonPrestigeClick(Sender: TObject);
var
  temp: TA2Image;
begin
  //ftype := bctPrestige;
  ftype := bctnewTalent;
  Findex := -1;
  A2ButtonNEXTClick(nil);
end;

procedure TfrmBillboardcharts.A2ButtonNEXTClick(Sender: TObject);
var
  tempsend: TWordComData;
begin

  inc(Findex);
  if Findex < 0 then Findex := 0;
  FDATAClear;
  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, CM_Billboardcharts);
  case ftype of
    bctEnergy: WordComData_ADDbyte(tempsend, Billboardcharts_Energy);
    bctPrestige: WordComData_ADDbyte(tempsend, Billboardcharts_Prestige);
    bctnewTalent: WordComData_ADDbyte(tempsend, Billboardcharts_newTalent);

  end;
  WordComData_ADDdword(tempsend, Findex);
  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TfrmBillboardcharts.FormShow(Sender: TObject);
begin
  FDATAClear;
  ComboBoxChange(nil);
end;

procedure TfrmBillboardcharts.A2ListBox1AdxDrawItem(ASurface: TA2Image;
  index: Integer; aStr: string; Rect: TRect; State: TDrawItemState; fx,
  fy: Integer);
var
  P: pTBillboardchartsdata;
  p2: pTBillboardGuildsData;
  acolor: tcolor;
begin
  case FSM_Command of
    SM_Billboardcharts: begin
    updateTitle;
        P := GETIndex(index);
        if P = nil then EXIT;

  if WinVerType = wvtnew then
  begin
    acolor := $000FFFFF;
  end else if WinVerType = wvtold then
  begin
    acolor := $000A0A0A;
  end;
  if p.rname = CharCenterName then acolor := $00FFFF00;

        ATextOut(ASurface, 10, 2, ColorSysToDxColor(acolor), inttostr(p.rid));
        ATextOut(ASurface, 60, 2, ColorSysToDxColor(acolor), p.rname);
        ATextOut(ASurface, 150, 2, ColorSysToDxColor(acolor), p.rGuildName);
        ATextOut(ASurface, 230, 2, ColorSysToDxColor(acolor), Get10000To100(p.rEnergy));
        ATextOut(ASurface, 310, 2, ColorSysToDxColor(acolor), inttostr(p.rnewTalent));
      end;
    SM_BillboardGuilds:
      begin
      updateTitle;
        P2 := GETIndex2(index);
        if P2 = nil then EXIT;

        if WinVerType = wvtnew then
        begin
          acolor := $000FFFFF;
        end else if WinVerType = wvtold then
        begin
          acolor := $000A0A0A;
        end;
      //  if p.rname = CharCenterName then acolor := $00FFFF00;

        ATextOut(ASurface, 10, 2, ColorSysToDxColor(acolor), inttostr(p2.rid));
        ATextOut(ASurface, 60, 2, ColorSysToDxColor(acolor), p2.rGuildName);
        ATextOut(ASurface, 150, 2, ColorSysToDxColor(acolor), Get10000To100(p2.rEnergy));
        ATextOut(ASurface, 230, 2, ColorSysToDxColor(acolor),IntToStr(p2.rCount)  );
        ATextOut(ASurface, 280, 2, ColorSysToDxColor(acolor), p2.rSysopname);
      end;
  end;

end;

procedure TfrmBillboardcharts.A2Button2Click(Sender: TObject);
begin
  Visible := false;
end;

procedure TfrmBillboardcharts.A2Button3Click(Sender: TObject);
var
  tempsend: TWordComData;
begin

  if Findex = 0 then exit;
  dec(Findex);
  if Findex < 0 then Findex := 0;
  FDATAClear;
  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, CM_Billboardcharts);
  case ftype of
    bctEnergy: WordComData_ADDbyte(tempsend, Billboardcharts_Energy);
    bctPrestige: WordComData_ADDbyte(tempsend, Billboardcharts_Prestige);
    bctnewTalent: WordComData_ADDbyte(tempsend, Billboardcharts_newTalent);
  end;

  WordComData_ADDdword(tempsend, Findex);
  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TfrmBillboardcharts.ComboBoxChange(Sender: TObject);
begin
  if ComboBox.Text = '荣誉榜' then
  begin
    A2ButtonPrestigeClick(nil);
  end
  else if ComboBox.Text = '元气榜' then
  begin
    A2ButtonEnergyClick(nil);
  end;
end;

procedure TfrmBillboardcharts.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmBillboardcharts.SetConfigFileName;
begin
  FConfigFileName := 'BillboardChar.xml';
end;

//procedure TfrmBillboardcharts.SetNewVersionOld;
//var
//  temping: TA2Image;
//begin
//  temping := TA2Image.Create(32, 32, 0, 0);
//  try
//    pgkBmp.getBmp('排行榜窗口.bmp', A2Form.FImageSurface);
//    A2Form.boImagesurface := true;
//    Width := A2Form.FImageSurface.Width;
//    Height := a2form.FImageSurface.Height;
//
//    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
//    A2Button2.A2Up := temping;
//    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
//    A2Button2.A2Down := temping;
//    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
//    A2Button2.A2Mouse := temping;
//    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
//    A2Button2.A2NotEnabled := temping;
//    A2Button2.Left := 358;
//    A2Button2.Top := 25;
//
//    pgkBmp.getBmp('排行榜_元气榜_弹起.bmp', temping);
//    A2ButtonEnergy.A2Up := temping;
//    pgkBmp.getBmp('排行榜_元气榜_按下.bmp', temping);
//    A2ButtonEnergy.A2Down := temping;
//    pgkBmp.getBmp('排行榜_元气榜_鼠标.bmp', temping);
//    A2ButtonEnergy.A2Mouse := temping;
//    pgkBmp.getBmp('排行榜_元气榜_禁止.bmp', temping);
//    A2ButtonEnergy.A2NotEnabled := temping;
//    A2ButtonEnergy.Left := 24;
//    A2ButtonEnergy.Top := 59;
//    A2ButtonEnergy.Caption := '';
//    A2ButtonEnergy.ADXForm := A2Form;
//    A2ButtonEnergy.Visible := true;
//
//    pgkBmp.getBmp('排行榜_荣誉榜_弹起.bmp', temping);
//    A2ButtonPrestige.A2Up := temping;
//    pgkBmp.getBmp('排行榜_荣誉榜_按下.bmp', temping);
//    A2ButtonPrestige.A2Down := temping;
//    pgkBmp.getBmp('排行榜_荣誉榜_鼠标.bmp', temping);
//    A2ButtonPrestige.A2Mouse := temping;
//    pgkBmp.getBmp('排行榜_荣誉榜_禁止.bmp', temping);
//    A2ButtonPrestige.A2NotEnabled := temping;
//    A2ButtonPrestige.Left := 80;
//    A2ButtonPrestige.Top := 59;
//    A2ButtonPrestige.Caption := '';
//    A2ButtonPrestige.ADXForm := A2Form;
//    A2ButtonPrestige.Visible := true;
//
//        //353 219 353 201
//    A2ListBox1.Left := 25;
//    A2ListBox1.Top := 110; //140
//    A2ListBox1.Width := 360;
//    A2ListBox1.Height := 201;
//
//    A2ILabelfield.Left := 28;
//    A2ILabelfield.Top := 87;
//
//    ComboBox.Visible := false;
//
//    A2ListBox1.FFontSelBACKColor := ColorSysToDxColor($887766);
//        //A2ListBox1.FLayout := tlCenter;
//
//  finally
//    temping.Free;
//  end;
//
//end;

procedure TfrmBillboardcharts.SetNewVersionTest;

begin
  inherited;
  SetTextPos(Self);
  SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;

  SetControlPos(A2Button2);
  SetControlPos(A2ButtonEnergy);
  A2ButtonEnergy.Caption := '';
  A2ButtonEnergy.ADXForm := A2Form;
  A2ButtonEnergy.Visible := true;
  SetControlPos(A2ButtonPrestige);
  A2ButtonPrestige.Caption := '';
  A2ButtonPrestige.ADXForm := A2Form;
  A2ButtonPrestige.Visible := true;
  SetControlPos(A2ButtonGuild);
  A2ButtonGuild.Caption := '';
  A2ButtonGuild.ADXForm := A2Form;
  A2ButtonGuild.Visible := true;
  SetControlPos(A2ListBox1);
  SetControlPos(A2ILabelfield);
  SetControlPos(ComboBox);
  ComboBox.Visible := false;
  A2ListBox1.FFontSelBACKColor := ColorSysToDxColor($887766);
end;

procedure TfrmBillboardcharts.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TfrmBillboardcharts.SetTextPos(AControl: TControl);
var
  node: TXmlNode;
  width, height, left, top: Integer;
  visible: Boolean;
  A2Down, A2Mouse, A2NotEnabled, A2Up: string;
  SelectImage, SelectNotImage, EnabledImage: string;
  temping, temping2: TA2Image;
  path: string;
  A2Image: string;
  imgwidth, imgheight: Integer;
  transparent: Boolean;
begin

  try
    node := FUIConfig.Root.NodeByName('Views').FindNode('TextPos');
    if node <> nil then
    begin
      FRankName1X := node.ReadAttributeInteger('FRankName1X', 0);
      FRankName1Y := node.ReadAttributeInteger('FRankName1Y', 0);
      FRoleName1X := node.ReadAttributeInteger('FRoleName1X', 0);
      FRoleName1Y := node.ReadAttributeInteger('FRoleName1Y', 0);

      //ShowMessage(IntToStr(FRankName1X));

      FRankName2X := node.ReadAttributeInteger('FRankName2X', 0);

      FRankName2Y := node.ReadAttributeInteger('FRankName2Y', 0);

      FRoleName2X := node.ReadAttributeInteger('FRoleName2X', 0);

      FRoleName2Y := node.ReadAttributeInteger('FRoleName2Y', 0);
      FSex1X := node.ReadAttributeInteger('FSex1X', 0);
      FSex1Y := node.ReadAttributeInteger('FSex1Y', 0);
      FSex2X := node.ReadAttributeInteger('FSex2X', 0);
      FSex2Y := node.ReadAttributeInteger('FSex2Y', 0);


      FYuanQi1X := node.ReadAttributeInteger('FYuanQi1X', 0);
      FYuanQi1Y := node.ReadAttributeInteger('FYuanQi1Y', 0);
      FYuanQi2X := node.ReadAttributeInteger('FYuanQi2X', 0);
      FYuanQi2Y := node.ReadAttributeInteger('FYuanQi2Y', 0);
      FRongYu1X := node.ReadAttributeInteger('FRongYu1X', 0);
      FRongYu1Y := node.ReadAttributeInteger('FRongYu1Y', 0);
      FRongYu2X := node.ReadAttributeInteger('FRongYu2X', 0);
      FRongYu2Y := node.ReadAttributeInteger('FRongYu2Y', 0);

    end;
  except
  end;
end;

procedure TfrmBillboardcharts.updateTitle;
var
  temp: TA2Image;
begin
  case FSM_Command of
    SM_Billboardcharts:
      begin
        temp := TA2Image.Create(A2ILabelfield.Width, A2ILabelfield.Height, 0, 0);
        try
      //年龄榜标题
          ATextOut(temp, 10 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '排名');
          ATextOut(temp, 70 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '昵称');
          ATextOut(temp, 160 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '门派');
          ATextOut(temp, 235 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '元气');
          ATextOut(temp, 294 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '天赋等级');

      //标题阴影
          ATextOut(temp, 10, 6, ColorSysToDxColor($003C9DFF), '排名');
          ATextOut(temp, 70, 6, ColorSysToDxColor($003C9DFF), '昵称');
          ATextOut(temp, 160, 6, ColorSysToDxColor($003C9DFF), '门派');
          ATextOut(temp, 235, 6, ColorSysToDxColor($003C9DFF), '元气');
          ATextOut(temp, 294, 6, ColorSysToDxColor($003C9DFF), '天赋等级');
          A2ILabelfield.A2Image := temp;
        finally
          temp.Free;
        end;
      end;
    SM_BillboardGuilds:
      begin
        temp := TA2Image.Create(A2ILabelfield.Width, A2ILabelfield.Height, 0, 0);
        try

          ATextOut(temp, 10 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '排名');
          ATextOut(temp, 70 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '门派');
          ATextOut(temp, 160 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '战斗力');
          ATextOut(temp, 235 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '人数');
          ATextOut(temp, 294 + 1, 6 + 1, ColorSysToDxColor($000A0A0A), '门主');

      //标题阴影
          ATextOut(temp, 10, 6, ColorSysToDxColor($003C9DFF), '排名');
          ATextOut(temp, 70, 6, ColorSysToDxColor($003C9DFF), '门派');
          ATextOut(temp, 160, 6, ColorSysToDxColor($003C9DFF), '战斗力');
          ATextOut(temp, 235, 6, ColorSysToDxColor($003C9DFF), '人数');
          ATextOut(temp, 294, 6, ColorSysToDxColor($003C9DFF), '门主');
          A2ILabelfield.A2Image := temp;
        finally
          temp.Free;
        end;
      end;
  end;

end;

procedure TfrmBillboardcharts.A2ButtonGuildClick(Sender: TObject);
var
  tempsend: TWordComData;
begin
  Findex := -1;
  inc(Findex);
  if Findex < 0 then Findex := 0;
  FDATAClear2;
  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, CM_BillboardGuilds);

  WordComData_ADDdword(tempsend, Findex);
  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TfrmBillboardcharts.FDATAClear2;
var
  i: integer;
  p: pTBillboardGuildsData;
begin
  for i := 0 to fdata2.Count - 1 do
  begin
    p := fdata2.Items[i];
    dispose(p);
  end;
  fdata2.Clear;
  A2ListBox1.Clear;
  A2ListBox1.DrawItem;
end;

procedure TfrmBillboardcharts.fdataadd2(aid: integer; asysopname: string;
  aEnergy, acount: integer; aGuildName: string);
var
  p: pTBillboardGuildsData;
begin
  if GETname2(aGuildName) <> nil then exit;
  new(p);
  p.rid := aid;
  p.rSysopname := asysopname;
  p.rEnergy := aEnergy;
  p.rCount := acount;

  p.rGuildName := aGuildName;

  fdata2.Add(p);
  A2ListBox1.AddItem(' ');
  A2ListBox1.DrawItem;
end;

function TfrmBillboardcharts.GETIndex2(
  aid: integer): pTBillboardGuildsData;
begin
  result := nil;
  if (aid < 0) or (aid > FDATA2.Count - 1) then exit;
  result := fdata2.Items[aid];
end;

function TfrmBillboardcharts.GETname2(
  aname: string): pTBillboardGuildsData;
var
  i: integer;
  p: pTBillboardGuildsData;
begin
  result := nil;
  for i := 0 to fdata2.Count - 1 do
  begin
    p := fdata2.Items[i];
    if p.rGuildName = aname then
    begin
      result := p;
      exit;
    end;
  end;
end;

end.

