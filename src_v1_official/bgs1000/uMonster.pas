unit uMonster;

interface

uses
  Windows, Classes, SysUtils, svClass,subutil, uAnsTick, AnsUnit,
  BasicObj, FieldMsg, MapUnit, DefType, Autil32, aiunit, uUser,
  uAIPath, uManager, uSkills, UserSDB;

type

   TMonster = class (TLifeObject)
   private
      pSelfData : PTMonsterData; 
      HaveItem : array[0..5 - 1] of TCheckItem;

      AttackSkill : TAttackSkill;

      procedure  SetAttackSkillData;
      protected
      procedure  SetMonsterData;
      function   FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
      procedure  Initial (aMonsterName: string; ax, ay, aw: integer);
      procedure  StartProcess; override;
      procedure  EndProcess; override;

      function   Regen : Boolean;
      function   Start : Boolean;
   public
      MonsterName : String;

      constructor Create;
      destructor  Destroy; override;
      procedure   Update (CurTick: integer); override;

      procedure   CallMe(x, y : Integer);

      function    GetAttackSkill : TAttackSkill;
      procedure   SetAttackSkill (aAttackSkill : TAttackSkill);
   end;

   TMonsterList = class
   private
      Manager : TManager;

      CurProcessPos : integer;
      AnsList : TAnsList;

      function  AllocFunction: pointer;
      procedure FreeFunction (item: pointer);
      function  GetCount: integer;
      procedure Clear;
   public
      constructor Create (cnt: integer; aManager : TManager);
      destructor  Destroy; override;

      procedure   AddMonster (aMonsterName: string; ax, ay, aw: integer; aMemberStr : String);
      function    CallMonster (aMonsterName: string; ax, ay, aw: integer; aName : String) : TMonster;
      function    CopyMonster (aBasicData : TBasicData; aAttackSkill : TAttackSkill) : TMonster;
            
      procedure   ReLoadFromFile;

      procedure   Update (CurTick: integer);

      function    GetMonsterByName(aName : String) : TMonster;

      property    Count : integer read GetCount;
   end;

implementation

uses
   SvMain;

/////////////////////////////////////
//       Monster
////////////////////////////////////
constructor TMonster.Create;
begin
   inherited Create;
   pSelfData := nil;
   AttackSkill := nil;
end;

destructor TMonster.Destroy;
begin
   pSelfData := nil;
   if (AttackSkill <> nil) and (FboCopy = false) then begin
      AttackSkill.Free;
   end;
   inherited destroy;
end;

function TMonster.Regen : Boolean;
var
   xx, yy : Integer;
begin
   Result := true;

   {
   for i := 0 to 10 - 1 do begin
      xx := CreatedX - ActionWidth + Random(ActionWidth * 2);
      yy := CreatedY - ActionWidth + Random(ActionWidth * 2);
      if Maper.isMoveable (xx, yy) then begin
         EndProcess;

         BasicData.x := xx;
         BasicData.y := yy;
         BasicData.nx := xx;
         BasicData.ny := yy;
         BasicData.Feature.rHitMotion := AM_HIT1;

         StartProcess;
         exit;
      end;
   end;
   }
   xx := CreatedX - ActionWidth + Random(ActionWidth * 2);
   yy := CreatedY - ActionWidth + Random(ActionWidth * 2);
   if Maper.GetMoveableXY (xx, yy, 10) then begin
      EndProcess;

      BasicData.x := xx;
      BasicData.y := yy;
      BasicData.nx := xx;
      BasicData.ny := yy;
      BasicData.Feature.rHitMotion := AM_HIT1;

      StartProcess;
      exit;
   end;

   Result := false;
end;

function TMonster.Start : Boolean;
var
   xx, yy : Integer;
begin
   Result := true;

   {
   for i := 0 to 10 - 1 do begin
      xx := CreatedX - ActionWidth + Random(ActionWidth * 2);
      yy := CreatedY - ActionWidth + Random(ActionWidth * 2);
      if Maper.isMoveable (xx, yy) then begin
         BasicData.x := xx;
         BasicData.y := yy;
         BasicData.nx := xx;
         BasicData.ny := yy;
         BasicData.Feature.rHitMotion := AM_HIT1;

         StartProcess;
         exit;
      end;
   end;
   }
   xx := CreatedX - ActionWidth + Random(ActionWidth * 2);
   yy := CreatedY - ActionWidth + Random(ActionWidth * 2);
   if Maper.GetMoveableXY (xx, yy, 10) then begin
      BasicData.x := xx;
      BasicData.y := yy;
      BasicData.nx := xx;
      BasicData.ny := yy;
      BasicData.Feature.rHitMotion := AM_HIT1;

      StartProcess;
      exit;
   end;

   Result := false;
