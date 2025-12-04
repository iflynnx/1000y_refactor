unit ObjCls;

interface

uses Windows, SysUtils, Classes, BmpUtil, A2Img, AUtil32;

const
    ID1             = 'ATZOBJ1' + #0;
    ID2             = 'ATZOBJ2' + #0;
    ID3             = 'ATZOBJ3' + #0;
    ObjectLibId     = 'ATZOBJ3' + #0;

    HeaderFileID    = 'OBJH3';
    OBJECT_CELL_MAX = 16 * 16;
    OBJECT_MAX_COUNT = 4096 + 1024 + 1024;

    UsedCheckTickDelay = 40000;
    UsedCheckDataTickDelay = 20000;

    FreeCountMAXSIZE = 5;
type
    TObjType = (TOB_none, TOB_follow, TOB_dummy);

    TFileObjectHeader = record
        Ident:array[0..7] of char;
        NObject:Integer;
    end;

    TObjectData = record           // ID3
        ObjectAniId:Integer;       // 局聪皋捞记 Object 备盒磊
        ObjectId:integer;          // Object Data Index
        Style:TObjType;            // TOB_none: 老馆object TOB_follow: aniObject;
        MWidth, MHeight:Integer;   // 1 喉钒俊 措茄 Cell肮荐
        nBlock:Integer;            // 喉钒 肮荐
        StartID:integer;           // ani 矫累 ObjectID
        endID:integer;             // ani 场 ObjectID
        IWidth, IHeight:Integer;   // 啊肺技肺辨捞
        Ipx, Ipy:Integer;
        MBuffer:array[0..OBJECT_CELL_MAX - 1] of byte; // move Control buffer 16*16
        AniDelay:integer;
        DataPos:DWord;
        None:array[0..4 - 1] of integer;
        Bits:PTAns2Color;
    end;
    PTObjectData = ^TObjectData;

    TObjectData2 = record          // ID2
        ObjectId:integer;
        MWidth, MHeight:Integer;
        IWidth, IHeight:Integer;
        Ipx, Ipy:Integer;
        MBuffer:array[0..OBJECT_CELL_MAX - 1] of byte;
        AniDelay:DWORD;
        None:array[0..4 - 1] of integer;
        Bits:PTAns2Color;
    end;
    PTObjectData2 = ^TObjectData2;

    TObjectDataList = class
    private
        FStream:TFileStream;
        TempImgClear:TA2Image;
        TempObjectAnsImage:TA2Image;

        DataList:TList;
        DataPosArr:array[0..OBJECT_MAX_COUNT - 1] of integer; //序号 对应 数据位置
        UsedTickBuffer:array[0..OBJECT_MAX_COUNT - 1] of integer;
        FFileName:string;
        UsedCheckTick:integer;

        FreeCount:integer;

        function GetCount:integer;
        function GetObjectData(index:Integer):PTObjectData;
        procedure ReFreshDataPos;
        //file
        function LoadFromFileATZOBJ3(aFileName:string):integer;
        function LoadFromFileATZOBJ2(aFileName:string):integer;
        procedure LoadFromFile(aFileName:string);
        procedure LoadFromHeaderFile(aFileName:string);
        //PGK
        function LoadFromPgkATZOBJ3(aFileName:string):integer;
        function LoadFromPgkATZOBJ2(aFileName:string):integer;
        procedure LoadFromPgk(aFileName:string);
        procedure LoadFromHeaderPgk(aFileName:string);
    public

        constructor Create;
        destructor Destroy; override;

        procedure LoadFrom(aName:string);

        procedure SaveToFile(aFileName:string);

        function GetObjectImage(index, pos, CurTick:integer):TA2Image;

        //        function Add(pObjectData:PTObjectData):Boolean;
          //      procedure Delete(index:Integer);
        procedure Clear;
        procedure UsedTickUpdate(CurTick:integer);

        property Items[Index:Integer]:PTObjectData read GetObjectData; default;
        property Count:integer read GetCount;

    end;

var
    ObjectDataList  :TObjectDataList;
    RoofDataList    :TObjectDataList;

implementation
uses filepgkclass;
const
  G_MapDataPath = '.\map\';
  //XorKey: array[0..10] of Byte = ($A1, $B7, $AC, $57, $1C, $63, $3B, $81, $57, $1C, $63); //字符串加密用 old
  XorKey: array[0..10] of Byte = ($A2, $B8, $AC, $68, $2C, $74, $4B, $92, $68, $2C, $64); //字符串加密用

