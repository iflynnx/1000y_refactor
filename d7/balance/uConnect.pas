unit uConnect;

interface

uses
   Windows, Classes, SysUtils, ScktComp, mmSystem;

type
   TConnector = class
   private
      Socket : TCustomWinSocket;
      CreateTime : Integer;
   protected
   public
      constructor Create (aSocket : TCustomWinSocket);
      destructor Destroy; override;
   end;

   TConnectorList = class
   private
      DataList : TList;

      function GetCount : Integer;
   protected
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      function Update (CurTick : Integer) : Boolean;

      function CreateConnect (aSocket : TCustomWinSocket) : Boolean;
      function DeleteConnect (aSocket : TCustomWinSocket) : String;

      property Count : Integer read GetCount;
   end;

var
   ConnectorList : TConnectorList;

implementation

// TConnector
constructor TConnector.Create (aSocket : TCustomWinSocket);
begin
   Socket := aSocket;
   CreateTime := timeGetTime;
end;

destructor TConnector.Destroy;
begin
   inherited Destroy;
end;

// TConnectorList
constructor TConnectorList.Create;
begin
   DataList := TList.Create;
end;

destructor TConnectorList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

procedure TConnectorList.Clear;
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      Connector.Free;
   end;
   DataList.Clear;
end;

function TConnectorList.GetCount : Integer;
begin
   Result := DataList.Count;
end;


function TConnectorList.CreateConnect (aSocket : TCustomWinSocket) : Boolean;
var
   Connector : TConnector;
begin
   Result := false;

   Connector := TConnector.Create (aSocket);
   DataList.Add (Connector);

   Result := true;
end;

function TConnectorList.DeleteConnect (aSocket :  TCustomWinSocket) : String;
var
   i : Integer;
   Connector : TConnector;
begin
   Result := '';

   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.Socket = aSocket then begin
         Connector.Free;
         DataList.Delete (i);
         exit;
      end;
   end;
end;

function TConnectorList.Update (CurTick : Integer) : Boolean;
var
   i : Integer;
   Connector : TConnector;
begin
   for i := DataList.Count - 1 downto 0 do begin
      Connector := DataList.Items [i];
      if CurTick >= Connector.CreateTime + 10000 then begin
         Connector.Socket.Close;
      end;
   end;

   Result := true;
end;

initialization
begin
   ConnectorList := TConnectorList.Create;
end;

finalization
begin
   ConnectorList.Free;
end;

end.
