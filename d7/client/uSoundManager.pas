unit uSoundManager;

interface

uses
   Windows, classes, Sysutils, uDSound;
const
   COLLECTIONWAVE_ID = 'ATW0';
{$ALIGN 1}
type
  TCollectionWaveFileHeader = packed record
     Ident : array [0..4-1] of char;
     Count : integer;
  end;

  TWaveData = packed record
     WaveName : array [0..32] of byte;
     WaveSize : integer;
     pwave : pbyte;
  end;
  PTWaveData = ^TWaveData;

  TATWaveLib = class
     private
        DataStringList : TStringList;
        FFileName : string;
     public
        constructor Create(aHandle: integer);
        destructor  Destroy; override;
        procedure   Clear;

        procedure   LoadFormFile (aFileName: string);
        procedure   play (aFileName: string; aPan, aVolume: integer);

        function    GetName (idx: integer): string;
        function    GetCount: integer;

        property    Items [idx: integer]: string read GetName;
        property    FileName: string read FFileName;
  end;

  TBaseSoundData = packed record
    aFileName : string;
    aBaseSoundHandle : integer;
  end;
  PTBaseSoundData = ^TBaseSoundData;

  TBaseSound = class
    private
      FVolume : integer;
      DataList : TList;
      function isSound: PTBaseSoundData;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear;

      procedure play (aFileName: string; aLoop: Boolean);
      procedure Stop (aFileName: string);
      procedure Pause;
      procedure Continue;
      procedure AllStop;
      procedure SetVolume (Value: integer);
  end;

   function  RangeCompute(X : Integer; TagetX :word) : Integer;
   function  RangeVolume(X,Y : Integer; TagetX,TagetY :word; volume : Integer) : Integer;

implementation

////////////////////////////////////////////////////////////////////////////////
//                             TATWaveLib
////////////////////////////////////////////////////////////////////////////////

constructor TATWaveLib.Create(aHandle: integer);
begin
   DEffectSoundInit (aHandle);
   DataStringList := TStringList.Create;
end;

destructor  TATWaveLib.Destroy;
begin
   DataStringList.Free;
   DEffectSoundFinal;
   inherited Destroy;
end;

procedure   TATWaveLib.Clear;
begin
   DataStringList.Clear;
end;

procedure   TATWaveLib.LoadFormFile (aFileName: string);
var
   i : integer;
   CollectionWaveFileHeader : TCollectionWaveFileHeader;
   PSTWaveData : PTWaveData;
   Stream : TFileStream;
   pos : integer;
begin
   if not FileExists (aFileName) then exit;
   FFileName := aFileName;
   pos := 0;
   Stream := nil;
   try
      Stream := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite);
      Stream.ReadBuffer (CollectionWaveFileHeader, sizeof(TCollectionWaveFileHeader));

      if StrLIComp(PChar(COLLECTIONWAVE_ID), CollectionWaveFileHeader.Ident, 4) <> 0 then
         raise Exception.Create('Not a valid Wave Library File');

      pos := pos + Sizeof(TCollectionWaveFileHeader);

      New (PSTWaveData);
      for i := 0 to CollectionWaveFileHeader.Count -1 do begin
         Stream.ReadBuffer (PSTWaveData^, sizeof(TWaveData));
         pos := pos + Sizeof (TWaveData);
         DataStringList.AddObject (StrPas(@PSTWaveData^.WaveName), TObject(pos));
         Stream.Seek (PSTWaveData^.WaveSize, soFromCurrent);
         pos := pos + PSTWaveData^.WaveSize;
      end;
      dispose (PSTWaveData);
   except
      if Stream <> nil then Stream.Free;
   end;
   if Stream <> nil then Stream.Free;
end;

procedure   TATWaveLib.play (aFileName: string; aPan, aVolume: integer);
var
   i : integer;
   Stream : TFileStream;
