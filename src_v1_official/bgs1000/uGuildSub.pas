unit uGuildSub;

interface

uses
   Windows, Sysutils, Classes, aDefType, Deftype, BasicObj, SvClass,
   SubUtil, uSkills, uLevelExp, uUser, aUtil32, uGramerid, AnsUnit,
   FieldMsg, MapUnit, AnsStringCls;


type
   TGuildUserData = record
     rName: string[32];
     rGradeName : string[32];
     rLastDay : integer;
   end;
   PTGuildUserData = ^TGuildUserData;

   TGuildUserList = Class
    private
     boChanged : boolean;
     IndexClass: TAnsIndexClass;
     DataList : TList;
    public
     constructor Create;
     destructor  Destroy; override;
     procedure   LoadFromFile (aFileName: string);
     procedure   SaveToFile (aFileName: string);
     procedure   Clear;
     procedure   AddUser (aUserName: string);
     function    DelUser (aUserName: string): Boolean;
     function    GetGradeName (aUserName: string): string;
     procedure   SetGradeName (aUserName, aGradeName: string);
     function    IsGuildUser (aUserName: string): Boolean;

     property    Changed : boolean read boChanged;
   end;

   TGuildNpc = class (TLifeObject)
   private
      TargetPosTick : Integer;
      TargetX, TargetY : Integer;
      TargetId : integer;
      ParentGuildObject : TBasicObject;

      ActionWidth : Integer;
      boProtector : Boolean;

      function IsSysopName (aname: string) : boolean;
      procedure  SetTargetId (aid: integer);
   protected
      procedure  SetNpcAttrib (aNpcData : PTNpcData);
   public
      GuildNpcName : String;
      boMagicNpc : Boolean;
      StartX, StartY: integer;
      RestX, RestY: integer;
      GuildMagicData : TMagicData;

      constructor Create;
      destructor Destroy; override;
      procedure  StartProcess; override;
      procedure  EndProcess; override;
      function   FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
      procedure  Initial (go : TBasicObject; aNpcName: string; ax, ay: integer);
      // procedure  SetSysop (aSysop, aSubSysop0, aSubSysop1, aSubSysop2: string);
      procedure  Update (CurTick: integer); override;

      procedure  MoveGuildNpc (aServerID, ax, ay: integer);
      procedure  MoveDieGuildNpc (aServerID, ax, ay: integer);
   end;

implementation

uses
   uGuild, uManager;

/////////////////////////////////
//      Guild User List
/////////////////////////////////
constructor TGuildUserList.Create;
begin
   boChanged := false;
   IndexClass := TAnsIndexClass.Create ('user', 20, TRUE);
   DataList := TList.Create;
end;

destructor  TGuildUserList.Destroy;
begin
   Clear;
   DataList.Free;
   IndexClass.Free;
   inherited destroy;
end;

procedure   TGuildUserList.Clear;
var i: integer;
begin
   for i := 0 to DataList.Count -1 do dispose (DataList[i]);
   DataList.Clear;
   IndexClass.Clear;
end;

procedure   TGuildUserList.LoadFromFile (aFileName: string);
var
   i: integer;
   str, rdstr: string;
   StringList : TStringList;
   p : PTGuildUserData;
begin
   Clear;
   if not FileExists (aFileName) then exit;

   StringList := TStringList.Create;
   StringList.LoadFromFile (aFileName);

   for i := 1 to StringList.Count -1 do begin    // 1부터는 첫줄이 필드이기때문에..
      str := StringList[i];
      new (p);
      str := GetValidStr3 (str, rdstr, ',');
      p^.rName := rdstr;
      str := GetValidStr3 (str, rdstr, ',');
      p^.rGradeName := rdstr;
      str := GetValidStr3 (str, rdstr, ',');
      p^.rLastDay := _StrToInt (rdstr);
      if p^.rLastDay = 0 then p^.rLastDay := GameCurrentDate;

      IndexClass.Insert (Integer(p), p^.rName);
      DataList.Add (p);
   end;
   StringList.Free;
end;

