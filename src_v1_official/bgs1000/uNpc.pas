unit uNpc;

interface

uses
  Windows, Messages, Classes, SysUtils, svClass,subutil, uAnsTick, AnsUnit,
  BasicObj, FieldMsg, MapUnit, DefType, Autil32, uUser, UserSDB,
  uManager, uSkills, AnsStringCls;

type

   TNpc = class (TLifeObject)
    private
     pSelfData : PTNpcData;
     boFighterNpc: Boolean;
     DblClick_UserId : integer;

     BuySellSkill : TBuySellSkill;
     SpeechSkill : TSpeechSkill;
     DeallerSkill : TDeallerSkill;
     AttackSkill : TAttackSkill;

     function  Regen : Boolean;
     function  Start : Boolean;
    protected
     procedure  SetNpcAttrib;
     function   FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
     procedure  Initial (aNpcName: string; ax, ay, aw: integer; aBookName : String);
     procedure  StartProcess; override;
     procedure  EndProcess; override;
    public
     NpcName : string;
     CreateIndex : integer;
     constructor Create;
     destructor Destroy; override;
     procedure  Update (CurTick: integer); override;

     procedure CallMe(x, y : Integer);
     function GetAttackSkill : TAttackSkill;
     procedure SetAttackSkill (aAttackSkill : TAttackSkill);
   end;

   TNpcList = class
   private
     Manager : TManager;
     CurProcessPos : integer;
     AnsList : TAnsList;

     function  AllocFunction: pointer;
     procedure FreeFunction (item: pointer);
     function  GetCount: integer;

     procedure Clear;
   public
     constructor Create (cnt: integer; aManager: TManager);
     destructor  Destroy; override;

     procedure   ReLoadFromFile;

     function    CallNpc (aNpcName: string; ax, ay, aw: integer; aName : String) : TNpc;
     procedure   AddNpc (aNpcName: string; ax, ay, aw: integer; aBookName : String);
     procedure   Update (CurTick: integer);
     property    Count : integer read GetCount;

     function    GetNpcByName (aName : String) : TBasicObject;
   end;

var
   FighterNpc : TNpc = nil;


implementation

uses
   svMain;

/////////////////////////////////////
//       Npc
////////////////////////////////////
constructor TNpc.Create;
begin
   inherited Create;

   pSelfData := nil;
   DblClick_UserId := 0;
   boFighterNpc := FALSE;

   BuySellSkill := nil;
   SpeechSkill := nil;
   DeallerSkill := nil;
   AttackSkill := nil;
end;

destructor TNpc.Destroy;
begin
   pSelfData := nil;
   if BuySellSkill <> nil then BuySellSkill.Free;
   if SpeechSkill <> nil then SpeechSkill.Free;
   if DeallerSkill <> nil then DeallerSkill.Free;
   if (AttackSkill <> nil) and (FboCopy = false) then AttackSkill.Free;

   inherited destroy;
end;

function  TNpc.Regen : Boolean;
var
   i, xx, yy : word;
begin
   Result := true;

   for i := 0 to 10 - 1 do begin
      xx := CreatedX - ActionWidth + Random(ActionWidth * 2);
      yy := CreatedY - ActionWidth + Random(ActionWidth * 2);
      if Maper.isMoveable (xx, yy) then begin
         EndProcess;

         BasicData.x := xx;
         BasicData.y := yy;
         BasicData.nx := xx;
         BasicData.ny := yy;
         BasicData.dir := DR_4;
         BasicData.Feature.rhitmotion := AM_HIT1;

         StartProcess;
         exit;
      end;
   end;
   Result := false;
end;

function TNpc.Start : Boolean;
var
   i, xx, yy : word;
begin
   Result := true;

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
   Result := false;
end;

procedure TNpc.SetNpcAttrib;
begin
   if pSelfData = nil then exit;
   
   LifeData.damagebody      := LifeData.damagebody      + pSelfData^.rDamage;
   LifeData.damagehead      := LifeData.damagehead      + 0;
   LifeData.damagearm       := LifeData.damagearm       + 0;
   LifeData.damageleg       := LifeData.damageleg       + 0;
   LifeData.AttackSpeed     := LifeData.AttackSpeed     + pSelfData^.rAttackSpeed;
   LifeData.avoid           := LifeData.avoid           + pSelfData^.ravoid;
   LifeData.recovery        := LifeData.recovery        + pSelfData^.rrecovery;
   LifeData.armorbody       := LifeData.armorbody       + pSelfData^.rarmor;
   LifeData.armorhead       := LifeData.armorhead       + pSelfData^.rarmor;
   LifeData.armorarm        := LifeData.armorarm        + pSelfData^.rarmor;
   LifeData.armorleg        := LifeData.armorleg        + pSelfData^.rarmor;

   SoundNormal := pSelfData^.rSoundNormal;
   SoundAttack := pSelfData^.rSoundAttack;
   SoundDie := pSelfData^.rSoundDie;
   SoundStructed := pSelfData^.rSoundStructed;
