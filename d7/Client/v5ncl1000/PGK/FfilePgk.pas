unit FfilePgk;
{
1，PGK包头（标志，数量）
2，文件头
3，文件
2和3循环存放。
好处：增加很方便，可提高更新PGK包速度。
}
interface
uses
  Windows, SysUtils, Classes, Graphics, uKeyClass, A2Img;

type
  TFILEHEAD = record
    rname: string[64]; //PGK文件名字
    rfilecount: integer; //文件数量
  end;
  PTFILEHEAD = ^TFILEHEAD;

  TFILELISTdata = record
    rname: string[64]; //名字
    radds: integer; //起点地址
    rsize: integer; //大小
    raddsHead: integer; //头文件地址
  end;
  pTFILELISTdata = ^TFILELISTdata;

  TFileListdata_file = record
    rname: string[64]; //名字
    radds: integer; //起点地址
    rsize: integer; //大小
  end;
  pTFileListdata_file = ^TFileListdata_file;

  TFileList = class
  private

    fdata: TLIST;
    fnameindex: TStringKeyClass;
    procedure Clear();
  public
    maxid: integer;
    constructor Create;
    destructor Destroy; override;
    procedure add(aname: string; aadds, aaddsHead, asize: integer);
    procedure del(aname: string);
    function get(aname: string): pTFILELISTdata;
    function getindex(aid: integer): pTFILELISTdata;
    function getTStringKeyClass: TStringKeyClass;
  end;
    //修改模式 文件打散放到pgkTEMP目录
  Tfilepgk = class
  private
    fHEAD: TFILEHEAD;

    ffilename: string;

        // Fkeytable:T_tabel;
         //Fkeytablehead:T_tabel;
    FPath: string;
    procedure LoadFromFile_02(); //格式：全部文件头，全部文件体；
    procedure saveToFile_02;

    procedure WriteHead(tmpFileStream: TMemoryStream);
    procedure WriteFileDir(pp: pTFILELISTdata; tmpFileStream: TMemoryStream);
    procedure WriteFile(pp: pTFILELISTdata; tmpStream: TMemoryStream; tmpFileStream: TMemoryStream);
    procedure update_add(afilename: string; aStream: TMemoryStream);

  public
    fboUPdate: boolean;
    fboWrite: boolean;
    fdata: TFileList;
    FStream: TMemoryStream;
    FisOld: Boolean;
    FSaveAs:Boolean;
    constructor Create(aname: string; aWrite: boolean = false; aboUPdate: boolean = false); 
    constructor Create2(aname: string; aWrite: boolean = false; aboUPdate: boolean = false;aisOld:Boolean = False);
    destructor Destroy; override;
    procedure saveAsToFile(afilename: string);
    procedure add(afilename: string);
    procedure add_append(afilename: string);
    procedure add2(afilename: string; aStream: TMemoryStream);

    procedure del(afilename: string);
    procedure get(afilename: string; aStream: TMemoryStream);

    procedure getBmp(afilename: string; outimg: TA2Image);
    procedure getImageLib(afilename: string; outimg: TA2ImageLib);
    procedure getBitmap(afilename: string; outimg: TBitmap);

    function GETmemu(): string;
    function isfile(afilename: string): boolean;
    procedure LoadFromFile();

    procedure saveToFile;
    procedure EnCryption(buf: pointer; asize: integer);
    procedure DeCryption(buf: pointer; asize: integer);
        //1，改变 指针  2，读取
    function Position(afilename: string; var asize: integer): boolean;

    procedure ReadBuffer(Buffer: pointer; Count: Longint);
    procedure isOldFile(AisOld: Boolean);
    procedure setSaveas(Asaveas:Boolean);
  end;
  TPgkUnite = class(Tfilepgk)
  private

    pgkfile: Tfilepgk;
    pppfile: Tfilepgk;

  public
    constructor Create(aname: string);
    destructor Destroy; override;
    procedure setPGK(afile: Tfilepgk);
    procedure setppp(afile: Tfilepgk);
    procedure Unite();
  end;
