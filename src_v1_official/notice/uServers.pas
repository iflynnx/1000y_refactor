unit uServers;

interface

uses
   Classes, SysUtils;

type

   TServer = class
   private
      FName : String;
      FIpAddr : String;
      FUserCount : Integer;
   public
      constructor Create (aName, aIpAddr : String);
      destructor Destroy; override;

      property Name : String read FName;
      property IpAddr : String read FIpAddr;
      property UserCount : Integer read FUserCount write FUserCount;
   end;

   TServerList = class
   private
      DataList : TList;

      function GetServer (Index : Integer) : TServer;
      function GetCount : Integer;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      function AddServer (aName, aIpAddr : String) : Boolean;
      function DelServer (aName : String) : Boolean;
      function SelServer (aName : String) : TServer;
      function GetServerName (aIpAddr : String) : String;

      procedure UserIn (aServerName, aLoginID, aCharName, aIpAddr : String);
      procedure UserOut (aServerName, aLoginID, aCharName, aIpAddr : String);

      property Count : Integer read GetCount;
      property Items [Index : Integer] : TServer read GetServer;
   end;

var
   ServerList : TServerList = nil;

implementation

constructor TServer.Create (aName, aIpAddr : String);
begin
   FName := aName;
   FIpAddr := aIpAddr;
end;

destructor TServer.Destroy;
begin
   inherited Destroy;
end;

constructor TServerList.Create;
begin
   DataList := TList.Create;
end;

destructor TServerList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

procedure TServerList.Clear;
var
   i : Integer;
   Server : TServer;
begin
   for i := 0 to DataList.Count - 1 do begin
      Server := DataList.Items [i];
      Server.Free;
   end;
   DataList.Clear;
end;

function TServerList.GetServer (Index : Integer) : TServer;
begin
   Result := DataList.Items [Index];
end;

function TServerList.GetCount : Integer;
begin
   Result := DataList.Count;
end;

function TServerList.AddServer (aName, aIpAddr : String) : Boolean;
var
   Server : TServer;
begin
   Result := false;

   Server := TServer.Create (aName, aIpAddr);
   DataList.Add (Server);

   Result := true;
end;

function TServerList.DelServer (aName : String) : Boolean;
var
   i : Integer;
   Server : TServer;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do begin
      Server := DataList.Items [i];
      if Server.Name = aName then begin
         Server.Free;
         DataList.Delete (i);
         Result := true;
         exit;
      end;
   end;
end;

function TServerList.SelServer (aName : String) : TServer;
var
   i : Integer;
   Server : TServer;
begin
   Result := nil;

   for i := 0 to DataList.Count - 1 do begin
      Server := DataList.Items [i];
      if Server.Name = aName then begin
         Result := Server;
         exit;
      end;
   end;
end;

function TServerList.GetServerName (aIpAddr : String) : String;
var
   i : Integer;
   Server : TServer;
begin
   Result := '';

   for i := 0 to DataList.Count - 1 do begin
      Server := DataList.Items [i];
      if Server.IpAddr = aIpAddr then begin
         Result := Server.Name;
         exit;
      end;
   end;
end;

procedure TServerList.UserIn (aServerName, aLoginID, aCharName, aIpAddr : String);
var
   i : Integer;
   Server : TServer;
begin
   for i := 0 to DataList.Count - 1 do begin
      Server := DataList.Items [i];
      if Server.Name = aServerName then begin
         Server.FUserCount := Server.FUserCount + 1;
         exit;
      end;
   end;
end;

procedure TServerList.UserOut (aServerName, aLoginID, aCharName, aIpAddr : String);
var
   i : Integer;
   Server : TServer;
begin
   for i := 0 to DataList.Count - 1 do begin
      Server := DataList.Items [i];
      if Server.Name = aServerName then begin
         Server.FUserCount := Server.FUserCount - 1;
         exit;
      end;
   end;
end;

end.
