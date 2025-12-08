unit uConnect;

interface

uses
   Classes, SysUtils, uGConnect, uDBRecordDef, uBuffer, uAnsTick,
   Common, uKeyClass, DefType, aDefType, BSCommon, uLevelExp, AnsImg2;

const
   SHARE_XPOS     = 63;
   SHARE_YPOS     = 61;
   GRADE_FILENAME = '.\Setting\Grade.SDB';

type
   TWhereStatus = ( ws_none, ws_group, ws_grade, ws_room, ws_inroom );

   TWordComData = record
      Cnt : Word;
      Data : array [0..4096 - 1] of byte;
   end;
   PTWordComData = ^TWordComData;

   TConnector = class
   private
      GradeWindowButtonDownTick : integer;
      GateNo : Integer;

      StartTime : String;

      SaveTick : Integer;
      FboAllowDelete : Boolean;

      ShoutedTick : Integer;

      User : Pointer;
      BattleRoom : Pointer;
   public
      ConnectID : Integer;

      CharData : TDBRecord;

      LoginID : String;
      ServerName : String;
      CharName : String;
      Name : String;

      GroupTitle : String;

      IpAddr : String;
      VerNo : Byte;
      PaidType : Byte;

      SysopScope : Integer;

      // Points;
      Win : Integer;          // 승
      Lose : Integer;         // 패
      DisConnected : Integer; // 끊긴거
      BattleRecord : Integer; // 전적
      Points : Integer;       // 점수
      Grade : Integer;        // 순위

      WhereStatus : TWhereStatus;
      WaitTick : Integer;
      WaitStartTick : Integer;

      ReceiveBuffer : TPacketBuffer;

      constructor Create (aServerName : String; aGateNo, aConnectID : Integer);
      destructor Destroy; override;

      procedure ExitBattleRoom;
      procedure ExitShareRoom;

      function  StartLayer (aData : PChar) : Boolean;
      procedure EndLayer;
      procedure Update (CurTick : Integer);

      procedure MessageProcess (aComData : PTWordComData);
      procedure BattleDBMessageProcess (aPacket : PTPacketData);

      procedure AddReceiveData (aData : PChar; aSize : Integer);
      procedure AddSendData (aData : PChar; aSize : Integer);

      function  SearchExtremeMagic (aStr : String) : String;
      function  SearchGradeStrList (aServerName, aCharName : String) : Boolean;
      procedure SearchPositionbyServer (aServerName : String; var aXpos, aYpos : Integer);

      procedure SendBattleGroupList (aType : Byte);
      procedure SendBattleRoomList (aGroupTitle : String; aType : Byte);
      procedure SendGradeList (aWordStr : String);

      function  GetCharAge : Integer;
      procedure SendChatMessage (astr: string; aColor: byte);
      procedure SendMap (var aSenderInfo: TBasicData; amap, aobj, arof, atil, aSoundBase: string);
      procedure SendShowCenterMessage (aStr : String; aColor : Word);
      procedure SendShow (var aSenderinfo: TBasicData);      

      function  GetToken (aStr : String; aDivStr : Char; aTime : Integer) : String;

      property  boAllowDelete : Boolean read FboAllowDelete write FboAllowDelete;
   end;

   TConnectorList = class
   private
      UniqueKey : TIntegerKeyClass;
      NameKey : TStringKeyClass;

      DataList : TList;

      SaveBuffer : TPacketBuffer;

      CreateTick : Integer;
      DeleteTick : Integer;
      SaveTick : Integer;

      ConnectorProcessCount : Integer;
      CurProcessPos : Integer;

      function GetCount : Integer;
      function GetNameKeyCount : Integer;
      function GetUniqueKeyCount : Integer;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      procedure Update (CurTick : Integer);

      function  CreateConnect (aGateNo : Integer; aPacket : PTPacketData) : TConnector;
      procedure DeleteConnect (aGateNo, aConnectID : Integer);

      procedure CloseAllConnect;
//      procedure CloseConnectByCharName (aName : String);
//      procedure CloseConnectByGateNo (aGateNo : Integer);

      procedure AddReceiveData (aGateNo : Integer; aPacket : PTPacketData);

      // procedure AddSaveData (aData : PChar; aSize : Integer);
      procedure BattleDBMessageProcess (aPacket : PTPacketData);

      procedure SendLatestList (aWhereStatus : TWhereStatus; aData : PChar; aSize : Integer);
      procedure SendLatestRoomList (aGroupTitle : String; aData : PChar; aSize : Integer);

      procedure WaitRoomMessage (aGroupTitle : String; aStr : String; aColor : Byte);
      procedure ShoutMessage (aStr : String; aColor : Byte);

      function GetSaveListCount : Integer;

      property Count : Integer read GetCount;
      property NameKeyCount : Integer read GetNameKeyCount;
      property UniqueKeyCount : Integer read GetUniqueKeyCount;
   end;

var
   ConnectorList : TConnectorList;

   GradeStrList : TStringList;

implementation

uses
   svMain, uUser, svClass, AUtil32, uGroup, UserSDB, BasicObj;

// ---------- TConnector;
constructor TConnector.Create (aServerName : String; aGateNo, aConnectID : Integer);
begin
   GateNo := aGateNo;
   ConnectID := aConnectID;

   VerNo := 0;
   PaidType := 0;

   ServerName := aServerName;
   CharName := '';
   LoginID := '';
   IpAddr := '';
   Name := '';

   Win := 0;
   Lose := 0;
   DisConnected := 0;
   BattleRecord := 0;
   Points := 0;
   Grade := 0;

   WhereStatus := ws_none;

   FillChar (CharData, SizeOf (TDBRecord), 0);

   StartTime := DateToStr (Date) + ' ' + TimeToStr (Time);
   SaveTick := mmAnsTick;
   ShoutedTick := mmAnsTick;
   WaitTick := 0;

   FboAllowDelete := false;

   User := nil;
   BattleRoom := nil;

   ReceiveBuffer := TPacketBuffer.Create (BufferSizeS2C);
   GradeWindowButtonDownTick := 0;

{
   RankData.rName := CharName;
   RankData.rServerName := ServerName;
   RankData.rAge := GetCharAge;

   if StrPas (@CharData.Sex) = '남' then
      RankData.rSex := 0
   else RankData.rSex := 1;

   BattleDBSender.PutPacket (ConnectID, BSBD_GETRANKDATA, 0, @RankData, SizeOf (TGetRankData)); // sdb data 불러오기
}
end;

destructor TConnector.Destroy;
begin
   frmMain.AddLog ('close ' + Name);
   frmMain.DelUser (Name);
   {
   if CharName <> '' then begin
      EndLayer;
   end;
   }

   if BattleRoom <> nil then begin
      TBattleRoom (BattleRoom).RemoveConnector (Self);
   end else begin
      ExitShareRoom;
      MirrorList.DelViewer (Self);
   end;

   ReceiveBuffer.Free;

   inherited Destroy;
end;

procedure TConnector.ExitBattleRoom;
begin
   if BattleRoom = nil then exit;

   User := nil;
   BattleRoom := nil;

   WhereStatus := ws_room;
   if GroupTitle <> '' then begin
      SendBattleRoomList (GroupTitle, 0);
   end else begin
      SendBattleGroupList (0);
   end;
