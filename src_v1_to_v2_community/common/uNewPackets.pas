unit uNewPackets;

interface

uses
    Windows, SysUtils, Classes, ScktComp, mmSystem, uBuffer, deftype;

const
    uPackets_MAX_PACKET_SIZE = deftype_MAX_PACK_SIZE;                           // * 2;
    PACKET_START = $FF11;
    PACKET_END = $11FF;

    psr_game = 50;                                                              //游戏包
    psr_PACKET_send = 51;                                                       //
    psr_PACKET_rece = 52;                                                       //

    PACKET_send_NewId = 100;                                                    //新包ID
    PACKET_send_id = 101;
    PACKET_send_NewIdOk = 103;

    PACKET_rece_id = 202;
    PACKET_rece_Errorid = 203;
    PACKET_rece_NewIdOk = 204;


    PACKET_0_none = 10;
    PACKET_1_sendError = 11;
    PACKET_2_RECEerror = 12;
    PACKET_3_receID = 13;
    PACKET_4_sendid = 14;
    PACKET_5_receok = 15;
    PACKET_6_sendok = 16;
type

    pT_tabel = ^T_tabel;
    T_tabel = record                                                            //密码本  100H
        buf: array[0..$100 - 1] of byte;                                        //实际   102 就结束
        a, b: integer;
    end;
    Tkey = record
        case integer of
            1: (data: array[0..3] of byte);
            2: (k: integer);
    end;



    //发送的数据 压入就已经解除密码
    TNewPacketSender = class
    private
        Name: string;
        Socket: TCustomWinSocket;

        SendBuffer: TBuffer;
        SendBuffertabel: T_tabel;

        boWriteAllow: Boolean;

        FWouldBlockCount: Integer;

        FSendTick: Integer;
        FSendBytes: Integer;
        FSendBytesPerSec: Integer;

        boBufferFullLog: Boolean;

        function isDataRemained: Boolean;
        procedure SetWriteAllow(boFlag: Boolean);
        function getBufferCount(): integer;

    public       
        function PutSendPacket(aData: PChar; aSize: Integer): Boolean;
        procedure setName(aname: string);
        constructor Create(aName: string; aSize: Integer; aSocket: TCustomWinSocket);
        destructor Destroy; override;

        procedure Clear;

        procedure Update(asize: integer = 65535);

        function View(aData: PChar; aSize: Integer): integer;
        function Flush(aSize: Integer): Boolean;

        function PutPacket(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer): Boolean;


        procedure WriteLog(aStr: string);

        property WriteAllow: Boolean read boWriteAllow write SetWriteAllow;
        property SendBytesPerSec: Integer read FSendBytesPerSec;
        property WouldBlockCount: Integer read FWouldBlockCount;
        property DataRemained: Boolean read isDataRemained;

        property BufferCount: Integer read getBufferCount;
    end;
    //接收到的数据 压入就已经解除密码
    TNewPacketReceiver = class
    private

        Name: string;
        FReceiveBytes: Integer;
        FReceiveBytesPerSec: Integer;
        FReceiveTick: Integer;

        ReceiveBuffer: TBuffer;                                                 //接收缓冲区  接收网络包后直接增加到缓冲区 未做任何处理
        ReceiveBuffertabel: T_tabel;
        PacketBuffer: TPacketBuffer;                                            //包缓冲区  完成分割、解密

        boBufferFullLog: Boolean;

        function GetCount: Integer;
    public

        procedure setName(aname: string);
        constructor Create(aName: string; aBufferSize: Integer);
        destructor Destroy; override;

        procedure Clear;

        procedure Update_bak;
        procedure Update;

        function PutData(aData: PChar; aSize: Integer): Boolean;                //压入
        function GetPacket(aPacket: PTPacketData): Boolean;                     //提出

        procedure WriteLog(aStr: string);

        property Count: Integer read GetCount;
        function getReceiveBufferCount(): integer;

        property ReceiveBufferCount: Integer read getReceiveBufferCount;
        property ReceiveBytesPerSec: Integer read FReceiveBytesPerSec;
    end;

  //支持重发包机制
  {
包格式：  $ff11,id,size,cmd,buf,$11ff
  }
    TRPacketdata = record
        rbegin: word;                                                           //2
        rid: integer;                                                           //6
        rsize: word;                                                            //8
        rcmd: byte;                                                             //9
        rbuf: TWordComData;
    end;
    pTRPacketdata = ^TRPacketdata;

    Tpcsdata = record
        rMSG: BYTE;
        rid: integer;
    end;
    pTpcsdata = ^Tpcsdata;

    TIDListdata = record
        rid: integer;
        rbegin: integer;
        rsize: integer;
    end;
    pTIDListdata = ^TIDListdata;

    TIDList = class
    private
        fname: string;
        flistArr: array[0..19] of TIDListdata;
        fcount: integer;
        fsize: integer;
        function sum_size: integer;
        procedure WriteLog(aStr: string);
    public

        constructor Create;
        destructor Destroy; override;

        procedure clear;
        function add(aid, abegin, asize: integer): boolean;
        procedure del(aid: integer);
        function get(aid: integer): pTIDListdata;
        function count: integer;
        function Maxcount: integer;

    end;
    //1，通知SEND错误发生，通知RECE错误发生，3，RECE发送ID号，4，SEND确认ID号，5，通知RECE恢复正常，6，通知SEND恢复正常。
    tpstype = (pt_0_none, pt_1_sendError, pt_2_RECEerror, pt_3_receID, pt_4_sendid, pt_5_receok, pt_6_sendok);
    TRPacketSender = class
    private
        fName: string;
        fid, fOKid: integer;
        cIDList: TIDList;
        fsendtcik: integer;
  ////////////////////////
  //       本类不创建
        FPacketSender: TNewPacketSender;
        fSocket: TCustomWinSocket;

        fDeleteState: boolean;
        FERROR: tpstype;
        function send(aid, amsg: integer; abuf: pointer; asize: integer): boolean;
        procedure send_Msg(amsg: integer);
        function MessageProcess(aComData: PTWordComData): Boolean;
        procedure WriteLog(aStr: string);
    public

        procedure setName(aname: string);
        constructor Create(aSocket: TCustomWinSocket; aPacketSender: TNewPacketSender);
        destructor Destroy; override;
        procedure Update(CurTick: integer);
    end;

    TRPacketReceiver = class
    private
        fName: string;
        fid: integer;
        FERROR: tpstype;
        cBuffer: TBuffer;
        fsendtcik: integer;

  ////////////////////////
  //       本类不创建
        FPacketReceiver: TNewPacketReceiver;
        fSocket: TCustomWinSocket;
        fRPacketSender: TRPacketSender;
        procedure send_msg(amsg: integer);
        procedure send_readId();
        function MessageProcess(aComData: PTWordComData): Boolean;
        procedure WriteLog(aStr: string);
    public

        procedure setName(aname: string);
        constructor Create(aSocket: TCustomWinSocket; aPacketReceiver: TNewPacketReceiver; afRPacketSender: TRPacketSender);
        destructor Destroy; override;
        procedure Update(CurTick: integer);
        function PutData(aData: PChar; aSize: Integer): Boolean;                //压入
    end;

