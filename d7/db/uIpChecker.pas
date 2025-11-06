unit uIpChecker;

interface

uses SysUtils, Classes, UserSDB;

type
   TIPChecker = class
   private
      FIPList : TStringList;
   public
      Enabled :Boolean;
      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      procedure LoadFromFile;
      function IsThereAtList (aIp : String) : Boolean;
      procedure SaveToFile (str : String);
   end;

   TRemoteUser = class
   private
      Name : String;
      Password : String;
   public
      constructor Create;
      destructor Destroy; override;
   end;

   TRemoteUserList = class
   private
      DataList : TList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure LoadFromFile;
      procedure Clear;

      function FindRemoteUser (aName, aPW : String) : Boolean;
   end;

var
   IPChecker : TIPChecker = nil;
   RemoteUserList : TRemoteUserList = nil;

implementation

constructor TIPChecker.Create;
begin
   Enabled := true;
   FIPList := TStringList.Create;
   LoadFromFile;
end;

destructor TIPChecker.Destroy;
begin
   FIPList.Clear;
   FIPList.Free;
end;

procedure TIPChecker.Clear;
begin
   FIPList.Clear;
end;

procedure TIPChecker.LoadFromFile;
var
   i, j : Integer;
   iName : String;
   //IPListSDB : TUserStringDB;
   aFileName, str : String;
begin
   aFileName := 'IPList.txt';
   if not FileExists (aFileName) then begin
      Enabled := false;
      exit;
   end;
   
   FIPList.LoadFromFile (aFileName);
end;

function TIPChecker.IsThereAtList (aIp : String) : Boolean;
var
   i : integer;
   str : String;
   nCount : Integer;
begin
   Result := false;
   if Enabled = false then begin
      Result := true;
      exit;
   end;
   
   nCount := FIPList.Count;

   for i := 0 to nCount - 1 do begin
      SaveToFile (IntToStr (i));
      Str := FIPList.Strings[i];
      if Str = aIp then begin
         Result := true;
         exit;
      end;
   end;
   
end;

procedure TIPChecker.SaveToFile (str : String);
var
   Stream : TFileStream;
   tmpFileName : String;
   szBuf : array[0..1024] of Byte;
begin
   try
      StrPCopy(@szBuf, '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + '] ' + Str + #13#10);
      tmpFileName := 'IPCheck.LOG';
      if FileExists (tmpFileName) then
         Stream := TFileStream.Create (tmpFileName, fmOpenReadWrite)
      else
         Stream := TFileStream.Create (tmpFileName, fmCreate);

      Stream.Seek(0, soFromEnd);
      Stream.WriteBuffer (szBuf, StrLen(@szBuf));
      Stream.Destroy;
   except
   end;
end;

// TRemoteUserData;
constructor TRemoteUser.Create;
begin
   Name := '';
   Password := '';
end;

destructor TRemoteUser.Destroy;
begin
   inherited Destroy;
end;

// TRemoteUser;
constructor TRemoteUserList.Create;
begin
   DataList := TList.Create;
   LoadFromFile;
end;

destructor TRemoteUserList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

procedure TRemoteUserList.Clear;
var
   i : Integer;
   RData : TRemoteUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      RData := DataList.Items [i];
      RData.Free;
   end;
   DataList.Clear;
end;

procedure TRemoteUserList.LoadFromFile;
var
   FileName, iName : String;
   DB : TUserStringDB;
   i : Integer;
   RData : TRemoteUser;
begin
   FileName := '.\RemoteUser.SDB';

   if not FileExists (FileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (FileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName(i);
      if iName = '' then continue;

      RData := TRemoteUser.Create;
      RData.Name := DB.GetFieldValueString (iName, 'Name');
      RData.Password := DB.GetFieldValueString (iName, 'PassWord');

      DataList.Add (RData);
   end;

   DB.Free;
end;

function TRemoteUserList.FindRemoteUser (aName, aPW : String) : Boolean;
var
   i : Integer;
   RData : TRemoteUser;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do begin
      RData := DataList.Items [i];
      if RData.Name = aName then begin
         if RData.Password = aPW then begin
            Result := true;
            exit;
         end;
      end;
   end;
end;


Initialization
begin
   IPChecker := TIPChecker.Create;
   RemoteUserList := TRemoteUserList.Create;
end;

Finalization
begin
   RemoteUserList.Free;
   IPChecker.Free;
end;

end.