end;

procedure TConnector.ExitShareRoom;
begin
   if User <> nil then begin
      TUserList (ShareRoom.UserList).FinalLayer (Self);
      User := nil;
      ShareRoom.RemoveJoinConnector (Self);
   end;
end;

function TConnector.StartLayer (aData : PChar) : Boolean;
var
   Str, rdStr : String;
   RankData : TGetRankData;
begin
   Result := true;

   Move (aData^, CharData, SizeOf (TDBRecord));

   CharName := StrPas (@CharData.PrimaryKey);
   LoginID := StrPas (@CharData.MasterName);
   Str := StrPas (@CharData.Dummy);

   Str := GetValidStr3 (Str, rdStr, ',');
   IpAddr := rdStr;
   Str := GetValidStr3 (Str, rdStr, ',');
   VerNo := _StrToInt (rdStr);
   Str := GetValidStr3 (Str, rdStr, ',');
   PaidType := _StrToInt (rdStr);

   FillChar (CharData.Dummy, SizeOf (CharData.Dummy), 0);

   Name := CharName + ' (' + ServerName + ')';

   // 과연 될까나? ;;;; 쩝.
   RankData.rName := CharName;
   RankData.rServerName := ServerName;
   RankData.rAge := GetCharAge;

   if StrPas (@CharData.Sex) = '남' then
      RankData.rSex := 0
   else RankData.rSex := 1;

   if BattleDBSender <> nil then begin
      BattleDBSender.PutPacket (ConnectID, BSBD_GETRANKDATA, 0, @RankData, SizeOf (TGetRankData)); // sdb data 불러오기
   end;

   SysopScope := SysopClass.GetSysopScope (CharName);
end;

procedure TConnector.EndLayer;
begin
   if User <> nil then begin
      TUserList (TUser (User).Manager.UserList).FinalLayer (Self);
   end;
end;

procedure TConnector.Update (CurTick : Integer);
var
   ComData : TWordComData;
begin
{
   if CurTick >= SaveTick + 2000 then begin
      GameServerConnectorList.AddSendServerData (GateNo, ConnectID, BG_USERCLOSE, nil, 0);
      FboAllowDelete := true;
      exit;
   end;
}
   if WaitTick > 0 then begin
      WaitTick := WaitTick - (CurTick - WaitStartTick);
      WaitStartTick := CurTick;
      if WaitTick <= 0 then begin
         WaitTick := 0;
         WaitStartTick := 0;
      end;
   end;
   
   if ReceiveBuffer.Count > 0 then begin
      while true do begin
         if ReceiveBuffer.Get (@ComData) = false then break;
         MessageProcess (@ComData);
      end;
   end;
end;

procedure TConnector.MessageProcess (aComData : PTWordComData);
var
   i, CurTick, SXpos, SYpos : integer;
   sColor : Byte;
   pcKey : PTCKey;
   pcSay : PTCSay;
   pcConfirm : PTCWindowConfirm;
   ComData : TWordComData;
   MainMagic : String;
   RoomTitle, Str, RetStr, MagicStr : String;
   Strs : array [0..15] of string;
   LimitStr : String;


   Room : TBattleRoom;
   tmpUser : TUser;
   prd : PTSShowListWindow;
   pHideWindow : PTSHideSpecialWindow;

   RankPart : TGetRankPart;
   MainMagicData : TMainMagicData;
   MainMagicRank : TGetMainMagicRank;
begin
   CurTick := mmAnsTick;

   pckey := @aComData^.Data;
   Case pckey^.rmsg of
      CM_WINDOWCONFIRM :
         begin
            pcConfirm := @aComData^.Data;
            Case pcConfirm^.rWindow of
               WINDOW_GROUPWINDOW :
                  begin
                     if WhereStatus <> ws_group then begin
//                        frmMain.WriteLogInfo ('Invalid Message Received (GroupWindow)');
                        exit;
                     end;

                     Case pcConfirm^.rButton of
                        BATTLEBUTTON_SELECT :
                           begin
                              GroupTitle := GetToken (pcConfirm^.rText, ':', 0);
                              if GroupTitle = '' then begin
                                 SendBattleGroupList (0);
                                 exit;
                              end;
                              WhereStatus := ws_room;
                              if GroupTitle <> '' then
                                 SendBattleRoomList (GroupTitle, 0);
                              ConnectorList.WaitRoomMessage (GroupTitle, format ('%s님이 들어오셨습니다', [CharName]), SAY_COLOR_GRADE5);
                           end;
                        BATTLEBUTTON_GRADE :
                           begin
                              SendGradeList ('');
                              WhereStatus := ws_grade;
                           end;
                        BATTLEBUTTON_EXIT :
                           begin
                              GameServerConnectorList.AddSendServerData (GateNo, ConnectID, BG_USERCLOSE, nil, 0);
                              FboAllowDelete := true;
                              WhereStatus := ws_none;
                           end;
                     end;
                  end;

               WINDOW_ROOMWINDOW :
                  begin
                     if WhereStatus <> ws_room then begin
