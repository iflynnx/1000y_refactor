unit uGuild;

interface

uses
  Windows, Classes, SysUtils, svClass, subutil, uAnsTick, AnsUnit,
  BasicObj, FieldMsg, MapUnit, DefType, Autil32, uMonster, uGramerid, UUser,
  IniFiles, uLevelexp, uManager, AnsStringCls, UserSDB;

const
   // DEC_GUILD_DURA_TICK = 200;
   DEC_GUILD_DURA_TICK = 500;

   // 2000.09.16 문파초석의 내구성 증가치 5000으로 수정 by Lee.S.G
   // ADD_GUILD_DURA_BY_SYSOP = 4000;
   ADD_GUILD_DURA_BY_SYSOP = 5000;
   ADD_GUILD_DURA_BY_SUBSYSOP = 1000;
   DEC_GUILD_DURA_BY_HIT = 20;

   MAX_GUILD_DURA = 1100000;

   GUILDSTONE_IMAGE_NUMBER = 67;

   MAX_SUBSYSOP_COUNT = 3;
   MAX_AGREESUBSYSOP_COUNT = 1;
   MAX_AGREECHAR_COUNT = 1;
   MAX_GUILDNPC_COUNT = 5;
   MaX_GUILDWEAR_COUNT = 2;

type
   TGuildObject = class (TBasicObject)
   private
      FGuildName : String;
      SelfData : TCreateGuildData;
      MakeGuildData : PTMakeGuildData;

      GuildNpcList : TList;
      DieGuildNpcList : TList;
      GuildUserList : TGuildUserList;
      DuraTick : integer;

      boAddGuildMagic : Boolean;

      AgreeList : TStringList;

      function    AddGuildNpc (aName : String; aX, aY : Integer): Boolean;
   protected
      procedure   Initial;
      procedure   StartProcess; override;
      procedure   EndProcess; override;
      function    FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
      function    GetUserGrade (uname: string) : string;
      function    GetGuildNpcbyName (aname: string) : integer;
   public
      constructor Create;
      destructor  Destroy; override;

      procedure   Clear;
      procedure   LoadFromFile (aGuildName: String);
      procedure   SaveToFile;

      procedure   GetGuildInfo (aUser: TUser);
      function    MoveStone (aServerID, ax, ay: integer) : Boolean;
      function    CreateStone (aSysopName : String; aServerID, ax, ay: integer) : Boolean;

      function    MakeGuild (aMakeGuildData : PTCMakeGuildData; aUser : TUser) : Boolean;
      procedure   AgreeMakeGuild (aName : String; aFlag : Boolean);
      procedure   ShowGuildInfo (aUser : TUser);

      procedure   Update (CurTick: integer); override;

      function    IsGuildUser (aName : String) : Boolean;
      function    IsGuildNpc (aName : String) : Boolean;

      function    GetSelfData : PTCreateGuildData;

      property    GuildName : String read FGuildName;
   end;

   TGuildList = class
   private
      CurProcessPos : Integer;
      DataList : TList;
      
      function    GetCount: Integer;
   public
      constructor Create;
      destructor  Destroy; override;

      procedure   Clear;

      procedure   LoadFromFile (aFileName : String);
      procedure   SaveToFile (aFileName : String);

      function    GetGuildBySysop (aSysopName : String) : TGuildObject;
      function    GetGuildByName (aGuildName : String) : TGuildObject;
      
      procedure   AllowGuildName (gid: integer; aboAllow: Boolean; aGuildName, aSysopName: string);
      function    AllowGuildCondition (gname, uname: String; var aRetStr : String) : Boolean; 
      function    AddGuildObject (aGuildName, aOwnerName : String; aServerID, aX, aY: integer): TGuildObject;
      function    GetUserGrade (aGuildName, uname: string): string;
      function    GetGuildServerID (aGuildName : String): Integer;
      procedure   GetGuildInfo (aGuildName: string; aUser: TUser);
      function    CheckGuildUser(aGuildName, aName : String) : Boolean;
      function    MoveStone (aGuildName : string; aServerID, ax, ay: integer) : Boolean;
      function    CreateStone (aGuildName, aSysopName : string; aServerID, ax, ay: integer) : Boolean;
      procedure   DeleteStone (aGuildName : String);
      procedure   CompactGuild;

      procedure   Update (CurTick: integer);
      property    Count : integer read GetCount;
   end;

var
   GuildList : TGuildList;

implementation

uses
   SVMain;

////////////////////////////////////////////////////
//
//             ===  GuildObject  ===
//
////////////////////////////////////////////////////

constructor TGuildObject.Create;
begin
   inherited Create;

   FGuildName := '';

   FillChar (SelfData, SizeOf (TCreateGuildData), 0);
   MakeGuildData := nil;

   GuildNpcList := TList.Create;
   DieGuildNpcList := TList.Create;
   GuildUserList := TGuildUserList.Create;

   AgreeList := TStringList.Create;
end;

destructor  TGuildObject.Destroy;
begin
   if MakeGuildData <> nil then begin
      Dispose (MakeGuildData);
      MakeGuildData := nil;
   end;

   Clear;
   GuildUserList.Free;
   GuildNpcList.Free;
   DieGuildNpcList.Free;
   
   AgreeList.Free;

   inherited Destroy;
end;

procedure TGuildObject.Clear;
var
   i : Integer;
   GuildNpc : TGuildNpc;
begin
   for i := 0 to DieGuildNpcList.Count - 1 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      GuildNpc.Free;
   end;
   DieGuildNpcList.Clear;
   
   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      GuildNpc.EndProcess;
      GuildNpc.Free;
   end;
   GuildNpcList.Clear;
   GuildUserList.Clear;
end;

function TGuildObject.GetSelfData : PTCreateGuildData;
begin
   Result := @SelfData;
end;

function TGuildObject.IsGuildUser (aName : String) : boolean;
begin
   Result := GuildUserList.IsGuildUser(aName);
end;

function TGuildObject.IsGuildNpc (aName : String) : Boolean;
var
   i : Integer;
   GuildNpc : TGuildNpc;
begin
   Result := false;

   if aName = '' then exit;
   
   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      if GuildNpc.GuildNpcName = aName then begin
         Result := true;
         exit;
      end;
   end;
   for i := 0 to DieGuildNpcList.Count - 1 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      if GuildNpc.GuildNpcName = aName then begin
         Result := true;
         exit;
      end;
   end;
end;

procedure TGuildObject.SaveToFile;
var
   i, j, nIndex : Integer;
   GuildNpc : TGuildNpc;
