unit uBattleDB;

interface

uses
  Windows, SysUtils, Classes, UserSDB, AUtil32, Math, uKeyClass, Common,
  BSCommon, uBDKeyClass, uUserData;

type
   TBattleGroup = record
      Index : Integer;
      Title : String [64];
      StartAge : Integer;
      EndAge : Integer;
      PointKey : TUserDataKeyClass;
   end;
   PTBattleGroup = ^TBattleGroup;

   TBattleDB = class
   private
      DataList : TList;
      GroupList : TList;

      NameKey : TStringKeyClass;
      // PointKey : TUserDataKeyClass;

      function CalPoint (difference : integer; Age : Word; Point : integer; WinFlag : Byte) : integer;
      procedure InsertUserData (aUserData : TUserData; boFlag : Boolean);
      function GetBattleGroupKey (aAge : Integer) : TUserDataKeyClass;
   public
      Constructor Create;
      Destructor Destroy; override;

      procedure Clear;

      procedure AddGroup (aTitle : String; aStart : Integer; aEnd : Integer);
      procedure LoadFromFile (aFileName : String);
      procedure SaveToSDB (aFileName : String);

      function GetRankData (aCharInfo : PTGetRankData; aRankData : PTSendRankData) : Boolean;
      function GetRankPart (aAge, aStart, aEnd : Integer; aRankPart : PTSendRankPart) : Boolean;
      function UpdateRank (aBattleData : PTBattleResultData) : Boolean;

      procedure DisplayCurrentScore;
      procedure Test;
  end;

var
   BattleDB : TBattleDB = nil;

implementation

uses
   FMain, uServerList, uBattleTable;

Constructor TBattleDB.Create;
begin
   GroupList := TList.Create;
   NameKey := TStringKeyClass.Create;
   // PointKey := TUserDataKeyClass.Create;
   DataList := TList.Create;
end;

Destructor TBattleDB.Destroy;
var
   i : Integer;
   pd : PTBattleGroup;
begin
   SaveToSDB (BattleDBFile);

   Clear;
   NameKey.Free;
   // PointKey.Free;
   DataList.Free;

   for i := 0 to GroupList.Count - 1 do begin
      pd := GroupList.Items [i];
      pd^.PointKey.Free;
      Dispose (pd);
   end;
   GroupList.Free;

   inherited Destroy;
end;

procedure TBattleDB.InsertUserData (aUserData : TUserData; boFlag : Boolean);
var
   i : Integer;
   pd : PTBattleGroup;
begin
   for i := 0 to GroupList.Count - 1 do begin
      pd := GroupList.Items [i];
      if (aUserData.Age >= pd^.StartAge) and (aUserData.Age <= pd^.EndAge) then begin
         pd^.PointKey.Insert (aUserData);
         if boFlag = true then pd^.PointKey.SetGrade;
         exit;
      end;
   end;
end;

procedure TBattleDB.Clear;
var
   i : Integer;
   UserData : TUserData;
   pd : PTBattleGroup;
begin
   for i := 0 to GroupList.Count - 1 do begin
      pd := GroupList.Items [i];
      pd^.PointKey.Clear;
   end;
   for i := 0 to DataList.Count - 1 do begin
      UserData := DataList.Items [i];
      UserData.Free;
   end;

   DataList.Clear;
   // PointKey.Clear;
   NameKey.Clear;
end;

procedure TBattleDB.DisplayCurrentScore;
var
   i, j : Integer;
   UserData : TUserData;
   Str : String;
   PointKey : TUserDataKeyClass;
   pd : PTBattleGroup;
begin
   for i := 0 to GroupList.Count - 1 do begin
      pd := GroupList.Items [i];
      PointKey := pd^.PointKey;

      frmMain.ClearResult (pd^.StartAge);

      for j := 0 to PointKey.Count - 1 do begin
         UserData := PointKey.Select (j);
         if UserData <> nil then begin
            Str := format ('%d %s %d %d', [UserData.Grade, UserData.Name, UserData.Point, UserData.Age]);
            frmMain.AddResult (UserData.Age, Str);
         end;
      end;
   end;
