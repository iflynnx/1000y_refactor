unit uUsers;

interface

uses
   Classes, SysUtils, mmSystem, uKeyClass, DefType;

type
   TUser = class
   private
      FServerName : String;
      FLoginID : String;
      FCharName : String;
      FIpAddr : String;
      FPaidType : TPaidType;
      FPaidCode : Byte;

      FStartDate : TDateTime;
      FStartTime : TDateTime;
      FStartTick : Integer;

      boAllowDelete : Boolean;
   public
      constructor Create (aServerName, aLoginID, aCharName, aIpAddr : String; aPaidType : TPaidType; aPaidCode : Byte);
      destructor Destroy; override;

      property ServerName : String read FServerName;
      property LoginID : String read FLoginID;
      property CharName : String read FCharName;
      property IpAddr : String read FIpAddr;
      property PaidType : TPaidType read FPaidType;
      property PaidCode : Byte read FPaidCode;
      property StartDate : TDateTime read FStartDate;
      property StartTime : TDateTime read FStartTime;
   end;

   TUserList = class
   private
      DataList : TList;
      LoginIDKey : TStringKeyClass;

      WillBanList : TList;

      function GetCount : Integer;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure ClearByServer (aServerName : String);

      procedure Update (CurTick : Integer);

      function AddUser (aServerName, aLoginID, aCharName, aIpAddr : String; aPaidType : TPaidType; aPaidCode : Byte) : Boolean;
      function DelUser (aLoginID, aCharName : String) : Boolean;

      procedure ARSClose (aLoginID : String);

      property Count : Integer read GetCount;
   end;

var
   UserList : TUserList;

implementation

uses
   FMain, uConnector, uServers, uUseIP;

// TUser
constructor TUser.Create (aServerName, aLoginID, aCharName, aIpAddr : String; aPaidType : TPaidType; aPaidCode : Byte);
begin
   FServerName := aServerName;
   FLoginID := aLoginID;
   FCharName := aCharName;
   FIpAddr := aIpAddr;
   FPaidType := aPaidType;
   FPaidCode := aPaidCode;

   FStartTick := timeGetTime;
   FStartDate := Date;
   FStartTime := Time;

   ServerList.UserIn (aServerName, aLoginID, aCharName, aIpAddr);
   IPList.AddUser (Self);

   boAllowDelete := false;
end;

destructor TUser.Destroy;
begin
   ServerList.UserOut (FServerName, FLoginID, FCharName, FIpAddr);
   IPList.DelUser (Self);

   inherited Destroy;
end;

// TUserList
constructor TUserList.Create;
begin
   DataList := TList.Create;
   WillBanList := TList.Create;
   LoginIDKey := TStringKeyClass.Create;
end;

destructor TUserList.Destroy;
begin
   Clear;
   DataList.Free;
   WillBanList.Free;
   LoginIDKey.Free;

   inherited Destroy;
end;

procedure TUserList.Clear;
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      User.Free;
   end;
   for i := 0 to WillBanList.Count - 1 do begin
      User := WillBanList.Items [i];
      User.Free;
   end;
   WillBanList.Clear;
   DataList.Clear;
   LoginIDKey.Clear;
end;

procedure TUserList.ClearByServer (aServerName : String);
var
   i : Integer;
   User : TUser;
begin
   for i := DataList.Count - 1 downto 0 do begin
      User := DataList.Items [i];
      if User.ServerName = aServerName then begin
         LoginIDKey.Delete (User.LoginID);
         User.Free;
         DataList.Delete (i);
      end;
   end;
   for i := WillBanList.Count - 1 downto 0 do begin
      User := WillBanList.Items [i];
      if User.ServerName = aServerName then begin
         User.Free;
         WillBanList.Delete (i);
      end;
   end;
end;

function TUserList.GetCount : Integer;
begin
   Result := DataList.Count;
end;

function TUserList.AddUser (aServerName, aLoginID, aCharName, aIpAddr : String; aPaidType : TPaidType; aPaidCode : Byte) : Boolean;
var
   nIndex : Integer;
   User : TUser;
   nd : TNoticeData;
