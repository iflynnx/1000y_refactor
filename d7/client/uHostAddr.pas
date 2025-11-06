unit uHostAddr;

interface

uses
   classes, sysutils, autil32;
type
  THostAddr = class
  public
    Ip: string;
    Port: string;
    Region: string;
  end;

  THostAddressClass = class
   private
     HostAddrList: TStringList;
     function GetCount: integer;
   public
     RegionList: TStringList;
     
     constructor Create (aFileName: string);
     destructor Destroy; override;
     function FindIndexByName (aname: string): integer;
     function GetIps(aidx: integer; adefault: string) : string;
     function GetPorts(aidx: integer; adefault: string) : string;
     function GetNames(aidx: integer; adefault: string) : string;
     function GetRegions(aidx: integer; adefault: string) : string;
     property Count: integer read GetCount;
  end;

implementation

constructor THostAddressClass.Create (aFileName: string);
var
   i: integer;
   str, rdstr: string;
   StringList: TStringList;
   HostAddr: THostAddr;
begin
   HostAddrList := TStringList.Create;
   RegionList := TStringList.Create;
   StringList := TStringList.Create;

   if FileExists (aFileName) then begin
      StringList.LoadFromFile (afilename);
      for i := StringList.Count-1 downto 0 do begin
         str := stringlist[i];
         str := GetValidStr3 (str, rdstr, ',');
         if rdstr = '' then begin StringList.delete (i); continue; end;
         str := GetValidStr3 (str, rdstr, ',');
         if rdstr = '' then begin StringList.delete (i); continue; end;
         str := GetValidStr3 (str, rdstr, ',');
         if rdstr = '' then begin StringList.delete (i); continue; end;
         str := GetValidStr3 (str, rdstr, ',');
         if rdstr = '' then begin StringList.delete (i); continue; end;
      end;

      for i := 0 to StringList.Count-1 do begin
         str := stringlist[i];
         HostAddr := THostAddr.Create;

         str := GetValidStr3 (str, rdstr, ',');
         HostAddr.Ip := rdstr;
         str := GetValidStr3 (str, rdstr, ',');
         HostAddr.Port := rdstr;
         str := GetValidStr3 (str, rdstr, ',');
         HostAddr.Region := rdstr;
         str := GetValidStr3 (str, rdstr, ',');
         HostAddrList.AddObject(rdstr, HostAddr);

         if RegionList.IndexOf(HostAddr.Region) < 0 then
            RegionList.Add(HostAddr.Region);
      end;
   end;
end;

destructor THostAddressClass.Destroy;
var
   i: integer;
   HostAddr: THostAddr;
begin
   for i := 0 to HostAddrList.Count-1 do begin
      HostAddr := THostAddr(HostAddrList.Objects[i]);
      HostAddr.Free;
   end;
   HostAddrList.Free;
   RegionList.Free;
   
   inherited destroy;
end;

function THostAddressClass.GetIps(aidx:integer; adefault: string) : string;
var
   HostAddr: THostAddr;
begin
   result := adefault;
   if (aidx < 0) or (aidx >= HostAddrList.Count) then exit;
   HostAddr := THostAddr(HostAddrList.Objects[aidx]);
   Result := HostAddr.Ip;
end;

function THostAddressClass.GetPorts(aidx:integer; adefault: string) : string;
var
   HostAddr: THostAddr;
begin
   result := adefault;
   if (aidx < 0) or (aidx >= HostAddrList.Count) then exit;
   HostAddr := THostAddr(HostAddrList.Objects[aidx]);
   Result := HostAddr.Port;
end;

function THostAddressClass.GetNames(aidx: integer; adefault: string) : string;
begin
   result := adefault;
   if (aidx < 0) or (aidx >= HostAddrList.Count) then exit;
   Result := HostAddrList[aidx];
end;

function THostAddressClass.GetRegions(aidx: integer; adefault: string) : string;
var
   HostAddr: THostAddr;
begin
   result := adefault;
   if (aidx < 0) or (aidx >= HostAddrList.Count) then exit;
   HostAddr := THostAddr(HostAddrList.Objects[aidx]);
   Result := HostAddr.Region;
end;

function THostAddressClass.GetCount: integer;
begin
   Result := HostAddrList.Count;
end;

function THostAddressClass.FindIndexByName (aname: string): integer;
begin
   Result := HostAddrList.IndexOf(aname);
end;

end.
