unit uGroup;

interface

uses
   Classes, SysUtils, BSCommon, UserSDB, AUtil32, DefType, uConnect, AnsImg2;

const
   OWNER_XPOS     = 17;
   FIGHTER_XPOS   = 20;
   BOTH_YPOS      = 18;
   WIN_SCORE      = 2;
   TOTAL_SCORE    = 3;
   DOUMI_CHAR     = '도우미';

type
   TBattleRoomStatus = ( brs_none, brs_waitfighter, brs_ready, brs_readyfight, brs_fighting, brs_nextready, brs_end );
   TBattleRoom = class
   private
      RoomNo : Integer;

      RoomStatus : TBattleRoomStatus;
      ViewerList : TList;
      JoinList : TList;
      FboAllowDelete : Boolean;
      FboRoomGrade : Boolean;

      function GetViewerCount : Integer;
      function GetJoinCount : Integer;
   public
      Title : String;
      Owner : String;          // 이름 + 서버
      Fighter : String;        // 이름 + 서버

      OwnerName : String;      // 순수 이름
      FighterName : String;    // 순수 이름
      OwnerServer : String;    // 서버명
      FighterServer : String;  // 서버명

      Stage : Integer;
      OwnerWin : Integer;
      FighterWin : Integer;
      Winner : String;
      Loser : String;
      OwnerXpos : Integer;
      FighterXpos : Integer;
      OwnerDir : Integer;
      FighterDir : Integer;
      OwnerPercent : Integer;
      FighterPercent : Integer;
      OwnerMotion : Integer;
      FighterMotion : Integer;
      BattleType : Integer;

      BattleStartTick : Integer;
      StatusElapsedTick : Integer;

      OwnerConnector : Pointer;
      FighterConnector : Pointer;
      OwnerUser : Pointer;
      FighterUser : Pointer;

      Phone : Pointer;
      Maper : Pointer;
      UserList : Pointer;

      ServerID : integer;
      Directory : String;
      SmpName : String;
      MapName : String;
      ObjName : String;
      RofName : String;
      TilName : String;
      SoundBase : String;

      boUseDrug : Boolean;
      boGetExp : Boolean;
      boBigSay : Boolean;
      boMakeGuild : Boolean;
      boPosDie : Boolean;
      boHit : Boolean;
      boWeather : Boolean;
      boPrison : Boolean;

      constructor Create (aOwnerConnector : TConnector; aOwner : String; aRoomNo : Integer);
      destructor Destroy; override;

      procedure Update (CurTick : Integer);

      procedure RemakeBattleChar (aStage : Integer);

      procedure RemoveConnector (aConnector : TConnector);
      procedure ExitConnector (aConnector : TConnector);

      procedure AddViewerConnector (aConnector : TConnector);
      procedure RemoveViewerConnector (aConnector : TConnector);
      function  GetViewerConnector (aIndex : Integer) : TConnector;

      procedure AddJoinConnector (aConnector : TConnector);
      procedure RemoveJoinConnector (aConnector : TConnector);

      procedure SetBattleBar (aSenderInfo : TBasicData; aPercent : Integer);
      procedure SetUserMotion (aSenderInfo : TBasicData; aMotion : Integer);      

      procedure SendWatchMessage (aStr : String; aColor : Byte);
      procedure SendWatchMap;
      procedure SendRankData (aConnector : TConnector);
      procedure SendResultData (aOwnerWin, aFighterWin, aOwnerDisCon, aFighterDisCon : Integer);

      procedure KickOutChar (aName : String);
      function  SearchConnector (aCharName : String) : TConnector;
      procedure ExitViewerConnector (aConnector : TConnector);                

      function GetRoomString : String;
      function GetViewerString : String;

      property ViewerCount : Integer read GetViewerCount;
      property JoinCount : Integer read GetJoinCount;
      property BattleRoomStatus : TBattleRoomStatus read RoomStatus;
      property RoomGrade : Boolean read FboRoomGrade write FboRoomGrade;
   end;

   TBattleGroup = class             // RoomList;
   private
      Name : String;
      ViewName : String;
      RoomLimit : Integer;
      MinAge : Integer;
      MaxAge : Integer;
      boGrade : Boolean;

      DataList : TList;

      function Get (aIndex : Integer) : Pointer;
      function GetCount : Integer;
   public
      constructor Create (aGroupData : PTCreateGroupData);
      destructor Destroy; override;

      function CreateBattleRoom (aOwnerConnector : TConnector; aOwner : String; var aRetStr : String) : TBattleRoom;
      function FightBattleRoom (aFighterConnector : TConnector; aTitle, aFighter : String; var aRetStr : String) : TBattleRoom;
      function ViewBattleRoom (aTitle : String; var aRetStr : String) : TBattleRoom;

      // procedure DeleteBattleRoom (aRoom : TBattleRoom);

      procedure Update (CurTick : Integer);

      procedure GetBattleRoomData (aRoomList : PTSShowListWindow; aType : Byte);

      procedure ShowRoomTitleList;
      function GetGroupString : String;

      property Items [aIndex : Integer] : Pointer read Get;
      property Count : Integer read GetCount;
   end;

   TBattleGroupList = class         // BattleGroupList;
   private
      DataList : TList;

      function GetCount : Integer;
      function Get (aIndex : Integer) : Pointer;
   public
      constructor Create;
      destructor Destroy; override;

      function LoadFromFile (aFileName : String) : Boolean;

      procedure Update (CurTick : Integer);

      procedure GetBattleGroupData (aGroupList : PTSShowListWindow; aType : Byte);
      procedure GetBattleRoomData (aRoomList : PTSShowListWindow; aGroupTitle : String; aType : Byte);

      function CreateBattleRoom (aOwnerConnector : TConnector; aGroupTitle, aOwnerName : String; var aRetStr : String) : TBattleRoom;
      function FightBattleRoom (aFighterConnector : TConnector; aGroupTitle, aRoomTitle, aFighterName : String; var aRetStr : String) : TBattleRoom;
      function ViewBattleRoom (aGroupTitle, aRoomTitle : String; var aRetStr : String) : TBattleRoom;

      procedure ShowRoomTitleList (aGroupTitle : String);

      property Items [aIndex : Integer] : Pointer read Get;
      property Count : Integer read GetCount;
   end;

var
   BattleGroupList : TBattleGroupList;
   ShareRoom : TBattleRoom;

   boUseShareRoom : Boolean = false;

implementation

uses
   MapUnit, FieldMsg, uUser, SVMain;

// TBattleRoom;
constructor TBattleRoom.Create (aOwnerConnector : TConnector; aOwner : String; aRoomNo : Integer);
var
   OwnerPoints : Integer; 
begin
   Owner := aOwner;
   Fighter := '';

   OwnerName := '';
   FighterName := '';
   OwnerServer := '';
   FighterServer := '';

   Stage := 0;
   OwnerWin := 0;
   FighterWin := 0;
   Winner := '';
   Loser := '';

   OwnerXpos := 0;
   FighterXpos := 0;
   OwnerDir := 0;
   FighterDir := 0;
   OwnerPercent := 100;
   FighterPercent := 100;
   OwnerMotion := AM_NONE;
   FighterMotion := AM_NONE;
   BattleType := 2;
   FboRoomGrade := false;

   OwnerConnector := aOwnerConnector;
   FighterConnector := nil;

   OwnerUser := nil;
   FighterUser := nil;

   RoomNo := aRoomNo;

   OwnerPoints := 0;
   if OwnerConnector <> nil then
      OwnerPoints := TConnector (OwnerConnector).Points;
