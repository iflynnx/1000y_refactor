unit uAcdClass;

interface

uses Windows, Messages, Sysutils, Classes, aUtil32;

const
   ACD_IDENT = 'ACD0';

   ACD_NONE        = 0;
   ACD_OLDCOPY     = 1;    // id(byte) + DataSize (word) + FilePos(integer)
   ACD_CONVANDCOPY = 2;    // id(byte) + DataSize (word) + FilePos(integer) + OldByte(byte) + NewByte(byte)
   ACD_ACDCOPY     = 3;    // id(byte) + DataSize (word)

   DEFAULT_BLOCK_SIZE = 1024;

   DEFAULT_CHECK_SIZE = 4096;

type
  TFileAcdHeader = record
   Id : array [0..8-1] of char;
   AcdCount : integer;
   OldFileSize : integer;
   NewFileSize : integer;
  end;
  PTFileAcdHeader = ^TFileAcdHeader;

  TAcdData = record
   id : byte;
   datasize : word;
   Filepos : integer;
   Oldb, Newb : byte;
   pdata: pbyte;
  end;
  PTAcdData = ^TAcdData;

  TAcdclass = class
  private
   poldBuffer, pNewBuffer : Pbyte;
   oldBuffersize, newBuffersize : integer;
  public
   DataList : TList;
   oc, cc, ac: integer;
   acdsize : integer;
   constructor Create;
   destructor Destroy; override;
   procedure Clear;
   procedure LoadFromStream (aStream: TFileStream);
   procedure SavetoStream (aStream: TFileStream);
   procedure LoadFromfile (afilename: string);
   procedure Savetofile (afilename: string);
   procedure MakeAcdFromFiles (aOldFile, aNewFile: string);
   procedure UpDateFile (aFileName: string);
   procedure Optimize;
   function  CompareFile (aOldFile, aNewFile: string): Boolean;
  end;


implementation

//uses unit1;
uses Dialogs;

constructor TAcdclass.Create;
begin
   DataList := TList.Create;
   pOldBuffer := nil;
   pNewBuffer := nil;
   OldBufferSize := 0;
   NewBufferSize := 0;
end;

destructor TAcdclass.Destroy;
begin
   Clear;
   DataList.Free;
   inherited destroy;
end;

procedure TAcdclass.Clear;
var
   i: integer;
   p : PTAcdData;
begin
   for i := DataList.Count -1 downto 0 do begin
      p := DataList[i];
      if p^.pdata <> nil then FreeMem (p^.pdata);
      dispose (p);
      DataList.Delete (i);
   end;
end;

procedure TAcdclass.LoadFromStream (aStream: TFileStream);
var
   i: integer;
   pmem, pcurb : pbyte;
   Header : TFileAcdHeader;
   pa : PTAcdData;
begin
   Getmem (pmem, aStream.size);
   aStream.ReadBuffer (pmem^, aStream.Size);
   pcurb := pmem;

   move (pcurb^, Header, sizeof(Header)); inc (pcurb, sizeof(TFileAcdHeader));

   if StrlComp (Header.Id, ACD_IDENT, 4) <> 0 then exit;

   oc := 0;
   cc := 0;
   ac := 0;

   for i := 0 to Header.AcdCount -1 do begin
      new (pa);
      FillChar (pa^, sizeof(TAcdData), 0);

      case pcurb^ of
         ACD_OLDCOPY     :
            begin
               inc (oc);
               move (pcurb^, pa^, 7); inc (pcurb, 7);
            end;    // id(byte) + DataSize (word) + FilePos(integer)
         ACD_CONVANDCOPY :
            begin
               inc (cc);
               move (pcurb^, pa^, 9); inc (pcurb, 9);
            end;    // id(byte) + DataSize (word) + FilePos(integer) + OldByte(byte) + NewByte(byte)
         ACD_ACDCOPY     :
            begin
               inc (ac);
               move (pcurb^, pa^, 3); inc (pcurb, 3);
               GetMem (pa^.pdata, pa^.datasize);

               move (pcurb^, pa^.pdata^, pa^.datasize); inc (pcurb, pa^.datasize);
            end;    // id(byte) + DataSize (word)
      end;
      DataList.Add (pa);
   end;
   FreeMem (pmem);
end;

procedure TAcdclass.SavetoStream (aStream: TFileStream);
var
   i: integer;
   Header : TFileAcdHeader;
   pa : PTAcdData;
begin
   Header.Id := ACD_IDENT;
   Header.AcdCount := DataList.Count;
   Header.OldFileSize := OldBufferSize;
   Header.NewFileSize := NewBufferSize;

   aStream.WriteBuffer (Header, sizeof(Header));

   for i := 0 to DataList.Count -1 do begin
      pa := DataList[i];
      case pa^.id of
         ACD_OLDCOPY     :    // id(byte) + DataSize (word) + FilePos(integer)
            begin
               aStream.WriteBuffer (pa^, 7);
            end;
         ACD_CONVANDCOPY :    // id(byte) + DataSize (word) + FilePos(integer) + OldByte(byte) + NewByte(byte)
            begin
               aStream.WriteBuffer (pa^, 9);
            end;
         ACD_ACDCOPY     :    // id(byte) + DataSize (word)
            begin
               aStream.WriteBuffer (pa^, 3);
               aStream.WriteBuffer (pa^.pdata^, pa^.datasize);
            end;
      end;
   end;
