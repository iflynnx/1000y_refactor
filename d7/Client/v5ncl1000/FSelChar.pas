unit FSelChar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, log, autil32, deftype, A2Form, A2Img, Atzcls, uAnsTick, Charcls, BaseUIForm,NativeXml;

type
  TFrmSelChar = class(TfrmBaseUI)
    A2Form: TA2Form;
    EditChar: TA2Edit;
    EditPassWord: TA2Edit;
    EditConfirm: TA2Edit;
    Pninfo: TA2Label;
    BtnChangePass: TA2Button;
    BtnSelect: TA2Button;
    BtnDelete: TA2Button;
    BtnCreateChar: TA2Button;
    LbSex: TA2Label;
    BtnWaMan: TA2Button;
    BtnMan: TA2Button;
    CBVillage: TA2ComboBox;
    ListBox1: TA2ListBox;
    A2ButtonCHANGECharName: TA2Button;
    A2ButtonCHANGECharNameON: TA2Button;
    A2Edit_OldName: TA2Edit;
    A2Edit_NewName: TA2Edit;
    A2ButtonCHANGECharNameOff: TA2Button;
    A2ILabel1: TA2ILabel;
    LbChar1: TA2ILabel;
    LbChar2: TA2ILabel;
    LbChar3: TA2ILabel;
    LbChar4: TA2ILabel;
    LbChar5: TA2ILabel;
    CharSelect: TA2ILabel;
    A2Edit1: TA2Edit;
    A2Panel1: TA2Panel;
    BackImgB1: TA2ILabel;
    A2ButtonCreateChar: TA2Button;
    A2ButtonCancel: TA2Button;
    A2PnInfo: TA2Label;
    A2CheckBox_Woman: TA2CheckBox;
    A2CheckBox_Man: TA2CheckBox;
    A2ButtonCloseCP: TA2Button;
    A2EditChar: TA2Edit;
    A2Panel2: TA2Panel;
    BackImgB2: TA2ILabel;
    A2ButtonDelOK: TA2Button;
    A2ButtonDelCancel: TA2Button;
    Pninfo2: TA2Label;
    A2ButtonCloseDP: TA2Button;
    A2LabelCharName0: TA2Label;
    A2LabelCharName1: TA2Label;
    A2LabelCharName2: TA2Label;
    A2LabelCharName3: TA2Label;
    A2LabelCharName4: TA2Label;
    CreateCharImgA2lbl: TA2ILabel;
    charImgLeftBtn: TA2Button;
    charImgRigthBtn: TA2Button;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure BtnChangePassClick(Sender: TObject);
    procedure BtnSelectClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnCreateCharClick(Sender: TObject);
    procedure EditPassWordKeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1DblClick(Sender: TObject);

    procedure FormHide(Sender: TObject);
    procedure BtnRealClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnWaManClick(Sender: TObject);
    procedure BtnManClick(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure A2ButtonCHANGECharNameClick(Sender: TObject);
    procedure A2ButtonCHANGECharNameONClick(Sender: TObject);
    procedure A2ButtonCHANGECharNameOffClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LbChar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LbChar2DblClick(Sender: TObject);
    procedure A2ButtonCreateCharClick(Sender: TObject);
    procedure A2ButtonCloseDPClick(Sender: TObject);
    procedure A2ButtonCloseCPClick(Sender: TObject);
    procedure A2CheckBox_ManClick(Sender: TObject);
    procedure A2CheckBox_WomanClick(Sender: TObject);
    procedure charImgRigthBtnClick(Sender: TObject);
    procedure charImgLeftBtnClick(Sender: TObject);
  private
    CharCenterImage: TA2Image;

    Feature: TFeature;
    FSelectIndex: Integer;
    CharImageArray: array[0..4] of TA2Image;
    CharImage1: TA2Image;
    CharImage2: TA2Image;
    CharImage3: TA2Image;
    CharImage4: TA2Image;
    CharImage5: TA2Image;
    FCurCharImageIndex: Integer;
    FWomanFeature: TFeature;
    FManFeature: TFeature;
    FCurCharImage: TA2Image;
    FSelectLeftSub:Integer;
    FSelectTopSub:Integer;
  public
    Labels: array[0..4] of TA2Label;
    boCommandHide: Boolean;
    procedure MyHide;
    procedure MyShow;
        { Public declarations }
    procedure SetFormText;

    procedure SetNewVersion; override;
    //procedure SetOldVersion;




    //procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;


    function GetArrImageLib(aindex, CurTick: integer; aFeature: tFeature): TA2ImageLib;
    procedure DrawFeatureItem;
    procedure NewCreateCharClick(Sender: TObject);
    procedure NewDeleteClick(Sender: TObject);
    procedure DrawCreateCharFeature(bIsMan: Boolean; AIndex: Integer);
    function changeIndex(AIndex:Integer):Integer;
    procedure SetOtherConfig();
  end;

var
  FrmSelChar: TFrmSelChar;

implementation

uses Fbl, FMain, FUpDateID, filepgkclass, FGameToolsAssist;

{$R *.DFM}

procedure TFrmSelChar.SetFormText;
begin
  Caption := (fname + '[选择角色]   ');
  Pninfo.Caption := ('没有人物的玩家，请按【制造人物】建立');
end;

procedure TFrmSelChar.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = char(VK_ESCAPE)) or (key = char(VK_RETURN)) then key := char(0);
end;

procedure TFrmSelChar.BtnChangePassClick(Sender: TObject);
var
  ccp: TCChangePassWord;
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  if Length(EditPassWord.Text) < 4 then
  begin
    Pninfo.Caption := ('密码必须4个字以上.');
    EditPassWord.SetFocus;
    exit;
  end;
  if not isEngNumeric(EditPassWord.Text) then
  begin
    Pninfo.Caption := ('只能使用英文字母与阿拉伯数字.');
    EditPassWord.SetFocus;
    exit;
  end;
  if EditPassWord.Text <> EditConfirm.Text then
  begin
    Pninfo.Caption := ('密码与确认密码不同.');
    EditConfirm.SetFocus;
    exit;
  end;

  ccp.rmsg := CM_CHANGEPASSWORD;
  ccp.rNewPass := EditPassWord.Text;

  Frmfbl.SocketAddData(sizeof(ccp), @ccp);