//                        frmMain.WriteLogInfo ('Invalid Message Received (RoomWindow)');
                        exit;
                     end;
                     if (BattleRoom <> nil) or (User <> nil) then begin
                        frmMain.WriteLogInfo ('Invalid Connector (RoomWindow)');
                        exit;
                     end;

                     Case pcConfirm^.rButton of
                        BATTLEBUTTON_MAKE :
                           begin
                              RoomTitle := pcConfirm^.rText;

                              Room := BattleGroupList.CreateBattleRoom (Self, GroupTitle, Name, RetStr);
                              if Room <> nil then begin
                                 BattleRoom := Room;
                                 User := TUserList(Room.UserList).InitialLayerByPosition (Name, CharName, Self, Room, OWNER_XPOS + 1, BOTH_YPOS);
                                 if User <> nil then begin
                                    TUserList(Room.UserList).StartChar (Name, DR_2);
                                    TUser(User).SendClass.SendChatMessage ('대련방에 입장하였습니다', SAY_COLOR_SYSTEM);
                                    WhereStatus := ws_inroom;

                                    prd := @ComData.Data;
                                    prd^.rMsg := SM_SHOWSPECIALWINDOW;
                                    prd^.rWindow := WINDOW_ROOMWINDOW;
                                    prd^.rType := 1;
                                    Str := Room.GetRoomString;
                                    SetWordString (prd^.rWordString, str);
                                    ComData.Cnt := sizeof(TSShowListWindow) - sizeof(TWordString) + sizeofwordstring(prd^.rWordString);
                                    ConnectorList.SendLatestRoomList (GroupTitle, @ComData, ComData.Cnt + SizeOf (Word));
                                 end else begin
                                    if GroupTitle <> '' then
                                       SendBattleRoomList (GroupTitle, 0);
                                 end;
                              end else begin
                                 SendChatMessage (RetStr, SAY_COLOR_SYSTEM);
                                 if GroupTitle <> '' then
                                    SendBattleRoomList (GroupTitle, 0);
                              end;
                           end;
                        BATTLEBUTTON_FIGHT :
                           begin
                              RoomTitle := GetToken (pcConfirm^.rText, ':', 0);

                              Room := BattleGroupList.FightBattleRoom (Self, GroupTitle, RoomTitle, Name, RetStr);
                              if Room <> nil then begin
                                 BattleRoom := Room;
                                 User := TUserList(Room.UserList).InitialLayerByPosition (Name, CharName, Self, Room, FIGHTER_XPOS + 1, BOTH_YPOS);
                                 if User <> nil then begin
                                    TUserList(Room.UserList).StartChar (Name, DR_6);
                                    TUser(User).SendClass.SendChatMessage ('대련방에 입장하였습니다', SAY_COLOR_SYSTEM);
                                    WhereStatus := ws_inroom;

                                    prd := @ComData.Data;
                                    prd^.rMsg := SM_SHOWSPECIALWINDOW;
                                    prd^.rWindow := WINDOW_ROOMWINDOW;
                                    prd^.rType := 3;
                                    Str := Room.GetRoomString;
                                    SetWordString (prd^.rWordString, str);
                                    ComData.Cnt := sizeof(TSShowListWindow) - sizeof(TWordString) + sizeofwordstring(prd^.rWordString);
                                    ConnectorList.SendLatestRoomList (GroupTitle, @ComData, ComData.Cnt + SizeOf (Word));
                                 end else begin
                                    if GroupTitle <> '' then
                                       SendBattleRoomList (GroupTitle, 0);
                                 end;
                              end else begin
                                 SendChatMessage (RetStr, SAY_COLOR_SYSTEM);
                                 if GroupTitle <> '' then
                                    SendBattleRoomList (GroupTitle, 0);
                              end;
                           end;
                        BATTLEBUTTON_SHOW :
                           begin
                              RoomTitle := GetToken (pcConfirm^.rText, ':', 0);

                              Room := BattleGroupList.ViewBattleRoom (GroupTitle, RoomTitle, RetStr);
                              if Room <> nil then begin
                                 BattleRoom := Room;
                                 tmpUser := TUserList(Room.UserList).GetUserPointer (Room.Owner);
                                 if tmpUser <> nil then begin
                                    tmpUser.SendMapForViewer (Self);

                                    Room.AddViewerConnector (Self);

                                    SendChatMessage ('대련 관람이 시작되었습니다', SAY_COLOR_SYSTEM);
                                    WhereStatus := ws_inroom;

                                    prd := @ComData.Data;
                                    prd^.rMsg := SM_SHOWSPECIALWINDOW;
                                    prd^.rWindow := WINDOW_ROOMWINDOW;
                                    prd^.rType := 3;
                                    Str := Room.GetRoomString;
                                    SetWordString (prd^.rWordString, str);
                                    ComData.Cnt := sizeof(TSShowListWindow) - sizeof(TWordString) + sizeofwordstring(prd^.rWordString);
                                    ConnectorList.SendLatestRoomList (GroupTitle, @ComData, ComData.Cnt + SizeOf (Word));
                                 end else begin
                                    SendChatMessage ('시스템 오류입니다. 다시 선택해 주세요', SAY_COLOR_SYSTEM);
                                    if GroupTitle <> '' then
                                       SendBattleRoomList (GroupTitle, 0);
                                 end;
                              end else begin
                                 SendChatMessage (RetStr, SAY_COLOR_SYSTEM);
                                 if GroupTitle <> '' then
                                    SendBattleRoomList (GroupTitle, 0);
                              end;
                           end;
                        BATTLEBUTTON_ROOMEXIT :
                           begin
                              WhereStatus := ws_group;
                              SendBattleGroupList (0);
                           end;
                     end;
                  end;
               WINDOW_GRADEWINDOW :
                  begin
                     if WhereStatus <> ws_grade then begin
                        frmMain.WriteLogInfo ('Invalid Message Received (GradeWindow)');
                        exit;
                     end;

                     Case pcConfirm^.rButton of
                        BATTLEBUTTON_SHOWALL :
                           begin
                              if GradeWindowButtonDownTick + 100 > mmAnsTick then exit;
                              GradeWindowButtonDownTick := mmAnsTick;

                              WhereStatus := ws_grade;
                              Rankpart.rAge := GetCharAge;
                              RankPart.rStart := 1;
                              RankPart.rEnd := 50;
                              if BattleDBSender <> nil then begin
                                 BattleDBSender.PutPacket (ConnectID, BSBD_GETRANKPART, 0, @RankPart, SizeOf (TGetRankPart));
                              end;
                           end;
                        BATTLEBUTTON_SHOWME :
                           begin
                              if GradeWindowButtonDownTick + 100 > mmAnsTick then exit;
                              GradeWindowButtonDownTick := mmAnsTick;

                              WhereStatus := ws_grade;
                              RankPart.rAge := GetCharAge;

                              if Grade < 25 then begin
                                 RankPart.rStart := 1;
                                 RankPart.rEnd := 50;
                              end else begin
                                 RankPart.rStart := Grade - 24;
                                 RankPart.rEnd := Grade + 25;
                              end;
                              if BattleDBSender <> nil then begin
                                 BattleDBSender.PutPacket (ConnectID, BSBD_GETRANKPART, 0, @RankPart, SizeOf (TGetRankPart));
                              end;
                           end;
                        BATTLEBUTTON_GRADEEXIT :
                           begin
                              WhereStatus := ws_group;
                              SendBattleGroupList (0);
                           end;
                     end;
                  end;
            end;
         end;
      Else
         begin
            pcSay := @aComData^.Data;
            if pcSay^.rmsg = CM_SAY then begin
               Str := GetWordString (pcSay^.rWordString);
               if Str = '' then exit;

               LimitStr := Copy (Str, 1, 88);
               Str := LimitStr;

               RetStr := Str;
               for i := 0 to 15 do begin
                  RetStr := GetValidStr3 (RetStr, Strs[i], ' ');
                  if RetStr = '' then break;
               end;


               case Str[1] of
                  '!' :
                     begin
                        // if Points < 2000 then exit;
                        sColor := SAY_COLOR_GRADE0;
                        case Grade of
                           0 :
                              begin
                                 if SysopScope >= 100 then begin
                                    sColor := SAY_COLOR_GRADE5;
                                 end;
                                 if CurTick > ShoutedTick + 1000 then begin
                                    ConnectorList.ShoutMessage ('{' + CharName + '} : ' + Copy (Str, 2, Length(Str) - 1), sColor);
                                    ShoutedTick := CurTick;
                                 end;
                                 exit;
                              end;
                           30..41 : sColor := SAY_COLOR_GRADE0;
                           20..29 : sColor := SAY_COLOR_GRADE1;
                           12..19 : sColor := SAY_COLOR_GRADE2;
                           6..11 : sColor := SAY_COLOR_GRADE3;
                           2..5 : sColor := SAY_COLOR_GRADE4;
                           1 : sColor := SAY_COLOR_GRADE5;
                        end;
                        if SysopScope >= 100 then sColor := SAY_COLOR_GRADE5;
                        if CurTick > ShoutedTick + 1000 then begin
                           ConnectorList.ShoutMessage ('{' + CharName + '} : ' + Copy (Str, 2, Length(Str) - 1), sColor);
                           ShoutedTick := CurTick;
                        end;
                        exit;
                     end;
                  '/' :
                     begin
                        if Strs[0] = '/누구' then begin
                           SendChatMessage (format ('<현재사용자 : %d 명>', [ConnectorList.Count]), SAY_COLOR_SYSTEM);
                           if WhereStatus = ws_inroom then begin
                              if BattleRoom = nil then begin
                                 SendChatMessage (format (' 참여인원 : %d 명', [ShareRoom.JoinCount]), SAY_COLOR_SYSTEM);
                                 MirrorList.ShowViewerList (Self);
                              end else begin
                                 SendChatMessage (format (' %s vs %s ', [TBattleRoom (BattleRoom).Owner, TBattleRoom (BattleRoom).Fighter]), SAY_COLOR_SYSTEM);
                                 Str := TBattleRoom (BattleRoom).GetViewerString;
                                 if Trim (Str) <> '' then SendChatMessage (Str, SAY_COLOR_NORMAL);
                              end;
                           end;
                           exit;
                        end;
                     end;
                  '@' :
                     begin
                        if Strs[0] = '@대전종료' then begin
                           if BattleRoom = nil then begin
                              ExitShareRoom;
                              MirrorList.DelViewer (Self);

                              WhereStatus := ws_group;
                              SendBattleGroupList (0);
                              exit;
                           end else begin
                              if WhereStatus <> ws_inroom then exit;
                              if BattleRoom = nil then exit;
                              if (TBattleRoom (BattleRoom).OwnerConnector = Self) or
                                 (TBattleRoom (BattleRoom).FighterConnector = Self) then begin
                                 if (TBattleRoom (BattleRoom).BattleRoomStatus = brs_fighting) or
                                 (TBattleRoom (BattleRoom).BattleRoomStatus = brs_nextready) then exit;
                              end;
                              TBattleRoom (BattleRoom).ExitConnector (Self);
                              WhereStatus := ws_room;
                              exit;
                           end;
                        end;
                        if Strs[0] = '@나가기' then begin
                           if (WhereStatus = ws_room) or (WhereStatus = ws_group) then begin
                              GameServerConnectorList.AddSendServerData (GateNo, ConnectID, BG_USERCLOSE, nil, 0);
                              FboAllowDelete := true;
                           end;
                           exit;
                        end;
                        if Strs[0] = '@전적확인' then begin
                           SendChatMessage (format ('%s : %d승 %d패 끊김:%d %d점 현재 %d위 (순위는 전체순위와 다를수 있음)',
                              [CharName, Win, Lose, DisConnected, Points, Grade]), SAY_COLOR_SYSTEM);
                           exit;
                        end;
                        if (UpperCase(Strs[0]) = '@BAN') then begin
                           if WhereStatus <> ws_inroom then exit;

                           if BattleRoom <> nil then begin
                              if TBattleRoom (BattleRoom).OwnerConnector = Self then begin
                                 if (TBattleRoom (BattleRoom).BattleRoomStatus = brs_fighting) or
                                 (TBattleRoom (BattleRoom).BattleRoomStatus = brs_nextready) then exit;
                                 TBattleRoom (BattleRoom).KickOutChar (Strs[1]);
                                 exit;
                              end;
                           end;
                        end;

                        if Strs[0] = '@공유방참여' then begin   // ShareRoom
                           if WhereStatus = ws_inroom then exit;

                           if (SysopScope < 100) and (boUseShareRoom = false) then begin
                              SendChatMessage ('지금은 공유방을 사용할 수 없습니다', SAY_COLOR_SYSTEM);
                              exit;
                           end;

                           if SysopScope < 100 then begin
                              if GradeStrList.Count > 1 then begin
                                 if SearchGradeStrList (ServerName, CharName) = false then begin
                                    SendChatMessage ('들어갈수 없습니다. @공유방구경 으로 구경하십시오', SAY_COLOR_SYSTEM);
                                    exit;
                                 end;
                              end;
                           end;

                           SXpos := 0;
                           SYpos := 0;
                           SearchPositionByServer (ServerName, SXpos, SYpos);
                           if (SXpos = 0) or (SYpos = 0) then begin
                              SXpos := SHARE_XPOS;
                              SYpos := SHARE_YPOS;
                           end; 
                           User := TUserList(ShareRoom.UserList).InitialLayerByPosition (Name, CharName, Self, ShareRoom, SXpos + 1, SYpos);
                           if User <> nil then begin
                              pHideWindow := @ComData.Data;
                              pHideWindow^.rMsg := SM_HIDESPECIALWINDOW;
                              if WhereStatus = ws_group then begin
                                 pHideWindow^.rWindow := WINDOW_GROUPWINDOW;
                              end else if WhereStatus = ws_room then begin
                                 pHideWindow^.rWindow := WINDOW_ROOMWINDOW;
                              end else if WhereStatus = ws_grade then begin
                                 pHideWindow^.rWindow := WINDOW_GRADEWINDOW;
                              end else begin
                                 pHideWindow^.rWindow := WINDOW_NONE;
                              end;

                              ComData.Cnt := SizeOf (TSHideSpecialWindow);
                              AddSendData (@ComData, ComData.Cnt + SizeOf (Word));

                              WhereStatus := ws_inroom;

                              TUserList(ShareRoom.UserList).StartChar (Name, DR_4);

                              ShareRoom.AddJoinConnector (Self);
                              TUser(User).SendClass.SendChatMessage ('대련방에 입장하였습니다', SAY_COLOR_SYSTEM);
                           end;
                           exit;
                        end;
                        if Strs[0] = '@공유방구경' then begin
                           if WhereStatus = ws_inroom then exit;

                           if MirrorList.AddViewer (Strs [1], Self) = true then begin
                              pHideWindow := @ComData.Data;
                              pHideWindow^.rMsg := SM_HIDESPECIALWINDOW;
                              if WhereStatus = ws_group then begin
                                 pHideWindow^.rWindow := WINDOW_GROUPWINDOW;
                              end else if WhereStatus = ws_room then begin
                                 pHideWindow^.rWindow := WINDOW_ROOMWINDOW;
                              end else if WhereStatus = ws_grade then begin
                                 pHideWindow^.rWindow := WINDOW_GRADEWINDOW;
                              end else begin
                                 pHideWindow^.rWindow := WINDOW_NONE;
                              end;

                              ComData.Cnt := SizeOf (TSHideSpecialWindow);
                              AddSendData (@ComData, ComData.Cnt + SizeOf (Word));

                              SendChatMessage ('대련 관람이 시작되었습니다', SAY_COLOR_SYSTEM);

                              WhereStatus := ws_inroom;
                           end else begin
                              SendChatMessage ('지정한 이름의 장소를 찾을 수 없습니다', SAY_COLOR_SYSTEM);
                           end;
                           exit;
                        end;
                        if UpperCase (Strs[0]) = '@RELOAD' then begin
                           if SysopScope < 100 then exit;
                           GradeStrList.Clear;
                           GradeStrList.LoadFromFile (GRADE_FILENAME);
                           exit;
                        end;
                     end;
               end; 

