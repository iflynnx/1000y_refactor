unit ADbClass;

interface

uses
  Windows, Messages, SysUtils, Classes, Dialogs, AUtil32,
  ADbUnit, ADbType;

const
     KINGDBINDEX_ID = 'ATI1';

type
  TDbIndexSortFunction = function (Item1, Item2: Pointer): Integer of object;

  TDbIndexFileHeader = record
     Ident : array[0..3] of char;
     Count : integer;
     DataSize : integer;
     boSavedIndex : Boolean;
     RecordCount : integer;
     None : array [0..28-1] of byte; //None : array [0..32-1] of byte;RecordCount 때문에.. 4바이트 줄임.
  end;

  TDbIndexData = record
    No: integer;
    prdata: pbyte;
  end;
  PTDbIndexData = ^TDbIndexData;

  TDbIndexClass = class
  private
    FName : string;
    FDataSize : integer;
    FTag : integer;
    FBoString : Boolean;
    UsedList, UnUsedList : TList;
    function    IndexCompare (pdata1, pdata2: pbyte): integer;

    function    IndexCompareForSort (pdata1, pdata2: pointer): integer;
    function    FindIndex (apdata: pbyte): integer;
    function    GetCount: integer;
  public
    DataList : TList;
    constructor Create (aName: string; aDataSize: integer; aBoString: Boolean);
    destructor  Destroy; override;
    procedure   Clear;
    procedure   Sort;
    procedure   SaveToIndexFile (aFileName: string; aRCount: integer);
    function    LoadFromIndexFile (aFileName: string; aRCount: integer): Boolean;
    function    Insert (aNo: integer; astr: string): integer;
    procedure   Delete (astr: string);
    function    Select (astr: string): integer;

    function    AddNoSort (aNo: integer; astr: string): integer;

    function    GetIndexString (aindex: integer): string;
    function    GetIndexNo (aindex: integer): integer;

    property    Name: string read FName;
    property    Tag: integer read FTag write FTag;
    property    DataSize: integer read FDataSize;
    property    BoString: Boolean read FBoString;
    property    Count : Integer read GetCount;
  end;

  TKingDbClass = class
  private
   AccessDataSize : integer;
   FRecordCount: integer;
   FFileName : string;
   BufferedFile : TBufferedFile;
   DbFileHeader : TDbFileHeader;

   RecordStartPosition : integer;
   RecordBuffer : array [0..16384-1] of byte;

   function    GetUsedCount: integer;
   procedure   AddIndex (aNo: integer; apb: pbyte);
   procedure   DeleteIndex (apb: pbyte);
   procedure   SetOpened (value: Boolean);
  public
   DbIndexClass: TDbIndexClass;
   constructor Create (aFileName: string; aIndexPos, aIndexLen: integer);
   destructor  Destroy; override;
   procedure   Scaning_Index;
   procedure   SetDataRecordSize (asize: integer);

   procedure   SetFileBufferSize (aBufSize: integer);

   function    SelectRecord (keyname, keydata: string; precord: pbyte): Boolean;
   function    InsertRecord (keyname, keydata: string; precord: pbyte): integer;
   function    DeleteRecord (keyname, keydata: string): Boolean;
   function    UpdateRecord (keyname, keydata: string; precord: pbyte): Boolean;

   function    isPrimarykey (keyname, keydata: string): Boolean;
   function    SelectRecordByNo (aNo: integer; precord: pbyte): Boolean;

   property    RecordCount : integer read FRecordCount;
   property    UsedCount: integer read GetUsedCount;
   property    Opened : Boolean write SetOpened;
   property    FileName : string  read FFileName;
  end;


implementation

function    TDbIndexClass.IndexCompareForSort (pdata1, pdata2: pointer): integer;
var
   i : integer;
   p1, p2 : pbyte;
begin
   p1 := PTDbIndexData (pdata1)^.prdata;
   p2 := PTDbIndexData (pdata2)^.prdata;

   if boString then begin
      Result := 0;
      for i := 0 to DataSize-1 do begin
         Result := p1^ - p2^;
         if Result <> 0 then exit;
         inc (p1); inc (p2);
      end;
   end else begin
      Result := PINTEGER (p1)^ - PINTEGER(p2)^;
   end;
