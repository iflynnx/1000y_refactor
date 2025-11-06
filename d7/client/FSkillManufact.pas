unit FSkillManufact;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, ExtCtrls, StdCtrls, StrDB, A2Img, AUtil32, DefType;

type
  TfrmSkillManufact = class(TForm)
    btnSelect: TA2Button;
    btnClose: TA2Button;
    lblJob: TA2Label;
    lblGrade: TA2Label;
    btnOrder0: TA2Button;
    btnGoods0: TA2Button;
    btnMan: TA2Button;
    btnWoman: TA2Button;
    lblMaterial0: TA2Label;
    lblMaterial1: TA2Label;
    lblMaterial2: TA2Label;
    lblMaterial3: TA2Label;
    A2Form: TA2Form;
    btnRun: TA2Button;
    btnGoods1: TA2Button;
    btnGoods2: TA2Button;
    btnGoods3: TA2Button;
    btnGoods4: TA2Button;
    btnGoods5: TA2Button;
    btnGoods6: TA2Button;
    btnGoods7: TA2Button;
    btnGoods8: TA2Button;
    btnGoods9: TA2Button;
    btnOrder1: TA2Button;
    btnOrder2: TA2Button;
    btnOrder3: TA2Button;
    imgOrderUp: TImage;
    imgManUp: TImage;
    imgWomanUp: TImage;
    imgGoodsUp: TImage;
    imgGoodsDisable: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2FormAdxPaint(aAnsImage: TA2Image);
    procedure btnOrderClick(Sender: TObject);
    procedure btnGoods0Click(Sender: TObject);
    procedure btnGenderClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
  private
    btnOrder: array[0..3] of TA2Button;
    strOrder: array[0..3] of string;
    btnGoods: array[0..9] of TA2Button;
    strGoods: array[0..9] of string;
    lblMaterial: array[0..3] of TA2Label;

    MakeSDB: TStringDb;
    iSelectOrder: integer;
    iSelectGoods: integer;
    iSelectSex: integer;

    strJobKind: string;
    iLimitLevel: integer;

    function isNeedSex(const strJob: string; iOrder: integer): Boolean;
  public
    procedure ShowList(const strJob, strGrade: string);
    procedure SelectOrder(NewOrder: integer);
    procedure SelectGoods(NewGoods: integer);
    procedure SelectSex(NewGender: integer);
  end;

var
  frmSkillManufact: TfrmSkillManufact;

implementation

uses FMain, FLogon, FSkill, FAttrib, FHistory;

const
   ManufactInfoFile: string = 'ect\manufacture.atd';
{$R *.dfm}

procedure TfrmSkillManufact.FormCreate(Sender: TObject);
var
   i: integer;
begin
   FrmM.AddA2Form(self, A2Form);
   Left := 10;
   Top := 10;
   Visible := False;

   MakeSDB := TStringDb.Create;

   MakeSDB.LoadFromFileCode('ect\manufacture.atd');

   for i := 0 to 3 do begin
      btnOrder[i] := TA2Button(FindComponent('btnOrder' + IntToStr(i)));
      strOrder[i] := '';
   end;

   for i := 0 to 9 do begin
      btnGoods[i] := TA2Button(FindComponent('btnGoods' + IntToStr(i)));
      strGoods[i] := '';
   end;

   for i := 0 to 3 do begin
      lblMaterial[i] := TA2Label(FindComponent('lblMaterial' + IntToStr(i)));
   end;

   iSelectOrder := 0;
   iSelectGoods := 0;
   iSelectSex := 0;
end;

procedure TfrmSkillManufact.btnCloseClick(Sender: TObject);
begin
   Visible := False;
end;

procedure TfrmSkillManufact.FormDestroy(Sender: TObject);
begin
   MakeSDB.Free;
end;

function GetLimitGrade(const strGrade: string): integer;
begin
   if strGrade = Conv('神工') then Result := 1
   else if strGrade = Conv('名人') then Result := 2
   else if strGrade = Conv('达人') then Result := 3
   else if strGrade = Conv('熟练工') then Result := 5
   else if strGrade = Conv('技能工') then Result := 7
   else if strGrade = Conv('初级工') then Result := 9
   else Result := 11;
end;