{
               if (UpperCase (RetStr) = '@CALL') then begin
                  if WhereStatus <> ws_inroom then exit;
                  if BattleRoom <> nil then exit;

//                  if doumiConnector <> Self then exit;
                  if SysopScope >= 100 then begin
                     RetStr := GetToken (Str, ' ', 1);
                     tmpConnector := ShareRoom.SearchConnector (RetStr);
                     tmpUser := TUserList (ShareRoom.UserList).GetUserPointer (tmpConnector.Name);
                     if tmpUser = nil then begin
                        SendChatMessage (format ('%s님이 없습니다.',[RetStr]), SAY_COLOR_SYSTEM);
                     end else begin
                        doumiUser := TUserList (ShareRoom.UserList).GetUserPointer (doumiConnector.Name);

                        tmpUser.XPosMove := doumiUser.BasicData.x;
                        tmpUser.YPosMove := doumiUser.BasicData.y;
                        tmpUser.MoveConnector;
                     end;
                     exit;
                  end;
               end;
               if (UpperCase (RetStr) = '@APPEAR') then begin
                  if WhereStatus <> ws_inroom then exit;
                  if BattleRoom <> nil then exit;

                  if doumiConnector <> Self then exit;
                  RetStr := GetToken (Str, ' ', 1);
                  tmpConnector := ShareRoom.SearchConnector (RetStr);
                  tmpUser := TUserList (ShareRoom.UserList).GetUserPointer (tmpConnector.Name);
                  if tmpUser = nil then begin
                     SendChatMessage (format ('%s님이 없습니다.',[RetStr]), SAY_COLOR_SYSTEM);
                  end else begin
                     doumiUser := TUserList (ShareRoom.UserList).GetUserPointer (doumiConnector.Name);

                     doumiUser.XPosMove := tmpUser.BasicData.x;
                     doumiUser.YPosMove := tmpUser.BasicData.y;
                     doumiUser.MoveConnector;
                  end;
                  exit;
               end;
}
{
               if Str = '@서버별순위' then begin
                  Rankpart.rAge := 0;
                  RankPart.rStart := 1;
                  RankPart.rEnd := 6;
                  if BattleDBSender <> nil then begin
                     BattleDBSender.PutPacket (ConnectID, BSBD_GETSERVERRANK, 0, @RankPart, SizeOf (TGetRankPart));
                  end;
                  exit;
               end;
               RetStr := GetToken (Str, ' ', 0);
               if RetStr = '@주무공' then begin
                  MagicStr := GetToken (Str, ' ', 1);
                  if Trim (MagicStr) = '' then begin
                     SendChatMessage ('@주무공 (권법가/검법가/도법가/창법가/퇴법가 중 한개)', SAY_COLOR_SYSTEM);
                  end else begin
                     MainMagic := SearchExtremeMagic (MagicStr);

                     if MainMagic = '' then exit;
                     MainMagicData.rName := CharName;
                     MainMagicData.rServerName := ServerName;
                     MainMagicData.rMagic := MainMagic;

                     if BattleDBSender <> nil then begin
                        BattleDBSender.PutPacket (ConnectID, BSBD_MAGICRESULT, 0, @MainMagicData, SizeOf (TMainMagicData));
                     end;
                  end;
                  exit;
               end;
               RetStr := GetToken (Str, ' ', 0);
               if RetStr = '@무공순위' then begin
                  MagicStr := GetToken (Str, ' ', 1);
                  if Trim (MagicStr) = '' then begin
                     SendChatMessage ('@무공순위 (권법가/검법가/도법가/창법가/퇴법가 중 한개)', SAY_COLOR_SYSTEM);
                  end else begin
                     MainMagicRank.rMainMagic := MagicStr;
                     MainMagicRank.rStart := 1;
                     MainMagicRank.rEnd := 50;

                     if BattleDBSender <> nil then begin
                        BattleDBSender.PutPacket (ConnectID, BSBD_GETMAINMAGICRANK, 0, @MainMagicRank, SizeOf (TGetMainMagicRank));
                     end;
                     exit;
                  end;
               end;
}
               if User = nil then begin
                  Case WhereStatus of
                     ws_inroom :
                        begin
                           if BattleRoom = nil then begin
                              ShareRoom.SendWatchMessage (CharName + ' : ' + str, SAY_COLOR_NORMAL);
                           end else begin
                              TBattleRoom (BattleRoom).SendWatchMessage (CharName + ' : ' + str, SAY_COLOR_NORMAL);
                           end;
                        end;
                     ws_room :
                        begin
                           ConnectorList.WaitRoomMessage (GroupTitle, CharName + ' : ' + Str, SAY_COLOR_NORMAL);
                        end;
                  end;
                  exit;
               end;
            end;
            if User <> nil then begin
               Move (aComData^, ComData, aComData^.cnt + SizeOf (Word));
               TUser (User).MessageProcess (ComData);
            end;
         end;
   end;