const
  G_fileHeadName = 'fpk';
  G_tmpPath = '\fpkTEMP\';
implementation

////////////////////////////////////////////////////////////////////////////////
//                           TFileList
////////////////////////////////////////////////////////////////////////////////

procedure TFileList.add(aname: string; aadds, aaddsHead, asize: integer);
var
  pp: pTFILELISTdata;
begin
  pp := get(aname);
  if pp <> nil then
  begin

    pp.rname := UpperCase(aname);
    pp.radds := aadds;
    pp.rsize := asize;
    pp.raddsHead := aaddsHead;
    exit;
  end;
  new(pp);
  pp.rname := UpperCase(aname);
  pp.radds := aadds;
  pp.rsize := asize;
  pp.raddsHead := aaddsHead;
  FDATA.Add(pp);
  fnameindex.Insert(pp.rname, pp);
end;

function TFileList.getindex(aid: integer): pTFILELISTdata;
begin
  if (aid < 0) or (aid > fdata.Count - 1) then exit;
  result := fdata.Items[aid];
end;

function TFileList.get(aname: string): pTFILELISTdata;
begin
  result := fnameindex.Select(UpperCase(aname));
end;

procedure TFileList.del(aname: string);
var
  i: integer;
  pp: pTFILELISTdata;
begin
  for i := 0 to FDATA.Count - 1 do
  begin
    pp := FDATA.Items[i];
    if pp.rname = aname then
    begin
      fnameindex.Delete(pp.rname);
      dispose(pp);
      fdata.Delete(i);

      exit;
    end
  end;
end;

procedure TFileList.Clear();
var
  i: integer;
  pp: pTFILELISTdata;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    pp := fdata.Items[i];
    dispose(pp);
  end;
  fdata.Clear;
  fnameindex.Clear;
end;

constructor TFileList.Create;
begin
  inherited Create;
  FDATA := tlist.Create;
  fnameindex := TStringKeyClass.Create;
end;

destructor TFileList.Destroy;
begin
  Clear;
  FDATA.Free;
  fnameindex.Free;
  inherited Destroy;
end;
////////////////////////////////////////////////////////////////////////////////
//                           Tfilepgk
////////////////////////////////////////////////////////////////////////////////

procedure Tfilepgk.WriteHead(tmpFileStream: TMemoryStream);
var
  tempHEAD: TFILEHEAD;
  test: Integer;
begin
  if fdata.fdata.Count > 65535 then exit;
  if tmpFileStream.Size < sizeof(tempHEAD) + 65535 * sizeof(TFileListdata_file) then
  begin
    tmpFileStream.Size := sizeof(tempHEAD) + 65535 * sizeof(TFileListdata_file)+16;
  end;

  fHEAD.rname := G_fileHeadName;
  fHEAD.rfilecount := fdata.maxid;

    //1，HEAD文件头
  tempHEAD := fHEAD;
    //加密码
  DeCryption(@tempHEAD, sizeof(tempHEAD));
    //写文件
  tmpFileStream.Position := 0;
  test := 34234243;
  tmpFileStream.WriteBuffer(test, 4);
  test := 34567443;
  tmpFileStream.WriteBuffer(test, 4);
  test := 22566788;
  tmpFileStream.WriteBuffer(test, 4);
  test := 22347788;
  tmpFileStream.WriteBuffer(test, 4);
  tmpFileStream.WriteBuffer(tempHEAD, sizeof(tempHEAD));
end;

procedure Tfilepgk.WriteFileDir(pp: pTFILELISTdata; tmpFileStream: TMemoryStream);
var
  apos: integer;
  tempTFILELISTdata: TFileListdata_file;
