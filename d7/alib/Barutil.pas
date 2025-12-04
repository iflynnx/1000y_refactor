unit barutil;

interface

uses
	Windows, classes, aDefType, Dialogs, SysUtils;

const
	CSENDCHAR = 10;
	CSENDCHAR2 = 13;

	COMDATASIZE = 4096;

   COMBUFFERSIZE = 32768;
   ALLOC_COMBUFFERSIZE = COMBUFFERSIZE+COMDATASIZE;
   SIZEARR_SIZE = 1000;


   BIG_COMBUFFERSIZE = 2048000;
   BIG_ALLOC_COMBUFFERSIZE = BIG_COMBUFFERSIZE+COMDATASIZE;
   BIG_SIZEARR_SIZE = 10000;

   BUFFERCLASS_BUFFERSIZE = 8192;
   BIG_BUFFERCLASS_BUFFERSIZE = 2048000;

type
	TWouldBlock = record
   	cnt : integer;
      data : array [0..8192] of byte;
   end;
   PTWouldBlock = ^TWouldBlock;

//	TComData = record
//   	cnt : integer;
//      data : array [0..COMDATASIZE] of byte;
//   end;
//   PTComData = ^TComData;

 TComDataList = class
  private
   {
   InDataPos, OutDataPos : integer;
   InArr, OutArr : integer;
   Buffer : array [0..ALLOC_COMBUFFERSIZE-1] of byte;
   SizeArr : array [0..SIZEARR_SIZE-1] of word;
   }

   DataList : TList;

   WouldBlock : TWouldBlock;
   function GetIsRemain : Boolean;
  public
   constructor Create;
   destructor Destroy; override;
   procedure Clear;
   // procedure AddComData  ( len : integer; PData : PByte);
   function  AddComData  ( len : integer; PData : PByte) : Integer;
   function  GetComData  ( var Cdata : TComData): Boolean;
   function  GetWouldBlock (var WBlock:TWouldBlock): Boolean;
   procedure SetWouldBlock (var WBlock:TWouldBlock);
   procedure ClearWouldBlock;
   property  IsRemain : Boolean read GetIsRemain;
 end;

 TBigComDataList = class
  private
   InDataPos, OutDataPos : integer;
   InArr, OutArr : integer;
   Buffer : array [0..BIG_ALLOC_COMBUFFERSIZE-1] of byte;
   SizeArr : array [0..BIG_SIZEARR_SIZE-1] of word;
   WouldBlock : TWouldBlock;
   function GetIsRemain : Boolean;
  public
   constructor Create;
   destructor Destroy; override;
   procedure Clear;
   procedure AddComData  ( len : integer; PData : PByte);
   function  GetComData  ( var Cdata : TComData): Boolean;
   function  GetWouldBlock (var WBlock:TWouldBlock): Boolean;
   procedure SetWouldBlock (var WBlock:TWouldBlock);
   procedure ClearWouldBlock;
   property  IsRemain : Boolean read GetIsRemain;
 end;

   TBufferClass = class
    private
     Buffer : Array [0..BUFFERCLASS_BUFFERSIZE-1] of byte;
     GetPos, AddPos: integer;
     EndPos : integer;
     function    GetCount: integer;
    public
     constructor Create;
     destructor  Destroy; override;
     function    Add (cnt:integer; pb:pbyte):Boolean;
     procedure   Clear;
     function    Get (asize:integer; pb:pbyte):integer;
     function    View (asize:integer; pb:pbyte):integer;
     property    Count : integer read GetCount;
   end;

   TBigBufferClass = class
    private
     Buffer : Array [0..BIG_BUFFERCLASS_BUFFERSIZE-1] of byte;
     GetPos, AddPos: integer;
     EndPos : integer;
     function    GetCount: integer;
    public
     constructor Create;
     destructor  Destroy; override;
     function    Add (cnt:integer; pb:pbyte):Boolean;
     procedure   Clear;
     function    Get (asize:integer; pb:pbyte):integer;
     function    View (asize:integer; pb:pbyte):integer;
     property    Count : integer read GetCount;
   end;