begin
   if SelfData.Name = '' then exit;

   FillChar (SelfData.GuildNpc, SizeOf (SelfData.GuildNpc), 0);
   nIndex := 0;
   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      if GuildNpc.boMagicNpc = true then begin
         SelfData.MagicExp := GuildNpc.GuildMagicData.rSkillExp;
      end;
      SelfData.GuildNpc[nIndex].rName := GuildNpc.GuildNpcName;
      SelfData.GuildNpc[nIndex].rX := GuildNpc.StartX;
      SelfData.GuildNpc[nIndex].rY := GuildNpc.StartY;
      Inc (nIndex);
   end;
   for i := 0 to DieGuildNpcList.Count - 1 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      if GuildNpc.boMagicNpc = true then begin
         SelfData.MagicExp := GuildNpc.GuildMagicData.rSkillExp;
      end;
      SelfData.GuildNpc[nIndex].rName := GuildNpc.GuildNpcName;
      SelfData.GuildNpc[nIndex].rX := GuildNpc.StartX;
      SelfData.GuildNpc[nIndex].rY := GuildNpc.StartY;
      Inc (nIndex);
   end;

   GuildUserList.SaveToFile ('.\Guild\' + SelfData.Name + 'GUser.sdb');
end;

procedure TGuildObject.LoadFromFile;
begin
   if not FileExists ('.\Guild\' + SelfData.Name + 'GUser.SDB') then exit;

   GuildUserList.LoadFromFile ('.\Guild\' + SelfData.Name + 'GUser.sdb');
end;

function TGuildObject.GetUserGrade (uName: String) : String;
var
   i : Integer;
begin
   if uName = SelfData.Sysop then
      inc (SelfData.Durability, ADD_GUILD_DURA_BY_SYSOP);
   for i := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
      if uName = SelfData.SubSysop[i] then
         inc (SelfData.Durability, ADD_GUILD_DURA_BY_SUBSYSOP);
   end;
   if SelfData.Durability > SelfData.MaxDurability then
      SelfData.Durability := SelfData.MaxDurability;

   Result := GuildUserList.GetGradeName (uName);
end;

procedure TGuildObject.GetGuildInfo (aUser: TUser);
var
   i : Integer;
   tmpStr, Sep : String;
begin
   tmpStr := SelfData.Name + ' (' + IntToStr (BasicData.X) + ',' + IntToStr (BasicData.Y) + ')';
   aUser.SendClass.SendChatMessage ('문파이름 : ' + tmpStr, SAY_COLOR_NORMAL);
   aUser.SendClass.SendChatMessage ('문주 : ' + SelfData.Sysop, SAY_COLOR_NORMAL);

   tmpStr := '부문주 : ';
   Sep := '';
   for i := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
      if SelfData.SubSysop[i] <> '' then begin
         tmpStr := tmpStr + Sep + SelfData.SubSysop[i] + Sep;
         Sep := ', ';
      end;
   end;
   aUser.SendClass.SendChatMessage (tmpStr, SAY_COLOR_NORMAL);
end;

function TGuildObject.AddGuildNpc (aName: string; ax, ay: integer): Boolean;
var
   i : integer;
   GuildNpc : TGuildNpc;
begin
   Result := FALSE;

   if GetGuildNpcByName (aName) <> -1 then exit;

   for i := 0 to MAX_GUILDNPC_COUNT - 1 do begin
      if SelfData.GuildNpc[i].rName = '' then begin
         SelfData.GuildNpc[i].rName := aName;
         SelfData.GuildNpc[i].rX := aX;
         SelfData.GuildNpc[i].rY := aY;

         GuildNpc := TGuildNpc.Create;
         GuildNpc.SetManagerClass (Manager);

         GuildNpc.Initial (Self, SelfData.GuildNpc[i].rName, SelfData.GuildNpc[i].rX, SelfData.GuildNpc[i].rY);

         if (SelfData.GuildMagic <> '') and (boAddGuildMagic = false) then begin
            GuildNpc.boMagicNpc := true;
            StrPCopy (@GuildNpc.BasicData.Guild, SelfData.GuildMagic);
            MagicClass.GetMagicData (SelfData.GuildMagic, GuildNpc.GuildMagicData, SelfData.MagicExp);
            boAddGuildMagic := true;
         end;
         DieGuildNpcList.Add (GuildNpc);
         
         Result := TRUE;
         exit;
      end;
   end;
end;

function  TGuildObject.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i, n, percent : integer;
//   xx, yy: word;
   str1, str2, str3: string;
   str, gname : string;
   sayer, objectname, gradename: string;
   SubData: TSubData;
   BO: TBasicObject;
   GuildNpc : TGuildNpc;

   MakeGuildWindow : TSShowMakeGuildWindow;
   pUser : TUser;
begin
   Result := PROC_FALSE;
   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;

   case Msg of
      FM_CLICK :
         begin
            if SelfData.Name = '' then Exit;

            pUser := TUser (GetViewObjectByID (SenderInfo.id));
            if pUser <> nil then begin
               ShowGuildInfo (pUser);
            end;
         end;
      FM_ADDITEM:
         begin
            if SelfData.Name = '' then Exit;

            if aSubData.ItemData.rkind = ITEM_KIND_DUMMY then begin
               if GuildNpcList.Count + DieGuildNpcList.Count >= MAX_GUILDNPC_COUNT then begin
                  BocSay ('더이상 만들수 없습니다.');
                  exit;
               end;
               i := 0;
               while true do begin
                  gName := INI_GUILD_NPC_NAME + IntToStr(i);
                  if GetGuildNpcByName (gName) = -1 then begin
                     AddGuildNpc (gName, BasicData.X, BasicData.Y);
                     Result := PROC_TRUE;
                     break;
                  end;
                  Inc (i);
               end;
            end;
         end;
      FM_HIT :
         begin
            if SelfData.Name <> '' then begin
               if isHitedArea (SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then begin
                  UserList.GuildSay (SelfData.Name, SelfData.Name + ': ' + format ('%s을 누가 때립니다.',[INI_GUILD_STONE]));
                  Dec (SelfData.Durability, DEC_GUILD_DURA_BY_HIT);
                  if SelfData.Durability <= 0 then begin
                     // FboAllowDelete := TRUE;
                  end;
                  BocSay (IntToStr (SelfData.Durability));
                  SubData.TargetId := SenderInfo.id;
                  for i := 0 to GuildNpcList.Count - 1 do begin
                     GuildNpc := GuildNpcList.Items [i];
                     if GuildNpc.FieldProc (NOTARGETPHONE, FM_GUILDATTACK, BasicData, SubData) = PROC_TRUE then begin
                        break;
                     end;
                  end;
               end;
            end;
{
            xx := SenderInfo.x; yy := SenderInfo.y;
            GetNextPosition (SenderInfo.dir, xx, yy);
            if (BasicData.x = xx) and (BasicData.y = yy) then begin
               UserList.GuildSay (GuildName, GuildName+ ': '+format ('%s을 누가 때립니다.',[INI_GUILD_STONE]));
               Dec (GuildDurability, DEC_GUILD_DURA_BY_HIT);
               BocSay (IntToStr (GuildDurability));
               SubData.TargetId := SenderInfo.id;
               for i := 0 to AnsList.Count -1 do
                  if TGuildNpc (AnsList[i]).FieldProc (NOTARGETPHONE, FM_GUILDATTACK, BasicData, SubData) = PROC_TRUE then break;
            end;
}
         end;
      FM_PICKUP :
         begin
            if FboAllowDelete then exit;
            if (SelfData.Name = '') and (SelfData.Sysop <> '') then begin
               if (StrPas (@SenderInfo.Name) = SelfData.Sysop) then begin
                  ItemClass.GetItemData (INI_Guild_STONE, SubData.ItemData);
                  SignToItem (SubData.ItemData, Manager.ServerID, SenderInfo, '');
                  SubData.ServerId := Manager.ServerId;
                  if TFieldPhone(Manager.Phone).SendMessage (SenderInfo.id, FM_ADDITEM, BasicData, SubData) = PROC_TRUE then begin
                     FboAllowDelete := TRUE;
                     exit;
                  end;
               end;
            end;
         end;
      FM_SAY :
         begin
            if FboAllowDelete then exit;
            if SenderInfo.id = BasicData.id then exit;

            if StrPas (@SenderInfo.Name) = SelfData.Sysop then begin
               str := GetWordString (aSubData.SayString);
               if ReverseFormat (str, '%s: 문파창설', str1, str2, str3, 1) then begin
                  FillChar (MakeGuildWindow, SizeOf (TSShowMakeGuildWindow), 0);
                  MakeGuildWindow.rMsg := SM_SHOWSPECIALWINDOW;
                  MakeGuildWindow.rWindow := WINDOW_GUILDMAKE;
                  MakeGuildWindow.rSysopName := SelfData.Sysop;

                  pUser := UserList.GetUserPointerById (SenderInfo.id);
                  if pUser <> nil then begin
                     pUser.SendClass.SendData (@MakeGuildWindow, SizeOf (TSShowMakeGuildWindow));
                  end;
                  exit;
               end;
            end;

            if StrPas (@SenderInfo.Name) = SelfData.Sysop then begin
               str := GetWordString (aSubData.SayString);

               if ReverseFormat (str, '%s: %s 문파를 만든다', str1, str2, str3, 2) then begin
                  if (not isFullHangul (str2)) or (not isGrammarID(str2)) or (Length(str2) > 12) or (Length(str2) < 2) then begin
                     BocSay ( '문파이름이 잘못되었습니다.');
                     exit;
                  end;
                  SubData.ServerId := Manager.ServerId;
                  StrPCopy (@SubData.SubName, Str1);
                  StrPCopy (@SubData.GuildName, Str2);
                  if TFieldPhone (Manager.Phone).SendMessage (MANAGERPHONE, FM_ALLOWGUILDNAME, BasicData, SubData) = PROC_FALSE then begin
                     BocSay ( '이미 문파이름이 있거나,');
                     BocSay ( '부문주나 문주로 등록되어 있습니다.');
                     BocSay ( '문파를 만들 수 없습니다.');
                     exit;
                  end else begin
                     BocChangeProperty;
                  end;
                  exit;
               end;
            end;
            if SelfData.Name = '' then exit;

            str := GetwordString (aSubData.SayString);
            if Pos ('탈퇴 시켜주세요',str) > 0 then begin
               str := GetValidStr3 (str, sayer, ':');
               // 2000.09.18 NPC의 이름과 User의 이름이 같을때 검색오류버그 수정 by Lee.S.G
               // 탈퇴는 RACE_HUMAN에서만 유효하다
               Bo := GetViewObjectByName (sayer, RACE_HUMAN);
               if Bo = nil then exit;
               if not (Bo is TUser) then exit;
               TUser(Bo).GuildName := '';
               TUser(Bo).GuildGrade := '';
               StrPCopy(@TUser(Bo).BasicData.Guild, '');
               TUser(Bo).BocChangeProperty;
               BocSay ('탈퇴 되었습니다.');
               exit;
            end;

            str := GetWordString (aSubData.SayString);
            if Pos ('제명 시켜주세요', str) > 0 then begin
               str := GetValidStr3 (str, sayer, ':');
               Bo := GetViewObjectByName (sayer, RACE_HUMAN);
               if Bo = nil then exit;
               if not (Bo is TUser) then exit;
               if (sayer <> SelfData.SubSysop[0]) and (sayer <> SelfData.SubSysop[1]) and (sayer <> SelfData.SubSysop[2]) then begin
                  BocSay ('부문주에 임명되어 있지 않습니다.');
                  exit;
               end;
               if sayer = SelfData.SubSysop[0] then SelfData.SubSysop[0] := ''
               else if sayer = SelfData.SubSysop[1] then SelfData.SubSysop[1] := ''
               else if sayer = SelfData.SubSysop[2] then SelfData.SubSysop[2] := '';
               BocSay ('부문주에서 제명 되었습니다.');
               exit;
            end;

            str := GetwordString (aSubData.SayString);
            if ReverseFormat (str, '%s: ', sayer, str2, str3, 1) then begin
               if (sayer <> SelfData.Sysop) and (sayer <> SelfData.SubSysop[0])
                  and (sayer <> SelfData.SubSysop[1]) and (sayer <> SelfData.SubSysop[2]) then exit;
            end;

            if ReverseFormat (str, '%s: %s님을 가입시킨다', sayer, objectname, str3, 2) then begin
               // 2000.09.18 NPC의 이름과 User의 이름이 같을때 검색오류버그 수정 by Lee.S.G
               // 가입은 RACE_HUMAN에서만 유효하다
               Bo := GetViewObjectByName (objectname, RACE_HUMAN);
               if Bo = nil then begin BocSay (format ('%s님은 없습니다.',[objectname])); exit; end;
               if not (Bo is TUser) then begin BocSay (format ('%s님은 사용자가 아닙니다.',[objectname])); exit; end;
               if TUser(Bo).GuildName = SelfData.Name then begin BocSay (format ('%s님은 가입되어 있습니다.',[objectname])); exit; end;
               if TUser(Bo).GuildName <> '' then begin BocSay (format ('%s님은 다른 문파 입니다.',[objectname])); exit; end;
               TUser(Bo).GuildName := SelfData.Name;
               // 2000.09.16 문주나 부문주의 가입시 문파초석의 내구성을 증가시키기 위해
               // GetUserGrade() 를 호출한다 by Lee.S.G
               TUser(Bo).GuildGrade := GetUserGrade (objectname);
               StrPCopy (@TUser(Bo).BasicData.Guild, SelfData.Name);
               GuildUserList.AddUser (objectname);
               TUser(Bo).BocChangeProperty;
               BocSay (format ('%s님을 가입시켰습니다.',[objectname]));
            end;
            if ReverseFormat (str, '%s: %s님을 탈퇴시킨다', sayer, objectname, str3, 2) then begin
               if GuildUserList.DelUser (objectname) then begin
                  BocSay (format ('%s님을 탈퇴시켰습니다.',[objectname]));
                  SubData.ServerId := Manager.ServerId;
                  StrPCopy (@SubData.SubName, objectname);
                  StrPCopy (@SubData.GuildName, SelfData.Name);
                  TFieldPhone (Manager.Phone).SendMessage (MANAGERPHONE, FM_REMOVEGUILDMEMBER, BasicData, SubData);

                  // 2000.09.18 NPC의 이름과 User의 이름이 같을때 검색오류버그 수정 by Lee.S.G
                  // 탈퇴는 RACE_HUMAN에서만 유효하다
                  {
                  Bo := GetViewObjectByName (objectname, RACE_HUMAN);
                  if Bo = nil then exit;
                  if not (Bo is TUser) then exit;
                  TUser (Bo).GuildName := '';
                  // 2000.09.16 GuildGrade도 함께 초기화 시킨다 by Lee.S.G
                  TUser (Bo).GuildGrade := '';
                  StrPCopy (@TUser (Bo).BasicData.Guild, '');
                  TUser(Bo).BocChangeProperty;
                  }
               end else begin
                  BocSay (format ('%s님은 가입되어있지 않습니다.',[objectname]));
               end;
            end;
            if ReverseFormat (str, '%s: %s님의 직함은 %s이다', sayer, objectname, gradename, 3) then begin
               if (not isFullHangul (gradename)) or (not isGrammarID(gradename)) or (Length(gradename) > 12) or (Length(gradename) < 2) then begin
                  BocSay ( '직책이름이 잘못되었습니다.');
                  exit;
               end;

               if GuildUserList.IsGuildUser (objectname) then begin
                  BocSay (format ('주어진 직책은 %s 입니다.',[gradename]));
                  GuildUserList.SetGradeName (objectname, gradename);
               end else begin
                  BocSay (format ('%s님은 가입되어있지 않습니다.',[objectname]));
               end;
            end;

            if ReverseFormat (str, '%s: %s님을 부문주로 임명한다', sayer, objectname, str3, 2) then begin
               if sayer <> SelfData.Sysop then exit;
               // 2000.09.18 NPC의 이름과 User의 이름이 같을때 검색오류버그 수정 by Lee.S.G
               // 부문주는 RACE_HUMAN에서만 유효하다
               Bo := GetViewObjectByName (objectname, RACE_HUMAN);
               if Bo = nil then begin BocSay (format ('%s님은 없습니다.',[objectname])); exit; end;
               if not (Bo is TUser) then begin BocSay (format ('%s님은 사용자가 아닙니다.',[objectname])); exit; end;
               if TUser (Bo).GuildName <> SelfData.Name then begin BocSay (format ('%s님은 문원이 아닙니다.',[objectname])); exit; end;

               if (objectname = SelfData.SubSysop[0]) or (objectname = SelfData.SubSysop[1]) or (objectname = SelfData.SubSysop[2]) then begin
                  BocSay (format ('%s님은 이미 부문주 입니다.',[objectname]));
                  exit;
               end;

               if (SelfData.SubSysop[0] <> '') and (SelfData.SubSysop[1] <> '') and (SelfData.SubSysop[2] <> '') then begin
                  BocSay ('더 이상 임명할 수 없습니다.');
                  BocSay ( format ('부문주는 %s, %s, %s님입니다.', [SelfData.SubSysop[0],SelfData.SubSysop[1],SelfData.SubSysop[2]]));
                  exit;
               end;

               // 2000.09.20 다른 문파의 문주나 부문주는 부문주로 임명될수 없다 by Lee.S.G
               SubData.ServerId := Manager.ServerId;
               StrPCopy (@SubData.SubName, objectname);
               StrPCopy (@SubData.GuildName, '');
               if TFieldPhone(Manager.Phone).SendMessage (MANAGERPHONE, FM_ALLOWGUILDSYSOPNAME, BasicData, SubData) = PROC_FALSE then begin
                  BocSay ( '이미 다른 문파의 부문주나 문주로 ');
                  BocSay ( '등록되어 있습니다.');
                  Exit;
               end;
               
               if SelfData.SubSysop[0] = '' then begin SelfData.SubSysop[0] := objectname; BocSay(format ('%s님을 임명했습니다.',[objectname])); exit; end;
               if SelfData.SubSysop[1] = '' then begin SelfData.SubSysop[1] := objectname; BocSay(format ('%s님을 임명했습니다.',[objectname])); exit; end;
               if SelfData.SubSysop[2] = '' then begin SelfData.SubSysop[2] := objectname; BocSay(format ('%s님을 임명했습니다.',[objectname])); exit; end;
            end;
            if ReverseFormat (str, '%s: %s님을 부문주에서 제명한다', sayer, objectname, str3, 2) then begin
               if sayer <> SelfData.Sysop then exit;
               if SelfData.SubSysop[0] = objectname then begin SelfData.SubSysop[0] := ''; BocSay(format ('%s님을 제명했습니다.',[objectname])); exit; end;
               if SelfData.SubSysop[1] = objectname then begin SelfData.SubSysop[1] := ''; BocSay(format ('%s님을 제명했습니다.',[objectname])); exit; end;
               if SelfData.SubSysop[2] = objectname then begin SelfData.SubSysop[2] := ''; BocSay(format ('%s님을 제명했습니다.',[objectname])); exit; end;
               BocSay (format ('%s님은 부문주가 아닙니다.',[objectname]));
            end;

            if ReverseFormat (str, '%s: 문파정보', str1, str2, str3, 1) then begin
               BocSay ('문파포졸정보');
               for i := 0 to GuildNpcList.Count -1 do begin
                  GuildNpc := GuildNpcList.Items [i];
                  str := StrPas(@GuildNpc.BasicData.Name);
                  str := str + '  x:' + IntToStr (GuildNpc.BasicData.X);
                  str := str + '  y:' + IntToStr (GuildNpc.BasicData.Y);
                  BocSay (str);
               end;

               BocSay (format ('문파초석 : %d/%d',[SelfData.Durability, SelfData.MaxDurability]));
               exit;
            end;
         end;
   end;
end;

procedure TGuildObject.Initial;
var
   i : Integer;
   GuildNpc : TGuildNpc;
begin
   inherited Initial (SelfData.Name);

   LoadFromFile (SelfData.Name);

   FGuildName := SelfData.Name;
   DuraTick := mmAnsTick;

   if (SelfData.MaxDurability = 0) or (SelfData.MaxDurability = 110000) then begin
      SelfData.MaxDurability := MAX_GUILD_DURA;
   end;

   BasicData.id := GetNewStaticItemId;
   BasicData.x := SelfData.X;
   BasicData.y := SelfData.Y;
   BasicData.ClassKind := CLASS_GUILDSTONE;
   BasicData.Feature.rrace := RACE_STATICITEM;
   BasicData.Feature.rImageNumber := 67;
   BasicData.Feature.rImageColorIndex := 0;

   boAddGuildMagic := false;

   DieGuildNpcList.Clear;
   for i := 0 to MAX_GUILDNPC_COUNT - 1 do begin
      if SelfData.GuildNpc[i].rName = '' then continue;

      GuildNpc := TGuildNpc.Create;
      if Manager <> nil then begin
         GuildNpc.SetManagerClass (Manager);
      end;
      GuildNpc.Initial (Self, SelfData.GuildNpc[i].rName, SelfData.GuildNpc[i].rX, SelfData.GuildNpc[i].rY);

      if (SelfData.GuildMagic <> '') and (boAddGuildMagic = false) then begin
         GuildNpc.boMagicNpc := true;
         StrPCopy (@GuildNpc.BasicData.Guild, SelfData.GuildMagic);
         MagicClass.GetMagicData (SelfData.GuildMagic, GuildNpc.GuildMagicData, SelfData.MagicExp);
         boAddGuildMagic := true;
      end;
      DieGuildNpcList.Add (GuildNpc);
   end;
end;

procedure TGuildObject.StartProcess;
var
   SubData : TSubData;
begin
   inherited StartProcess;

   TFieldPhone(Manager.Phone).RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   TFieldPhone(Manager.Phone).SendMessage (0, FM_CREATE, BasicData, SubData);
end;

procedure TGuildObject.EndProcess;
var
   i : integer;
   SubData : TSubData;
   GuildNpc : TGuildNpc;
begin
   if FboRegisted = FALSE then exit;

   for i := DieGuildNpcList.Count - 1 downto 0 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      GuildNpc.Free;
      DieGuildNpcList.Delete (i);
   end;

   for i := GuildNpcList.Count - 1 downto 0 do begin
      GuildNpc := GuildNpcList.Items [i];
      GuildNpc.EndProcess;
      GuildNpc.Free;
      GuildNpcList.Delete (i);
   end;

   TFieldPhone(Manager.Phone).SendMessage (0, FM_DESTROY, BasicData, SubData);
   TFieldPhone(Manager.Phone).UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

procedure TGuildObject.ShowGuildInfo (aUser : TUser);
var
   i : Integer;
   gi : TSShowGuildInfoWindow;
begin
   FillChar (gi, SizeOf (TSShowGuildInfoWindow), 0);

   gi.rMsg := SM_SHOWSPECIALWINDOW;
   gi.rWindow := WINDOW_GUILDINFO;
   gi.rboEdit := 1;
   gi.rGuildName := GuildName;
   gi.rGuildX := SelfData.X;
   gi.rGuildY := SelfData.Y;
   gi.rCreateDate := SelfData.MakeDate;
   gi.rSysop := SelfData.Sysop;
   for i := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
      gi.rSubSysop[i] := SelfData.SubSysop[i];
   end;
   for i := 0 to MAX_GUILDNPC_COUNT - 1 do begin
      gi.rGuildNpc [i] := SelfData.GuildNpc[i].rName;
      gi.rGuildNpcX [i] := SelfData.GuildNpc[i].rX;
      gi.rGuildNpcY [i] := SelfData.GuildNpc[i].rY;
   end;
   gi.rGuildTitle := SelfData.Title;
   gi.rGuildMagic := SelfData.GuildMagic;
   gi.rGuildAward := IntToStr (SelfData.AwardPoint);
   gi.rGuildDura := SelfData.Durability;

   aUser.SendClass.SendData (@gi, SizeOf (TSShowGuildInfoWindow));
end;

function TGuildObject.MakeGuild (aMakeGuildData : PTCMakeGuildData; aUser : TUser) : Boolean;
var
   i, Cnt : Integer;
   str, RetStr, GuildStr : String;
   pUser : TUser;
begin
   Result := false;

   GuildStr := Trim (aMakeGuildData^.rGuildName);
   if (not isFullHangul (GuildStr)) or (not isGrammarID(GuildStr)) or (Length(GuildStr) > 12) or (Length(GuildStr) < 2) then begin
      aUser.SendClass.SendChatMessage ('문파이름이 올바르지 않습니다', SAY_COLOR_SYSTEM);
      exit;
   end;
   if GuildList.AllowGuildCondition (GuildStr, aUser.Name, RetStr) = false then begin
      aUser.SendClass.SendChatMessage (RetStr, SAY_COLOR_SYSTEM);
      exit;
   end;

   for i := 0 to MAX_AGREESUBSYSOP_COUNT - 1 do begin
      str := Trim (aMakeGuildData^.rSubSysop [i]);
      if str = '' then begin
         aUser.SendClass.SendChatMessage ('부문주 3명의 이름을 모두 채워주세요', SAY_COLOR_SYSTEM);
         exit;
      end;
      pUser := TUser (GetViewObjectByName (str, RACE_HUMAN));
      if pUser = nil then begin
         aUser.SendClass.SendChatMessage (str + '님은 접속중이 아닙니다', SAY_COLOR_SYSTEM);
         aUser.SendClass.SendChatMessage ('문파설립시에는 동의자 모두가 접속하고 있어야만 합니다', SAY_COLOR_SYSTEM);
         exit;
      end;
      if pUser.BasicData.Guild[0] <> 0 then begin
         aUser.SendClass.SendChatMessage (str + '님은 이미 다른 문파에 가입되어 있습니다', SAY_COLOR_SYSTEM);
         exit;
      end;
      if GuildList.AllowGuildCondition (GuildStr, pUser.Name, RetStr) = false then begin
         aUser.SendClass.SendChatMessage (RetStr, SAY_COLOR_SYSTEM);
         exit;
      end;
   end;
   for i := 0 to MAX_AGREECHAR_COUNT - 1 do begin
      str := Trim (aMakeGuildData^.rAgreeChar [i]);
      if str = '' then begin
         aUser.SendClass.SendChatMessage (format ('문원 %d명의 이름을 모두 채워주세요', [MAX_AGREECHAR_COUNT]), SAY_COLOR_SYSTEM);
         exit;
      end;
      pUser := TUser (GetViewObjectByName (str, RACE_HUMAN));
      if pUser = nil then begin
         aUser.SendClass.SendChatMessage (str + '님은 접속중이 아닙니다', SAY_COLOR_SYSTEM);
         aUser.SendClass.SendChatMessage ('문파설립시에는 동의자 모두가 접속하고 있어야만 합니다', SAY_COLOR_SYSTEM);
         exit;
      end;
      if pUser.BasicData.Guild[0] <> 0 then begin
         aUser.SendClass.SendChatMessage (str + '님은 이미 다른 문파에 가입되어 있습니다', SAY_COLOR_SYSTEM);
         exit;
      end;
      if GuildList.AllowGuildCondition (GuildStr, pUser.Name, RetStr) = false then begin
         aUser.SendClass.SendChatMessage (RetStr, SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   if MakeGuildData = nil then begin
      New (MakeGuildData);
   end;
   FillChar (MakeGuildData^, SizeOf (TMakeGuildData), 0);

   MakeGuildData^.GuildName := GuildStr;
   MakeGuildData^.Sysop := aUser.Name;

   RetStr := format ('%s님이 %s 문파를 창설하려고 합니다. 창설 동의자로 지정되었습니다. 문파창설에 동의하시겠습니까?', [aUser.Name, GuildStr]);
   for i := 0 to MAX_AGREESUBSYSOP_COUNT - 1 do begin
      str := aMakeGuildData^.rSubSysop [i];
      pUser := TUser (GetViewObjectByName (str, RACE_HUMAN));
      if pUser <> nil then begin
         if pUser.isSpecialWindow = true then begin
            aUser.SendClass.SendChatMessage (str + '님은 교환창/보관창을 띄워놓은 상태입니다', SAY_COLOR_SYSTEM);
            pUser.SendClass.SendChatMessage (str + '현재의 창(교환창/보관창)을 닫아 주시기 바랍니다', SAY_COLOR_SYSTEM);
            exit;
         end;

         pUser.SetSpecialWindowSt (WINDOW_AGREE, AGREE_GUILDMAKE, BasicData.ID);
         pUser.SendClass.SendShowSpecialWindow (WINDOW_AGREE, '문파창설 동의', RetStr);
      end;
      MakeGuildData^.AgreeChar [i] := str;
   end;
   for i := 0 to MAX_AGREECHAR_COUNT - 1 do begin
      str := aMakeGuildData^.rAgreeChar [i];
      pUser := TUser (GetViewObjectByName (str, RACE_HUMAN));
      if pUser <> nil then begin
         if pUser.isSpecialWindow = true then begin
            aUser.SendClass.SendChatMessage (str + '님은 교환창/보관창을 띄워놓은 상태입니다', SAY_COLOR_SYSTEM);
            pUser.SendClass.SendChatMessage (str + '현재의 창(교환창/보관창)을 닫아 주시기 바랍니다', SAY_COLOR_SYSTEM);
            exit;
         end;

         pUser.SetSpecialWindowSt (WINDOW_AGREE, AGREE_GUILDMAKE, BasicData.ID);
         pUser.SendClass.SendShowSpecialWindow (WINDOW_AGREE, '문파창설 동의', RetStr);
      end;
      MakeGuildData^.AgreeChar [MAX_AGREESUBSYSOP_COUNT + i] := str;
   end;

   aUser.SendClass.SendChatMessage ('모든 동의를 얻고 나면 문파가 자동으로 생성됩니다', SAY_COLOR_SYSTEM);
   aUser.SendClass.SendChatMessage ('잠시 기다려 주시기 바랍니다', SAY_COLOR_SYSTEM);

   Result := true;
end;

procedure TGuildObject.AgreeMakeGuild (aName : String; aFlag : Boolean);
var
   i : Integer;
   RetStr, Str, GuildName : String;
   aUser, pUser : TUser;
begin
   if MakeGuildData = nil then exit;

   if aFlag = true then begin
      for i := 0 to MAX_AGREESUBSYSOP_COUNT + MAX_AGREECHAR_COUNT - 1 do begin
         if MakeGuildData^.AgreeChar [i] = aName then begin
            MakeGuildData^.boAgree [i] := true;
            break;
         end;
      end;

      for i := 0 to MAX_AGREESUBSYSOP_COUNT + MAX_AGREECHAR_COUNT - 1 do begin
         if MakeGuildData^.AgreeChar [i] = '' then continue;
         if MakeGuildData^.boAgree [i] = false then exit;
      end;

      GuildName := MakeGuildData^.GuildName;
      aUser := TUser (GetViewObjectByName (MakeGuildData^.Sysop, RACE_HUMAN));
      if aUser = nil then begin
         Dispose (MakeGuildData);
         MakeGuildData := nil;
         exit;
      end;

      // 문파명 및 문원들을 다시 한번 검사한다
      if GuildList.AllowGuildCondition (GuildName, MakeGuildData^.Sysop, RetStr) = false then begin
         aUser.SendClass.SendChatMessage (RetStr, SAY_COLOR_SYSTEM);
         Dispose (MakeGuildData);
         MakeGuildData := nil;
         exit;
      end;

      for i := 0 to MAX_AGREESUBSYSOP_COUNT - 1 do begin
         str := Trim (MakeGuildData^.AgreeChar [i]);
         if str = '' then begin
            aUser.SendClass.SendChatMessage ('부문주 3명의 이름을 모두 채워주세요', SAY_COLOR_SYSTEM);
            Dispose (MakeGuildData);
            MakeGuildData := nil;
            exit;
         end;
         pUser := TUser (GetViewObjectByName (str, RACE_HUMAN));
         if pUser = nil then begin
            aUser.SendClass.SendChatMessage (str + '님은 접속중이 아닙니다', SAY_COLOR_SYSTEM);
            aUser.SendClass.SendChatMessage ('문파설립시에는 동의자 모두가 접속하고 있어야만 합니다', SAY_COLOR_SYSTEM);
            Dispose (MakeGuildData);
            MakeGuildData := nil;
            exit;
         end;
         if pUser.BasicData.Guild[0] <> 0 then begin
            aUser.SendClass.SendChatMessage (str + '님은 이미 다른 문파에 가입되어 있습니다', SAY_COLOR_SYSTEM);
            Dispose (MakeGuildData);
            MakeGuildData := nil;
            exit;
         end;
         if GuildList.AllowGuildCondition (GuildName, pUser.Name, RetStr) = false then begin
            aUser.SendClass.SendChatMessage (RetStr, SAY_COLOR_SYSTEM);
            Dispose (MakeGuildData);
            MakeGuildData := nil;
            exit;
         end;
      end;
      for i := 0 to MAX_AGREECHAR_COUNT - 1 do begin
         str := Trim (MakeGuildData^.AgreeChar [MAX_AGREESUBSYSOP_COUNT + i]);
         if str = '' then begin
            aUser.SendClass.SendChatMessage (format ('문원 %d명의 이름을 모두 채워주세요', [MAX_AGREECHAR_COUNT]), SAY_COLOR_SYSTEM);
            Dispose (MakeGuildData);
            MakeGuildData := nil;
            exit;
         end;
         pUser := TUser (GetViewObjectByName (str, RACE_HUMAN));
         if pUser = nil then begin
            aUser.SendClass.SendChatMessage (str + '님은 접속중이 아닙니다', SAY_COLOR_SYSTEM);
            aUser.SendClass.SendChatMessage ('문파설립시에는 동의자 모두가 접속하고 있어야만 합니다', SAY_COLOR_SYSTEM);
            Dispose (MakeGuildData);
            MakeGuildData := nil;
            exit;
         end;
         if pUser.BasicData.Guild[0] <> 0 then begin
            aUser.SendClass.SendChatMessage (str + '님은 이미 다른 문파에 가입되어 있습니다', SAY_COLOR_SYSTEM);
            Dispose (MakeGuildData);
            MakeGuildData := nil;
            exit;
         end;
         if GuildList.AllowGuildCondition (GuildName, pUser.Name, RetStr) = false then begin
            aUser.SendClass.SendChatMessage (RetStr, SAY_COLOR_SYSTEM);
            Dispose (MakeGuildData);
            MakeGuildData := nil;
            exit;
         end;
      end;

      // 문파를 실명화한다
      BocSay (format ('문파이름은 %s입니다.',[GuildName]));
      StrPCopy (@BasicData.Name, GuildName);
      SelfData.Name := GuildName;
      FGuildName := GuildName;
      BocChangeProperty;
      BocChangeFeature;
      SelfData.MakeDate := DateToStr (Date);

      // 동의자를 문원들을 모두 가입시킨다
      for i := 0 to MAX_AGREESUBSYSOP_COUNT + MAX_AGREECHAR_COUNT - 1 do begin
         Str := MakeGuildData^.AgreeChar [i];
         if Str = '' then continue;
         pUser := TUser (GetViewObjectByName (Str, RACE_HUMAN));
         if pUser <> nil then begin
            pUser.GuildName := GuildName;
            pUser.GuildGrade := GetUserGrade (Str);
            StrPCopy (@pUser.BasicData.Guild, GuildName);
            GuildUserList.AddUser (Str);
            pUser.BocChangeProperty;
         end;
      end;
   end else begin
      BocSay (format ('%s님이 동의하지 않았기 때문에 문파창설은 취소됩니다.',[aName]));
      Dispose (MakeGuildData);
      MakeGuildData := nil;
   end;
end;

function TGuildObject.MoveStone (aServerID, ax, ay: integer) : Boolean;
var
   i, nX, nY : integer;
   nIndex : Byte;
   SubData : TSubData;
   tmpManager : TManager;
   GuildNpc : TGuildNpc;
begin
   Result := false;

   if Manager = nil then exit;

   tmpManager := ManagerList.GetManagerByServerID (aServerID);
   if tmpManager = nil then exit;
   if tmpManager.boMakeGuild = false then exit;
   nIndex := TMaper (tmpManager.Maper).GetAreaIndex (aX, aY);
   if nIndex = 0 then exit;
   if AreaClass.CanMakeGuild (nIndex) = false then exit;

   nX := aX; nY := aY;
   // TMaper (tmpManager.Maper).GetMoveableXY (nX, nY, 10);
   // if not TMaper (tmpManager.Maper).isMoveable (nX, nY) then exit;

   TFieldPhone(Manager.Phone).SendMessage (NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
   TFieldPhone(Manager.Phone).UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   SelfData.MapID := aServerID;
   SelfData.X := nX; SelfData.Y := nY;
   BasicData.x := nx; BasicData.y := ny;

   SetManagerClass (tmpManager);

   TFieldPhone(Manager.Phone).RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   TFieldPhone(Manager.Phone).SendMessage (NOTARGETPHONE, FM_CREATE, BasicData, SubData);

   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      GuildNpc.MoveGuildNpc (aServerID, nX, nY);
   end;

   for i := 0 to DieGuildNpcList.Count - 1 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      GuildNpc.MoveDieGuildNpc (aServerID, nX, nY);
   end;

   Result := true;
end;

function TGuildObject.CreateStone (aSysopName : String; aServerID, ax, ay: integer) : Boolean;
var
   i, nX, nY : integer;
   nIndex : Byte;
   SubData : TSubData;
   tmpManager : TManager;
   GuildNpc : TGuildNpc;
begin
   Result := false;

   if (aSysopName <> '') and (SelfData.Sysop <> aSysopName) then exit; 

   tmpManager := ManagerList.GetManagerByServerID (aServerID);
   if tmpManager = nil then exit;
   if tmpManager.boMakeGuild = false then exit;
   nIndex := TMaper (tmpManager.Maper).GetAreaIndex (aX, aY);
   if nIndex = 0 then exit;
   if AreaClass.CanMakeGuild (nIndex) = false then exit;

   nX := aX; nY := aY;
   if TMaper (tmpManager.Maper).isGuildStoneArea (nX, nY) = true then exit;
   // TMaper (tmpManager.Maper).GetMoveableXY (nX, nY, 10);
   // if not TMaper (tmpManager.Maper).isMoveable (nX, nY) then exit;

   SelfData.MapID := aServerID;
   SelfData.X := nX; SelfData.Y := nY;
   BasicData.x := nx; BasicData.y := ny;

   SetManagerClass (tmpManager);

   Initial;
   StartProcess;

   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      GuildNpc.MoveGuildNpc (aServerID, nX, nY);
   end;

   for i := 0 to DieGuildNpcList.Count - 1 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      GuildNpc.MoveDieGuildNpc (aServerID, nX, nY);
   end;

   Result := true;
end;

function   TGuildObject.GetGuildNpcByName (aname: string): integer;
var
   i : integer;
   GuildNpc : TGuildNpc;
begin
   Result := -1;
   for i := 0 to GuildNpcList.Count -1 do begin
      GuildNpc := GuildNpcList.Items [i];
      if GuildNpc.GuildNpcName = aName then begin
         Result := i;
         exit;
      end;
   end;
end;

procedure TGuildObject.Update (CurTick: integer);
var
   i, j, nX, nY : integer;
   nname: string;
   GuildNpc : TGuildNpc;
   bo : TBasicObject;
begin
   // 2000.09.18 문파포졸이 삭제되는 현상을 막기위해 먼저 삭제하고
   // 뒤이어 바로 생성한다 by Lee.S.G
   for i := GuildNpcList.Count - 1 downto 0 do begin
      GuildNpc := GuildNpcList.Items [i];
      if GuildNpc.boAllowDelete then begin
         GuildNpc.EndProcess;
         GuildNpcList.Delete (i);
         DieGuildNpcList.Add (GuildNpc);
      end;
   end;

   {
   for i := 0 to 5 - 1 do begin
      nName := GuildNpcDataClass.GuildNpcDataArr[i].rname;
      if nname = '' then continue;

      ret := GetGuildNpcByName (nname);
      if ret = -1 then begin
         xx := GuildNpcDataClass.GuildNpcDataArr[i].rx;
         yy := GuildNpcDataClass.GuildNpcDataArr[i].ry;

         tempx := 0; tempy := 0;
         if not TMaper(Manager.Maper).IsMoveable (xx, yy) then begin
            for j := 0 to 32 do begin
               GetNearPosition (tempx, tempy);
               if TMaper(Manager.Maper).isMoveable (xx + tempx, yy + tempy) then begin
                  break;
               end;
            end;
            if not TMaper(Manager.Maper).isMoveable (xx + tempx, yy + tempy) then begin
               tempx := 0; tempy := 0;
            end;
         end;

         GuildNpc := TGuildNpc.Create;
         GuildNpc.SetManagerClass (Manager);
         GuildNpc.StartX := xx;
         GuildNpc.StartY := yy;
         GuildNpc.Initial (TBasicObject(Self), nname, xx+tempx, yy+tempy);
         GuildNpc.GuildNpcDataClass := GuildNpcDataClass;

         if (GuildMagicName <> '') and (i = 0) then begin
            GuildNpc.boMagicNpc := TRUE;
            StrPcopy (@GuildNpc.BasicData.Guild, GuildMagicName);
            MagicClass.GetMagicData (GuildMagicName, GuildNpc.GuildMagicData, GuildMagicExp);
         end;

         GuildNpc.StartProcess;
         // 2000.09.16 문파포졸중 문파무공이 지정된 포졸의 위치가 변하는것을
         // 막기 위해 TAnsList에 Insert Method를 추가하고 문파포졸의 생성시
         // 첫번째 포졸은 리스트의 선두에 삽입한다 by Lee.S.G
         // AnsList.Add (GuildNpc);
         if i = 0 then GuildNpcList.Insert (0, GuildNpc)
         else GuildNpcList.Add (GuildNpc);
      end;
   end;
   }

   if (Manager <> nil) and (DieGuildNpcList.Count > 0) then begin
      for i := DieGuildNpcList.Count - 1 downto 0 do begin
         GuildNpc := DieGuildNpcList.Items [i];
         nX := GuildNpc.StartX;
         nY := GuildNpc.StartY;

         TMaper (Manager.Maper).GetMoveableXY (nX, nY, 10);
         if TMaper (Manager.Maper).isMoveable (nX, nY) then begin
            GuildNpc.BasicData.X := nX;
            GuildNpc.BasicData.Y := nY;
            GuildNpc.StartProcess;
            GuildNpcList.Add (GuildNpc);
            DieGuildNpcList.Delete (i);
         end;
      end;
   end;

   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      GuildNpc.Update (CurTick);
   end;

   if CurTick > DuraTick + DEC_GUILD_DURA_TICK then begin
      DuraTick := CurTick;
      dec (SelfData.Durability);
   end;
end;

////////////////////////////////////////////////////
//
//             ===  GuildList  ===
//
////////////////////////////////////////////////////

constructor TGuildList.Create;
begin
   CurProcessPos := 0;
   
   DataList := TList.Create;

   LoadFromFile ('.\Guild\CreateGuild.SDB');
end;

destructor TGuildList.Destroy;
begin
   SaveToFile ('.\Guild\CreateGuild.SDB');
   Clear;
   DataList.Free;
   
   inherited Destroy;
end;

procedure TGuildList.Clear;
var
   i : Integer;
   GuildObject : TGuildObject;
begin
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      GuildObject.EndProcess;
      GuildObject.Free;
   end;
   DataList.Clear;
end;

function  TGuildList.GetCount: integer;
begin
   Result := DataList.Count;
end;

function TGuildList.GetGuildBySysop (aSysopName : String) : TGuildObject;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := nil;
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.SelfData.Sysop = aSysopName then begin
         Result := GuildObject;
         exit;
      end;
   end;
end;

function TGuildList.GetGuildByName (aGuildName : String) : TGuildObject;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := nil;
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         Result := GuildObject;
         exit;
      end;
   end;
end;

function TGuildList.GetUserGrade (aGuildName, uName: String): string;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := '';
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         Result := GuildObject.GetUserGrade (uname);
         exit;
      end;
   end;
end;

function TGuildList.GetGuildServerID (aGuildName : String): Integer;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := -1;
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         Result := GuildObject.SelfData.MapID;
         exit;
      end;
   end;
end;

procedure TGuildList.GetGuildInfo (aGuildName: string; aUser: TUser);
var
   i : integer;
   GuildObject : TGuildObject;
begin
   for i := 0 to DataList.Count -1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         GuildObject.GetGuildInfo (aUser);
         exit;
      end;
   end;
end;

function TGuildList.CheckGuildUser (aGuildName, aName : String) : Boolean;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := FALSE;
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName <> aGuildName then continue;
      if GuildObject.IsGuildUser(aName) = true then begin
         Result := TRUE;
         exit;
      end;
   end;
end;

procedure   TGuildList.AllowGuildName (gid: integer; aboAllow: Boolean; aGuildName, aSysopName: string);
var
   i : integer;
   pd : PTCreateGuildData;
   GuildObject: TGuildObject;
begin
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.BasicData.id = gid then begin
         if aboAllow = true then begin
            pd := GuildObject.GetSelfData;
            
            GuildObject.BocSay (format ('문파이름은 %s입니다.',[aGuildName]));
            pd^.Sysop := aSysopName;
            StrPCopy (@GuildObject.BasicData.Name, aGuildName);
            pd^.Name := aGuildName;
            GuildObject.FGuildName := aGuildName;
            GuildObject.BocChangeFeature;
            pd^.MakeDate := DateToStr (Date);
         end else begin
            GuildObject.BocSay ('문파를 만들 수 없습니다.');
         end;
         exit;
      end;
   end;
end;

function TGuildList.AllowGuildCondition (gname, uname : String; var aRetStr : String) : Boolean;
var
   i, j : integer;
   pd : PTCreateGuildData;
   GuildObject: TGuildObject;
begin
   Result := TRUE;
   
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      pd := GuildObject.GetSelfData;
      if pd^.Name = '' then continue;
      if pd^.Name = gname then begin
         aRetStr := '이미 같은 문파이름이 존재합니다';
         Result := FALSE;
         exit;
      end;
      if pd^.Sysop = uname then begin
         aRetStr := uName + '님은 ' + pd^.Name + '문의 문주입니다';
         Result := FALSE;
         exit;
      end;
      for j := 0 to MAX_SUBSYSOP_COUNT do begin
         if pd^.SubSysop[j] = uname then begin
            aRetStr := uName + '님은 ' + pd^.Name + '문의 부문주입니다';
            Result := FALSE;
            exit;
         end;
      end;
   end;
end;

function TGuildList.MoveStone (aGuildName : String; aServerID, ax, ay: integer) : Boolean;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := false;
   for i := 0 to DataList.Count -1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         Result := GuildObject.MoveStone (aServerID, ax, ay);
         exit;
      end;
   end;
end;

function TGuildList.CreateStone (aGuildName, aSysopName : String; aServerID, ax, ay: integer) : Boolean;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := false;
   for i := 0 to DataList.Count -1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.SelfData.Name = aGuildName then begin
         if GuildObject.boRegisted = false then begin
            Result := GuildObject.CreateStone (aSysopName, aServerID, ax, ay);
         end;
         exit;
      end;
   end;
end;

procedure TGuildList.DeleteStone (aGuildName : String);
var
   i : Integer;
   GuildObject : TGuildObject;
begin
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         GuildObject.SelfData.Durability := 0;
         CompactGuild;
         exit;
      end;
   end;
end;

procedure TGuildList.CompactGuild;
var
   i : Integer;
   GuildObject : TGuildObject;
   Str, iName : String;
   buffer : array [0..4096 - 1] of char;
   DB : TUserStringDB;
   Stream : TFileStream;
begin
   if not FileExists ('.\Guild\DeletedGuild.SDB') then begin
      Str := 'Index,DeletedDate,Name,Durability,X,Y,Sysop,SubSysop0,SubSysop1,SubSysop2,GuildMagic,MakeDate,MagicExp' + #13#10;
      StrPCopy (@buffer, Str);
      Stream := TFileStream.Create ('.\Guild\DeletedGuild.SDB', fmCreate);
      Stream.WriteBuffer (buffer, StrLen (@buffer));
      Stream.Free;
   end;

   DB := TUserStringDB.Create;
   DB.LoadFromFile ('.\Guild\DeletedGuild.SDB');

   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = '' then continue;
      if GuildObject.SelfData.Durability <= 0 then begin
         iName := IntToStr (DB.Count);
         DB.AddName (iName);
         DB.SetFieldValueString (iName, 'DeletedDate', DateToStr (Date));
         DB.SetFieldValueString (iName, 'Name', GuildObject.GuildName);
         DB.SetFieldValueInteger (iName, 'Durability', GuildObject.SelfData.Durability);
         DB.SetFieldValueInteger (iName, 'X', GuildObject.SelfData.X);
         DB.SetFieldValueInteger (iName, 'Y', GuildObject.SelfData.Y);
         DB.SetFieldValueString (iName, 'Sysop', GuildObject.SelfData.Sysop);
         DB.SetFieldValueString (iName, 'SubSysop0', GuildObject.SelfData.SubSysop [0]);
         DB.SetFieldValueString (iName, 'SubSysop1', GuildObject.SelfData.SubSysop [1]);
         DB.SetFieldValueString (iName, 'SubSysop2', GuildObject.SelfData.SubSysop [2]);
         DB.SetFieldValueString (iName, 'GuildMagic', GuildObject.SelfData.GuildMagic);
         DB.SetFieldValueString (iName, 'MakeDate', GuildObject.SelfData.MakeDate);
         DB.SetFieldValueInteger (iName, 'MagicExp', GuildObject.SelfData.MagicExp);

         GuildObject.boAllowDelete := true;
         try DeleteFile ('.\Guild\' + GuildObject.GuildName + 'GUser.SDB'); except end;
      end;
   end;

   DB.SaveToFile ('.\Guild\DeletedGuild.SDB');
   DB.Free;

   MagicClass.CompactGuildMagic;
end;


function TGuildList.AddGuildObject (aGuildName, aOwnerName : String; aServerID, aX, aY: integer): TGuildObject;
var
   Manager : TManager;
   GuildObject : TGuildObject;
   pd : PTCreateGuildData;
begin
   GuildObject := TGuildObject.Create;

   pd := GuildObject.GetSelfData;
   pd^.Name := aGuildName;
   pd^.MapID := aServerID;
   pd^.X := aX;
   pd^.Y := aY;
   pd^.Durability := MAX_GUILD_DURA;
   pd^.MaxDurability := MAX_GUILD_DURA;
   pd^.Sysop := aOwnerName;
   
   Manager := ManagerList.GetManagerByServerID (aServerID);
   GuildObject.SetManagerClass (Manager);
   GuildObject.Initial;
   GuildObject.StartProcess;
   DataList.Add (GuildObject);
   
   Result := GuildObject;
end;

procedure TGuildList.LoadFromFile (aFileName : String);
var
   i, j : Integer;
   str, rdstr : string;
   iName : string;
   pd, pdd : PTCreateGuildData;
   DB : TUserStringDb;
   Manager : TManager;
   GuildObject : TGuildObject;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDb.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to Db.Count - 1 do begin
      iName := Db.GetIndexName (i);
      if iName = '' then continue;

      GuildObject := TGuildObject.Create;
      pd := GuildObject.GetSelfData;

      FillChar (pd^, SizeOf(TCreateGuildData), 0);

      pd^.Name := iName;
      pd^.Title := Db.GetFieldValueString (iName, 'Title');
      pd^.MapID := Db.GetFieldValueInteger (iName, 'MapID');
      pd^.x := Db.GetFieldValueInteger (iname, 'X');
      pd^.y := Db.GetFieldValueInteger (iname, 'Y');
      pd^.Durability := Db.GetFieldValueInteger (iName, 'Durability');
      pd^.MaxDurability := Db.GetFieldValueInteger (iName, 'MaxDurability');
      pd^.GuildMagic := Db.GetFieldValueString (iName, 'GuildMagic');
      pd^.MagicExp := Db.GetFieldValueInteger (iName, 'MagicExp');
      pd^.MakeDate := Db.GetFieldValueString (iName, 'MakeDate');
      pd^.Sysop := Db.GetFieldValueString (iname, 'Sysop');
      for j := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
         pd^.SubSysop[j] := Db.GetFieldValueString (iName, 'SubSysop' + IntToStr (j));
      end;
      for j := 0 to MAX_GUILDNPC_COUNT - 1 do begin
         str := Db.GetFieldValueString (iName, 'Npc' + IntToStr(j));
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildNpc[j].rName := rdstr;
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildNpc[j].rx := _StrToInt (rdstr);
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildNpc[j].ry := _StrToInt (rdstr);
      end;
      for j := 0 to MAX_GUILDWEAR_COUNT - 1 do begin
         str := Db.GetFieldValueString (iName, 'Wear0');
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildWear[j].rItemName := rdstr;
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildWear[j].rColor := _StrToInt (rdstr);
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildWear[j].rItemCount := _StrToInt (rdstr);
      end;

      pd^.BasicPoint := Db.GetFieldValueInteger (iName, 'BasicPoint');
      pd^.AwardPoint := Db.GetFieldValueInteger (iName, 'AwardPoint');
      pd^.BattleRejectCount := Db.GetFieldValueInteger (iName, 'BattleRejectCount');
      pd^.ChallengeGuild := Db.GetFieldValueString (iName, 'ChallengeGuild');
      pd^.ChallengeGuildUser := Db.GetFieldValueString (iName, 'ChallengeGuildUser');
      pd^.ChallengeDate := Db.GetFieldValueString (iName, 'ChallengeDate');

      Manager := ManagerList.GetManagerByServerID (pd^.MapID);
      if Manager <> nil then begin
         GuildObject.SetManagerClass (Manager);
         GuildObject.Initial;
         GuildObject.StartProcess;
      end else begin
         GuildObject.Initial;
      end;

      DataList.Add (GuildObject);
   end;

   DB.Free;
end;

procedure TGuildList.SaveToFile (aFileName : String);
var
   i, j : integer;
   str, rdstr : string;
   pd : PTCreateGuildData;
   GuildObject : TGuildObject;
   DB : TUserStringDb;
begin
   if not FileExists (aFileName) then exit;

   Db := TUserStringDb.Create;
   Db.LoadFromFile (aFileName);

   for i := 0 to Db.Count - 1 do begin
      Db.DeleteName (Db.GetIndexName (0));
   end;

   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      pd := GuildObject.GetSelfData;
      if pd^.Name = '' then continue;

      GuildObject.SaveToFile;

      Db.AddName (pd^.Name);
      Db.SetFieldValueString (pd^.Name, 'Title', pd^.Title);
      Db.SetFieldValueInteger (pd^.Name, 'MapID', pd^.MapID);
      Db.SetFieldValueInteger (pd^.Name, 'X', pd^.x);
      Db.SetFieldValueInteger (pd^.Name, 'Y', pd^.y);
      Db.SetFieldValueInteger (pd^.Name, 'Durability', pd^.Durability);
      Db.SetFieldValueInteger (pd^.Name, 'MaxDurability', pd^.MaxDurability);
      Db.SetFieldValueString (pd^.Name, 'GuildMagic', pd^.GuildMagic);
      Db.SetFieldValueInteger (pd^.Name, 'MagicExp', pd^.MagicExp);
      Db.SetFieldValueString (pd^.Name, 'MakeDate', pd^.MakeDate);
      Db.SetFieldValueString (pd^.Name, 'Sysop', pd^.Sysop);
      for j := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
         Db.SetFieldValueString (pd^.Name, 'SubSysop' + IntToStr (j), pd^.SubSysop[j]);
      end;
      for j := 0 to MAX_GUILDNPC_COUNT - 1 do begin
         str := pd^.GuildNpc[j].rName + ':';
         str := str + IntToStr (pd^.GuildNpc[j].rx) + ':';
         str := str + IntToStr (pd^.GuildNpc[j].ry) + ':';
         if pd^.GuildNpc[j].rName = '' then str := '';
         Db.SetFieldValueString (pd^.Name, 'Npc' + IntToStr(j), str);
      end;
      for j := 0 to MAX_GUILDWEAR_COUNT - 1 do begin
         str := '';
         if pd^.GuildWear[j].rItemName <> '' then begin
            str := pd^.GuildWear[j].rItemName + ':';
            str := str + IntToStr (pd^.GuildWear[j].rColor) + ':';
            str := str + IntToStr (pd^.GuildWear[j].rItemCount) + ':';
         end;
         Db.SetFieldValueString (pd^.Name, 'Wear' + IntToStr(j), str);
      end;
      Db.SetFieldValueInteger (pd^.Name, 'BasicPoint', pd^.BasicPoint);
      Db.SetFieldValueInteger (pd^.Name, 'AwardPoint', pd^.AwardPoint);
      Db.SetFieldValueInteger (pd^.Name, 'BattleRejectCount', pd^.BattleRejectCount);
      Db.SetFieldValueString (pd^.Name, 'ChallengeGuild', pd^.ChallengeGuild);
      Db.SetFieldValueString (pd^.Name, 'ChallengeGuildUser', pd^.ChallengeGuildUser);
      Db.SetFieldValueString (pd^.Name, 'ChallengeDate', pd^.ChallengeDate);
   end;

   Db.SaveToFile ('.\Guild\CreateGuild.SDB');
   Db.Free;
end;

procedure TGuildList.Update (CurTick: integer);
var
   i, j : Integer;
   DeleteGuildObject, GuildObject : TGuildObject;
   StartPos, GuildProcessCount : Integer;
begin
   GuildProcessCount := (DataList.Count * 4 div 100);
   if GuildProcessCount = 0 then GuildProcessCount := DataList.Count;

   GuildProcessCount := ProcessListCount;

   if DataList.Count > 0 then begin
      StartPos := CurProcessPos;
      for i := 0 to GuildProcessCount - 1 do begin
         if CurProcessPos >= DataList.Count then CurProcessPos := 0;
         GuildObject := DataList.Items [CurProcessPos];
         // if (GuildObject.SelfData.Durability <= 0) or (GuildObject.FboAllowDelete = true) then begin
         if GuildObject.FboAllowDelete = true then begin
            GuildObject.EndProcess;
            GuildObject.Free;
            DataList.Delete (CurProcessPos);
         end else begin
            try
               GuildObject.Update (CurTick);
            except
               frmMain.WriteLogInfo (format ('TGuild.Update (%s) exception', [GuildObject.GuildName]));
               exit;
            end;
         end;
         Inc (CurProcessPos);
         if CurProcessPos = StartPos then break;
      end;
   end;
end;

end.
