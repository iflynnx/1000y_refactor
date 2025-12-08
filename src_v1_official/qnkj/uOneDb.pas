unit uOneDb;

interface

uses Windows, Classes, SysUtils, AUtil32, AnsUnit;

type
///////////////////////////////////////////////////////////////
////        TOneRecordDb
   TOneRecordDbIndex = record
      rData : string[64];
      rIndex : integer;
   end;
   PTOneRecordDbIndex = ^TOneRecordDbIndex;

   TOneRecordDbData = record
      rData : string[64];
   end;
   PTOneRecordDbData = ^TOneRecordDbData;

   TOneRecordDb = class
    private
      FieldIndexList : TList;
      FieldList : TList;
      DataList  : TList;
      FDivider : char;

      function  GetFieldCount: integer;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      procedure ClearData;
      procedure SetDivider(aDivider : char);
      function  GetDivider : char;
      function  GetFieldIndex (afield: string): integer;

      procedure LoadFromFile (aFileName: string);
      procedure SaveToFile (aFileName: string);
      procedure SetField (afieldarr: pbyte);
      procedure SetData  (adataarr: pbyte);

      function  GetField (afieldarr: pbyte): Boolean;
      function  GetData  (adataarr: pbyte): Boolean;

      function  GetIntegerData (afield: string): integer;
      function  GetStringData (afield: string): string;

      function  GetFieldByIndex (aIndex: integer): string;
      function  GetIntegerDataByIndex (aIndex: integer): integer;
      function  GetStringDataByIndex (aIndex: integer): string;

      procedure SetIntegerData (afield: string; adata: integer);
      procedure SetStringData (afield: string; adata: string);

      property  FieldCount : integer read GetFieldCount;
   end;

///////////////////////////////////////////////////////////////
////        TBigOneRecordDb
   TBigOneRecordDbIndex = record
      rField : array [0..64-1] of char;
      rIndex : integer;
   end;
   PTBigOneRecordDbIndex = ^TBigOneRecordDbIndex;

   TBigOneRecordDbField = record
      rField : array [0..64-1] of char;
   end;
   PTBigOneRecordDbField = ^TBigOneRecordDbField;

   TBigOneRecordDbData = record
      rData : array [0..2000 -1] of char;
   end;
   PTBigOneRecordDbData = ^TBigOneRecordDbData;

   TBigOneRecordDb = class
    private
      FieldIndexList : TList;
      FieldList : TList;
      DataList  : TList;
      FDivider : char;    // 데이터를 읽어들이고 내보낼때 분리기호 기본값 ','
      function  GetFieldCount: integer;
    public
      constructor Create;
      destructor Destroy; override;
      procedure LoadFromFile (aFileName: string);
      procedure Clear;
      procedure ClearData;
      procedure SetDivider(aDivider : char);
      function  GetDivider: char;

      procedure SetField (afieldarr: pchar);
      procedure SetData  (adataarr: pchar);
      procedure SetStringData (afield: string; adata: string);

      function  GetField (afieldarr: pchar): Boolean;
      function  GetData  (adataarr: pchar): Boolean;
      function  GetStringData (afield: string): string;

      function  GetFieldIndex (afield: string): integer;
      function  GetFieldByIndex (aIndex: integer): string;
      function  GetStringDataByIndex (aIndex: integer): string;

      property  FieldCount : integer read GetFieldCount;
   end;

function  SortComp(aItem1, aItem2 : pointer): integer;
function  BigSortComp(aItem1, aItem2 : pointer): integer;

implementation

function  SortComp(aItem1, aItem2 : pointer): integer;
begin
   Result := CompareStr(PTOneRecordDbIndex(aItem1)^.rData, PTOneRecordDbIndex(aItem2)^.rData);
end;

function  BigSortComp(aItem1, aItem2 : pointer): integer;
begin
   Result := StrComp(PTBigOneRecordDbIndex(aItem1)^.rField, PTBigOneRecordDbIndex(aItem2)^.rField);
end;

//////////////////////////////////////////////////////
/////        TOneRecordDb
//////////////////////////////////////////////////////

constructor TOneRecordDb.Create;
begin
   FDivider := ',';
   FieldIndexList := TList.Create;
   FieldList := TList.Create;
   DataList  := TList.Create;
