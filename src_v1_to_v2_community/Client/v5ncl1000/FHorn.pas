unit FHorn;         //2015.12.02 在水一方

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, A2Form, A2View, ExtCtrls, deftype, AUtil32, BaseUIForm, A2Img, CharCls;

type
  TFrmHorn = class(TfrmBaseUI)
    BtnOK: TA2Button;
    EdCount1_old: TA2Edit;
    EdCount2_old: TA2Edit;
    EdCount3_old: TA2Edit;
    A2Form: TA2Form;
    A2CheckBox_Low: TA2CheckBox;
    A2CheckBox_Mid: TA2CheckBox;
    A2CheckBox_High: TA2CheckBox;
    BtnClose: TA2Button;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Clear;
    procedure FormShow(Sender: TObject);
    procedure EdCount1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdCount1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnCloseClick(Sender: TObject);
    procedure A2CheckBox_HornClick(Sender: TObject);
  private
    itemtag: integer;
    EdCount1: TA2ChatEdit;
    EdCount2: TA2ChatEdit;
    EdCount3: TA2ChatEdit; 
    FMSGItemName:string;
  public
    FSelectedChatItemData: TItemData;
    FSelectedChatItemPos: integer;
    FCurEdChatText: string;
    procedure MessageProcess(var code: TWordComData);
    //procedure SetOldVersion;
    procedure SetNewVersion(); override;
 //   procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure SetChatInfo;
  end;

var
  FrmHorn: TFrmHorn;

implementation

uses
  FMain, FBottom, FAttrib;

{$R *.DFM}

procedure TFrmHorn.SetNewVersion;
begin
  inherited;
end;

//procedure TFrmHorn.SetOldVersion;
//begin
//end;

procedure TFrmHorn.FormCreate(Sender: TObject);
begin
  itemtag := -1;
  FAllowCache := True;
  
  EdCount1 := TA2ChatEdit.Create(self);
  EdCount1.Parent := self;
  EdCount1.Width := 20;
  EdCount1.Height := 20;
  EdCount1.ADXForm := self.A2form;
  EdCount1.Name := 'EdCount1';
  EdCount1.Text := '';
  EdCount1.MaxLength := 100;
  EdCount1.AutoSize := false;
  EdCount1.OnKeyDown := self.EdCount1KeyDown;
  EdCount1.OnKeyUp := self.EdCount1KeyUp;
  
  EdCount2 := TA2ChatEdit.Create(self);
  EdCount2.Parent := self;
  EdCount2.Width := 20;
  EdCount2.Height := 20;
  EdCount2.ADXForm := self.A2form;
  EdCount2.Name := 'EdCount2';
  EdCount2.Text := '';
  EdCount2.MaxLength := 100;
  EdCount2.AutoSize := false;
  EdCount2.OnKeyDown := self.EdCount1KeyDown;
  EdCount2.OnKeyUp := self.EdCount1KeyUp;
  
  EdCount3 := TA2ChatEdit.Create(self);
  EdCount3.Parent := self;
  EdCount3.Width := 20;
  EdCount3.Height := 20;
  EdCount3.ADXForm := self.A2form;
  EdCount3.Name := 'EdCount3';
  EdCount3.Text := '';
  EdCount3.MaxLength := 100;
  EdCount3.AutoSize := false;
  EdCount3.OnKeyDown := self.EdCount1KeyDown;
  EdCount3.OnKeyUp := self.EdCount1KeyUp;
  
  Self.ActiveControl := EdCount1;
  inherited;
  FTestPos := True;
  A2Form.FImageSurface.Name := 'FImageSurface';   //2015.11.10 在水一方>
  FrmM.AddA2Form(Self, A2form);
//  Parent := FrmM;
  if WinVerType = wvtnew then
  begin
    SetNewVersion;
//  end
//  else
//  begin
//    SetOldVersion;
  end;
end;

procedure TFrmHorn.FormDestroy(Sender: TObject);
begin
  EdCount1.Free;
  EdCount2.Free;
  EdCount3.Free;
end;

procedure TFrmHorn.Clear;
begin
  EdCount1.Text := '';
  EdCount2.Text := '';
  EdCount3.Text := '';
end;

procedure TFrmHorn.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  psCount: PTSCount;
  CSelectCount: TCSelectCount;
  tt, ttgod: pTSHaveItem;
  t2PTSNPCItem: PTSNPCItem;
begin
  pckey := @Code.data;

end;

procedure TFrmHorn.BtnOKClick(Sender: TObject);
var
  str,ds,itemname: string;
  itemid: Integer;
  aSayItem: TCSayItem;