end;

procedure TConnector.BattleDBMessageProcess (aPacket : PTPacketData);
var
   pSendRankData : PTSendRankData;
   pSendRankPart : PTSendRankPart;
   pSendServerRankPart : PTSendServerRankPart;  
   i, nCount : Integer;
   Str, Dest : String;
begin
   Case aPacket^.RequestMsg of
      BDBS_SENDRANKDATA :
         begin
            if aPacket^.ResultCode = 0 then exit;
            pSendRankData := @aPacket^.Data;

            Win := pSendRankData^.rWin;
            Lose := pSendRankData^.rLose;
            DisConnected := pSendRankData^.rDisConnected;
            BattleRecord := pSendRankData^.rBattleRecord;
            Points := pSendRankData^.rPoints;
            Grade := pSendRankData^.rGrade;
         end;
      BDBS_SENDRANKPART :
         begin
            if aPacket^.ResultCode = 0 then exit;
            pSendRankPart := @aPacket^.Data;

            nCount := pSendRankPart^.rEnd - pSendRankPart^.rStart + 1;

            Str := '';
            Dest := '';
            for i := 0 to nCount - 1 do begin
               Str := IntToStr (pSendRankPart^.rData [i].rGrade) + '위 ' +
                  IntToStr (pSendRankPart^.rData [i].rPoints) + ' ' +
                  pSendRankPart^.rData [i].rCharName + ' ( ' +
                  pSendRankPart^.rData [i].rServerName + ' ) ' + ' <' +
                  IntToStr (pSendRankPart^.rData [i].rWin) + '승 ' +
                  IntToStr (pSendRankPart^.rData [i].rLose) + '패' + '>' + ',';
               Dest := Dest + Str;
            end;
            SendGradeList (Dest);
         end;
      BDBS_SENDSERVERRANK :
         begin
            exit;
            if aPacket^.ResultCode = 0 then exit;
            pSendServerRankPart := @aPacket^.Data;

            nCount := pSendServerRankPart^.rEnd - pSendServerRankPart^.rStart + 1;

            Str := '';
            Dest := '';
            for i := 0 to nCount - 1 do begin
               Str := pSendServerRankPart^.rData [i].rServerName + ' (' +
                  IntToStr (pSendServerRankPart^.rData [i].rPoints) + ')' + #13;
               Dest := Dest + Str;
            end;

            SendChatMessage (Dest, SAY_COLOR_NORMAL);
         end;
      BDBS_SENDMAINMAGICRANK :
         begin
            exit;
            if aPacket^.ResultCode = 0 then exit;
            pSendRankPart := @aPacket^.Data;

            nCount := pSendRankPart^.rEnd - pSendRankPart^.rStart + 1;

            Str := '';
            Dest := '';            
            for i := 0 to nCount - 1 do begin
               Str := IntToStr (pSendRankPart^.rData [i].rGrade) + '위 ' +
                  IntToStr (pSendRankPart^.rData [i].rPoints) + ' ' +
                  pSendRankPart^.rData [i].rCharName + ' ( ' +
                  pSendRankPart^.rData [i].rServerName + ' ) ' + ' <' +
                  IntToStr (pSendRankPart^.rData [i].rWin) + '승 ' +
                  IntToStr (pSendRankPart^.rData [i].rLose) + '패' + '>' + #13;
               Dest := Dest + Str;
            end;

            SendChatMessage (Dest, SAY_COLOR_NORMAL);
         end;
   end;
