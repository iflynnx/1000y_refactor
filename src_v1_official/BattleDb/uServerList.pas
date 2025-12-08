unit uServerList;

interface

uses
   Sysutils, Classes, UserSDB, AUtil32;

type
   TServerData = record
      ServerName : string[20];
      ServerPoint : Integer;
   end;
   PTServerData = ^TServerData;

   TServerList = class
   private
      DataList : TList;
   public
      Constructor Create;
      Destructor Destroy; override;

      procedure LoadFromFile (aFileName : string);
      procedure SaveToSDB (aFileName : string);
      function GetServerName (Idx : integer) : string;
      procedure AddServerPoint (aServerName : string);
      procedure DelServerPoint (aServerName : string);
   end;

var
   ServerList : TServerList;

implementation
uses
   FMain;

Constructor TServerList.Create;
begin
   DataList := TList.Create;
end;

Destructor TServerList.Destroy;
begin
   SaveToSDB (BattleDBServerListFile);
   DataList.Free;
   inherited Destroy;
end;

procedure TServerList.LoadFromFile (aFileName : string);
var
   i : integer;
   str, rdstr : string;
   DB : TUserStringDB;
   pd : PTServerData;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);
   for i := 0 to DB.Count-1 do begin
      str := DB.GetIndexString(i);
      New (pd);
      str := GetValidStr3 (str, rdstr, ',');
      pd^.ServerName := rdstr;
      str := GetValidStr3 (str, rdstr, ',');
      pd^.ServerPoint := StrToInt(rdstr);

      DataList.Add (pd);
   end;
   DB.Free;

end;

procedure TServerList.SaveToSDB (aFileName : string);
var
   i : integer;
   Stream : TFileStream;
   str : string;
   buffer : array [0..4096-1] of Char;
   pd : PTServerData;
begin
   if FileExists (aFileName) then DeleteFile (aFileName);

   Stream := TFileStream.Create (aFileName, fmCreate);
   str := 'ServerName, ServerPoint';
   StrPCopy (@buffer, str + #13#10);
   Stream.WriteBuffer (buffer, StrLen (@buffer));

   for i := 0 to DataList.Count-1 do begin
      pd := DataList[i];
      str := pd^.ServerName + ',' + IntToStr(pd^.ServerPoint);
      StrPCopy (@buffer, str + #13#10);
      Stream.WriteBuffer (buffer, StrLen (@buffer));
   end;
   Stream.Free;
end;

function TServerList.GetServerName (Idx : integer) : string;
var
   pd : PTServerData;
begin
   Result := '';
   if Idx > DataList.Count-1 then exit;
   pd := DataList.Items[Idx];
   Result := pd^.ServerName;
end;

procedure TServerList.AddServerPoint (aServerName : string);
var
   i : integer;
   pd : PTServerData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items[i];
      if aServerName = pd^.ServerName then begin
         pd^.ServerPoint := pd^.ServerPoint + BattleDBServerPoint;
         exit;
      end;
   end;
end;

procedure TServerList.DelServerPoint (aServerName : string);
var
   i : integer;
   pd : PTServerData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items[i];
      if aServerName = pd^.ServerName then begin
         pd^.ServerPoint := pd^.ServerPoint - BattleDBServerPoint;
         if pd^.ServerPoint < 0 then pd^.ServerPoint := 0;
         exit;
      end;
   end;
end;

end.