//   Title := format ('%d %s [%d]', [RoomNo, Owner, OwnerPoints]);
   Title := format ('%s [%d]', [Owner, OwnerPoints]);

   if OwnerConnector = nil then begin
      Maper := TMaper.Create ('.\Smp\Server2.smp');
      Phone := TFieldPhone.Create (Self);

      ServerID := 0;
      Directory := '.\smp\';
      SmpName := 'Server2.smp';
      MapName := 'Server2.map';
      ObjName := 'BSMapobj.obj';
      RofName := 'BSMaprof.rof';
      TilName := 'BSmaptil.til';
      SoundBase := '1401';
   end else begin
      Maper := TMaper.Create ('.\Smp\BSMap.smp');
      Phone := TFieldPhone.Create (Self);

      ServerID := 0;
      Directory := '.\smp\';
      SmpName := 'BSMap.smp';
      MapName := 'BSMap.map';
      ObjName := 'BSMapobj.obj';
      RofName := 'BSMaprof.rof';
      TilName := 'BSMaptil.til';
      SoundBase := '1401';
   end;

   boUseDrug := false;
   boGetExp := false;
   boBigSay := true;
   boMakeGuild := false;
   boPosDie := false;
   boHit := true;
   boWeather := false;
   boPrison := false;

   FboAllowDelete := false;
   RoomStatus := brs_none;

   UserList := TUserList.Create (100);
   ViewerList := TList.Create;
   JoinList := TList.Create;
end;

destructor TBattleRoom.Destroy;
var
   i : Integer;
   Connector : TConnector;
begin
   if (Stage > 0) and (Stage < TOTAL_SCORE) then begin
      if FboRoomGrade = true then begin
         SendResultData (OwnerWin, FighterWin, 1, 0);
      end;
   end;

   if OwnerConnector <> nil then begin
      TUserList (UserList).FinalLayer (OwnerConnector);
      TConnector (OwnerConnector).ExitBattleRoom;
   end;
   if FighterConnector <> nil then begin
      TUserList (UserList).FinalLayer (FighterConnector);
      TConnector (FighterConnector).ExitBattleRoom;
   end;
   for i := 0 to ViewerList.Count - 1 do begin
      Connector := ViewerList.Items [i];
      Connector.ExitBattleRoom;
   end;

   ViewerList.Clear;
   ViewerList.Free;

   if OwnerConnector = nil then begin
      for i := 0 to JoinList.Count - 1 do begin
         Connector := JoinList.Items [i];
         Connector.ExitShareRoom;
      end;

      JoinList.Clear;
      JoinList.Free;
   end;

   TMaper (Maper).Free;
   TFieldPhone (Phone).Free;
   TUserList (UserList).Free;

   inherited Destroy;
end;

function TBattleRoom.GetRoomString : String;
var
   FighterPoints : Integer;
begin
   FighterPoints := 0;

   if FighterConnector <> nil then
      FighterPoints := TConnector (FighterConnector).Points;

   if Fighter = '' then begin
      Result := Title + ':' + ' ( 대기중 ) ' + ':' + '관람 ' + IntToStr (ViewerList.Count) + '명';
   end else begin
      Result := Title + ':' + ' ' + Fighter + ' [' + IntToStr (FighterPoints) + ']' + ' ' + ':' + '관람 ' + IntToStr (ViewerList.Count) + '명';
   end;
end;

function TBattleRoom.GetViewerString : String;
var
   i : Integer;
   Connector : TConnector;
   Str, rdStr : String;
begin
   Result := '';

   Str := ''; rdStr := '';
   for i := 0 to ViewerList.Count - 1 do begin
      Connector := ViewerList.Items [i];
      rdStr := rdStr + Connector.Name;
      if i < ViewerList.Count - 1 then begin
         rdStr := rdStr + ' ';
      end;
      if Length (rdStr) > 40 then begin
         Str := ' ' + Str + rdStr + #13;
         rdStr := '';
      end;
   end;

   if rdStr <> '' then
      Str := ' ' + Str + rdStr + #13;

   Result := Str;
end;

function TBattleRoom.GetViewerCount : Integer;
begin
   Result := ViewerList.Count;
end;

procedure TBattleRoom.AddViewerConnector (aConnector : TConnector);
begin
   ViewerList.Add (aConnector);
end;

procedure TBattleRoom.RemoveViewerConnector (aConnector : TConnector);
var
   i : Integer;
   tmpConnector : TConnector;
begin
   for i := 0 to ViewerList.Count - 1 do begin
      tmpConnector := ViewerList.Items [i];
      if tmpConnector = aConnector then begin
         ViewerList.Delete (i);
         tmpConnector.ExitBattleRoom;
         exit;
      end;
   end;
end;

function TBattleRoom.GetJoinCount : Integer;
begin
   Result := JoinList.Count;
end;

procedure TBattleRoom.AddJoinConnector (aConnector : TConnector);
begin
   JoinList.Add (aConnector);
end;

procedure TBattleRoom.RemoveJoinConnector (aConnector : TConnector);
var
   i : Integer;
   tmpConnector : TConnector;
begin
   for i := 0 to JoinList.Count - 1 do begin
      tmpConnector := JoinList.Items [i];
      if tmpConnector = aConnector then begin
         JoinList.Delete (i);
         exit;
      end;
   end;
end;

function TBattleRoom.GetViewerConnector (aIndex : Integer) : TConnector;
begin
   Result := nil;

   if ViewerList.Count = 0 then exit;
   if aIndex >= ViewerList.Count then exit;

   Result := ViewerList.Items [aIndex];
end;

procedure TBattleRoom.Update (CurTick : Integer);
var
   Users : TUserList;
   OwnConnector, FgtConnector : TConnector;
   OwnUser, FgtUser : TUser;