end;

procedure TBattleDB.AddGroup (aTitle : String; aStart : Integer; aEnd : Integer);
var
   pd : PTBattleGroup;
begin
   New (pd);
   pd^.Index := GroupList.Count;
   pd^.Title := aTitle;
   pd^.StartAge := aStart;
   pd^.EndAge := aEnd;
   pd^.PointKey := TUserDataKeyClass.Create;

   GroupList.Add (pd);
end;

procedure TBattleDB.LoadFromFile (aFileName : String);
var
   i : Integer;
   iName, KeyName : String;
   DB : TUserStringDB;
   UserData : TUserData;
   pd : PTBattleGroup;
   Str : string;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);
   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      UserData := TUserData.Create;
      UserData.LoadFromSDB (i, DB);

      NameKey.Insert (UserData.Name, UserData);

      InsertUserData (UserData, false);

      DataList.Add (UserData);
   end;
   DB.Free;

   for i := 0 to GroupList.Count - 1 do begin
      pd := GroupList.Items [i];
      pd^.PointKey.SetGrade;
   end;

   DisplayCurrentScore;
end;

procedure TBattleDB.SaveToSDB (aFileName : String);
var
   i : Integer;
   Stream : TFileStream;
   UserData : TUserData;
   Str, iName : String;
   buffer : array [0..4096 - 1] of Char;
   sex : string;
