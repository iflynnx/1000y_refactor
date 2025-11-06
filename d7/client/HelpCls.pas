unit HelpCls;

interface

uses
   Windows, Classes, Forms, Sysutils, Autil32, uCrypt;

type
   THelpRec = record
      filename: array[0..19] of char;
      Pos: integer;
      Size: integer;
   end;
   PHelpRec = ^THelpRec;

   THelpClass = class
   private
      HelpFile: string;
      IndexList: TList;
      procedure ListClear;
      function GetIndexCount: integer;
      function GetItem(index: integer): PHelpRec;
      function GetItemByName(filename: string): PHelpRec;
   public
      constructor Create;
      destructor Destroy; override;

      procedure LoadIndex(const FileName: string);
      procedure LoadHelp(HelpRec: PHelpRec; out Str: string);

      property Count: integer read GetIndexCount;
      property Items[index: integer]: PHelpRec read GetItem; default;
      property Names[filename: string]: PHelpRec read GetItemByName;
   end;

procedure EncryptFiles(const FileName: string; const FileList: TStrings);

implementation

procedure EncryptFiles(const FileName: string; const FileList: TStrings);
var
   IndexFileName: string;
   FileStream, IndexStream: TStream;
   StringData: TStringList;
   SrcStr, DestStr: array[0..1024-1] of char;
   tmpStr: string;
   i, j, len: integer;
   IndexRec: THelpRec;
begin
   IndexFileName := ChangeFileExt(FileName, '.idx');

   FileStream := nil;
   IndexStream := nil;
   StringData := nil;
   try
      FileStream := TFileStream.Create(FileName, fmCreate or fmShareExclusive);
      IndexStream := TFileStream.Create(IndexFileName, fmCreate or fmShareExclusive);
   except
      FileStream.Free;
      IndexStream.Free;
      Application.MessageBox('File Open Error', 'Error', mb_OK);
      exit;
   end;

   try
      StringData := TStringList.Create;
      for i := 0 to FileList.Count-1 do begin
         // Source File Load
         StringData.Clear;
         StringData.LoadFromFile(FileList[i]);

         // Data Encrypt
         for j := 0 to StringData.Count-1 do begin
            Len := Length(StringData[j]);
            StrPCopy(SrcStr, StringData[j]);
            Encryption(@SrcStr, @DestStr, len);
            tmpStr := PChar(@DestStr);
            StringData[j] := tmpStr;
         end;

         // Index Save
         FillChar(IndexRec, SizeOf(THelpRec), 0);
         tmpStr := ExtractFileName(FileList[i]);
         StrPCopy(IndexRec.filename, tmpStr);
         IndexRec.Pos := FileStream.Position;
         IndexRec.Size := Length(StringData.Text);
         IndexStream.Write(IndexRec, SizeOf(THelpRec));

         // Encrypt Data Save
         StringData.SaveToStream(FileStream);
      end;
   finally
      StringData.Free;
      FileStream.Free;
      IndexStream.Free;
   end;
end;

constructor THelpClass.Create;
begin
   inherited;

   IndexList := TList.Create;
end;

destructor THelpClass.Destroy;
begin
   ListClear;
   IndexList.Free;

   inherited;
end;

procedure THelpClass.ListClear;
var
   HelpIndex: PHelpRec;
   i: integer;
begin
   for i:=0 to IndexList.Count-1 do begin
      HelpIndex := IndexList[i];
      Dispose(HelpIndex);
   end;
   IndexList.Clear;
end;

procedure THelpClass.LoadIndex(const FileName: string);
var
   len: integer;
   Stream: TFileStream;
   HelpIndex: THelpRec;
   NewIndex: PHelpRec;
begin
   ListClear;

   try
      Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
   except
      Application.MessageBox('File Open Error', 'Error', MB_OK);
      exit;
   end;
   HelpFile := ChangeFileExt(FileName, '.chp');

   try
      while true do begin
         len := Stream.Read(HelpIndex, SizeOf(THelpRec));
         if len < SizeOf(THelpRec) then break;
         New(NewIndex);
         move(HelpIndex, NewIndex^, SizeOf(THelpRec));
         IndexList.Add(NewIndex);
      end;
   finally
      Stream.Free;
   end;
end;

function THelpClass.GetIndexCount: integer;
begin
   Result := IndexList.Count;
end;

function THelpClass.GetItem(index: integer): PHelpRec;
begin
   Result := nil;
   if IndexList.Count <= index then exit;

   Result := IndexList[index];
end;

function THelpClass.GetItemByName(filename: string): PHelpRec;
var
   i: integer;
begin
   for i := 0 to IndexList.Count-1 do begin
      Result := IndexList[i];
      if StrIComp(PChar(filename), PChar(@Result^.filename)) = 0 then exit;
   end;

   Result := nil;
end;

procedure THelpClass.LoadHelp(HelpRec: PHelpRec; out Str: string);
var
   Stream: TFileStream;
   StrSrc, StrDest: array[0..4096-1] of char;
   tmpStrings: TStringList;
   tmpStr: string;
   i, len: integer;
begin
   if HelpRec = nil then exit;
   fillchar(StrSrc, 4096, 0);
   fillchar(StrDest, 4096, 0);
   try
      Stream := TFileStream.Create(HelpFile, fmOpenRead or fmShareDenyWrite);
   except
      exit;
   end;

   try
      Stream.Seek(HelpRec^.Pos, soFromBeginning);
      Stream.Read(StrSrc, HelpRec^.Size);
      StrSrc[HelpRec^.Size] := #0;
   finally
      Stream.Free;
   end;

   tmpStrings := TStringList.Create;
   tmpStr := PChar(@StrSrc);
   tmpStrings.Text := tmpStr;

   for i := 0 to tmpStrings.Count-1 do begin
      StrPCopy(@StrSrc, tmpStrings[i]);
      len := StrLen(@StrSrc);
      if len > 0 then
         len := Decryption(@StrSrc, @StrDest, len);

      StrDest[len] := #0;
      tmpStr := PChar(@StrDest);
      tmpStrings[i] := tmpStr;
   end;

   Str := tmpStrings.Text;

   tmpStrings.Free;
end;

end.