end;

procedure TFrmSelChar.BtnDeleteClick(Sender: TObject);
var
  ret: integer;
  buffer: array[0..64] of byte;
  cdc: TCDeleteChar;
  str, uCharName, uServerName: string;
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  if listbox1.Items[Listbox1.Itemindex] = '' then
  begin
    exit;
  end;

  str := listbox1.Items[Listbox1.Itemindex];
  str := GetValidStr3(str, uCharName, ':');
  str := GetValidStr3(str, uServerName, ':');
  if uCharName = '' then exit;
  if uServerName = '' then exit;

  _StrPCopy(@Buffer, uCharName + ' ' + ('确定要删除该角色.'));
  ret := Application.MessageBox(@Buffer, Pchar(('删除角色')), 1);
  if ret <> 1 then exit;

  cdc.rmsg := CM_DELETECHAR;
  cdc.rchar := Copy(uCharName, 1, 20);
  cdc.rServer := Copy(uServerName, 1, 20);
  Frmfbl.SocketAddData(sizeof(cdc), @cdc);
end;

procedure TFrmSelChar.BtnCreateCharClick(Sender: TObject);
var
  ccc: TCCreateChar;
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  if Length(EditChar.Text) < 2 then
  begin
    Pninfo.Caption := ('人物名称 输入2个字以上');
    EditChar.SetFocus;
    exit;
  end;
  if Pos(',', EditChar.Text) > 0 then
  begin
    Pninfo.Caption := ('不可使用特殊符号');
    EditChar.SetFocus;
    exit;
  end;
  if Pos(',', CBVillage.text) > 0 then
  begin
    Pninfo.Caption := ('不可使用特殊符号');
    CBVillage.SetFocus;
    exit;
  end;

  ccc.rmsg := CM_CREATECHAR;
  ccc.rchar := EditChar.Text;

  if LbSex.Caption = ('男') then ccc.rsex := 0
  else ccc.rsex := 1;

  ccc.rVillage := CBVillage.Text;
  ccc.rServer := '';

  Frmfbl.SocketAddData(sizeof(ccc), @ccc);
end;


procedure TFrmSelChar.EditPassWordKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = char(VK_ESCAPE)) or (key = char(VK_RETURN)) then key := char(0);
end;

procedure TFrmSelChar.ListBox1DblClick(Sender: TObject);
begin
  BtnSelectClick(Sender);

end;

procedure TFrmSelChar.FormHide(Sender: TObject);
begin
  if boCommandHide = FALSE then FrmM.Close;
end;

procedure TFrmSelChar.MyHide;
begin
  boCommandHide := TRUE;
  Visible := FALSE;
  boCommandHide := FALSE;
  FrmGameToolsAssist.loadFromfile(ReConnectChar);
end;

procedure TFrmSelChar.MyShow;
var
  csc: TCSelectChar;
begin
  boCommandHide := FALSE;
  Visible := TRUE;
  if ReConnectChar <> '' then
  begin
    csc.rmsg := CM_SELECTCHAR;
    csc.rchar := ReConnectChar;
    csc.rServer := ReConnectServer;
    Frmfbl.SocketAddData(sizeof(csc), @csc);

    //ReConnectChar := '';
  end;

 // ListBox1.SetFocus;
end;

procedure TFrmSelChar.BtnRealClick(Sender: TObject);
begin
  FrmUpDateId.ShowModal;
end;

//procedure TFrmSelChar.SetOldVersion;
//var
//  outimg: TA2Image;
//begin
//  pgkBmp.getBmp('selectchar.bmp', A2form.FImageSurface);
//  outimg := TA2Image.Create(32, 32, 0, 0);
//
//  try
//    pgkBmp.getBmp('男按钮down.bmp', outimg);
//    BtnMan.A2Down := outimg;
//    pgkBmp.getBmp('男按钮UP.bmp', outimg);
//    BtnMan.A2Up := outimg;
//
//    pgkBmp.getBmp('女按钮down.bmp', outimg);
//    BtnWaMan.A2Down := outimg;
//    pgkBmp.getBmp('女按钮UP.bmp', outimg);
//    BtnWaMan.A2Up := outimg;
//
//    pgkBmp.getBmp('删除按钮down.bmp', outimg);
//    BtnDelete.A2Down := outimg;
//    pgkBmp.getBmp('删除按钮UP.bmp', outimg);
//    BtnDelete.A2Up := outimg;
//
//    pgkBmp.getBmp('选择按钮down.bmp', outimg);
//    BtnSelect.A2Down := outimg;
//    pgkBmp.getBmp('选择按钮UP.bmp', outimg);
//    BtnSelect.A2Up := outimg;
//
//    pgkBmp.getBmp('修改密码DOWN.bmp', outimg);
//    BtnChangePass.A2Down := outimg;
//    pgkBmp.getBmp('修改密码UP.bmp', outimg);
//    BtnChangePass.A2Up := outimg;
//
//    pgkBmp.getBmp('制造按钮down.bmp', outimg);
//    BtnCreateChar.A2Down := outimg;
//    pgkBmp.getBmp('制造按钮UP.bmp', outimg);
//    BtnCreateChar.A2Up := outimg;
//  finally
//    outimg.Free;
//  end;
//
//  A2form.boImagesurface := true;
//
//end;

procedure TFrmSelChar.SetNewVersion;
begin
  inherited;
end;