begin
    //计算 起点
  apos := pp.raddsHead * sizeof(TFileListdata_file) + sizeof(TFILEHEAD);
    //写头
  tempTFILELISTdata.rname := pp.rname;
  tempTFILELISTdata.radds := pp.radds;
  tempTFILELISTdata.rsize := pp.rsize;

    //加密
  DeCryption(@tempTFILELISTdata, sizeof(TFileListdata_file));
  tmpFileStream.Position := apos;
  tmpFileStream.WriteBuffer(tempTFILELISTdata, sizeof(TFileListdata_file));
end;

procedure Tfilepgk.WriteFile(pp: pTFILELISTdata; tmpStream: TMemoryStream; tmpFileStream: TMemoryStream);
var
  apos: integer;
  aStream: TMemoryStream;
begin
    //计算 起点
  apos := pp.radds;
    //加密
  aStream := TMemoryStream.Create;
  try
    aStream.LoadFromStream(tmpStream);
    DeCryption(aStream.Memory, aStream.Size);
    tmpFileStream.Position := apos;
    tmpFileStream.WriteBuffer(aStream.Memory^, aStream.Size);
  finally
    aStream.Free;
  end;

end;

procedure Tfilepgk.update_add(afilename: string; aStream: TMemoryStream);
var
  pp: pTFILELISTdata;
begin
  fdata.add(afilename, 0, 0, 0);
  pp := fdata.get(afilename);
  if pp = nil then exit;
  pp.radds := FStream.Size;
  pp.rsize := aStream.Size;
  pp.raddsHead := fdata.maxid;
  inc(fdata.maxid);

    //写入 pgk HEAD
  WriteHead(FStream);
    //写目录
  WriteFileDir(pp, FStream);
    //写文件
  WriteFile(pp, aStream, FStream);
end;

procedure Tfilepgk.add_append(afilename: string);
var
  pp: pTFILELISTdata;
  aStream: TMemoryStream;
  aname: string;
begin
  if fboWrite = false then exit;
  if FileExists(afilename) = FALSE then
  begin
    Windows.MessageBox(0, PCHAR(afilename), '文件不存在', 0);
    exit;
  end;

  aname := ExtractFileName(afilename);
  aname := UpperCase(aname);
  pp := fdata.get(aname);
  if pp <> nil then
  begin
    Windows.MessageBox(0, PCHAR(afilename), PCHAR('PGK包中已经存在!' + aname), 0);
    exit;
  end;
  aStream := TMemoryStream.Create;
  try
    aStream.LoadFromFile(afilename);
    update_add(aname, aStream);
  finally
    aStream.Free;
  end;

end;

procedure Tfilepgk.add2(afilename: string; aStream: TMemoryStream);
var
  pp: pTFILELISTdata;
  aname: string;
begin
  if fboWrite = false then exit;

  aname := ExtractFileName(afilename);
  aname := UpperCase(aname);
  pp := fdata.get(aname);
  if pp <> nil then exit;
  update_add(aname, aStream);
end;

procedure Tfilepgk.add(afilename: string);
var
  pp: pTFILELISTdata;
  aStream: TMemoryStream;
  aname: string;
begin
  if fboUPdate = false then
  begin

    exit;
  end;
  if FileExists(afilename) = FALSE then
  begin
    Windows.MessageBox(0, PCHAR(afilename), '文件不存在', 0);
    exit;
  end;

  aname := ExtractFileName(afilename);
  aname := UpperCase(aname);
  pp := fdata.get(aname);
  if pp <> nil then
  begin
    del(aname);
  end;
  aStream := TMemoryStream.Create;
  try
    fdata.add(aname, 0, 0, 0);
    aStream.LoadFromFile(afilename);
    aStream.SaveToFile(FPath + G_tmpPath + aname);
  finally
    aStream.Free;
  end;

end;

procedure Tfilepgk.del(afilename: string);
begin
  if fboUPdate = false then exit;
  fdata.del(afilename);
end;

function Tfilepgk.isfile(afilename: string): boolean;
begin
  result := false;
  if fdata.get(afilename) <> nil then result := true;
end;