//在程序里加入以下两个函数，

function Dec(Str: string): string; //字符解密函數
var
  i, j: Integer;
begin
  Result := '';
  j := 0;
  for i := 1 to Length(Str) div 2 do
  begin
    Result := Result + Char(StrToInt('$' + Copy(Str, i * 2 - 1, 2)) xor XorKey[j]);
    j := (j + 1) mod 11;
  end;
end;

function Enc(Str: string): string; //字符加密函數 這是用的一個異或加密
var
  i, j: Integer;
begin
  Result := '';
  j := 0;
  for i := 1 to Length(Str) do
  begin
    Result := Result + IntToHex(Byte(Str[i]) xor XorKey[j], 2);
    j := (j + 1) mod 11;
  end;
end;
constructor TObjectDataList.Create;
begin
    FStream := nil;
    DataList := TList.Create;

    TempObjectAnsImage := TA2Image.Create(32, 24, 0, 0);
    TempImgClear := TA2Image.Create(32, 24, 0, 0);
    TempImgClear.Clear(0);

    FFileName := '';
    Clear;
    UsedCheckTick := 0;
    FreeCount := 0;
    Fillchar(UsedTickBuffer, sizeof(UsedTickBuffer), 0);
end;

destructor TObjectDataList.Destroy;
begin
    Clear;

    DataList.Free;
    TempObjectAnsImage.Free;
    TempImgClear.Free;
    inherited Destroy;
end;

procedure TObjectDataList.Clear;
var
    i               :Integer;
    pObjectData     :PTObjectData;
begin
    if FStream <> nil then FStream.Free;
    FStream := nil;
    FillChar(DataPosArr, sizeof(DataPosArr), $FF);
    for i := 0 to DataList.Count - 1 do
    begin
        pObjectData := Datalist[i];
        if pObjectData^.Bits <> nil then FreeMem(pObjectData^.Bits);
        Dispose(pObjectData);
    end;
    DataList.Clear;
end;

procedure TObjectDataList.ReFreshDataPos;
var
    i               :integer;
    po              :PTObjectData;
begin
    FillChar(DataPosArr, sizeof(DataPosArr), $FF);
    for i := 0 to DataList.Count - 1 do
    begin
        po := DataList[i];
        DataPosArr[po^.ObjectId] := i;
    end;
end;

procedure TObjectDataList.UsedTickUpdate(CurTick:integer);
var
    i               :Integer;
    pObjectData     :PTObjectData;
begin
    if FFileName = '' then exit;
    if CurTick > UsedCheckTick + UsedCheckTickdelay then
    begin
        UsedCheckTick := CurTick;
        for i := FreeCount to FreeCount + FreeCountMAXSIZE - 1 do
        begin
            if CurTick > UsedTickBuffer[i] + UsedCheckDataTickDelay then
            begin
                if DataList.Count - 1 < i then
                begin
                    FreeCount := 0;
                    break;
                end;
                pObjectData := Datalist[i];
                if pObjectData = nil then continue;
                if pObjectData^.Bits <> nil then FreeMem(pObjectData^.Bits);
                pObjectData^.Bits := nil;
                UsedTickBuffer[i] := CurTick;
            end;
        end;
        inc(FreeCount, FreeCountMAXSIZE);
        if FreeCount + FreeCountMAXSIZE > DataList.Count - 1 then FreeCount := 0;
    end;
end;

function TObjectDataList.GetObjectImage(index, pos, CurTick:integer):TA2Image;
var
    pObjectData     :PTObjectData;
    pb              :pbyte;
    asize           :integer;
      tmpfilename: string;
