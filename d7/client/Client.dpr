program Client;

uses
  Windows,
  Forms,
  FLogOn in 'FLogOn.pas' {FrmLogOn},
  FSelChar in 'FSelChar.pas' {FrmSelChar},
  deftype in '..\1000ydef\deftype.pas',
  CLMap in 'CLMap.pas',
  CTable in 'CTable.pas',
  dll_Sock in 'dll_Sock.pas',
  TileCls in 'TileCls.pas',
  objcls in 'objcls.pas',
  FMain in 'FMain.pas' {FrmM},
  FBottom in 'FBottom.pas' {FrmBottom},
  FAttrib in 'FAttrib.pas' {FrmAttrib},
  SubUtil in '..\1000ydef\SubUtil.pas',
  FExchange in 'FExchange.pas' {FrmExchange},
  FSearch in 'FSearch.pas' {FrmSearch},
  FQuantity in 'FQuantity.pas' {FrmQuantity},
  FSound in 'FSound.pas' {FrmSound},
  Log in '..\1000ydef\Log.pas',
  FDepository in 'FDepository.pas' {FrmDepository},
  FMiniMap in 'FMiniMap.pas' {FrmMiniMap},
  uPersonBat in 'uPersonBat.pas',
  FbatList in 'FbatList.pas' {FrmbatList},
  FMuMagicOffer in 'FMuMagicOffer.pas' {FrmMuMagicOffer},
  uBuffer in '..\common\uBuffer.pas',
  uCrypt in '..\common\uCrypt.pas',
  uPackets in '..\common\uPackets.pas',
  BSCommon in '..\common\BSCommon.pas',
  CharCls in 'CharCls.pas',
  uProcessUnit in 'uProcessUnit.pas',
  FPassEtc in 'FPassEtc.pas' {FrmPassEtc},
  FEnergy in 'FEnergy.pas' {FrmEnergy},
  FHelp in 'FHelp.pas' {frmHelp},
  FItemHelp in 'FItemHelp.pas' {frmItemHelp},
  FNPCTrade in 'FNPCTrade.pas' {frmNPCTrade},
  FcMessageBox in 'FcMessageBox.pas' {FrmcMessageBox},
  FSkill in 'FSkill.pas' {frmSkill},
  uHostAddr in 'uHostAddr.pas',
  FHistory in 'FHistory.pas' {frmHistory},
  uEffectCls in 'uEffectCls.pas',
  FEventInput in 'FEventInput.pas' {frmEventInput},
  uCookie in '..\COMMON\uCookie.pas',
  uImage in '..\COMMON\uImage.pas',
  Cltype in 'Cltype.pas',
  FSkillManufact in 'FSkillManufact.pas' {frmSkillManufact},
  FCharAttrib in 'FCharAttrib.pas' {frmCharAttrib},
  FSpecialMagic in 'FSpecialMagic.pas' {frmSpecialMagic},
  FBestMagic in 'FBestMagic.pas' {frmBestMagic},
  AtzCls in 'AtzCls.pas',
  BackScrn in 'BackScrn.pas',
  uSoundManager in 'uSoundManager.pas',
  FConfirmDialog in 'FConfirmDialog.pas' {frmConfirmDialog},
  FTeamMember in 'FTeamMember.pas' {frmTeamMember},
  FInputDialog in 'FInputDialog.pas' {frmInputDialog},
  FGuildInfo in 'FGuildInfo.pas' {frmGuildInfo},
  AUtil32 in '..\1000ydef\AUtil32.pas';

{$R *.RES}

begin

   // System Check
//   if (GetDeviceidentify (DriverName, GraphicCard) <> S_OK) then
//      Application.MessageBox('DirectX Version 8이상으로 설치하여주시기 바랍니다.', '주의', MB_OK);
//   CPUSpeed := GetCPUSpeed;
//   GetDeviceidentify(DriverName, GraphicCard);
//   CPUSpeed := 0;
//   TotalMemory := GetTotalPhysicalMemory;

// Debug Mode Check
//{$ifndef _DEBUG}
//   if IsDebuggerPresent then begin
//      Application.MessageBox(PChar(Conv('보조프로그램으로 인하여 종료됩니다.')), PChar(Conv('천년')));
//      exit;
//   end;
//{$endif}

  Application.Initialize;
  Application.CreateForm(TFrmM, FrmM);
  Application.CreateForm(TFrmLogOn, FrmLogOn);
  Application.CreateForm(TFrmSelChar, FrmSelChar);
  Application.CreateForm(TFrmBottom, FrmBottom);
  Application.CreateForm(TFrmAttrib, FrmAttrib);
  Application.CreateForm(TFrmExchange, FrmExchange);
  Application.CreateForm(TFrmSearch, FrmSearch);
  Application.CreateForm(TFrmQuantity, FrmQuantity);
  Application.CreateForm(TFrmSound, FrmSound);
  Application.CreateForm(TFrmDepository, FrmDepository);
  Application.CreateForm(TFrmMiniMap, FrmMiniMap);
  Application.CreateForm(TFrmbatList, FrmbatList);
  Application.CreateForm(TFrmMuMagicOffer, FrmMuMagicOffer);
  Application.CreateForm(TFrmPassEtc, FrmPassEtc);
  Application.CreateForm(TFrmEnergy, FrmEnergy);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.CreateForm(TfrmNPCTrade, frmNPCTrade);
  Application.CreateForm(TfrmItemHelp, frmItemHelp);
  Application.CreateForm(TFrmcMessageBox, FrmcMessageBox);
  Application.CreateForm(TfrmSkill, frmSkill);
  Application.CreateForm(TfrmHistory, frmHistory);
  Application.CreateForm(TfrmEventInput, frmEventInput);
  Application.CreateForm(TfrmSkillManufact, frmSkillManufact);
  Application.CreateForm(TfrmCharAttrib, frmCharAttrib);
  Application.CreateForm(TfrmSpecialMagic, frmSpecialMagic);
  Application.CreateForm(TfrmBestMagic, frmBestMagic);
  Application.CreateForm(TfrmConfirmDialog, frmConfirmDialog);
  Application.CreateForm(TfrmTeamMember, frmTeamMember);
  Application.CreateForm(TfrmInputDialog, frmInputDialog);
  Application.CreateForm(TfrmGuildInfo, frmGuildInfo);
  Application.Run;
end.