function Tfilepgk.GETmemu(): string;
var
  i: integer;
  pp: pTFILELISTdata;
begin
  result := '';
  for i := 0 to fdata.fdata.Count - 1 do
  begin
    pp := fdata.fdata.Items[i];
    result := result + pp.rname + #13#10;
  end;
end;

procedure Tfilepgk.getBitmap(afilename: string; outimg: TBitmap);
var
  aStream: TMemoryStream;
begin
  aStream := TMemoryStream.Create;
  try

    get(UpperCase(afilename), aStream);
    if aStream.Size > 0 then
      outimg.LoadFromStream(aStream);
  finally
    aStream.free;
  end;

end;

procedure Tfilepgk.getImageLib(afilename: string; outimg: TA2ImageLib);
var
  aStream: TMemoryStream;
begin
  aStream := TMemoryStream.Create;
  try
    aStream.Size := 0;
    get(UpperCase(afilename), aStream);
    if aStream.Size > 0 then
      outimg.LoadFromStream(aStream);
  finally
    aStream.free;
  end;

end;

procedure Tfilepgk.getBmp(afilename: string; outimg: TA2Image);
var
  aStream: TMemoryStream;
begin
  outimg.Clear(0);
  aStream := TMemoryStream.Create;
  try

    get(UpperCase(afilename), aStream);
    if aStream.Size > 0 then
      outimg.LoadFromStream(aStream);
  finally
    aStream.free;
  end;

end;

procedure Tfilepgk.ReadBuffer(Buffer: pointer; Count: Longint);
begin

  FStream.ReadBuffer(Buffer^, Count);
  EnCryption((Buffer), Count);
end;

function Tfilepgk.Position(afilename: string; var asize: integer): boolean;
var
  pp: pTFILELISTdata;
begin
  result := false;
  pp := fdata.get(UpperCase(afilename));
  if pp = nil then exit;

  FStream.Position := pp.radds;
  asize := pp.rsize;
  result := true;
end;

procedure Tfilepgk.get(afilename: string; aStream: TMemoryStream);
var
  pp: pTFILELISTdata;
begin
  pp := fdata.get(UpperCase(afilename));
  if pp = nil then exit;

  aStream.SetSize(pp.rsize);
  aStream.Position := 0;
  FStream.Position := pp.radds;
  FStream.ReadBuffer(aStream.Memory^, pp.rsize);
  EnCryption(aStream.Memory, aStream.Size);
end;

procedure Tfilepgk.EnCryption(buf: pointer; asize: integer);
var
  i: integer;
  pb: pbyte;
  bb: byte;
begin
  pb := buf;
  for i := 1 to asize do
  begin
    bb := pb^;
    asm
          rol bb,5
    end;
    pb^ := bb;
    inc(pb);
  end;

end;

procedure Tfilepgk.DeCryption(buf: pointer; asize: integer);
var
  i: integer;
  pb: pbyte;
  bb: byte;
begin
  pb := buf;
  for i := 1 to asize do
  begin
    bb := pb^;
    asm
          ror bb,5
    end;
    pb^ := bb;
    inc(pb);
  end;

end;

procedure Tfilepgk.saveAsToFile(afilename: string);
var
  pp: pTFILELISTdata;
  tmpPP: TFILELISTdata;
  i, apos, apos_head: integer;
  aStream: TMemoryStream;
  tmpFileStream: TMemoryStream;