function  BaramGatherData (var cdata : TComData; ch : byte): Boolean;
procedure BaramEncoding (var sour, dest : TComData);
procedure BaramDecoding (var sour, dest : TComData);

procedure BaramDbEncoding (var sour, dest : TComData);
procedure BaramDbDecoding (var sour, dest : TComData);

procedure Reverse4Bit (var code : TComData);

implementation

//uses
//   svMain;

var
   ComDataMaxValue : Integer = -1;
   ComDataCurValue : Integer = -1;

/////////////////////////////////////
//         TBufferClass
/////////////////////////////////////
constructor TBufferClass.Create;
begin
   Endpos := 0;
   GetPos := 0; AddPos := 0;
end;

destructor TBufferClass.Destroy;
begin
   inherited destroy;
end;

procedure TBufferClass.Clear;
begin
   Endpos := 0;
   GetPos := 0; AddPos := 0;
end;

function  TBufferClass.GetCount: integer;
var TempAddPos, TempGetPos: integer;
begin
   TempAddPos := AddPos; TempGetPos := GetPos;
   Result := 0;
   if TempAddPos > TempGetPos then Result := TempAddPos - TempGetPos;
   if TempAddPos < TempGetPos then Result := TempAddPos - TempGetPos + BUFFERCLASS_BUFFERSIZE;
end;

function  TBufferClass.Add (cnt: integer; pb: pbyte): Boolean;
var
   boErrorFlag : Boolean;
begin
   Result := TRUE;

   // if (AddPos + cnt - BUFFERCLASS_BUFFERSIZE) >= GetPos then begin Result := FALSE; exit; end;

   boErrorFlag := false;
   if Cnt = 0 then boErrorFlag := true;
   if AddPos > GetPos then begin
      if AddPos + Cnt >= BUFFERCLASS_BUFFERSIZE then begin
         if AddPos + Cnt - BUFFERCLASS_BUFFERSIZE >= GetPos then begin
            boErrorFlag := true;
         end;
      end;
   end else if AddPos < GetPos then begin
      if AddPos + Cnt >= GetPos then begin
         boErrorFlag := true;
      end;
   end;

   if boErrorFlag = true then begin
//      FrmMain.WriteLogInfo (Format('TBufferClass Overflow AddPos[%d] GetPos[%d] Count[%d]', [AddPos, GetPos, Cnt]));
      Exit;
   end;

   {
   if AddPos + Cnt <= BUFFERCLASS_BUFFERSIZE then begin
      Move (pb^, Buffer[AddPos], Cnt);
   end else begin
      Move (pb^, Buffer[AddPos], BUFFERCLASS_BUFFERSIZE - AddPos);
      Inc (pb, BUFFERCLASS_BUFFERSIZE - AddPos);
      Move (pb^, Buffer[0], Cnt - (BUFFERCLASS_BUFFERSIZE - AddPos));
   end;

   if AddPos + Cnt < BUFFERCLASS_BUFFERSIZE then AddPos := AddPos + Cnt
   else if AddPos + Cnt >= BUFFERCLASS_BUFFERSIZE then
      AddPos := AddPos + Cnt - BUFFERCLASS_BUFFERSIZE;
   }

   if AddPos + cnt <= BUFFERCLASS_BUFFERSIZE then begin
      move (pb^, buffer[Addpos], cnt);
   end else begin
      move (pb^, buffer[addpos], BUFFERCLASS_BUFFERSIZE - addpos);
      inc (pb, BUFFERCLASS_BUFFERSIZE - addpos);
      move (pb^, buffer[0], cnt - (BUFFERCLASS_BUFFERSIZE - addpos));
   end;

   if AddPos + cnt < BUFFERCLASS_BUFFERSIZE then begin AddPos := AddPos + cnt; exit; end;
   if AddPos + cnt = BUFFERCLASS_BUFFERSIZE then begin AddPos := 0; exit; end;
   if AddPos + cnt > BUFFERCLASS_BUFFERSIZE then begin
      AddPos := AddPos + cnt - BUFFERCLASS_BUFFERSIZE;
      exit;
   end;