begin
   Users := nil;
   
   if UserList <> nil then begin
      Users := TUserList (UserList);
      Users.Update (CurTick);
   end;

   if OwnerConnector = nil then exit;

   if (OwnerUser = nil) and (Owner <> '') then begin
      OwnerUser := Users.GetUserPointer (Owner);
   end;
   if (FighterUser = nil) and (Fighter <> '') then begin
      FighterUser := Users.GetUserPointer (Fighter);
   end;

   // Users.Update (CurTick);

   if (Fighter = '') and (RoomStatus <> brs_waitfighter) and
      (RoomStatus <> brs_none) then begin
      RoomStatus := brs_none;
      if (Stage > 0) and (Stage < TOTAL_SCORE) then begin
         if FboRoomGrade = true then begin
            SendResultData (OwnerWin, FighterWin, 0, 1);
         end;
      end;
   end;

   OwnConnector := TConnector (OwnerConnector);
   FgtConnector := TConnector (FighterConnector);
   OwnUser := TUser (OwnerUser);
   FgtUser := TUser (FighterUser);

   Case RoomStatus of
      brs_none :
         begin
            if OwnerUser <> nil then begin
               OwnUser.SendClass.SendShowCenterMessage('대련 상대자가 들어올때까지 대기하여 주세요', WinRGB(31, 31, 31));
               RoomStatus := brs_waitfighter;
            end;
         end;
      brs_waitfighter :
         begin
            if (OwnerUser <> nil) and (FighterUser <> nil) then begin
               SendRankData (OwnConnector);
               SendRankData (FgtConnector);

               OwnerName := OwnConnector.CharName;
               FighterName := FgtConnector.CharName;
               OwnerServer := OwnConnector.ServerName;
               FighterServer := FgtConnector.ServerName;

               OwnUser.SendRefillMessage (OwnUser.BasicData.ID, OwnUser.BasicData);
               FgtUser.SendRefillMessage (FgtUser.BasicData.ID, FgtUser.BasicData);

               OwnUser.SendClass.SendBattleBar (Owner, Fighter, OwnerWin, FighterWin, OwnerPercent, FighterPercent, BattleType);
               FgtUser.SendClass.SendBattleBar (Owner, Fighter, OwnerWin, FighterWin, OwnerPercent, FighterPercent, BattleType);

               if OwnUser.BasicData.X <> OWNER_XPOS then begin
                  OwnerXpos := OWNER_XPOS;
                  OwnerDir := DR_2;

                  OwnUser.EndUser;

                  OwnUser.BasicData.X := OwnerXpos;
                  OwnUser.BasicData.Y := BOTH_YPOS;
                  OwnUser.BasicData.Dir := OwnerDir;
//                  OwnUser.BasicData.Feature.rfeaturestate := wfs_normal;

                  OwnUser.SendClass.SendMap (OwnUser.BasicData, OwnUser.Manager.MapName,
                     OwnUser.Manager.ObjName, OwnUser.Manager.RofName,
                     OwnUser.Manager.TilName, OwnUser.Manager.SoundBase);

                  OwnUser.StartUser;
                  OwnUser.SetActionState (as_ice);
               end;

               OwnUser.SendClass.SendShowCenterMessage (format ('%s님이 대련상대자로,들어오셨습니다', [Fighter]), WinRGB (31, 31, 31));
               FgtUser.SendClass.SendShowCenterMessage (format ('%s님을 대련상대자로,선택하셨습니다', [Owner]), WinRGB (31, 31, 31));
               OwnUser.SendClass.SendChatMessage (format ('%s님의 전적은 %d승 %d패 %d끊김 %d점 %d위 입니다',
                  [Fighter, FgtConnector.Win, FgtConnector.Lose, FgtConnector.DisConnected, FgtConnector.Points, FgtConnector.Grade]), SAY_COLOR_SYSTEM);
               FgtUser.SendClass.SendChatMessage (format ('%s님의 전적은 %d승 %d패 %d끊김 %d점 %d위 입니다',
                  [Owner, OwnConnector.Win, OwnConnector.Lose, OwnConnector.DisConnected, OwnConnector.Points, OwnConnector.Grade]), SAY_COLOR_SYSTEM);