begin
   if FileExists ('.\wav\'+aFileName) then begin
      if not DEffectSoundPlay ('.\wav\'+aFileName, aPan, aVolume) then begin
         Stream := TFileStream.Create('.\wav\'+aFileName, fmOpenRead or fmShareDenyWrite);
         DEffectSoundAdd ('.\wav\'+aFileName, Stream);
         DEffectSoundPlay ('.\wav\'+aFileName, aPan, aVolume);
         Stream.Free;
      end;
      exit;
   end;

   for i := 0 to DataStringList.Count -1 do begin
      if DataStringList[i] = aFileName then begin
         if DEffectSoundPlay (aFileName, aPan, aVolume) then begin
            exit
         end else begin
            Stream := nil;
            try
               Stream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyWrite);
               Stream.Seek (integer(DataStringList.Objects[i]), soFromCurrent);
               DEffectSoundAdd (aFileName, Stream);
               DEffectSoundPlay (aFileName, aPan, aVolume);
            except
               if Stream <> nil then Stream.Free;
               exit;
            end;
            if Stream <> nil then Stream.Free;
            exit;
         end;
      end;
   end;
end;

function    TATWaveLib.GetName (idx: integer): string;
begin
   Result := '';
   if (idx < 0) or (idx > DataStringList.Count-1) then exit;
   Result := DataStringList[idx];
end;

function    TATWaveLib.GetCount: integer;
begin
   Result := DataStringList.Count;
end;

////////////////////////////////////////////////////////////////////////////////
constructor TBaseSound.Create;
begin
   FVolume := 0;
   DataList := TList.Create;
end;

destructor TBaseSound.Destroy;
begin
   Clear;
   DataList.Free;
   inherited Destroy;
end;

procedure TBaseSound.Clear;
var
   i : integer;
   P : PTBaseSoundData;
begin
   for i := 0 to DataList.Count -1 do begin
      p := DataList [i];
      DBaseSoundStop (p^.aBaseSoundHandle);
      DBaseSoundFreeHandle (p^.aBaseSoundHandle);
      dispose (p);
   end;
   DataList.Clear;
end;

function GetFileSelect(aFileName: string): string;
var
   mp3File: string;
begin
   mp3File := ChangeFileExt(aFileName, '.mp3');

   if FileExists(mp3File) then
      Result := mp3File
   else
      Result := aFileName;
end;

procedure TBaseSound.play (aFileName: string; aLoop: Boolean);
var
   P : PTBaseSoundData;
begin
   p := isSound;
   if p <> nil then begin
      p^.aFileName := GetFileSelect(aFileName);
      DBaseSoundSetVolume (p^.aBaseSoundHandle, FVolume);
   end else begin
      new (p);
      p^.aFileName := GetFileSelect(aFileName);
      p^.aBaseSoundHandle := DBaseSoundCreateHandle;
      DBaseSoundSetVolume (p^.aBaseSoundHandle, FVolume);
   end;
   DBaseSoundSetLoop (p^.aBaseSoundHandle, aLoop);
   DBaseSoundLoadFromFile (p^.aBaseSoundHandle, PChar(p^.aFileName));
   DBaseSoundPlay (p^.aBaseSoundHandle);
   DataList.Add (p);
end;

procedure TBaseSound.SetVolume (Value: integer);
var
   i : integer;
   P : PTBaseSoundData;
begin
   FVolume := Value;
   for i := 0 to DataList.Count -1 do begin
      p := DataList[i];
      DBaseSoundSetVolume (p^.aBaseSoundHandle, FVolume);
   end;
end;

procedure TBaseSound.Pause;
var
   i: integer;
   p: PTBaseSoundData;
begin
   for i := 0 to DataList.Count-1 do begin
      p := DataList[i];
      DBaseSoundPause(p^.aBaseSoundHandle);
   end;
end;

procedure TBaseSound.Continue;
var
   i: integer;
   p: PTBaseSoundData;
begin
   for i := 0 to DataList.Count-1 do begin
      p := DataList[i];
      DBaseSoundPlay(p^.aBaseSoundHandle);
   end;
end;

procedure TBaseSound.Stop (aFileName: string);
var
   i : integer;
   P : PTBaseSoundData;
begin
   for i := 0 to DataList.Count -1 do begin
      p := DataList[i];
      if p^.aFileName = aFileName then begin
         DBaseSoundStop (p^.aBaseSoundHandle);
         exit;
      end;
   end;
end;

procedure TBaseSound.AllStop;
var
   i : integer;
   P : PTBaseSoundData;
begin
   for i := 0 to DataList.Count -1 do begin
      p := DataList[i];
      DBaseSoundStop (p^.aBaseSoundHandle);
   end;
end;


function TBaseSound.isSound: PTBaseSoundData;
var
   i : integer;
   P : PTBaseSoundData;
begin
   Result := nil;
   for i := 0 to DataList.Count -1 do begin
      p := DataList[i];
      if not DBaseSoundGetPlaying (p^.aBaseSoundHandle) then begin
         Result := p;
         exit;
      end;
   end;
end;

function RangeCompute(X : Integer; TagetX :Word) : Integer;
begin
   if TagetX < X then begin
      Result := -(ABS(TagetX - X)*500);
   end else begin
      Result := (ABS(TagetX - X)*500);
   end;
end;

function RangeVolume(X,Y : Integer; TagetX,TagetY :word; volume : Integer) : Integer;
begin
   Result := -((ABS(TagetX - X)*400) + (ABS(TagetY - Y)*400)) + volume;
end;


end.