end;

procedure  TNpc.Initial (aNpcName: string; ax, ay, aw: integer; aBookName : String);
begin
   inherited Initial (aNpcName);
   
   if aNpcName = 'ºñ¹«Àå' then boFighterNpc := TRUE
   else boFighterNpc := FALSE;

   DblClick_UserId := 0;

   if AttackSkill = nil then begin
      AttackSkill := TAttackSkill.Create (Self);
   end;

   pSelfData := NpcClass.GetNpcDataPointer (aNpcName);
   
   SetNpcAttrib;

   NpcName := aNpcName;

   if pSelfData^.rboSeller = true then begin
      if BuySellSkill = nil then
         BuySellSkill := TBuySellSkill.Create (Self);

      BuySellSkill.LoadFromFile (Manager.Directory + StrPas (@pSelfData^.rNpcText));
   end;

   BasicData.id := GetNewMonsterId;
   CreatedX := ax;
   CreatedY := ay;
   ActionWidth := aw;
   BasicData.ClassKind := CLASS_NPC;
   BasicData.Feature.rrace := RACE_NPC;

   BasicData.Feature.raninumber := pSelfData^.rAnimate;
   BasicData.Feature.rImageNumber := pSelfData^.rShape;

   MaxLife := pSelfData^.rLife;

   if aBookName <> '' then begin
      if SpeechSkill = nil then begin
         SpeechSkill := TSpeechSkill.Create (Self);
      end;
      SpeechSkill.LoadFromFile (aBookName);
      if DeallerSkill = nil then begin
         DeallerSkill := TDeallerSkill.Create (Self);
      end;
      DeallerSkill.LoadFromFile (aBookName);
   end;
end;

procedure TNpc.StartProcess;
var
   SubData : TSubData;
begin
   inherited StartProcess;

   CurLife := MaxLife;

   if AttackSkill = nil then begin
      AttackSkill := TAttackSkill.Create (Self);

      AttackSkill.TargetX := CreateX - 3 + Random (6);
      AttackSkill.TargetY := CreateY - 3 + Random (6);
   end;

   if boFighterNpc then begin
      FighterNpc := Self;
      DontAttacked := TRUE;
   end;

   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (0, FM_CREATE, BasicData, SubData);
end;

procedure TNpc.EndProcess;
var
   SubData : TSubData;
begin
   if FboRegisted = FALSE then exit;
   
   SetAttackSkill (nil);
   FboCopy := false;

   Phone.SendMessage (0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);
   if boFighterNpc then begin
      FighterNpc := nil;
      DontAttacked := FALSE;
   end;
   inherited EndProcess;
end;

procedure TNpc.CallMe(x, y : Integer);
begin
   EndProcess;
   BasicData.x := x;
   BasicData.y := y;
   StartProcess;
end;

function  TNpc.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i : integer;
   tx, ty : Word;
   RetStr, Str : string;
   bo : TBasicObject;
   User : TUser;
//   Mon : TMonster;
   SubData: TSubData;
   ItemData : TItemData;
   tmpAttackSkill : TAttackSkill;
begin
   Result := PROC_FALSE;
   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;

   if boFighterNpc then begin
      UserList.FieldProc2 (hfu, Msg, SenderInfo, aSubData);
      exit;
   end;

   case Msg of
      FM_CLICK :
         begin
            if BuySellSkill <> nil then begin
               if BuySellSkill.CanLogItem = true then begin
                  User := UserList.GetUserPointer (StrPas (@SenderInfo.Name));
                  if User <> nil then begin
                     RetStr := User.ShowItemLogWindow;
                     if RetStr <> '' then begin
                        CommandSay (RetStr);
                     end;
                  end;
               end;
            end;
         end;
      FM_SHOW :
         begin
            if SenderInfo.id = BasicData.id then exit;
            if SenderInfo.Feature.rHideState = hs_0 then exit;
            if SenderInfo.Feature.rFeatureState = wfs_die then begin
               if AttackSkill.GetTargetID = SenderInfo.id then begin
                  AttackSkill.SetTargetID (0, true);
                  exit;
               end;
            end;
            if AttackSkill.GetTargetID <> 0 then exit;

            if pSelfData^.rboProtector = true then begin