procedure TFrmSelChar.FormCreate(Sender: TObject);
begin
  inherited;
  FTestPos := true;
  FSelectIndex := -1;
  if not G_Default1024 then
  begin
    self.Height := fhei;
    self.Width := fwide;
  end
  else
  begin
    self.Height := fhei1024;
    self.Width := fwide1024;
  end;
  FrmM.AddA2Form(Self, A2form);
  FCurCharImageIndex := 0;
  if WinVerType = wvtnew then
  begin
    SetNewVersion;
//  end
//  else
//  begin
//    SetOldVersion;
  end;

  Left := 0;
  Top := 0;
  SetFormText;
  LbSex.Font.Name := mainFont;
  CBVillage.Font.Name := mainFont;
  EditPassWord.Font.Name := mainFont;
  EditConfirm.Font.Name := mainFont;
  Pninfo.Font.Name := mainFont;

  ListBox1.boAutoPro := false;

  CharImage1 := TA2Image.Create(160, 160, 0, 0);
  CharImage2 := TA2Image.Create(160, 160, 0, 0);
  CharImage3 := TA2Image.Create(160, 160, 0, 0);
  CharImage4 := TA2Image.Create(160, 160, 0, 0);
  CharImage5 := TA2Image.Create(160, 160, 0, 0);
  CharImageArray[0] := CharImage1;
  CharImageArray[1] := CharImage2;
  CharImageArray[2] := CharImage3;
  CharImageArray[3] := CharImage4;
  CharImageArray[4] := CharImage5;
  FCurCharImage := TA2Image.Create(160, 160, 0, 0);
  Labels[0] := A2LabelCharName0;
  Labels[1] := A2LabelCharName1;
  Labels[2] := A2LabelCharName2;
  Labels[3] := A2LabelCharName3;
  Labels[4] := A2LabelCharName4;
  FillChar(FWomanFeature, SizeOf(TFeature), 0);
  FWomanFeature.rrace := 1;
  FWomanFeature.raninumber := 0;
  FWomanFeature.rfeaturestate := wfs_normal;
  FWomanFeature.rboman := False;
  FillChar(FManFeature, SizeOf(TFeature), 0);
  FManFeature.rboman := True;
  FManFeature.rrace := 1;
end;

procedure TFrmSelChar.BtnWaManClick(Sender: TObject);
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  LbSex.Caption := ('女');
end;

procedure TFrmSelChar.BtnManClick(Sender: TObject);
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  LbSex.Caption := ('男');
end;

procedure TFrmSelChar.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if byte(key) = VK_RETURN then
    BtnSelectClick(Sender);
end;

procedure TFrmSelChar.A2ButtonCHANGECharNameClick(Sender: TObject);
var
  csc: TCChangeCharName;
  str, uCharName, uServerName, newname: string;
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);

  str := listbox1.Items[Listbox1.Itemindex];

  str := GetValidStr3(str, uCharName, ':');
  str := GetValidStr3(str, uServerName, ':');
  if uCharName = '' then exit;
  if uServerName = '' then exit;
  if str <> '改名字' then EXIT;
  A2Edit_NewName.Text := trim(A2Edit_NewName.Text);
  newname := A2Edit_NewName.Text;
  if newname = '' then exit;

  csc.rmsg := CM_CHANGECharName;
  csc.rOldName := Copy(uCharName, 1, 20);
  csc.rOldServerName := Copy(uServerName, 1, 20);
  csc.rNewName := newname;
  Frmfbl.SocketAddData(sizeof(csc), @csc);
  A2Edit_OldName.Visible := false;
  A2Edit_NewName.Visible := false;
  A2ButtonCHANGECharName.Visible := false;
  A2ButtonCHANGECharNameOff.Visible := false;

  A2ILabel1.Visible := false;

end;


procedure TFrmSelChar.A2ButtonCHANGECharNameONClick(Sender: TObject);
var
  csc: TCSelectChar;
  str, uCharName, uServerName: string;
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  str := listbox1.Items[Listbox1.Itemindex];

  str := GetValidStr3(str, uCharName, ':');
  str := GetValidStr3(str, uServerName, ':');
  if uCharName = '' then exit;
  if uServerName = '' then exit;
  if str <> '改名字' then EXIT;
  A2Edit_OldName.Text := uCharName;
  A2Edit_OldName.Visible := true;
  A2Edit_NewName.Visible := true;
  A2Edit_NewName.Text := '';
  A2ButtonCHANGECharName.Visible := true;
  A2ButtonCHANGECharNameOff.Visible := true;
  A2ILabel1.Visible := true;
  A2ButtonCHANGECharNameON.Visible := false;
  Pninfo.Caption := '';
end;

procedure TFrmSelChar.A2ButtonCHANGECharNameOffClick(Sender: TObject);
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  A2Edit_OldName.Visible := false;
  A2Edit_NewName.Visible := false;
  A2ButtonCHANGECharName.Visible := false;
  A2ButtonCHANGECharNameOff.Visible := false;
  A2ButtonCHANGECharNameON.Visible := true;
  A2ILabel1.Visible := false;
end;

procedure TFrmSelChar.BtnSelectClick(Sender: TObject);
var
  csc: TCSelectChar;
  str, uCharName, uServerName: string;
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  if FSelectIndex = -1 then Exit;
  try

    str := listbox1.Items[FSelectIndex - 1];

    A2ButtonCHANGECharNameON.Visible := false;

    str := GetValidStr3(str, uCharName, ':');
    str := GetValidStr3(str, uServerName, ':');
    //ShowMessage(uServerName);
    //Exit;
    if uCharName = '' then exit;
    if uServerName = '' then exit;
    if str = '改名字' then
    begin
      A2ButtonCHANGECharNameON.Visible := true;
      EXIT;
    end;
    csc.rmsg := CM_SELECTCHAR;
    csc.rchar := Copy(uCharName, 1, 20);
    csc.rServer := Copy(uServerName, 1, 20);
    fservername := Copy(uServerName, 1, 20);


    Frmfbl.SocketAddData(sizeof(csc), @csc);
    ReConnectChar := csc.rchar;
    ReConnectServer := csc.rServer;
    ReConnectyctime := FSelectIndex;
  except
  end;