end;

destructor TOneRecordDb.Destroy;
begin
   Clear;
   FieldIndexList.Free;
   FieldList.Free;
   DataList.Free;
   inherited destroy;
end;

procedure TOneRecordDb.Clear;
var
   i : integer;
begin
   for i := 0 to DataList.Count - 1 do dispose (DataList[i]);
   DataList.Clear;
   for i := 0 to FieldList.Count - 1 do dispose (FieldList[i]);
   FieldList.Clear;
   for i := 0 to FieldIndexList.Count - 1 do dispose (FieldIndexList[i]);
   FieldIndexList.Clear;
end;

procedure TOneRecordDb.ClearData;
var i : integer;
begin
   for i := 0 to DataList.Count -1 do PTOneRecordDbData (DataList[I])^.rData := '';
end;

procedure TOneRecordDb.SetDivider(aDivider : char);
begin
   FDivider := aDivider;
end;

function TOneRecordDb.GetDivider : char;
begin
   Result := FDivider;
end;

function  TOneRecordDb.GetFieldCount: integer;
begin
   Result := FieldList.Count;
end;

function  TOneRecordDb.GetFieldIndex (afield: string): integer;
var
   iHead, iTail, iCurr : integer;
   nCompResult : integer;
   strFieldName : string;
begin
   Result := -1;
   strFieldName := LowerCase(aField);
   iHead := 0;   iTail := FieldIndexList.count - 1;
   if iHead > iTail then exit;

   while TRUE do begin
      iCurr := ((iTail - iHead) div 2) + iHead;
      if (iCurr > iHead) and (iCurr < iTail) then begin
         nCompResult := CompareStr(strFieldName, PTOneRecordDbIndex(FieldIndexList[iCurr])^.rData);
         if nCompResult = 0 then begin
            Result := PTOneRecordDbIndex(FieldIndexList[iCurr])^.rIndex;
            exit;
         end
         else if nCompResult > 0 then iHead := iCurr
         else if nCompResult < 0 then iTail := iCurr;
      end
      else if (iCurr = iHead) or (iCurr = iTail) then begin
         nCompResult := CompareStr(strFieldName, PTOneRecordDbIndex(FieldIndexList[iCurr])^.rData);
         if nCompResult = 0 then begin
            Result := PTOneRecordDbIndex(FieldIndexList[iCurr])^.rIndex;
            exit;
         end
         else if nCompResult > 0 then iCurr := iTail
         else if nCompResult < 0 then iCurr := iHead;

         nCompResult := CompareStr(strFieldName, PTOneRecordDbIndex(FieldIndexList[iCurr])^.rData);
         if nCompResult = 0 then begin
            Result := PTOneRecordDbIndex(FieldIndexList[iCurr])^.rIndex;
            exit;
         end
         else break;
      end
      else break;
   end;
end;

function  TOneRecordDb.GetIntegerData (afield: string): integer;
var idx: integer;
begin
   Result := 0;
   idx := GetFieldIndex (afield);
   if idx = -1 then exit;
   Result := _StrToInt (PTOneRecordDbData (DataList[idx])^.rdata);
end;

function  TOneRecordDb.GetStringData (afield: string): string;
var idx: integer;
begin
   Result := '';
   idx := GetFieldIndex (afield);
   if idx = -1 then exit;
   Result := PTOneRecordDbData (DataList[idx])^.rdata;
end;

procedure TOneRecordDb.SetIntegerData (afield: string; adata: integer);
var idx: integer;
begin
   idx := GetFieldIndex (afield);
   if idx = -1 then exit;
   PTOneRecordDbData (DataList[idx])^.rData := IntToStr (adata);
end;

procedure TOneRecordDb.SetStringData (afield: string; adata: string);
var idx: integer;
begin
   idx := GetFieldIndex (afield);
   if idx = -1 then exit;
   PTOneRecordDbData (DataList[idx])^.rdata := adata;
end;

procedure TOneRecordDb.SetField (afieldarr: pbyte);
var
   i : integer;
   p : PTOneRecordDbData;
   pI : PTOneRecordDbIndex;
   str,rdstr : string;