begin
  if FileExists(afilename) = FALSE then
  begin
    tmpFileStream := TMemoryStream.Create;
    tmpFileStream.LoadFromFile(afilename);
  end else
  begin
    tmpFileStream := TMemoryStream.Create; //(afilename, fmOpenReadWrite or fmShareDenyNone);
  end;

  try
    aStream := TMemoryStream.Create;
    try
      tmpFileStream.Position := 0;
      tmpFileStream.Size := 0;
      WriteHead(tmpFileStream);
      apos := sizeof(TFILEHEAD) + 65535 * sizeof(TFileListdata_file);
      apos_head := sizeof(TFILEHEAD);
      for i := 0 to fdata.fdata.Count - 1 do
      begin
        pp := fdata.fdata.Items[i];
        tmpPP := pp^;
        get(tmpPP.rname, aStream);
        tmppp.radds := apos;
        tmpPP.raddsHead := apos_head;

        WriteFileDir(@tmpPP, tmpFileStream);
        WriteFile(@tmpPP, aStream, tmpFileStream);
        inc(apos_head, sizeof(TFileListdata_file));
        inc(apos, tmpPP.rsize);
      end;

    finally
      aStream.Free;
    end;

  finally
    tmpFileStream.Free;
  end;

end;

procedure Tfilepgk.saveToFile_02();
var
  pp: pTFILELISTdata;
  tempTFILELISTdata: TFileListdata_file;
  i, apos, apos_head: integer;
  aStream: TMemoryStream;
  tempHEAD: TFILEHEAD;
  test: Integer;
begin
  if fboUPdate = false then exit;
  if fdata.fdata.Count > 65535 then exit;
  FStream.Size := sizeof(tempHEAD) + 65535 * sizeof(TFileListdata_file)+16;
  FStream.Position := 0;
  test := 3425660;
  FStream.WriteBuffer(test, 4);
  test := 23667770;
  FStream.WriteBuffer(test, 4);
  test := 26776570;
  FStream.WriteBuffer(test, 4);
  test := 90563240;
  FStream.WriteBuffer(test, 4);
  fHEAD.rname := G_fileHeadName;
  fHEAD.rfilecount := fdata.fdata.Count;
  tempHEAD := fHEAD;
    //1，HEAD文件头
  DeCryption(@tempHEAD, sizeof(tempHEAD)); //, @tempkey);
  FStream.WriteBuffer(tempHEAD, sizeof(tempHEAD));
  aStream := TMemoryStream.Create;
  try
    apos := sizeof(tempHEAD) + 65535 * sizeof(TFileListdata_file)+16;
    apos_head := sizeof(tempHEAD)+16;

    for i := 0 to fdata.fdata.Count - 1 do
    begin
      pp := fdata.fdata.Items[i];
      aStream.Size := 0;
      if FileExists(FPath + G_tmpPath + pp.rname) then
      begin
        aStream.Position := 0;
        aStream.LoadFromFile(FPath + G_tmpPath + pp.rname);
      end;
      pp.radds := apos;
      pp.rsize := aStream.Size;
            //写头
      tempTFILELISTdata.rname := pp.rname;
      tempTFILELISTdata.radds := pp.radds;
      tempTFILELISTdata.rsize := pp.rsize;

      DeCryption(@tempTFILELISTdata, sizeof(TFileListdata_file));
      FStream.Position := apos_head;
      FStream.WriteBuffer(tempTFILELISTdata, sizeof(TFileListdata_file));
      apos_head := FStream.Position;
            //写文件
      DeCryption(aStream.Memory, aStream.Size);
      FStream.Position := apos;
      FStream.WriteBuffer(aStream.Memory^, aStream.Size);
      apos := FStream.Position;
    end;
    if FSaveAs then
      ffilename:= StringReplace(ffilename,'.pgk','.dgk',[rfReplaceAll]);
    FStream.SaveToFile(ffilename);
  finally
    aStream.Free;
  end;

end;

procedure Tfilepgk.saveToFile();
begin
  saveToFile_02;
end;

procedure Tfilepgk.LoadFromFile();
begin
  LoadFromFile_02;
end;

procedure Tfilepgk.LoadFromFile_02(); //
var
  aTFILELISTdata_file: TFileListdata_file;
  pp: pTFILELISTdata;
  i, j: integer;
  aStream: TMemoryStream;
  tempbuf: pchar;
  apos: pbyte;