end;

procedure TFrmSelChar.ListBox1Click(Sender: TObject);
var
  csc: TCChangeCharName;
  str, uCharName, uServerName, newname: string;
begin
  FSelectIndex := ListBox1.ItemIndex;


  str := listbox1.Items[Listbox1.Itemindex];

  str := GetValidStr3(str, uCharName, ':');
  str := GetValidStr3(str, uServerName, ':');
  if uCharName = '' then exit;
  if uServerName = '' then exit;
  if str <> '改名字' then
  begin
    A2ButtonCHANGECharNameON.Visible := false;
  end else
    A2ButtonCHANGECharNameON.Visible := true;

end;

procedure TFrmSelChar.DrawFeatureItem;
var
  i, gc, ga, j: integer;

  ImageLib: TA2ImageLib;
  charlbl: TA2ILabel;
  CharImage: TA2Image;
  index:Integer;
begin
  if frmfbl = nil then Exit;
 // if FSelectIndex = -1 then Exit;
 // Feature := frmfbl.DBRecordList[FSelectIndex].feature;

  for j := 0 to Length(frmfbl.DBRecordList) - 1 do
  begin
     index:=163;
    charlbl := nil;
    if frmfbl.DBRecordList[j].used then
    begin
      if j = FSelectIndex-1 then
        index:=57;
      Feature := frmfbl.DBRecordList[j].feature;
      charlbl := TA2ILabel(FindComponent('LbChar' + inttostr(j + 1)));
    // if charlbl.A2Image = nil then Continue;
      CharImage := CharImageArray[j];
      CharImage.Clear(0);
      for i := 0 to 10 - 1 do
      begin
        ImageLib := GetArrImageLib(i, mmAnsTick, Feature);
        if ImageLib <> nil then
        begin
          GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
          if Feature.rArr[i * 2 + 1] = 0 then
            CharImage.DrawImage(
              ImageLib.Images[index],
              ImageLib.Images[index].px + 80,
              ImageLib.Images[index].py + 80,
              TRUE)
          else
            CharImage.DrawImageGreenConvert(
              ImageLib.Images[index],
              ImageLib.Images[index].px + 80,
              ImageLib.Images[index].py + 80,
              gc, ga);
        end;
      end;

      charlbl.A2Image := CharImage;
    end;

  end;
//   Feature.rArr[4]:=1;
//  Feature.rArr[5]:=2;      Feature.rArr[8]:=1;
//  Feature.rArr[9]:=2;
//  Feature.rArr[14]:=1;
//  Feature.rArr[15]:=1;
//  CharCenterImage.Clear(0);
//
//  for i := 0 to 10 - 1 do
//  begin
//    ImageLib := GetArrImageLib(i, mmAnsTick, Feature);
//    if ImageLib <> nil then
//    begin
//      GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
//      if Feature.rArr[i * 2 + 1] = 0 then
//        CharCenterImage.DrawImage(
//          ImageLib.Images[57],
//          ImageLib.Images[57].px + CHarMaxSiezHalf,
//          ImageLib.Images[57].py + CHarMaxSiezHalf,
//          TRUE)
//      else
//        CharCenterImage.DrawImageGreenConvert(
//          ImageLib.Images[57],
//          ImageLib.Images[57].px + CHarMaxSiezHalf,
//          ImageLib.Images[57].py + CHarMaxSiezHalf,
//          gc, ga);
//    end;
//  end;
//
end;

function TFrmSelChar.GetArrImageLib(aindex, CurTick: integer;
  aFeature: tFeature): TA2ImageLib;
begin
  if not aFeature.rboMan then
    Result := AtzClass.GetImageLib(char(word('a') + aindex) + format('%d0.atz', [aFeature.rArr[aindex * 2]]), CurTick)
  else
    Result := AtzClass.GetImageLib(char(word('n') + aindex) + format('%d0.atz', [aFeature.rArr[aindex * 2]]), CurTick);

end;

procedure TFrmSelChar.SetConfigFileName;
begin
  FConfigFileName := 'CharSelect.xml';
end;