end;

procedure TAcdclass.LoadFromFile (afilename: string);
var Stream : TFileStream;
begin
   if not FileExists (aFileName) then exit;
   Clear;
   Stream := TFileStream.Create (aFileName, fmOpenRead);
   LoadFromStream (Stream);
   Stream.Free;
end;

procedure TAcdclass.Savetofile (afilename: string);
var Stream : TFileStream;
begin
   if DataList.Count <= 0 then exit;
   Stream := TFileStream.Create (aFileName, fmCreate);
   SaveToStream (Stream);
   Stream.Free;
end;

procedure TAcdclass.Optimize;
   function Check (idx: integer): Boolean;
   var
      pan, pac : PTAcdData;
   begin
      pan := DataList[idx+1];
      pac := DataList[idx];

      Result := FALSE;
      if pan^.Id <> ACD_OLDCOPY then exit;
      if pac^.Id <> ACD_OLDCOPY then exit;
      if pac^.datasize + pan^.datasize > 32768-1 then exit;

      if pac^.filepos + pac^.datasize = pan^.filepos then begin
         pac^.datasize := pac^.datasize + pan^.datasize;

         dispose (pan);
         DataList.Delete(idx+1);
         Result := TRUE;
      end;

   end;
var
   i, n : integer;
begin
   n := 0;
   for i := 0 to DataList.Count -1 do begin
      if not Check (n) then inc (n);
      if n >= DataList.Count-1 then break;
   end;
end;

function  TAcdclass.CompareFile (aOldFile, aNewFile: string): Boolean;
var
   i, osize, nsize, nb: integer;
   opb,  npb: pbyte;
   ocpb,  ncpb: pbyte;
   Stream : TFileStream;
begin
   Result := FALSE;
   osize := File_Size (aOldFile); if osize <= 0 then exit;
   nsize := File_Size (aNewFile); if nsize <= 0 then exit;
   if osize <> nsize then exit;

   GetMem (opb, osize);
   GetMem (npb, nsize);

   Stream := TFileStream.Create (aOldFile, fmOpenRead);
   Stream.ReadBuffer (opb^, osize);
   Stream.Free;

   Stream := TFileStream.Create (aNewfile, fmOpenRead);
   Stream.ReadBuffer (npb^, nsize);
   Stream.Free;

   nb := osize div 1000;
   ocpb := opb;
   ncpb := npb;
   Result := TRUE;
   for i := 0 to nb -1 do begin
      if not CompareMem (ncpb, ocpb, 1000) then begin
         Result := FALSE;
      end;
      inc (ncpb, 1000);
      inc (ocpb, 1000);
   end;

   if Result = TRUE then begin
      nb := osize mod 1000;
      if nb <> 0 then begin
         if not CompareMem (ncpb, ocpb, nb) then Result := FALSE;
      end;
   end;
   FreeMem (opb);
   FreeMem (npb);
end;

procedure TAcdclass.UpDateFile (aFileName: string);
var
   i, j : integer;
   Stream, MStream : TFileStream;
   pa : PTAcdData;
   tempbuffer : array [0..32768] of byte;
begin
   Sysutils.DeleteFile ('temp.dat');
   ReNameFile (aFileName, 'temp.dat');

   Stream := TFileStream.Create ('temp.dat', fmOpenRead);
   MStream := TFileStream.Create (aFileName, fmCreate);

   for i := 0 to DataList.Count -1 do begin
      pa := DataList[i];
      case pa^.id of
         ACD_OLDCOPY     :
            begin
               Stream.Seek (pa^.filepos, 0);
               Stream.ReadBuffer (tempbuffer, pa^.datasize);
               MStream.WriteBuffer (tempbuffer, pa^.datasize);
            end;
         ACD_CONVANDCOPY :
            begin
               Stream.Seek (pa^.filepos, 0);
               Stream.ReadBuffer (tempbuffer, pa^.datasize);
               for j := 0 to pa^.datasize -1 do if tempbuffer[j] = pa^.Oldb then tempbuffer[j] := pa^.Newb;
               MStream.WriteBuffer (tempbuffer, pa^.datasize);
            end;
         ACD_ACDCOPY     :
            begin
               MStream.WriteBuffer (pa^.pdata^, pa^.datasize);
            end;
      end;
   end;
   MStream.Free;
   Stream.Free;
end;

function GetDiff1byte (np, op: pbyte; cnt: integer; var nb, ob: byte): integer;
var
   i, j: integer;
   flag : Boolean;
   nbuf: array [0..10-1] of byte;
   obuf: array [0..10-1] of byte;