begin
    Result := TempImgClear;
    if DataPosArr[index] = -1 then exit;
    pObjectdata := DataList[DataPosArr[index]];
    if pObjectdata.Bits = nil then
    begin
        if pgkmap.Position(FFileName, asize) = false then
        begin
               tmpfilename := G_MapDataPath + Enc(AnsiUpperCase(FFileName)) + '.do';
            if FileExists(tmpfilename) = false then exit;
            if FStream = nil then
            begin
                   FStream := TFileStream.Create(tmpfilename, fmOpenRead or fmShareDenyNone);
                      FStream.Seek(16, 0);
            end;

            with pObjectData^ do
            begin
                getmem(pb, (IWidth * IHeight * 2 * nBlock));
                pObjectData.Bits := pointer(pb);
                FStream.Position := (pObjectData^.Datapos); //本组 首地址
                FStream.ReadBuffer(pb^, (IWidth * IHeight * 2 * nBlock));
            end;
        end else
        begin
            with pObjectData^ do
            begin
                getmem(pb, (IWidth * IHeight * 2 * nBlock));
                pObjectData.Bits := pointer(pb);
                pgkmap.FStream.Position := pgkmap.FStream.Position + (pObjectData^.Datapos); //本组 首地址
                pgkmap.ReadBuffer(pb, (IWidth * IHeight * 2 * nBlock));
            end;
        end;
    end;
    pb := pointer(pObjectdata.Bits);
    UsedTickBuffer[index] := CurTick; //使用 时间
    inc(pb, pObjectData^.IWidth * pObjectData^.IHeight * (2) * pos); //当前图片首地址
    TempObjectAnsImage.Setsize(pObjectdata^.IWidth, pObjectdata^.IHeight);
    TempObjectAnsImage.px := pObjectdata^.IPx;
    TempObjectAnsImage.py := pObjectdata^.IPY;
    copymemory(TempObjectAnsImage.Bits, pb, pObjectData^.IWidth * pObjectData^.IHeight * 2);
    Result := TempObjectAnsImage;
end;

procedure TObjectDataList.SaveToFile(aFileName:string);
var
    i               :Integer;
    Stream          :TFileStream;

    FileObjectHeader:TFileObjectHeader;
    pObjectData     :PTObjectData;
    pb              :pbyte;
begin
    {  Stream := TFileStream.Create(aFileName + 'head', fmCreate);
      try
          FileObjectHeader.Ident := ObjectLibId;
          FileObjectHeader.NObject := DataList.Count;

          Stream.WriteBuffer(FileObjectHeader, sizeof(FileObjectHeader));

          for i := 0 to DataList.Count - 1 do
          begin
              pObjectData := DataList[i];
              Stream.WriteBuffer(pObjectData^, sizeof(TObjectData));
          end;
      finally
          Stream.Free;
      end;

      for i := 0 to DataList.Count - 1 do
      begin
          pObjectData := DataList[i];
          Stream := TFileStream.Create(aFileName + inttostr(i), fmCreate);
          try

              pb := FStream.Memory;
              inc(pb, pObjectData^.Datapos); //本组 首地址
              with pObjectData^ do
                  Stream.WriteBuffer(pb^, (IWidth * IHeight * 2 * nBlock));

          finally
              Stream.Free;
          end;
      end;
     }
end;

function TObjectDataList.GetCount:integer;
begin
    Result := OBJECT_MAX_COUNT;
end;

function TObjectDataList.GetObjectData(Index:Integer):PTObjectData;
var
    dp              :integer;
begin
    dp := DataPosArr[Index];
    if (dp < DataList.Count) and (dp > -1) then Result := DataList[dp]
    else Result := nil;
end;
{
function DataListSort(Item1, Item2:Pointer):integer;
begin
    Result := PTObjectData(Item1).ObjectId - PTObjectData(Item2).ObjectId;
end;

function TObjectDataList.Add(pObjectData:PTObjectData):Boolean;
var
    i               :Integer;
    pod             :PTObjectData;
begin
    Result := FALSE;
    for i := 0 to DataList.Count - 1 do
    begin
        pod := DataList[i];
        if pod^.ObjectId = pObjectData^.ObjectId then exit;
    end;
    DataList.Add(pObjectData);
    DataList.Sort(DataListSort);

    ReFreshDataPos;

    Result := TRUE;
end;

procedure TObjectDataList.Delete(Index:Integer);
var
    dp              :integer;
begin
    dp := DataPosArr[index];
    if (dp < DataList.Count) and (dp > -1) then
    begin
        if PTObjectData(DataList[dp])^.Bits <> nil then FreeMem(PTObjectData(DataList[dp])^.Bits);
        dispose(DataList[dp]);
        DataList.Delete(dp);

        ReFreshDataPos;
    end;
end;
}

function TObjectDataList.LoadFromPgkATZOBJ3(aFileName:string):integer;
var
    i, pos, asize   :Integer;

    FileObjectHeader:TFileObjectHeader;
    pObjectData     :PTObjectData;
    HeaderFile, str, rdstr:string;