//procedure TFrmSelChar.SetNewVersionOld;
//var
//  outimg: TA2Image;
//begin
//
//    //  A2Form.FImageSurface.LoadFromFile (ExtractFilePath(ParamStr(0))+'bmp\人物选择及创建界面-背景.bmp');
//  if fwide = 800 then
//  begin
//    pgkBmp.getBmp('人物选择及创建界面-背景.bmp', A2form.FImageSurface);
//    outimg := TA2Image.Create(32, 32, 0, 0);
//    try
//      EditChar.Left := 303;
//      EditChar.Top := 228;
//      EditChar.Width := 95;
//      EditChar.Height := 16;
//
//      CBVillage.Left := 305;
//      CBVillage.Top := 268;
//      CBVillage.Width := 95;
//      CBVillage.Height := 16;
//
//      ListBox1.Left := 456;
//      ListBox1.Top := 205;
//      ListBox1.Width := 122;
//      ListBox1.Height := 75;
//
//      LbSex.Left := 306 + 16;
//      LbSex.Top := 314;
//      LbSex.Width := 58;
//      LbSex.Height := 19;
//
//      BtnWaMan.Left := 254;
//      BtnWaMan.Top := 363;
//      BtnWaMan.Width := 45;
//      BtnWaMan.Height := 16;
//
//      BtnMan.Left := 339;
//      BtnMan.Top := 363;
//      BtnMan.Width := 58;
//      BtnMan.Height := 19;
//
//      BtnCreateChar.Left := 289;
//      BtnCreateChar.Top := 406;
//      BtnCreateChar.Width := 76;
//      BtnCreateChar.Height := 18;
//
//      BtnSelect.Left := 441;
//      BtnSelect.Top := 289;
//      BtnSelect.Width := 76;
//      BtnSelect.Height := 18;
//
//      BtnDelete.Left := 523;
//      BtnDelete.Top := 289;
//      BtnDelete.Width := 76;
//      BtnDelete.Height := 18;
//
//      EditPassWord.Left := 497;
//      EditPassWord.Top := 336;
//      EditPassWord.Width := 95;
//      EditPassWord.Height := 16;
//
//      EditConfirm.Left := 497;
//      EditConfirm.Top := 376;
//      EditConfirm.Width := 95;
//      EditConfirm.Height := 16;
//
//      BtnChangePass.Left := 485;
//      BtnChangePass.Top := 476;
//      BtnChangePass.Width := 76;
//      BtnChangePass.Height := 18;
//
//      Pninfo.Left := Pninfo.Left + 45;
//      Pninfo.Top := Pninfo.Top + 12;
//      pgkBmp.getBmp('人物选择及创建界面-男-按下.bmp', outimg);
//      BtnMan.A2Down := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-男-弹起.bmp', outimg);
//      BtnMan.A2Up := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-男-鼠标.bmp', outimg);
//      BtnMan.A2Mouse := outimg;
//
//      pgkBmp.getBmp('人物选择及创建界面-女-按下.bmp', outimg);
//      BtnWaMan.A2Down := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-女-弹起.bmp', outimg);
//      BtnWaMan.A2Up := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-女-鼠标.bmp', outimg);
//      BtnWaMan.A2Mouse := outimg;
//
//      pgkBmp.getBmp('人物选择及创建界面-删除人物-按下.bmp', outimg);
//      BtnDelete.A2Down := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-删除人物-弹起.bmp', outimg);
//      BtnDelete.A2Up := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-删除人物-鼠标.bmp', outimg);
//      BtnDelete.A2Mouse := outimg;
//
//      pgkBmp.getBmp('人物选择及创建界面-选择人物-按下.bmp', outimg);
//      BtnSelect.A2Down := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-选择人物-弹起.bmp', outimg);
//      BtnSelect.A2Up := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-选择人物-鼠标.bmp', outimg);
//      BtnSelect.A2Mouse := outimg;
//
//      pgkBmp.getBmp('人物选项_密码修改_按下.bmp', outimg);
//      BtnChangePass.A2Down := outimg;
//      pgkBmp.getBmp('人物选项_密码修改_弹起.bmp', outimg);
//      BtnChangePass.A2Up := outimg;
//      pgkBmp.getBmp('人物选项_密码修改_鼠标.bmp', outimg);
//      BtnChangePass.A2Mouse := outimg;
//
//      pgkBmp.getBmp('人物选择及创建界面-确认创建-按下.bmp', outimg);
//      BtnCreateChar.A2Down := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-确认创建-弹起.bmp', outimg);
//      BtnCreateChar.A2Up := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-确认创建-鼠标.bmp', outimg);
//      BtnCreateChar.A2Mouse := outimg;
//
//      A2ILabel1.Left := 425;
//      A2ILabel1.Top := 315;
//      A2ILabel1.Width := 182;
//      A2ILabel1.Height := 66;
//      pgkBmp.getBmp('登陆界面_修改名字.bmp', outimg);
//      A2ILabel1.A2Image := outimg;
//
//      A2Edit_OldName.Left := A2ILabel1.Left + 71;
//      A2Edit_OldName.Top := A2ILabel1.Top + 9;
//      A2Edit_NewName.Left := A2ILabel1.Left + 71;
//      A2Edit_NewName.Top := A2ILabel1.Top + 40;
//
//      A2Edit_OldName.Visible := false;
//      A2Edit_NewName.Visible := false;
//      A2ButtonCHANGECharName.Visible := false;
//      A2ButtonCHANGECharNameOff.Visible := false;
//
//      A2ILabel1.Visible := false;
//
//      pgkBmp.getBmp('登陆界面_修改名字_按下.bmp', outimg);
//      A2ButtonCHANGECharNameON.A2Down := outimg;
//      pgkBmp.getBmp('登陆界面_修改名字_弹起.bmp', outimg);
//      A2ButtonCHANGECharNameON.A2Up := outimg;
//      pgkBmp.getBmp('登陆界面_修改名字_禁止.bmp', outimg);
//      A2ButtonCHANGECharNameON.A2NotEnabled := outimg;
//      pgkBmp.getBmp('登陆界面_修改名字_鼠标.bmp', outimg);
//      A2ButtonCHANGECharNameON.A2Mouse := outimg;
//
//
//      pgkBmp.getBmp('登陆界面_取消_按下.bmp', outimg);
//      A2ButtonCHANGECharNameOff.A2Down := outimg;
//      pgkBmp.getBmp('登陆界面_取消_弹起.bmp', outimg);
//      A2ButtonCHANGECharNameOff.A2Up := outimg;
//      pgkBmp.getBmp('登陆界面_取消_禁止.bmp', outimg);
//      A2ButtonCHANGECharNameOff.A2NotEnabled := outimg;
//      pgkBmp.getBmp('登陆界面_取消_鼠标.bmp', outimg);
//      A2ButtonCHANGECharNameOff.A2Mouse := outimg;
//      A2ButtonCHANGECharNameOff.Left := 524;
//      A2ButtonCHANGECharNameOff.Top := 384;
//
//
//      pgkBmp.getBmp('登陆界面_确认_按下.bmp', outimg);
//      A2ButtonCHANGECharName.A2Down := outimg;
//      pgkBmp.getBmp('登陆界面_确认_弹起.bmp', outimg);
//      A2ButtonCHANGECharName.A2Up := outimg;
//      pgkBmp.getBmp('登陆界面_确认_禁止.bmp', outimg);
//      A2ButtonCHANGECharName.A2NotEnabled := outimg;
//      pgkBmp.getBmp('登陆界面_确认_鼠标.bmp', outimg);
//      A2ButtonCHANGECharName.A2Mouse := outimg;
//      A2ButtonCHANGECharName.Left := 441;
//      A2ButtonCHANGECharName.Top := 384;
//    finally
//      outimg.Free;
//    end;
//  end else
//  begin
//
//    //pgkBmp_n.getBmp('人物选择及创建界面-背景.bmp', A2form.FImageSurface);
//    outimg := TA2Image.Create(32, 32, 0, 0);
//    try
//     {   EditChar.Left := 303;
//        EditChar.Top := 228; }
//      EditChar.Width := 95;
//      EditChar.Height := 36;
//
//       { CBVillage.Left := 305;
//        CBVillage.Top := 268;   }
//      CBVillage.Width := 95;
//      CBVillage.Height := 36;
//
//      {  ListBox1.Left := 456;
//        ListBox1.Top := 205;   }
//      ListBox1.Width := 122;
//      ListBox1.Height := 75;
//
//       { LbSex.Left := 306 + 16;
//        LbSex.Top := 314;   }
//      LbSex.Width := 58;
//      LbSex.Height := 39;
//
//       { BtnWaMan.Left := 254;
//        BtnWaMan.Top := 363; }
//      BtnWaMan.Width := 45;
//      BtnWaMan.Height := 36;
//
//      {  BtnMan.Left := 339;
//        BtnMan.Top := 363;  }
//      BtnMan.Width := 58;
//      BtnMan.Height := 39;
//
//       { BtnCreateChar.Left := 289;
//        BtnCreateChar.Top := 406;   }
//      BtnCreateChar.Width := 76;
//      BtnCreateChar.Height := 18;
//
//       { BtnSelect.Left := 441;
//        BtnSelect.Top := 289;      }
//      BtnSelect.Width := 76;
//      BtnSelect.Height := 18;
//
//        {BtnDelete.Left := 523;
//        BtnDelete.Top := 289; }
//      BtnDelete.Width := 76;
//      BtnDelete.Height := 18;
//
//       { EditPassWord.Left := 497;
//        EditPassWord.Top := 336; }
//      EditPassWord.Width := 95;
//      EditPassWord.Height := 16;
//
//      {  EditConfirm.Left := 497;
//        EditConfirm.Top := 376;  }
//      EditConfirm.Width := 95;
//      EditConfirm.Height := 16;
//
//      {  BtnChangePass.Left := 485;
//        BtnChangePass.Top := 476;   }
//      BtnChangePass.Width := 76;
//      BtnChangePass.Height := 18;
//
//      Pninfo.Left := Pninfo.Left + 45;
//      Pninfo.Top := Pninfo.Top + 12;
//      pgkBmp.getBmp('人物选择及创建界面-男-按下.bmp', outimg);
//      BtnMan.A2Down := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-男-弹起.bmp', outimg);
//      BtnMan.A2Up := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-男-鼠标.bmp', outimg);
//      BtnMan.A2Mouse := outimg;
//
//      pgkBmp.getBmp('人物选择及创建界面-女-按下.bmp', outimg);
//      BtnWaMan.A2Down := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-女-弹起.bmp', outimg);
//      BtnWaMan.A2Up := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-女-鼠标.bmp', outimg);
//      BtnWaMan.A2Mouse := outimg;
//
//      pgkBmp.getBmp('人物选择及创建界面-删除人物-按下.bmp', outimg);
//      BtnDelete.A2Down := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-删除人物-弹起.bmp', outimg);
//      BtnDelete.A2Up := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-删除人物-鼠标.bmp', outimg);
//      BtnDelete.A2Mouse := outimg;
//
//      pgkBmp.getBmp('人物选择及创建界面-选择人物-按下.bmp', outimg);
//      BtnSelect.A2Down := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-选择人物-弹起.bmp', outimg);
//      BtnSelect.A2Up := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-选择人物-鼠标.bmp', outimg);
//      BtnSelect.A2Mouse := outimg;
//
//      pgkBmp.getBmp('人物选项_密码修改_按下.bmp', outimg);
//      BtnChangePass.A2Down := outimg;
//      pgkBmp.getBmp('人物选项_密码修改_弹起.bmp', outimg);
//      BtnChangePass.A2Up := outimg;
//      pgkBmp.getBmp('人物选项_密码修改_鼠标.bmp', outimg);
//      BtnChangePass.A2Mouse := outimg;
//
//      pgkBmp.getBmp('人物选择及创建界面-确认创建-按下.bmp', outimg);
//      BtnCreateChar.A2Down := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-确认创建-弹起.bmp', outimg);
//      BtnCreateChar.A2Up := outimg;
//      pgkBmp.getBmp('人物选择及创建界面-确认创建-鼠标.bmp', outimg);
//      BtnCreateChar.A2Mouse := outimg;
//
//      A2ILabel1.Left := 425;
//      A2ILabel1.Top := 315;
//      A2ILabel1.Width := 182;
//      A2ILabel1.Height := 66;
//      pgkBmp.getBmp('登陆界面_修改名字.bmp', outimg);
//      A2ILabel1.A2Image := outimg;
//
//      A2Edit_OldName.Left := A2ILabel1.Left + 71;
//      A2Edit_OldName.Top := A2ILabel1.Top + 9;
//      A2Edit_NewName.Left := A2ILabel1.Left + 71;
//      A2Edit_NewName.Top := A2ILabel1.Top + 40;
//
//      A2Edit_OldName.Visible := false;
//      A2Edit_NewName.Visible := false;
//      A2ButtonCHANGECharName.Visible := false;
//      A2ButtonCHANGECharNameOff.Visible := false;
//
//      A2ILabel1.Visible := false;
//
//      pgkBmp.getBmp('登陆界面_修改名字_按下.bmp', outimg);
//      A2ButtonCHANGECharNameON.A2Down := outimg;
//      pgkBmp.getBmp('登陆界面_修改名字_弹起.bmp', outimg);
//      A2ButtonCHANGECharNameON.A2Up := outimg;
//      pgkBmp.getBmp('登陆界面_修改名字_禁止.bmp', outimg);
//      A2ButtonCHANGECharNameON.A2NotEnabled := outimg;
//      pgkBmp.getBmp('登陆界面_修改名字_鼠标.bmp', outimg);
//      A2ButtonCHANGECharNameON.A2Mouse := outimg;
//
//
//      pgkBmp.getBmp('登陆界面_取消_按下.bmp', outimg);
//      A2ButtonCHANGECharNameOff.A2Down := outimg;
//      pgkBmp.getBmp('登陆界面_取消_弹起.bmp', outimg);
//      A2ButtonCHANGECharNameOff.A2Up := outimg;
//      pgkBmp.getBmp('登陆界面_取消_禁止.bmp', outimg);
//      A2ButtonCHANGECharNameOff.A2NotEnabled := outimg;
//      pgkBmp.getBmp('登陆界面_取消_鼠标.bmp', outimg);
//      A2ButtonCHANGECharNameOff.A2Mouse := outimg;
//      {  A2ButtonCHANGECharNameOff.Left := 524;
//        A2ButtonCHANGECharNameOff.Top := 384;    }
//
//
//      pgkBmp.getBmp('登陆界面_确认_按下.bmp', outimg);
//      A2ButtonCHANGECharName.A2Down := outimg;
//      pgkBmp.getBmp('登陆界面_确认_弹起.bmp', outimg);
//      A2ButtonCHANGECharName.A2Up := outimg;
//      pgkBmp.getBmp('登陆界面_确认_禁止.bmp', outimg);
//      A2ButtonCHANGECharName.A2NotEnabled := outimg;
//      pgkBmp.getBmp('登陆界面_确认_鼠标.bmp', outimg);
//      A2ButtonCHANGECharName.A2Mouse := outimg;
//      {  A2ButtonCHANGECharName.Left := 441;
//        A2ButtonCHANGECharName.Top := 384;
//                                              }
//    finally
//      outimg.Free;
//    end;
//  end;
//
//  CharCenterImage := TA2Image.Create(160, 160, 0, 0);
//
//
//  A2form.boImagesurface := true;
//end;