//               BattleStartTick := CurTick;
               StatusElapsedTick := CurTick;

               RoomStatus := brs_ready;
            end;
         end;
      brs_ready :
         begin
            OwnUser.SendClass.SendShowCenterMessage ('대련준비 하십시오', WinRGB (31, 31, 31));
            FgtUser.SendClass.SendShowCenterMessage ('대련준비 하십시오', WinRGB (31, 31, 31));
            OwnUser.SendClass.SendShowCenterMessage ('준비가 끝나면 인사(F4)하십시오', WinRGB (31, 31, 31));
            FgtUser.SendClass.SendShowCenterMessage ('준비가 끝나면 인사(F4)하십시오', WinRGB (31, 31, 31));

            OwnerXpos := OWNER_XPOS;
            FighterXpos := FIGHTER_XPOS;
            OwnerDir := DR_2;
            FighterDir := DR_6;
            StatusElapsedTick := CurTick;

            Stage := 0;
            OwnerWin := 0;
            FighterWin := 0;

            RoomStatus := brs_readyfight;
         end;
      brs_readyfight :
         begin
            if CurTick > StatusElapsedTick + 4000 then begin
               OwnConnector.SendShowCenterMessage ('준비시간이 경과되어,대련은 중지됩니다', WinRGB (31, 31, 31));
               FgtConnector.SendShowCenterMessage ('준비시간이 경과되어,대련은 중지됩니다', WinRGB (31, 31, 31));
               FboAllowDelete := true;
               StatusElapsedTick := CurTick;
               exit;
            end;

            if Stage >= 1 then begin
               if (OwnUser.BasicData.X = OwnerXpos) and (OwnUser.BasicData.Y = BOTH_YPOS) and
                  (OwnUser.BasicData.Dir = OwnerDir) then begin
                  if (FgtUser.BasicData.X = FighterXpos) and (FgtUser.BasicData.Y = BOTH_YPOS) and
                     (FgtUser.BasicData.Dir = FighterDir) then begin

                     OwnUser.SendClass.SendShowCenterMessage ('자리를 옮겨 대련을 시작합니다', WinRGB (31, 31, 31));
                     FgtUser.SendClass.SendShowCenterMessage ('자리를 옮겨 대련을 시작합니다', WinRGB (31, 31, 31));

                     OwnUser.SendClass.SendShowCenterMessage ('준비하십시오', WinRGB (31, 31, 31));
                     FgtUser.SendClass.SendShowCenterMessage ('준비하십시오', WinRGB (31, 31, 31));

                     inc (Stage);

                     OwnUser.SendClass.SendShowCenterMessage (format ('STAGE %d', [Stage]), WinRGB (31, 31, 31));
                     FgtUser.SendClass.SendShowCenterMessage (format ('STAGE %d', [Stage]), WinRGB (31, 31, 31));

                     StatusElapsedTick := CurTick;
                     BattleStartTick := CurTick;
                     RoomStatus := brs_fighting;
                     exit;
                  end;
               end;
            end else begin
               if (OwnUser.BasicData.X = OwnerXpos) and (OwnUser.BasicData.Y = BOTH_YPOS) and
                  (OwnUser.BasicData.Dir = OwnerDir) and (OwnerMotion = AM_HELLO) then begin
                  if (FgtUser.BasicData.X = FighterXpos) and (FgtUser.BasicData.Y = BOTH_YPOS) and
                     (FgtUser.BasicData.Dir = FighterDir) and (FighterMotion = AM_HELLO) then begin

                     OwnUser.SendRefillMessage (OwnUser.BasicData.ID, OwnUser.BasicData);
                     FgtUser.SendRefillMessage (FgtUser.BasicData.ID, FgtUser.BasicData);
                     OwnUser.SendClass.SendBattleBar (Owner, Fighter, OwnerWin, FighterWin, OwnerPercent, FighterPercent, BattleType);
                     FgtUser.SendClass.SendBattleBar (Owner, Fighter, OwnerWin, FighterWin, OwnerPercent, FighterPercent, BattleType);

                     OwnUser.SendClass.SendShowCenterMessage ('대련을 시작합니다', WinRGB (31, 31, 31));
                     FgtUser.SendClass.SendShowCenterMessage ('대련을 시작합니다', WinRGB (31, 31, 31));

                     inc (Stage);

                     OwnUser.SendClass.SendShowCenterMessage (format ('STAGE %d', [Stage]), WinRGB (31, 31, 31));
                     FgtUser.SendClass.SendShowCenterMessage (format ('STAGE %d', [Stage]), WinRGB (31, 31, 31));

                     OwnerMotion := AM_NONE;
                     FighterMotion := AM_NONE;

                     StatusElapsedTick := CurTick;
                     BattleStartTick := CurTick;
                     RoomStatus := brs_fighting;
                     exit;
                  end;
               end;;
            end;
         end;
      brs_fighting :
         begin
            if OwnConnector.WaitTick = 0 then begin
               if OwnUser.GetActionState = as_ice then begin
                  OwnUser.SetActionState (as_free);
                  FgtUser.SetActionState (as_free);
                  OwnConnector.WaitStartTick := 0;
                  FgtConnector.WaitStartTick := 0;
               end;
            end;

            StatusElapsedTick := CurTick;
{
            if TUser (OwnerUser).BasicData.dir <> OwnerDir then begin
               TUser (OwnerUser).SendClass.SendChatMessage (format ('%s님이 자리이탈로 패하셨습니다', [Owner]), WinRGB (31, 31, 31));
               TUser (FighterUser).SendClass.SendChatMessage (format ('%s님이 자리이탈로 패하셨습니다', [Owner]), WinRGB (31, 31, 31));
               inc (FighterWin);
               RoomStatus := brs_nextready;
               exit;
            end else if TUser (FighterUser).BasicData.dir <> FighterDir then begin
               TUser (OwnerUser).SendClass.SendChatMessage (format ('%s님이 자리이탈로 패하셨습니다. 다음대련으로 넘어갑니다', [Owner]), WinRGB (31, 31, 31));
               TUser (FighterUser).SendClass.SendChatMessage (format ('%s님이 자리이탈로 패하셨습니다. 다음대련으로 넘어갑니다', [Owner]), WinRGB (31, 31, 31));
               inc (OwnerWin);
               RoomStatus := brs_nextready;
               exit;
            end;
}

            if OwnUser.BasicData.Feature.rfeaturestate = wfs_die then begin
               inc (FighterWin);
               OwnUser.SendClass.SendShowCenterMessage (format ('%s님이 %d승 하셨습니다.', [Fighter, FighterWin]), WinRGB (31, 31, 31));
               FgtUser.SendClass.SendShowCenterMessage (format ('%s님이 %d승 하셨습니다.', [Fighter, FighterWin]), WinRGB (31, 31, 31));
               RoomStatus := brs_nextready;
               exit;
            end else if FgtUser.BasicData.Feature.rfeaturestate = wfs_die then begin
               inc (OwnerWin);
               OwnUser.SendClass.SendShowCenterMessage (format ('%s님이 %d승 하셨습니다.', [Owner, OwnerWin]), WinRGB (31, 31, 31));
               FgtUser.SendClass.SendShowCenterMessage (format ('%s님이 %d승 하셨습니다.', [Owner, OwnerWin]), WinRGB (31, 31, 31));
               RoomStatus := brs_nextready;
               exit;
            end;

            if CurTick > BattleStartTick + 8000 then begin
               if OwnerPercent > FighterPercent then begin
                  inc (OwnerWin);
                  OwnUser.SendClass.SendShowCenterMessage (format ('%s님이 %d승 하셨습니다.', [Owner, OwnerWin]), WinRGB (31, 31, 31));
                  FgtUser.SendClass.SendShowCenterMessage (format ('%s님이 %d승 하셨습니다.', [Owner, OwnerWin]), WinRGB (31, 31, 31));
                  RoomStatus := brs_nextready;
                  exit;
               end else if OwnerPercent < FighterPercent then begin
                  inc (FighterWin);
                  OwnUser.SendClass.SendShowCenterMessage (format ('%s님이 %d승 하셨습니다.', [Fighter, FighterWin]), WinRGB (31, 31, 31));
                  FgtUser.SendClass.SendShowCenterMessage (format ('%s님이 %d승 하셨습니다.', [Fighter, FighterWin]), WinRGB (31, 31, 31));
                  RoomStatus := brs_nextready;
                  exit;
               end else if OwnerPercent = FighterPercent then begin
                  OwnUser.SendClass.SendShowCenterMessage ('대련시간이 경과하여 대련을 종료합니다', WinRGB (31, 31, 31));
                  FgtUser.SendClass.SendShowCenterMessage ('대련시간이 경과하여 대련을 종료합니다', WinRGB (31, 31, 31));
                  FboAllowDelete := true;
                  BattleStartTick := CurTick;
                  exit;
               end;

               BattleStartTick := CurTick;
            end;
         end;
      brs_nextready :
         begin
            {
            if Stage < TOTAL_SCORE then begin
               if CurTick > StatusElapsedTick + 500 then begin
                  RemakeBattleChar (Stage);
                  StatusElapsedTick := CurTick;
               end;
            end;

            if CurTick > StatusElapsedTick + 500 then begin
               if Stage = 3 then begin
                  OwnUser.SetActionState (as_ice);
                  FgtUser.SetActionState (as_ice);

                  if OwnerWin = WIN_SCORE then begin
                     Winner := Owner;
                     Loser := Fighter;
                     OwnUser.SendClass.SendShowCenterMessage (format ('%d : %d 로 %s님이,승리하셨습니다', [OwnerWin, FighterWin, Winner]), WinRGB (31, 31, 31));
                     FgtUser.SendClass.SendShowCenterMessage (format ('%d : %d 로 %s님이,패하셨습니다', [OwnerWin, FighterWin, Loser]), WinRGB (31, 31, 31));
                  end else if FighterWin = WIN_SCORE then begin
                     Winner := Fighter;
                     Loser := Owner;
                     OwnUser.SendClass.SendShowCenterMessage (format ('%d : %d 로 %s님이,패하셨습니다', [FighterWin, OwnerWin, Loser]), WinRGB (31, 31, 31));
                     FgtUser.SendClass.SendShowCenterMessage (format ('%d : %d 로 %s님이,승리하셨습니다', [FighterWin, OwnerWin, Winner]), WinRGB (31, 31, 31));
                  end;

                  if FboRoomGrade = true then begin
                     SendResultData (OwnerWin, FighterWin, 0, 0);
                  end;

                  OwnUser.SendClass.SendShowCenterMessage ('대련이 끝났습니다,F4를 누르면 나갈 수 있습니다', WinRGB (31, 31, 31));
                  FgtUser.SendClass.SendShowCenterMessage ('대련이 끝났습니다,F4를 누르면 나갈 수 있습니다', WinRGB (31, 31, 31));

                  RoomStatus := brs_end;
               end;
            end;
            }

            if CurTick <= StatusElapsedTick + 700 then exit;

            RemakeBattleChar (Stage);
            StatusElapsedTick := CurTick;

            if (OwnerWin = WIN_SCORE) or (FighterWin = WIN_SCORE) then begin
               OwnUser.SetActionState (as_ice);
               FgtUser.SetActionState (as_ice);

               if OwnerWin = WIN_SCORE then begin
                  Winner := Owner;
                  Loser := Fighter;
                  OwnUser.SendClass.SendShowCenterMessage (format ('%d : %d 로 %s님이,승리하셨습니다', [OwnerWin, FighterWin, Winner]), WinRGB (31, 31, 31));
                  FgtUser.SendClass.SendShowCenterMessage (format ('%d : %d 로 %s님이,패하셨습니다', [OwnerWin, FighterWin, Loser]), WinRGB (31, 31, 31));
               end else if FighterWin = WIN_SCORE then begin
                  Winner := Fighter;
                  Loser := Owner;
                  OwnUser.SendClass.SendShowCenterMessage (format ('%d : %d 로 %s님이,패하셨습니다', [FighterWin, OwnerWin, Loser]), WinRGB (31, 31, 31));
                  FgtUser.SendClass.SendShowCenterMessage (format ('%d : %d 로 %s님이,승리하셨습니다', [FighterWin, OwnerWin, Winner]), WinRGB (31, 31, 31));
               end;

               OwnerMotion := AM_NONE;
               FighterMotion := AM_NONE;

               if FboRoomGrade = true then begin
                  SendResultData (OwnerWin, FighterWin, 0, 0);
               end;

               OwnUser.SendClass.SendShowCenterMessage ('대련이 끝났습니다,F4를 누르면 나갈 수 있습니다', WinRGB (31, 31, 31));
               FgtUser.SendClass.SendShowCenterMessage ('대련이 끝났습니다,F4를 누르면 나갈 수 있습니다', WinRGB (31, 31, 31));

               inc (Stage);
               RoomStatus := brs_end;
            end else begin
               RoomStatus := brs_readyfight;
            end;
         end;
      brs_end :
         begin
            if (OwnerMotion = AM_HELLO) or (FighterMotion = AM_HELLO) then begin
               FboAllowDelete := true;
            end;

            if CurTick > StatusElapsedTick + 30000 then begin
               FboAllowDelete := true;
            end;
         end;

   end;