end;

procedure TMonster.SetAttackSkillData;
begin
   if pSelfData = nil then exit;
   if AttackSkill = nil then exit;

   AttackSkill.boViewHuman := pSelfData^.rboViewHuman;
   AttackSkill.boAutoAttack := pSelfData^.rboAutoAttack;
   AttackSkill.EscapeLife := pSelfData^.rEscapeLife;
   AttackSkill.ViewWidth := pSelfData^.rViewWidth;
   AttackSkill.boChangeTarget := pSelfData^.rboChangeTarget;
   AttackSkill.boBoss := pSelfData^.rboBoss;
   AttackSkill.boVassal := pSelfData^.rboVassal;
   AttackSkill.VassalCount := pSelfData^.rVassalCount;
   if (pSelfData^.rAttackMagic.rFunction >= 4)
      and (pSelfData^.rAttackMagic.rFunction <= 6) then begin
         HaveSkill := pSelfData^.rAttackMagic.rFunction;
   end else begin
      AttackSkill.SetAttackMagic (pSelfData^.rAttackMagic);
   end;
end;

procedure TMonster.SetMonsterData;
var
   i : Integer;
begin
   if pSelfData = nil then exit;

   LifeData.damageBody      := LifeData.damageBody      + pSelfData^.rDamage;
   LifeData.damageHead      := LifeData.damageHead      + 0;
   LifeData.damageArm       := LifeData.damageArm       + 0;
   LifeData.damageLeg       := LifeData.damageLeg       + 0;
   LifeData.AttackSpeed     := LifeData.AttackSpeed     + pSelfData^.rAttackSpeed;
   LifeData.avoid           := LifeData.avoid           + pSelfData^.ravoid;
   LifeData.recovery        := LifeData.recovery        + pSelfData^.rrecovery;
   LifeData.armorBody       := LifeData.armorBody       + pSelfData^.rarmor;
   LifeData.armorHead       := LifeData.armorHead       + pSelfData^.rarmor;
   LifeData.armorArm        := LifeData.armorArm        + pSelfData^.rarmor;
   LifeData.armorLeg        := LifeData.armorLeg        + pSelfData^.rarmor;

   BasicData.Feature.raninumber := pSelfData^.rAnimate;
   BasicData.Feature.rImageNumber := pSelfData^.rShape;

   for i := 0 to 5 - 1 do begin
      HaveItem[i] := pSelfData^.rHaveItem[i];
   end;

   MaxLife := pSelfData^.rLife;

   SetAttackSkillData;

   WalkSpeed := pSelfData^.rWalkSpeed;
   SoundNormal := pSelfData^.rSoundNormal;
   SoundAttack := pSelfData^.rSoundAttack;
   SoundDie := pSelfData^.rSoundDie;
   SoundStructed := pSelfData^.rSoundStructed;
end;

procedure  TMonster.Initial (aMonsterName: string; ax, ay, aw: Integer);
var
   MonsterData : TMonsterData;
begin
   inherited Initial (aMonsterName);

   if AttackSkill = nil then begin
      AttackSkill := TAttackSkill.Create (Self);
   end;

   pSelfData := MonsterClass.GetMonsterDataPointer (aMonsterName);
   SetMonsterData;
   
   MonsterName := aMonsterName;

   Basicdata.id := GetNewMonsterId;
   BasicData.ClassKind := CLASS_MONSTER;
   BasicData.Feature.rrace := RACE_MONSTER;

   CreatedX := ax;
   CreatedY := ay;
   ActionWidth := aw;
end;

procedure TMonster.StartProcess;
var
   SubData : TSubData;
   MonsterData : TMonsterData;
begin
   inherited StartProcess;

   CurLife := MaxLife;
   
   if AttackSkill = nil then begin
      AttackSkill := TAttackSkill.Create (Self);

      AttackSkill.TargetX := CreateX - 3 + Random (6);
      AttackSkill.TargetY := CreateY - 3 + Random (6);

      SetAttackSkillData;
   end;

   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (0, FM_CREATE, BasicData, SubData);

   if FboCopy = true then begin
      ShowEffect (1, lek_none);
   end;
end;

procedure TMonster.EndProcess;
var
   SubData : TSubData;