procedure TFrmSelChar.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := True;
  SetControlPos(CharSelect);
  SetControlPos(LbChar1);
  SetControlPos(LbChar2);
  SetControlPos(LbChar3);
  SetControlPos(LbChar4);
  SetControlPos(LbChar5);
  SetControlPos(BtnSelect);
  SetControlPos(BtnCreateChar);
  BtnCreateChar.OnClick := NewCreateCharClick;
  SetControlPos(BtnDelete);
  BtnDelete.OnClick := NewDeleteClick;
  SetControlPos(A2Panel1);
  SetControlPos(BackImgB1);
  SetControlPos(A2ButtonCreateChar);
  SetControlPos(A2ButtonCancel);
  SetControlPos(A2CheckBox_Man);
  A2CheckBox_Man.Checked := True;
  SetControlPos(A2CheckBox_Woman);
  A2CheckBox_Woman.Checked := False;
  SetControlPos(A2EditChar);
  SetControlPos(A2PnInfo);
  SetControlPos(A2LabelCharName0);
  SetControlPos(A2LabelCharName1);
  SetControlPos(A2LabelCharName2);
  SetControlPos(A2LabelCharName3);
  SetControlPos(A2LabelCharName4);
  SetControlPos(A2ButtonCloseCP);
  SetControlPos(A2ButtonCloseDP);
  SetControlPos(charImgLeftBtn);
  SetControlPos(CreateCharImgA2lbl);
  SetControlPos(charImgRigthBtn);
  A2Panel1.Visible := False;
  A2Panel2.Visible := False;
  DrawFeatureItem;
  CharSelect.Visible := False;
  SetControlPos(self.Pninfo);
    SetControlPos(self.Pninfo2);
  SetOtherConfig();