begin
    Result := -1;
    if pgkmap.isfile(aFileName) = FALSE then exit;
    if FFileName = aFileName then exit;
    FFileName := aFileName;

    str := ExtractFileName(aFileName);
    str := GetValidstr3(str, rdstr, '.');

    HeaderFile := rdstr + '.hdf';
    if pgkmap.isfile(HeaderFile) then
    begin
        LoadFromHeaderpgk(HeaderFile);
        exit;
    end;
    pos := 0;
    Clear;

    try

        try
            if pgkmap.Position(aFileName, asize) = false then exit;

            pgkmap.ReadBuffer(@FileObjectHeader, sizeof(FileObjectHeader));
            inc(pos, sizeof(FileObjectHeader));

            if StrLIComp(PChar(ObjectLibId), FileObjectHeader.Ident, 8) <> 0 then
                raise Exception.Create('Not a valid Object Library File');

            for i := 0 to FileObjectHeader.NObject - 1 do
            begin
                new(pObjectData);

                pgkmap.ReadBuffer(pObjectData, sizeof(TObjectData));
                inc(pos, sizeof(TObjectData));
                pObjectData^.Bits := nil;
                pObjectData^.DataPos := Pos;
                pgkmap.FStream.Seek((pObjectData^.IWidth * pObjectData^.IHeight * pObjectData^.nBlock * 2), sofromcurrent);
                inc(pos, (pObjectData^.IWidth * pObjectData^.IHeight * pObjectData^.nBlock * 2));
                DataList.Add(pObjectData);
            end;
            ReFreshDataPos;

        except

            Clear;

        end;
    finally

    end;
    Result := 0;
end;

function TObjectDataList.LoadFromFileATZOBJ3(aFileName:string):integer;
var
    i, pos          :Integer;
    Stream          :TFileStream;
    FileObjectHeader:TFileObjectHeader;
    pObjectData     :PTObjectData;
    HeaderFile, str, rdstr:string;
  tmpFilename,tmphdf: string;

begin
 
    tmpFilename := '.\map\' + Enc(AnsiUpperCase(aFileName)) + '.do';
    Result := -1;
    if FileExists(tmpFilename) = FALSE then exit;
    if FFileName = aFileName then exit;
    FFileName := aFileName;

    str := ExtractFileName(aFileName);
    str := GetValidstr3(str, rdstr, '.');

   tmphdf := rdstr + '.hdf';
  tmphdf := Enc(AnsiUpperCase(tmphdf));
  HeaderFile := G_MapDataPath + tmphdf + '.dh';

    if FileExists(HeaderFile) then
    begin
        LoadFromHeaderFile(HeaderFile);
        exit;
    end;
    pos := 0;
    Clear;
    Stream := nil;
    try
        Stream := TFileStream.Create(tmpFilename, fmOpenRead or fmShareDenyNone);
        Stream.Seek(16,0);
        Stream.ReadBuffer(FileObjectHeader, sizeof(FileObjectHeader));
        inc(pos, sizeof(FileObjectHeader));
         Inc(pos,16);
        if StrLIComp(PChar(ObjectLibId), FileObjectHeader.Ident, 8) <> 0 then
            raise Exception.Create('Not a valid Object Library File');

        for i := 0 to FileObjectHeader.NObject - 1 do
        begin
            new(pObjectData);

            Stream.ReadBuffer(pObjectData^, sizeof(TObjectData));
            inc(pos, sizeof(TObjectData));
         
            pObjectData^.Bits := nil;
            pObjectData^.DataPos := Pos;
            Stream.Seek((pObjectData^.IWidth * pObjectData^.IHeight * pObjectData^.nBlock * 2), sofromcurrent);
            inc(pos, (pObjectData^.IWidth * pObjectData^.IHeight * pObjectData^.nBlock * 2));
            DataList.Add(pObjectData);
        end;
        ReFreshDataPos;
        Stream.Free;
    except
        if Stream <> nil then Stream.Free;
        Clear;
        exit;
    end;
    Result := 0;
end;

function TObjectDataList.LoadFromPgkATZOBJ2(aFileName:string):integer;

var
    i, n, asize     :Integer;

    FileObjectHeader:TFileObjectHeader;
    pObjectData2    :PTObjectData2;
    pObjectData     :PTObjectData;
    pos             :integer;
