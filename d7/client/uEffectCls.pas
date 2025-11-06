unit uEffectCls;

interface

uses
   Classes, Sysutils, Windows,
   uXDibA;

const
  EffectFileID02 = 'EFD2';
  EffectFileID01 = 'EFD1';
  EffectFileID00 = 'EFD0';

  Char_Max_Dir = 8;

type
  TEffectMethodData = packed record
    rStart : byte;
    rEnd : byte;
  end;

  TEffectMethod = packed record
    rStart : TEffectMethodData;
    rKeepUp : TEffectMethodData;
    rEnd : TEffectMethodData;
  end;

  TEffectDataHeader = packed record
    rIdent : array [0..6-1] of char;
    rSoundName : string[8];
    rEffectCount : byte;
    rFrontImageCount : byte;
    rBackImageCount : byte;
    rFrontSubImageCount : byte;
    rShadowImageCount : byte;
  end;

  TEffectDir = packed record
    rX, rY : Smallint;
  end;

  TEffectCoordinate = array [0..Char_Max_Dir-1] of TEffectDir;

  TEffectImageDESC = packed record
    rImage : Smallint;
    rX, rY : Smallint;
    rScaleX, rScaleY : byte;
    rDrawType : byte;
  end;
  PTEffectImageDESC = ^TEffectImageDESC;

  TEffectItem = packed record
    rAlphaValue : byte;
    rDelay : byte;
    rFront : TEffectImageDESC;
    rBack : TEffectImageDESC;
    rFrontSub : TEffectImageDESC;
    rShadow : TEffectImageDESC;
  end;
  PTEffectItem =^TEffectItem;

  TEffectDataClass = class
    private
      DataList : TList;

      FrontImageList : TList;
      BackImageList : TList;
      FrontSubImageList : TList;
      ShadowImageList : TList;

      FEffectName : string;
      FSoundName : string;
      FCoordinate : TEffectCoordinate;
      FEffectMethod : TEffectMethod;
      function GetDataCount: integer;
      function GetFrontImageCount: integer;
      function GetBackImageCount: integer;
      function GetFrontSubImageCount: integer;
      function GetShadowImageCount: integer;

      function GetDelay (Index: integer): integer;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear;

      procedure AddFrontImage (aXDib: TXDib);
      procedure DelFrontImage (aIndex: integer);
      function GetFrontImage (p: PTEffectItem): TXDib;
      function GetFrontImageData (aIndex: integer): TXDib;

      procedure AddBackImage (aXDib : TXDib);
      procedure DelBackImage (aIndex: integer);
      function GetBackImage (p: PTEffectItem): TXDib;
      function GetBackImageData (aIndex: integer): TXDib;

      procedure AddFrontSubImage (aXDib : TXDib);
      procedure DelFrontSubImage (aIndex: integer);
      function GetFrontSubImage (p: PTEffectItem): TXDib;
      function GetFrontSubImageData (aIndex: integer): TXDib;

      procedure AddShadowImage (aXDib : TXDib);
      procedure DelShadowImage (aIndex: integer);
      function GetShadowImage (p: PTEffectItem): TXDib;
      function GetShadowImageData (aIndex: integer): TXDib;

      procedure AddEffect (P: PTEffectItem);
      procedure DelEffect (aIndex: integer);
      function GetEffect (aIndex: integer): PTEffectItem;

      procedure SetCoordinate (aDir, aX, aY: integer);
      procedure GetCoordinate (aDir: integer; var aX, aY: integer);

      procedure SetMethod (aEffectMethod : TEffectMethod);

      procedure LoadFromStreamID00 (aStream: TStream);
      procedure LoadFromStreamID01 (aStream: TStream);
      procedure LoadFromStreamID02 (aStream: TStream);
      procedure LoadFromFile (aFileName: string);
      procedure SaveToFile (aFileName: string);
      procedure LoadFromStream (aStream : TStream);
      procedure SaveToStream (aStream: TStream);

      property SoundName : string read FSoundName write FSoundName;
      property EffectName : string read FEffectName write FEffectName;

      property FrontImageCount : integer read GetFrontImageCount;
      property BackImageCount : integer read GetBackImageCount;
      property FrontSubImageCount : integer read GetFrontSubImageCount;
      property ShadowImageCount : integer read GetShadowImageCount;

      property DataCount : integer read GetDataCount;
      property Delay[Index: integer] : integer read GetDelay;
      property EffectMethod : TEffectMethod read FEffectMethod write FEffectMethod;
  end;

  TEffectDataItem = record
    aEffectdata : TEffectDataClass;
    aUsedCount : integer;
  end;
  PTEffectDataItem = ^TEffectDataItem;

  TEffectDataList = class
    private
      DataList : TList;
      FRootdir : string;
    public
      constructor Create (aRootDir: string);
      destructor Destroy; override;
      procedure Clear;

      function GetEffectData (aFileName: string): TEffectDataClass;
      procedure FreeEffectData (aEffectDataClass: TEffectDataClass);

      function GetResCount: integer;
  end;