procedure   TGuildUserList.SaveToFile (aFileName: string);
var
   i: integer;
   str: string;
   StringList : TStringList;
   p : PTGuildUserData;
begin
   if boChanged = true then begin
      StringList := TStringList.Create;
      str := 'Name,GradeName,LastDay,';
      StringList.add (str);
      for i := 0 to DataList.Count -1 do begin
         p := DataList[i];
         str := p^.rName + ',' + p^.rGradeName + ',' + IntToStr (p^.rLastDay);
         StringList.Add (str);
      end;
      StringList.SaveToFile (aFileName);
      StringList.Free;
      boChanged := false;
   end;
end;

function    TGuildUserList.GetGradeName (aUserName: string): string;
var
   n : integer;
begin
   Result := '';
   n := IndexClass.Select (aUserName);
   if (n <> 0) and (n <> -1) then begin
      PTGuildUserData(n)^.rLastDay := GameCurrentDate;
      Result := PTGuildUserData (n)^.rGradeName;
   end;
end;

procedure   TGuildUserList.SetGradeName (aUserName, aGradeName: string);
var
   n : integer;
begin
   n := IndexClass.Select (aUserName);
   if (n <> 0) and (n <> -1) then begin
      PTGuildUserData (n)^.rGradeName := aGradeName;
      boChanged := true;
   end;
end;

procedure   TGuildUserList.AddUser (aUserName: string);
var
   n : integer;
   p : PTGuildUserData;
begin
   n := IndexClass.Select (aUserName);
   if (n <> 0) and (n <> -1) then exit
   else begin
      new (p);
      p^.rName := aUserName;
      p^.rGradeName := '';
      p^.rLastDay := GameCurrentDate;

      DataList.Add (p);
      IndexClass.Insert (Integer(p), aUserName);

      boChanged := true;
   end;
end;

function    TGuildUserList.IsGuildUser (aUserName: string): Boolean;
var
   n : integer;
begin
   n := IndexClass.Select (aUserName);
   if (n <> 0) and (n <> -1) then Result := TRUE
   else Result := FALSE;
end;

function    TGuildUserList.DelUser (aUserName: string): Boolean;
var i, n : integer;
begin
   n := IndexClass.Select (aUserName);
   if (n <> 0) and (n <> -1) then begin
      for i := 0 to DataList.Count -1 do begin
         if aUserName = PTGuildUserData (DataList[i])^.rname then begin
            dispose (DataList[i]);
            DataList.Delete (i);
            IndexClass.Delete (aUserName);
            boChanged := true;
            break;
         end;
      end;
      Result := TRUE;
   end else Result := FALSE;
end;

///////////////////////////////////////////


/////////////////////////////////////
//       Npc
////////////////////////////////////
constructor TGuildNpc.Create;
begin
   inherited Create;

   boProtector := false;
   ActionWidth := 0;
end;

destructor TGuildNpc.Destroy;
begin
   inherited destroy;
end;

procedure TGuildNpc.SetTargetId (aid: integer);
begin
   if aid = BasicData.id then exit;
   TargetId := aid;
   LifeObjectState := los_attack;
end;

procedure TGuildNpc.SetNpcAttrib (aNpcData : PTNpcData);
begin
   LifeData.damagebody      := LifeData.damagebody      + aNpcData^.rDamage;
   LifeData.damagehead      := LifeData.damagehead      + 0;
   LifeData.damagearm       := LifeData.damagearm       + 0;
   LifeData.damageleg       := LifeData.damageleg       + 0;
   LifeData.AttackSpeed     := LifeData.AttackSpeed     + aNpcData^.rAttackSpeed;
   LifeData.avoid           := LifeData.avoid           + aNpcData^.ravoid;
   LifeData.recovery        := LifeData.recovery        + aNpcData^.rrecovery;
   LifeData.armorbody       := LifeData.armorbody       + aNpcData^.rarmor;
   LifeData.armorhead       := LifeData.armorhead       + aNpcData^.rarmor;
   LifeData.armorarm        := LifeData.armorarm        + aNpcData^.rarmor;
   LifeData.armorleg        := LifeData.armorleg        + aNpcData^.rarmor;

   BasicData.Feature.raninumber := aNpcData^.rAnimate;
   BasicData.Feature.rImageNumber := aNpcData^.rShape;
   
   MaxLife := aNpcData^.rLife;

   SoundNormal := aNpcData^.rSoundNormal;
   SoundAttack := aNpcData^.rSoundAttack;
   SoundDie := aNpcData^.rSoundDie;
   SoundStructed := aNpcData^.rSoundStructed;