begin
   if FboRegisted = FALSE then exit;
   
   SetAttackSkill (nil);
   FboCopy := false;

   Phone.SendMessage (0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

procedure TMonster.CallMe(x, y : Integer);
begin
   EndProcess;
   BasicData.x := x;
   BasicData.y := y;
   StartProcess;
end;

function  TMonster.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i : Integer;
   tx, ty, len, len2: word;
   bo : TBasicObject;
   SubData : TSubData;
   ItemData : TItemData;
label abcde;

begin
   Result := PROC_FALSE;
   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;

   case Msg of
      FM_HIT, FM_STRUCTED, FM_CHANGEFEATURE, FM_MOVE, FM_SHOW:
         begin
            if SenderInfo.id = BasicData.id then goto abcde;
            if SenderInfo.Feature.rrace <> RACE_HUMAN then goto abcde;        // 주석이면 몬스터도 공격
            if SenderInfo.Feature.rHideState = hs_0 then goto abcde;

            if (SenderInfo.Feature.rFeatureState = wfs_die) then begin
               if SenderInfo.id = AttackSkill.CurNearViewHumanId then AttackSkill.CurNearViewHumanId := 0;
               if SenderInfo.id = AttackSkill.HateHumanId then AttackSkill.HateHumanId := 0;
               goto abcde;
            end;
            len := GetLargeLength (BasicData.x, BasicData.y, SenderInfo.x, SenderInfo.y);
            if AttackSkill.ViewWidth < len then exit;
            if AttackSkill.boViewHuman = FALSE then exit;
            bo := nil;
            if AttackSkill.CurNearViewHumanID <> 0 then
               bo := TBasicObject (GetViewObjectById (AttackSkill.CurNearViewHumanId));
            if bo <> nil then begin
               len2 := GetLargeLength (BasicData.x, BasicData.y, bo.Posx, bo.Posy);
               if len2 > len then AttackSkill.CurNearViewHumanId := SenderInfo.id;
            end else AttackSkill.CurNearViewHumanId := SenderInfo.id;
         end;
      FM_HIDE :
         begin
            if SenderInfo.id = BasicData.id then goto abcde;
            if SenderInfo.id = AttackSkill.CurNearViewHumanId then AttackSkill.CurNearViewHumanId := 0;
            if SenderInfo.id = AttackSkill.HateHumanId then AttackSkill.HateHumanId := 0;
         end;
   end;
abcde:

   case Msg of
      FM_SHOW :
         begin
         end;
      FM_CHANGEFEATURE:
         begin
         end;
      FM_GATHERVASSAL :
         begin
            if SenderInfo.id = BasicData.id then exit;
            if AttackSkill.boVassal and (LifeObjectState = los_none) and (aSubData.VassalCount > 0) then begin
               aSubData.VassalCount := aSubData.VassalCount - 1;
               AttackSkill.SetTargetId (aSubData.TargetId, false);
            end;
         end;
      FM_STRUCTED :
         begin
            if SenderInfo.id = BasicData.id then begin
               if CurLife <= 0 then begin
                  BasicData.nx := BasicData.x;
                  BasicData.ny := BasicData.y;

                  AttackSkill.SetTargetId (0, true);

                  for i := 0 to 5 - 1 do begin
                     if HaveItem[i].rName <> '' then begin
                        if ItemClass.GetCheckItemData (MonsterName, HaveItem[i], ItemData) = false then continue;
                        ItemData.rOwnerName[0] := 0;
                        SubData.ItemData := ItemData;
                        SubData.ServerId := Manager.ServerId;
                        Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
                     end;
                  end;
                  exit;
               end;
               if AttackSkill.boChangeTarget then begin
                  Bo := GetViewObjectByID (AttackSkill.GetTargetID);
                  if Bo <> nil then begin
                     len := GetLargeLength (BasicData.x, BasicData.y, Bo.Posx, Bo.Posy);
                     if len > 1 then begin
                        AttackSkill.SetTargetId (aSubData.attacker, true);
                     end;
                  end;
               end;
               if isUserId (aSubData.attacker) then AttackSkill.HateHumanId := aSubData.attacker;
            end;
         end;
      FM_DEADHIT :
         begin
            if SenderInfo.id = BasicData.id then exit;
            if BasicData.Feature.rfeaturestate = wfs_die then begin Result := PROC_TRUE; exit; end;
            CurLife := 0;
            
            AttackSkill.SetTargetId (0, true);

            BasicData.nx := BasicData.x;
            BasicData.ny := BasicData.y;

            for i := 0 to 5 - 1 do begin
               if HaveItem[i].rName <> '' then begin
                  if ItemClass.GetCheckItemData (MonsterName, HaveItem[i], ItemData) = false then continue;
                  ItemData.rOwnerName[0] := 0;
                  SubData.ItemData := ItemData;
                  SubData.ServerId := Manager.ServerId;
                  Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
               end;
            end;

            CommandChangeCharState (wfs_die);
         end;
      FM_HIT :
         begin
         //
         end;
      FM_SAY :
         begin
         end;
   end;
end;

procedure TMonster.Update (CurTick: integer);
var
   i : Integer;
   boFlag : Boolean;
   BO : TLifeObject;
begin
//   inherited UpDate (CurTick);
   if (BasicData.Feature.rfeaturestate = wfs_die) and (LifeObjectState <> los_die) then begin
      LifeObjectState := los_die;
   end;
   
   case LifeObjectState of
      los_init :
         begin
            Start;
            exit;
         end;
      los_die :
         begin
            if CurTick > DiedTick + 1600 then begin
               if Manager.RegenInterval = 0 then begin
                  Regen;
                  exit;
               end;
            end;
            if CurTick > DiedTick + 800 then begin
               if Manager.RegenInterval > 0 then begin
                  FboAllowDelete := true;
                  exit;
               end;
            end;
         end;
      los_none:
         begin
            if AttackSkill <> nil then AttackSkill.ProcessNone (CurTick);
         end;
      los_escape:
         begin
            if AttackSkill <> nil then AttackSkill.ProcessEscape (CurTick);
         end;
      los_attack:
         begin
            if AttackSkill <> nil then begin
               boFlag := AttackSkill.ProcessAttack (CurTick, Self);
               if (boFlag = false) and (boSkillUsed = true) and (FboCopy = false) then begin
                  boSkillUsed := false;
                  if CopiedList <> nil then begin
                     for i := 0 to CopiedList.Count - 1 do begin
                        BO := TLifeObject (CopiedList[i]);
                        BO.boAllowDelete := true;
                     end;
                  end;
               end;
            end;
         end;
      los_moveattack :
         begin
            if AttackSkill <> nil then AttackSkill.ProcessMoveAttack (CurTick);
         end;
      los_deadattack :
         begin
            if AttackSkill <> nil then AttackSkill.ProcessDeadAttack (CurTick);
         end;
   end;
end;

function TMonster.GetAttackSkill : TAttackSkill;
begin
   if AttackSkill = nil then
      AttackSkill := TAttackSkill.Create (Self);
      
   Result := AttackSkill;
end;

procedure TMonster.SetAttackSkill (aAttackSkill : TAttackSkill);
begin
   if AttackSkill <> nil then begin
      if FboCopy = false then begin
         AttackSkill.Free;
      end;
   end;

   AttackSkill := aAttackSkill;
end;

////////////////////////////////////////////////////
//
//             ===  MonsterList  ===
//
////////////////////////////////////////////////////

constructor TMonsterList.Create (cnt: integer; aManager: TManager);
begin
   Manager := aManager;

   CurProcessPos := 0;
   AnsList := TAnsList.Create (cnt, AllocFunction, FreeFunction);

   ReLoadFromFile;
end;

destructor TMonsterList.Destroy;
begin
   Clear;
   AnsList.Free;
   inherited destroy;
end;

procedure TMonsterList.Clear;
var
   i : Integer;
begin
   for i := AnsList.Count - 1 downto 0 do begin
      TMonster (AnsList[i]).EndProcess;
      AnsList.Delete (i);
   end;
end;

procedure   TMonsterList.ReLoadFromFile;
var
   i, j, iCount : integer;
   FileName, iName, MonsterName : String;
   CreateMonsterData : TCreateMonsterData;
   MonsterData : TMonsterData;
   DB : TUserStringDB;
begin
   Clear;

   FileName := '.\Setting\CreateMonster' + IntToStr (Manager.ServerID) + '.SDB';

   if not FileExists (FileName) then exit;

   DB := TUserStringDb.Create;
   DB.LoadFromFile (FileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      MonsterName := DB.GetFieldValueString (iName, 'MonsterName');
      if MonsterName = '' then continue;
      MonsterClass.GetMonsterData (MonsterName, @MonsterData);
      if MonsterData.rName[0] = 0 then continue;
      iCount := DB.GetFieldValueInteger (iName, 'Count');
      if iCount <= 0 then continue;

      CreateMonsterData.Name := MonsterName;
      CreateMonsterData.x := DB.GetFieldValueInteger (iName, 'X');
      CreateMonsterData.y := DB.GetFieldValueInteger (iName, 'Y');
      CreateMonsterData.Width := DB.GetFieldValueInteger (iName, 'Width');
      CreateMonsterData.Member := DB.GetFieldValueString (iName, 'Member');

      for j := 0 to iCount - 1 do begin
         AddMonster (CreateMonsterData.Name, CreateMonsterData.x, CreateMonsterData.y, CreateMonsterData.Width, CreateMonsterData.Member);
      end;
   end;
   DB.Free;
end;

function  TMonsterList.GetCount: integer;
begin
   Result := AnsList.Count;
end;

function TMonsterList.AllocFunction: pointer;
begin
   Result := TMonster.Create;
end;

procedure TMonsterList.FreeFunction (item: pointer);
begin
   TMonster (item).Free;
end;

procedure TMonsterList.AddMonster (aMonsterName: string; ax, ay, aw: integer; aMemberStr : String);
var
   Monster, Member : TMonster;
   str, MemberName, MemberCount : String;
   i, Count : Integer;
   AttackSkill, tmpAttackSkill : TAttackSkill;
begin
   Monster := AnsList.GetUnUsedPointer;
   if Monster <> nil then begin
      Monster.SetManagerClass (Manager);
      Monster.Initial (aMonsterName, ax, ay, aw);
      AnsList.Add (Monster);
      if aMemberStr <> '' then begin
         AttackSkill := Monster.GetAttackSkill;
         AttackSkill.SetGroupSkill;
         str := aMemberStr;
         while str <> '' do begin
            str := GetValidStr3 (str, MemberName, ':');
            if MemberName = '' then break;
            str := GetValidStr3 (str, MemberCount, ':');
            if MemberCount = '' then break;
            Count := _StrToInt (MemberCount);

            for i := 0 to Count - 1 do begin
               Member := AnsList.GetUnUsedPointer;
               if Member <> nil then begin
                  Member.SetManagerClass (Manager);
                  Member.Initial (MemberName, ax, ay, aw);
                  AnsList.Add (Member);
                  AttackSkill.AddGroup (Member);
                  tmpAttackSkill := Member.GetAttackSkill;
                  if tmpAttackSkill <> nil then
                     tmpAttackSkill.SetBoss (Monster);
               end;
            end;
         end;
      end;
   end;
end;

function TMonsterList.CopyMonster (aBasicData : TBasicData; aAttackSkill : TAttackSkill) : TMonster;
var
   Monster : TMonster;
begin
   Result := nil;
   Monster := AnsList.GetUnUsedPointer;
   if Monster <> nil then begin
      Monster.SetManagerClass (Manager);
      Monster.SetAttackSkill (aAttackSkill);
      Monster.FboCopy := true;
      Monster.Initial (StrPas (@aBasicData.Name), aBasicData.x, aBasicData.y, 4);
      if Monster.Start = false then begin
         Monster.Free;
         exit;
      end;
      AnsList.Add (Monster);

      Result := Monster;
   end;
end;

function TMonsterList.CallMonster (aMonsterName: string; ax, ay, aw: integer; aName : String) : TMonster;
var
   Monster : TMonster;
   AttackSkill : TAttackSkill;
begin
   Result := nil;
   
   Monster := AnsList.GetUnUsedPointer;
   if Monster <> nil then begin
      Monster.SetManagerClass (Manager);
      Monster.Initial (aMonsterName, ax, ay, aw);
      if Monster.Start = false then begin
         Monster.Free;
         exit;
      end;
      AttackSkill := Monster.GetAttackSkill;
      if AttackSkill <> nil then begin
         AttackSkill.SetDeadAttackName (aName);
      end;
      AnsList.Add (Monster);

      Result := Monster;
   end;
end;


function TMonsterList.GetMonsterByName(aName : String) : TMonster;
var
   i : Integer;
begin
   Result := nil;
   for i := 0 to AnsList.Count - 1 do begin
      if TMonster(AnsList.Items[i]).MonsterName = aName then begin
         if TMonster(AnsList.Items[i]).BasicData.Feature.rfeaturestate = wfs_normal then begin
            Result := TMonster(AnsList.Items[i]);
            exit;
         end;
      end;
   end;
end;

procedure TMonsterList.Update (CurTick: integer);
var
   i : integer;
   Monster : TMonster;
begin
   if CurProcessPos >= AnsList.Count then CurProcessPos := 0;

   for i := 0 to ProcessListCount - 1 do begin
      if AnsList.Count = 0 then break;
      if CurProcessPos >= AnsList.Count then CurProcessPos := 0;
      Monster := TMonster (AnsList[CurProcessPos]);
      if Monster.FboAllowDelete = true then begin
         Monster.EndProcess;
         AnsList.Delete (CurProcessPos);
      end else begin
         try
            Monster.UpDate (CurTick);
            Inc (CurProcessPos);
         except
            Monster.FBoAllowDelete := true;
            frmMain.WriteLogInfo (format ('TMonsterList.Update (%s) failed', [Monster.MonsterName]));
         end;
      end;
   end;
end;

end.