implementation

// TPacketSender
uses Dialogs, Unit_console;

procedure rc4_setup(key: Tkey; p1: pT_tabel);                                   //初始化 密码本
var
    i, j, k, a: integer;
begin
    p1.a := 0;
    p1.b := 0;
    for i := 0 to 255 do p1.buf[i] := i;

    j := 0;
    k := 0;
    for i := 0 to 255 do
    begin
        a := p1.buf[i];
        j := byte(j + a + key.data[k]);
        p1.buf[i] := p1.buf[j];
        p1.buf[j] := a;
        inc(k);
        if k >= (high(key.data) + 1) then k := 0;
    end;

end;
{解密或者加密buf 缓冲区  len 长度 s密码本}

procedure rc4_crypt(buf: Pointer; len: dword; s: pT_tabel);
var
    i, x, y, a, b: integer;
    t: pbyte;
begin
    t := pbyte(buf);
    x := s.a;
    y := s.b;
    for i := 0 to len - 1 do
    begin
        x := byte(x + 1);
        a := s.buf[x];
        y := byte(y + a);
        s.buf[x] := s.buf[y];
        b := s.buf[y];
        s.buf[y] := a;
        t^ := t^ xor (s.buf[byte(a + b)]);
        inc(t);
    end;
    s.a := (x);
    s.b := (y);
end;

procedure EnCryption(buf: pointer; asize: integer; s: pT_tabel);
begin
    rc4_crypt(buf, asize, s);
end;

procedure DeCryption(buf: pointer; asize: integer; s: pT_tabel);
begin
    rc4_crypt(buf, asize, s);
end;

function TNewPacketSender.getBufferCount: integer;
begin
    Result := SendBuffer.Count;
end;

constructor TNewPacketSender.Create(aName: string; aSize: Integer; aSocket: TCustomWinSocket);
var
    Size: Integer;
    key: Tkey;
begin
    Name := aName;

    FSendBytes := 0;
    FSendBytesPerSec := 0;
    FSendTick := 0;

    FWouldBlockCount := 0;

    Socket := aSocket;

    boWriteAllow := false;

    Size := aSize;
    if Size <= 0 then Size := 65535;
    SendBuffer := TBuffer.Create(Size);

    boBufferFullLog := false;
    key.k := $20151112;        //2015.11.12 在水一方
    rc4_setup(key, @SendBuffertabel);
end;

destructor TNewPacketSender.Destroy;
begin
    SendBuffer.Free;
    inherited Destroy;
end;

procedure TNewPacketSender.Clear;
begin
    SendBuffer.Clear;
end;

function TNewPacketSender.isDataRemained: Boolean;
begin
    Result := false;
    if SendBuffer.Count > 0 then Result := true;
end;

procedure TNewPacketSender.SetWriteAllow(boFlag: Boolean);
begin
    boWriteAllow := boFlag;
end;

function TNewPacketSender.View(aData: PChar; aSize: Integer): integer;
var
    nSendSize: integer;
begin
    result := 0;
    if boWriteAllow = false then exit;
    if SendBuffer.Count <= 0 then exit;
    nSendSize := SendBuffer.Count;
    if nSendSize > aSize then nSendSize := aSize;
    if SendBuffer.View(aData, nSendSize) = false then exit;
    result := nSendSize;
end;

function TNewPacketSender.Flush(aSize: Integer): Boolean;
begin
    result := SendBuffer.Flush(aSize);
end;

