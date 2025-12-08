unit USound;

interface

uses Windows, Classes, SysUtils, DXSounds, AUtil32, MMSystem, Wave,
    DefType, uAnsTick, Log, uKeyClass, cbDSMixer, IniFiles;

const
    SOUND_BUFFER = 2;

    COLLECTIONWAVE_ID = 'ATW0';

type
    TCollectionWaveFileHeader = record
        Ident: array[0..4 - 1] of char;
        Count: integer;
    end;

    TWaveData = record
        WaveName: array[0..32] of byte;
        WaveSize: integer;
        pwave: pbyte;
    end;
    PTWaveData = ^TWaveData;

    TDxWaveData = record
        WC: TWaveCollectionItem;
        SmallFlag: Boolean;
        UsedTick: integer;
    end;
    PTDxWaveData = ^TDxWaveData;

    TwavefileListdata = record
        rname: string[64];
        WaveData: TWaveData;
        rpos: integer;
    end;
    pTwavefileListdata = ^TwavefileListdata;
    TwavefileList = class
    private
        data: tlist;
        indexname: TStringKeyClass;
        procedure Clear();
    public
        constructor Create;
        destructor Destroy; override;
        procedure add(aitem: TwavefileListdata);

        procedure del(aname: string);

        function get(aname: string): pTwavefileListdata;

    end;

    TSoundManager = class
    private
        //      WaveStringList:TStringList;
      //        NewWaveStringList:TStringList;
        FFileName: string;
        FNewFileName: string;
        //        FDxWaveList:TDxWaveList;
        DataList: TList;
        FVolume: integer;
        FVolumeEffect: integer;
        FDXSound: TDXSound;
        FBoPlay: Boolean;
        FRoopCount: integer;

        //
        wavefileList: TwavefileList;
        FDXWaveList: TDXWaveList;

        //MP3
        dsm: TcbDSMixer;
        FWB1: TcbDSMixerChannel;
        boACTIVATEAPP_State: boolean;
        boACTIVATEAPP: boolean;
        ACTIVATEAPPTime: integer;
        function GetDxWaveData(aName: string): PTDxWaveData;
        function GetDxWaveDataMin(): PTDxWaveData;
        procedure SetVolume(Value: integer);
        procedure SetVolumeEffect(Value: integer);

    public

        AudioBase: TAudioFileStream;

        constructor Create(aDxSound: TDXSound; aFileName, aNewFileName: string; aDxWaveList: TDXWaveList);
        destructor Destroy; override;

        function RangeCompute(X: Integer; TagetX: word): Integer;
        function RangeVolume(X, Y: Integer; TagetX, TagetY: word; volume: Integer): Integer;

        procedure UpDate(CurTime: DWORD);

        procedure NewPlayEffect(aEffectName: string; apan: integer);
        procedure PlayBaseAudio(aFileName: string; aRoopCount: integer);

        procedure PlayBaseAudioMp3(aFileName: string; aRoopCount: integer);
        procedure activateapp(Value: boolean);
        property boPlay: Boolean read FBoPlay write FBoPlay;
        property Volume: integer read FVolume write SetVolume;
        property VolumeEffect: integer read FVolumeEffect write SetVolumeEffect;

        property DxSound: TDXSound read FDxSound write FDXSound;
    end;

implementation

uses FMain, FBottom, forms;
//////////////////////////////////////////
//            TwavefileList

constructor TwavefileList.Create;
begin
    data := TList.Create;
    indexname := TStringKeyClass.Create;
end;

destructor TwavefileList.Destroy;
begin
    Clear;
    data.Free;
    indexname.Free;
    inherited Destroy;
end;

procedure TwavefileList.add(aitem: TwavefileListdata);
var
    p: pTwavefileListdata;
begin

    p := get(aitem.rname);
    if p <> nil then
    begin
        raise Exception.Create('声音文件列表发现重复文件:' + aitem.rname);
        exit;
    end;
    new(p);
    p^ := aitem;
    data.Add(p);
    indexname.Insert(p.rname, p);
end;

procedure TwavefileList.del(aname: string);
var
    p: pTwavefileListdata;
    str: string;
    i: integer;
begin
    aname := trim(aname);
    if aname = '' then exit;
    p := get(aname);
    if p = nil then exit;
    for i := 0 to data.Count - 1 do
    begin
        p := data.Items[i];

        if aname = p.rname then
        begin
            data.Delete(i);
            indexname.Delete(aname);
            dispose(p);
            exit;
        end;
    end;
