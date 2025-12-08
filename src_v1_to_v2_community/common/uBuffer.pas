unit uBuffer;

interface

uses
    Classes, SysUtils, deftype;
const
   //MAX_HAVE_PACKET = 8192;
   MAX_HAVE_PACKET = 65535;
type
    TBuffer = class
    private
        FPutSize, FGetSize: Integer;

        FSize: Integer;
        FCount: Integer;

        ReadPos, WritePos: Integer;
        BufferPtr: PChar;

        procedure CalcCount;
    protected
    public
        constructor Create(aSize: Integer);
        destructor Destroy; override;

        procedure Clear;

        function View(aData: PChar; aSize: Integer): Boolean;
        function Get(aData: PChar; aSize: Integer): Boolean;
        function Put(aData: PChar; aSize: Integer): Boolean;
        function Flush(aSize: Integer): Boolean;

        property Count: Integer read FCount;

        property Size: Integer read FSize;
        property ReadAt: Integer read ReadPos;
        property WriteAt: Integer read WritePos;
        property PutSize: Integer read FPutSize;
        property GetSize: Integer read FGetSize;
    end;
    {
    类：TPacketBuffer
    方法：
      查看    function View(aData: PChar): Boolean;
      获取    function Get(aData: PChar): Boolean;
      存入    function Put(aData: PChar; aSize: Integer): Boolean;
      清洗(缓冲区)function Flush: Boolean;
    功能：TBuffer类的扩展，
          HavePacketSize    每块数据长度
          HavePacketBuffer  TBuffer; 连续存放数据，
          ReadPos           读取 指针
          WritePos          写入指针
    }
    TPacketBuffer = class
    private
        FCount: Integer;

        ReadPos, WritePos: Integer;
        HavePacketSize: array[0..MAX_HAVE_PACKET - 1] of Integer;
        HavePacketBuffer: TBuffer;
    public
        constructor Create(aSize: Integer);
        destructor Destroy; override;

        procedure Clear;

        function View(aData: PChar): Boolean;
        function Get(aData: PChar): Boolean;
        function Put(aData: PChar; aSize: Integer): Boolean;
        function Flush: Boolean;

        property Count: Integer read FCount;
    end;

implementation

constructor TBuffer.Create(aSize: Integer);
begin
    FGetSize := 0;
    FPutSize := 0;

    BufferPtr := nil;
    FSize := 0;
    FCount := 0;
    ReadPos := 0;
    WritePos := 0;

    if aSize <= 0 then exit;

    GetMem(BufferPtr, aSize);
    if BufferPtr = nil then exit;

    FSize := aSize;
end;

destructor TBuffer.Destroy;
begin
    if BufferPtr <> nil then
    begin
        FreeMem(BufferPtr, FSize);
    end;

    inherited Destroy;
end;

procedure TBuffer.CalcCount;
begin
    if ReadPos = WritePos then
    begin
        FCount := 0;
    end else if WritePos > ReadPos then
    begin
        FCount := WritePos - ReadPos;
    end else
    begin
        FCount := FSize - ReadPos + WritePos;
    end;
end;

procedure TBuffer.Clear;
begin
    FCount := 0;
    ReadPos := 0;
    WritePos := 0;
end;
//名字：View
//功能：查看数据
//说明： 提出数据，但不修改读指针ReadPos

function TBuffer.View(aData: PChar; aSize: Integer): Boolean;
var
    nSize, pSize: Integer;
begin
    Result := false;
    try

        if FCount < aSize then exit;
        //ReadPos  读取 指针   WritePos 写入指针
        if WritePos > ReadPos then                                              //判断 缓冲区 跨 尾 头
        begin
            Move((BufferPtr + ReadPos)^, aData^, aSize);
        end else
        begin
            if aSize <= FSize - ReadPos then
            begin
                Move((BufferPtr + ReadPos)^, aData^, aSize);
            end else
            begin
                nSize := FSize - ReadPos;
                pSize := aSize - nSize;
                Move((BufferPtr + ReadPos)^, aData^, nSize);
                Move(BufferPtr^, (aData + nSize)^, pSize);
            end;
        end;
        Result := true;
    except
        Result := false;
    end;

end;
//名字：GET
//功能：获取数据
//说明： 提出数据，修改读指针ReadPos

function TBuffer.Get(aData: PChar; aSize: Integer): Boolean;
var
    nSize, pSize: Integer;