procedure TNewPacketSender.Update(asize: integer = 65535);
var
    CurTick: Integer;
    nSendSize, nWrite: Integer;
    buffer: array[0..65535 - 1] of Byte;
begin
    CurTick := timeGetTime;

    if (boWriteAllow = true) and (SendBuffer.Count > 0) then
    begin
        //缓冲区  一共多少
        nSendSize := SendBuffer.Count;
        if asize > 65535 then asize := 65535;
        if nSendSize > asize then nSendSize := asize;
        //拷贝 一份出来
        if SendBuffer.View(@buffer, nSendSize) = false then exit;

        nWrite := Socket.SendBuf(buffer, nSendSize);                            //发送 一块数据
        if nWrite < 0 then nWrite := 0;

        if nWrite > 0 then SendBuffer.Flush(nWrite);                            //提取数据 确认

        //记录 ------------------------------------------------------------
        if nWrite > 0 then FSendBytes := FSendBytes + nWrite;                   //记录
        if nWrite < nSendSize then
        begin
            FWouldBlockCount := FWouldBlockCount + 1;                           //记录
            boWriteAllow := false;
        end;
        //----------------------------------------------------------------

    end;

    if CurTick >= FSendTick + 1000 then
    begin
        FSendBytesPerSec := FSendBytes div 1024;
        FSendBytes := 0;
        FSendTick := CurTick;
    end;
end;


//重新 打包 包头

function TNewPacketSender.PutPacket(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer): Boolean;
var
    Packet: TPacketData;
    nsize: integer;
begin
    Result := false;
    //重新 打包头

    if (aSize < 0) or (aSize > sizeof(Packet.Data)) then exit;
    nsize := SizeOf(Word) + SizeOf(Integer) + SizeOf(Byte) * 2 + aSize;         //全部 长度
    Packet.PacketSize := nsize;
    Packet.RequestID := aID;
    Packet.RequestMsg := aMsg;
    Packet.ResultCode := aRetCode;
    if aSize > 0 then Move(aData^, Packet.Data, aSize);

    EnCryption(@Packet, nsize, @SendBuffertabel);                               //加密
    //压入 发送缓冲区
    if SendBuffer.Put(@Packet, nsize) = true then
    begin
        Result := true;
        exit;
    end;
    WriteLog(format('%sSendBuffer.Put failed BufferSize=%d, InputSize=%d', [Name, SendBuffer.Count, Packet.PacketSize]));
    SendBuffer.Clear;

end;

function TNewPacketSender.PutSendPacket(aData: PChar; aSize: Integer): Boolean;
var
    temp: TWordComData;
    nSize: Word;
begin
    if aSize <= 0 then exit;
    //打发送包头
    temp.Size := aSize + 2;
    nSize := temp.Size;
    if aSize > 0 then Move(aData^, temp.Data, aSize);

    EnCryption(@temp, nSize, @SendBuffertabel);                                 //加密
    //压入 发送缓冲区
    if SendBuffer.Put(@temp, nSize) = true then
    begin
        Result := true;
        exit;
    end;
    WriteLog(format('%sSendBuffer.Put failed BufferSize=%d, InputSize=%d', [Name, SendBuffer.Count, nSize]));
    SendBuffer.Clear;
end;

procedure TNewPacketSender.WriteLog(aStr: string);
var
    Stream: TFileStream;
    FileName: string;