begin
   if FileExists (aFileName) then DeleteFile (aFileName);

   Stream := TFileStream.Create (aFileName, fmCreate);

   Str := 'Name,ServerName,CharName,Age,Sex,MainMagic,Win,Lose,DisConnected,Point,Grade,ServerGrade,MagicGrade,ServerPoint,LastFighterName,FightingCount';
   StrPCopy (@buffer, Str + #13#10);
   Stream.WriteBuffer (buffer, StrLen (@buffer));

   for i := 0 to DataList.Count - 1 do begin
      UserData := DataList.Items [i];
      Str := IntToStr (i + 1) + ',' + UserData.GetDataStr;
      StrPCopy (@buffer, Str + #13#10);
      Stream.WriteBuffer (buffer, StrLen (@buffer));
   end;
   Stream.Free;
end;

function TBattleDB.GetRankData (aCharInfo : PTGetRankData; aRankData : PTSendRankData) : Boolean;
var
   iName : String;
   UserData : TUserData;
begin
   Result := false;

   FillChar (aRankData^, SizeOf (TSendRankData), 0);

   if aCharInfo^.rName = '' then exit;

   iName := aCharInfo^.rServerName + ':' + aCharInfo^.rName;
   UserData := NameKey.Select (iName);
   if UserData = nil then begin
      UserData := TUserData.Create;
      UserData.Name := iName;
      UserData.CharName := aCharInfo^.rName;
      UserData.ServerName := aCharInfo^.rServerName;
      UserData.Age := aCharInfo^.rAge;
      UserData.Sex := aCharInfo^.rSex;
      UserData.Point := 1000;

      NameKey.Insert (iName, UserData);

      InsertUserData (UserData, true);

      DataList.Add (UserData);
   end;

   aRankData^.rCharName := UserData.CharName;
   aRankData^.rServerName := UserData.ServerName;
   aRankData^.rWin := UserData.Win;
   aRankData^.rLose := UserData.Lose;
   aRankData^.rDisConnected := UserData.DisConnected;
   aRankData^.rPoints := UserData.Point;
   aRankData^.rGrade := UserData.Grade;

   Result := true;
end;

function TBattleDB.GetBattleGroupKey (aAge : Integer) : TUserDataKeyClass;
var
   i : Integer;
   pd : PTBattleGroup;
begin
   Result := nil;

   for i := 0 to GroupList.Count - 1 do begin
      pd := GroupList.Items [i];
      if (aAge >= pd^.StartAge) and (aAge <= pd^.EndAge) then begin
         Result := pd^.PointKey;
         exit;
      end;
   end;
end;

function TBattleDB.GetRankPart (aAge, aStart, aEnd : Integer; aRankPart : PTSendRankPart) : Boolean;
var
   i : Integer;
   UserData : TUserData;
   PointKey : TUserDataKeyClass;
   Str : String;
begin
   Result := false;

   PointKey := GetBattleGroupKey (aAge);
   if PointKey = nil then begin
      FillChar (aRankPart^, SizeOf (TSendRankPart), 0);
      aRankPart^.rStart := aStart;
      aRankPart^.rEnd := aStart - 1;
      exit;
   end;

   FillChar (aRankPart^, SizeOf (TSendRankPart), 0);
   aRankPart^.rStart := aStart;
   aRankPart^.rEnd := aEnd;

   frmMain.ClearResult (0);
   for i := aStart to aEnd do begin
      UserData := PointKey.Select (i - 1);
      if UserData = nil then begin
         aRankPart^.rEnd := i - 1;
         break;
      end;

      aRankPart^.rData [i - aStart].rCharName := UserData.CharName;
      aRankPart^.rData [i - aStart].rServerName := UserData.ServerName;
      aRankPart^.rData [i - aStart].rWin := UserData.Win;
      aRankPart^.rData [i - aStart].rLose := UserData.Lose;
      aRankPart^.rData [i - aStart].rDisConnected := UserData.DisConnected;
      aRankPart^.rData [i - aStart].rPoints := UserData.Point;
      aRankPart^.rData [i - aStart].rGrade := UserData.Grade;

      Str := format ('%d %s %d', [UserData.Grade, UserData.CharName, UserData.Point]);
      frmMain.AddResult (0, Str);
   end;
   frmMain.AddResult (0, '----------------------------------------');
   frmMain.lstResult6.Items.Insert (0, format ('RankPart : %d - %d', [aStart, aEnd]));
   
   Result := true;
end;

function TBattleDB.UpdateRank (aBattleData : PTBattleResultData) : Boolean;
var
   Owner, Fighter : TUserData;
   Str, OwnerName, FighterName : String;
   differenceOwner, differenceFighter : integer; //점수차이
   PointKey : TUserDataKeyClass;
begin
   Result := false;

   Str := format ('%s (%d/%d/%d)', [aBattleData^.rOwnerName, aBattleData^.rOwnerWin, aBattleData^.rOwnerLose, aBattleData^.rOwnerDisCon]);
   frmMain.AddLog (Str);
   Str := format ('%s (%d/%d/%d)', [aBattleData^.rFighterName, aBattleData^.rFighterWin, aBattleData^.rFighterLose, aBattleData^.rFighterDisCon]);
   frmMain.AddLog (Str);

   OwnerName := aBattleData^.rOwnerServer + ':' + aBattleData^.rOwnerName;
   FighterName := aBattleData^.rFighterServer + ':' + aBattleData^.rFighterName;

   Owner := NameKey.Select (OwnerName);
   if Owner = nil then exit;
   Fighter := NameKey.Select (FighterName);
   if Fighter = nil then exit;

   if aBattleData^.rFighterName = Owner.LastFighterName then begin
      if Owner.FightingCount >= 3 then begin
         exit;
      end else begin
         Owner.FightingCount := Owner.FightingCount + 1;
      end;
   end else begin
      Owner.LastFighterName := aBattleData^.rFighterName;
      Owner.FightingCount := 1;
   end;

   if aBattleData^.rOwnerName = Fighter.LastFighterName then begin
      if Fighter.FightingCount >= 3 then begin
         exit;
      end else begin
         Fighter.FightingCount := Fighter.FightingCount + 1;
      end;
   end else begin
      Fighter.LastFighterName := aBattleData^.rOwnerName;
      Fighter.FightingCount := 1;
   end;

   differenceOwner := Owner.Point - Fighter.Point;
   differenceFighter := Fighter.Point - Owner.Point;

   if (aBattleData^.rOwnerWin = 0) and (aBattleData^.rOwnerLose = 0) and (aBattleData^.rOwnerDisCon = 0) then exit;
   if (aBattleData^.rFighterWin = 0) and (aBattleData^.rFighterLose = 0) and (aBattleData^.rFighterDiscon = 0) then exit;

   if aBattleData^.rOwnerDisCon > 0 then begin
      Owner.DisConnected := Owner.DisConnected + 1;
      Owner.Point := Owner.Point + CalPoint (differenceOwner, Owner.Age, Owner.Point, 1);
   end else if aBattleData^.rFighterDisCon > 0 then begin
      Fighter.DisConnected := Fighter.DisConnected + 1;
      Fighter.Point := Fighter.Point + CalPoint (differenceFighter, Fighter.Age, Fighter.Point, 1);
   end else if aBattleData^.rOwnerWin - aBattleData^.rFighterWin > 0 then begin
      Owner.Win := Owner.Win + 1;
      Fighter.Lose := Fighter.Lose + 1;
      Owner.Point := Owner.Point + CalPoint (differenceOwner, Owner.Age, Owner.Point, 0);
      Fighter.Point := Fighter.Point + CalPoint (differenceFighter, Fighter.Age, Fighter.Point, 1);

      if CompareStr(aBattleData^.rOwnerServer, aBattleData^.rFighterServer) <> 0 then begin
         if (Owner.ServerGrade >= 50) and (Fighter.ServerGrade >=50) then begin
            ServerList.AddServerPoint (Owner.ServerName);
            ServerList.DelServerPoint (Fighter.ServerName);
            Owner.ServerPoint := Owner.ServerPoint + 1;
            Fighter.ServerPoint := Fighter.ServerPoint - 1;
            if Fighter.ServerPoint < 0 then Fighter.ServerPoint := 0;
         end;
      end;
   end else begin
      Fighter.Win := Fighter.Win + 1;
      Owner.Lose := Owner.Lose + 1;
      Fighter.Point := Fighter.Point + CalPoint (differenceFighter, Fighter.Age, Fighter.Point, 0);
      Owner.Point := Owner.Point + CalPoint (differenceOwner, Owner.Age, Owner.Point, 1);

      if CompareStr(aBattleData^.rOwnerServer, aBattleData^.rFighterServer) <> 0 then begin
         if (Owner.ServerGrade >= 50) and (Fighter.ServerGrade >= 50) then begin
            ServerList.AddServerPoint (Fighter.ServerName);
            ServerList.DelServerPoint (Owner.ServerName);
            Fighter.ServerPoint := Fighter.ServerPoint + 1;
            Owner.ServerPoint := Owner.ServerPoint - 1;
            if Owner.ServerPoint < 0 then Owner.ServerPoint := 0;
         end;
      end;
   end;
   if Owner.Point < 800 then Owner.Point := 800;
   if Fighter.Point < 800 then Fighter.Point := 800;

   PointKey := GetBattleGroupKey (Owner.Age);
   PointKey.Update (Owner);
   PointKey := GetBattleGroupKey (Fighter.Age);
   PointKey.Update (Fighter);

   PointKey.SetGrade;
end;

{
function TBattleDB.CalPoint (difference : integer; BattleRecord : integer; Point : integer; aCalPointFlag : Byte) : integer;
var
   K, A : integer;
   // P 는 내가 이길 확률, 1-P 는 상대편이 이길 확률
   x, P : Extended;
begin
   K := 0;
   x := Power (10, -difference/400 );
   P := 1 / (1+x) * 0.3;

   if BattleRecord < 30 then begin
      if Point >= 2400 then begin
         K := 20;
      end else begin
         K := 50;
      end;
   end;

   if BattleRecord >= 30 then begin
      if Point >= 2400 then begin
         K := 20;
      end else begin
         K := 30;
      end;
   end;


   //이긴 사람에게 더할 값을 리턴
   if aCalPointFlag = 0 then begin
//      if K < 30 then A := round (K * (1 - P)) else A := round (K * (1 + P));
      A := round (K * (1 - P));
//      if A < 1 then A := 1;
      Result := A;
   //진 사람에게서 뺄 값을 리턴
   end else if aCalPointFlag = 1 then begin
      A := round (K * P);
      if A < 1 then A := 1;
      Result := A;
   end;
end;
}

function TBattleDB.CalPoint (difference : integer; Age : Word; Point : integer; WinFlag : Byte) : integer;
begin
   Result := 0;

   case Age of
      7000..9999:
      begin
         case Point of
            0..999 : if WinFlag = 0 then Result := 2 else Result := -1;
            1000..1499 : if WinFlag = 0 then Result := 3 else Result := -2;
            1500..1799: Result := BattleTable.GetDomainData (0, WinFlag, difference);
            1800..2399: Result := BattleTable.GetDomainData (1, WinFlag, difference);
            2400..10000: Result := BattleTable.GetDomainData (2, WinFlag, difference);
         end;
      end;
      6000..6999:
      begin
         case Point of
            0..999: if WinFlag = 0 then Result := 2 else Result := -1;
            1000..1399: if WinFlag = 0 then Result := 3 else Result := -2;
            1400..1799: Result := BattleTable.GetDomainData (0, WinFlag, difference);
            1800..2399: Result := BattleTable.GetDomainData (1, WinFlag, difference);
            2400..10000: Result := BattleTable.GetDomainData (2, WinFlag, difference);
         end;
      end;

      5000..5999:
      begin
         case Point of
            0..999: if WinFlag = 0 then Result := 2 else Result := -1;
            1000..1299: if WinFlag = 0 then Result := 3 else Result := -2;
            1300..1799: Result := BattleTable.GetDomainData (0, WinFlag, difference);
            1800..2399: Result := BattleTable.GetDomainData (1, WinFlag, difference);
            2400..10000: Result := BattleTable.GetDomainData (2, WinFlag, difference);
         end;
      end;

      4000..4999:
      begin
         case Point of
            0..999: if WinFlag = 0 then Result := 2 else Result := -1;
            1000..1199: if WinFlag = 0 then Result := 3 else Result := -2;
            1200..1799: Result := BattleTable.GetDomainData (0, WinFlag, difference);
            1800..2399: Result := BattleTable.GetDomainData (1, WinFlag, difference);
            2400..10000: Result := BattleTable.GetDomainData (2, WinFlag, difference);
         end;
      end;
      3000..3999:
      begin
         case Point of
            0..999: if WinFlag = 0 then Result := 2 else Result := -1;
            1000..1099: if WinFlag = 0 then Result := 3 else Result := -2;
            1100..1799: Result := BattleTable.GetDomainData (0, WinFlag, difference);
            1800..2399: Result := BattleTable.GetDomainData (1, WinFlag, difference);
            2400..10000: Result := BattleTable.GetDomainData (2, WinFlag, difference);
         end;
      end;
      else exit;
   end;
end;

procedure TBattleDB.Test;
var
   str : string;
   Data1, Data2 : TUserData;
   BattleData : TBattleResultData;
   RankData : TGetRankData;
begin
   Data1 := NameKey.Select ('신화:달라요');
   Data2 := NameKey.Select ('생명:귀문권');

   str := Data1.CharName + ',' + inttostr(data1.point);

   FrmMain.lstComment.Items.Add(str);
   FrmMain.lstComment.Items.Add('---------------------------------------');

   str := Data2.CharName + ',' + inttostr(data2.point);

   FrmMain.lstComment.Items.Add(str);

   BattleData.rOwnerName := Data1.CharName;
   BattleData.rOwnerServer := Data1.ServerName;
   BattleData.rFighterName := Data2.CharName;
   BattleData.rFighterServer:= Data2.ServerName;
   BattleData.rOwnerWin := 2;
   BattleData.rOwnerLose := 1;
   BattleData.rOwnerDisCon := 0;
   BattleData.rFighterWin := 1;
   BattleData.rFighterLose := 2;
   BattleData.rFighterDisCon :=0;

   UpdateRank (@BattleData);
end;

end.