//               if SenderInfo.Feature.rrace = RACE_MONSTER then begin
//                  Mon := TMonster (GetViewObjectById (SenderInfo.id));
//                  if Mon <> nil then begin
//                     tmpAttackSkill := Mon.GetAttackSkill;
//                     if tmpAttackSkill <> nil then begin
//                        if tmpAttackSkill.boAutoAttack = true then
//                           AttackSkill.SetTargetId (SenderInfo.id, true);
//                     end;
//                  end;
//               end;
//               exit;
            end;
            if pSelfData^.rboAutoAttack = true then begin
               if SenderInfo.Feature.rrace = RACE_HUMAN then begin
                  AttackSkill.SetTargetId (SenderInfo.id, true);
               end;
            end;
         end;
      FM_CHANGEFEATURE:
         begin
            if SenderInfo.id = BasicData.id then exit;
            if SenderInfo.Feature.rHideState = hs_0 then exit;
            if (SenderInfo.id = AttackSkill.GetTargetId)
               and (SenderInfo.Feature.rFeatureState = wfs_die) then begin
               AttackSkill.SetTargetId (0, true);
               exit;
            end;

            if AttackSkill.GetTargetID <> 0 then exit;

            if pSelfData^.rboAutoAttack = true then begin
               if SenderInfo.Feature.rrace = RACE_HUMAN then begin
                  AttackSkill.SetTargetId (SenderInfo.id, true);
               end;
            end;
         end;
      FM_STRUCTED :
         begin
            if SenderInfo.id = BasicData.id then begin
               if pSelfData^.rboProtector then begin
                  AttackSkill.SetTargetId (aSubData.attacker, true);
               end;
               if CurLife <= 0 then begin
                  BasicData.nx := BasicData.x;
                  BasicData.ny := BasicData.y;

                  AttackSkill.SetTargetId (0, true);

                  for i := 0 to 5 - 1 do begin
                     if pSelfData^.rHaveItem[i].rName <> '' then begin
                        if ItemClass.GetCheckItemData (NpcName, pSelfData^.rHaveItem[i], ItemData) = false then continue;
                        ItemData.rOwnerName[0] := 0;
                        SubData.ItemData := ItemData;
                        SubData.ServerId := Manager.ServerId;
                        Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
                     end;
                  end;
               end;
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
               if pSelfData^.rHaveItem[i].rName <> '' then begin
                  if ItemClass.GetCheckItemData (NpcName, pSelfData^.rHaveItem[i], ItemData) = false then continue;
                  ItemData.rOwnerName[0] := 0;
                  SubData.ItemData := ItemData;
                  SubData.ServerId := Manager.ServerId;
                  Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
               end;
            end;

            CommandChangeCharState (wfs_die);
         end;
      FM_SAY:
         begin
            if boFighterNpc then exit;
            if SenderInfo.Feature.rfeaturestate = wfs_die then exit;
            if SenderInfo.id = BasicData.id then exit;
            if SenderInfo.Feature.rrace = RACE_NPC then exit;
            str := GetWordString (aSubData.SayString);

            if BuySellSkill <> nil then begin
               if BuySellSkill.ProcessMessage (str, SenderInfo) = true then exit;
            end;
            if DeallerSkill <> nil then begin
               if DeallerSkill.ProcessMessage (str, SenderInfo) = true then exit;
            end;
         end;
   end;
end;

procedure TNpc.Update (CurTick: integer);
begin
//   inherited UpDate (CurTick);
   if boFighterNpc then exit;

   case LifeObjectState of
      los_init :
         begin
            Start;
         end;
      los_die :
         begin
            if CurTick > DiedTick + 1600 then begin
               if Manager.RegenInterval = 0 then begin
                  Regen;
               end else begin
                  FboAllowDelete := true;
               end;
            end;
         end;
      los_none:
         begin
            if SpeechSkill <> nil then SpeechSkill.ProcessMessage (CurTick);
            if AttackSkill <> nil then AttackSkill.ProcessNone (CurTick);
         end;
      los_attack:
         begin
            if AttackSkill <> nil then AttackSkill.ProcessAttack (CurTick, Self);
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

function TNpc.GetAttackSkill : TAttackSkill;
begin
   if AttackSkill = nil then
      AttackSkill := TAttackSkill.Create (Self);
      
   Result := AttackSkill;
end;

procedure TNpc.SetAttackSkill (aAttackSkill : TAttackSkill);
begin
   if (AttackSkill <> nil) and (FboCopy = false) then begin
      AttackSkill.Free;
   end;

   AttackSkill := aAttackSkill;
end;

////////////////////////////////////////////////////
//
//             ===  NpcList  ===
//
////////////////////////////////////////////////////

constructor TNpcList.Create (cnt: integer; aManager: TManager);
begin
   Manager := aManager;
   CurProcessPos := 0;
   AnsList := TAnsList.Create (cnt, AllocFunction, FreeFunction);

   ReLoadFromFile;