begin
    try
        if not DirectoryExists('.\Log\') then
        begin
            CreateDir('.\Log\');
        end;
        FileName := '.\Log\' + Name + 'TNewPacketSender.Log';
        if FileExists(FileName) then
        begin
            Stream := TFileStream.Create(FileName, fmOpenReadWrite);
        end else
        begin
            Stream := TFileStream.Create(FileName, fmCreate);
        end;
        aStr := '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + ']' + aStr + #13 + #10;
        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(aStr[1], length(aStr));
        Stream.Free;
    except
    end;
end;

// TPacketReceiver

constructor TNewPacketReceiver.Create(aName: string; aBufferSize: Integer);
var
    Size: Integer;
    KEY: TKEY;
begin
    Name := aName;

    FReceiveBytes := 0;
    FReceiveBytesPerSec := 0;
    FReceiveTick := 0;

    Size := aBufferSize;
    if Size <= 0 then Size := 16384;
    ReceiveBuffer := TBuffer.Create(Size);
    PacketBuffer := TPacketBuffer.Create(Size);

    boBufferFullLog := false;

    key.k := $20151112;        //2015.11.12 在水一方
    rc4_setup(key, @ReceiveBuffertabel);
end;

destructor TNewPacketReceiver.Destroy;
begin
    Clear;
    PacketBuffer.Free;
    ReceiveBuffer.Free;

    inherited Destroy;
end;

procedure TNewPacketReceiver.Clear;
begin
    PacketBuffer.Clear;
    ReceiveBuffer.Clear;
end;

function TNewPacketReceiver.GetCount: Integer;
begin
    Result := PacketBuffer.Count;
end;
//分包，解密

procedure TNewPacketReceiver.Update_bak;
{var
    i, iBase, iPos, iStartPos, iEndPos, nSize: Integer;
    CurTick: Integer;
    buffer: array[0..uPackets_MAX_PACKET_SIZE - 1] of Byte;
    Packet: TPacketData;}
begin
    {
        CurTick := timeGetTime;
        //缓冲区
        while ReceiveBuffer.Count > 0 do
        begin
            nSize := ReceiveBuffer.Count;
            if nSize > uPackets_MAX_PACKET_SIZE then nSize := uPackets_MAX_PACKET_SIZE;

            if ReceiveBuffer.View(@buffer, nSize) = true then
            begin
                iPos := 0;
                while iPos < nSize do
                    //while-------------------------------------------------------------------
                begin
                    iStartPos := -1;
                    iBase := iPos;
                    //找包开始符
                    for i := iBase to nSize - 1 do
                    begin
                        Inc(iPos);
                        if buffer[i] = PACKET_START then //包开始符 PACKET_START=28
                        begin
                            iStartPos := i + 1;
                            break;
                        end;
                    end;

                    if iStartPos = -1 then //
                    begin
                        // WriteLog ('Wrong Packet : StartCode not found');
                        ReceiveBuffer.Flush(iPos);
                        exit;
                    end;
                    //找 包结束符
                    iEndPos := -1;
                    iBase := iPos;
                    for i := iBase to nSize - 1 do
                    begin
                        Inc(iPos);
                        if buffer[i] = PACKET_START then
                        begin
                            // WriteLog ('Wrong Packet : PACKET_START Detected');
                            Dec(iPos);
                            ReceiveBuffer.Flush(iPos);
                            exit;
                        end else if buffer[i] = PACKET_END then
                        begin          //包结束符 PACKET_END=29
                            iEndPos := i - 1;
                            break;
                        end;
                    end;
                    if iEndPos = -1 then
                    begin
                        iPos := iBase - 1;
                        if iPos = 0 then exit;
                        break;
                    end;

                    if iEndPos - iStartPos + 1 > 0 then
                    begin
                        //数据解密
                        DeCryption(@buffer[iStartPos], @Packet, iEndPos - iStartPos + 1);
                        if (Packet.PacketSize > 0) and (Packet.PacketSize <= SizeOf(TPacketData)) then
                        begin
                            PacketBuffer.Put(@Packet, Packet.PacketSize);
                        end;
                    end;
                end;
                //while----------------------------------------------------------------------------
                ReceiveBuffer.Flush(iPos);
            end else
            begin
                break;
            end;
        end;

        if CurTick >= FReceiveTick + 1000 then
        begin
            FReceiveBytesPerSec := FReceiveBytes div 1024;
            FReceiveBytes := 0;
            FReceiveTick := CurTick;
        end;
        }
end;

procedure TNewPacketReceiver.Update;
var
    i, iPos, nSize: Integer;
    CurTick: Integer;
    Packet: TPacketData;
begin
    CurTick := timeGetTime;
    while ReceiveBuffer.Count > 0 do
    begin

        nSize := ReceiveBuffer.Count;
        if nSize <= 0 then Break;
        if nSize > sizeof(Packet) then nSize := sizeof(Packet);
        //从 缓冲区 拷贝 一份出来 分析

        if not ReceiveBuffer.View(@Packet, nSize) then Break;

        if (Packet.PacketSize <= 0) or (Packet.PacketSize > nSize) then Break;

        ReceiveBuffer.Flush(Packet.PacketSize);                                 //修改 当前指针 确认提出数据

        PacketBuffer.Put(@Packet, Packet.PacketSize);                           //压入 完整包管理
    end;

    if CurTick >= FReceiveTick + 1000 then
    begin
        FReceiveBytesPerSec := FReceiveBytes div 1024;
        FReceiveBytes := 0;
        FReceiveTick := CurTick;
    end;
end;
//接收到的数据 压入就已经解除密码

function TNewPacketReceiver.PutData(aData: PChar; aSize: Integer): Boolean;
begin
    Result := false;

    FReceiveBytes := FReceiveBytes + aSize;

    if aSize <= 0 then exit;
    DeCryption(aData, asize, @ReceiveBuffertabel);                              //解除密码
    //放入 缓冲区
    if ReceiveBuffer.Put(aData, aSize) = true then
    begin
        Result := true;
        exit;
    end;
    //输出 失败 LOG
    WriteLog(format('%sReceiveBuffer.Put failed BufferSize=%d, InputSize=%d', [Name, ReceiveBuffer.Count, aSize]));
    ReceiveBuffer.Clear;
end;
//取包

function TNewPacketReceiver.GetPacket(aPacket: PTPacketData): Boolean;
begin
    Result := PacketBuffer.Get(PChar(aPacket));
end;

function TNewPacketReceiver.getReceiveBufferCount(): integer;
begin
    Result := ReceiveBuffer.Count;
end;

procedure TNewPacketReceiver.WriteLog(aStr: string);
var
    Stream: TFileStream;
    FileName: string;
begin
    try
        if not DirectoryExists('.\Log\') then
        begin
            CreateDir('.\Log\');
        end;
        FileName := '.\Log\' + Name + 'TNewPacketReceiver.Log';
        if FileExists(FileName) then
        begin
            Stream := TFileStream.Create(FileName, fmOpenReadWrite);
        end else
        begin
            Stream := TFileStream.Create(FileName, fmCreate);
        end;
        aStr := '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + ']' + aStr + #13 + #10;
        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(aStr[1], length(aStr));
        Stream.Free;
    except
    end;
end;



{ TRPacketSender }

constructor TRPacketSender.Create(aSocket: TCustomWinSocket; aPacketSender: TNewPacketSender);
begin
    fDeleteState := false;
    fName := '';
    FERROR := pt_0_none;
    fid := 1001;
    fOKid := fid - 1;
    fSocket := aSocket;
    fPacketSender := aPacketSender;
    cIDList := TIDList.Create;
end;

destructor TRPacketSender.Destroy;
begin
    cIDList.Free;
    inherited;
end;



function TRPacketSender.send(aid: integer; amsg: integer; abuf: pointer; asize: integer): boolean;
var
    buf: TRPacketdata;
    pw: pword;
    nWrite, nSendSize: integer;
begin
    result := false;
    if (asize <= 0) or (asize > (sizeof(buf) - (11 + 2))) then
    begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender；send[包长度超出范围] 包ID%d,  包长度%d', [aid, asize])); {$ENDIF}

        exit;                                                                   //存储空间 范围
    end;

    //重新打包
    nSendSize := asize + 13;

    buf.rbegin := $FF11;

    buf.rid := aid;
    buf.rcmd := amsg;
    buf.rsize := nSendSize;

    buf.rbuf.Size := asize;
    move(abuf^, buf.rbuf.Data, asize);
    pw := @buf.rbuf.Data[asize];
    //if random(100) < 90 then
    pw^ := $11FF;

    nWrite := fSocket.SendBuf(buf, nSendSize);
    if nWrite <> nSendSize then
    begin
      //发送失败
      //  fPacketSender.WriteLog(format('TRPacketSender.send发送失败; ID:%d;nSendSize:%d;nWrite:%d;', [buf.rid, nSendSize, nWrite]));
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender.send发送失败; ID:%d;nSendSize:%d;nWrite:%d;', [buf.rid, nSendSize, nWrite])); {$ENDIF}
        exit;
    end;
{$IFDEF showlog}
    if FrmConsole.Visible then
        FrmConsole.cprint(lt_RPacket, format('TRPacketSender.send发送成功; 包ID:%d;包长度:%d;', [buf.rid, nSendSize]));
{$ENDIF}
    result := true;
end;


procedure TRPacketSender.send_Msg(amsg: integer);
var
    temp: Tpcsdata;
begin
    temp.rMSG := amsg;
    temp.rid := fid;
    send($FFFF, psr_PACKET_send, @temp, sizeof(temp));
end;

function TRPacketSender.MessageProcess(aComData: PTWordComData): Boolean;
var
    p: pTpcsdata;

    function qrenID(aid: integer): boolean;
    var
        i, j: integer;
        pid: pTIDListdata;
    begin
        result := false;
        for i := fOKid + 1 to aid do
        begin
            pid := cIDList.get(i);
            if pid = nil then
            begin
             //包ID 无效
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender；[确认ID无效]已确认到ID%d,需要确认到%d；使用到%d', [fOKid, aid, FID])); {$ENDIF}
                exit;
            end else
            begin
                FPacketSender.Flush(pid.rsize);
                cIDList.del(i);
                fOKid := i;
{$IFDEF showlog}
                if FrmConsole.Visible then
                    FrmConsole.cprint(lt_RPacket, format('TRPacketSender；[确认成功]已确认到ID%d,需要确认到%d；使用到%d', [fOKid, aid, FID]));
{$ENDIF}
            end;
        end;
        result := true;
    end;

begin
    p := @aComData.Data;
    case p.rMSG of
        PACKET_0_none: ;
        PACKET_1_sendError:
            begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender；PACKET_1_sendError', [])); {$ENDIF}
                if FERROR <> pt_0_none then exit;
                FERROR := pt_1_sendError;
                fsendtcik := 0;
            end;
        PACKET_2_RECEerror:
            begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender；PACKET_2_RECEerror', [])); {$ENDIF}
                if FERROR <> pt_1_sendError then exit;
                FERROR := pt_2_RECEerror;
                fsendtcik := 0;
            end;
        PACKET_3_receID:
            begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender；PACKET_3_receID', [])); {$ENDIF}
                if FERROR <> pt_2_RECEerror then exit;

                p.rid := p.rid - 1;
                if (p.rid >= fOKid) and (p.rid < FID) then
                begin
                    if qrenID(p.rid) = false then
                    begin
                      //重大错误  只能断开
                        fDeleteState := true;
                        WriteLog('掉包，重新协商终止，ID丢失，断开网络');
                        fSocket.Close;
                        exit;
                    end;
                end else
                begin
                      //ID不正常   //重大错误  只能断开
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender；[ID出范围]已确认到ID%d,需要确认到%d；使用到%d', [fOKid, p.rid, FID])); {$ENDIF}
                    fDeleteState := true;
                    WriteLog('掉包，重新协商终止，ID超范围，断开网络');

                    fSocket.Close;
                    exit;
                end;
                cIDList.clear;
                fid := fOKid + 1;
                FERROR := pt_3_receID;
                fsendtcik := 0;
            end;
        PACKET_4_sendid: ;
        PACKET_5_receok:
            begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender；PACKET_5_receok', [])); {$ENDIF}
                if FERROR <> pt_4_sendid then exit;
                FERROR := pt_5_receok;
                fsendtcik := 0;
            end;
        PACKET_6_sendok: ;
        PACKET_rece_id:
            begin
                p.rid := p.rid - 1;
                if (p.rid >= fOKid) and (p.rid < FID) then
                begin
                    if qrenID(p.rid) = false then
                    begin
                        FERROR := pt_1_sendError;
                    end;
                end else
                begin
                      //ID不正常
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender；PACKET_rece_id[ID出范围]已确认到ID%d,需要确认到%d；使用到%d', [fOKid, p.rid, FID])); {$ENDIF}
                    FERROR := pt_1_sendError;
                end;
            end;
{
        PACKET_rece_Errorid:
            begin
                FrmConsole.cprint(lt_RPacket, format('TRPacketSender；PACKET_rece_Errorid[主动要求新ID]已确认到ID%d,使用到%d', [fOKid, FID]));
                send_newId;
            end;
        PACKET_rece_NewIdOk:
            begin
                if p.rid = fid then
                begin
                    fNotstate := false;

                    send_newIdOk;
                    FrmConsole.cprint(lt_RPacket, format('TRPacketSender；PACKET_rece_NewIdOk[答复使用新ID]当前ID%d', [fid]));
                end else
                begin
         //新ID 过期
                    FrmConsole.cprint(lt_RPacket, format('TRPacketSender；PACKET_rece_NewIdOk[新ID过期]当前ID%d;收到ID%d', [fid, p.rid]));
                    send_newId;
                end;
            end;
            }
    end;

end;

procedure TRPacketSender.WriteLog(aStr: string);
var
    Stream: TFileStream;
    FileName: string;
begin
    try
        FileName := '.\Log\' + fName + 'TRPacketSender.Log';
        if FileExists(FileName) then
        begin
            Stream := TFileStream.Create(FileName, fmOpenReadWrite);
        end else
        begin
            Stream := TFileStream.Create(FileName, fmCreate);
        end;
        aStr := '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + ']' + aStr + #13 + #10;
        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(aStr[1], length(aStr));
        Stream.Free;
    except
    end;
end;

procedure TRPacketSender.Update(CurTick: integer);
var
    buf: array[0..65535] of byte;
    pw: pword;
    asize, i, nWrite, nSendSize: integer;
begin
    if fDeleteState then exit;

    case FERROR of
        pt_0_none:
            begin

            end;
        pt_1_sendError:
            begin
                //通知 接收端
                if fsendtcik + 100 < CurTick then
                begin
                    fsendtcik := CurTick;
                    send_Msg(PACKET_2_RECEerror);
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('=========TRPacketSender；pt_1_sendError', [])); {$ENDIF}
                    WriteLog('掉包，重新协商开始');
                end;
            end;
        pt_2_RECEerror:
            begin
                //要求接收端给出ID
                if fsendtcik + 100 < CurTick then
                begin
                    fsendtcik := CurTick;
                    send_Msg(PACKET_3_receID);
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('=========TRPacketSender；pt_2_RECEerror', [])); {$ENDIF}
                end;
            end;
        pt_3_receID:
            begin
                FERROR := pt_4_sendid;
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('=========TRPacketSender；pt_3_receID', [])); {$ENDIF}
            end;
        pt_4_sendid:
            begin
                 //通知接收端 恢复正常
                if fsendtcik + 100 < CurTick then
                begin
                    fsendtcik := CurTick;
                    send_Msg(PACKET_5_receok);
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('=========TRPacketSender；pt_4_sendid', [])); {$ENDIF}
                end;
            end;
        pt_5_receok:
            begin
                FERROR := pt_6_sendok;
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('=========TRPacketSender；pt_5_receok', [])); {$ENDIF}
            end;
        pt_6_sendok:
            begin
                FERROR := pt_0_none;
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('=========TRPacketSender；pt_6_sendok', [])); {$ENDIF}
                WriteLog('掉包，重新协商完成');
            end;
    end;

    if FERROR <> pt_0_none then exit;

    if cIDList.count >= cIDList.Maxcount then
    begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender；cIDList[包满] 当前数量%d，最大数量%d', [cIDList.count, cIDList.Maxcount])); {$ENDIF}
        exit;                                                                   //ID列表满
    end;

    asize := fPacketSender.View(@buf, 65535);
    if asize <= 0 then exit;                                                    //没提取出数据

    i := cIDList.sum_size;
    if i < 0 then exit;
    asize := asize - i;
    if asize <= 0 then exit;
   // if asize > 8192 then asize := 8192;
    if asize > 65535 then asize := 65535;

   //ID管理
    if cIDList.add(fid, 0, asize) = false then
    begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender.Update();cIDList.add失败 fid%d,  asize%d', [fid, asize])); {$ENDIF}
        exit;
    end;
    //发送
    if send(fid, psr_game, @buf[i], asize) = false then
    begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketSender；send失败 包ID%d,  包长度%d', [fid, asize])); {$ENDIF}
        cIDList.del(fid);
        exit;
    end;
    inc(fid);

