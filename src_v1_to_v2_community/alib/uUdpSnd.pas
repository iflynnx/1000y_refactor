unit uUdpSnd;

interface

uses
  Windows, SysUtils, Classes, autil32, NMUDP, AnsUnit, adeftype, BarUtil;


type
  TUSendData = record    // 200 이하일경우는 그냥 이상일땐 할당.
    Ip: string[32];
    Port: integer;
    datasize : integer;
    pDefaultBuf: pbyte;
    pExtraBuf: pbyte;
  end;
  PTUSendData = ^TUSendData;

  TUdpSendClass = class
    private
     DefaultBufferSize : integer;
     nUpdatePerSend : integer;
     Udp : TNMUDP;
     AnsList : TAnsList;
     function  AllocFunction: pointer;
     procedure FreeFunction (item: pointer);
    public
     constructor Create (aDefaultBufferSize: integer);
     destructor destroy; override;
     procedure  AddUdpData (aip: string; aport: integer; cnt: integer; pb: pbyte);
     procedure  SetUnUsedAndSend (aUnUsed, aSend: integer);
     procedure  Clear;
     procedure  UpDate;
  end;


implementation


constructor TUdpSendClass.Create (aDefaultBufferSize: integer);
begin
   DefaultBufferSize := aDefaultBufferSize;
   Udp := TNMUDP.Create(nil);
   AnsList := TAnsList.Create (10, AllocFunction, FreeFunction);
   AnsList.MaxUnUsedCount := 100;
   nUpdatePerSend := 1;
end;

destructor TUdpSendClass.destroy;
begin
   Clear;
   AnsList.Free;
   inherited destroy;
end;

procedure  TUdpSendClass.SetUnUsedAndSend (aUnUsed, aSend: integer);
begin
   AnsList.MaxUnUsedCount := aUnUsed;
   nUpdatePerSend := aSend;
end;

function  TUdpSendClass.AllocFunction: pointer;
var p : PTUSendData;
begin
   new (p);
   FillChar (p^, sizeof(TUSendData), 0);
   GetMem (p^.pDefaultBuf, DefaultBufferSize+1);     // 여휴로 +1
   Result := p;
end;

procedure TUdpSendClass.FreeFunction (item: pointer);
begin
   FreeMem (PTUSendData (item)^.pDefaultBuf);
   dispose (item);
end;

procedure TUdpSendClass.Clear;
var
   i: integer;
   p : PTUSendData;
begin
   for i := AnsList.Count -1 downto 0 do begin
      p := AnsList[i];
      if p.datasize > DefaultBufferSize then FreeMem (p.pExtraBuf);

      p^.Ip := '';
      p^.Port := 0;
      p^.datasize := 0;
      FillChar (p^.pDefaultBuf^, DefaultBufferSize, 0);
      p^.pExtraBuf := nil;
      AnsList.Delete (i);
   end;
end;

procedure  TUdpSendClass.AddUdpData (aip: string; aport: integer; cnt: integer; pb: pbyte);
var
   p : PTUSendData;
begin
   p := AnsList.GetUnUsedPointer;
   p^.ip := aip;
   p^.port := aport;
   p^.datasize := cnt;
   if cnt > DefaultBufferSize then begin
      GetMem (p^.pExtraBuf, cnt);
      move (pb^, p^.pExtraBuf^, cnt);
   end else begin
      move (pb^, p^.pDefaultBuf^, cnt);
   end;
   AnsList.Add (p);
end;

procedure  TUdpSendClass.UpDate;
var
   i : integer;
   p : PTUSendData;
   psd : PTComData;
   Buffer : array [0..8192] of char;
begin
   if AnsList.Count <= 0 then exit;

   for i := 0 to nUpDatePerSend -1 do begin
      p := AnsList[0];
      Udp.RemoteHost := p^.ip;
      Udp.RemotePort := p^.port;

      psd := @Buffer;
      psd^.cnt := p^.datasize;

      if p^.datasize > DefaultBufferSize then move (p^.pExtraBuf^, psd^.data, psd^.cnt)
      else                                    move (p^.pDefaultBuf^, psd^.data, psd^.cnt);

      try
         Udp.SendBuffer(Buffer, psd^.cnt + 4);
      finally
         if p^.datasize > DefaultBufferSize then FreeMem (p^.pExtraBuf);
         AnsList.Delete (0);
      end;
   end;
end;

end.
