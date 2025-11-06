unit uPersonBat;

interface

uses
   A2Img, BackScrn, AUtil32, Deftype, classes, SysUtils;

type
   TMsgItem = packed record
      rLines: Byte;
      rOptions: Byte;  // 0: CenterMessage, 1: TopMessage, 2: EventMessage
      rColor: Word;
      rLine1: string;
      rLine2: string;
      rLine3: string;
   end;
   PTMsgItem = ^TMsgItem;

   TPersonBat = class
   private
      PersonBatLib : TA2ImageLib;
      FWinType : Byte;
      RightID, LeftID : string;
      RightWinCount, LeftWinCount : byte;
      RightBarImg, LeftBarImg : TA2Image;
      RightIDEnergy, LeftIDEnergy : byte;

      FShowBar : Boolean;
      FShowBatMsg : Boolean;

      FMsgList : TList;

      BatMsgDelay : integer;
      BatMsgItem: TMsgItem;
   public
      ShowBatX, ShowBatY : integer;
      constructor Create;
      destructor  Destroy; override;

      procedure   SetID (aRightID, aLeftID : string);
      procedure   Draw;
      procedure   SetEnergy (aRightIDEnergy, aLeftIDEnergy : integer);
      procedure   BatMessageDraw (CurTick: integer);

      procedure   MessageProcess (var code: TWordComData);
      procedure   AddCenterMsg(col: Word; option: Byte; str: string);
      procedure   AddEventMsg(col: Word; const strName, strLine1, strLine2: string);

      property    ShowBar : Boolean read FShowBar write FShowBar;
      property    ShowBatMsg : Boolean read FShowBatMsg write FShowBatMsg;
   end;

var
   PersonBat : TPersonBat;

implementation

uses
   FMain, FHistory;
{O+}

function  calculation4 (xMax,xValue,yMax,yValue,aResult : integer): integer;
begin
   Result := 0;
   case aResult of
      1 : Result := (xValue*yMax) div yValue;
      2 : Result := (xMax*yValue) div yMax;
      3 : Result := (xMax*yValue) div xValue;
      4 : Result := (xValue*yMax) div xMax;
   end;
end;

procedure MakeBarImage (aBarImage, SourImage : TA2Image; BarPersent, directionType: byte);
var
   i, n : integer;
   dd, ss, tempSS, Tempbit, TT : PTAns2Color;
   ibp : integer;
begin
   ibp := calculation4 (aBarImage.Width,0,100,BarPersent,2);
   if ibp > aBarImage.Width then ibp := aBarImage.Width;
   dd := SourImage.Bits;
   ss := aBarImage.Bits;

   GetMem (Tempbit, sizeof(TAns2Color)*SourImage.Height);
   TT := Tempbit;
   for i := 0 to SourImage.Height -1 do begin
      move (dd^, TT^, SizeOf(TAns2Color));
      inc (dd, SourImage.Width);
      inc (TT);
   end;
   case directionType of
      0 :
         begin
            TT := Tempbit;
            for i := 0 to SourImage.Height-1 do begin
               tempSS := ss;
               for n := 0 to ibp -1 do begin
                  TempSS^ := TT^; inc (TempSS);
               end;
               inc (ss, aBarImage.Width); inc (TT);
            end;
         end;
      1 :
         begin
            TT := Tempbit;
            for i := 0 to SourImage.Height-1 do begin
               tempSS := ss;
               inc (tempss, aBarImage.Width);
               for n := ibp -1 downto 0 do begin
                  dec (TempSS); TempSS^ := TT^;
               end;
               inc (ss, aBarImage.Width); inc (TT);
            end;
         end;
   end;
   FreeMem (Tempbit);
end;

procedure   TPersonBat.MessageProcess (var code: TWordComData);
var
   PTTSShowBattleBar : PTSShowBattleBar;
   PTTSShowCenterMsg : PTSShowCenterMsg;
   psEventMessage:  PTSEventMessage;
   pckey : PTCKey;
   str: string;