procedure TfrmSkillManufact.ShowList(const strJob, strGrade: string);
begin
   strJobKind := strJob;
   iLimitLevel := GetLimitGrade(strGrade);

   lblJob.Caption := strJobKind;
   lblGrade.Caption := strGrade;

   if strJob = Conv('铸造师') then begin
      strOrder[0] := Conv('剑');     strOrder[1] := Conv('刀');
      strOrder[2] := Conv('枪');     strOrder[3] := Conv('槌');

      btnOrder2.Visible := True;
      btnOrder3.Visible := True;
   end else
   if strJob = Conv('裁缝') then begin
      strOrder[0] := Conv('弓服');   strOrder[1] := Conv('铠甲');
      strOrder[2] := '';             strOrder[3] := '';

      btnOrder2.Visible := False;
      btnOrder3.Visible := False;
   end else
   if strJob = Conv('工匠') then begin
      strOrder[0] := Conv('头盔');   strOrder[1] := Conv('护腕');
      strOrder[2] := Conv('靴子');   strOrder[3] := Conv('手套');

      btnOrder2.Visible := True;
      btnOrder3.Visible := True;
   end else
   if strJob = Conv('炼丹师') then begin
      strOrder[0] := Conv('技术药'); strOrder[1] := Conv('加工药');
      strOrder[2] := '';             strOrder[3] := '';

      btnOrder2.Visible := False;
      btnOrder3.Visible := False;
   end else begin
      exit;
   end;

   btnRun.Visible := False;
   SelectOrder(0);
   SelectGoods(-1);
   frmM.ShowA2Form(Self);
end;

procedure TfrmSkillManufact.SelectOrder(NewOrder: integer);
var
   i, index: integer;
   strIndex: string;
begin
   if (NewOrder < 0) or (NewOrder > 3) or
      (strOrder[NewOrder] = '') then exit;

   iSelectOrder := NewOrder;
   SelectGoods(-1);
   
   index := 0;
   for i := 0 to MakeSDB.Count do begin
      strIndex := MakeSDB.GetIndexName(i);
      if strJobKind <> MakeSDB.GetFieldValueString(strIndex, 'Job') then continue;
      if strOrder[NewOrder] <> MakeSDB.GetFieldValueString(strIndex, 'Order') then continue;
      if Conv('女') = MakeSDB.GetFieldValueString(strIndex, 'Sex') then continue;

      strGoods[index] := MakeSDB.GetFieldValueString(strIndex, 'ViewName');

      if iLimitLevel > MakeSDB.GetFieldValueInteger(strIndex, 'Grade') then begin
         btnGoods[index].UpImage := imgGoodsDisable.Picture;
         btnGoods[index].Enabled := False;
      end else begin
         btnGoods[index].UpImage := imgGoodsUp.Picture;
         btnGoods[index].Enabled := True;
      end;

      inc(index);
      if index >= 10 then break;
   end;

   if index < 10 then begin
      for i := index to 9 do begin
         strGoods[i] := '';
         btnGoods[i].UpImage := imgGoodsDisable.Picture;
         btnGoods[i].Enabled := False;
      end;
   end;

   if isNeedSex(strJobKind, NewOrder) then begin
      btnMan.Visible := True; btnWoman.Visible := True;
   end else begin
      btnMan.Visible := False; btnWoman.Visible := False;
   end;
end;

function TfrmSkillManufact.isNeedSex(const strJob: string; iOrder: integer): Boolean;
begin
   Result := (strJob = conv('裁缝')) or
             ((strJob = Conv('工匠')) and (iOrder < 3));
end;

procedure TfrmSkillManufact.SelectGoods(NewGoods: integer);
var
   str, str2, strGoodsName: string;
   i: integer;
begin
   iSelectGoods := NewGoods;

   if iSelectGoods < 0 then begin
      for i := 0 to 3 do begin
         lblMaterial[i].Caption := '';
      end;
      exit;
   end;

   strGoodsName := strGoods[iSelectGoods];

   if isNeedSex(strJobKind, iSelectOrder) then begin
      if iSelectSex = 0 then
         strGoodsName := Conv('男子') + strGoodsName
      else
         strGoodsName := Conv('女子') + strGoodsName;
   end;

   for i := 0 to 3 do begin
      str := MakeSDB.GetFieldValueString(strGoodsName, 'Material' + IntToStr(i+1));
      if str = '' then begin
         lblMaterial[i].Caption := '';
      end else begin
         str2 := GetValidStr4(str, ':');
         lblMaterial[i].Caption := str2 + ' ' + str + Conv('个');
      end;
   end;
end;

procedure TfrmSkillManufact.SelectSex(NewGender: integer);
begin
   iSelectSex := NewGender;

   if iSelectSex = 0 then begin
      btnMan.UpImage := btnMan.DownImage;
      btnWoman.UpImage := imgWomanUp.Picture;
   end else begin
      btnWoman.UpImage := btnWoman.DownImage;
      btnMan.UpImage := imgManUp.Picture;
   end;

   SelectGoods(iSelectGoods);