end;

//////////////////////////////////////////////////
//             DbIndexClass
//////////////////////////////////////////////////

constructor TDbIndexClass.Create (aName: string; aDataSize: integer; aBoString: Boolean);
begin
   FName := aname;
   DataList := TList.Create;
   FDataSize := aDataSize;
   FTag := 0;
   FboString := aboString;
   UsedList := TList.Create;
   UnUsedList := TList.Create;
end;

destructor  TDbIndexClass.Destroy;
begin
   Clear;
   UnUsedList.free;
   UsedList.free;
   DataList.Free;
   inherited destroy;
end;

procedure QuickSort(SortList: PPointerList; L, R: Integer;
  SCompare: TDbIndexSortFunction);
var
  I, J: Integer;
  P, T: Pointer;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while SCompare(SortList^[I], P) < 0 do Inc(I);
      while SCompare(SortList^[J], P) > 0 do Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(SortList, L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure TDbIndexClass.Sort;
begin
   if (DataList.List <> nil) and (DataList.Count > 0) then
      QuickSort(DataList.List, 0, DataList.Count - 1, IndexCompareForSort);
end;

function    TDbIndexClass.GetCount: integer;
begin
   Result := DataList.Count;
end;

function   TDbIndexClass.LoadFromIndexFile (aFileName: string; aRCount: integer): Boolean;
var
   i, cnt: integer;
   allocpb, pb : pbyte;
   pi: PTDbIndexData;
   FileHeader : TDbIndexFileHeader;
   Stream : TFileStream;
begin
   Result := FALSE;
   if not FileExists (aFileName) then exit;
   Stream := TFileStream.Create (aFileName, fmOpenReadWrite);
   Stream.ReadBuffer (FileHeader, sizeof(FileHeader));

   if (FileHeader.Ident <> KINGDBINDEX_ID) or (not FileHeader.boSavedIndex) then begin
      Stream.Free;
      exit;
   end;

   if aRCount <> FileHeader.RecordCount then begin
      Stream.Free;
      exit;
   end;

   cnt := (FileHeader.DataSize + 4) * FileHeader.Count + sizeof(FileHeader) + FileHeader.RecordCount;
   if Stream.Size <> cnt then begin
      Stream.Free;
      exit;
   end;

   Result := TRUE;

   Clear;

   FileHeader.boSavedindex := FALSE;
   Stream.Seek (0, soFromBeginning);
   Stream.WriteBuffer (FileHeader, sizeof(FileHeader));

   cnt := (FileHeader.DataSize + 4) * FileHeader.Count;
   GetMem (allocpb, cnt);
   Stream.ReadBuffer (allocpb^, cnt);

   FDataSize := FileHeader.DataSize;

   pb := allocpb;
   for i := 0 to FileHeader.Count -1 do begin
      new (pi);
      getmem (pi^.prdata, FDataSize);
      FillChar (pi^.prdata^, FDataSize, 0);

      move (pb^, pi^.No, 4);                inc (pb, 4);
      move (pb^, pi^.prdata^, FDataSize);   inc (pb, FDataSize);
      DataList.Add (pi);
   end;
   FreeMem (allocpb, cnt);


   GetMem (allocpb, FileHeader.RecordCount);
   Stream.ReadBuffer (allocpb^, FileHeader.RecordCount);
   pb := allocpb;
   for i := 0 to FileHeader.RecordCount-1 do begin
      if pb^ = 1 then UsedList.Add (Pointer(i))
      else UnUsedList.Add (Pointer(i));
      inc (pb);
   end;
   FreeMem (allocpb);

   Stream.Free;
end;

procedure   TDbIndexClass.SaveToIndexFile (aFileName: string; aRCount: integer);
var
   i, cnt: integer;
   allocpb, pb : pbyte;
   pi : PTDbIndexData;
   FileHeader : TDbIndexFileHeader;
   Stream : TFileStream;
begin
   FillChar (FileHeader, sizeof(TDbIndexFileHeader), 0);
   FileHeader.Ident := KINGDBINDEX_ID;
   FileHeader.Count := DataList.Count;
   FileHeader.DataSize := FDataSize;
   FileHeader.boSavedindex := TRUE;
   FileHeader.RecordCount := aRCount;

   if FileExists (aFileName) then DeleteFile (aFileName);
   Stream := TFileStream.Create (aFileName, fmCreate);
   Stream.WriteBuffer (FileHeader, sizeof(FileHeader));

   if DataList.Count > 0 then begin

      cnt := (FDataSize + 4) * DataList.Count;
      GetMem (allocpb, cnt);
      pb := allocpb;
      for i := 0 to DataList.Count -1 do begin
         pi := DataList[i];
         move (pi^.No, pb^, 4);                inc (pb, 4);
         move (pi^.prdata^, pb^, FDataSize);   inc (pb, FDataSize);
      end;
      Stream.WriteBuffer (allocpb^, cnt);
      FreeMem (allocpb, cnt);

   end;


   GetMem (allocpb, aRCount);
   FillChar (allocpb^, aRCount, 0);

   for i := 0 to UsedList.Count -1 do begin
      pb := allocpb;
      inc (pb, integer (UsedList[i]));
      pb^ := 1;
   end;
   Stream.WriteBuffer (allocpb^, aRCount);
   FreeMem (allocpb);

   Stream.Free;
end;

procedure   TDbIndexClass.Clear;
var i: integer;
begin
   for i := DataList.Count-1 downto 0 do begin
      FreeMem (PTDbIndexData (DataList[i])^.prdata);
      dispose (DataList[i]);
      DataList.Delete (i);
   end;
   UsedList.Clear;
   UnUsedList.Clear;
end;

function    TDbIndexClass.IndexCompare (pdata1, pdata2: pbyte): integer;
var i : integer;
begin
   if boString then begin
      Result := 0;
      for i := 0 to DataSize-1 do begin
         Result := pdata1^ - pdata2^;
         if Result <> 0 then exit;
         inc (pdata1); inc (pdata2);
      end;
   end else begin
      Result := PINTEGER (pdata1)^ - PINTEGER(pdata2)^;
   end;
end;

function    TDbIndexClass.FindIndex (apdata: pbyte): integer;
var
   i, ret, lpos, hpos, cpos: integer;
begin
   Result := -1;
   if DataList.Count = 0 then exit;

   hpos := DataList.Count-1;
   lpos := 0;
   cpos := (lpos+hpos) div 2;

   for i := 0 to 32-1 do begin
      ret := IndexCompare (apdata, PTDbIndexData (DataList[cpos])^.prdata);
      if ret = 0 then begin Result := cpos; exit; end;

      if ret > 0 then lpos := cpos
      else hpos := cpos;
      cpos := (lpos + hpos) div 2;

      if hpos - lpos < 3 then break;
   end;

   for i := lpos to hpos do begin
      ret := IndexCompare (apdata, PTDbIndexData (DataList[i])^.prdata );
      if ret = 0 then begin Result := i; exit; end;
   end;
end;

function   TDbIndexClass.Insert (aNo: integer; astr: string): integer;
   function    FindIndex2 (apdata: pbyte): integer;
   var
      i, ret, lpos, hpos, cpos: integer;
   begin
      Result := 0;
      if DataList.Count = 0 then exit;

      hpos := DataList.Count-1;
      lpos := 0;
      cpos := (lpos+hpos) div 2;

      for i := 0 to 32-1 do begin
         ret := IndexCompare (apdata, PTDbIndexData (DataList[cpos])^.prdata);
         if ret > 0 then lpos := cpos
         else hpos := cpos;
         cpos := (lpos + hpos) div 2;

         if hpos - lpos < 3 then break;
      end;

      hpos := hpos + 1;   // 5
      lpos := lpos - 1;   // 5
      if hpos >= DataList.Count then hpos := DataList.Count -1;
      if lpos < 0 then lpos := 0;

      for i := lpos to hpos do begin
         ret := IndexCompare (apdata, PTDbIndexData (DataList[i])^.prdata );
         if ret < 0 then begin Result := i; exit; end;
      end;
      Result := DataList.Count;
   end;
var
   pid : PTDbIndexData;
begin
   new (pid);
   getmem (pid^.prdata, DataSize+2);

   pid^.No := aNo;
   FillChar (pid^.prdata^, DataSize+2, 0);
   if boString then StrPcopy (pchar (pid^.prdata), astr)
   else PINTEGER (pid^.prdata)^ := _StrToInt (astr);

   Result := FindIndex2 (pid^.prdata);
   if Result <> DataList.Count then DataList.insert (Result, pid)
   else DataList.Add (pid);
end;

function    TDbIndexClass.AddNoSort (aNo: integer; astr: string): integer;
var
   pid : PTDbIndexData;
begin
   new (pid);
   getmem (pid^.prdata, DataSize+2);

   pid^.No := aNo;
   FillChar (pid^.prdata^, DataSize+2, 0);

   if Length (astr) > DataSize then astr := copy (astr, 1, DataSize);

   if boString then StrPcopy (pchar (pid^.prdata), astr)
   else PINTEGER (pid^.prdata)^ := _StrToInt (astr);
   Result := DataList.Add (pid);
end;

procedure   TDbIndexClass.Delete (astr: string);
var
   index: integer;
   temp : array [0..256-1] of byte;
begin
   FillChar (temp, DataSize, 0);
   if boString then StrPCopy (@temp, astr)
   else PINTEGER (@Temp)^ := _StrToInt (astr);

   index := FindIndex (@temp);
   if index <> -1 then begin
      FreeMem (PTDbIndexData (DataList[index])^.prdata);
      dispose (DataList[index]);
      DataList.Delete (index);
   end;
end;

function    TDbIndexClass.Select (astr: string): integer;
var
   index: integer;
   temp : array [0..256-1] of byte;
begin
   FillChar (temp, DataSize, 0);
   if boString then StrPCopy (@temp, astr)
   else PINTEGER (@Temp)^ := _StrToInt (astr);

   Result := -1;
   index := FindIndex (@temp);
   if index = -1 then exit;
   Result := PTDbIndexData (DataList[index])^.No;
end;

function    TDbIndexClass.GetIndexString (aindex: integer): string;
var pd : PTDbIndexData;
begin
   Result := '';
   if aindex < 0 then exit;
   if aindex >= DataList.Count then exit;
   pd := DataList[aindex];

   if boString then begin
      Result := StrPas (pchar (pd^.prdata) );
   end else begin
      Result := IntToStr ( PINTEGER (pd^.prdata)^ );
   end;
end;

function    TDbIndexClass.GetIndexNo (aindex: integer): integer;
var pd : PTDbIndexData;
begin
   Result := -1;
   if aindex < 0 then exit;
   if aindex >= DataList.Count then exit;
   pd := DataList[aindex];

   Result := pd^.No;
end;

{
function    GetHashNumber (astr: string): integer;
var i, n: integer;
begin
   n := 0;
   for i := 1 to Length(astr) do n := n + word (astr[i]);
   Result := n mod 8;
end;
}
//////////////////////////////////////////////////
//             KingDbClass
//////////////////////////////////////////////////

constructor TKingDbClass.Create (aFileName: string; aIndexPos, aIndexLen: integer);
var
   idxname: string;
begin
   BufferedFile := TBufferedFile.Create (aFileName);
   FFileName := aFileName;
   BufferedFile.ReadBuffer (0, sizeof(DbFileHeader), @DbFileHeader);

   FRecordCount := DbFileHeader.RecordCount;
   AccessDataSize := DbFileHeader.RecordDataSize;

   RecordStartPosition := sizeof(DbFileHeader);
   FillChar (RecordBuffer, sizeof(RecordBuffer), 0);

   DbIndexClass := TDbIndexClass.Create ('primarykey', aIndexLen, TRUE);
   DbIndexClass.Tag := aIndexPos;

   idxname := ChangeFileExt (aFileName, '.idx');

   if DbFileHeader.boSavedIndex then begin
      if not DbIndexClass.LoadFromIndexFile (idxname, DbFileHeader.RecordCount) then Scaning_Index;
   end else begin
      Scaning_Index;
   end;

   DbFileHeader.boSavedIndex := FALSE;
   BufferedFile.WriteBuffer (0, sizeof(DbFileHeader), @DbFileHeader);
   DeleteFile (idxname);
end;

destructor  TKingDbClass.Destroy;
var
   idxname: string;
begin
   idxname := ChangeFileExt (FFileName, '.idx');
   DbIndexClass.SaveToIndexFile (idxname, DbFileHeader.RecordCount);
   DbIndexClass.Free;
   
   DbFileHeader.boSavedIndex := TRUE;
   BufferedFile.WriteBuffer (0, sizeof(DbFileHeader), @DbFileHeader);
   BufferedFile.Free;
   inherited destroy;
end;

procedure   TKingDbClass.SetFileBufferSize (aBufSize: integer);
begin
   BufferedFile.SetBufferSize (aBufSize);
end;

procedure   TKingDbClass.SetOpened (value: Boolean);
begin
   BufferedFile.Opened := value;
end;

function    TKingDbClass.GetUsedCount: integer;
begin
   Result := DbIndexclass.UsedList.Count;
end;

procedure   TKingDbClass.SetDataRecordSize (asize: integer);
begin
   if asize < DbFileHeader.RecordDataSize then AccessDataSize := asize;
end;

{
procedure   TKingDbClass.Scaning_Index;
var
   i, n : integer;
   pb : pbyte;
begin
   DbIndexClass.UsedList.Clear;
   DbIndexClass.UnUsedList.Clear;
   DbIndexClass.Clear;
   BufferedFile.SetBufferSize (30000000);

   for i := 0 to DbFileHeader.RecordCount-1 do begin
      n := RecordStartPosition + i * DbFileHeader.RecordSize;
      BufferedFile.ReadBuffer (n, DbFileHeader.RecordSize, @RecordBuffer);
      if RecordBuffer[0] = 0 then begin DbIndexClass.UnUsedList.Add (Pointer (i)); continue; end;
      DbIndexClass.UsedList.Add (Pointer(i));
      pb := @RecordBuffer; inc (pb);
      AddIndex (i, pb);
   end;
   BufferedFile.SetBufferSize (4096);
end;
}

procedure   TKingDbClass.Scaning_Index;
var
   i, n : integer;
//   nilcount : integer;
   pb : pbyte;
   str: string;
begin

   DbIndexClass.UsedList.Clear;
   DbIndexClass.UnUsedList.Clear;
   DbIndexClass.Clear;
   BufferedFile.SetBufferSize (30000000);

//   nilcount := 0;
   for i := 0 to DbFileHeader.RecordCount-1 do begin
      n := RecordStartPosition + i * DbFileHeader.RecordSize;
      BufferedFile.ReadBuffer (n, DbFileHeader.RecordSize, @RecordBuffer);
      if RecordBuffer[0] = 0 then begin DbIndexClass.UnUsedList.Add (Pointer (i)); continue; end;
      DbIndexClass.UsedList.Add (Pointer(i));
      pb := @RecordBuffer; inc (pb);

      inc (pb, DbIndexClass.Tag);
      if DbIndexClass.boString then str := StrPas (pchar(pb))
      else str := IntToStr (PINTEGER (pb)^);

      if Length (str) > DbIndexClass.DataSize then begin
         str := Copy (str, 1, DbIndexClass.DataSize);
      end;

      DbIndexClass.AddNoSort (i, str);
//      if Str = '' then inc (nilCount);
   end;

   DbIndexClass.Sort;

   BufferedFile.SetBufferSize (4096);
end;

procedure   TKingDbClass.AddIndex (aNo: integer; apb: pbyte);
var
   pb : pbyte;
   str: string;
begin
   pb := apb;
   inc (pb, DbIndexClass.Tag);
   if DbIndexClass.boString then str := StrPas (pchar(pb))
   else str := IntToStr (PINTEGER (pb)^);
   DbIndexClass.Insert (aNo, str);
end;

procedure   TKingDbClass.DeleteIndex (apb: pbyte);
var
   pb : pbyte;
   str: string;
begin
   pb := apb;
   inc (pb, DbIndexClass.Tag);

   if DbIndexClass.boString then str := StrPas (pchar(pb))
   else str := IntToStr ( PINTEGER (pb)^);

   DbIndexClass.Delete (str);
end;

function    TKingDbClass.SelectRecordByNo (aNo: integer; precord: pbyte): Boolean;
var
   n : integer;
begin
//   Result := FALSE;
   n := RecordStartPosition + aNo * DbFileHeader.RecordSize;
   BufferedFile.ReadBuffer (n, DbFileHeader.RecordSize, @RecordBuffer);
   move (RecordBuffer[1], precord^, AccessDataSize);
   Result := TRUE;
end;

function    TKingDbClass.SelectRecord (keyname, keydata: string; precord: pbyte): Boolean;
var
   n, No : integer;
begin
   Result := FALSE;

   No := DbIndexClass.Select (keydata);
   if No = -1 then exit;

   n := RecordStartPosition + No * DbFileHeader.RecordSize;
   BufferedFile.ReadBuffer (n, DbFileHeader.RecordSize, @RecordBuffer);
   move (RecordBuffer[1], precord^, AccessDataSize);
   Result := TRUE;
end;

function    TKingDbClass.InsertRecord (keyname, keydata: string; precord: pbyte): integer;
var
   n, No : integer;
   pb : pbyte;
begin
   Result := -1;
   if DbIndexClass.UnUsedList.Count = 0 then exit;

   No := Integer ((DbIndexClass.UnusedList[0]));
   DbIndexClass.UnUsedList.Delete (0);
   DbIndexClass.UsedList.Add (Pointer(No));
   Move (precord^, RecordBuffer[1], AccessDataSize);
   RecordBuffer[0] := 1;

   n := RecordStartPosition + No * DbFileHeader.RecordSize;
   BufferedFile.WriteBuffer (n, DbFileHeader.RecordSize, @RecordBuffer);
   Result := No;

   pb := @RecordBuffer; inc (pb);
   AddIndex (No, pb);
end;

function    TKingDbClass.DeleteRecord (keyname, keydata: string): Boolean;
var
   i, n, No : integer;
   pb : pbyte;
begin
   Result := FALSE;

   No := DbIndexClass.Select (keydata);
   if No = -1 then exit;

   n := RecordStartPosition + No * DbFileHeader.RecordSize;
   BufferedFile.ReadBuffer (n, DbFileHeader.RecordSize, @RecordBuffer);
   pb := @RecordBuffer; inc (pb);
   DeleteIndex (pb);

   FillChar (RecordBuffer, sizeof(RecordBuffer), 0);
   BufferedFile.WriteBuffer (n, DbFileHeader.RecordSize, @RecordBuffer);

   for i := 0 to DbIndexClass.UsedList.Count -1 do begin
      if Integer (DbIndexClass.UsedList[i]) = no then begin
         DbIndexClass.UsedList.Delete (i);
         break;
      end;
   end;

   DbIndexClass.UnUsedList.Add (Pointer(No));
   Result := TRUE;
end;

function    TKingDbClass.UpDateRecord (keyname, keydata: string; precord: pbyte): Boolean;
var n, No : integer;
begin
   Result := FALSE;

   No := DbIndexClass.Select (keydata);
   if No = -1 then exit;

   n := RecordStartPosition + No * DbFileHeader.RecordSize;
   RecordBuffer[0] := 1;
   move (precord^, RecordBuffer[1], AccessDataSize);
   BufferedFile.WriteBuffer (n, DbFileHeader.RecordSize, @RecordBuffer);
   Result := TRUE;
end;

function    TKingDbClass.isPrimarykey (keyname, keydata: string): Boolean;
var No : integer;
begin
   Result := FALSE;
   No := DbIndexClass.Select (keydata);
   if No = -1 then exit;
   Result := TRUE;
end;

end.