end;

function TwavefileList.get(aname: string): pTwavefileListdata;
begin
    result := indexname.Select(aname);
end;

procedure TwavefileList.Clear();
var
    p: PTWaveData;
    i: integer;
begin
    for i := 0 to data.Count - 1 do
    begin
        p := data.Items[i];
        dispose(p);
    end;
    data.Clear;
    indexname.Clear;
end;

////////////////////////////////////

constructor TSoundManager.Create(aDxSound: TDXSound; aFileName, aNewFileName: string; aDxWaveList: TDXWaveList);
var
    i, pos: integer;
    pdwd: PTDxWaveData;
    Stream: TFileStream;
    Header: TCollectionWaveFileHeader;
    wd: TWaveData;
    buf: array[0..64] of char;
    wavefileListdata: TwavefileListdata;
begin
    boACTIVATEAPP_State := false;
    boACTIVATEAPP := false;
    ACTIVATEAPPTime := 0;
    dsm := TcbDSMixer.Create(FrmM);
    FWB1 := TcbDSMixerChannel.Create(DSM);

    wavefileList := TwavefileList.Create;
    FBoPlay := TRUE;
    FDXSound := aDxSound;
    AudioBase := nil;

    FVolume := -1000;
    FVolumeEffect := -1000;

    FRoopCount := 0;

    FFileName := aFileName;
    FNewFileName := aNewFileName;
    FDXWaveList := aDxWaveList;
    DataList := TList.Create;

    //
    if FileExists(aNewFileName) then
    begin
        pos := 0;
        Stream := TFileStream.Create(aNewFileName, fmOpenRead);
        try

            try

                Stream.ReadBuffer(Header, sizeof(TCollectionWaveFileHeader));
                pos := pos + sizeof(TCollectionWaveFileHeader);
                if StrLIComp(PChar(COLLECTIONWAVE_ID), Header.Ident, 4) <> 0 then
                    raise Exception.Create('Not a valid Wave Library File');

                for i := 0 to Header.Count - 1 do
                begin
                    Stream.ReadBuffer(wd, SizeOf(TWaveData));

                    if wd.WaveSize > 5 * 1000 * 1000 then
                    begin
                        //2015.11.19屏蔽 等待处理
                        StrPcopy(buf, 'Stream Read BigSize:' + IntToStr(wd.WaveSize));
                        Application.MessageBox(buf, 'USound', 0);
                        break;
                    end;

                    pos := pos + SizeOf(TWaveData);
                    Stream.Seek(wd.WaveSize, soFromCurrent);

                    wavefileListdata.rpos := pos;
                    wavefileListdata.WaveData := wd;
                    wavefileListdata.rname := UpperCase(StrPas(@wd.WaveName));
                    wavefileList.add(wavefileListdata);

                    pos := pos + wd.WaveSize;
                end;

            except
                raise exception.Create('Audio ERROR' + aNewFileName);
            end;
        finally
            Stream.Free;
        end;
    end;
    //队列支持50个声音同时播放
    {for i := 0 to SOUND_BUFFER - 1 do
    begin
        aDxWaveList.Items.Add;

        aDxWaveList.Items[i].Name := '';

        new(pdwd);
        pdwd^.WC := aDxWaveList.Items[i];
        pdwd^.UsedTick := i;
        DataList.Add(pdwd);
    end;
    }
end;

destructor TSoundManager.Destroy;
var
    i: integer;
begin
    FWB1.FREE;

    dsm.Free;

    wavefileList.Free;
    if Audiobase <> nil then
    begin
        AudioBase.Stop;
        AudioBase.Free;
        Audiobase := nil;
    end;

    for i := 0 to DataList.Count - 1 do dispose(DataList[i]);
    DataList.Free;
    inherited Destroy;
end;

procedure TSoundManager.SetVolume(Value: integer);
var
    ClientIni: TIniFile;
begin
    FVolume := Value;
    if AudioBase <> nil then AudioBase.Volume := Value;

    FWB1.Volume := FVolume;

    ClientIni := TIniFile.Create('.\ClientIni.ini');
    try
        ClientIni.WriteInteger('SOUND', 'BASEVOLUME', FVolume);
    finally
        ClientIni.Free;
    end;

end;

procedure TSoundManager.SetVolumeEffect(Value: integer);
var
    ClientIni: TIniFile;