end;

procedure TBattleRoom.RemakeBattleChar (aStage : Integer);
begin
   if (aStage mod 2) = 1 then begin
      OwnerXpos := FIGHTER_XPOS;
      FighterXpos := OWNER_XPOS;
      OwnerDir := DR_6;
      FighterDir := DR_2;
   end else begin
      OwnerXpos := OWNER_XPOS;
      FighterXpos := FIGHTER_XPOS;
      OwnerDir := DR_2;
      FighterDir := DR_6;
   end;

   TUser (FighterUser).EndUser;
   TUser (OwnerUser).EndUser;

   TUser (OwnerUser).BasicData.X := OwnerXpos;
   TUser (OwnerUser).BasicData.Y := BOTH_YPOS;
   TUser (OwnerUser).BasicData.Dir := OwnerDir;
//   TUser (OwnerUser).CommandChangeCharState (wfs_normal, false);
   // TUser (OwnerUser).BasicData.Feature.rfeaturestate := wfs_normal;
   TUser (FighterUser).BasicData.X := FighterXpos;
   TUser (FighterUser).BasicData.Y := BOTH_YPOS;
   TUser (FighterUser).BasicData.Dir := FighterDir;
//   TUser (FighterUser).CommandChangeCharState (wfs_normal, false);
   // TUser (FighterUser).BasicData.Feature.rfeaturestate := wfs_normal;

   TUser (OwnerUser).SendClass.SendMap (TUser (OwnerUser).BasicData,
      TUser (OwnerUser).Manager.MapName, TUser (OwnerUser).Manager.ObjName,
      TUser (OwnerUser).Manager.RofName, TUser (OwnerUser).Manager.TilName,
      TUser (OwnerUser).Manager.SoundBase);
   TUser (FighterUser).SendClass.SendMap (TUser (FighterUser).BasicData,
      TUser (FighterUser).Manager.MapName, TUser (FighterUser).Manager.ObjName,
      TUser (FighterUser).Manager.RofName, TUser (FighterUser).Manager.TilName,
      TUser (FighterUser).Manager.SoundBase);

   TUser (OwnerUser).StartUser;
   TUser (FighterUser).StartUser;

   TUser (OwnerUser).SetActionState (as_ice);
   TUser (FighterUser).SetActionState (as_ice);

   TUser (OwnerUser).SendRefillMessage (TUser (OwnerUser).BasicData.ID, TUser(OwnerUser).BasicData);
   TUser (FighterUser).SendRefillMessage (TUser (FighterUser).BasicData.ID, TUser(FighterUser).BasicData);

   OwnerPercent := 100;
   FighterPercent := 100;

   if (aStage mod 2) = 1 then begin
      TUser (OwnerUser).SendClass.SendBattleBar (Fighter, Owner, FighterWin, OwnerWin, 100, 100, BattleType);
      TUser (FighterUser).SendClass.SendBattleBar (Fighter, Owner, FighterWin, OwnerWin, 100, 100, BattleType);

      // RoomStatus := brs_readyfight;
      // exit;
   end else begin
      TUser (OwnerUser).SendClass.SendBattleBar (Owner, Fighter, OwnerWin, FighterWin, 100, 100, BattleType);
      TUser (FighterUser).SendClass.SendBattleBar (Owner, Fighter, OwnerWin, FighterWin, 100, 100, BattleType);

      {
      if (OwnerWin = WIN_SCORE) or (FighterWin = WIN_SCORE) then begin
         inc (Stage);
         exit;
      end else begin
         RoomStatus := brs_readyfight;
         exit;
      end;
      }
   end;
end;

procedure TBattleRoom.RemoveConnector (aConnector : TConnector);
begin
   if OwnerConnector = nil then exit;

   if OwnerUser <> nil then begin
      if OwnerConnector = aConnector then begin
         FboAllowDelete := true;
         TUserList (UserList).FinalLayer (OwnerConnector);
         OwnerConnector := nil;
         OwnerUser := nil;
         Owner := '';
         exit;
      end;
      if FighterConnector = aConnector then begin
         TUserList (UserList).FinalLayer (FighterConnector);
         TConnector (FighterConnector).ExitBattleRoom;
         FighterConnector := nil;
         FighterUser := nil;
         Fighter := '';
         exit;
      end;
   end;

   RemoveViewerConnector (aConnector);
end;

procedure TBattleRoom.ExitConnector (aConnector : TConnector);
var
   prd : PTSShowListWindow;
   ComData : TWordComData;
   Str : String;
begin
   if OwnerConnector = nil then exit;

   if OwnerConnector = aConnector then begin
      FboAllowDelete := true;
      exit;
   end;
   if FighterConnector = aConnector then begin
      TUserList (UserList).FinalLayer (FighterConnector);
      TConnector (FighterConnector).ExitBattleRoom;
      FighterConnector := nil;
      FighterUser := nil;
      Fighter := '';
   end else begin
      RemoveViewerConnector (aConnector);
   end;

   prd := @ComData.Data;
   prd^.rMsg := SM_SHOWSPECIALWINDOW;
   prd^.rWindow := WINDOW_ROOMWINDOW;
   prd^.rType := 3;
   Str := GetRoomString;
   SetWordString (prd^.rWordString, str);
   ComData.Cnt := sizeof(TSShowListWindow) - sizeof(TWordString) + sizeofwordstring(prd^.rWordString);
   ConnectorList.SendLatestRoomList (aConnector.GroupTitle, @ComData, ComData.Cnt + SizeOf (Word));
//   ConnectorList.SendLatestList (ws_room, @ComData, ComData.Cnt + SizeOf (Word));
end;