end;

procedure TRPacketSender.setName(aname: string);
begin
    fName := aname;
    cIDList.fname := aname;
end;

{ TRPacketReceiver }



constructor TRPacketReceiver.Create(aSocket: TCustomWinSocket; aPacketReceiver: TNewPacketReceiver; afRPacketSender: TRPacketSender);
begin
    FERROR := pt_0_none;
    fsendtcik := 0;
    fName := '';
    fid := 1001;

    fSocket := aSocket;
    FPacketReceiver := aPacketReceiver;
    fRPacketSender := afRPacketSender;
    cBuffer := TBuffer.Create(65535);
end;

destructor TRPacketReceiver.Destroy;
begin
    cBuffer.Free;
    inherited;
end;

function TRPacketReceiver.MessageProcess(aComData: PTWordComData): Boolean;
var
    p: pTpcsdata;
begin
    p := @aComData.Data;
    case p.rMSG of
        PACKET_0_none: ;
        PACKET_1_sendError: ;
        PACKET_2_RECEerror:
            begin
                FERROR := pt_2_RECEerror;
                send_msg(PACKET_2_RECEerror);
            end;
        PACKET_3_receID:
            begin
                FERROR := pt_3_receID;
                send_msg(PACKET_3_receID);
            end;
        PACKET_4_sendid: ;
        PACKET_5_receok:
            begin
                FERROR := pt_5_receok;
                send_msg(PACKET_5_receok);
            end;
        PACKET_6_sendok: ;
{
        PACKET_send_id:
            begin
                if p.rid = fid then
                begin
            //正常
                    FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver；PACKET_send_id[正常];发送到%d,接收到%d', [p.rid, fid]));
                end else
                begin

                    send_errorId;
                    FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver；PACKET_send_id[错误];发送到%d,接收到%d', [p.rid, fid]));
                end;
            end;
        PACKET_send_NewId:
            begin
                fid := p.rid;
                send_NewIdOk;
                FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver；PACKET_send_NewId[接收到新ID](%d)', [fid]));
            end;
        PACKET_send_NewIdOk:
            begin
                fNotstate := false;
                FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver；PACKET_send_NewIdOk[接收到新IDOK](%d)', [fid]));
            end;
            }
    end;

