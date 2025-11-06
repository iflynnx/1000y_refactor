unit uGetDeviceName;

interface

uses
   Windows,
   DirectDraw;


function GetDeviceidentify (var aDriver, aDescription: pChar): HResult;
function GetCpuSpeed: integer;
function GetTotalPhysicalMemory: integer;

implementation


type
  TDirectDrawCreate = function (lpGUID: PGUID; out lplpDD: IDirectDraw; pUnkOuter: IUnknown) : HResult; stdcall;

const
   DllFileName = 'D2GNA.dll';

var
  hDDrawDLL : THandle = 0;
  pDDraw : IDirectDraw = nil;
  pDDraw4 : IDirectDraw4 = nil;

  DirectDrawCreate  : TDirectDrawCreate;
  DDDeviceIdentifier : TDDDeviceIdentifier;

function LoadDll: Boolean;
var
   hr : HResult;
begin
   Result := FALSE;
   Fillchar (DDDeviceIdentifier, sizeof(DDDeviceIdentifier), 0);
   hDDrawDLL := LoadLibrary ('DDRAW.DLL');
   if hDDrawDLL < 32 then begin
   end else begin
      DirectDrawCreate := TDirectDrawCreate (GetProcAddress(hDDrawDLL, 'DirectDrawCreate'));
      hr := DirectDrawCreate(nil, pDDraw, nil);
      if hr = S_OK then begin
         pDDraw4 := pDDraw as IDirectDraw4;
         if pDDraw4 <> nil then begin
            pDDraw4.GetDeviceIdentifier(DDDeviceIdentifier, 0);
            Result := TRUE;
         end;
      end;
   end;
end;

procedure FreeDll;
begin
   if pDDraw4 <> nil then pDDraw4 := nil;
   if pDDraw <> nil then pDDraw := nil;

   if hDDrawDLL > 32 then FreeLibrary(hDDrawDLL);
end;

function GetDeviceidentify (var aDriver, aDescription: pChar): HResult;
begin
   Result := S_FALSE;
   fillchar (DDDeviceIdentifier, sizeof(DDDeviceIdentifier), 0);
   if LoadDll then begin
      Result := S_OK;
      aDriver := DDDeviceIdentifier.szDriver;
      aDescription := DDDeviceIdentifier.szDescription;
   end;
   FreeDll;
end;


function CpuSpeed: Extended;
var
   t: DWORD;
   mhi, mlo, nhi, nlo: DWORD;
   t0, t1, chi, clo, shr32: Comp;
begin
   shr32 := 65536;
   shr32 := shr32 * 65536;
   t := GetTickCount;
   while t = GetTickCount do begin end;
   asm
      DB 0FH
      DB 031H
      mov mhi,edx
      mov mlo,eax
   end;

   while GetTickCount < (t + 1000) do begin end;
   asm
      DB 0FH
      DB 031H
      mov nhi,edx
      mov nlo,eax
   end;
   chi := mhi;
   if mhi < 0 then chi := chi + shr32;
   clo := mlo;
   if mlo < 0 then clo := clo + shr32;
   t0 := chi * shr32 + clo;
   chi := nhi;
   if nhi < 0 then chi := chi + shr32;
   clo := nlo;
   if nlo < 0 then clo := clo + shr32;
   t1 := chi * shr32 + clo;
   Result := (t1 - t0) / 1E6;
end;

function GetCpuSpeed: integer;
begin
   Result := round(CpuSpeed);
end;

function GetTotalPhysicalMemory: integer;
var
   MemStat : TMemoryStatus;
begin
   MemStat.dwLength := sizeof(TMemoryStatus);
   GlobalMemoryStatus(MemStat);
   Result := (MemStat.dwTotalPhys div 1048576)+1;
end;

end.