begin
   pckey := @Code.data;
   case pckey^.rmsg of
   SM_SHOWBATTLEBAR :
      begin
         PTTSShowBattleBar := @Code.data;
         with PTTSShowBattleBar^ do begin
            FWinType := rWinType;
            LeftID := rLeftName;
            LeftWinCount := rLeftWin;
            LeftIDEnergy := rLeftPercent;
            RightID := rRightName;
            RightWinCount := rRightWin;
            RightIDEnergy := rRightPercent;
         end;
         FShowBar := TRUE;
      end;
   SM_SHOWCENTERMSG, SM_SHOWTOPMSG :
      begin
         PTTSShowCenterMsg := @Code.data;

         str := GetwordString(PTTSShowCenterMsg.rText);

         if pckey.rmsg = SM_SHOWCENTERMSG then begin
            AddCenterMsg(32767, 0, str);
         end else begin
            AddCenterMsg(32767, 1, str);
         end;

         FShowBatMsg := TRUE;
      end;
      {
   SM_SHOWEVENTMSG:
      begin
         psEventMessage := @Code.Data;

         str := StrPas(@psEventMessage.rName);
         AddEventMsg(WinRGB(31, 24, 24), str, psEventMessage.rMsg1, psEventMessage.rMsg2);
         FShowBatMsg := TRUE;
      end;
      }
   end;
end;

procedure TPersonBat.AddCenterMsg(col: Word; option: Byte; str: string);
var
   rdstr: string;
   pMsgItem: PTMsgItem;
begin
   str := GetValidStr3 (str, rdstr,',');

   New(pMsgItem);
   pMsgItem.rColor := col;
   pMsgItem.rOptions := option;

   if str = '' then begin
      pMsgItem.rLines := 1;
      pMsgItem.rLine1 := rdstr;
   end else begin
      pMsgItem.rLines := 2;
      pMsgItem.rLine1 := rdstr;
      pMsgItem.rLine2 := str;
   end;

   FMsgList.Add(pMsgItem);
end;

procedure TPersonBat.AddEventMsg(col: Word; const strName, strLine1, strLine2: string);
var
   pMsgItem: PTMsgItem;
begin
   New(pMsgItem);
   pMsgItem.rLines := 3;
   pMsgItem.rColor := col;
   pMsgItem.rOptions := 2;
   pMsgItem.rLine1 := strLine1;
   pMsgItem.rLine2 := strLine2;
   pMsgItem.rLine3 := strName;

   FMsgList.Add(pMsgItem);
end;

constructor TPersonBat.Create;
begin
   PersonBatLib := TA2ImageLib.Create;
   PersonBatLib.LoadFromFile ('.\ect\persw.Atz');

   RightBarImg := TA2Image.Create (140,8,0,0);
   LeftBarImg := TA2Image.Create (140,8,0,0);

   RightIDEnergy := 100;
   LeftIDEnergy := 100;
   RightID := '';
   LeftID := '';
   RightWinCount := 0;
   LeftWinCount := 0;
   FShowBar := FALSE;
   FShowBatMsg := FALSE;

//   BatMsgFontColor := 0;
//   BatMsgText := '';
   FMsgList := TList.Create;

   BatMsgDelay := 0;

   ShowBatX := 104;
   ShowBatY := 145;
end;

destructor  TPersonBat.Destroy;
begin
   inherited destroy;
   RightBarImg.Free;
   LeftBarImg.Free;
   PersonBatLib.Free;
   FMsgList.Free;
end;

procedure   TPersonBat.SetID (aRightID, aLeftID : string);
begin
   RightID := aRightID;
   LeftID := aLeftID;
end;

procedure   TPersonBat.SetEnergy (aRightIDEnergy, aLeftIDEnergy : integer);
begin
   RightIDEnergy := aRightIDEnergy;
   LeftIDEnergy := aLeftIDEnergy;
end;

const
   EnergybarLeftstartPos = 20;
   EnergybarRightstartPos = 250;

procedure   TPersonBat.Draw;
var
   i, Leftw, Rightw : integer;