end;

procedure TConnector.AddReceiveData (aData : PChar; aSize : Integer);
begin
   if ReceiveBuffer.Put (aData, aSize) = false then begin
      frmMain.WriteLogInfo ('TConnector.AddReceiveData() failed');
   end;
end;

procedure TConnector.AddSendData (aData : PChar; aSize : Integer);
begin
   if aSize <= 4096 then begin
      GameServerConnectorList.AddSendData (GateNo, ConnectID, aData, aSize);
   end else begin;
      frmMain.WriteLogInfo ('TConnector.AddSendData Size > 4096');
   end;
end;

procedure TConnector.SearchPositionbyServer (aServerName : String; var aXpos, aYpos : Integer);
var
   i, Xpos, Ypos : Integer;
   DB : TUserStringDB;
   iName, ServerName, CharName : String;
begin
   ServerName := '';
   CharName := '';

   DB := TUserStringDB.Create;
   DB.LoadFromFile ('.\Setting\CreateSpecialArea.SDB');

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      ServerName := DB.GetFieldValueString (iName, 'Name');
      Xpos := DB.GetFieldValueInteger (iName, 'X');
      Ypos := DB.GetFieldValueInteger (iName, 'Y');

      if ServerName = aServerName then begin
         aXpos := Xpos;
         aYpos := Ypos;
         exit;
      end;
   end;
end;

function TConnector.SearchGradeStrList (aServerName, aCharName : String) : Boolean;
var
   i, j : Integer;
   Strs : Array [0..5] of String;
   Str : String;
begin
   Result := false;

   if (aCharName = '') or (aServerName = '') then exit;

   for i := 0 to GradeStrList.Count - 1 do begin
      Str := GradeStrList.Strings [i];
      for j := 0 to 5 do begin
         Str := GetValidStr3 (Str, Strs [j], ',');
         if Str = '' then break; 
      end;

      if (Strs[1] = aServerName) and (Strs[2] = aCharName) then begin
         Result := true;
         exit;
      end;
   end;
end;

function TConnector.SearchExtremeMagic (aStr : String) : String;
var
   i, nMagic : Integer;
   MagicData : TMagicData;
begin
   Result := '';
   nMagic := 0;

   if aStr = '권법가' then begin
      for i := 0 to HAVEMAGICSIZE - 1 do begin
         MagicClass.GetMagicData (StrPas (@CharData.HaveMagicArr[i].Name), MagicData, CharData.HaveMagicArr [i].Skill);
         if (MagicData.rMagicType = MAGICTYPE_WRESTLING) and (MagicData.rcSkillLevel = 9999) then begin
            inc (nMagic);               
         end;
      end;
      if (nMagic = 6) and (GetLevel (CharData.BasicMagicArr[0].Skill) = 9999) then begin
         Result := aStr; 
      end;
      exit;
   end;
   if aStr = '검법가' then begin
      for i := 0 to HAVEMAGICSIZE - 1 do begin
         MagicClass.GetMagicData (StrPas (@CharData.HaveMagicArr[i].Name), MagicData, CharData.HaveMagicArr [i].Skill);
         if (MagicData.rMagicType = MAGICTYPE_FENCING) and (MagicData.rcSkillLevel = 9999) then begin
            inc (nMagic);
         end;
      end;
      if (nMagic = 6) and (GetLevel (CharData.BasicMagicArr[1].Skill) = 9999) then begin
         Result := aStr;
      end;
      exit;
   end;
   if aStr = '도법가' then begin
      for i := 0 to HAVEMAGICSIZE - 1 do begin
         MagicClass.GetMagicData (StrPas (@CharData.HaveMagicArr[i].Name), MagicData, CharData.HaveMagicArr [i].Skill);
         if (MagicData.rMagicType = MAGICTYPE_SWORDSHIP) and (MagicData.rcSkillLevel = 9999) then begin
            inc (nMagic);
         end;
      end;
      if (nMagic = 6) and (GetLevel (CharData.BasicMagicArr[2].Skill) = 9999) then begin
         Result := aStr;
      end;
      exit;
   end;
   if aStr = '퇴법가' then begin
      for i := 0 to HAVEMAGICSIZE - 1 do begin
         MagicClass.GetMagicData (StrPas (@CharData.HaveMagicArr[i].Name), MagicData, CharData.HaveMagicArr [i].Skill);
         if (MagicData.rMagicType = MAGICTYPE_HAMMERING) and (MagicData.rcSkillLevel = 9999) then begin
            inc (nMagic);
         end;
      end;
      if (nMagic = 6) and (GetLevel (CharData.BasicMagicArr[3].Skill) = 9999) then begin
         Result := aStr;
      end;
      exit;
   end;
   if aStr = '창법가' then begin
      for i := 0 to HAVEMAGICSIZE - 1 do begin
         MagicClass.GetMagicData (StrPas (@CharData.HaveMagicArr[i].Name), MagicData, CharData.HaveMagicArr [i].Skill);
         if (MagicData.rMagicType = MAGICTYPE_SPEARING) and (MagicData.rcSkillLevel = 9999) then begin
            inc (nMagic);
         end;
      end;
      if (nMagic = 6) and (GetLevel (CharData.BasicMagicArr[4].Skill) = 9999) then begin
         Result := aStr;
      end;
      exit;
   end;
end;

procedure TConnector.SendBattleGroupList (aType : Byte);
var
   ComData : TWordComData;
   psShowGroupList : PTSShowListWindow;
begin
   psShowGroupList := @ComData.Data;
   BattleGroupList.GetBattleGroupData (psShowGroupList, aType);

   ComData.Cnt := sizeof(TSShowListWindow) - sizeof(TWordString) + sizeofwordstring(psShowGroupList^.rWordString);
   AddSendData (@ComData, ComData.Cnt + SizeOf (Word));
end;

procedure TConnector.SendBattleRoomList (aGroupTitle : String; aType : Byte);
var
   ComData : TWordComData;
   psShowRoomList : PTSShowListWindow;