begin
   Clear;
   i := 0;
   str := strpas (pchar(afieldarr));
   while str <> '' do begin
      str := GetValidStr3 (str, rdstr, FDivider);
      new (p);
      p^.rdata := LowerCase (rdstr);
      FieldList.add (p);

      new(pI);
      pI^.rData := LowerCase (rdstr);
      pI^.rIndex := i;
      FieldIndexList.Add(pI);
      inc(i);

      new (p);
      p^.rData := '';
      DataList.Add(p);
   end;
   FieldIndexList.Sort(SortComp);
end;

procedure TOneRecordDb.SetData (adataarr: pbyte);
var
   i : integer;
   str,rdstr : string;
begin
   if FieldList.Count <= 0 then exit;

   str := strpas (pchar(adataarr));
   for i := 0 to FieldList.Count -1 do begin
      str := GetValidStr3 (str, rdstr, FDivider);
      PTOneRecordDbData (DataList[I])^.rData := rdstr;
   end;
end;

function TOneRecordDb.GetField (afieldarr: pbyte): Boolean;
var
   i : integer;
   pb: pbyte;
begin
   Result := FALSE;
   afieldarr^ := 0;
   if FieldList.Count = 0 then exit;

   pb := afieldarr;
   for i := 0 to FieldList.Count -1 do begin
      _strpcopy (pchar(pb), PTOneRecordDbData (FieldList[i])^.rdata+FDivider);
      inc (pb, Length(PTOneRecordDbData (FieldList[i])^.rdata)+1);
   end;
   Result := TRUE;
end;

function TOneRecordDb.GetData (adataarr: pbyte): Boolean;
var
   i : integer;
   pb: pbyte;
begin
   Result := FALSE;
   adataarr^ := 0;
   if FieldList.Count = 0 then exit;

   pb := adataarr;
   for i := 0 to DataList.Count -1 do begin
      _strpcopy (pchar(pb), PTOneRecordDbData (DataList[i])^.rdata+FDivider);
      inc (pb, Length(PTOneRecordDbData (DataList[i])^.rdata)+1);
   end;

   Result := TRUE;
end;

procedure TOneRecordDb.LoadFromFile (aFileName: string);
var
   Buffer : array [0..4096-1] of byte;
   StringList : TStringList;
begin
   if FileExists (afileName) then begin
      StringList := TStringList.Create;

      StringList.LoadFromFile (aFileName);
      if StringList.Count >= 1 then begin
         _StrPCopy (@Buffer, StringList[0]);
         SetField (@Buffer);
      end;
      if StringList.Count >= 2 then begin
         _StrPCopy (@Buffer, StringList[1]);
         SetData (@Buffer);
      end;
      StringList.Free;
      FieldIndexList.Sort(SortComp);
   end;
end;

procedure TOneRecordDb.SaveToFile (aFileName: string);
var
   Buffer : array [0..4096-1] of byte;
   StringList : TStringList;
begin
   StringList := TStringList.Create;
   GetField (@Buffer);

   StringList.Add (StrPas (@Buffer));
   GetData (@Buffer);
   StringList.Add (StrPas (@Buffer));

   StringList.SaveToFile (aFileName);

   StringList.Free;
end;

function  TOneRecordDb.GetFieldByIndex (aIndex: integer): string;
begin
   Result := '';
   if aIndex >= FieldList.Count then exit;
   Result := PTOneRecordDbData (FieldList[aIndex])^.rData;
end;

function  TOneRecordDb.GetIntegerDataByIndex (aIndex: integer): integer;
begin
   Result := 0;
   if aIndex >= FieldList.Count then exit;
   Result := _StrToInt(PTOneRecordDbData (DataList[aIndex])^.rData);
end;

function  TOneRecordDb.GetStringDataByIndex (aIndex: integer): string;
begin
   Result := '';
   if aIndex >= FieldList.Count then exit;
   Result := PTOneRecordDbData(DataList[aIndex])^.rData;
end;

//////////////////////////////////////////////////////
/////        TBigOneRecordDb
//////////////////////////////////////////////////////
constructor TBigOneRecordDb.Create;
begin
   FieldIndexList := TList.Create;
   FieldList := TList.Create;
   DataList  := TList.Create;
   FDivider := ',';
end;

destructor TBigOneRecordDb.Destroy;
begin
   Clear;
   FieldIndexList.Free;
   FieldList.Free;
   DataList.Free;
   inherited destroy;