end;

function  TBufferClass.Get (asize: integer; pb: pbyte): integer;
var
   TempAddPos: integer;
   CurCnt : integer;
begin
   Result := 0;

   if asize = 0 then begin
//      frmMain.WriteLogInfo('TBufferClass.pas aSize = 0 Except');
      exit;
   end;

   CurCnt := 0;
   TempAddPos := AddPos; GetPos := GetPos;
   if TempAddPos > GetPos then CurCnt := TempAddPos - GetPos;
   if TempAddPos < GetPos then CurCnt := TempAddPos - GetPos + BUFFERCLASS_BUFFERSIZE;
   if CurCnt = 0 then exit;

   if CurCnt < asize then begin
      asize := CurCnt;
//      frmMain.WriteLogInfo('TBufferClass.pas NotEnough Data Except');
      exit;
   end;
   Result := asize;

   if GetPos + asize <= BUFFERCLASS_BUFFERSIZE then begin
      move (buffer[GetPos], pb^, asize);
   end else begin
      move (buffer[GetPos], pb^, BUFFERCLASS_BUFFERSIZE - GetPos);
      inc (pb, BUFFERCLASS_BUFFERSIZE - GetPos);
      move (buffer[0], pb^, asize - (BUFFERCLASS_BUFFERSIZE - GetPos) );
   end;

   if GetPos + asize < BUFFERCLASS_BUFFERSIZE then begin GetPos := GetPos + asize; exit; end;
   if GetPos + asize = BUFFERCLASS_BUFFERSIZE then begin GetPos := 0; exit; end;
   if GetPos + asize > BUFFERCLASS_BUFFERSIZE then begin
      GetPos := GetPos + asize - BUFFERCLASS_BUFFERSIZE;
      exit;
   end;
end;

function  TBufferClass.View (asize: integer; pb: pbyte): integer;
var
   TempGetPos: integer;
begin
   Result := 0;
   FillChar (pb^, asize, 0);
   if asize >= BUFFERCLASS_BUFFERSIZE then exit;

   TempGetPos := GetPos;
   if TempGetPos + asize <= BUFFERCLASS_BUFFERSIZE then begin
      move (buffer[TempGetPos], pb^, asize);
   end else begin
      move (buffer[TempGetPos], pb^, BUFFERCLASS_BUFFERSIZE - TempGetPos);
      inc (pb, BUFFERCLASS_BUFFERSIZE - TempGetPos);
      move (buffer[0], pb^, asize - (BUFFERCLASS_BUFFERSIZE - TempGetPos) );
   end;
   Result := asize;
end;

/////////////////////////////////////
//         TBigBufferClass
/////////////////////////////////////
constructor TBigBufferClass.Create;
begin
   endpos := 0;
   GetPos := 0; AddPos := 0;
end;

destructor TBigBufferClass.Destroy;
begin
   inherited destroy;
end;

procedure TBigBufferClass.Clear;
begin
   Endpos := 0;
   GetPos := 0; AddPos := 0;
end;

function  TBigBufferClass.GetCount: integer;
var TempAddPos, TempGetPos: integer;
begin
   TempAddPos := AddPos; TempGetPos := GetPos;
   Result := 0;
   if TempAddPos > TempGetPos then Result := TempAddPos - TempGetPos;
   if TempAddPos < TempGetPos then Result := TempAddPos - TempGetPos + BIG_BUFFERCLASS_BUFFERSIZE;
end;

function  TBigBufferClass.Add (cnt: integer; pb: pbyte): Boolean;
var
   boErrorFlag : Boolean;