end;

function TRPacketReceiver.PutData(aData: PChar; aSize: Integer): Boolean;
begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver[压入原始包]长度(%d)', [aSize])); {$ENDIF}
    result := cBuffer.Put(aData, aSize);
    if Result = false then cBuffer.Clear;
end;

procedure TRPacketReceiver.send_msg(amsg: integer);
var
    temp: Tpcsdata;
begin
    temp.rMSG := amsg;
    temp.rid := fid;
    fRPacketSender.send($FFFF, psr_PACKET_rece, @temp, sizeof(temp));
end;





procedure TRPacketReceiver.send_readId;
var
    temp: Tpcsdata;
begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver[告知][包接收到](%d)', [fid])); {$ENDIF}
    temp.rMSG := PACKET_rece_id;
    temp.rid := fid;
    fRPacketSender.send($FFFF, psr_PACKET_rece, @temp, sizeof(temp));
end;

procedure TRPacketReceiver.WriteLog(aStr: string);
var
    Stream: TFileStream;
    FileName: string;
begin
    try
        FileName := '.\Log\' + fName + 'TRPacketReceiver.Log';
        if FileExists(FileName) then
        begin
            Stream := TFileStream.Create(FileName, fmOpenReadWrite);
        end else
        begin
            Stream := TFileStream.Create(FileName, fmCreate);
        end;
        aStr := '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + ']' + aStr + #13 + #10;
        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(aStr[1], length(aStr));
        Stream.Free;
    except
    end;