begin
  FStream.Position := 0;
  fdata.Clear;
  fdata.maxid := 0;
  if FStream.Size = 0 then
  begin
    WriteHead(FStream);
    exit;
  end;
  if FStream.Size - FStream.Position < sizeof(fHEAD) then exit;
  if not FisOld then
    FStream.Seek(16, 0);
    //1，读文件头
  FStream.ReadBuffer(fHEAD, sizeof(fHEAD));

  EnCryption(@fHEAD, sizeof(fHEAD));
  if fHEAD.rfilecount > 65535 then exit;
  if fHEAD.rfilecount <= 0 then exit;
  if not FisOld then
    if fHEAD.rname <> G_fileHeadName then exit;
    //2,单文件头   预先留65535
  if FStream.Size - FStream.Position < 65535 * sizeof(TFileListdata_file) then exit;
  getmem(tempbuf, fHEAD.rfilecount * sizeof(TFileListdata_file));
  try

    FStream.ReadBuffer(tempbuf^, fHEAD.rfilecount * sizeof(TFileListdata_file));
    apos := pbyte(tempbuf);

    for i := 0 to fHEAD.rfilecount - 1 do
    begin
      aTFILELISTdata_file.rname := '';
      copymemory(@aTFILELISTdata_file, apos, sizeof(TFileListdata_file));
      EnCryption(@aTFILELISTdata_file, sizeof(TFileListdata_file));
      fdata.add(aTFILELISTdata_file.rname, aTFILELISTdata_file.radds, i, aTFILELISTdata_file.rsize);

      inc(apos, sizeof(TFileListdata_file));

    end;
    fdata.maxid := fHEAD.rfilecount;
        //3，文件体
  finally
    freemem(tempbuf, 65535 * sizeof(TFileListdata_file));
  end;

  if fboUPdate then
  begin
    aStream := TMemoryStream.Create;
    try
      for i := 0 to fdata.fdata.Count - 1 do
      begin
        pp := fdata.getindex(i);
        if pp = nil then Continue;
        get(pp.rname, aStream);
        aStream.Position := 0;
        if not DirectoryExists(FPath + G_tmpPath) then CreateDir(FPath + G_tmpPath);
        aStream.SaveToFile(FPath + G_tmpPath + pp.rname);
      end;
    finally
      aStream.Free;
    end;

  end;
end;

constructor Tfilepgk.Create(aname: string; aWrite: boolean = false; aboUPdate: boolean = false);

begin
  inherited Create;
  if not FisOld then
  FisOld := False;
  FSaveAs:=False;
  ffilename := aname;
  FPath := ExtractFileDir(ffilename);
  fdata := TFileList.Create;
  fboUPdate := aboUPdate;
  fboWrite := aWrite;
  if fboWrite then
  begin
    if FileExists(ffilename) = FALSE then
    begin
      FStream := TMemoryStream.Create;
      FStream.LoadFromFile(ffilename);
      FStream.Free;
      FStream := nil;
    end;
    FStream := TMemoryStream.Create; //(ffilename, fmOpenReadWrite or fmShareDenyNone);
  end else
  begin
    if FileExists(ffilename) = FALSE then
    begin
      FStream := nil;
      Windows.MessageBox(0, PCHAR(ffilename), '文件不存在', 0);
      exit;
    end;
    FStream := TMemoryStream.Create;
    FStream.LoadFromFile(ffilename);
  end;

  LoadFromFile();

end;

destructor Tfilepgk.Destroy;
begin
    // saveToFile(ffilename);

  fdata.Free;
  if FStream <> nil then FStream.Free;
  inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
//                       TPgkUnite
////////////////////////////////////////////////////////////////////////////////

procedure TPgkUnite.setPGK(afile: Tfilepgk);
begin
  pgkfile := afile;
end;

procedure TPgkUnite.setppp(afile: Tfilepgk);
begin
  pppfile := afile;
end;

constructor TPgkUnite.Create(aname: string);
begin
  inherited Create(aname, TRUE );
  pppfile := nil;
  pgkfile := nil;