implementation

uses FMain;

////////////////////////////////////////////////////////////////////////////////
//                            TEffectDataClass
////////////////////////////////////////////////////////////////////////////////
constructor TEffectDataClass.Create;
begin
   DataList := TList.Create;
   FrontImageList := TList.Create;
   BackImageList := TList.Create;
   FrontSubImageList := TList.Create;
   ShadowImageList := TList.Create;

   FEffectName := '';
   FSoundName := '';
   Fillchar (FCoordinate, sizeof(FCoordinate), 0);
   Fillchar (FEffectMethod, sizeof(FEffectMethod), 0);
end;

destructor TEffectDataClass.Destroy;
begin
   Clear;

   FrontImageList.Free;
   BackImageList.Free;
   FrontSubImageList.Free;
   ShadowImageList.Free;

   DataList.Free;
   inherited Destroy;
end;

procedure TEffectDataClass.Clear;
var
   i : integer;
   XDib : TXDib;
   p : PTEffectItem;
begin
   FEffectName := '';
   FSoundName := '';
   Fillchar (FCoordinate, sizeof(TEffectCoordinate), 0);
   Fillchar (FEffectMethod, sizeof(TEffectMethod), 0);

   for i := 0 to DataList.Count -1 do begin
      p := DataList[i];
      dispose (p);
   end;
   DataList.Clear;

   for i := 0 to FrontImageList.Count -1 do begin
      XDib := FrontImageList[i];
      if XDib <> nil then XDib.Free;
   end;
   FrontImageList.Clear;

   for i := 0 to BackImageList.Count -1 do begin
      XDib := BackImageList[i];
      if XDib <> nil then XDib.Free;
   end;
   BackImageList.Clear;

   for i := 0 to FrontSubImageList.Count -1 do begin
      XDib := FrontSubImageList[i];
      if XDib <> nil then XDib.Free;
   end;
   FrontSubImageList.Clear;

   for i := 0 to ShadowImageList.Count -1 do begin
      XDib := ShadowImageList[i];
      if XDib <> nil then XDib.Free;
   end;
   ShadowImageList.Clear
end;

function TEffectDataClass.GetDataCount: integer;
begin
   Result := DataList.Count;
end;

procedure TEffectDataClass.AddFrontImage(aXDib : TXDib);
begin
   FrontImageList.Add (aXDib);
end;

procedure TEffectDataClass.DelFrontImage(aIndex: integer);
begin
   if (aIndex < 0) or (aIndex > FrontImageList.Count -1) then exit;
   FrontImageList.Delete(aIndex);
end;

function TEffectDataClass.GetFrontImage (p : PTEffectItem): TXDib;
begin
   Result := nil;
   if p <> nil then begin
      if (p^.rFront.rImage < 0) or (p^.rFront.rImage > FrontImageList.Count -1) then exit;
      Result := FrontImageList[p^.rFront.rImage];
   end;
end;

function TEffectDataClass.GetFrontImageData (aIndex: integer): TXDib;
begin
   Result := nil;
   if (aIndex < 0) or (aIndex > FrontImageList.Count -1) then exit;
   Result := FrontImageList[aIndex];
end;

procedure TEffectDataClass.AddBackImage(aXDib : TXDib);
begin
   BackImageList.Add (aXDib);
end;

procedure TEffectDataClass.DelBackImage(aIndex: integer);
begin
   if (aIndex < 0) or (aIndex > BackImageList.Count -1) then exit;
   BackImageList.Delete(aIndex);
end;

function TEffectDataClass.GetBackImage (p: PTEffectItem): TXDib;
begin
   Result := nil;
   if p = nil then exit;
   if (p^.rBack.rImage < 0) or (p^.rBack.rImage > BackImageList.Count -1) then exit;
   Result := BackImageList[p^.rBack.rImage];
end;

