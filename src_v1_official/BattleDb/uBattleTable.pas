unit uBattleTable;

interface

uses
   Sysutils, Classes, UserSDB, AUtil32;

const
   MAXDOMAINCOUNT = 40;

type
   TTableData = record
      Difference : integer;
      WinFirstDomain : word;
      LoseFirstDomain : word;
      WinSecondDomain : word;
      LoseSecondDomain : word;
      WinThirdDomain : word;
      LoseThirdDomain : word;
   end;
   PTTableData = ^TTableData;

   TBattleTable = class
   private
      DataList : TList;
   public
      Constructor Create;
      Destructor Destroy; override;

      procedure LoadFromFile (aFileName : string);
      procedure SaveToSDB (aFileName : string);
      function GetDomainData (aDomain : Byte; aWinFlag : Byte; adifference : integer) : integer;
   end;

var
   BattleTable : TBattleTable;

implementation
uses
   FMain;

Constructor TBattleTable.Create;
begin
   DataList := TList.Create;
end;

Destructor TBattleTable.Destroy;
begin
   SaveToSDB (BattleDBCalTableFile);
   DataList.Free;
   inherited Destroy;
end;

procedure TBattleTable.LoadFromFile (aFileName : string);
var
   i : integer;
   iName, str : string;
   DB : TUserStringDB;
   pd : PTTableData;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);
   for i := 0 to DB.Count-1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      New (pd);
      pd^.Difference := DB.GetFieldValueInteger (iName, 'Difference');
      pd^.WinFirstDomain := DB.GetFieldValueInteger (iName, 'WinFirstDomain');
      pd^.LoseFirstDomain := DB.GetFieldValueInteger (iName, 'LoseFirstDomain');
      pd^.WinSecondDomain := DB.GetFieldValueInteger (iName, 'WinSecondDomain');
      pd^.LoseSecondDomain := DB.GetFieldValueInteger (iName, 'LoseSecondDomain');
      pd^.WinThirdDomain := DB.GetFieldValueInteger (iName, 'WinThirdDomain');
      pd^.LoseThirdDomain := DB.GetFieldValueInteger (iName, 'LoseThirdDomain');

      DataList.Add (pd);
   end;
   DB.Free;

end;

procedure TBattleTable.SaveToSDB (aFileName : string);
var
   i : integer;
   Stream : TFileStream;
   str : string;
   buffer : array [0..4096-1] of Char;
   pd : PTTableData;
begin
   if FileExists (aFileName) then DeleteFile (aFileName);

   Stream := TFileStream.Create (aFileName, fmCreate);
   str := 'Name,Difference,WinFirstDomain,LoseFirstDomain,WinSecondDomain,LoseSecondDomain,WinThirdDomain,LoseThirdDomain,';
   StrPCopy (@buffer, str + #13#10);
   Stream.WriteBuffer (buffer, StrLen (@buffer));

   for i := 0 to DataList.Count-1 do begin
      pd := DataList[i];
      str := IntToStr (i + 1) + IntToStr(pd^.Difference) + IntToStr(pd^.WinFirstDomain) + IntToStr(pd^.LoseFirstDomain) + IntToStr(pd^.WinSecondDomain) + IntToStr(pd^.LoseSecondDomain) + IntToStr(pd^.WinThirdDomain) + IntToStr(pd^.LoseThirdDomain);
      StrPCopy (@buffer, str + #13#10);
      Stream.WriteBuffer (buffer, StrLen (@buffer));
   end;
   Stream.Free;
end;

function TBattleTable.GetDomainData (aDomain : Byte; aWinFlag : Byte; adifference : integer) : integer;
var
   i, idx : integer;
   WinFirstDomain : array [0..MAXDOMAINCOUNT-1] of Integer;
   LoseFirstDomain : array [0..MAXDOMAINCOUNT-1] of Integer;
   WinSecondDomain : array [0..MAXDOMAINCOUNT-1] of Integer;
   LoseSecondDomain : array [0..MAXDOMAINCOUNT-1] of Integer;
   WinThirdDomain : array [0..MAXDOMAINCOUNT-1] of Integer;
   LoseThirdDomain : array [0..MAXDOMAINCOUNT-1] of Integer;
   pd : PTTableData;
begin
   Result := 0;

   for i := 0 to MAXDOMAINCOUNT-1 do begin
      WinFirstDomain[i] := 0;
      LoseFirstDomain[i] := 0;
      WinSecondDomain[i] := 0;
      LoseSecondDomain[i] := 0;
      WinThirdDomain[i] := 0;
      LoseThirdDomain[i] := 0;
   end;

   for i := 0 to DataList.Count -1 do begin
      pd := DataList.Items[i];

      WinFirstDomain[i] := pd^.WinFirstDomain;
      LoseFirstDomain[i] := pd^.LoseFirstDomain;
      WinSecondDomain[i] := pd^.WinSecondDomain;
      LoseSecondDomain[i] := pd^.LoseSecondDomain;
      WinThirdDomain[i] := pd^.WinThirdDomain;
      LoseThirdDomain[i] := pd^.LoseThirdDomain;
   end;

   if (adifference >= 400) and (adifference < 800)  then idx := 0;
   if (adifference >= 300) and (adifference < 400) then idx := 1;
   if (adifference >= 200) and (adifference < 300) then idx := 2;
   if (adifference >= 100) and (adifference < 200) then idx := 3;
   if (adifference >= 0) and (adifference < 100) then idx := 4;
   if (adifference > -100) and (adifference < 0) then idx := 4;
   if (adifference > -200) and (adifference <= -100) then idx := 5;
   if (adifference > -300) and (adifference <= -200) then idx := 6;
   if (adifference > -400) and (adifference <= -300) then idx := 7;
   if (adifference > -800) and (adifference <= -400) then idx := 8;

   if aDomain = 0 then begin
      if aWinFlag = 0 then Result := WinFirstDomain[idx] else Result := -LoseFirstDomain[idx];
   end;

   if aDomain = 1 then begin
      if aWinFlag = 0 then Result := WinSecondDomain[idx] else Result := -LoseSecondDomain[idx];
   end;

   if aDomain = 2 then begin
      if aWinFlag = 0 then Result := WinThirdDomain[idx] else Result := -LoseThirdDomain[idx];
   end;

end;

end.