end;

function TGuildNpc.IsSysopName (aname : String) : boolean;
var
   i : Integer;
   pd : PTCreateGuildData;
begin
   Result := TRUE;
   if ParentGuildObject <> nil then begin
      pd := TGuildObject (ParentGuildObject).GetSelfData;
      if pd^.Sysop = aname then exit;
      for i := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
         if pd^.SubSysop[i] = aname then exit;
      end;
   end;

   Result := FALSE;
end;

procedure  TGuildNpc.Initial (go : TBasicObject; aNpcName: string; ax, ay: integer);
var
   NpcData : TNpcData;
begin
   inherited Initial (aNpcName);
   
   GuildNpcName := aNpcName;

   boMagicNpc := FALSE;
   FillChar (GuildMagicData, SizeOf(TMagicData), 0);

   ParentGuildObject := go;

   NpcClass.GetNpcData (INI_GUILD_NPC_NAME, @NpcData);

   Basicdata.id := GetNewMonsterId;
   BasicData.x := ax;
   BasicData.y := ay;
   BasicData.dir := DR_4;
   BasicData.ClassKind := CLASS_GUILDNPC;
   BasicData.Feature.rrace := RACE_NPC;
   StrPCopy (@BasicData.Name, aNpcName);

   boProtector := NpcData.rboProtector;
   ActionWidth := NpcData.rActionWidth;

   SetNpcAttrib (@NpcData);

   TargetId := 0;
   TargetPosTick := 0;

   // 2000.09.16 TargetX, TargetY 가 지정되지 않아 서버가 시작된 후 NPC들의
   // 동작이 획일적으로 북서쪽을 향한다. 초기 위치를 넣어준다 by Lee.S.G
   TargetX := aX; TargetY := aY;
   RestX := aX; RestY := aY;
   StartX := aX; StartY := aY;
end;

procedure TGuildNpc.StartProcess;
var
   SubData : TSubData;
begin
   inherited StartProcess;

   CurLife := MaxLife;

   BasicData.Feature.rhitmotion := AM_HIT1;
   TFieldPhone(Manager.Phone).RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   TFieldPhone(Manager.Phone).SendMessage (0, FM_CREATE, BasicData, SubData);
end;

procedure TGuildNpc.EndProcess;
var SubData : TSubData;
begin
   if FboRegisted = FALSE then exit;
   
   TFieldPhone (Manager.Phone).SendMessage (0, FM_DESTROY, BasicData, SubData);
   TFieldPhone (Manager.Phone).UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);
   inherited EndProcess;
end;

procedure TGuildNpc.MoveGuildNpc (aServerID, ax, ay: integer);
var
   tmpManager : TManager;
   SubData : TSubData;
   nX, nY : Integer;