function TEffectDataClass.GetBackImageData (aIndex: integer): TXDib;
begin
   Result := nil;
   if (aIndex < 0) or (aIndex > BackImageList.Count -1) then exit;
   Result := BackImageList[aIndex];
end;

procedure TEffectDataClass.AddFrontSubImage (aXDib : TXDib);
begin
   FrontSubImageList.Add (aXDib);
end;

procedure TEffectDataClass.DelFrontSubImage (aIndex: integer);
begin
   if (aIndex < 0) or (aIndex > FrontSubImageList.Count -1) then exit;
   FrontSubImageList.Delete(aIndex);
end;

function TEffectDataClass.GetFrontSubImage (p: PTEffectItem): TXDib;
begin
   Result := nil;
   if p = nil then exit;
   if (p^.rFrontSub.rImage < 0) or (p^.rFrontSub.rImage > FrontSubImageList.Count -1) then exit;
   Result := FrontSubImageList[p^.rFrontSub.rImage];
end;

function TEffectDataClass.GetFrontSubImageData (aIndex: integer): TXDib;
begin
   Result := nil;
   if (aIndex < 0) or (aIndex > FrontSubImageList.Count -1) then exit;
   Result := FrontSubImageList[aIndex];
end;
////////////////////////////////////////////////////////////////////////////////
procedure TEffectDataClass.AddShadowImage (aXDib : TXDib);
begin
   ShadowImageList.Add (aXDib);
end;

procedure TEffectDataClass.DelShadowImage (aIndex: integer);
begin
   if (aIndex < 0) or (aIndex > ShadowImageList.Count -1) then exit;
   ShadowImageList.Delete(aIndex);
end;

function TEffectDataClass.GetShadowImage (p: PTEffectItem): TXDib;
begin
   Result := nil;
   if p = nil then exit;
   if (p^.rShadow.rImage < 0) or (p^.rShadow.rImage > ShadowImageList.Count -1) then exit;
   Result := ShadowImageList[p^.rShadow.rImage];
end;

function TEffectDataClass.GetShadowImageData (aIndex: integer): TXDib;
begin
   Result := nil;
   if (aIndex < 0) or (aIndex > ShadowImageList.Count -1) then exit;
   Result := ShadowImageList[aIndex];
end;
////////////////////////////////////////////////////////////////////////////////
procedure TEffectDataClass.AddEffect (P: PTEffectItem);
begin
   DataList.Add (p);
end;

procedure TEffectDataClass.DelEffect (aIndex: integer);
begin
   if (aIndex < 0) or (aIndex > DataList.Count -1) then exit;
   DataList.Delete (aIndex);
end;

function TEffectDataClass.GetEffect (aIndex: integer): PTEffectItem;
begin
   Result := nil;
   if (aIndex < 0) or (aIndex > DataList.Count -1) then exit;
   Result := DataList[aIndex];
end;

procedure TEffectDataClass.SetCoordinate (aDir, aX, aY: integer);
begin
   if (aDir < 0) or (aDir > Char_Max_Dir -1) then exit;
   FCoordinate[aDir].rX := aX;
   FCoordinate[aDir].rY := aY;
end;

procedure TEffectDataClass.GetCoordinate (aDir: integer; var aX, aY: integer);
begin
   if (aDir < 0) or (aDir > Char_Max_Dir -1) then exit;
   aX := FCoordinate[aDir].rX;
   aY := FCoordinate[aDir].rY;
end;

procedure TEffectDataClass.SetMethod (aEffectMethod : TEffectMethod);
begin
   FEffectMethod := aEffectMethod;
end;

type
  TEffectDir00 = packed record
    aX, aY : integer;
  end;

  TEffectCoordinate00 = array [0..Char_Max_Dir-1] of TEffectDir00;

  TEffectDataHeader00 = packed record
    aIdent : array [0..6-1] of char;
    aEffectCount : integer;
    aFrontImageCount : integer;
    aBackImageCount : integer;
    aSoundName : string[32];
  end;

  TEffectItem00 = packed record
    aAlphaValue : byte;
    aFrontX, aFrontY : integer;
    aBackX, aBackY : integer;
    aFScaleX, aFScaleY : single;
    aBScaleX, aBScaleY : single;
    aFrontDrawType : byte;
    aBackDrawType : byte;
    aDelay : integer;
    aFrontImage : integer;
    aBackImage : integer;
  end;
  PTEffectItem00 =^TEffectItem00;