begin
   Result := TRUE;

   if (AddPos + cnt - BIG_BUFFERCLASS_BUFFERSIZE) >= GetPos then begin Result := FALSE; exit; end;

   boErrorFlag := false;
   if Cnt = 0 then boErrorFlag := true;
   if AddPos > GetPos then begin
      if AddPos + Cnt >= BIG_BUFFERCLASS_BUFFERSIZE then begin
         if AddPos + Cnt - BIG_BUFFERCLASS_BUFFERSIZE >= GetPos then begin
            boErrorFlag := true;
         end;
      end;
   end else if AddPos < GetPos then begin
      if AddPos + Cnt >= GetPos then begin
         boErrorFlag := true;
      end;
   end;

   if boErrorFlag = true then begin
//      FrmMain.WriteLogInfo (Format('TBigBufferClass Overflow AddPos[%d] GetPos[%d] Count[%d]', [AddPos, GetPos, Cnt]));
      Exit;
   end;

   if AddPos + cnt <= BIG_BUFFERCLASS_BUFFERSIZE then begin
      move (pb^, buffer[Addpos], cnt);
   end else begin
      move (pb^, buffer[addpos], BIG_BUFFERCLASS_BUFFERSIZE - addpos);
      inc (pb, BIG_BUFFERCLASS_BUFFERSIZE - addpos);
      move (pb^, buffer[0], cnt - (BIG_BUFFERCLASS_BUFFERSIZE - addpos));
   end;

   if AddPos + cnt < BIG_BUFFERCLASS_BUFFERSIZE then begin AddPos := AddPos + cnt; exit; end;
   if AddPos + cnt = BIG_BUFFERCLASS_BUFFERSIZE then begin AddPos := 0; exit; end;
   if AddPos + cnt > BIG_BUFFERCLASS_BUFFERSIZE then begin
      AddPos := AddPos + cnt - BIG_BUFFERCLASS_BUFFERSIZE;
      exit;
   end;
end;

function  TBigBufferClass.Get (asize: integer; pb: pbyte): integer;
var
   TempAddPos: integer;
   CurCnt : integer;
begin
   Result := 0;
   CurCnt := 0;
   TempAddPos := AddPos; GetPos := GetPos;
   if TempAddPos > GetPos then CurCnt := TempAddPos - GetPos;
   if TempAddPos < GetPos then CurCnt := TempAddPos - GetPos + BIG_BUFFERCLASS_BUFFERSIZE;
   if CurCnt = 0 then exit;

   if CurCnt < asize then asize := CurCnt;
   Result := asize;

   if GetPos + asize <= BIG_BUFFERCLASS_BUFFERSIZE then begin
      move (buffer[GetPos], pb^, asize);
   end else begin
      move (buffer[GetPos], pb^, BIG_BUFFERCLASS_BUFFERSIZE - GetPos);
      inc (pb, BIG_BUFFERCLASS_BUFFERSIZE - GetPos);
      move (buffer[0], pb^, asize - (BIG_BUFFERCLASS_BUFFERSIZE - GetPos) );
   end;

   if GetPos + asize < BIG_BUFFERCLASS_BUFFERSIZE then begin GetPos := GetPos + asize; exit; end;
   if GetPos + asize = BIG_BUFFERCLASS_BUFFERSIZE then begin GetPos := 0; exit; end;
   if GetPos + asize > BIG_BUFFERCLASS_BUFFERSIZE then begin
      GetPos := GetPos + asize - BIG_BUFFERCLASS_BUFFERSIZE;
      exit;
   end;
end;

function  TBigBufferClass.View (asize: integer; pb: pbyte): integer;
var
   TempGetPos: integer;
begin
   Result := 0;
   FillChar (pb^, asize, 0);
   if asize >= BIG_BUFFERCLASS_BUFFERSIZE then exit;

   TempGetPos := GetPos;
   if TempGetPos + asize <= BIG_BUFFERCLASS_BUFFERSIZE then begin
      move (buffer[TempGetPos], pb^, asize);
   end else begin
      move (buffer[TempGetPos], pb^, BIG_BUFFERCLASS_BUFFERSIZE - TempGetPos);
      inc (pb, BIG_BUFFERCLASS_BUFFERSIZE - TempGetPos);
      move (buffer[0], pb^, asize - (BIG_BUFFERCLASS_BUFFERSIZE - TempGetPos) );
   end;
   Result := asize;
