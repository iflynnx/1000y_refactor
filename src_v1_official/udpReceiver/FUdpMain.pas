unit FUdpMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  NMUDP, StdCtrls, IniFiles, adeftype, Barutil, AUtil32, ExtCtrls;

type
  TIpData = record
    ipaddr : string [32];
    RBuffer : TBufferClass;
  end;
  PTIpData = ^TIpData;

  TStringData = record
    rmsg : byte;
    rWordString : TWordString;
  end;
  PTStringData = ^TStringData;

  TFrmMain = class(TForm)
    BtnClose: TButton;
    LbCaption: TLabel;
    LbReceiveCount: TLabel;
    TimerProcess: TTimer;
    BtnSave: TButton;
    LbUdpPort: TLabel;
    LbIpCount: TLabel;
    LbDataPerSec: TLabel;
    lblExcept: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerProcessTimer(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
  private
    Ini: TIniFile;
    StringList : TStringList;
    ipCount : integer;
    IpList : TList;

    UdpExceptCount : Integer;

    procedure SaveDataFileAndClear;
    procedure BufferProcess(var Code: TComdata; ipaddr: string);
  public
    procedure UdpDataReceived(Sender: TComponent; NumberBytes: Integer; FromIP: String; FromPort : Integer);

  end;

var
  FrmMain: TFrmMain;
  SaveNumber : integer = 1000;
  MaxListCount : integer = 10000;
  DataDirectory : string = '.\';
  DataFileName : string = 'Sample';
  DataFileNameExt : string = '.sdb';
  Fields : string = 'Name,';

  NMUDPTest : TNMUDP;

  ReceiveDataSize : integer = 0;


implementation

{$R *.DFM}

procedure TFrmMain.UdpDataReceived(Sender: TComponent; NumberBytes: Integer; FromIP: String; FromPort : Integer);
var
   i, cnt : integer;
   Buffer : array [0..8192] of char;
begin
  ReceiveDataSize := ReceiveDataSize + NumberBytes;
  try
    cnt := NumberBytes;

    if cnt > 0 then begin
       if cnt > 8192 then cnt := 8192;
       NMUDPTest.ReadBuffer(Buffer, cnt);

       byte (Buffer[cnt]) := 0;

       for i := 0 to IpList.Count-1 do begin
          if Fromip = PTIpData(IpList[i])^.ipaddr then begin
             PTIpData(IpList[i])^.RBuffer.Add (cnt, @Buffer);
             break;
          end;
       end;
    end else begin
      UdpExceptCount := UdpExceptCount + 1;
      lblExcept.Caption := 'UDP EXCEPT : ' + IntToStr(UdpExceptCount);
    end;
  finally
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
   i : integer;
   pi : PTIpData;
begin
   UdpExceptCount := 0;

   StringList := TStringList.Create;

   Ini := TIniFile.Create ('.\Receiver.ini');

   NMUDPTest := TNMUDP.Create (self);
   NMUDPTest.LocalPort := Ini.ReadInteger ('UDPRECEIVER','PORT', 6001);
   NMUDPTest.OnDataReceived := UdpDataReceived;


   LbCaption.Caption := 'Caption : ' + Ini.ReadString ('UDPRECEIVER','CAPTION', 'Udp Receiver');
   LbUdpPort.Caption := 'Port : ' + IntToStr (NMUDPTest.LocalPort);

   SaveNumber := Ini.ReadInteger ('UDPRECEIVER','SAVENUMBER', 0);
   SaveNumber := SaveNumber + 1;
   Ini.WriteInteger ('UDPRECEIVER','SAVENUMBER', SaveNumber);
   MaxListCount := Ini.ReadInteger ('UDPRECEIVER','MAXLISTCOUNT', 10000);

   DataDirectory := Ini.ReadString ('UDPRECEIVER','DIRECTORY', '.\');
   DataFileName := Ini.ReadString ('UDPRECEIVER','FILENAME', 'Sample');
   DataFileNameExt := Ini.ReadString ('UDPRECEIVER','FILENAMEEXT', '.sdb');

   Fields := Ini.ReadString ('UDPRECEIVER','FIELDS', 'Name,');
   Fields := Fields + ',Ipaddr,Date,Time,';

   IpList := TList.Create;
   ipCount := Ini.ReadInteger ('UDPRECEIVER','IPCOUNT', 0);
   LbIpCount.Caption := 'IP : ' + IntToStr (ipCount);


   for i := 1 to ipCount do begin
      new (pi);
      pi^.ipaddr := Ini.ReadString ('UDPRECEIVER','IP'+IntToStr(i), '127.0.0.1');
      pi^.RBuffer := TBufferClass.Create;
      IpList.Add (pi);
   end;

   TimerProcess.Enabled := TRUE;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
var i : integer;
begin
   for i := 0 to IpList.Count-1 do begin
      PTIpData (IpList[i])^.RBuffer.Free;
      dispose (IpList[i]);
   end;
   IpList.Free;
   SaveDataFileAndClear;
   Ini.Free;
   StringList.Free;
   NMUDPTest.Free;
end;

procedure TFrmMain.BtnSaveClick(Sender: TObject);
begin
   if StringList.Count = 0 then exit;
   StringList.Insert (0, Fields);
   StringList.SaveToFile (DataDirectory + DataFileName + IntToStr (SaveNumber)+DataFileNameExt);
   StringList.Delete (0);
end;

procedure TFrmMain.SaveDataFileAndClear;
begin
   if StringList.Count = 0 then exit;
   StringList.Insert (0, Fields);
   StringList.SaveToFile (DataDirectory + DataFileName + IntToStr (SaveNumber)+DataFileNameExt);
   inc (SaveNumber);
   Ini.WriteInteger ('UDPRECEIVER','SAVENUMBER', SaveNumber);
   StringList.Clear;
end;

procedure TFrmMain.BufferProcess(var Code: TComdata; ipaddr: string);
var str : string;
begin
   str := GetWordString (PTStringData(@Code.Data)^.rWordString);
   StringList.Add (str+','+ipaddr+','+DateToStr(Date)+','+TimeToStr(Time));
   if StringList.Count > MaxListCount then SaveDataFileAndClear;
end;

procedure TFrmMain.TimerProcessTimer(Sender: TObject);
const
   CurProcess : integer = 0;
var
   i, cnt: integer;
   sd : TComData;
   pi : PTIpData;
begin
   inc (CurProcess);

   if CurProcess >= 10 then begin
      CurProcess := 0;
      LbDataPerSec.Caption := 'Data / Sec : ' + IntToStr (ReceiveDataSize);
      ReceiveDataSize := 0;
   end;

   LbReceiveCount.Caption := 'Data Count : ' + inttostr(StringList.Count);

   for i := 0 to IpList.Count -1 do begin
      pi := IpList[i];

      while TRUE do begin
         cnt := pi^.RBuffer.Count;
         if cnt < 4 then break;
         pi^.RBuffer.View (4, @sd.cnt);
         if cnt < sd.cnt + 4 then break;
         pi^.RBuffer.Get (sd.cnt + 4, @sd);
         BufferProcess (sd, IntToStr(i));
      end;
   end;
end;

procedure TFrmMain.BtnCloseClick(Sender: TObject);
begin
   Close;
end;

end.

