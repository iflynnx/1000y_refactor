unit uUseIP;

interface

uses
   Classes, SysUtils, mmSystem, uKeyClass, uUsers, DefType;

type
   TGateIP = class
   private
      FName : String;
      FIpAddr : String;

      DataList : TList;

      FStartDate : TDateTime;
      FStartTime : TDateTime;
      FStartTick : Integer;

      function GetCount : Integer;
   public
      constructor Create (aName, aIpAddr : String);
      destructor Destroy; override;

      procedure AddUser (aUser : TUser);
      procedure DelUser (aUser : TUser);
      function SelUser (aIndex : Integer) : TUser;

      property Name : String read FName;
      property IPAddr : String read FIPAddr;
      property UseCount : Integer read GetCount;
   end;

   TUseIP = class
   private
      FIpAddr : String;
      FPaidCode : Byte;

      DataList : TList;

      boBanIP : Boolean;

      FStartDate : TDateTime;
      FStartTime : TDateTime;
      FStartTick : Integer;

      function GetCount : Integer;
   public
      constructor Create (aIpAddr : String);
      destructor Destroy; override;

      procedure AddUser (aUser : TUser);
      procedure DelUser (aUser : TUser);

      property IPAddr : String read FIPAddr;
      property UseCount : Integer read GetCount;
   end;

   TIPList = class
   private
      UseIPList : TList;
      GateIPList : TList;

      UseIpKey : TStringKeyClass;
      GateIPKey : TStringKeyClass;

      function GetUseIPCount : Integer;
      function GetGateIPCount : Integer;
      function GetBanIPCount : String;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      function AddUser (aUser : TUser) : Boolean;
      function DelUser (aUser : TUser) : Boolean;

      function FindGateIP (aIpAddr : String) : TGateIP;
      function FindUseIP (aIpAddr : String) : TUseIP;
      function GetGateIP (aIndex : Integer) : TGateIP;
      function GetUseIP (aIndex : Integer) : TUseIP;

      property UseIPCount : Integer read GetUseIPCount;
      property GateIPCount : Integer read GetGateIPCount;
      property BanIPCount : String read GetBanIPCount;
   end;

var
   IPList : TIPList = nil;

implementation

uses
   FMain, uUtil;

// TGateIP
constructor TGateIP.Create (aName, aIpAddr : String);
begin
   FName := aName;
   FIpAddr := aIpAddr;

   DataList := TList.Create;

   FStartTick := timeGetTime;
   FStartDate := Date;
   FStartTime := Time;
end;

destructor TGateIP.Destroy;
begin
   DataList.Clear;
   DataList.Free;
   
   inherited Destroy;
end;

function TGateIP.GetCount : Integer;
begin
   Result := DataList.Count;
end;

procedure TGateIP.AddUser (aUser : TUser);
begin
   DataList.Add (aUser);
end;

procedure TGateIP.DelUser (aUser : TUser);
var
   nIndex : Integer;
   Stream : TFileStream;
   FileName, Str, StartStr, EndStr, UseStr : String;
   nHour, nMin, nSec, nMSec : Word;
   buffer : array [0..4096 - 1] of Char;
   EndDate, EndTime : TDateTime;