begin
   Result := true;

   User := LoginIDKey.Select (aLoginID);
   if User <> nil then begin
      if User.boAllowDelete = false then begin
         AddResult (format ('BAN : %s %s %s', [User.ServerName, User.LoginID, User.CharName]));

         FillChar (nd, SizeOf (TNoticeData), 0);
         nd.rMsg := NGM_REQUESTCLOSE;
         nd.rLoginID := User.LoginID;
         nd.rCharName := User.CharName;

         ConnectorList.AddSendData (User.ServerName, @nd, SizeOf (TNoticeData));

         nIndex := DataList.IndexOf (User);
         if nIndex >= 0 then begin
            LoginIDKey.Delete (aLoginID);
            DataList.Delete (nIndex);
         end;
         WillBanList.Add (User);
      end else begin
         AddResult (format ('FIND : %s %s %s', [User.ServerName, User.LoginID, User.CharName]));
         nIndex := DataList.IndexOf (User);
         if nIndex >= 0 then begin
            User.Free;
            LoginIDKey.Delete (aLoginID);
            DataList.Delete (nIndex);
         end;
      end;
   end;

   User := TUser.Create (aServerName, aLoginID, aCharName, aIpAddr, aPaidType, aPaidCode);
   DataList.Add (User);
   LoginIDKey.Insert (aLoginID, User);
end;

function TUserList.DelUser (aLoginID, aCharName : String) : Boolean;
var
   i : Integer;
   User : TUser;
begin
   Result := true;

   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if (User.LoginID = aLoginID) and (User.CharName = aCharName) then begin
         User.boAllowDelete := true;
         LoginIDKey.Delete (aLoginID);
         exit;
      end;
   end;

   for i := 0 to WillBanList.Count - 1 do begin
      User := WillBanList.Items [i];
      if (User.LoginID = aLoginID) and (User.CharName = aCharName) then begin
         User.boAllowDelete := true;
         exit;
      end;
   end;

   Result := false;
end;

procedure TUserList.ARSClose (aLoginID : String);
var
   nd : TNoticeData;
   i, nIndex : Integer;
   User : TUser;
begin
   for i := 0 to DataList.Count - 1 do begin
      User := DataList.Items [i];
      if User.LoginID = aLoginID then begin
         AddResult (format ('ARS : %s %s %s', [User.ServerName, User.LoginID, User.CharName]));

         FillChar (nd, SizeOf (TNoticeData), 0);
         nd.rMsg := NGM_REQUESTCLOSE;
         nd.rLoginID := User.LoginID;
         nd.rCharName := User.CharName;

         ConnectorList.AddSendData (User.ServerName, @nd, SizeOf (TNoticeData));

         nIndex := DataList.IndexOf (User);
         if nIndex >= 0 then begin
            LoginIDKey.Delete (aLoginID);
            DataList.Delete (nIndex);
         end;
         WillBanList.Add (User);
      end;
   end;
end;

procedure TUserList.Update (CurTick : Integer);
var
   i : Integer;
   nd : TNoticeData;
   User : TUser;
begin
   for i := DataList.Count - 1 downto 0 do begin
      User := DataList.Items [i];
      if User.boAllowDelete = true then begin
         LoginIDKey.Delete (User.LoginID);
         User.Free;
         DataList.Delete (i);
      end;
   end;
   for i := WillBanList.Count - 1 downto 0 do begin
      User := WillBanList.Items [i];
      if User.boAllowDelete = true then begin
         User.Free;
         WillBanList.Delete (i);
      end;
   end;
   for i := 0 to WillBanList.Count - 1 do begin
      User := WillBanList.Items [i];
      FillChar (nd, SizeOf (TNoticeData), 0);
      nd.rMsg := NGM_REQUESTCLOSE;
      nd.rLoginID := User.LoginID;
      nd.rCharName := User.CharName;
      // ConnectorList.AddSendData (User.ServerName, @nd, SizeOf (TNoticeData));
   end;
end;

end.