procedure TBattleRoom.SetBattleBar (aSenderInfo : TBasicData; aPercent : Integer);
begin
   if OwnerUser = nil then exit;
   if aSenderInfo.id = TUser (OwnerUser).BasicData.id then begin
      OwnerPercent := aPercent;
   end else if aSenderInfo.id = TUser (FighterUser).BasicData.id then begin
      FighterPercent := aPercent;
   end;
end;

procedure TBattleRoom.SetUserMotion (aSenderInfo : TBasicData; aMotion : Integer);
begin
   if OwnerUser = nil then exit;
   if aSenderInfo.id = TUser (OwnerUser).BasicData.id then begin
      OwnerMotion := aMotion;
   end else if aSenderInfo.id = TUser (FighterUser).BasicData.id then begin
      FighterMotion := aMotion;
   end;
end;

procedure TBattleRoom.SendWatchMessage (aStr : String; aColor : Byte);
var
   i : Integer;
   Connector : TConnector;
begin
   if ViewerList.Count <= 0 then exit;

   if OwnerUser <> nil then begin
      if OwnerConnector <> nil then begin
         TConnector (OwnerConnector).SendChatMessage (aStr, aColor);
      end;
      if FighterConnector <> nil then begin
         TConnector (FighterConnector).SendChatMessage (aStr, aColor);
      end;
      for i := 0 to ViewerList.Count - 1 do begin
         Connector := ViewerList.Items [i];
         Connector.SendChatMessage (aStr, aColor);
      end;
   end else begin
      for i := 0 to JoinList.Count - 1 do begin
         Connector := JoinList.Items [i];
         Connector.SendChatMessage (aStr, aColor);
      end;
   end;
end;

procedure TBattleRoom.SendWatchMap;
var
   i : Integer;
   doumiConnector, Connector : TConnector;
   doumiUser : TUser;
begin
   doumiConnector := SearchConnector (DOUMI_CHAR);
   if doumiConnector = nil then exit;

   doumiUser := TUserList (Self.UserList).GetUserPointer (doumiConnector.Name);

   for i := 0 to ViewerList.Count - 1 do begin
      Connector := ViewerList.Items [i];
      Connector.SendMap (doumiUser.BasicData, MapName, ObjName, RofName, TilName, SoundBase);
   end;
end;

procedure TBattleRoom.SendRankData (aConnector : TConnector);
var
   RankData : TGetRankData;
begin
   RankData.rName := aConnector.CharName;
   RankData.rServerName := aConnector.ServerName;
   RankData.rAge := aConnector.GetCharAge;

   if StrPas (@aConnector.CharData.Sex) = '남' then
      RankData.rSex := 0
   else RankData.rSex := 1;

   if BattleDBSender <> nil then
      BattleDBSender.PutPacket (aConnector.connectID, BSBD_GETRANKDATA, 0, @RankData, SizeOf (TGetRankData)); // sdb data 불러오기
end;

procedure TBattleRoom.SendResultData (aOwnerWin, aFighterWin, aOwnerDisCon, aFighterDisCon : Integer);
var
   ResultData : TBattleResultData;
begin
   ResultData.rOwnerName := OwnerName;
   ResultData.rOwnerServer := OwnerServer;
   ResultData.rFighterName := FighterName;
   ResultData.rFighterServer := FighterServer;
   ResultData.rOwnerWin := aOwnerWin;
   ResultData.rOwnerLose := aFighterWin;
   ResultData.rOwnerDisCon := aOwnerDisCon;
   ResultData.rFighterWin := aFighterWin;
   ResultData.rFighterLose := aOwnerWin;
   ResultData.rFighterDisCon := aFighterDisCon;

   if BattleDBSender <> nil then begin
      BattleDBSender.PutPacket (0, BSBD_BATTLERESULT, 0, @ResultData, SizeOf (TBattleResultData));
   // ConnectID를 뭐로 해야하지? 0으로 임시적으로 넣었는데.. ;;;; 쩝.
   // 0으로... 꼭 받을사람 확인 없이...

      if OwnerConnector <> nil then begin
         SendRankData (TConnector (OwnerConnector));
      end;
      if FighterConnector <> nil then begin
         SendRankData (TConnector (FighterConnector));
      end;
   end;
end;

procedure TBattleRoom.KickOutChar (aName : String);
var
   i : Integer;
   Connector : TConnector;
begin
   if OwnerUser = nil then begin
      if aName = '' then begin
         for i := JoinList.Count - 1 downto 0 do begin
            Connector := JoinList.Items [i];
            if Connector.SysopScope < 100 then begin
               Connector.WhereStatus := ws_group;
               Connector.SendBattleGroupList (0);
               Connector.SendChatMessage ('운영자 요청에 의해 방에서 나갑니다', SAY_COLOR_SYSTEM);
               Connector.ExitShareRoom;
            end;
         end;
         exit;
      end else begin
         for i := 0 to JoinList.Count - 1 do begin
            Connector := JoinList.Items [i];
            if Connector.CharName = aName then begin
               Connector.WhereStatus := ws_group;
               Connector.SendBattleGroupList (0);
               Connector.SendChatMessage ('운영자 요청에 의해 방에서 나갑니다', SAY_COLOR_SYSTEM);
               Connector.ExitShareRoom;
               exit;
            end;
         end;

         {
         for i := 0 to ViewerList.Count - 1 do begin
            Connector := ViewerList.Items [i];
            if Connector.CharName = aName then begin
               Connector.WhereStatus := ws_group;
               Connector.SendBattleGroupList (0);
               Connector.SendChatMessage ('운영자 요청에 의해 방에서 나갑니다', SAY_COLOR_SYSTEM);
               Connector.ExitShareRoom;
               exit;
            end;
         end;
         }
      end;
   end else begin
      if FighterConnector <> nil then begin
         if TConnector (FighterConnector).CharName = aName then begin
            TConnector (FighterConnector).WhereStatus := ws_room;
            TConnector (FighterConnector).SendChatMessage ('방장 요청에 의해 방에서 나갑니다', SAY_COLOR_SYSTEM);
            ExitConnector (TConnector (FighterConnector));
            exit;
         end;
      end;

      for i := 0 to ViewerList.Count - 1 do begin
         Connector := ViewerList.Items [i];
         if Connector.CharName = aName then begin
            Connector.WhereStatus := ws_room;
            Connector.SendChatMessage ('방장 요청에 의해 방에서 나갑니다', SAY_COLOR_SYSTEM);
            ExitConnector (Connector);
            exit;
         end;
      end;
   end;
end;

function TBattleRoom.SearchConnector (aCharName : String) : TConnector;
var
   i : Integer;
   Connector : TConnector;
begin
   Result := nil;

   for i := 0 to JoinList.Count - 1 do begin
      Connector := JoinList.Items [i];
      if Connector.CharName = aCharName then begin
         Result := Connector;
         exit;
      end;
   end;   
end;

procedure TBattleRoom.ExitViewerConnector (aConnector : TConnector);
var
   i : Integer;
   tmpConnector, Connector : TConnector;
begin
   tmpConnector := SearchConnector (DOUMI_CHAR);

   if tmpConnector = aConnector then begin
      for i := 0 to ViewerList.Count - 1 do begin
         Connector := ViewerList.Items [i];
         RemoveViewerConnector (Connector);
         Connector.WhereStatus := ws_group;
         Connector.SendBattleGroupList (0);
         Connector.SendChatMessage ('지금은 관람할 수 없습니다', SAY_COLOR_SYSTEM);
      end;
   end;   