end;

procedure TfrmSkillManufact.A2FormAdxPaint(aAnsImage: TA2Image);
var
   i: integer;
   FontColor: Word;
   xx, yy, TextWidth: integer;
begin
   for i := 0 to 3 do begin
      if btnOrder[i].Visible then begin
         if iSelectOrder = i then FontColor := WinRGB(31,31,0)
                             else FontColor := WinRGB(31,31,31);

         TextWidth := ATextWidth(strOrder[i]);
         xx := btnOrder[i].Left + (btnOrder[i].Width - TextWidth) div 2;
         yy := btnOrder[i].Top + (btnOrder[i].Height - 12) div 2;

         ATextOut(aAnsImage, xx+1, yy+1, WinRGB(1,1,1), strOrder[i]);
         ATextOut(aAnsImage, xx, yy, FontColor, strOrder[i]);
      end;
   end;

   for i := 0 to 9 do begin
      if strGoods[i] <> '' then begin
         if iSelectGoods = i then FontColor := WinRGB(31,31,0)
                             else FontColor := WinRGB(31,31,31);

         TextWidth := ATextWidth(strGoods[i]);
         xx := btnGoods[i].Left + (btnGoods[i].Width - TextWidth) div 2;
         yy := btnGoods[i].Top + (btnGoods[i].Height - 12) div 2;

         ATextOut(aAnsImage, xx+1, yy+1, WinRGB(1,1,1), strGoods[i]);
         ATextOut(aAnsImage, xx, yy, FontColor, strGoods[i]);
      end;
   end;
end;

procedure TfrmSkillManufact.btnOrderClick(Sender: TObject);
begin
   SelectOrder(TComponent(Sender).Tag);
end;

procedure TfrmSkillManufact.btnGoods0Click(Sender: TObject);
begin
   SelectGoods(TComponent(Sender).Tag);
end;

procedure TfrmSkillManufact.btnGenderClick(Sender: TObject);
begin
   SelectSex(TComponent(Sender).Tag);
end;

procedure TfrmSkillManufact.btnSelectClick(Sender: TObject);
var
   strGoodsName, str: string;
   strNeedItem: string;
   iNeedCount, index, i: integer;
   CanAllow: Boolean;
   cSetMaterial: TCSetMaterial;
begin
   // 急琶阑 窍看绰瘤...
   if iSelectGoods < 0 then begin
      ChatMan.AddChat(Conv('请选择制造物品'), WinRGB(24, 24, 0), 0);
      exit;
   end;

   // 犁丰沫捞 厚菌绰瘤...
   if not frmSkill.isNullMat then begin
      ChatMan.AddChat(Conv('请空出技术窗栏位'), WinRGB(24, 24, 0), 0);
      exit;
   end;

   strGoodsName := strGoods[iSelectGoods];

   if isNeedSex(strJobKind, iSelectOrder) then begin
      if iSelectSex = 0 then
         strGoodsName := Conv('男子') + strGoodsName
      else
         strGoodsName := Conv('女子') + strGoodsName;
   end;

   FillChar(cSetMaterial, sizeof(TCSetMaterial), 0);
   cSetMaterial.rMsg := CM_SETMATERIAL;

   CanAllow := True;
   for i := 0 to 3 do begin
      str := MakeSDB.GetFieldValueString(strGoodsName, 'Material' + IntToStr(i+1));
      str := GetValidStr3(str, strNeedItem, ':');
      iNeedCount := _StrToInt(str);
      if (iNeedCount < 1) or (strNeedItem = '') then break;

      index := frmAttrib.HaveSomeItem(strNeedItem, iNeedCount);
      if index < 0 then begin
         CanAllow := False;
         break;
      end else begin
         cSetMaterial.rIdx[i]   := index;
         cSetMaterial.rCount[i] := iNeedCount;
      end;
   end;

   if CanAllow then begin
//      Connector.SendData(@cSetMaterial, sizeof(TCSetMaterial));
      frmLogon.SocketAddData(sizeof(TCSetMaterial), @cSetMaterial);
      btnRun.Visible := True;
   end else begin
      ChatMan.AddChat(Conv('材料不足'), WinRGB(24, 24, 0), 0);
   end;
end;

procedure TfrmSkillManufact.btnRunClick(Sender: TObject);
begin
   frmSkill.btnMake.OnClick(Sender);
   btnRun.Visible := False;
end;

end.