end;

procedure TBigOneRecordDb.LoadFromFile (aFileName: string);
var
   Buffer : array [0..4096-1] of byte;
   StringList : TStringList;
begin
   if FileExists (afileName) then begin
      StringList := TStringList.Create;

      StringList.LoadFromFile (aFileName);
      if StringList.Count >= 1 then begin
         _StrPCopy (@Buffer, StringList[0]);
         SetField (@Buffer);
      end;
      if StringList.Count >= 2 then begin
         _StrPCopy (@Buffer, StringList[1]);
         SetData (@Buffer);
      end;
      StringList.Free;
      FieldIndexList.Sort(BigSortComp);
   end;
end;

procedure TBigOneRecordDb.Clear;
var
   i : integer;
begin
   for i := 0 to DataList.Count -1 do dispose (DataList[i]);
   DataList.Clear;
   for i := 0 to FieldList.Count -1 do dispose (FieldList[i]);
   FieldList.Clear;
   for i := 0 to FieldIndexList.Count -1 do dispose (FieldIndexList[i]);
   FieldIndexList.Clear;
end;

procedure TBigOneRecordDb.ClearData;
var i, j, nBufferCnt : integer;
begin
   nBufferCnt := SizeOf(PTBigOneRecordDbData(DataList[0]));
   for i := 0 to FieldList.Count -1 do
      for j := 0 to nBufferCnt do
         PTBigOneRecordDbData (DataList[i])^.rData[j] := #0;
end;

procedure TBigOneRecordDb.SetDivider(aDivider : char);
begin
   FDivider := aDivider;
end;

function TBigOneRecordDb.GetDivider: char;
begin
   Result := FDivider;
end;

procedure TBigOneRecordDb.SetField (aFieldArr: pchar);
var
   pF : PTBigOneRecordDbField;
   pI : PTBigOneRecordDbIndex;
   pD : PTBigOneRecordDbData;
   str, rdstr : string;
   i : integer;
begin
   Clear;
   i := 0;
   str := StrPas (aFieldArr);
   while str <> '' do begin
     str := GetValidStr3 (str, rdstr, FDivider);
      new (pF);
      StrPCopy (@pF^.rField, LowerCase (rdstr));
      FieldList.add (pF);

      new (pI);
      StrPCopy (@pI^.rField, LowerCase (rdstr));
      pI^.rIndex := i;
      FieldIndexList.Add(pI);
      inc(i);

      new (pD);
      FillChar(pD^.rData, sizeof (pd^.rdata), 0);
      DataList.Add(pD);
   end;
   FieldIndexList.Sort(BigSortComp);
end;

procedure TBigOneRecordDb.SetData (aDataArr: pchar);
var
   i, n: integer;
   arrNDividerPos : array[0..1000-1] of integer;
   nDataLen : integer;
   pc : pchar;
begin
   if FieldList.Count <= 0 then exit;
   for i := 0 to 1000 - 1 do arrNDividerPos[i] := -1;
   nDataLen := StrLen(aDataArr);

   arrNDividerPos[0] := -1;   n := 1;
   for i := 0 to nDataLen-1 do begin
      if aDataArr[i] = FDivider then begin
         arrNDividerPos[n] := i; inc(n);
      end;
   end;
   // 끝이 FDivider로 끝나지 않을 때 처리함.
   if arrNDividerPos[n-1] < (nDataLen - 1) then arrNDividerPos[n] := nDataLen ;

   pc := aDataArr;
   for i := 1 to FieldList.Count do begin
      move (pc^, PTBigOneRecordDbData (DataList[i-1])^.rData, arrNDividerPos[i] - (arrNDividerPos[i-1] + 1));
      PTBigOneRecordDbData(DataList[i-1])^.rData[arrNDividerPos[i] - (arrNDividerPos[i-1] + 1)] := #0;
      inc(pc, arrNDividerPos[i] - arrNDividerPos[i-1]);
   end;
end;

procedure TBigOneRecordDb.SetStringData (afield: string; adata: string);
var idx: integer;
begin
   idx := GetFieldIndex (aField);
   if idx = -1 then exit;
   StrPCopy(@PTBigOneRecordDbData (DataList[idx])^.rdata, aData);
