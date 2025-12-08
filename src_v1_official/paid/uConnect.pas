unit uConnect;

interface

uses
   Classes, SysUtils, ScktComp, uPackets, DefType;

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

      procedure MessageProcess (aPacket : PTPacketData);

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
   FMain, uPaidDB;

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
var
   cn : Integer;
   pPaidData : PTPaidData;
   PaidData : TPaidData;
   NamePay : TNamePay;
   IPPay : TIPPay;
begin
   Case aPacket^.RequestMsg of
      PM_CHECKPAID :
         begin
            pPaidData := PTPaidData (@aPacket^.Data);
            Move (pPaidData^, PaidData, SizeOf (TPaidData));
            
            NamePay := PaidDB.GetRemainName (pPaidData^.rLoginID);
            if NamePay <> nil then begin
               PaidData.rRemainDay := NamePay.RemainDay;
               PaidData.rPaidType := pt_namemoney;
               PaidData.rCode := NamePay.Code;
               AddInfo (format ('%s (%d)', [NamePay.LoginID, NamePay.RemainDay]));
            end else begin
               IPPay := PaidDB.GetRemainIP (pPaidData^.rIPAddr);
               if IPPay <> nil then begin
                  PaidData.rRemainDay := IPPay.RemainDay;
                  PaidData.rPaidType := pt_ipmoney;
                  PaidData.rCode := IPPay.Code;
                  AddInfo (format ('%s (%d)', [IPPay.IpAddr, IPPay.RemainDay]));
               end else begin
                  PaidData.rRemainDay := 0;
                  PaidData.rPaidType := pt_invalidate;
                  PaidData.rCode := 0;
               end;
            end;

            if PaidData.rRemainDay = 0 then begin
               cn := 0;
               if PaidData.rMakeDate <> '' then begin
                  try
                     cn := 4 - Round (Date - StrToDate (PaidData.rMakeDate));
                  except
                     cn := 0;
                  end;
               end;
               if (cn <= 4) and (cn > 0) then begin
                  PaidData.rRemainDay := cn;
                  PaidData.rPaidType := pt_test;
               end;
            end;
            if frmMain.CheckBox1.Checked = true then begin
               Sender.PutPacket (aPacket^.RequestID, aPacket^.RequestMsg, 1, @PaidData, SizeOf (TPaidData));
            end else begin
               Sender.PutPacket (aPacket^.RequestID, aPacket^.RequestMsg, 0, @PaidData, SizeOf (TPaidData));
            end;
         end;
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
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.Socket = aSocket then begin
         Connector.AddReceiveData (aData, aCount);
         exit;
      end;
   end;
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
