unit uGateConnector;

interface

uses
   Classes, SysUtils, ScktComp, uPackets, DefType, mmSystem;

type
   TGateConnector = class
   private
      Socket : TCustomWinSocket;
      Receiver : TPacketReceiver;
   protected
   public
      constructor Create (aSocket : TCustomWinSocket);
      destructor Destroy; override;

      procedure AddReceiveData (aData : PChar; aSize : Integer);

      procedure Update (CurTick : Integer);
      procedure MessageProcess (var aPacket : TPacketData);
   end;

   TGateConnectorList = class
   private
      DataList : TList;

      function GetCount : Integer;
   protected
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      function Update (CurTick : Integer) : Boolean;

      function CreateConnector (aSocket : TCustomWinSocket) : Boolean;
      function DeleteConnector (aSocket : TCustomWinSocket) : Boolean;

      procedure AddReceiveData (aSocket : TCustomWinSocket; aData : PChar; aSize : Integer);

      property Count : Integer read GetCount;
   end;

var
   GateConnectorList : TGateConnectorList;

implementation

uses
   FMain;

// TGateConnector
constructor TGateConnector.Create (aSocket : TCustomWinSocket);
begin
   Socket := aSocket;
   Receiver := TPacketReceiver.Create ('', 16384, true);
end;

destructor TGateConnector.Destroy;
begin
   Receiver.Free;
   inherited Destroy;
end;

procedure TGateConnector.AddReceiveData (aData : PChar; aSize : Integer);
begin
   Receiver.PutData (aData, aSize);
end;

procedure TGateConnector.Update (CurTick : Integer);
var
   Packet : TPacketData;
begin
   Receiver.Update;
   while Receiver.Count > 0 do begin
      if Receiver.GetPacket (@Packet) = false then break;
      MessageProcess (Packet);
   end;
end;

procedure TGateConnector.MessageProcess (var aPacket : TPacketData);
var
   i, cnt : Integer;
   pd : PTBalanceData;
begin
   pd := @aPacket.Data;
   Case pd^.rMsg of
      BM_GATEINFO :
         begin
            for i := 0 to MAX_AVAILABLE_GATE - 1 do begin
               if GateInfo[i].boAvail = true then begin
                  if pd^.rIpAddr = GateInfo[i].RemoteIP then begin
                     if pd^.rPort = GateInfo[i].RemotePort then begin
                        GateInfo[i].UserCount := pd^.rUserCount;
                        GateInfo[i].ReceiveTick := timeGetTime;

                        frmMain.DrawStatus (i);
                        exit;
                     end;
                  end;
               end;
            end;

            for i := 0 to MAX_AVAILABLE_GATE - 1 do begin
               if GateInfo[i].boAvail = false then begin
                  GateInfo[i].boAvail := true;
                  GateInfo[i].RemoteIP := StrPas (@pd^.rIpAddr);
                  GateInfo[i].RemotePort := pd^.rPort;
                  GateInfo[i].UserCount := pd^.rUserCount;
                  GateInfo[i].ReceiveTick := timeGetTime;

                  frmMain.DrawStatus (i);
                  exit;
               end;
            end;
         end;
   end;
end;

// TGateConnectorList
constructor TGateConnectorList.Create;
begin
   DataList := TList.Create;
end;

destructor TGateConnectorList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

procedure TGateConnectorList.Clear;
var
   i : Integer;
   Connector : TGateConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      Connector.Free;
   end;
   DataList.Clear;
end;

function TGateConnectorList.GetCount : Integer;
begin
   Result := DataList.Count;
end;


function TGateConnectorList.CreateConnector (aSocket : TCustomWinSocket) : Boolean;
var
   Connector : TGateConnector;
begin
   Result := false;

   Connector := TGateConnector.Create (aSocket);
   DataList.Add (Connector);

   Result := true;
end;

function TGateConnectorList.DeleteConnector (aSocket :  TCustomWinSocket) : Boolean;
var
   i : Integer;
   Connector : TGateConnector;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.Socket = aSocket then begin
         Connector.Free;
         DataList.Delete (i);
         Result := true;
         exit;
      end;
   end;
end;

procedure TGateConnectorList.AddReceiveData (aSocket : TCustomWinSocket; aData : PChar; aSize : Integer);
var
   i : Integer;
   Connector : TGateConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.Socket = aSocket then begin
         Connector.AddReceiveData (aData, aSize);
         exit;
      end;
   end;
end;

function TGateConnectorList.Update (CurTick : Integer) : Boolean;
var
   i : Integer;
   Connector : TGateConnector;
begin
   for i := DataList.Count - 1 downto 0 do begin
      Connector := DataList.Items [i];
      Connector.Update (CurTick);
   end;

   Result := true;
end;

initialization
begin
   GateConnectorList := TGateConnectorList.Create;
end;

finalization
begin
   GateConnectorList.Free;
end;

end.

