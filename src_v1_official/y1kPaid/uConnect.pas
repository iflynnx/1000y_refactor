unit uConnect;

interface

uses
   Classes, SysUtils, ScktComp, uPackets;

type
   TConnector = class
   private
      Socket : TCustomWinSocket;
      IpAddr : String;

      Sender : TPacketSender;
      Receiver : TPacketReceiver;
   public
      constructor Create (aSocket : TCustomWinSocket);
      destructor Destroy; override;

      procedure Update;

      procedure AddReceiveData (aData : PChar; aCount : Integer);

      procedure SetWriteAllow;
   end;

   TConnectorList = class
   private
      DataList : TList;
      function GetCount : Integer;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure Update;

      function CreateConnect (aSocket : TCustomWinSocket) : Boolean;
      function DeleteConnect (aSocket : TCustomWinSocket) : Boolean;

      procedure AddReceiveData (aSocket : TCustomWinSocket; aData : PChar; aCount : Integer);

      procedure SetWriteAllow (aSocket : TCustomWinSocket);

      property Count : Integer read GetCount;
   end;

var
   ConnectorList : TConnectorList;

implementation

uses
   FMain;

constructor TConnector.Create (aSocket : TCustomWinSocket);
begin
   Socket := aSocket;
   IpAddr := aSocket.RemoteAddress;

   Sender := TPacketSender.Create ('Sender', BufferSizeS2S, aSocket);
   Receiver := TPacketReceiver.Create ('Receiver', BufferSizeS2S);
end;

destructor TConnector.Destroy;
begin
   Sender.Free;
   Receiver.Free;
end;

procedure TConnector.Update;
var
   Packet : TPacketData;
begin
   Receiver.Update;
   while Receiver.Count > 0 do begin
      if Receiver.GetPacket (@Packet) = false then break;
      MessageProcess (@Packet);
   end;
   Sender.Update;
end;

procedure TConnector.MessageProcess (aPacket : PTPacketData);
begin
   Case aPacket^.Msg of

   end;
end;

procedure TConnector.AddReceiveData (aData : PChar; aCount : Integer);
begin
   Receiver.PutData (aData, aCount);
end;

procedure TConnector.SetWriteAllow;
begin
   Sender.WriteAllow := true;
end;

constructor TConnectorList.Create;
begin
   DataList := TList.Create;
end;

destructor TConnectorList.Destroy;
begin
   Clear;
   DataList.Free;
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

procedure TConnectorList.Update;
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      Connector.Update;
   end;
end;

function TConnectorList.CreateConnect (aSocket : TCustomWinSocket) : Boolean;
var
   Connector : TConnector;
begin
   Connector := TConnector.Create (aSocket);
   DataList.Add (Connector);
end;

function TConnectorList.DeleteConnect (aSocket : TCustomWinSocket) : Boolean;
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.Socket = aSocket then begin
         Connector.Free;
         DataList.Delete (i);
         exit;
      end;
   end;
end;

procedure TConnectorList.AddReceiveData (aSocket : TCustomWinSocket; aData : PChar; aCount : Integer);
begin

end;

procedure TConnectorList.SetWriteAllow (aSocket : TCustomWinSocket);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.Socket = aSocket then begin
         Connector.SetWriteAllow;
      end;
   end;
end;

end.