end;

destructor TNpcList.Destroy;
begin
   Clear;
   AnsList.Free;
   inherited destroy;
end;

procedure TNpcList.Clear;
var
   i : Integer;
begin
   for i := AnsList.Count - 1 downto 0 do begin
      TNpc (AnsList[i]).EndProcess;
      TNpc (AnsList[i]).SetAttackSkill (nil);
      AnsList.Delete (i);
   end;
end;

procedure TNpcList.ReLoadFromFile;
var
   i, j, iCount, iMapID : integer;
   iName, NpcName : String;
   CreateNpcData : TCreateNpcData;
   NpcData : TNpcData;
   DB : TUserStringDB;
   FileName : String;
begin
   Clear;

   FileName := '.\Setting\CreateNpc' + IntToStr (Manager.ServerID) + '.SDB';

   if not FileExists (FileName) then exit;

   DB := TUserStringDb.Create;
   DB.LoadFromFile (FileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then Continue;

      NpcName := DB.GetFieldValueString (iName, 'NpcName');
      if NpcName = '' then continue;
      NpcClass.GetNpcData (NpcName, @NpcData);
      if NpcData.rName[0] = 0 then continue;
      iCount := DB.GetFieldValueInteger (iName, 'Count');
      if iCount <= 0 then continue;

      CreateNpcData.Name := NpcName;
      CreateNpcData.X := DB.GetFieldValueInteger (iName, 'X');
      CreateNpcData.Y := DB.GetFieldValueInteger (iName, 'Y');
      CreateNpcData.Width := DB.GetFieldValueInteger (iName, 'Width');
      CreateNpcData.BookName := DB.GetFieldValueString (iName, 'BookName');

      for j := 0 to iCount - 1 do begin
         AddNpc (CreateNpcData.Name, CreateNpcData.x, CreateNpcData.y, CreateNpcData.Width, CreateNpcData.BookName);
      end;
   end;
   DB.Free;
end;

function  TNpcList.GetCount: integer;
begin
   Result := AnsList.Count;
end;

function TNpcList.AllocFunction: pointer;
begin
   Result := TNpc.Create;
end;

procedure TNpcList.FreeFunction (item: pointer);
begin
   TNpc (item).Free;
end;

procedure TNpcList.AddNpc (aNpcName: string; ax, ay, aw: integer; aBookName : String);
var
   Npc : TNpc;
begin
   Npc := AnsList.GetUnUsedPointer;
   if Npc <> nil then begin
      Npc.SetManagerClass (Manager);
      Npc.Initial (aNpcName, ax, ay, aw, aBookName);
      AnsList.Add (Npc);
   end;
end;

function TNpcList.CallNpc (aNpcName: string; ax, ay, aw: integer; aName : String) : TNpc;
var
   Npc : TNpc;
   AttackSkill : TAttackSkill;
begin
   Result := nil;
   
   Npc := AnsList.GetUnUsedPointer;
   if Npc <> nil then begin
      Npc.SetManagerClass (Manager);
      Npc.Initial (aNpcName, ax, ay, aw, '');
      Npc.Start;
      AttackSkill := Npc.GetAttackSkill;
      if AttackSkill <> nil then begin
         AttackSkill.SetDeadAttackName (aName);
      end;
      AnsList.Add (Npc);

      Result := Npc;
   end;
end;

procedure TNpcList.Update (CurTick: integer);
var
   i : integer;
   Npc : TNpc;
begin
   for i := 0 to ProcessListCount-1 do begin
      if AnsList.Count = 0 then break;
      if CurProcessPos >= AnsList.Count then CurProcessPos := 0;
      Npc := AnsList[CurProcessPos];
      if Npc.FboAllowDelete = true then begin
         Npc.EndProcess;
         Npc.SetAttackSkill (nil);
         AnsList.Delete (CurProcessPos);
      end else begin
         try
            Npc.Update (CurTick);
            Inc (CurProcessPos);
         except
            Npc.FboAllowDelete := true;
            frmMain.WriteLogInfo (format ('TNpcList.Update (%s) failed', [Npc.NpcName]));
         end;
      end;
   end;
end;

function TNpcList.GetNpcByName (aName : String) : TBasicObject;
var
   i : Integer;
   BO : TBasicObject;
begin
   Result := nil;
   for i := 0 to AnsList.Count - 1 do begin
      BO := AnsList[i];
      if BO <> nil then begin
         if StrPas (@BO.BasicData.Name) = aName then begin
            if BO.BasicData.Feature.rfeaturestate <> wfs_die then begin
               Result := BO;
               exit;
            end;
         end;
      end;
   end;
end;

end.