end;



/////////////////////////////////////
//         TComDataList
/////////////////////////////////////

constructor TComDataList.Create;
begin
   {
   InDatapos := 0; OutDataPos := 0;
   InArr := 0; OutArr := 0;
   FillChar (Buffer, sizeof(Buffer), 0);
   FillChar (SizeArr, sizeof(SizeArr), 0);
   }
   DataList := TList.Create;
end;

destructor TComDataList.Destroy;
begin
   Clear;
   DataList.Free;
   inherited Destroy;
end;

// procedure TComDataList.AddComData ( len : integer; PData : PByte);
function TComDataList.AddComData ( len : integer; PData : PByte) : Integer;
var
   pd : PTComData;
begin
   if (len <= 0) or (len > COMDATASIZE) then begin
      Result := 1000;
      exit;
   end;

   pd := nil;
   try
      New (pd);
      pd^.cnt := len;
      Move(PData^, pd^.data, len);

      DataList.Add(pd);

      if (ComDataMaxValue < DataList.Count) or (ComDataMaxValue = -1) then begin
         ComDataMaxValue := DataList.Count;
//         frmMain.lblMax.Caption := 'MAX : ' + IntToStr(ComDataMaxValue);
      end;
   except
      if pd <> nil then Dispose (pd);
   end;

   Result := DataList.Count;
   {
   bFlag := true;
   if (OutArr = 0) and (InArr = SIZEARR_SIZE - 1) then begin
      bFlag := false;
   end else if InArr = OutArr - 1 then begin
      bFlag := false;
   end;

   if bflag = false then begin
      // FrmMain.WriteLogInfo('TGS1000 BarUtil.pas AddComData Except');
      exit;
   end;

   if (OutDataPos > InDataPos) and (InDataPos + len >= OutDataPos) then begin
      // FrmMain.WriteLogInfo('TGS1000 BarUtil.pas AddComData Stack Overflow');
      exit;
   end;

   SizeArr[InArr] := len;
   move (pdata^, Buffer[InDataPos] , len);

   InDataPos := InDataPos + len;
   if InDataPos >= COMBUFFERSIZE then InDataPos := 0;

   InArr := InArr+1;
   if InArr >= SIZEARR_SIZE then InArr := 0;
   }
end;

function  TComDataList.GetComData  ( var Cdata : TComData): Boolean;
var
   pd : PTComData;
begin
   Result := false;
   if DataList.Count = 0 then exit;

   try
      pd := DataList.Items[0];
      Move (pd^, CData, SizeOf(TComData));
      DataList.Delete (0);
      Dispose (pd);
   except
      exit;
   end;

   Result := true;

   {
   Result := FALSE;
   if OutArr = InArr then exit;

   CData.cnt := SizeArr[OutArr];
   move (Buffer[OutDataPos] , CDAta.Data, SizeArr[OutArr]);
   CDAta.Data[CData.cnt] := 0;

   OutDataPos := OutDataPos + SizeArr[OutArr];
   if OutDataPos >= COMBUFFERSIZE then OutDataPos := 0;

   OutArr := OutArr + 1;
   if OutArr >= SIZEARR_SIZE then OutArr := 0;

   Result := TRUE;
   }
end;

function  TComDataList.GetWouldBlock (var WBlock:TWouldBlock): Boolean;
begin
   if WouldBlock.cnt <> 0 then begin
      WBlock.cnt := WouldBlock.cnt;
      move (WouldBlock.data, WBlock.data, WouldBlock.cnt);
      Result := TRUE;
   end else begin
      WBlock.cnt := 0;
      Result := FALSE;
   end;
end;

procedure TComDataList.SetWouldBlock (var WBlock:TWouldBlock);
begin
   Move (WBlock, WouldBlock, sizeof(WouldBlock));
end;

procedure TComDataList.ClearWouldBlock;
begin
   FillChar (WouldBlock, sizeof(WouldBlock), 0);
end;