procedure TEffectDataClass.LoadFromStreamID00 (aStream: TStream);
var
   EffectDataHeader00 : TEffectDataHeader00;
   EffectCoordinate00 : TEffectCoordinate00;
   i : integer;
   po : PTEffectItem00;
   p : PTEffectItem;
   XDib : TXDib;
begin
   if aStream = nil then exit;
   aStream.Seek(0, soFromBeginning);
   Clear;

   aStream.Read (EffectDataHeader00, sizeof (TEffectDataHeader00));
   if EffectDataHeader00.aIdent <> EffectFileID00 then begin
      Clear;
      exit;
   end;

   aStream.Read (EffectCoordinate00, sizeof(EffectCoordinate00));
   for i := 0 to Char_Max_Dir -1 do begin
      FCoordinate[i].rX := EffectCoordinate00[i].aX;
      FCoordinate[i].rY := EffectCoordinate00[i].aY;
   end;

   Fillchar (FEffectMethod, sizeof(TEffectMethod), 0);
   if EffectDataHeader00.aEffectCount > 255 then begin
      raise Exception.Create('파일구조가 잘못되었음 [255개이상의 Data]'+ FEffectName);
      Clear;
      exit;
   end;

   for i := 0 to EffectDataHeader00.aEffectCount -1 do begin
      new (po);
      new (p);
      aStream.Read (po^, sizeof(TEffectItem00));

      p^.rAlphaValue := po^.aAlphaValue;
      p^.rDelay := po^.aDelay;

      p^.rFront.rImage := po^.aFrontImage;
      p^.rFront.rX := po^.aFrontX;
      p^.rFront.rY := po^.aFrontY;
      p^.rFront.rScaleX := 1;
      p^.rFront.rScaleY := 1;
      p^.rFront.rDrawType := po^.aFrontDrawType;

      p^.rBack.rImage := po^.aBackImage;
      p^.rBack.rX := po^.aBackX;
      p^.rBack.rY := po^.aBackY;
      p^.rBack.rScaleX := 1;
      p^.rBack.rScaleY := 1;
      p^.rBack.rDrawType := po^.aBackDrawType;

      p^.rFrontSub.rImage := -1;
      p^.rFrontSub.rX := 0;
      p^.rFrontSub.rY := 0;
      p^.rFrontSub.rScaleX := 1;
      p^.rFrontSub.rScaleY := 1;
      p^.rFrontSub.rDrawType := 3; // Screen;

      p^.rShadow.rImage := -1;
      p^.rShadow.rX := 0;
      p^.rShadow.rY := 0;
      p^.rShadow.rScaleX := 1;
      p^.rShadow.rScaleY := 1;
      p^.rShadow.rDrawType := 11; // Screen;

      DataList.Add (p);
      dispose (po);
   end;

   for i := 0 to EffectDataHeader00.aFrontImageCount -1 do begin
      XDib := TXDib.Create;
      XDib.LoadFromStream (aStream);
      FrontImageList.Add (XDib);
   end;

   for i := 0 to EffectDataHeader00.aBackImageCount -1 do begin
      XDib := TXDib.Create;
      XDib.LoadFromStream (aStream);
      BackImageList.Add (XDib);
   end;
end;

procedure TEffectDataClass.LoadFromStreamID02 (aStream: TStream);
var
   EffectDataHeader : TEffectDataHeader;
   i : integer;
   p : PTEffectItem;
   XDib : TXDib;
begin
   if aStream = nil then exit;
   aStream.Seek(0, soFromBeginning);
   Clear;

   aStream.Read (EffectDataHeader, sizeof (TEffectDataHeader));
   if EffectDataHeader.rIdent <> EffectFileID02 then begin
      Clear;
      exit;
   end;

   aStream.Read (FCoordinate, sizeof(FCoordinate));
   aStream.Read (FEffectMethod, sizeof(FEffectMethod));

   for i := 0 to EffectDataHeader.rEffectCount -1 do begin
      new (p);
      aStream.Read (p^, sizeof(TEffectItem));
      DataList.Add (p);
   end;

   for i := 0 to EffectDataHeader.rFrontImageCount -1 do begin
      XDib := TXDib.Create;
      XDib.LoadFromStream (aStream);
      FrontImageList.Add (XDib);
   end;

   for i := 0 to EffectDataHeader.rBackImageCount -1 do begin
      XDib := TXDib.Create;
      XDib.LoadFromStream (aStream);
      BackImageList.Add (XDib);
   end;

   for i := 0 to EffectDataHeader.rFrontSubImageCount -1 do begin
      XDib := TXDib.Create;
      XDib.LoadFromStream (aStream);
      FrontSubImageList.Add (XDib);
   end;

   for i := 0 to EffectDataHeader.rShadowImageCount -1 do begin
      XDib := TXDib.Create;
      XDib.LoadFromStream (aStream);
      ShadowImageList.Add (XDib);
   end;