begin
    FVolumeEffect := Value;
    ClientIni := TIniFile.Create('.\ClientIni.ini');
    try
        ClientIni.WriteInteger('SOUND', 'EFFECTVOLUME', FVolumeEffect);
    finally
        ClientIni.Free;
    end;

end;

procedure TSoundManager.activateapp(Value: boolean);
begin
    boACTIVATEAPP := Value;
    boACTIVATEAPP_State := true;
end;

procedure TSoundManager.PlayBaseAudioMp3(aFileName: string; aRoopCount: integer);
var
    curname: string;
begin
    sleep(100);
    if dsm = nil then exit;
    if not chat_yinyue then Volume := -9999;

    curname := format('.\wav\%s', [aFileName]);

    if FileExists(curname) = FALSE then exit;
    FRoopCount := aRoopCount;

    FWB1.FileName := '';

    FWB1.FileName := curname;

    fwb1.Play;

    fwb1.Volume := FVolume;
    fwb1.Loop := true;
end;

procedure TSoundManager.PlayBaseAudio(aFileName: string; aRoopCount: integer);
var
    curname: string;
    WaveFormat: TWaveFormatEx;
begin
    sleep(100);
    if DXSound = nil then exit;
    if DXSound.DSound = nil then exit;

    curname := format('.\wav\%s', [aFileName]);
    //   LogObj.WriteLog(3, 'PlayBaseAudio ' + curname);

    if (AudioBase <> nil) and (AudioBase.FileName = curname) then
    begin
        FRoopCount := aRoopCount;
        exit;
    end;
    if Audiobase <> nil then
    begin
        AudioBase.Stop;
        AudioBase.Free;
        Audiobase := nil;
    end;

    if FileExists(curname) = FALSE then exit;
    FRoopCount := aRoopCount;

    try
        AudioBase := TAudioFileStream.Create(DXSound.DSound);
    except
        raise exception.Create('Audio ERROR');
    end;
    AudioBase.FileName := curname;
    AudioBase.Looped := FALSE;
    AudioBase.Volume := FVolume;

    //  Setting of format of primary buffer.
    MakePCMWaveFormatEx(WaveFormat, 44100, AudioBase.Format.wBitsPerSample, 2);
    DXSound.Primary.SetFormat(WaveFormat);
    if FboPlay then
    begin
        AudioBase.Play;
        AudioBase.Volume := FVolume;
    end;

    //   LogObj.WriteLog(3, 'PlayBaseAudio Volume = ' + IntToStr(FVolume));
end;

function TSoundManager.GetDxWaveDataMin(): PTDxWaveData;
var
    i: integer;
    pdwd: PTDxWaveData;
begin
    pdwd := DataList[0];
    result := pdwd;
    for i := 0 to DataList.Count - 1 do
    begin
        pdwd := DataList[i];
        if pdwd^.UsedTick < Result^.UsedTick then
        begin
            result := pdwd;
        end;
    end;

end;

function TSoundManager.GetDxWaveData(aName: string): PTDxWaveData;
var
    i: integer;
begin
    Result := nil;
    for i := 0 to DataList.Count - 1 do
    begin
        if PTDxWaveData(DataList[i])^.WC.Name = aName then
        begin
            Result := DataList[i];
            exit;
        end;
    end;

end;

function TSoundManager.RangeCompute(X: Integer; TagetX: Word): Integer;
begin
    if TagetX < X then
    begin
        Result := -(ABS(TagetX - X) * 500);
    end else
    begin
        Result := (ABS(TagetX - X) * 500);
    end;
end;

function TSoundManager.RangeVolume(X, Y: Integer; TagetX, TagetY: word; volume: Integer): Integer;
begin
    Result := -((ABS(TagetX - X) * 400) + (ABS(TagetY - Y) * 400)) + volume;
end;

procedure TSoundManager.NewPlayEffect(aEffectName: string; apan: integer);
var
    i, mintick, minidx, pos: integer;
    pdwd: PTDxWaveData;
    Stream: TFileStream;
    pp: pTwavefileListdata;
    WC: TWaveCollectionItem;