procedure TComDataList.Clear;
var
   i : Integer;
   pd : PTComData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items[i];
      if pd <> nil then Dispose (pd);
   end;
   DataList.Clear;
   {
   InDatapos := 0; OutDataPos := 0;
   InArr := 0; OutArr := 0;
   FillChar (Buffer, sizeof(Buffer), 0);
   FillChar (SizeArr, sizeof(SizeArr), 0);
   }
end;

function TComDataList.GetIsRemain : Boolean;
begin
   Result := false;
   if DataList.Count > 0 then Result := true;
   {
   if OutArr = InArr then Result := FALSE
   else Result := TRUE;
   }
end;


/////////////////////////////////////
//         TBIGComDataList
/////////////////////////////////////

constructor TBigComDataList.Create;
begin
   InDatapos := 0; OutDataPos := 0;
   InArr := 0; OutArr := 0;
   FillChar (Buffer, sizeof(Buffer), 0);
   FillChar (SizeArr, sizeof(SizeArr), 0);
end;

destructor TBigComDataList.Destroy;
begin
   inherited Destroy;
end;

procedure TBigComDataList.AddComData ( len : integer; PData : PByte);
var
   bFlag : Boolean;
begin
   bFlag := true;
   if (OutArr = 0) and (InArr = BIG_SIZEARR_SIZE - 1) then begin
      bFlag := false;
   end else if InArr = OutArr - 1 then begin
      bFlag := false;
   end;

   if bflag = false then begin
//      FrmMain.WriteLogInfo ('TBigComDataList AddComData Stack Overflow');
      exit;
   end;

   if (OutDataPos > InDataPos) and (InDataPos + len >= OutDataPos) then begin
//      FrmMain.WriteLogInfo ('TBigComDataList AddComData Stack Overflow');
      exit;
   end;

   SizeArr[InArr] := len;
   move (pdata^, Buffer[InDataPos] , len);

   InDataPos := InDataPos + len;
   if InDataPos >= BIG_COMBUFFERSIZE then InDataPos := 0;

   InArr := InArr + 1;
   if InArr >= BIG_SIZEARR_SIZE then InArr := 0;
end;

function  TBigComDataList.GetComData  ( var Cdata : TComData): Boolean;
begin
   Result := FALSE;
   if OutArr = InArr then exit;

   CData.cnt := SizeArr[OutArr];
   move (Buffer[OutDataPos] , CDAta.Data, SizeArr[OutArr]);
   CData.Data[CData.cnt] := 0;

   OutDataPos := OutDataPos + SizeArr[OutArr];
   if OutDataPos >= BIG_COMBUFFERSIZE then OutDataPos := 0;

   OutArr := OutArr + 1;
   if OutArr >= BIG_SIZEARR_SIZE then OutArr := 0;

   Result := TRUE;
end;

function  TBigComDataList.GetWouldBlock (var WBlock:TWouldBlock): Boolean;
begin
   if WouldBlock.cnt <> 0 then begin
      WBlock.cnt := WouldBlock.cnt;
      move (WouldBlock.data, WBlock.data, WouldBlock.cnt);
      Result := TRUE;
   end else begin
      WBlock.cnt := 0;
      Result := FALSE;
   end;
end;

procedure TBigComDataList.SetWouldBlock (var WBlock:TWouldBlock);
begin
   Move (WBlock, WouldBlock, sizeof(WouldBlock));
end;

procedure TBigComDataList.ClearWouldBlock;
begin
   FillChar (WouldBlock, sizeof(WouldBlock), 0);
end;

procedure TBigComDataList.Clear;
begin
   InDatapos := 0; OutDataPos := 0;
   InArr := 0; OutArr := 0;
   FillChar (Buffer, sizeof(Buffer), 0);
   FillChar (SizeArr, sizeof(SizeArr), 0);
end;

function TBigComDataList.GetIsRemain : Boolean;
begin
   if OutArr = InArr then Result := FALSE
   else Result := TRUE;
end;


// --------------------------------------------------------------------------//
//						Encoding - Decoding
// --------------------------------------------------------------------------//