begin
   psShowRoomList := @ComData.Data;
   BattleGroupList.GetBattleRoomData (psShowRoomList, aGroupTitle, aType);

   ComData.Cnt := sizeof(TSShowListWindow) - sizeof(TWordString) + sizeofwordstring(psShowRoomList^.rWordString);
   AddSendData (@ComData, ComData.Cnt + SizeOf (Word));
end;

procedure TConnector.SendGradeList (aWordStr : String);
var
   ComData : TWordComData;
   psShowListWindow : PTSShowListWindow;
begin
   psShowListWindow := @ComData.Data;

   with psShowListWindow^ do begin
      rMsg := SM_SHOWSPECIALWINDOW;
      rWindow := WINDOW_GRADEWINDOW;
      rType := 0;
      SetWordString (rWordString, aWordStr);

      ComData.Cnt := sizeof(TSShowListWindow) - sizeof(TWordString) + sizeofwordstring(rwordstring);
   end;      
   AddSendData (@ComData, ComData.Cnt + SizeOf (Word));
end;

function TConnector.GetCharAge : Integer;
begin
   Result := GetLevel (CharData.Light + CharData.Dark);
end;

procedure TConnector.SendChatMessage (astr: string; aColor: byte);
var
   ComData : TWordComData;
   psChatMessage : PTSChatMessage;
begin
   psChatMessage := @ComData.Data;
   with psChatMessage^ do begin
      rmsg := SM_CHATMESSAGE;
      case acolor of
         SAY_COLOR_NORMAL : begin rFColor := WinRGB (22,22,22); rBColor := WinRGB (0, 0 ,0); end;
         SAY_COLOR_SHOUT  : begin rFColor := WinRGB (22,22,22); rBColor := WinRGB (0, 0 ,24); end;
         SAY_COLOR_SYSTEM : begin rFColor := WinRGB (22,22, 0); rBColor := WinRGB (0, 0 ,0); end;
         SAY_COLOR_NOTICE : begin rFColor := WinRGB (255 div 8, 255 div 8, 255 div 8); rBColor := WinRGB (133 div 8, 133 div 8, 133 div 8); end;

         SAY_COLOR_GRADE0 : begin rFColor := WinRGB (18, 16, 14); rBColor := WinRGB (2,4,5); end;
         SAY_COLOR_GRADE1 : begin rFColor := WinRGB (26, 23, 21); rBColor := WinRGB (2,4,5); end;
         SAY_COLOR_GRADE2 : begin rFColor := WinRGB (31, 29, 27); rBColor := WinRGB (2,4,5); end;
         SAY_COLOR_GRADE3 : begin rFColor := WinRGB (22, 18,  8); rBColor := WinRGB (1,4,11); end;
         SAY_COLOR_GRADE4 : begin rFColor := WinRGB (23, 13,  4); rBColor := WinRGB (1,4,11); end;
         SAY_COLOR_GRADE5 : begin rFColor := WinRGB (31, 29, 21); rBColor := WinRGB (1,4,11); end;

         else begin rFColor := WinRGB (22,22,22); rBColor := WinRGB (0, 0 ,0); end;
      end;

      SetWordString (rWordstring, aStr);
      ComData.Cnt := Sizeof(TSChatMessage) - Sizeof(TWordString) + sizeofwordstring(rWordString);
   end;
   AddSendData (@ComData, ComData.Cnt + SizeOf (Word));
end;

procedure TConnector.SendMap (var aSenderInfo: TBasicData; amap, aobj, arof, atil, aSoundBase: string);
var
   ComData : TWordComData;
   psNewMap : PTSNewMap;
begin
   psNewMap := @ComData.Data;
   FillChar (psNewMap^, SizeOf (TSNewMap), 0);
   with psNewMap^ do begin
      rmsg := SM_NEWMAP;
      StrPCopy (@rMapName, aMap);
      StrCopy (@rCharName, @aSenderInfo.Name);
      rId := aSenderInfo.id;
      rx := aSenderInfo.x;
      ry := aSenderInfo.y;
      StrPCopy (@rObjName, aobj);
      StrPCopy (@rRofName, arof);
      StrPCopy (@rTilName, atil);
      ComData.Cnt := SizeOf (TSNewMap);
   end;
   AddSendData (@ComData, ComData.Cnt + SizeOf (Word));
end;

procedure TConnector.SendShowCenterMessage (aStr : String; aColor : Word);
var
   ComData : TWordComData;
   psShowCenterMsg : PTSShowCenterMsg;
begin
   psShowCenterMsg := @ComData.Data;

   with psShowCenterMsg^ do begin
      rMsg := SM_SHOWCENTERMSG;
      rColor := aColor;
      SetWordString (rText, aStr);
      ComData.Cnt := SizeOf (TSShowCenterMsg) - SizeOf (TWordString) + SizeOfWordString (rText);
   end;
   AddSendData (@ComData, ComData.Cnt + SizeOf (Word));
end;

procedure TConnector.SendShow (var aSenderinfo: TBasicData);
var
   ComData : TWordComData;
   psShow : PTSShow;
   str : shortstring;
begin
   if (aSenderInfo.Feature.rrace = RACE_HUMAN) or (aSenderInfo.Feature.rRace = RACE_MONSTER)
      or (aSenderInfo.Feature.rRace = RACE_NPC) then begin
      psShow := @ComData.Data;
      with psShow^ do begin
         str := StrPas (@aSenderInfo.Name);

         if aSenderInfo.ServerName [0] <> 0 then
            str := str + ',' + StrPas (@aSenderInfo.ServerName);

         if Length (str) >= 18 then str := Copy (str, 1, 18);

         rmsg := SM_SHOW;
         rId := aSenderInfo.id;
         StrPCopy (@rNameString, str);
         rdir := aSenderInfo.dir;
         rx := aSenderInfo.x;
         ry := aSenderInfo.y;
         rFeature := aSenderInfo.Feature;
         if rFeature.rrace = RACE_NPC then rFeature.rrace := RACE_MONSTER;
         SetWordString (rWordString, '');

         ComData.Cnt := sizeof(TSShow)-sizeof(twordstring)+sizeofwordstring(rwordstring);
      end;
      AddSendData (@ComData, ComData.Cnt + SizeOf (Word));
      exit;
   end;
end;

function TConnector.GetToken (aStr : String; aDivStr : Char; aTime : Integer) : String;
var
   Strs : array [0..5] of string;
   Dest : String;
   i : Integer;
begin
   Dest := aStr;

   for i := 0 to 5 do begin
      Dest := GetValidStr3 (Dest, Strs[i], aDivStr);
      if Dest = '' then break;
   end;

   Result := Strs [aTime];   
end;

// TConnectorList
constructor TConnectorList.Create;
begin
   CurProcessPos := 0;
   ConnectorProcessCount := 0;

   CreateTick := 0;
   DeleteTick := 0;
   SaveTick := 0;

   UniqueKey := TIntegerKeyClass.Create;
   NameKey := TStringKeyClass.Create;

   DataList := TList.Create;

   SaveBuffer := TPacketBuffer.Create (1024 * 1024 * 4);
end;

