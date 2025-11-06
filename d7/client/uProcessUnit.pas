unit uProcessUnit;

interface

uses
   windows, TlHelp32, classes;

procedure TerminateProcessName (aProcessName : string);
function  TerminateProcessID (aProcessID : DWord): Boolean;
procedure BuildProcess32List;

var
   ProcessList : TStringList;
implementation

procedure TerminateProcessName (aProcessName : string);
var
   i : integer;
begin
   for i := 0 to ProcessList.Count -1 do begin
      if ProcessList[i] = aProcessName then begin
         TerminateProcessID (DWord(ProcessList.Objects[i]));
      end;
   end;
end;

function  TerminateProcessID (aProcessID : DWord): Boolean;
var
   h : THandle;
   b : boolean;
begin
   Result := FALSE;
   h := OpenProcess(PROCESS_ALL_ACCESS, TRUE, aProcessID);
   if h = 0 then exit;
   try
      b := TerminateProcess (h, 0);
   except
      exit;
   end;
   if not b then exit;
   Result := TRUE;
end;

procedure BuildProcess32List;
var
   Process32 : TProcessEntry32;
   H : THandle;
   Next : Boolean;
begin
   ProcessList.Clear;
   Process32.dwSize := Sizeof(TProcessEntry32);
   H := CreateToolHelp32Snapshot (TH32CS_SNAPPROCESS, 0);
   if Process32First(H, Process32) then begin
      ProcessList.AddObject (Process32.szExeFile, TObject(Process32.th32ProcessID));
      Repeat
         Next := Process32Next(H, Process32);
         if Next then
            ProcessList.AddObject (Process32.szExeFile, TObject(Process32.th32ProcessID));
      until not Next;
   end;
   CloseHandle(H);
end;

initialization
begin
   ProcessList := TStringList.Create;
end;

finalization
begin
   ProcessList.Free;
end;
end.