begin
    Result := false;
    if aSize = 0 then exit;
    if FCount < aSize then exit;

    FGetSize := FGetSize + aSize;

    if aSize <= FSize - ReadPos then
    begin
        Move((BufferPtr + ReadPos)^, aData^, aSize);
        ReadPos := ReadPos + aSize;
    end else
    begin
        nSize := FSize - ReadPos;
        pSize := aSize - nSize;
        Move((BufferPtr + ReadPos)^, aData^, nSize);
        Move(BufferPtr^, (aData + nSize)^, pSize);
        ReadPos := pSize;
    end;

    if ReadPos = FSize then ReadPos := 0;

    CalcCount;

    Result := true;
end;
//名字：Flush
//功能：清洗(缓冲区)
//说明：缓冲区 读ReadPos指针 移动 aSize长度；

function TBuffer.Flush(aSize: Integer): Boolean;
var
    nSize, pSize: Integer;
begin
    Result := false;
    if aSize <= 0 then exit;
    if FCount < aSize then exit;

    FGetSize := FGetSize + aSize;

    if aSize <= FSize - ReadPos then
    begin
        ReadPos := ReadPos + aSize;
    end else
    begin
        nSize := FSize - ReadPos;
        pSize := aSize - nSize;
        ReadPos := pSize;
    end;

    if ReadPos = FSize then ReadPos := 0;

    CalcCount;

    Result := true;
end;
//名字：PUT
//功能：存放(记录)

function TBuffer.Put(aData: PChar; aSize: Integer): Boolean;
var
    nSize, pSize: Integer;
begin
    Result := false;
    if aSize = 0 then exit;
    if FSize - FCount < aSize then exit;                                        //空间 不够

    FPutSize := FPutSize + aSize;                                               //估计 增加后长度
    //头 尾 循环使用缓冲区
    if aSize <= FSize - WritePos then
    begin
        Move(aData^, (BufferPtr + WritePos)^, aSize);
        WritePos := WritePos + aSize;
    end else
    begin                                                                       //空间 到尾部   ； 1，存满  2，多于部分从首部开始存。
        nSize := FSize - WritePos;
        pSize := aSize - nSize;
        Move(aData^, (BufferPtr + WritePos)^, nSize);
        Move((aDAta + nSize)^, BufferPtr^, pSize);
        WritePos := pSize;
    end;

    if WritePos = FSize then WritePos := 0;

    CalcCount;

    Result := true;
end;

// TPacketBuffer

constructor TPacketBuffer.Create(aSize: Integer);
begin
    FCount := 0;

    ReadPos := 0;
    WritePos := 0;
    FillChar(HavePacketSize, SizeOf(HavePacketSize), 0);

    HavePacketBuffer := TBuffer.Create(aSize);
end;

destructor TPacketBuffer.Destroy;
begin
    HavePacketBuffer.Free;
    inherited Destroy;
end;

procedure TPacketBuffer.Clear;
begin
    FCount := 0;
    ReadPos := 0;
    WritePos := 0;

    FillChar(HavePacketSize, SizeOf(HavePacketSize), 0);

    HavePacketBuffer.Clear;
end;

function TPacketBuffer.View(aData: PChar): Boolean;
begin
    Result := false;

    if FCount <= 0 then exit;

    Result := HavePacketBuffer.View(aData, HavePacketSize[ReadPos]);
end;

function TPacketBuffer.Get(aData: PChar): Boolean;
begin
    Result := false;

    if FCount <= 0 then exit;

    if HavePacketBuffer.Get(aData, HavePacketSize[ReadPos]) = false then exit;
    HavePacketSize[ReadPos] := 0;
    Inc(ReadPos);
    Dec(FCount);
    if ReadPos >= high(HavePacketSize) then ReadPos := 0;

    Result := true;
end;

function TPacketBuffer.Put(aData: PChar; aSize: Integer): Boolean;
begin
    Result := false;

    if FCount >= high(HavePacketSize) then exit;

    if HavePacketBuffer.Put(aData, aSize) = false then exit;
    HavePacketSize[WritePos] := aSize;
    Inc(WritePos);
    Inc(FCount);
    if WritePos >= high(HavePacketSize) then WritePos := 0;

    Result := true;
end;

function TPacketBuffer.Flush: Boolean;
begin
    Result := false;
    if FCount <= 0 then exit;

    if HavePacketBuffer.Flush(HavePacketSize[ReadPos]) = false then exit;
    HavePacketSize[ReadPos] := 0;
    Inc(ReadPos);
    Dec(FCount);
    if ReadPos >= high(HavePacketSize) then ReadPos := 0;

    Result := true;
end;

end.