begin
   Result := 0;
   for i := 0 to cnt-1 do begin
      if (np^ <> op^) then begin
         if Result = 0 then begin
            obuf[Result] := op^;
            nbuf[Result] := np^;
            nb := np^;
            ob := op^;
            inc (Result);
         end else begin
            flag := TRUE;
            for j := 0 to Result -1 do begin
               if (np^ = nbuf[j]) and (op^ = obuf[j]) then flag := FALSE;
            end;

            if flag then begin
               obuf[Result] := op^;
               nbuf[Result] := np^;
               inc (Result);
               if Result >= 2 then exit;
            end;
         end;
      end;
      inc (np); inc (op);
   end;
end;

procedure TAcdclass.MakeAcdFromFiles (aOldFile, aNewFile: string);
var
   i, j, k, n, s, e, pos, tempsize, blocksize: integer;
   opb,  npb: pbyte;
   nb, ob, c1, c2: byte;
   Stream : TFileStream;
   pa : PTAcdData;
   tempbuffer : array [0..16384] of byte;

   OldFilePosition : integer;

   label FoundAnAnswer;

begin
   Clear;

   OldBufferSize := File_Size (aOldFile); if OldBufferSize <= 0 then exit;
   NewBufferSize := File_Size (aNewFile); if NewBufferSize <= 0 then exit;

   GetMem (pOldBuffer, OldBufferSize);
   GetMem (pNewBuffer, NewBufferSize);

   Stream := TFileStream.Create (aOldFile, fmOpenRead);
   Stream.ReadBuffer (pOldBuffer^, OldBufferSize);
   Stream.Free;

   Stream := TFileStream.Create (aNewfile, fmOpenRead);
   Stream.ReadBuffer (pNewBuffer^, NewBufferSize);
   Stream.Free;

   tempsize := NewBufferSize;
   npb := pNewBuffer;
   opb := pOldBuffer;
   pos := 0;

   oc := 0;
   cc := 0;
   ac := 0;
   OldFilePosition := 0;

   while tempsize > 0 do begin
      blocksize := DEFAULT_BLOCK_SIZE;
      if tempsize < blocksize then blocksize := tempsize;

      s := pos - DEFAULT_CHECK_SIZE;
      e := pos + DEFAULT_CHECK_SIZE;

      if s < 0 then s := 0;
      if e > OldBufferSize - blocksize-1 then e := OldBufferSize - blocksize-1;

      if s < e then begin
         for j := 0 to 8 do begin
            if blocksize < 16 then break;
            blocksize := blocksize div 2;

            OldFilePosition := 0;
            opb := pOldBuffer;
            inc (opb, s);  inc (OldFilePosition, s);

            for i := s to e do begin
               n := GetDiff1byte (npb, opb, blocksize, nb, ob);
               if n = 0 then goto FoundAnAnswer;
               if n = 1 then begin
                  move (opb^, tempbuffer, blocksize);
                  for k := 0 to blocksize -1 do if tempbuffer[k] = ob then tempbuffer[k] := nb;
                  n := GetDiff1byte (npb, @tempbuffer, blocksize, c1, c2);
                  if n = 0 then goto FoundAnAnswer;
               end;
               inc (opb); inc (OldFilePosition);
            end;
         end;
      end;

FoundAnAnswer:

      new (pa);
      FillChar (pa^, sizeof(TACDData), 0);

      if s < e then begin
         n := GetDiff1byte (npb, opb, blocksize, nb, ob);
         if n = 1 then begin
            move (opb^, tempbuffer, blocksize);
            for k := 0 to blocksize -1 do if tempbuffer[k] = ob then tempbuffer[k] := nb;
            if CompareMem (npb, @tempbuffer, blocksize) then n := 1
            else n := 2;
         end;
      end else n := 2;

      case n of
         0 :
            begin
               inc (oc);
               pa^.Id := ACD_OLDCOPY;
               pa^.filepos := OldFilePosition;

               pa^.datasize := blocksize;
               pa^.pdata := nil;

            end;
         1:
            begin
               inc (cc);
               pa^.Id := ACD_CONVANDCOPY;
               pa^.filepos := OldFilePosition;

               pa^.datasize := blocksize;
               pa^.OldB := ob;
               pa^.NewB := nb;
               pa^.pdata := nil;

            end;
         else begin
               inc (ac);
               pa^.Id := ACD_ACDCOPY;
               pa^.filepos := 0;
               pa^.datasize := blocksize;
               GetMem (pa^.pdata, blocksize);
               move (npb^, pa^.pdata^, blocksize);
         end;
      end;

      DataList.Add (pa);
      inc (npb, blocksize);
      pos := pos + blocksize;
      tempsize := tempsize - blocksize;
   end;
   FreeMem (pOldBuffer);
   FreeMem (pNewBuffer);

   Optimize;

   acdsize := 0;
   for i := 0 to DataList.Count -1 do begin
      pa := DataList[i];
      case pa^.id of
         ACD_OLDCOPY     :
            begin
               inc (acdsize, 7);
            end;
         ACD_CONVANDCOPY :
            begin
               inc (acdsize, 9);
            end;
         ACD_ACDCOPY     :
            begin
               inc (acdsize, 3);
               inc (acdsize, pa^.datasize);
            end;
      end;
   end;
end;


end.