end;

procedure TEffectDataClass.LoadFromStreamID01 (aStream: TStream);
var
   EffectDataHeader : TEffectDataHeader;
   i : integer;
   p : PTEffectItem;
   XDib : TXDib;
begin
   if aStream = nil then exit;
   aStream.Seek(0, soFromBeginning);
   Clear;

   aStream.Read (EffectDataHeader, sizeof (TEffectDataHeader));
   if EffectDataHeader.rIdent <> EffectFileID01 then begin
      Clear;
      exit;
   end;

   aStream.Read (FCoordinate, sizeof(FCoordinate));
   Fillchar (FEffectMethod, sizeof(FEffectMethod), 0);

   for i := 0 to EffectDataHeader.rEffectCount -1 do begin
      new (p);
      aStream.Read (p^, sizeof(TEffectItem));
      DataList.Add (p);
   end;

   for i := 0 to EffectDataHeader.rFrontImageCount -1 do begin
      XDib := TXDib.Create;
      XDib.LoadFromStream (aStream);
      FrontImageList.Add (XDib);
   end;

   for i := 0 to EffectDataHeader.rBackImageCount -1 do begin
      XDib := TXDib.Create;
      XDib.LoadFromStream (aStream);
      BackImageList.Add (XDib);
   end;

   for i := 0 to EffectDataHeader.rFrontSubImageCount -1 do begin
      XDib := TXDib.Create;
      XDib.LoadFromStream (aStream);
      FrontSubImageList.Add (XDib);
   end;

   for i := 0 to EffectDataHeader.rShadowImageCount -1 do begin
      XDib := TXDib.Create;
      XDib.LoadFromStream (aStream);
      ShadowImageList.Add (XDib);
   end;
end;

procedure TEffectDataClass.LoadFromFile (aFileName: string);
var Stream : TFileStream;
begin
   if not FileExists(aFileName) then exit;
   Stream := nil;
   try
      Stream := TFileStream.Create (aFileName, fmOpenRead or fmShareDenyWrite);
      LoadFromStream (Stream);
   except
      if Stream <> nil then Stream.Free;
      exit;
   end;
   if Stream <> nil then Stream.Free;
end;

procedure TEffectDataClass.SaveToFile (aFileName: string);
var Stream : TFileStream;
begin
   Stream := nil;
   try
      Stream := TFileStream.Create (aFileName, fmCreate or fmOpenReadWrite);
      SaveToStream (Stream);
   except
      if Stream <> nil then Stream.Free;
      exit;
   end;
   if Stream <> nil then Stream.Free;
end;

procedure TEffectDataClass.LoadFromStream (aStream : TStream);
var
   EffectDataHeader : TEffectDataHeader;
begin
   if aStream = nil then exit;
   aStream.Read (EffectDataHeader, sizeof (TEffectDataHeader));
   if EffectDataHeader.rIdent = EffectFileID00 then begin LoadFromStreamID00(aStream); exit end;
   if EffectDataHeader.rIdent = EffectFileID01 then begin LoadFromStreamID01(aStream); exit; end;
   if EffectDataHeader.rIdent = EffectFileID02 then begin LoadFromStreamID02(aStream); exit; end;
   Clear;
end;

procedure TEffectDataClass.SaveToStream (aStream: TStream);
var
   EffectDataHeader : TEffectDataHeader;
   i : integer;
   p : PTEffectItem;
   XDib, tmpDib : TXDib;