end;

procedure TFrmSelChar.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TFrmSelChar.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if ssAlt in Shift then
//  begin
//    case Key of
//
//      word('p'), WORD('P'):
//        begin
//          SetNewVersionTest;
//        end;
//    end;
//  end else
//    inherited;
end;

procedure TFrmSelChar.LbChar1Click(Sender: TObject);
var
  w, h: Integer;
begin
   FSelectIndex := StrToIntDef(TControl(sender).Hint, -1);
     if not frmfbl.DBRecordList[FSelectIndex-1].used then
        Exit;
    DrawFeatureItem;
  w := (CharSelect.Width - TControl(sender).Width) div 2;
  CharSelect.Left := TControl(sender).Left - w+self.FSelectLeftSub;
  h := (CharSelect.Height - TControl(sender).Height) div 2;
  CharSelect.Top := TControl(sender).Top - h+self.FSelectTopSub;
  CharSelect.Show;


 // CharSelect.BringToFront;
end;

procedure TFrmSelChar.FormShow(Sender: TObject);
begin
  if Self.CanFocus then
    Self.SetFocus;
end;

procedure TFrmSelChar.LbChar2DblClick(Sender: TObject);
begin
  BtnSelectClick(Sender);
end;

procedure TFrmSelChar.NewCreateCharClick(Sender: TObject);
begin
  self.A2PnInfo.Caption := '请输入要创建的角色名称';
  A2Panel1.Visible := True;
  DrawCreateCharFeature(A2CheckBox_Man.Checked, 0);
  A2EditChar.SetFocus;
end;

procedure TFrmSelChar.NewDeleteClick(Sender: TObject);
begin
  Self.Pninfo2.Caption := '';
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  if listbox1.Items[FSelectIndex - 1] = '' then
  begin
    exit;
  end;
  A2Panel2.Visible := True;