begin
  //if HaveItemclass.getnameid('')
  case itemtag of
  0:itemname := '低级喇叭';
  1:itemname := '中级喇叭';
  2:itemname := '高级喇叭';
  else
  itemname := '选择喇叭';
  end;
  itemid := HaveItemclass.getnameid(itemname);
  if itemid = -1 then begin
    FrmBottom.AddChat(format('你还没有%s', [itemname]),WinRGB(22, 22, 0), 0);
    Exit;
  end;

  ds := '';
  if Trim(EdCount1.Text) <> '' then
    str := Trim(EdCount1.Text);
  //if str <> '' then ds := #13 else ds := '';
  if Trim(EdCount2.Text) <> '' then
    str := str + ds + Trim(EdCount2.Text);
  //if str <> '' then ds := #13 else ds := '';
  if Trim(EdCount3.Text) <> '' then
    str := str + ds + Trim(EdCount3.Text);
  str := Trim(str);

  if str <> '' then begin
    if EdCount1.HaveChatItem then begin
      aSayItem.rmsg := CM_SAYITEM;
      aSayItem.rtype := 2;

      aSayItem.rpos := FSelectedChatItemPos;
      copymemory(@aSayItem.rChatItemData, @self.FSelectedChatItemData, sizeof(TItemData));

      SetWordString(aSayItem.rWordString, str);

      FrmAttrib.sendDblClickItemStringEx(itemid, STR, aSayItem);
    end
    else
      FrmAttrib.sendDblClickItemString(itemid, str);
  end;
  //Visible := False;
end;

procedure TFrmHorn.FormShow(Sender: TObject);
begin
  EdCount1.SetFocus;
end;

procedure TFrmHorn.EdCount1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: Integer;
begin
  Exit;
  if key = VK_ESCAPE then
  begin
    Exit;
  end;

  if (key = 13) or (key = 40) then
  begin
    if Visible then
    begin
      case TA2Edit(Sender).Tag of
      0: EdCount2.SetFocus;
      1: EdCount3.SetFocus;
      2: ;
      end;
    end;
    Exit;
  end;
  if KEY = 38 then
  begin
    if Visible then
    begin
      case TA2Edit(Sender).Tag of
      0: ;
      1: EdCount1.SetFocus;
      2: EdCount2.SetFocus;
      end;
    end;
    Exit;
  end;
end; 

procedure TFrmHorn.EdCount1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  I: Integer;
begin
  Exit;
  if (ATextWidth(TA2Edit(Sender).Text) > TA2Edit(Sender).Width-40) then
  begin
    if Visible and not(Key in [8,13,10,37,38,39,40,46]) then
    begin
      case TA2Edit(Sender).Tag of
      0: EdCount2.SetFocus;
      1: EdCount3.SetFocus;
      2: begin
           i := TA2Edit(Sender).SelStart;
           TA2Edit(Sender).Text := copy(TA2Edit(Sender).Text,1,Length(TA2Edit(Sender).Text)-1);
           TA2Edit(Sender).SelStart := i;
         end;
      end;
    end;
    Exit;
  end;
end;

procedure TFrmHorn.SetConfigFileName;
begin
  FConfigFileName := 'Horn.xml';

end;

//procedure TFrmHorn.SetNewVersionOld;
//begin
////
//end;

procedure TFrmHorn.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  SetControlPos(BtnOK);

  SetControlPos(BtnClose);
  SetControlPos(EdCount1);
  SetControlPos(EdCount2);
  SetControlPos(EdCount3);
  SetControlPos(A2CheckBox_Low);
  SetControlPos(A2CheckBox_Mid);
  SetControlPos(A2CheckBox_High);
  FrmM.SetA2Form(Self, A2form);

end;

procedure TFrmHorn.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;
end;

procedure TFrmHorn.BtnCloseClick(Sender: TObject);
begin
  inherited;
  Visible := False;
end;

procedure TFrmHorn.A2CheckBox_HornClick(Sender: TObject);
begin
  inherited;
  case TA2CheckBox(Sender).Tag of
  0:begin
    A2CheckBox_Low.Checked := True;
    A2CheckBox_Mid.Checked := False;
    A2CheckBox_High.Checked := False;
    end;
  1:begin
    A2CheckBox_Low.Checked := False;
    A2CheckBox_Mid.Checked := True;
    A2CheckBox_High.Checked := False;
    end;
  2:begin
    A2CheckBox_Low.Checked := False;
    A2CheckBox_Mid.Checked := False;
    A2CheckBox_High.Checked := True;
    end;
  end;
  itemtag := TA2CheckBox(Sender).Tag;
end;

procedure TFrmHorn.SetChatInfo;
var
  k: word;
begin
  if (self.FSelectedChatItemData.rViewName = '') then
  begin
    EdCount1.HaveChatItem := false;

  end
  else
  begin
    EdCount1.ChatItemName := self.FSelectedChatItemData.rViewName;
    EdCount1.HaveChatItem := true;
    FCurEdChatText := self.EdCount1.Text;
    begin
      //if EdCount1.SelectedChatItemPos = -1 then
        EdCount1.SelectedChatItemPos := self.EdCount1.SelStart + self.EdCount1.SelLength + 1;
      //self.FSelectedChatItemPos := length(self.EdCount1.Text) + 1 - length(FCurEdChatText);
      self.FSelectedChatItemPos := EdCount1.SelectedChatItemPos + Length(format('[%s]:', [CharCenterName])) - 1;
    end;
   // sendsayitem(EdChat.Text, k);
  end;
end;

end.