begin
   if aStream = nil then exit;
   EffectDataHeader.rIdent := EffectFileID02;
   EffectDataHeader.rEffectCount := DataList.Count;
   EffectDataHeader.rFrontImageCount := FrontImageList.Count;
   EffectDataHeader.rBackImageCount := BackImageList.Count;
   EffectDataHeader.rFrontSubImageCount := FrontSubImageList.Count;
   EffectDataHeader.rShadowImageCount := ShadowImageList.Count;

   aStream.Write (EffectDataHeader, sizeof(TEffectDataHeader));
   aStream.Write (FCoordinate, sizeof(FCoordinate));
   aStream.Write (FEffectMethod, sizeof(FEffectMethod));

   for i := 0 to DataList.Count -1 do begin
      p := DataList[i];
      aStream.Write (p^, sizeof (TEffectItem));
   end;

   for i := 0 to FrontImageList.Count -1 do begin
      XDib := FrontImageList[i];
      tmpDib := TXDib.Create;
      tmpDib.Assign (XDib);
      tmpDib.SaveToStream (aStream);
      tmpDib.Free;
   end;

   for i := 0 to BackImageList.Count -1 do begin
      XDib := BackImageList[i];
      tmpDib := TXDib.Create;
      tmpDib.Assign (XDib);
      tmpDib.SaveToStream (aStream);
      tmpDib.Free;
   end;

   for i := 0 to FrontSubImageList.Count -1 do begin
      XDib := FrontSubImageList[i];
      tmpDib := TXDib.Create;
      tmpDib.Assign (XDib);
      tmpDib.SaveToStream (aStream);
      tmpDib.Free;
   end;

   for i := 0 to ShadowImageList.Count -1 do begin
      XDib := ShadowImageList[i];
      tmpDib := TXDib.Create;
      tmpDib.Assign (XDib);
      tmpDib.SaveToStream (aStream);
      tmpDib.Free;
   end;
end;

function TEffectDataClass.GetFrontImageCount: integer;
begin
   Result := FrontImageList.Count;
end;

function TEffectDataClass.GetBackImageCount: integer;
begin
   Result := BackImageList.Count;
end;

function TEffectDataClass.GetFrontSubImageCount: integer;
begin
   Result := FrontSubImageList.Count;
end;

function TEffectDataClass.GetShadowImageCount: integer;
begin
   Result := ShadowImageList.Count;
end;

function TEffectDataClass.GetDelay (Index: integer): integer;
var
   p : PTEffectItem;
begin
   Result := 10;
   if (Index < 0) or (Index > DataList.Count -1) then exit;
   p := DataList[Index];
   Result := p^.rDelay;
end;

////////////////////////////////////////////////////////////////////////////////
//                            TEffectDataList
////////////////////////////////////////////////////////////////////////////////

constructor TEffectDataList.Create (aRootDir: string);
begin
   DataList := TList.Create;
   FRootdir := aRootDir;
end;

destructor TEffectDataList.Destroy;
begin
   Clear;
   DataList.Free;
   inherited Destroy;
end;

procedure TEffectDataList.Clear;
var
   i : integer;
   Pe : PTEffectDataItem;
begin
   for i := 0 to DataList.Count -1 do begin
      Pe := DataList[i];
      Pe^.aEffectdata.Free;
      dispose (Pe);
   end;
   DataList.Clear;
end;

function TEffectDataList.GetEffectData (aFileName: string): TEffectDataClass;
var
   Pe : PTEffectDataItem;
   i : integer;
begin
   Result := nil;
   if aFileName = '' then exit;
   for i := 0 to DataList.Count -1 do begin
      Pe := DataList[i];
      if Pe^.aEffectdata.EffectName = aFileName then begin
         inc (Pe^.aUsedCount);
         Result := Pe^.aEffectdata;
         exit;
      end;
   end;

   new (Pe);
   Fillchar (Pe^, sizeof(TEffectDataItem), 0);
   Pe^.aEffectdata := TEffectDataClass.Create;
   Pe^.aEffectdata.LoadFromFile (FRootdir+aFileName);
   Pe^.aEffectdata.EffectName := aFileName;
   inc (Pe^.aUsedCount);
   DataList.Add (pe);
   Result := Pe^.aEffectdata;
end;

procedure TEffectDataList.FreeEffectData (aEffectDataClass: TEffectDataClass);
var
   Pe : PTEffectDataItem;
   i : integer;
begin
   if aEffectDataClass = nil then exit;
   for i := DataList.Count -1 DownTo 0 do begin
      Pe := DataList[i];
      if Pe^.aUsedCount <= 0 then begin
         Pe^.aEffectdata.Free;
         dispose (Pe);
         DataList.Delete (i);
         continue;
      end;
      if Pe^.aEffectdata = aEffectDataClass then dec (Pe^.aUsedCount);
   end;
end;

function TEffectDataList.GetResCount: integer;
begin
   Result := DataList.Count;
end;

end.
