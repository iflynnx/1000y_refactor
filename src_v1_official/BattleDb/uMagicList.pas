unit uMagicList;

interface

uses
   Sysutils, Classes, UserSDB;

type
   TMagicData = record
      MainMagic : string [20];
   end;
   PTMagicData = ^TMagicData;

   TMagicList = class
   private
      DataList : TList;
   public
      Constructor Create;
      Destructor Destroy; override;

      procedure LoadFromFile (aFileName : string);
      procedure SaveToSDB (aFileName : string);
      function GetMainMagic (Idx : integer) : string;

   end;
var
   MagicList : TMagicList;

implementation
uses
   FMain;

Constructor TMagicList.Create;
begin
   DataList := TList.Create;
end;

Destructor TMagicList.Destroy;
begin
   SaveToSDB (BattleDBMagicListFile);
   DataList.Free;
   inherited Destroy;
end;

procedure TMagicList.LoadFromFile (aFileName : string);
var
   i : integer;
   str : string;
   DB : TUserStringDB;
   pd : PTMagicData;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);
   for i := 0 to DB.Count-1 do begin
      str := DB.GetIndexString(i);
      New (pd);
      pd^.MainMagic := str;

      DataList.Add (pd);
   end;
   DB.Free;

end;

procedure TMagicList.SaveToSDB (aFileName : string);
var
   i : integer;
   Stream : TFileStream;
   str : string;
   buffer : array [0..4096-1] of Char;
   pd : PTMagicData;
begin
   if FileExists (aFileName) then DeleteFile (aFileName);

   Stream := TFileStream.Create (aFileName, fmCreate);
   str := 'MainMagic';
   StrPCopy (@buffer, str + #13#10);
   Stream.WriteBuffer (buffer, StrLen (@buffer));

   for i := 0 to DataList.Count-1 do begin
      pd := DataList[i];
      str := pd^.MainMagic;
      StrPCopy (@buffer, str + #13#10);
      Stream.WriteBuffer (buffer, StrLen (@buffer));
   end;
   Stream.Free;
end;

function TMagicList.GetMainMagic (Idx : integer) : string;
var
   pd : PTMagicData;
begin
   Result := '';
   if Idx > DataList.Count-1 then exit;
   pd := DataList.Items[Idx];
   Result := pd^.MainMagic;
end;

end.