end;

procedure TRPacketReceiver.Update(CurTick: integer);
var
    p: pTRPacketdata;
    buff: array[0..65535] of byte;
    nRead, i: integer;
    pw: pword;
    bostate: boolean;
begin


    case FERROR of
        pt_0_none:
            begin
                if fsendtcik + 100 < CurTick then
                begin
                    fsendtcik := CurTick;
                    send_readId;
                end;
            end;
        pt_1_sendError:
            begin
                //通知 接收端
                if fsendtcik + 100 < CurTick then
                begin
                    fsendtcik := CurTick;
                    send_Msg(PACKET_1_sendError);
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver；pt_1_sendError', [])); {$ENDIF}
                    WriteLog('掉包，重新协商开始');
                end;
            end;
        pt_2_RECEerror:
            begin

            end;
        pt_3_receID:
            begin

            end;
        pt_4_sendid:
            begin

            end;
        pt_5_receok:
            begin
                FERROR := pt_0_none;
                WriteLog('掉包，重新协商完成');
            end;
        pt_6_sendok:
            begin

            end;
    end;

    while true do
    begin
///////////////////////////////////
//            整理
        i := cBuffer.Count;
        if I <= 13 then EXIT;
        if i > 65535 then i := 65535;
        if cBuffer.View(@buff, I) = FALSE then EXIT;
        nRead := i;
        bostate := false;
        for i := 0 to nRead - 1 do
        begin
            if i = nRead then exit;
            pw := @buff[i];
            if pw^ = $FF11 then
            begin
    //放弃前面数据
                if i > 0 then
                begin
                    cBuffer.Flush(i);
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver[放弃原始包]长度(%d)', [i])); {$ENDIF}
                end;
                bostate := true;
                break;
            end;
        end;

        if bostate = false then
        begin
    //没找到包头标志   全部放弃
            nRead := nRead - 1;
            if nRead > 0 then
            begin
                cBuffer.Flush(nRead);
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver[放弃原始包]长度(%d)', [nRead])); {$ENDIF}
            end;
            exit;
        end;
