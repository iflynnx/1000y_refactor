unit uPaidDB;

interface

uses
   Windows, Classes, SysUtils, AUtil32, UserSDB, uKeyClass;

type
   TNamePay = class
   private
      FLoginID : String;
      FRemainDay : Integer;
      FCode : Byte;
   public
      constructor Create (aLoginID : String; aRemainDay : Integer; aCode : Byte);
      destructor Destroy; override;

      property LoginID : String read FLoginID;
      property RemainDay : Integer read FRemainDay;
      property Code : Byte read FCode;
   end;

   TIPPay = class
   private
      FIPAddr : String;
      FRemainDay : Integer;
      FCode : Byte;
   public
      constructor Create (aIPAddr : String; aRemainDay : Integer; aCode : Byte);
      destructor Destroy; override;

      property IPAddr : String read FIPAddr;
      property RemainDay : Integer read FRemainDay;
      property Code : Byte read FCode;
   end;

   TPaidDB = class
   private
      FNamePaidFileName : String;
      FIPPaidFileName : String;
      
      NamePaidList : TList;
      IPPaidList : TList;
      NameKey : TStringKeyClass;
      IPKey : TStringKeyClass;

      function GetNamePaidCount : Integer;
      function GetIPPaidCount : Integer;
   public
      constructor Create (aNameFileName, aIPFileName : String);
      destructor  Destroy; override;

      procedure   Clear;

      function    GetRemainName (aName : String) : TNamePay;
      function    GetRemainIp (aIpAddr : String) : TIPPay;

      procedure   LoadFromFile;

      property    NamePaidCount : Integer read GetNamePaidCount;
      property    IPPaidCount : Integer read GetIPPaidCount;
   end;

var
   PaidDB : TPaidDB = nil;

implementation

// TNamePay
constructor TNamePay.Create (aLoginID : String; aRemainDay : Integer; aCode : Byte);
begin
   FLoginID := aLoginID;
   FRemainDay := aRemainDay;
   if FRemainDay < 0 then FRemainDay := 0;
   FCode := aCode;
end;

destructor TNamePay.Destroy;
begin
   inherited Destroy;
end;

// TIPPay
constructor TIPPay.Create (aIpAddr : String; aRemainDay : Integer; aCode : Byte);
begin
   FIPAddr := aIpAddr;
   FRemainDay := aRemainDay;
   if FRemainDay < 0 then FRemainDay := 0;
   FCode := aCode;
end;

destructor TIPPay.Destroy;
begin
   inherited Destroy;
end;

// TPaidDB
constructor TPaidDB.Create (aNameFileName, aIPFileName : String);
begin
   NamePaidList := TList.Create;
   IPPaidList := TList.Create;
   NameKey := TStringKeyClass.Create;
   IPKey := TStringKeyClass.Create;

   FNamePaidFileName := aNameFileName;
   FIPPaidFileName := aIPFileName;

   LoadFromFile;
end;

destructor  TPaidDB.Destroy;
begin
   Clear;
   NamePaidList.Free;
   IPPaidList.Free;
   NameKey.Free;
   IPKey.Free;
   
   inherited Destroy;
end;

procedure TPaidDB.Clear;
var
   i : Integer;
   NamePay : TNamePay;
   IPPay : TIPPay;
begin
   for i := 0 to NamePaidList.Count - 1 do begin
      NamePay := NamePaidList.Items [i];
      NamePay.Free;
   end;
   NamePaidList.Clear;
   NameKey.Clear;

   for i := 0 to IPPaidList.Count - 1 do begin
      IPPay := IPPaidList.Items [i];
      IPPay.Free;
   end;
   IPPaidList.Clear;
   IPKey.Clear;
end;

procedure TPaidDB.LoadFromFile;
var
   i, j : Integer;
   iName, Name, tmpName : String;
   RemainDay, IPLen : Integer;
   Code : Byte;
   NamePay : TNamePay;
   IPPay : TIPPay;
   DB : TUserStringDB;
begin
   Clear;

   if FileExists (FNamePaidFileName) then begin
      DB := TUserStringDB.Create;
      DB.LoadFromFile (FNamePaidFileName);
      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName (i);
         if iName = '' then continue;

         Name := DB.GetFieldValueString (iName, 'LoginID');
         if Name = '' then continue;
         RemainDay := DB.GetFieldValueInteger (iName, 'RemainDay');
         if RemainDay <= 0 then continue;
         Code := DB.GetFieldValueInteger (iName, 'Ect');

         NamePay := NameKey.Select (Name);
         if NamePay = nil then begin
            NamePay := TNamePay.Create (Name, RemainDay, Code);
            NamePaidList.Add (NamePay);
            NameKey.Insert (Name, NamePay);
         end;
      end;
      DB.Free;
   end;

   if FileExists (FIPPaidFileName) then begin
      DB := TUserStringDB.Create;
      DB.LoadFromFile (FIPPaidFileName);
      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName (i);
         if iName = '' then continue;

         Name := DB.GetFieldValueString (iName, 'IPAddr');
         if Name = '' then continue;
         RemainDay := DB.GetFieldValueInteger (iName, 'RemainDay');
         if RemainDay <= 0 then continue;
         IPLen := DB.GetFieldValueInteger (iName, 'IPLength');
         if IPLen <= 0 then IPLen := 1;
         Code := DB.GetFieldValueInteger (iName, 'Ect');

         for j := 0 to IPLen - 1 do begin
            tmpName := DWORDToIPAddr (IpAddrToDWORD (Name) + DWORD(j));
            IPPay := IPKey.Select (tmpName);
            if IPPay = nil then begin
               IPPay := TIPPay.Create (tmpName, RemainDay, Code);
               IPPaidList.Add (IPPay);
               IPKey.Insert (tmpName, IPPay);
            end;
         end;
      end;
      DB.Free;
   end;
end;

function TPaidDB.GetRemainName (aName: String) : TNamePay;
begin
   Result := NameKey.Select (aName);
end;

function TPaidDB.GetRemainIp (aIpAddr: String) : TIPPay;
begin
   Result := IPKey.Select (aIPAddr);
end;

function TPaidDB.GetNamePaidCount : Integer;
begin
   Result := NamePaidList.Count;
end;

function TPaidDB.GetIPPaidCount : Integer;
begin
   Result := IPPaidList.Count;
end;

end.