begin
   nIndex := DataList.IndexOf (aUser);
   if nIndex < 0 then exit;

   FileName := '.\Data\GI' + GetDateByStr (Date) + '.SDB';

   Stream := nil;
   try
      if not FileExists (FileName) then begin
         Stream := TFileStream.Create (FileName, fmCreate);
         StrPCopy (@buffer, 'IP,ServerName,LoginID,CharName,StartTime,EndTime,UseTime' + #13#10);
         Stream.WriteBuffer (buffer, StrLen (@buffer));
      end else begin
         Stream := TFileStream.Create (FileName, fmOpenReadWrite);
         Stream.Seek (0, soFromEnd);
      end;

      EndDate := Date - aUser.StartDate;
      EndTime := Time - aUser.StartTime;
      StartStr := GetDateByStr (aUser.StartDate) + ' ' + GetTimeByStr (aUser.StartTime);
      EndStr := GetDateByStr (Date) + ' ' + GetTimeByStr (Time);

      DecodeTime (EndTime, nHour, nMin, nSec, nMSec);
      if EndDate > 0 then nHour := nHour +  Round (EndDate) * 24;
      UseStr := '';
      if nHour < 10 then UseStr := UseStr + '0';
      UseStr := UseStr + IntToStr (nHour) + ':';
      if nMin < 10 then UseStr := UseStr + '0';
      UseStr := UseStr + IntToStr (nMin) + ':';
      if nSec < 10 then UseStr := UseStr + '0';
      UseStr := UseStr + IntToStr (nSec);

      StrPCopy (@buffer, FIpAddr + ',' + aUser.ServerName + ',' + aUser.LoginID
          + ',' + aUser.CharName + ',' + StartStr + ',' + EndStr + ',' + UseStr + #13#10);
      Stream.WriteBuffer (buffer, StrLen (@buffer));
   except
   end;

   if Stream <> nil then Stream.Free;

   DataList.Delete (nIndex);
end;

function TGateIP.SelUser (aIndex : Integer) : TUser;
begin
   Result := nil;
   if (aIndex < 0) or (aIndex >= DataList.Count) then exit;

   Result := DataList.Items [aIndex];
end;

// TUseIP
constructor TUseIP.Create (aIpAddr : String);
begin
   FIpAddr := aIpAddr;
   FPaidCode := 0;

   boBanIP := false;
   
   DataList := TList.Create;

   FStartTick := timeGetTime;
   FStartDate := Date;
   FStartTime := Time;
end;

destructor TUseIP.Destroy;
var
   Stream : TFileStream;
   FileName, Str, StartStr, EndStr, UseStr : String;
   nHour, nMin, nSec, nMSec : Word;
   buffer : array [0..4096 - 1] of Char;
   EndDate, EndTime : TDateTime;
begin
   FileName := '.\Data\CI' + GetDateByStr (Date) + '.SDB';

   Stream := nil;
   try
      if not FileExists (FileName) then begin
         Stream := TFileStream.Create (FileName, fmCreate);
         StrPCopy (@buffer, 'IP,StartTime,EndTime,UseTime,Code' + #13#10);
         Stream.WriteBuffer (buffer, StrLen (@buffer));
      end else begin
         Stream := TFileStream.Create (FileName, fmOpenReadWrite);
         Stream.Seek (0, soFromEnd);
      end;

      EndDate := Date - FStartDate;
      EndTime := Time - FStartTime;
      StartStr := GetDateByStr (FStartDate) + ' ' + GetTimeByStr (FStartTime);
      EndStr := GetDateByStr (Date) + ' ' + GetTimeByStr (Time);

      DecodeTime (EndTime, nHour, nMin, nSec, nMSec);
      if EndDate > 0 then nHour := nHour +  Round (EndDate) * 24;
      UseStr := '';
      if nHour < 10 then UseStr := UseStr + '0';
      UseStr := UseStr + IntToStr (nHour) + ':';
      if nMin < 10 then UseStr := UseStr + '0';
      UseStr := UseStr + IntToStr (nMin) + ':';
      if nSec < 10 then UseStr := UseStr + '0';
      UseStr := UseStr + IntToStr (nSec);

      SendUdp (FIpAddr + ',' + StartStr + ',' + EndStr + ',' + UseStr + ',' + IntToStr (FPaidCode));

      StrPCopy (@buffer, FIpAddr + ',' + StartStr + ',' + EndStr + ',' + UseStr + ',' + IntToStr (FPaidCode) + #13#10);
      Stream.WriteBuffer (buffer, StrLen (@buffer));
   except
   end;

   if Stream <> nil then Stream.Free;

   DataList.Clear;
   DataList.Free;

   inherited Destroy;
end;

function TUseIP.GetCount : Integer;
begin
   Result := DataList.Count;
end;

procedure TUseIP.AddUser (aUser : TUser);
var
   i, iCount : Integer;
   User : TUser;
begin
   if (aUser.PaidType = pt_ipmoney) or (aUser.PaidType = pt_iptime) then begin
      FPaidCode := aUser.PaidCode;
   end;

   DataList.Add (aUser);
   if DataList.Count > 2 then begin
      iCount := 0;
      for i := 0 to DataList.Count - 1 do begin
         User := DataList.Items [i];
         if (User.PaidType = pt_ipmoney) or (User.PaidType = pt_iptime) then begin
            iCount := iCount + 1;
         end;
      end;

      if iCount > 2 then begin
         boBanIP := true;
         if frmMain.chkIPLImit.Checked = true then begin
            for i := 0 to DataList.Count - 1 do begin
               User := DataList.Items [i];
               if (User.PaidType = pt_ipmoney) or (User.PaidType = pt_iptime) then begin
                  UserList.ARSClose (User.LoginID);
                  break;
               end;
            end;
         end;
      end;
   end;
end;

procedure TUseIP.DelUser (aUser : TUser);
var
   nIndex : Integer;
   i, iCount : Integer;
   User : TUser;
begin
   nIndex := DataList.IndexOf (aUser);
   if nIndex < 0 then exit;

   DataList.Delete (nIndex);

   if boBanIP = true then begin
      if DataList.Count > 2 then begin
         iCount := 0;
         for i := 0 to DataList.Count - 1 do begin
            User := DataList.Items [i];
            if (User.PaidType = pt_ipmoney) or (User.PaidType = pt_iptime) then begin
               iCount := iCount + 1;
            end;
         end;

         if iCount <= 2 then begin
            boBanIP := false;
         end;
      end else begin
         boBanIP := false;
      end;
   end;
end;

// TIPList
constructor TIPList.Create;
var
   i : Integer;
   StrList : TStringList;
   Str : String;
   GateIP : TGateIP;
begin
   UseIPList := TList.Create;
   UseIpKey := TStringKeyClass.Create;

   GateIPList := TList.Create;
   GateIPKey := TStringKeyClass.Create;

   StrList := TStringList.Create;
   StrList.LoadFromFile ('.\GateWayList.TXT');
   for i := 0 to StrList.Count - 1 do begin
      Str := StrList.Strings [i];
      if Str <> '' then begin
         GateIP := GateIPKey.Select (Str);
         if GateIP = nil then begin
            GateIP := TGateIP.Create ('', Str);
            GateIPList.Add (GateIP);
            GateIPKey.Insert (Str, GateIP);
         end;
      end;
   end;
end;

destructor TIPList.Destroy;
begin
   Clear;
   UseIPKey.Free;
   UseIPList.Free;
   GateIPKey.Free;
   GateIPList.Free;

   inherited Destroy;
end;

procedure TIPList.Clear;
var
   i : Integer;
   UseIP : TUseIP;
   GateIP : TGateIP;
begin
   for i := 0 to UseIPList.Count - 1 do begin
      UseIP := UseIPList.Items [i];
      UseIP.Free;
   end;
   UseIPList.Clear;
   UseIPKey.Clear;
   for i := 0 to GateIPList.Count - 1 do begin
      GateIP := GateIPList.Items [i];
      GateIP.Free;
   end;
   GateIPList.Clear;
   GateIPKey.Clear;
end;

function TIPList.GetUseIPCount : Integer;
begin
   Result := UseIPList.Count;
end;

function TIPList.FindGateIP (aIpAddr : String) : TGateIP;
var
   i : Integer;
   GateIP : TGateIP;
begin
   Result := nil;
   
   for i := 0 to GateIPList.Count - 1 do begin
      GateIP := GateIPList.Items [i];
      if GateIP.IPAddr = aIpAddr then begin
         Result := GateIP;
         exit;
      end;
   end;
end;

function TIPList.FindUseIP (aIpAddr : String) : TUseIP;
var
   i : Integer;
   UseIP : TUseIP;
begin
   Result := nil;

   for i := 0 to UseIPList.Count - 1 do begin
      UseIP := UseIPList.Items [i];
      if UseIP.IPAddr = aIpAddr then begin
         Result := UseIP;
         exit;
      end;
   end;
end;

function TIPList.GetGateIPCount : Integer;
begin
   Result := GateIPList.Count;
end;

function TIPList.GetBanIPCount : String;
var
   i, iCount, uCount, mCount : Integer;
   MaxIpAddr : String;
   UseIP : TUseIP;
begin
   Result := '';

   iCount := 0; uCount := 0; mCount := 0;
   MaxIpAddr := '';
   for i := 0 to UseIPList.Count - 1 do begin
      UseIP := UseIPList.Items [i];
      if UseIP.boBanIP = true then begin
         if mCount < UseIP.UseCount then begin
            mCount := UseIP.UseCount;
            MaxIPAddr := UseIP.IpAddr;
         end;
         uCount := uCount + UseIP.UseCount - 2; 
         iCount := iCount + 1;
      end;
   end;

   Result := format ('%d/%d/%s(%d)', [iCount, uCount, MaxIPAddr, mCount]);
end;

function TIPList.AddUser (aUser : TUser) : Boolean;
var
   nIndex : Integer;
   UseIP : TUseIP;
   GateIP : TGateIP;
begin
   Result := false;

   GateIP := GateIPKey.Select (aUser.IpAddr);
   UseIP := UseIpKey.Select (aUser.IpAddr);
   if GateIP <> nil then begin
      GateIP.AddUser (aUser);
   end else begin
      if UseIP <> nil then begin
         UseIP.AddUser (aUser);
      end else begin
         UseIP := TUseIP.Create (aUser.IpAddr);
         UseIP.AddUser (aUser);
         UseIPList.Add (UseIP);
         UseIPKey.Insert (aUser.IpAddr, UseIP);

         AddUsedIP (aUser.IpAddr);
      end;
   end;
end;

function TIPList.DelUser (aUser : TUser) : Boolean;
var
   i, nIndex : Integer;
   UseIP : TUseIP;
   GateIP : TGateIP;
begin
   Result := true;

   GateIP := GateIPKey.Select (aUser.IpAddr);
   UseIP := UseIpKey.Select (aUser.IpAddr);
   if GateIP <> nil then begin
      GateIP.DelUser (aUser);
      exit;
   end else begin
      if UseIP <> nil then begin
         UseIP.DelUser (aUser);
         if UseIP.UseCount = 0 then begin
            nIndex := UseIPList.IndexOf (UseIP);
            UseIPKey.Delete (aUser.IpAddr);
            UseIPList.Delete (nIndex);
            UseIP.Free;
            AddEndIP (aUser.IpAddr);
         end;
         exit;
      end;
   end;

   Result := false;
end;

function TIPList.GetGateIP (aIndex : Integer) : TGateIP;
begin
   Result := nil;
   if (aIndex < 0) or (aIndex >= GateIPList.Count) then exit;

   Result := GateIPList.Items [aIndex];
end;

function TIPList.GetUseIP (aIndex : Integer) : TUseIP;
begin
   Result := nil;
   if (aIndex < 0) or (aIndex >= UseIPList.Count) then exit;

   Result := UseIPList.Items [aIndex];
end;


end.