end;

destructor TPgkUnite.Destroy;
begin

  inherited Destroy;
end;

procedure TPgkUnite.Unite();
var
  pp: pTFILELISTdata;
  tempTFILELISTdata: TFILELISTdata;
  i: integer;
  aStream: TMemoryStream;
  uaddstitle, uadds, usize: integer;
    //    tempkey, tempkey2:T_tabel;
  tempHEAD: TFILEHEAD;
begin
    //存头
    //存文件列表
    //存文件

  if pppfile = nil then exit;
  if pgkfile = nil then exit;
  fdata.Clear;
    //    tempkey := Fkeytablehead;
  usize := pppfile.fdata.fdata.Count + pgkfile.fdata.fdata.Count;
  FStream.Size := 0;
  FStream.Position := 0;
  fHEAD.rname := G_fileHeadName;
  fHEAD.rfilecount := usize;
  tempHEAD := fHEAD;
  DeCryption(@tempHEAD, sizeof(tempHEAD)); //, @tempkey);
  FStream.WriteBuffer(tempHEAD, sizeof(tempHEAD));

  aStream := TMemoryStream.Create;
  try

        //目录
    for i := 0 to pppfile.fdata.fdata.Count - 1 do
    begin
      pp := pppfile.fdata.fdata.Items[i];
      fdata.add(pp.rname, 0, 0, 0);
    end;
    for i := 0 to pgkfile.fdata.fdata.Count - 1 do
    begin
      pp := pgkfile.fdata.fdata.Items[i];
      fdata.add(pp.rname, 0, 0, 0);
    end;
        //存目录
    uaddstitle := sizeof(fHEAD);
    uadds := uaddstitle + sizeof(TFILELISTdata) * usize;
    for i := 0 to fdata.fdata.Count - 1 do
    begin
      pp := fdata.fdata.Items[i];

      aStream.Size := 0;
      if pppfile.isfile(pp.rname) then
      begin
        pppfile.get(pp.rname, aStream);

      end
      else if pgkfile.isfile(pp.rname) then
      begin
        pgkfile.get(pp.rname, aStream);
      end;

      pp.radds := uadds;
      pp.rsize := aStream.Size;
            //写头
      FStream.Position := uaddstitle;
      tempTFILELISTdata := pp^;
      DeCryption(@tempTFILELISTdata, sizeof(TFILELISTdata)); //, @tempkey);
      FStream.WriteBuffer(tempTFILELISTdata, sizeof(TFILELISTdata));

      uaddstitle := uaddstitle + sizeof(TFILELISTdata);

      uadds := uadds + aStream.Size;
    end;
        //        tempkey2 := tempkey;
                //存文件
    for i := 0 to usize - 1 do
    begin
      pp := fdata.fdata.Items[i];

      aStream.Size := 0;
      if pppfile.isfile(pp.rname) then
      begin
        pppfile.get(pp.rname, aStream);

      end
      else if pgkfile.isfile(pp.rname) then
      begin
        pgkfile.get(pp.rname, aStream);
      end;

            //写文件
      FStream.Position := pp.radds;
            //            tempkey := tempkey2;
      DeCryption(aStream.Memory, aStream.Size); //, @tempkey);
      FStream.WriteBuffer(aStream.Memory^, aStream.Size);

    end;
  finally
    aStream.Free;
  end;

end;

function TFileList.getTStringKeyClass: TStringKeyClass;
begin
  Result := fnameindex;
end;

procedure Tfilepgk.isOldFile(AisOld: Boolean);
begin
  FisOld := AisOld;
end;

constructor Tfilepgk.Create2(aname: string; aWrite, aboUPdate,
  aisOld: Boolean);
begin
    FisOld:=aisOld;
  Create(aname,aWrite,aboUPdate);

end;

procedure Tfilepgk.setSaveas(Asaveas: Boolean);
begin
  FSaveAs:=Asaveas;
end;

end.