begin

    //缓冲区找
  {  aEffectName := UpperCase(aEffectName);
    pdwd := GetDxWaveData(aEffectName);
    if pdwd <> nil then
    begin
        pdwd^.UsedTick := mmAnsTick;
        if not pdwd^.WC.Initialized then pdwd^.WC.Restore;
        pdwd^.WC.Pan := apan;
        pdwd^.WC.Volume := avolume;
        pdwd^.WC.Play(FALSE);
        exit;
    end;
    //查找最先使用的
    pdwd := GetDxWaveDataMin;
    if pdwd = nil then exit;
    pp := wavefileList.get(aEffectName);
    if pp <> nil then
    begin
        if pp.rname = aEffectName then
        begin
            Pos := pp.rpos;
            Stream := TFileStream.Create(FNewFileName, fmOpenRead);
            try

                try
                    Stream.Seek(pos, soFromBeginning);
                    pdwd^.WC.Name := aEffectName;
                    pdwd^.UsedTick := mmAnsTick;
                    pdwd^.WC.Stop;

                    pdwd^.WC.Wave.Clear;
                    pdwd^.WC.Wave.LoadFromstream(Stream);
                    if not pdwd^.WC.Initialized then pdwd^.WC.Restore;
                    pdwd^.WC.Pan := apan;
                    pdwd^.WC.Volume := avolume;
                    pdwd^.WC.Play(FALSE);
                    exit;
                except
                    pdwd^.WC.Name := '';
                    exit;
                end;
            finally
                Stream.Free;
            end;
        end;
    end;
    if FileExists('.\wav\' + aEffectName) then
    begin
        try
            pdwd^.WC.Name := aEffectName;
            pdwd^.UsedTick := mmAnsTick;
            pdwd^.WC.Stop;
            pdwd^.WC.Wave.Clear;
            pdwd^.WC.Wave.LoadFromFile('.\wav\' + aEffectName);
            if not pdwd^.WC.Initialized then pdwd^.WC.Restore;
            pdwd^.WC.Pan := apan;
            pdwd^.WC.Volume := avolume;
            pdwd^.WC.Play(FALSE);
        except
            pdwd^.WC.Name := '';
            exit;
        end;
    end;
    }
    aEffectName := UpperCase(aEffectName);
    for i := 0 to FDxWaveList.Items.Count - 1 do
    begin
        if FDxWaveList.Items[i].Name = aEffectName then
        begin
            WC := FDxWaveList.Items[i];
            WC.Name := aEffectName;
            if not WC.Initialized then WC.Restore;
            WC.Pan := apan;
            WC.Volume := FVolumeEffect;
            WC.Play(FALSE);
            exit;
        end;
    end;

    pp := wavefileList.get(aEffectName);
    if pp <> nil then
    begin
        if pp.rname = aEffectName then
        begin
            Pos := pp.rpos;
            Stream := TFileStream.Create(FNewFileName, fmOpenRead or fmShareDenyNone);
            try

                try
                    Stream.Seek(pos, soFromBeginning);
                    FDxWaveList.Items.Add;
                    WC := FDxWaveList.Items[FDxWaveList.Items.Count - 1];
                    WC.Name := aEffectName;
                    WC.Wave.LoadFromstream(Stream);
                    if not WC.Initialized then WC.Restore;
                    WC.Pan := apan;
                    WC.Volume := FVolumeEffect;
                    WC.Play(FALSE);
                    exit;
                except
                    pdwd^.WC.Name := '';
                    exit;
                end;
            finally
                Stream.Free;
            end;
        end;
    end;
    if FileExists('.\wav\' + aEffectName) then
    begin
        try
            if not chat_yinxiao then exit;
            FDxWaveList.Items.Add;
            WC := FDxWaveList.Items[FDxWaveList.Items.Count - 1];
            WC.Name := aEffectName;
            WC.Wave.LoadFromFile('.\wav\' + aEffectName);
            if not WC.Initialized then WC.Restore;
            WC.Pan := apan;
            WC.Volume := FVolumeEffect;
            WC.Play(FALSE);
        except

            exit;
        end;
    end;
    if FDxWaveList.Items.Count > 20 then FDxWaveList.Items.Delete(0);
end;

procedure TSoundManager.UpDate(CurTime: DWORD);
begin

    if FRoopCount >= 0 then
    begin
        if (AudioBase <> nil) and (AudioBase.Playing = FALSE) then
        begin
            dec(FRoopCount);
            AudioBase.Position := 0;
            AudioBase.Play;
        end;
    end;

    if (boACTIVATEAPP_State) and (ACTIVATEAPPTime + 200 < CurTime) then
    begin
        boACTIVATEAPP_State := false;
        ACTIVATEAPPTime := CurTime;

        if dsm = nil then exit;

        if boACTIVATEAPP then
        begin
            if fwb1.Status = sPaused then fwb1.Play;
        end
        else
            if fwb1.Status = sPlaying then fwb1.Pause;
    end;
end;

end.