///////////////////////////////////
//            提取
        i := cBuffer.Count;
        if I <= 13 then EXIT;
        if i > 65535 then i := 65535;
        if cBuffer.View(@buff, I) = FALSE then EXIT;
        p := @buff;
  //开始标志
        if p.rbegin <> $FF11 then exit;
        if i < p.rsize then
        begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver[等待后续包]当前长度(%d)', [I])); {$ENDIF}
            exit;                                                               //长度不够
        end;
  /////////////--------等待后续包-----------//////////////
  //长度验证
        nRead := (p.rbuf.Size + 13);
        if nRead <> (p.rsize) then
        begin
            cBuffer.Flush(2);
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver[长度验证失败]计算长度%d;包长度%d', [nRead, p.rsize])); {$ENDIF}
            exit;
        end;
  //结束标志
        pw := @p.rbuf.Data[p.rbuf.Size];
        if pw^ <> $11FF then
        begin
            cBuffer.Flush(2);
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver[结束标志]错误；计算长度%d;包长度%d', [nRead, p.rsize])); {$ENDIF}
            exit;
        end;

        cBuffer.Flush(nRead);                                                   //确认全部包
        case p.rcmd of
            psr_game:
                begin
                    if FERROR <> pt_0_none then exit;                           //暂停状态
     //ID验证
                    if p.rid <> fid then
                    begin
                    //接收端。。。唯一触发错误地方
                        FERROR := pt_1_sendError;
                        fsendtcik := 0;
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver[ID验证失败]接收ID%d;当前ID%d', [p.rid, fid])); {$ENDIF}
                        exit;
                    end;
{$IFDEF showlog}if FrmConsole.Visible then FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver[正确包]长度%d；ID%d', [p.rsize, p.rid])); {$ENDIF}
                    inc(fid);
                    FPacketReceiver.PutData(@p.rbuf.Data, p.rbuf.Size);
                    fsendtcik := 0;
                end;
            psr_PACKET_send:
                begin
                    if p.rid <> $FFFF then
                    begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver[psr_PACKET_send<>$ffff]接收ID%d', [p.rid])); {$ENDIF}
                        exit;
                    end;
                    MessageProcess(@p.rbuf);
                end;
            psr_PACKET_rece:
                begin
                    if p.rid <> $FFFF then
                    begin
{$IFDEF showlog}FrmConsole.cprint(lt_RPacket, format('TRPacketReceiver[psr_PACKET_rece<>$ffff]接收ID%d', [p.rid])); {$ENDIF}
                        exit;
                    end;
                    fRPacketSender.MessageProcess(@p.rbuf);
                end;
        end;
    end;
end;

procedure TRPacketReceiver.setName(aname: string);
begin
    fName := aname;
end;

{ TIDList }

function TIDList.add(aid, abegin, asize: integer): boolean;
var
    i: integer;
begin
    result := false;
    if get(aid) <> nil then exit;
    for i := 0 to High(flistArr) do
    begin
        if flistArr[i].rid = 0 then
        begin
            flistArr[i].rid := aid;
            flistArr[i].rbegin := abegin;
            flistArr[i].rsize := asize;

            fsize := fsize + flistArr[i].rsize;
            inc(fcount);
            result := true;
            exit;
        end;
    end;

end;

procedure TIDList.clear;
begin
    fillchar(flistArr, sizeof(flistArr), 0);
    fcount := 0;
end;

function TIDList.count: integer;
begin
    result := fcount;
end;

constructor TIDList.Create;
begin
    clear;
    fname := '';
end;

procedure TIDList.del(aid: integer);
var
    i: integer;
begin
    if aid <= 0 then exit;
    for i := 0 to High(flistArr) do
    begin
        if flistArr[i].rid = aid then
        begin
            flistArr[i].rid := 0;
            fsize := fsize - flistArr[i].rsize;
            if fsize < 0 then
            begin
                fsize := 0;
                WriteLog('错误fsize<0');
            end;
            dec(fcount);
            if fcount < 0 then
            begin
                WriteLog('错误fcount<0');
                fcount := 0;
            end;
            exit;
        end;
    end;

end;

destructor TIDList.Destroy;
begin
    inherited;
end;

function TIDList.get(aid: integer): pTIDListdata;
var
    i: integer;
begin
    result := nil;
    for i := 0 to High(flistArr) do
    begin
        if flistArr[i].rid = aid then
        begin
            result := @flistArr[i];
            exit;
        end;
    end;

end;

procedure TIDList.WriteLog(aStr: string);
var
    Stream: TFileStream;
    FileName: string;
begin
    try
        FileName := '.\Log\' + fName + 'TIDList.Log';
        if FileExists(FileName) then
        begin
            Stream := TFileStream.Create(FileName, fmOpenReadWrite);
        end else
        begin
            Stream := TFileStream.Create(FileName, fmCreate);
        end;
        aStr := '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + ']' + aStr + #13 + #10;
        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(aStr[1], length(aStr));
        Stream.Free;
    except
    end;
end;

function TIDList.Maxcount: integer;
begin
    result := High(flistArr) + 1;
end;

function TIDList.sum_size: integer;
begin
    result := fsize;
end;

procedure TNewPacketReceiver.setName(aname: string);
begin
    Name := aname;

end;

procedure TNewPacketSender.setName(aname: string);
begin
    Name := aname;
end;

end.