function  BaramGatherData (var cdata : TComData; ch : byte): Boolean;
begin
	result := FALSE;
   if ch = CSENDCHAR then exit;
   if ch = CSENDCHAR2 then exit;

   if cdata.cnt < COMDATASIZE-2 then begin
      cdata.data[cdata.cnt] := ch;
      cdata.cnt := cdata.cnt + 1;
      if ch = byte('.') then begin
         cdata.data[cdata.cnt] := 0;
         result := TRUE;
      end;
   end;
end;

procedure Decoding3 ( sour, dest: Pbyte);
var
   buf : array [0..4] of byte;
   b1, b2 : byte;
begin
   move (sour^, buf, 4);
   b1 := buf[0] shl 2; b2 := buf[1] shr 4;
   dest^ := b1 or b2; inc (dest);

   b1 := buf[1] shl 4; b2 := buf[2] shr 2;
   dest^ := b1 or b2; inc (dest);

   b1 := buf[2] shl 6; b2 := buf[3];
   dest^ := b1 or b2;
end;

procedure BaramDecoding ( var sour, dest: TComData);
var
   i, nblock : integer;
   buf : array [0..COMDATASIZE-1+10] of byte;
begin
   nblock := (sour.cnt-1) div 4;

   move (sour.data, buf, sour.cnt);
   buf[sour.cnt] := 0;
   buf[sour.cnt+1] := 0;
   buf[sour.cnt+2] := 0;
   buf[sour.cnt+3] := 0;

   for i := 0 to (nblock*4)-1 do
      buf[i] := buf[i] - $3b;

   for i := 0 to nblock-1 do begin
      Decoding3 (@buf[i*4], @dest.data[i*3]);
   end;
   dest.cnt := nblock * 3;
   if dest.cnt < COMDATASIZE then dest.data[dest.cnt] := 0;
end;

procedure Encoding4 ( sour, dest: Pbyte);
var
   buf : array [0..4] of byte;
   b1, b2 : byte;
begin
   move (sour^, buf, 3);

   dest^ := buf[0] shr 2; inc (dest);

   b1 := (buf[0] and $03) shl 4;
   b2 := (buf[1] shr 4);
   dest^ := b1 or b2; inc (dest);

   b1 := (buf[1] and $0f) shl 2;
   b2 := (buf[2] shr 6);
   dest^ := b1 or b2; inc (dest);

   dest^ := buf[2] and $3f;
end;

procedure BaramEncoding (var sour, dest : TComData);
var i, nblock: integer;
begin
   sour.data[sour.cnt] := 0;

   nblock := sour.cnt div 3;
   if (sour.cnt mod 3) <> 0 then nblock := nblock + 1;

   for i := 0 to nblock-1 do begin
      Encoding4 (@sour.data[i*3], @dest.data[i*4]);
      dest.data[i*4+0] := dest.data[i*4+0] + $3B;
      dest.data[i*4+1] := dest.data[i*4+1] + $3B;
      dest.data[i*4+2] := dest.data[i*4+2] + $3B;
      dest.data[i*4+3] := dest.data[i*4+3] + $3B;
   end;

   dest.data[nblock*4] := byte('.');
   dest.data[nblock*4+1] := CSENDCHAR;
   dest.cnt := nblock*4+2;

   dest.data[dest.cnt] := 0;
end;

procedure Reverse4Bit (var code : TComData);
var
   i : integer;
   a,b : byte;
begin
   for i := 0 to code.cnt -1 do begin
      a := code.data[i] and $f0;
      b := code.data[i] and $0f;

      a := a shr 4;
      b := b shl 4;
      code.data[i] := a+b;
   end;
end;

procedure BaramDbEncoding (var sour, dest : TComData);
begin
   Reverse4Bit (sour);
   BaramEncoding (sour, dest);
end;

procedure BaramDbDecoding ( var sour, dest: TComData);
begin
   BaramDecoding (sour, dest);
   Reverse4Bit (dest);
end;


end.