end;

// TBattleGroup;
constructor TBattleGroup.Create (aGroupData : PTCreateGroupData);
begin
   Name := aGroupData^.Name;
   ViewName := aGroupData^.ViewName;
   RoomLimit := aGroupData^.RoomLimit;
   MinAge := aGroupData^.MinAge;
   MaxAge := aGroupData^.MaxAge;
   boGrade := aGroupData^.boGrade;

   DataList := TList.Create;
end;

destructor TBattleGroup.Destroy;
var
   i : Integer;
   BattleRoom : TBattleRoom;
begin
   for i := 0 to DataList.Count - 1 do begin
      BattleRoom := DataList.Items [i];
      BattleRoom.Free;
   end;
   DataList.Clear;
   DataList.Free;

   inherited Destroy;
end;

function TBattleGroup.GetGroupString : String;
var
   Str : String;   
begin
   if boGrade = true then begin
      Str := ' <' + '순위기록' + '>';      
   end else begin
      Str := '';
   end;

   Result := ViewName + ':' + ' ( 개설방수 ' + IntToStr (Count) + ' )' + Str;
end;

function TBattleGroup.CreateBattleRoom (aOwnerConnector : TConnector; aOwner : String; var aRetStr : String) : TBattleRoom;
var
   i, iNo : Integer;
   boFlag : Boolean;
   ComData : TWordComData;
   pd : PTSShowListWindow;
   BattleRoom : TBattleRoom;
   Age : Integer;
   str : String;
begin
   Result := nil;

   if DataList.Count >= RoomLimit then begin
      aRetStr := '더 이상 만들 수 없습니다';
      exit;
   end;
   Age := aOwnerConnector.GetCharAge;

   if (Age < MinAge) or (Age > MaxAge) then begin
      aRetStr := '이 그룹에는 만들 수 없습니다';
      exit;
   end;

   iNo := 1;
   while true do begin
      boFlag := false;
      for i := 0 to DataList.Count - 1 do begin
         BattleRoom := DataList.Items [i];
         if BattleRoom.RoomNo = iNo then begin
            boFlag := true;
            break;
         end;
      end;
      if boFlag = false then break;
      Inc (iNo);
   end;
   BattleRoom := TBattleRoom.Create (aOwnerConnector, aOwner, iNo);
   DataList.Add (BattleRoom);

   BattleRoom.RoomGrade := boGrade;

   pd := @ComData.Data;
   pd^.rMsg := SM_SHOWSPECIALWINDOW;
   pd^.rWindow := WINDOW_GROUPWINDOW;
   pd^.rType := 3;
   Str := GetGroupString;
   SetWordString (pd^.rWordString, Str);
   ComData.Cnt := sizeof(TSShowListWindow) - sizeof(TWordString) + sizeofwordstring(pd^.rWordString);
   ConnectorList.SendLatestList (ws_group, @ComData, ComData.Cnt + SizeOf (Word));

   frmMain.lstGroupUpdate (Str);

//   ViewTitle := ViewName + ':' + IntToStr (DataList.Count);

   Result := BattleRoom;
end;

function TBattleGroup.FightBattleRoom (aFighterConnector : TConnector; aTitle, aFighter : String; var aRetStr : String) : TBattleRoom;
var
   i, Age : Integer;
   BattleRoom : TBattleRoom;
begin
   Result := nil;

   Age := aFighterConnector.GetCharAge;
   if (Age < MinAge) or (Age > MaxAge) then begin
      aRetStr := '이 그룹에서 대전할 수 없습니다';
      exit;
   end;

   for i := 0 to DataList.Count - 1 do begin
      BattleRoom := DataList.Items [i];
      if BattleRoom.Title = aTitle then begin
         if BattleRoom.Fighter = '' then begin
            BattleRoom.FighterConnector := aFighterConnector;
            BattleRoom.Fighter := aFighter;
            Result := BattleRoom;
         end else begin
            aRetStr := '이미 대전중인 방입니다';
         end;
         exit;
      end;
   end;

   aRetStr := '선택한 방을 찾을 수 없습니다';
end;

function TBattleGroup.ViewBattleRoom (aTitle : String; var aRetStr : String) : TBattleRoom;
var
   i : Integer;
   BattleRoom : TBattleRoom;
begin
   Result := nil;

   for i := 0 to DataList.Count - 1 do begin
      BattleRoom := DataList.Items [i];
      if BattleRoom.Title = aTitle then begin
         Result := BattleRoom;
         exit;
      end;
   end;

   aRetStr := '선택한 방을 찾을 수 없습니다';
end;

{
procedure TBattleGroup.DeleteBattleRoom (aRoom : TBattleRoom);
var
   i : Integer;
   BattleRoom : TBattleRoom;
begin
   for i := 0 to DataList.Count - 1 do begin
      BattleRoom := DataList.Items [i];
      if BattleRoom = aRoom then begin
         BattleRoom.Free;
         DataList.Delete (i);
         exit;
      end;
   end;
end;
}

procedure TBattleGroup.Update (CurTick : Integer);
var
   i : Integer;
   BattleRoom : TBattleRoom;
   str : String;
   ComData : TWordComData;
   pd : PTSShowListWindow;
   prd : PTSShowListWindow;
begin
   if ShareRoom <> nil then ShareRoom.Update (CurTick);

   for i := DataList.Count - 1 downto 0 do begin
      BattleRoom := DataList.Items [i];
      if BattleRoom.FboAllowDelete = true then begin
         prd := @ComData.Data;
         prd^.rMsg := SM_SHOWSPECIALWINDOW;
         prd^.rWindow := WINDOW_ROOMWINDOW;
         prd^.rType := 2;
         Str := BattleRoom.GetRoomString;
         SetWordString (prd^.rWordString, str);
         ComData.Cnt := sizeof(TSShowListWindow) - sizeof(TWordString) + sizeofwordstring(prd^.rWordString);
         ConnectorList.SendLatestRoomList (ViewName, @ComData, ComData.Cnt + SizeOf (Word));
//         ConnectorList.SendLatestList (ws_room, @ComData, ComData.Cnt + SizeOf (Word));

         BattleRoom.Free;
         DataList.Delete (i);

         pd := @ComData.Data;
         pd^.rMsg := SM_SHOWSPECIALWINDOW;
         pd^.rWindow := WINDOW_GROUPWINDOW;
         pd^.rType := 3;
         Str := GetGroupString;
         SetWordString (pd^.rWordString, str);
         ComData.Cnt := sizeof(TSShowListWindow) - sizeof(TWordString) + sizeofwordstring(pd^.rWordString);
         ConnectorList.SendLatestList (ws_group, @ComData, ComData.Cnt + SizeOf (Word));

         frmMain.lstGroupUpdate (Str);
      end;
   end;

   for i := 0 to DataList.Count - 1 do begin
      BattleRoom := DataList.Items [i];
      if BattleRoom.FboAllowDelete = true then
         frmMain.WriteLogInfo ('FboAllowDelete = true');
      BattleRoom.Update (CurTick);
      if (BattleRoom.FboAllowDelete = true) and (BattleRoom.OwnerUser = nil) and (BattleRoom.OwnerConnector = nil) then
         frmMain.WriteLogInfo ('FboAllowDelete = true, OwnerUser = nil, OwnerConnector = nil');
   end;