begin
   tmpManager := ManagerList.GetManagerByServerID (aServerID);

   TFieldPhone (Manager.Phone).SendMessage (NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
   TFieldPhone (Manager.Phone).UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   nX := aX; nY := aY;
   TMaper(tmpManager.Maper).GetNearXY (nX, nY);
   StartX := nX; StartY := nY;
   TargetX := nX; TargetY := nY;
   RestX := nX; RestY := nY;
   BasicData.x := nX; BasicData.y := nY;

   SetManagerClass (tmpManager);

   TFieldPhone (Manager.Phone).RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   TFieldPhone (Manager.Phone).SendMessage (NOTARGETPHONE, FM_CREATE, BasicData, SubData);
end;

procedure TGuildNpc.MoveDieGuildNpc (aServerID, ax, ay: integer);
var
   tmpManager : TManager;
   nX, nY : Integer;
begin
   tmpManager := ManagerList.GetManagerByServerID (aServerID);

   nX := aX; nY := aY;
   TMaper(tmpManager.Maper).GetNearXY (nX, nY);
   StartX := nX; StartY := nY;
   TargetX := nX; TargetY := nY;
   RestX := nX; RestY := nY;
   BasicData.x := nX; BasicData.y := nY;

   SetManagerClass (tmpManager);
end;

function  AddPermitExp (var aLevel, aExp: integer; addvalue: integer): integer;
var n : integer;
begin
   n := GetLevelMaxExp (aLevel) * 3;
   if n > addvalue then n := addvalue;
   inc (aExp, n);
   aLevel := GetLevel (aExp);
   Result := n;
end;

function  TGuildNpc.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i: integer;
   str, boname : string;
   sayer, objectname, gradename: string;
   Bo: TBasicObject;
   MagicData : TMagicData;
   OldSkillLevel : Integer;
begin
   Result := PROC_FALSE;
   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;
   case Msg of
      FM_ADDITEM :
         begin
            exit;
            {
            Bo := GetViewObjectByid (SenderInfo.id);
            if Bo = nil then exit;
            if not (Bo is TUSER) then exit;
            boname := TUser (Bo).Name;
            IsSysopName(boname);
            }
         end;
      FM_ADDATTACKEXP  :
         begin
            if boMagicNpc then begin
               OldSkillLevel := GuildMagicData.rcSkillLevel;
               AddPermitExp (GuildMagicData.rcSkillLevel, GuildMagicData.rSkillExp, aSubData.ExpData.Exp);
               if OldSkillLevel <> GuildMagicData.rcSkillLevel then begin
                  if (GuildMagicData.rcSkillLevel mod 10) = 0 then begin
                     {
                     if GuildMagicData.rcSkillLevel >= 5000 then begin
                        BocSay ( Get10000To100 (GuildMagicData.rcSkillLevel) );
                     end else begin
                        BocSay ( Get10000To100 (GuildMagicData.rcSkillLevel) );
                     end;
                     }
                     BocSay ( Get10000To100 (GuildMagicData.rcSkillLevel) );
                  end;
               end;
            end;
         end;
      FM_SHOW :
         begin
         end;
      FM_CHANGEFEATURE:
         begin
            if (SenderInfo.id = TargetId) and (SenderInfo.Feature.rFeatureState = wfs_die) then SetTargetId (0);
         end;
      FM_GUILDATTACK :
         begin
            if CurLife <= 0 then exit;
            if LifeObjectState = los_attack then exit;
            Result := PROC_FALSE;
            if aSubData.TargetId <> 0 then begin
               // 2000.10.04 문주나 부문주는 공격하지 않도록 수정 by Lee.S.G
               Bo := GetViewObjectByID (aSubData.TargetId);
               if Bo = nil then exit;
               if Bo is TGuildNpc then begin
                  if TGuildObject(ParentGuildObject).GuildName <> TGuildObject(TGuildNpc(Bo).ParentGuildObject).GuildName then begin
                     SetTargetId(aSubData.TargetId);
                  end;
               end
               else begin
                  if Bo is TUser then begin
                     boname := TUser (Bo).Name;
                     if IsSysopName(boname) = FALSE then begin
                        SetTargetId (aSubData.TargetId);
                     end;
                  end else begin
                     SetTargetId (aSubData.TargetId);
                  end;
               end;
               Result := PROC_TRUE;
            end;
         end;
      FM_STRUCTED :
         begin
            if (SenderInfo.id = BasicData.id) then begin
               if CurLife <= 0 then begin
                  SetTargetId (0);
                  // CommandChangeCharState (wfs_die);
                  exit;
               end;
               if boProtector then begin
                  // 2000.10.04 문주나 부문주는 공격하지 않도록 수정 by Lee.S.G
                  Bo := GetViewObjectByID (aSubData.Attacker);
                  if Bo = nil then exit;
                  if Bo is TGuildNpc then begin
                     if TGuildObject(ParentGuildObject).GuildName <> TGuildObject(TGuildNpc(Bo).ParentGuildObject).GuildName then begin
                        SetTargetId(aSubData.attacker);
                     end;
                  end
                  else begin
                     if Bo is TUser then begin
                        {
                        boname := TUser (Bo).Name;
                        if IsSysopName(boname) = TRUE then begin
                           // 문파관리자에게 맞았을때에는 잠시 문주의 반대방향으로 회피
                           if (BasicData.X < TUser(Bo).BasicData.X) and (BasicData.Y < TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X - 6; TargetY := BasicData.Y - 6;
                           end else if (BasicData.X = TUser(Bo).BasicData.X) and (BasicData.Y < TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X + 0; TargetY := BasicData.Y - 6;
                           end else if (BasicData.X > TUser(Bo).BasicData.X) and (BasicData.Y < TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X + 6; TargetY := BasicData.Y - 6;
                           end else if (BasicData.X > TUser(Bo).BasicData.X) and (BasicData.Y = TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X + 6; TargetY := BasicData.Y + 0;
                           end else if (BasicData.X > TUser(Bo).BasicData.X) and (BasicData.Y > TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X + 6; TargetY := BasicData.Y + 6;
                           end else if (BasicData.X = TUser(Bo).BasicData.X) and (BasicData.Y > TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X + 0; TargetY := BasicData.Y + 6;
                           end else if (BasicData.X < TUser(Bo).BasicData.X) and (BasicData.Y > TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X - 6; TargetY := BasicData.Y + 6;
                           end else if (BasicData.X < TUser(Bo).BasicData.X) and (BasicData.Y = TUser(Bo).BasicData.Y) then begin
                              TargetX := BasicData.X - 6; TargetY := BasicData.Y + 0;
                           end;
                           LifeObjectState := los_rest;
                        end else begin
                           SetTargetId (aSubData.attacker);
                        end;
                        }
                        SetTargetId (aSubData.attacker);
                     end else begin
                        SetTargetId (aSubData.attacker);
                     end;
                  end;
               end;
            end;
         end;
      FM_DEADHIT :
         begin
            CurLife := 0;
            CommandChangeCharState (wfs_die);
         end;
      FM_SAY:
         begin
            if FboAllowDelete then exit;
            if SenderInfo.id = BasicData.id then exit;
            if TargetId <> 0 then begin
               if (TargetID <> TGuildObject(ParentGuildObject).BasicData.ID) and
                  (LifeObjectState = los_attack) then exit;
            end;

            if LifeObjectState = los_escape then exit;

            str := GetWordString (aSubData.SayString);
            if ReverseFormat (str, '%s: ', sayer, objectname, gradename, 1) then begin
               if (IsSysopName(sayer) = FALSE) and (SysopClass.GetSysopScope (sayer) < 100) then begin
                  exit;
               end;
            end;

            if ReverseFormat (str, '%s: 문파무공을 %s님에게 전수한다', sayer, objectname, gradename, 2) then begin
               if boMagicNpc then begin
                  // 2000.09.18 NPC의 이름과 User의 이름이 같을때 검색오류버그 수정 by Lee.S.G
                  // 문파무공 전수는 RACE_HUMAN에서만 유효하다
                  Bo := GetViewObjectByName (objectname, RACE_HUMAN);
                  if Bo = nil then begin BocSay (format ('%s님은 없습니다.',[objectname])); exit; end;
                  if not (Bo is TUser) then begin BocSay (format ('%s님은 사용자가 아닙니다.',[objectname])); exit; end;
                  if TUser(Bo).GuildName = '' then begin BocSay ('문원이 아닙니다.'); exit; end;
                  if TUser(Bo).GuildName <> TGuildObject(ParentGuildObject).GuildName then begin
                     BocSay (format ('%s님은 다른문파 입니다.',[objectname]));
                     exit;
                  end;
                  if StrPas (@GuildMagicData.rName) = '' then begin BocSay ('문파무공이 없습니다.'); exit; end;
                  if GuildMagicData.rcSkillLevel < 5000 then begin BocSay ('저의 수련도가 부족합니다.'); exit; end;
                  MagicClass.GetMagicData (StrPas (@GuildMagicData.rName), MagicData, 0);
                  if TUser(Bo).AddMagic (@MagicData) then begin
                     BocSay ('문파무공을 전수 했습니다.');
                     GuildMagicData.rSkillExp := 0;
                     GuildMagicData.rcSkillLevel := GetLevel(GuildMagicData.rSkillExp);
                  end else BocSay ('문파무공을 전수를 실패했습니다.');
               end;
               exit;
            end;

            if ReverseFormat (str, '%s: %s의 이름은 %s이다', sayer, objectname, gradename, 3) then begin
               // objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  for i := 0 to MAX_GUILDNPC_COUNT - 1 do begin
                     if TGuildObject (ParentGuildObject).IsGuildNpc (gradename) then begin
                        BocSay ('이미 같은 이름이 있습니다.');
                        exit;
                     end;
                  end;

                  if (not isFullHangul (gradename)) or (not isGrammarID(gradename)) then begin
                     BocSay ('이름이 잘못되었습니다.');
                     exit;
                  end;
                  if (Length (gradename) <= 1) or (Length(gradename) > 10) then begin
                     BocSay ('이름이 잘못되었습니다.');
                     exit;
                  end;
                  
                  StrPCopy (@BasicData.Name, gradename);
                  GuildNpcName := Gradename;
                  BocChangeProperty;
                  BocSay (format ('저의 이름은 %s가 되었습니다.',[GuildNpcName]));
                  exit;
               end;
               exit;
            end;

            if ReverseFormat (str, '%s: %s의 위치는 여기다', sayer, objectname, gradename, 2) then begin
               // objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  if not TMaper(Manager.Maper).isObjectArea (BasicData.x, BasicData.y) then begin
                     StartX := BasicData.x; StartY := BasicData.y;
                     BocSay ('저는 여기에서 시작됩니다.');
                  end else begin
                     BocSay ('이곳에 위치를 지정할 수 없습니다');
                  end;
               end;
               exit;
            end;

            { 그냥 한번 넣어본 코딩 by Lee.S.G
            // if ReverseFormat (str, '%s: %s는 %s를 공격한다', sayer, objectname, targetname, 3) then begin
               // objectname := copy (objectname, 1, Length(objectname)-2);
               // targetname := copy (targetname, 1, Length(targetname)-2);
               if objectname = GuildNpcName then begin
                  Bo := GetViewObjectByName (targetname, RACE_HUMAN);
                  if Bo = nil then begin BocSay (format ('%s님은 없습니다.',[targetname])); exit; end;
                  if not (Bo is TUser) then begin BocSay (format ('%s님은 사용자가 아닙니다.',[targetname])); exit; end;
                  SetTargetID(TUser(Bo).BasicData.id);
               end;
            end;
            }

            if ReverseFormat (str, '%s: %s은 따라온다', sayer, objectname, gradename, 2) or
               ReverseFormat (str, '%s: %s는 따라온다', sayer, objectname, gradename, 2) then begin
               // objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  if BasicData.Feature.rfeaturestate = wfs_sitdown then begin
                     BasicData.Feature.rfeaturestate := wfs_normal;
                     BocChangeFeature;
                  end;

                  TargetId := SenderInfo.id;
                  LifeObjectState := los_follow;
               end;
               exit;
            end;
            if ReverseFormat (str, '%s: %s은 정지한다', sayer, objectname, gradename, 2) or
               ReverseFormat (str, '%s: %s는 정지한다', sayer, objectname, gradename, 2) then begin
               // objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then LifeObjectState := los_stop;
               exit;
            end;
            // 2000.09.16 문파포졸에 대한 일어선다,앉는다의 동작 삭제 by Lee.S.G
            {
            // if ReverseFormat (str, '%s: %s 일어선다', sayer, objectname, gradename, 2) then begin
               objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  if BasicData.Feature.rfeaturestate = wfs_sitdown then begin
                     BasicData.Feature.rfeaturestate := wfs_normal;
                     BocChangeFeature;
                  end;
               end;
            end;
            // if ReverseFormat (str, '%s: %s 앉는다', sayer, objectname, gradename, 2) then begin
               objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  if BasicData.Feature.rfeaturestate = wfs_normal then begin
                     BasicData.Feature.rfeaturestate := wfs_sitdown;
                     BocChangeFeature;
                     LifeObjectState := los_stop;
                  end;
               end;
            end;
            }
            if ReverseFormat (str, '%s: %s은 휴식한다', sayer, objectname, gradename, 2) or
               ReverseFormat (str, '%s: %s는 휴식한다', sayer, objectname, gradename, 2) then begin
               // objectname := copy (objectname, 1, Length(objectname)-2);
               if objectname = GuildNpcName then begin
                  if BasicData.Feature.rfeaturestate = wfs_sitdown then begin
                     BasicData.Feature.rfeaturestate := wfs_normal;
                     BocChangeFeature;
                  end;

                  RestX := BasicData.x;
                  RestY := BasicData.y;
                  LifeObjectState := los_rest;
                  BocSay ('저는 여기에서 휴식합니다.');
               end;
               exit;
            end;
         end;
   end;
end;

procedure TGuildNpc.Update (CurTick: integer);
var
   key : word;
   Bo : TBasicObject;
   i : integer;
begin
   inherited UpDate (CurTick);

   if (BasicData.Feature.rFeatureState = wfs_die) and (CurTick > DiedTick + 1600) then begin
      FboAllowDelete := TRUE;
      exit;
   end;

   case LifeObjectState of
      los_none:
         begin
            if TargetPosTick + 3000 < CurTick then begin
               TargetPosTick := Curtick;
               TargetX := RestX - ActionWidth div 2 + Random (ActionWidth);
               TargetY := RestY - ActionWidth div 2 + Random (ActionWidth);
               exit;
            end;

            if WalkTick + 200 < CurTick then begin
               Walktick := CurTick;
               GotoXyStand (TargetX, TargetY);
            end;
         end;
      los_die :;
      los_follow:
         begin
            bo := TBasicObject (GetViewObjectById (TargetId));
            if bo = nil then LifeObjectState := los_none
            else begin
               if GetLargeLength (BasicData.X, BasicData.Y, bo.PosX, bo.PosY) <= 2 then exit; 

               if WalkTick + 60 < CurTick then begin
                  Walktick := CurTick;
                  GotoXyStand (bo.Posx, bo.Posy);
               end;
            end;
         end;
      los_stop:
         begin
         end;
      los_rest:
         begin
            if TargetPosTick + 3000 < CurTick then begin
               TargetPosTick := Curtick;
               TargetX := RestX - ActionWidth div 2 + Random (ActionWidth);
               TargetY := RestY - ActionWidth div 2 + Random (ActionWidth);
               exit;
            end;

            if WalkTick + 200 < CurTick then begin
               Walktick := CurTick;
               GotoXyStand (TargetX, TargetY);
            end;
         end;
      los_attack:
         begin
            bo := TBasicObject (GetViewObjectById (TargetId));
            if bo = nil then LifeObjectState := los_none
            else begin
               if GetLargeLength (BasicData.X, BasicData.Y, bo.PosX, bo.PosY) = 1 then begin
                  key := GetNextDirection (BasicData.X, BasicData.Y, bo.PosX, bo.PosY);
                  if key = DR_DONTMOVE then exit;   // 위쪽이 0 일때의 경우인데 위쪽이 1임..
                  if key <> BasicData.dir then CommandTurn (key);
                  CommandHit (CurTick);
               end else begin
                  if WalkTick + 35 < CurTick then begin
                     Walktick := CurTick;

                     GotoXyStand (bo.Posx, bo.Posy);
                  end;
               end;
            end;
         end;
   end;
end;

end.