begin
    Result := -1;

    if pgkmap.isfile(aFileName) = FALSE then exit;
    if FFileName = aFileName then exit;
    FFileName := aFileName;
    pos := 0;

    Clear;

    try
        try

            if pgkmap.Position(aFileName, asize) = false then exit;
            pgkmap.ReadBuffer(@FileObjectHeader, sizeof(FileObjectHeader));
            inc(pos, sizeof(FileObjectHeader));

            if StrLIComp(PChar(ID2), FileObjectHeader.Ident, 8) <> 0 then
                raise Exception.Create('Not a valid Object Library File');

            for i := 0 to FileObjectHeader.NObject - 1 do
            begin
                new(pObjectData2);
                pgkmap.ReadBuffer(pObjectData2, sizeof(TObjectData2));
                inc(pos, sizeof(TObjectData2));

                new(pObjectData);
                with pObjectData^ do
                begin
                    ObjectAniId := 0;
                    ObjectId := pObjectData2^.ObjectId;
                    Style := TObjType(0);
                    MWidth := pObjectData2^.MWidth;
                    MHeight := pObjectData2^.MHeight;
                    nBlock := 1;
                    StartID := -1;
                    endID := 0;
                    IWidth := pObjectData2^.IWidth;
                    IHeight := pObjectData2^.IHeight;
                    Ipx := pObjectData2^.Ipx;
                    Ipy := pObjectData2^.Ipy;
                    for n := 0 to OBJECT_CELL_MAX - 1 do
                    begin
                        MBuffer[n] := pObjectData2^.MBuffer[n];
                    end;
                    AniDelay := integer(pObjectData2^.AniDelay);
                    DataPos := pos;
                    for n := 0 to 4 - 1 do
                    begin
                        None[n] := pObjectData2^.None[n];
                    end;
                    Bits := nil;
                end;
                DataList.Add(pObjectData);

                if pObjectData2 <> nil then FreeMem(pObjectData2);
                pgkmap.FStream.Seek((pObjectData2^.IWidth * pObjectData2^.IHeight * 2), sofromcurrent);
                inc(pos, (pObjectData2^.IWidth * pObjectData2^.IHeight * 2));
            end;
            ReFreshDataPos;

        except
            Clear;
        end;
    finally

    end;
    Result := 0;
end;

function TObjectDataList.LoadFromFileATZOBJ2(aFileName:string):integer;
var
    i, n            :Integer;
    Stream          :TFileStream;
    FileObjectHeader:TFileObjectHeader;
    pObjectData2    :PTObjectData2;
    pObjectData     :PTObjectData;
    pos             :integer;
  tmpFilename: string;
begin
 
    tmpFilename := '.\map\' + Enc(AnsiUpperCase(aFileName)) + '.do';
    Result := -1;

    if FileExists(tmpFilename) = FALSE then exit;
    if FFileName = aFileName then exit;
    FFileName := aFileName;
    pos := 0;
    Stream := nil;
    Clear;
    try
        Stream := TFileStream.Create(tmpFilename, fmOpenRead or fmShareDenyNone);
        Stream.Seek(16,0);
        Stream.ReadBuffer(FileObjectHeader, sizeof(FileObjectHeader));
        inc(pos, sizeof(FileObjectHeader));
        Inc(pos,16);
        if StrLIComp(PChar(ID2), FileObjectHeader.Ident, 8) <> 0 then
            raise Exception.Create('Not a valid Object Library File');

        for i := 0 to FileObjectHeader.NObject - 1 do
        begin
            new(pObjectData2);
            Stream.ReadBuffer(pObjectData2^, sizeof(TObjectData2));
            inc(pos, sizeof(TObjectData2));

            new(pObjectData);
            with pObjectData^ do
            begin
                ObjectAniId := 0;
                ObjectId := pObjectData2^.ObjectId;
                Style := TObjType(0);
                MWidth := pObjectData2^.MWidth;
                MHeight := pObjectData2^.MHeight;
                nBlock := 1;
                StartID := -1;
                endID := 0;
                IWidth := pObjectData2^.IWidth;
                IHeight := pObjectData2^.IHeight;
                Ipx := pObjectData2^.Ipx;
                Ipy := pObjectData2^.Ipy;
                for n := 0 to OBJECT_CELL_MAX - 1 do
                begin
                    MBuffer[n] := pObjectData2^.MBuffer[n];
                end;
                AniDelay := integer(pObjectData2^.AniDelay);
                DataPos := pos;
                for n := 0 to 4 - 1 do
                begin
                    None[n] := pObjectData2^.None[n];
                end;
                Bits := nil;
            end;
            DataList.Add(pObjectData);

            if pObjectData2 <> nil then FreeMem(pObjectData2);
            Stream.Seek((pObjectData2^.IWidth * pObjectData2^.IHeight * 2), sofromcurrent);
            inc(pos, (pObjectData2^.IWidth * pObjectData2^.IHeight * 2));
        end;
        ReFreshDataPos;
        Stream.Free;
    except
        if Stream <> nil then Stream.Free;
        Clear;
        exit;
    end;
    Result := 0;