end;

procedure TBattleGroup.GetBattleRoomData (aRoomList : PTSShowListWindow; aType : Byte);
var
   i : Integer;
   dest : String;
   BattleRoom : TBattleRoom;
begin
   aRoomList^.rMsg := SM_SHOWSPECIALWINDOW;
   aRoomList^.rWindow := WINDOW_ROOMWINDOW;
   aRoomList^.rType := aType;

   dest := '';
   for i := 0 to DataList.Count - 1 do begin
      BattleRoom := DataList.Items [i];
      if BattleRoom.FboAllowDelete = true then continue;
      dest := dest + BattleRoom.GetRoomString + ',';
   end;

   SetWordString (aRoomList^.rWordString, dest);
end;

procedure TBattleGroup.ShowRoomTitleList;
var
   i : Integer;
   BattleRoom : TBattleRoom;
begin
   for i := 0 to DataList.Count - 1 do begin
      BattleRoom := DataList.Items [i];
      frmMain.lstRoom.Items.Add (BattleRoom.GetRoomString);
   end;
end;

function TBattleGroup.Get (aIndex : Integer) : Pointer;
begin
   Result := nil;

   if (aIndex < 0) or (aIndex >= DataList.Count) then exit;

   Result := DataList.Items [aIndex];
end;

function TBattleGroup.GetCount : Integer;
begin
   Result := DataList.Count;
end;


// TBattleGroupList;
constructor TBattleGroupList.Create;
begin
   DataList := TList.Create;

   LoadFromFile ('.\Setting\CreateGroup.SDB');
end;

destructor TBattleGroupList.Destroy;
var
   i : Integer;
   BattleGroup : TBattleGroup;
begin
   for i := 0 to DataList.Count - 1 do begin
      BattleGroup := DataList.Items [i];
      BattleGroup.Free;
   end;
   DataList.Clear;
   DataList.Free;
   inherited Destroy;
end;

function TBattleGroupList.LoadFromFile (aFileName : String) : Boolean;
var
   i : Integer;
   iName : String;
   DB : TUserStringDB;
   gd : TCreateGroupData;
   BattleGroup : TBattleGroup;
begin
   Result := false;

   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      gd.Name := iName;
      gd.ViewName := DB.GetFieldValueString (iName, 'ViewName');
      gd.RoomLimit := DB.GetFieldValueInteger (iName, 'RoomLimit');
      gd.MinAge := DB.GetFieldValueInteger (iName, 'MinAge');
      gd.MaxAge := DB.GetFieldValueInteger (iName, 'MaxAge');
      gd.boGrade := DB.GetFieldValueBoolean (iName, 'boGrade');

      BattleGroup := TBattleGroup.Create (@gd);

      DataList.Add (BattleGroup);

      frmMain.lstGroup.Items.Add (BattleGroup.GetGroupString);
   end;

   DB.Free;

   Result := true;
end;

procedure TBattleGroupList.GetBattleGroupData (aGroupList : PTSShowListWindow; aType : Byte);
var
   i : Integer;
   BattleGroup : TBattleGroup;
   dest : String;
begin
   // FillChar (aGroupList^, SizeOf (TSShowGroupListWindow), 0);

   aGroupList^.rMsg := SM_SHOWSPECIALWINDOW;
   aGroupList^.rWindow := WINDOW_GROUPWINDOW;
   aGroupList^.rType := aType;

   dest := '';
   for i := 0 to DataList.Count - 1 do begin
      BattleGroup := DataList.Items [i];
      dest := dest + BattleGroup.GetGroupString + ',';
   end;

   SetWordString (aGroupList^.rWordString, dest);
end;

procedure TBattleGroupList.GetBattleRoomData (aRoomList : PTSShowListWindow; aGroupTitle : String; aType : Byte);
var
   i : Integer;
   BattleGroup : TBattleGroup;
begin
   for i := 0 to DataList.Count - 1 do begin
      BattleGroup := DataList.Items [i];
      if BattleGroup.ViewName = aGroupTitle then begin
         BattleGroup.GetBattleRoomData (aRoomList, aType);
         exit;
      end;
   end;
end;

function TBattleGroupList.CreateBattleRoom (aOwnerConnector : TConnector; aGroupTitle, aOwnerName : String; var aRetStr : String) : TBattleRoom;
var
   i : Integer;
   BattleGroup : TBattleGroup;
begin
   Result := nil;
   aRetStr := '';

   for i := 0 to DataList.Count - 1 do begin
      BattleGroup := DataList.Items [i];
      if BattleGroup.ViewName = aGroupTitle then begin
         Result := BattleGroup.CreateBattleRoom (aOwnerConnector, aOwnerName, aRetStr);
         exit;
      end;
   end;

   aRetStr := '지정한 그룹을 찾을 수 없습니다';
end;

function TBattleGroupList.FightBattleRoom (aFighterConnector : TConnector; aGroupTitle, aRoomTitle, aFighterName : String; var aRetStr : String) : TBattleRoom;
var
   i : Integer;
   BattleGroup : TBattleGroup;
begin
   Result := nil;

   for i := 0 to DataList.Count - 1 do begin
      BattleGroup := DataList.Items [i];
      if BattleGroup.ViewName = aGroupTitle then begin
         Result := BattleGroup.FightBattleRoom (aFighterConnector, aRoomTitle, aFighterName, aRetStr);
         exit;
      end;
   end;

   aRetStr := '지정한 그룹을 찾을 수 없습니다';
end;

function TBattleGroupList.ViewBattleRoom (aGroupTitle, aRoomTitle : String; var aRetStr : String) : TBattleRoom;
var
   i : Integer;
   BattleGroup : TBattleGroup;
begin
   Result := nil;

   for i := 0 to DataList.Count - 1 do begin
      BattleGroup := DataList.Items [i];
      if BattleGroup.ViewName = aGroupTitle then begin
         Result := BattleGroup.ViewBattleRoom (aRoomTitle, aRetStr);
         exit;
      end;
   end;

   aRetStr := '지정한 그룹을 찾을 수 없습니다';
end;

function TBattleGroupList.Get (aIndex : Integer) : Pointer;
begin
   Result := nil;

   if (aIndex < 0) or (aIndex >= DataList.Count) then exit;

   Result := DataList.Items [aIndex];
end;

function TBattleGroupList.GetCount : Integer;
begin
   Result := DataList.Count;
end;

procedure TBattleGroupList.Update (CurTick : Integer);
var
   i : Integer;
   BattleGroup : TBattleGroup;
begin
   for i := 0 to DataList.Count - 1 do begin
      BattleGroup := DataList.Items [i];
      BattleGroup.Update (CurTick);
   end;
end;

procedure TBattleGroupList.ShowRoomTitleList (aGroupTitle : String);
var
   i : Integer;
   BattleGroup : TBattleGroup;
begin
   for i := 0 to DataList.Count - 1 do begin
      BattleGroup := DataList.Items [i];
      if BattleGroup.ViewName = aGroupTitle then begin
         BattleGroup.ShowRoomTitleList;
         exit;
      end;
   end;
end;

end.