begin
   BackScreen.Back.DrawImage (PersonBatLib.Images[4],218,14,TRUE);
   // Left
   LeftBarImg.Clear (0);
   MakeBarImage (LeftBarImg, PersonBatLib.Images[5], LeftIDEnergy,0);
   BackScreen.Back.DrawImage (LeftBarImg,EnergybarLeftstartPos+51,10+14,TRUE);
   BackScreen.Back.DrawImage (PersonBatLib.Images[0],EnergybarLeftstartPos,10,TRUE);
   BackScreen.Back.DrawImage (PersonBatLib.Images[1],EnergybarLeftstartPos + PersonBatLib.Images[0].Width-2-4,23,TRUE);
   //
   Leftw := LeftWinCount;
   for i := 0 to FWinType-1 do begin
      if Leftw <= i then BackScreen.Back.DrawImage (PersonBatLib.Images[6],160+32-(i*16), 35,TRUE)
      else BackScreen.Back.DrawImage (PersonBatLib.Images[7],160+32-(i*16), 35,TRUE);
   end;
   i := ATextWidth (LeftID);
   ATextOut (BackScreen.Back, 212-i, 6, WinRGB(31,31,31), LeftID);

   // Right
   RightBarImg.Clear (0);
   MakeBarImage (RightBarImg, PersonBatLib.Images[5], RightIDEnergy,1);
   BackScreen.Back.DrawImage (RightBarImg,EnergybarRightstartPos,10+14,TRUE);

   BackScreen.Back.DrawImage (PersonBatLib.Images[2],EnergybarRightstartPos,23,TRUE);
   BackScreen.Back.DrawImage (PersonBatLib.Images[3],EnergybarRightstartPos+PersonBatLib.Images[2].Width-2-4,10,TRUE);

   Rightw := RightWinCount;
   for i := 0 to FWinType-1 do begin
      if Rightw <= i then BackScreen.Back.DrawImage (PersonBatLib.Images[6],6+EnergybarRightstartPos+(i*16), 35,TRUE)
      else BackScreen.Back.DrawImage (PersonBatLib.Images[7],6+EnergybarRightstartPos+(i*16), 35,TRUE);
   end;
   ATextOut (BackScreen.Back, EnergybarRightstartPos, 6, WinRGB(31,31,31), RightID);
end;

procedure   TPersonBat.BatMessageDraw (CurTick: integer);
var
   n : integer;
   pMsgItem: PTMsgItem;
begin // 한글 20자 Total 40자
   if BatMsgDelay + 300 < CurTick then begin
      if FMsgList.Count > 0 then begin
         pMsgItem := FMsgList[0];
         BatMsgItem := pMsgItem^;
         FMsgList.Delete(0);
         Dispose(pMsgItem);
//         BatMsgText := FMsgStringList[0];
//         FMsgStringList.Delete (0);
         BatMsgDelay := CurTick;

         case BatMsgItem.rLines of
         1: begin
               ChatMan.AddChat(BatMsgItem.rLine1, BatMsgItem.rColor, 0);
            end;
         2: begin
               ChatMan.AddChat(BatMsgItem.rLine1, BatMsgItem.rColor, 0);
               ChatMan.AddChat(BatMsgItem.rLine2, BatMsgItem.rColor, 0);
            end;
         3: begin
               ChatMan.AddChat(BatMsgItem.rLine1, BatMsgItem.rColor, 0);
               ChatMan.AddChat(BatMsgItem.rLine2 + ' - ' + BatMsgItem.rLine3, BatMsgItem.rColor, 0);
            end;
         end;
      end else begin
         FShowBatMsg := FALSE;
      end;
   end;

   if BatMsgItem.rOptions = 0 then begin
      ShowBatX := 104;
      ShowBatY := 145;
   end else begin
      ShowBatX := 0;
      ShowBatY := 0;
   end;

   BackScreen.Back.DrawImageKeyColor (PersonBatLib.Images[8], ShowBatx, ShowBaty, 31,@Darkentbl);
   BackScreen.Back.DrawImageKeyColor (PersonBatLib.Images[9], PersonBatLib.Images[8].Width+ShowBatx-2, ShowBaty+2, 31,@Darkentbl);

   case BatMsgItem.rLines of
   1: begin
         n := ATextWidth (BatMsgItem.rLine1);
         ATextOut(BackScreen.Back, ShowBatx+(126-(n div 2)), ShowBaty+26, BatMsgItem.rColor, BatMsgItem.rLine1);
      end;
   2: begin
         ATextOut(BackScreen.Back, ShowBatx+10, ShowBaty+10+8,  BatMsgItem.rColor, BatMsgItem.rLine1);
         ATextOut(BackScreen.Back, ShowBatx+10, ShowBaty+10+26, BatMsgItem.rColor, BatMsgItem.rLine2);
      end;
   3: begin
         ATextOut(BackScreen.Back, ShowBatx+10,  ShowBaty+10, BatMsgItem.rColor, BatMsgItem.rLine1);
         ATextOut(BackScreen.Back, ShowBatx+10,  ShowBaty+28, BatMsgItem.rColor, BatMsgItem.rLine2);
         ATextOut(BackScreen.Back, ShowBatx+150, ShowBaty+46, BatMsgItem.rColor, BatMsgItem.rLine3);
      end;
   end;
end;

end.