end;

procedure TObjectDataList.LoadFrom(aName:string);
begin
    if pgkmap.isfile(aName) = FALSE then
    begin
        LoadFromFile(aName);
        exit;
    end;
    LoadFromPgk(aName);
end;

procedure TObjectDataList.LoadFromPgk(aFileName:string);
var
    asize           :integer;
    FileObjectHeader:TFileObjectHeader;
begin
    if pgkmap.isfile(aFileName) = FALSE then
    begin

        exit;
    end;

    try
        if pgkmap.Position(aFileName, asize) = false then exit;

        pgkmap.ReadBuffer(@FileObjectHeader, sizeof(FileObjectHeader));

    except

        FillChar(FileObjectHeader, sizeof(FileObjectHeader), 0);
        exit;
    end;

    if StrLIComp(PChar(ID2), FileObjectHeader.Ident, 8) <> 0 then
    else LoadFromPgkATZOBJ2(aFileName);

    if StrLIComp(PChar(ID3), FileObjectHeader.Ident, 8) <> 0 then
    else LoadFromPgkATZOBJ3(aFileName);
end;

procedure TObjectDataList.LoadFromFile(aFileName:string);
var
    Stream          :TFileStream;
    FileObjectHeader:TFileObjectHeader;
  tmpFilename: string;
begin
 
    tmpFilename := '.\map\' + Enc(AnsiUpperCase(aFileName)) + '.do';
    if FileExists(tmpFilename) = FALSE then exit;
    Stream := nil;
    try
        Stream := TFileStream.Create(tmpFilename, fmOpenRead or fmShareDenyNone);
        Stream.Seek(16,0);
        Stream.ReadBuffer(FileObjectHeader, sizeof(FileObjectHeader));
        Stream.Free;
    except
        if Stream <> nil then Stream.Free;
        FillChar(FileObjectHeader, sizeof(FileObjectHeader), 0);
        exit;
    end;

    if StrLIComp(PChar(ID2), FileObjectHeader.Ident, 8) <> 0 then
    else LoadFromFileATZOBJ2(aFileName);

    if StrLIComp(PChar(ID3), FileObjectHeader.Ident, 8) <> 0 then
    else LoadFromFileATZOBJ3(aFileName);
end;

procedure TObjectDataList.LoadFromHeaderpgk(aFileName:string);
var
    i               :Integer;
    Stream          :TMemoryStream;
    FileObjectHeader:TFileObjectHeader;
    pObjectData     :PTObjectData;
begin
    if pgkmap.isfile(aFileName) = false then exit;
    Clear;
    Stream := TMemoryStream.Create;
    try

        try
            pgkmap.get(aFileName, Stream);
            Stream.Position := 0;
            Stream.ReadBuffer(FileObjectHeader, sizeof(FileObjectHeader));

            if StrLIComp(PChar(HeaderFileID), FileObjectHeader.Ident, 8) <> 0 then
                raise Exception.Create('Not a valid Object Library File');

            for i := 0 to FileObjectHeader.NObject - 1 do
            begin
                new(pObjectData);

                Stream.ReadBuffer(pObjectData^, sizeof(TObjectData));
                pObjectData^.Bits := nil;
                DataList.Add(pObjectData);
            end;
            ReFreshDataPos;

        except
            Clear;
        end;
    finally
        Stream.Free;
    end;
end;

procedure TObjectDataList.LoadFromHeaderFile(aFileName:string);
var
    i               :Integer;
    Stream          :TFileStream;
    FileObjectHeader:TFileObjectHeader;
    pObjectData     :PTObjectData;
  tmp: string;
begin
 
    if FileExists(aFileName) = FALSE then exit;
    Clear;
    Stream := nil;
    try
        Stream := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyNone);
        Stream.Seek(16,0);
        Stream.ReadBuffer(FileObjectHeader, sizeof(FileObjectHeader));

        if StrLIComp(PChar(HeaderFileID), FileObjectHeader.Ident, 8) <> 0 then
            raise Exception.Create('Not a valid Object Library File');

        for i := 0 to FileObjectHeader.NObject - 1 do
        begin
            new(pObjectData);

            Stream.ReadBuffer(pObjectData^, sizeof(TObjectData));
            pObjectData^.Bits := nil;
              Inc(pObjectData^.DataPos, 16);
            DataList.Add(pObjectData);
        end;
        ReFreshDataPos;
        Stream.Free;
    except
        if Stream <> nil then Stream.Free;
        Clear;
        exit;
    end;
end;

end.