end;

procedure TFrmSelChar.A2ButtonCreateCharClick(Sender: TObject);
var
  ccc: TCCreateChar;
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  if Length(A2EditChar.Text) < 2 then
  begin
    A2PnInfo.Caption := ('人物名称 输入2个字以上');
    A2EditChar.SetFocus;
    exit;
  end;
  if Pos(',', A2EditChar.Text) > 0 then
  begin
    A2PnInfo.Caption := ('不可使用特殊符号');
    A2EditChar.SetFocus;
    exit;
  end;
  if Pos(',', CBVillage.text) > 0 then
  begin
    A2PnInfo.Caption := ('不可使用特殊符号');
    CBVillage.SetFocus;
    exit;
  end;

  ccc.rmsg := CM_CREATECHAR;
  ccc.rchar := A2EditChar.Text;

  if A2CheckBox_Man.Checked then ccc.rsex := 0
  else ccc.rsex := 1;

  ccc.rVillage := CBVillage.Text;
  ccc.rServer := '';

  Frmfbl.SocketAddData(sizeof(ccc), @ccc);
end;

procedure TFrmSelChar.A2ButtonCloseDPClick(Sender: TObject);
begin
  A2Panel2.Visible := False;

end;

procedure TFrmSelChar.A2ButtonCloseCPClick(Sender: TObject);
begin
  A2Panel1.Visible := False;

end;

procedure TFrmSelChar.A2CheckBox_ManClick(Sender: TObject);
begin
  inherited;
  if TA2CheckBox(Sender).Tag = 1 then
    A2CheckBox_Man.Checked := not A2CheckBox_Woman.Checked
  else
    A2CheckBox_Woman.Checked := not A2CheckBox_Man.Checked;
    DrawCreateCharFeature(True,FCurCharImageIndex);
end;

procedure TFrmSelChar.A2CheckBox_WomanClick(Sender: TObject);
begin
  inherited;
  if TA2CheckBox(Sender).Tag = 1 then
    A2CheckBox_Man.Checked := not A2CheckBox_Woman.Checked
  else
    A2CheckBox_Woman.Checked := not A2CheckBox_Man.Checked;
      DrawCreateCharFeature(False,FCurCharImageIndex);
end;

procedure TFrmSelChar.DrawCreateCharFeature(bIsMan: Boolean;
  AIndex: Integer);
var
  i, gc, ga, j: integer;

  ImageLib: TA2ImageLib;
  charlbl: TA2ILabel;
  Feature: TFeature;
  imgindex:Integer;
begin
  if bIsMan then
    Feature := FManFeature
  else
    Feature := FWomanFeature;
  FCurCharImage.Clear(0);
  imgindex:=changeIndex(AIndex);
  for i := 0 to 10 - 1 do
  begin
    ImageLib := GetArrImageLib(i, mmAnsTick, Feature);
    if ImageLib <> nil then
    begin
      GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
      if Feature.rArr[i * 2 + 1] = 0 then
        FCurCharImage.DrawImage(
          ImageLib.Images[imgindex],
          ImageLib.Images[imgindex].px + 80,
          ImageLib.Images[imgindex].py + 80,
          TRUE)
      else
        FCurCharImage.DrawImageGreenConvert(
          ImageLib.Images[imgindex],
          ImageLib.Images[imgindex].px + 80,
          ImageLib.Images[imgindex].py + 80,
          gc, ga);
    end;
  end;
  CreateCharImgA2lbl.Transparent:=True;
  CreateCharImgA2lbl.A2Image := FCurCharImage;
end;
procedure TFrmSelChar.charImgRigthBtnClick(Sender: TObject);
begin
  inherited;
   FCurCharImageIndex:=FCurCharImageIndex+1;
   if FCurCharImageIndex> 7 then
     FCurCharImageIndex:=0;
     DrawCreateCharFeature(A2CheckBox_Man.Checked,FCurCharImageIndex);
end;

procedure TFrmSelChar.charImgLeftBtnClick(Sender: TObject);
begin
  inherited;
   FCurCharImageIndex:=FCurCharImageIndex-1;
   if FCurCharImageIndex<0 then
     FCurCharImageIndex:=7;
     DrawCreateCharFeature(A2CheckBox_Man.Checked,FCurCharImageIndex);
end;

function TFrmSelChar.changeIndex(AIndex: Integer): Integer;
begin
  case AIndex of
    0:Result:= FUIConfig.Root.NodeByName('Views').ReadInteger('charindex0',57);
    1:Result:= FUIConfig.Root.NodeByName('Views').ReadInteger('charindex1',58);
    2:Result:= FUIConfig.Root.NodeByName('Views').ReadInteger('charindex2',59);
    3:Result:= FUIConfig.Root.NodeByName('Views').ReadInteger('charindex3',60);
    4:Result:= FUIConfig.Root.NodeByName('Views').ReadInteger('charindex4',61);
    5:Result:= FUIConfig.Root.NodeByName('Views').ReadInteger('charindex5',62);
    6:Result:= FUIConfig.Root.NodeByName('Views').ReadInteger('charindex6',63);
    7:Result:= FUIConfig.Root.NodeByName('Views').ReadInteger('charindex7',64);
    8:Result:= FUIConfig.Root.NodeByName('Views').ReadInteger('charindex8',65);
    9:Result:= FUIConfig.Root.NodeByName('Views').ReadInteger('charindex9',66);
    10:Result:=FUIConfig.Root.NodeByName('Views').ReadInteger('charindex10',67);
  end;
end;

procedure TFrmSelChar.SetOtherConfig;
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
    node := FUIConfig.Root.NodeByName('Views').FindNode('Select');
    if node <> nil then
    begin
      FSelectLeftSub := node.ReadInteger('SelectLeftSub', 0);
      FSelectTopSub := node.ReadInteger('SelectTopSub', 0);
    end;
  except
  end;
end;

end.