destructor TConnectorList.Destroy;
begin
   Clear;
   UniqueKey.Free;
   NameKey.Free;
   DataList.Free;

   SaveBuffer.Free;

   inherited Destroy;
end;

procedure TConnectorList.Clear;
var
   i : Integer;
   Connector : TConnector;
begin
   UniqueKey.Clear;
   NameKey.Clear;

   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      Connector.Free;
   end;
   DataList.Clear;

   SaveBuffer.Clear;
end;

procedure TConnectorList.Update (CurTick : Integer);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := DataList.Count - 1 downto 0 do begin
      Connector := DataList.Items [i];
      if Connector.FboAllowDelete = true then begin
         UniqueKey.Delete (1000000000 * Connector.GateNo + Connector.ConnectID);
         NameKey.Delete (Connector.Name);
         Connector.Free;
         DataList.Delete (i);
         continue;
      end;
      Connector.Update (CurTick);
   end;

   {
   ConnectorProcessCount := (DataList.Count * 4 div 100);
   if ConnectorProcessCount = 0 then ConnectorProcessCount := DataList.Count;

   ConnectorProcessCount := ProcessListCount;

   if DataList.Count > 0 then begin
      StartPos := CurProcessPos;
      for i := 0 to ConnectorProcessCount - 1 do begin
         if CurProcessPos >= DataList.Count then CurProcessPos := 0;
         Connector := DataList.Items [CurProcessPos];
         Connector.Update (CurTick);
         Inc (CurProcessPos);
         if CurProcessPos = StartPos then break;
      end;
   end;
   }
end;

function TConnectorList.GetCount : Integer;
begin
   Result := DataList.Count;
end;

function TConnectorList.GetNameKeyCount : Integer;
begin
   Result := NameKey.Count;
end;

function TConnectorList.GetUniqueKeyCount : Integer;
begin
   Result := UniqueKey.Count;
end;

function TConnectorList.CreateConnect (aGateNo : Integer; aPacket : PTPacketData) : TConnector;
var
   Connector : TConnector;
   pcd : PTDBRecord;
   GateNo, ConnectID : Integer;
   ServerName : String;
begin
   Result := nil;

   GateNo := aGateNo;
   ConnectID := aPacket^.RequestID;

   pcd := @aPacket^.Data;

   ServerName := GameServerConnectorList.GetGameServerName (aGateNo);
   if ServerName = '' then begin
      GameServerConnectorList.AddSendServerData (aGateNo, aPacket^.RequestID, BG_USERCLOSE, nil, 0);
      exit;
   end;

   Connector := NameKey.Select (StrPas (@pcd^.PrimaryKey) + ' (' + ServerName + ')');
   if Connector <> nil then begin
      DeleteConnect (Connector.GateNo, Connector.ConnectID);
      GameServerConnectorList.AddSendServerData (aGateNo, aPacket^.RequestID, BG_USERCLOSE, nil, 0);
      exit;
   end;

   Connector := TConnector.Create (ServerName, GateNo, ConnectID);
   if Connector.StartLayer (@aPacket^.Data) = false then begin
      Connector.Free;
      GameServerConnectorList.AddSendServerData (aGateNo, aPacket^.RequestID, BG_USERCLOSE, nil, 0);
      exit;
   end;

   UniqueKey.Insert (1000000000 * GateNo + ConnectID, Connector);
   NameKey.Insert (Connector.Name, Connector);

   DataList.Add (Connector);

   frmMain.AddLog ('Start ' + Connector.Name); // for test;
   frmMain.AddUser (Connector.Name);

   Result := Connector;
end;

procedure TConnectorList.DeleteConnect (aGateNo, aConnectID : Integer);
var
   nPos : Integer;
   Connector : TConnector;
begin
   Connector := UniqueKey.Select (1000000000 * aGateNo + aConnectID);
   if Connector <> nil then begin
      nPos := DataList.IndexOf (Connector);
      UniqueKey.Delete (1000000000 * Connector.GateNo + Connector.ConnectID);
      NameKey.Delete (Connector.Name);
      Connector.Free;
      DataList.Delete (nPos);
   end;
end;

procedure TConnectorList.CloseAllConnect;
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      GameServerConnectorList.AddSendServerData (Connector.GateNo, Connector.ConnectID, GM_DISCONNECT, nil, 0);
   end;
end;
{
procedure TConnectorList.CloseConnectByCharName (aName : String);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := DataList.Count - 1 downto 0 do begin
      Connector := DataList.Items [i];
      if Connector.Name = aName then begin
         GameServerConnectorList.AddSendServerData (Connector.GateNo, Connector.ConnectID, GM_DISCONNECT, nil, 0);
         exit;
      end;
   end;
end;

procedure TConnectorList.CloseConnectByGateNo (aGateNo : Integer);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := DataList.Count - 1 downto 0 do begin
      Connector := DataList.Items [i];
      if Connector.GateNo = aGateNo then begin
         DeleteConnect (aGateNo, Connector.ConnectID);
      end;
   end;
end;
}
procedure TConnectorList.AddReceiveData (aGateNo : Integer; aPacket : PTPacketData);
var
   ComData : TWordComData;
   Connector : TConnector;
begin
   Connector := UniqueKey.Select (1000000000 * aGateNo + aPacket^.RequestID);
   if Connector <> nil then begin
      ComData.Cnt := aPacket^.PacketSize - (SizeOf (Word) + SizeOf (Integer) + SizeOf (Byte) * 2);
      Move (aPacket^.Data, ComData.Data, ComData.Cnt);
      Connector.AddReceiveData (@ComData, ComData.Cnt + SizeOf (Word));
      exit;
   end;
end;

{
procedure TConnectorList.AddSaveData (aData : PChar; aSize : Integer);
begin
   SaveBuffer.Put (aData, aSize);
end;
}

function TConnectorList.GetSaveListCount : Integer;
begin
   Result := SaveBuffer.Count;
end;

procedure TConnectorList.BattleDBMessageProcess (aPacket : PTPacketData);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.ConnectID = aPacket^.RequestID then begin
         Connector.BattleDBMessageProcess (aPacket);
         exit;
      end;
   end;
end;

procedure TConnectorList.SendLatestList (aWhereStatus : TWhereStatus; aData : PChar; aSize : Integer);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.WhereStatus = aWhereStatus then begin
         Connector.AddSendData (aData, aSize);
      end;
   end;
end;

procedure TConnectorList.SendLatestRoomList (aGroupTitle : String; aData : PChar; aSize : Integer);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.WhereStatus = ws_room then begin
         if Connector.GroupTitle = aGroupTitle then begin
            Connector.AddSendData (aData, aSize);
         end;
      end;
   end;
end;

procedure TConnectorList.WaitRoomMessage (aGroupTitle : String; aStr : String; aColor : Byte);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.GroupTitle = aGroupTitle then begin
         if Connector.WhereStatus = ws_room then begin
            Connector.SendChatMessage (aStr, aColor);
         end;
      end;
   end;
end;

procedure TConnectorList.ShoutMessage (aStr : String; aColor : Byte);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      Connector.SendChatMessage (aStr, aColor);
   end;
end;

end.