end;

function TBigOneRecordDb.GetField (aFieldArr: pchar): Boolean;
var
   i, j , k : integer;
begin
   Result := FALSE;
   aFieldArr^ := #0;
   if FieldList.Count = 0 then exit;
   k := 0;
   for i := 0 to FieldList.Count - 1 do begin
      j := 0;
      while PTBigOneRecordDbField(FieldList[i])^.rField[j] <> #0 do begin
         aFieldArr[k] := PTBigOneRecordDbField(FieldList[i])^.rField[j];
         inc(k);   inc(j);
      end;
      aFieldArr[k] := FDivider;   inc(k);
   end;
   aFieldArr[k] := #0;
   Result := TRUE;
end;

function TBigOneRecordDb.GetData (aDataArr: pchar): Boolean;
var
   i, j, k : integer;
begin
   Result := FALSE;
   adataarr^ := #0;
   if FieldList.Count = 0 then exit;
   k := 0;
   for i := 0 to DataList.Count -1 do begin
      j := 0;
      while PTBigOneRecordDbData(DataList[i])^.rData[j] <> #0 do begin
         aDataArr[k] := PTBigOneRecordDbData(DataList[i])^.rData[j];
         inc(k);   inc(j);
      end;
      aDataArr[k] := FDivider;   inc(k);
   end;
   aDataArr[k] := #0;
   Result := TRUE;
end;

function  TBigOneRecordDb.GetStringData (aField: string): string;
var idx: integer;
begin
   Result := '';
   idx := GetFieldIndex (aField);
   if idx = -1 then exit;
   Result := StrPas(@PTBigOneRecordDbData (DataList[idx])^.rdata);
end;

function  TBigOneRecordDb.GetFieldIndex (afield: string): integer;
var
   iHead, iTail, iCurr : integer;
   nCompResult : integer;
   arrFieldName : array[0..32-1] of char;
begin
   Result := -1;
   FillChar(arrFieldName, SizeOf(arrFieldName), #0);
   StrPCopy(@arrFieldName, LowerCase(aField));

   iHead := 0;   iTail := FieldIndexList.count - 1;
   if iHead > iTail then exit;

   while TRUE do begin
      iCurr := ((iTail - iHead) div 2) + iHead;
      if (iCurr > iHead) and (iCurr < iTail) then begin
         nCompResult := StrComp(@arrFieldName, PTBigOneRecordDbIndex(FieldIndexList[iCurr])^.rField);
         if nCompResult = 0 then begin
            Result := PTBigOneRecordDbIndex(FieldIndexList[iCurr])^.rIndex;
            exit;
         end
         else if nCompResult > 0 then iHead := iCurr
         else if nCompResult < 0 then iTail := iCurr;
      end
      else if (iCurr = iHead) or (iCurr = iTail) then begin
         nCompResult := StrComp(@arrFieldName, PTBigOneRecordDbIndex(FieldIndexList[iCurr])^.rField);
         if nCompResult = 0 then begin
            Result := PTBigOneRecordDbIndex(FieldIndexList[iCurr])^.rIndex;
            exit;
         end
         else if nCompResult > 0 then iCurr := iTail
         else if nCompResult < 0 then iCurr := iHead;

         nCompResult := StrComp(@arrFieldName, PTBigOneRecordDbIndex(FieldIndexList[iCurr])^.rField);
         if nCompResult = 0 then begin
            Result := PTBigOneRecordDbIndex(FieldIndexList[iCurr])^.rIndex;
            exit;
         end
         else break;
      end
      else break;
   end;
end;

function  TBigOneRecordDb.GetFieldByIndex (aIndex: integer): string;
begin
   Result := '';
   if aIndex >= FieldList.Count then exit;
   Result := StrPas(@PTBigOneRecordDbField (FieldList[aIndex])^.rField);
end;

function  TBigOneRecordDb.GetStringDataByIndex (aIndex: integer): string;
begin
   Result := '';
   if aIndex >= FieldList.Count then exit;
   Result := StrPas(@PTBigOneRecordDbData(DataList[aIndex])^.rData);
end;

function  TBigOneRecordDb.GetFieldCount: integer;
begin
   Result := FieldList.Count;
end;


end.

