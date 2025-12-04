unit uHardCode; //2015.11.16 在水一方

interface

uses windows, WinSock, SysUtils, Nb30, Classes, ActiveX, ComObj, Variants;

const
  IDENTIFY_BUFFER_SIZE = 512;

type
  TIDERegs = packed record
    bFeaturesReg: BYTE; //Used for specifying SMART "commands".
    bSectorCountReg: BYTE; //IDE sector count register
    bSectorNumberReg: BYTE; //IDE sector number register
    bCylLowReg: BYTE; //IDE low order cylinder value
    bCylHighReg: BYTE; //IDE high order cylinder value
    bDriveHeadReg: BYTE; //IDE drive/head register
    bCommandReg: BYTE; //Actual IDE command.
    bReserved: BYTE; //reserved for future use. Must be zero.
  end;
  TSendCmdInParams = packed record
      //Buffer size in bytes
    cBufferSize: DWORD;
      //Structure with drive register values.
    irDriveRegs: TIDERegs;
      //Physical drive number to send command to (0,1,2,3).
    bDriveNumber: BYTE;
    bReserved: array[0..2] of Byte;
    dwReserved: array[0..3] of DWORD;
    bBuffer: array[0..0] of Byte; //Input buffer.
  end;
  TIdSector = packed record
    wGenConfig: Word;
    wNumCyls: Word;
    wReserved: Word;
    wNumHeads: Word;
    wBytesPerTrack: Word;
    wBytesPerSector: Word;
    wSectorsPerTrack: Word;
    wVendorUnique: array[0..2] of Word;
    sSerialNumber: array[0..19] of CHAR;
    wBufferType: Word;
    wBufferSize: Word;
    wECCSize: Word;
    sFirmwareRev: array[0..7] of Char;
    sModelNumber: array[0..39] of Char;
    wMoreVendorUnique: Word;
    wDoubleWordIO: Word;
    wCapabilities: Word;
    wReserved1: Word;
    wPIOTiming: Word;
    wDMATiming: Word;
    wBS: Word;
    wNumCurrentCyls: Word;
    wNumCurrentHeads: Word;
    wNumCurrentSectorsPerTrack: Word;
    ulCurrentSectorCapacity: DWORD;
    wMultSectorStuff: Word;
    ulTotalAddressableSectors: DWORD;
    wSingleWordDMA: Word;
    wMultiWordDMA: Word;
    bReserved: array[0..127] of BYTE;
  end;
  PIdSector = ^TIdSector;
  TDriverStatus = packed record
      //驱动器返回的错误代码，无错则返回0
    bDriverError: Byte;
      //IDE出错寄存器的内容，只有当bDriverError 为 SMART_IDE_ERROR 时有效
    bIDEStatus: Byte;
    bReserved: array[0..1] of Byte;
    dwReserved: array[0..1] of DWORD;
  end;
  TSendCmdOutParams = packed record
      //bBuffer的大小
    cBufferSize: DWORD;
      //驱动器状态
    DriverStatus: TDriverStatus;
      //用于保存从驱动器读出的数据的缓冲区，实际长度由cBufferSize决定
    bBuffer: array[0..0] of BYTE;
  end;

  TScsiPassThrough = record
    Length: Word;
    ScsiStatus: Byte;
    PathId: Byte;
    TargetId: Byte;
    Lun: Byte;
    CdbLength: Byte;
    SenseInfoLength: Byte;
    DataIn: Byte;
    DataTransferLength: ULONG;
    TimeOutValue: ULONG;
    DataBufferOffset: DWORD;
    SenseInfoOffset: ULONG;
    Cdb: array[0..15] of Byte;
  end;

  TScsiPassThroughWithBuffers = record
    spt: TScsiPassThrough;
    bSenseBuf: array[0..31] of Byte;
    bDataBuf: array[0..191] of Byte;
  end;

type
  MD5Count = array[0..1] of DWORD;
  MD5State = array[0..3] of DWORD;
  MD5Block = array[0..15] of DWORD;
  MD5CBits = array[0..7] of Byte;
  MD5Digest = array[0..15] of Byte;
  MD5Buffer = array[0..63] of Byte;
  MD5Context = record
    State: MD5State;
    Count: MD5Count;
    Buffer: MD5Buffer;
  end;

var
  PADDING: MD5Buffer = (
    $80, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00
    );
    MyClientIP: string = 'localhost';
    function GetHardCode: string;
    function GetFileMD5(filename: string): string;
    function RivestStr(Str: string): string;       
    function GetWMIProperty(WMIType, WMIProperty: string): string;

implementation

function SendArp(ipaddr: ulong; temp: dword; ulmacaddr: pointer; ulmacaddrleng: pointer): dword;
  stdcall; external 'Iphlpapi.dll' Name 'SendARP';
 
//------------------------------------------------------------------------------
// ByteToHex Convert
//------------------------------------------------------------------------------

function ByteToHex(Src: Char): string;
begin
  SetLength(Result, 2);
  asm
    MOV         EDI, [Result]
    MOV         EDI, [EDI]
    MOV         AL, Src
    MOV         AH, AL          // Save to AH
    SHR         AL, 4           // Output High 4 Bits
    ADD         AL, '0'
    CMP         AL, '9'
    JBE         @@OutCharLo
    ADD         AL, 'A'-'9'-1
@@OutCharLo:
    AND         AH, $f
    ADD         AH, '0'
    CMP         AH, '9'
    JBE         @@OutChar
    ADD         AH, 'A'-'9'-1
@@OutChar:
    STOSW
  end;
end;

//------------------------------------------------------------------------------
// get host IP
//------------------------------------------------------------------------------

function HostToIP(Name: string; var Ip: string): Boolean;
var
  wsdata: TWSAData;
  hostName: array[0..255] of char;
  hostEnt: PHostEnt;
  addr: PChar;
begin
  WSAStartup($0101, wsdata);
  try
    gethostname(hostName, sizeof(hostName));
    StrPCopy(hostName, Name);
    hostEnt := gethostbyname(hostName);
    if Assigned(hostEnt) then
    begin
      if Assigned(hostEnt^.h_addr_list) then
      begin
        addr := hostEnt^.h_addr_list^;
        if Assigned(addr) then
        begin
          IP := Format('%d.%d.%d.%d', [byte(addr[0]),
            byte(addr[1]), byte(addr[2]), byte(addr[3])]);
          Result := True;
        end
        else
        begin
          Result := False;
        end;
      end
      else
      begin
        Result := False;
      end;
    end
    else
    begin
      Result := False;
    end;
  finally
    WSACleanup;
  end;
end;

//------------------------------------------------------------------------------
// 机器码生成 硬盘序列号
//------------------------------------------------------------------------------

function GetIdeHDSerialNo: string;
var
  hDevice: THandle;
  cbBytesReturned: DWORD;
  //ptr : PChar;
  SCIP: TSendCmdInParams;
  aIdOutCmd: array[0..(SizeOf(TSendCmdOutParams) + IDENTIFY_BUFFER_SIZE - 1) - 1] of Byte;
  IdOutCmd: TSendCmdOutParams absolute aIdOutCmd;

  procedure ChangeByteOrder(var Data; Size: Integer);
  var
    ptr: PChar;
    i: Integer;
    c: Char;
  begin
    ptr := @Data;
    for i := 0 to (Size shr 1) - 1 do
    begin
      c := ptr^;
      ptr^ := (ptr + 1)^;
      (ptr + 1)^ := c;
      Inc(ptr, 2);
    end;
  end;
begin
  Result := ''; //如果出错则返回空串
  if SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT then
  begin //Windows NT, Windows 2000
      //提示：改变名称可适用于其它驱动器，如第二个驱动器： '\\.\PhysicalDrive1\'
    hDevice := CreateFile('\\.\PhysicalDrive0', GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  end
  else //Version Windows 95 OSR2, Windows 98
    hDevice := CreateFile('\\.\SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0);
  if hDevice = INVALID_HANDLE_VALUE then
    Exit;
  try
    FillChar(SCIP, SizeOf(TSendCmdInParams) - 1, #0);
    FillChar(aIdOutCmd, SizeOf(aIdOutCmd), #0);
    cbBytesReturned := 0;
      //Set up data structures for IDENTIFY command.
    with SCIP do
    begin
      cBufferSize := IDENTIFY_BUFFER_SIZE;
        //bDriveNumber := 0;
      with irDriveRegs do
      begin
        bSectorCountReg := 1;
        bSectorNumberReg := 1;
          //if Win32Platform=VER_PLATFORM_WIN32_NT then bDriveHeadReg := $A0
          //else bDriveHeadReg := $A0 or ((bDriveNum and 1) shl 4);
        bDriveHeadReg := $A0;
        bCommandReg := $EC;
      end;
    end;
    if not DeviceIoControl(hDevice, $0007C088, @SCIP, SizeOf(TSendCmdInParams) - 1,
      @aIdOutCmd, SizeOf(aIdOutCmd), cbBytesReturned, nil) then
      Exit;
  finally
    CloseHandle(hDevice);
  end;
  with PIdSector(@IdOutCmd.bBuffer)^ do
  begin
    ChangeByteOrder(sSerialNumber, SizeOf(sSerialNumber));
    (PChar(@sSerialNumber) + SizeOf(sSerialNumber))^ := #0;
    Result := Trim(StrPas(@sSerialNumber));
  end;
end;

function GetScsiHDSerialNo: string;
var
  dwReturned: DWORD;
  len: DWORD;
  sDeviceName: string;
  hDevice: THandle;
  Buffer: array[0..SizeOf(TScsiPassThroughWithBuffers) + SizeOf(TScsiPassThrough) - 1] of Byte;
  sptwb: TScsiPassThroughWithBuffers absolute Buffer;
begin
  Result := '';
  sDeviceName := 'C:';
  hDevice := CreateFile(PChar('\\.\' + sDeviceName), GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  if hDevice = INVALID_HANDLE_VALUE then
    Exit;
  try
    FillChar(Buffer, SizeOf(Buffer), #0);
    with sptwb.spt do
    begin
      Length := SizeOf(TScsiPassThrough);
      CdbLength := 6; // CDB6GENERIC_LENGTH
      SenseInfoLength := 24;
      DataIn := 1; // SCSI_IOCTL_DATA_IN
      DataTransferLength := 192;
      TimeOutValue := 2;
      DataBufferOffset := PChar(@sptwb.bDataBuf) - PChar(@sptwb);
      SenseInfoOffset := PChar(@sptwb.bSenseBuf) - PChar(@sptwb);
      Cdb[0] := $12; // OperationCode := SCSIOP_INQUIRY;
      Cdb[1] := $01; // Flags := CDB_INQUIRY_EVPD; Vital product data
      Cdb[2] := $80; // PageCode            Unit serial number
      Cdb[4] := 192; // AllocationLength
    end;
    len := sptwb.spt.DataBufferOffset + sptwb.spt.DataTransferLength;
    if DeviceIoControl(hDevice, $0004D004, @sptwb, SizeOf(TScsiPassThrough),
      @sptwb, len, dwReturned, nil) and ((PChar(@sptwb.bDataBuf) + 1)^ = #$80) then
      SetString(Result, PChar(@sptwb.bDataBuf) + 4, Ord((PChar(@sptwb.bDataBuf) + 3)^));
    Result := Trim(Result);
  finally
    CloseHandle(hDevice);
  end;
end;

function GetHDSerialNo: string;
begin
  Result := GetIdeHDSerialNo;
  if Length(Result) = 0 then
    Result := GetScsiHDSerialNo;
end;

//------------------------------------------------------------------------------
// 机器码生成 CPU序列号
//------------------------------------------------------------------------------

function GetCpuInfo: longint;
var
  temp: longint;
begin
  asm
    push         ebx
    push         edi
    mov          edi, eax
    mov          eax, 1
    dw           $a20f
    mov          temp, edx
    pop          edi
    pop          ebx
  end;
  result := temp;
end;

//------------------------------------------------------------------------------
// 机器码生成 MAC 序列号
//------------------------------------------------------------------------------

function Getmac: string;
var
  NCB: TNCB;
  ADAPTER: TADAPTERSTATUS;
  LANAENUM: TLANAENUM;
  intIdx: Integer;
  re: Char;
  buf: string;
begin
  try
    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := Chr(NCBRESET);
    NCB.ncb_lana_num := LANAENUM.lana[0];
    re := NetBios(@NCB);
    if Ord(re) <> 0 then
    begin
      Result := '';
      exit;
    end;
    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := Chr(NCBASTAT);
    NCB.ncb_lana_num := LANAENUM.lana[0];
    StrPCopy(NCB.ncb_callname, '*');
    NCB.ncb_buffer := @ADAPTER.adapter_address[0];
    NCB.ncb_length := SizeOf(ADAPTER);
    re := NetBios(@NCB);
    if Ord(re) <> 0 then
    begin
      exit;
    end;
    buf := '';
    for intIdx := 0 to 5 do
    begin
      buf := buf + InttoHex(Integer(ADAPTER.adapter_address[intIdx]), 2) + '-';
    end;
    Result := copy(buf, 0, length(buf) - 1);
  finally
    //
  end;
end;

//------------------------------------------------------------------------------
// 机器码生成 MAC 序列号2
//------------------------------------------------------------------------------
function   Getmac2:string;
var
  myip: ulong;
  mymac: array[0..5] of Byte;
  mymaclength: ulong;
  r: Integer;
begin
  //myip := inet_addr(PChar('192.168.0.1'));
  myip := inet_addr(PChar(MyClientIP));
  mymaclength := Length(mymac);
  r := SendArp(myip, 0, @mymac, @mymaclength);
  Result := 'errorcode:' + IntToStr(r);
  Result := format('%2.2x-%2.2x-%2.2x-%2.2x-%2.2x-%2.2x', [mymac[0], mymac[1], mymac[2], mymac[3], mymac[4], mymac[5]]);
end;
 
//------------------------------------------------------------------------------
//  以下为加密算法
//------------------------------------------------------------------------------

function F(x, y, z: DWORD): DWORD;
begin
  Result := (x and y) or ((not x) and z);
end;

function G(x, y, z: DWORD): DWORD;
begin
  Result := (x and z) or (y and (not z));
end;

function H(x, y, z: DWORD): DWORD;
begin
  Result := x xor y xor z;
end;

function I(x, y, z: DWORD): DWORD;
begin
  Result := y xor (x or (not z));
end;

procedure rot(var x: DWORD; n: BYTE);
begin
  x := (x shl n) or (x shr (32 - n));
end;

procedure FF(var a: DWORD; b, c, d, x: DWORD; s: BYTE; ac: DWORD);
begin
  inc(a, F(b, c, d) + x + ac);
  rot(a, s);
  inc(a, b);
end;

procedure GG(var a: DWORD; b, c, d, x: DWORD; s: BYTE; ac: DWORD);
begin
  inc(a, G(b, c, d) + x + ac);
  rot(a, s);
  inc(a, b);
end;

procedure HH(var a: DWORD; b, c, d, x: DWORD; s: BYTE; ac: DWORD);
begin
  inc(a, H(b, c, d) + x + ac);
  rot(a, s);
  inc(a, b);
end;

procedure II(var a: DWORD; b, c, d, x: DWORD; s: BYTE; ac: DWORD);
begin
  inc(a, I(b, c, d) + x + ac);
  rot(a, s);
  inc(a, b);
end;

procedure Encode(Source, Target: pointer; Count: longword);
var
  S: PByte;
  T: PDWORD;
  I: longword;
begin
  S := Source;
  T := Target;
  for I := 1 to Count div 4 do begin
    T^ := S^;
    inc(S);
    T^ := T^ or (S^ shl 8);
    inc(S);
    T^ := T^ or (S^ shl 16);
    inc(S);
    T^ := T^ or (S^ shl 24);
    inc(S);
    inc(T);
  end;
end;

procedure Decode(Source, Target: pointer; Count: longword);
var
  S: PDWORD;
  T: PByte;
  I: longword;
begin
  S := Source;
  T := Target;
  for I := 1 to Count do begin
    T^ := S^ and $FF;
    inc(T);
    T^ := (S^ shr 8) and $FF;
    inc(T);
    T^ := (S^ shr 16) and $FF;
    inc(T);
    T^ := (S^ shr 24) and $FF;
    inc(T);
    inc(S);
  end;
end;

procedure Transform(Buffer: pointer; var State: MD5State);
var
  a, b, c, d: DWORD;
  Block: MD5Block;
begin
  Encode(Buffer, @Block, 64);
  a := State[0];
  b := State[1];
  c := State[2];
  d := State[3];
  FF(a, b, c, d, Block[0], 7, $D76AA478);
  FF(d, a, b, c, Block[1], 12, $E8C7B756);
  FF(c, d, a, b, Block[2], 17, $242070DB);
  FF(b, c, d, a, Block[3], 22, $C1BDCEEE);
  FF(a, b, c, d, Block[4], 7, $F57C0FAF);
  FF(d, a, b, c, Block[5], 12, $4787C62A);
  FF(c, d, a, b, Block[6], 17, $A8304613);
  FF(b, c, d, a, Block[7], 22, $FD469501);
  FF(a, b, c, d, Block[8], 7, $698098D8);
  FF(d, a, b, c, Block[9], 12, $8B44F7AF);
  FF(c, d, a, b, Block[10], 17, $FFFF5BB1);
  FF(b, c, d, a, Block[11], 22, $895CD7BE);
  FF(a, b, c, d, Block[12], 7, $6B901122);
  FF(d, a, b, c, Block[13], 12, $FD987193);
  FF(c, d, a, b, Block[14], 17, $A679438E);
  FF(b, c, d, a, Block[15], 22, $49B40821);
  GG(a, b, c, d, Block[1], 5, $F61E2562);
  GG(d, a, b, c, Block[6], 9, $C040B340);
  GG(c, d, a, b, Block[11], 14, $265E5A51);
  GG(b, c, d, a, Block[0], 20, $E9B6C7AA);
  GG(a, b, c, d, Block[5], 5, $D62F105D);
  GG(d, a, b, c, Block[10], 9, $2441453);
  GG(c, d, a, b, Block[15], 14, $D8A1E681);
  GG(b, c, d, a, Block[4], 20, $E7D3FBC8);
  GG(a, b, c, d, Block[9], 5, $21E1CDE6);
  GG(d, a, b, c, Block[14], 9, $C33707D6);
  GG(c, d, a, b, Block[3], 14, $F4D50D87);
  GG(b, c, d, a, Block[8], 20, $455A14ED);
  GG(a, b, c, d, Block[13], 5, $A9E3E905);
  GG(d, a, b, c, Block[2], 9, $FCEFA3F8);
  GG(c, d, a, b, Block[7], 14, $676F02D9);
  GG(b, c, d, a, Block[12], 20, $8D2A4C8A);
  HH(a, b, c, d, Block[5], 4, $FFFA3942);
  HH(d, a, b, c, Block[8], 11, $8771F681);
  HH(c, d, a, b, Block[11], 16, $6D9D6122);
  HH(b, c, d, a, Block[14], 23, $FDE5380C);
  HH(a, b, c, d, Block[1], 4, $A4BEEA44);
  HH(d, a, b, c, Block[4], 11, $4BDECFA9);
  HH(c, d, a, b, Block[7], 16, $F6BB4B60);
  HH(b, c, d, a, Block[10], 23, $BEBFBC70);
  HH(a, b, c, d, Block[13], 4, $289B7EC6);
  HH(d, a, b, c, Block[0], 11, $EAA127FA);
  HH(c, d, a, b, Block[3], 16, $D4EF3085);
  HH(b, c, d, a, Block[6], 23, $4881D05);
  HH(a, b, c, d, Block[9], 4, $D9D4D039);
  HH(d, a, b, c, Block[12], 11, $E6DB99E5);
  HH(c, d, a, b, Block[15], 16, $1FA27CF8);
  HH(b, c, d, a, Block[2], 23, $C4AC5665);
  II(a, b, c, d, Block[0], 6, $F4292244);
  II(d, a, b, c, Block[7], 10, $432AFF97);
  II(c, d, a, b, Block[14], 15, $AB9423A7);
  II(b, c, d, a, Block[5], 21, $FC93A039);
  II(a, b, c, d, Block[12], 6, $655B59C3);
  II(d, a, b, c, Block[3], 10, $8F0CCC92);
  II(c, d, a, b, Block[10], 15, $FFEFF47D);
  II(b, c, d, a, Block[1], 21, $85845DD1);
  II(a, b, c, d, Block[8], 6, $6FA87E4F);
  II(d, a, b, c, Block[15], 10, $FE2CE6E0);
  II(c, d, a, b, Block[6], 15, $A3014314);
  II(b, c, d, a, Block[13], 21, $4E0811A1);
  II(a, b, c, d, Block[4], 6, $F7537E82);
  II(d, a, b, c, Block[11], 10, $BD3AF235);
  II(c, d, a, b, Block[2], 15, $2AD7D2BB);
  II(b, c, d, a, Block[9], 21, $EB86D391);
  inc(State[0], a);
  inc(State[1], b);
  inc(State[2], c);
  inc(State[3], d);
end;

procedure MD5Init(var Context: MD5Context);
begin
  with Context do begin
    State[0] := $67452301;
    State[1] := $EFCDAB89;
    State[2] := $98BADCFE;
    State[3] := $10325476;
    Count[0] := 0;
    Count[1] := 0;
    ZeroMemory(@Buffer, SizeOf(MD5Buffer));
  end;
end;

procedure MD5Update(var Context: MD5Context; Input: pChar; Length: longword);
var
  Index: longword;
  PartLen: longword;
  I: longword;
begin
  with Context do begin
    Index := (Count[0] shr 3) and $3F;
    inc(Count[0], Length shl 3);
    if Count[0] < (Length shl 3) then inc(Count[1]);
    inc(Count[1], Length shr 29);
  end;
  PartLen := 64 - Index;
  if Length >= PartLen then begin
    CopyMemory(@Context.Buffer[Index], Input, PartLen);
    Transform(@Context.Buffer, Context.State);
    I := PartLen;
    while I + 63 < Length do begin
      Transform(@Input[I], Context.State);
      inc(I, 64);
    end;
    Index := 0;
  end else I := 0;
  CopyMemory(@Context.Buffer[Index], @Input[I], Length - I);
end;

procedure MD5Final(var Context: MD5Context; var Digest: MD5Digest);
var
  Bits: MD5CBits;
  Index: longword;
  PadLen: longword;
begin
  Decode(@Context.Count, @Bits, 2);
  Index := (Context.Count[0] shr 3) and $3F;
  if Index < 56 then PadLen := 56 - Index else PadLen := 120 - Index;
  MD5Update(Context, @PADDING, PadLen);
  MD5Update(Context, @Bits, 8);
  Decode(@Context.State, @Digest, 4);
  ZeroMemory(@Context, SizeOf(MD5Context));
end;

function MD5String(M: string): MD5Digest;
var
  Context: MD5Context;
begin
  MD5Init(Context);
  MD5Update(Context, pChar(M), length(M));
  MD5Final(Context, Result);
end;

function MD5File(N: string): MD5Digest;
var
  FileHandle: THandle;
  MapHandle: THandle;
  ViewPointer: pointer;
  Context: MD5Context;
begin
  MD5Init(Context);
  FileHandle := CreateFile(pChar(N), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then try
    MapHandle := CreateFileMapping(FileHandle, nil, PAGE_READONLY, 0, 0, nil);
    if MapHandle <> 0 then try
      ViewPointer := MapViewOfFile(MapHandle, FILE_MAP_READ, 0, 0, 0);
      if ViewPointer <> nil then try
        MD5Update(Context, ViewPointer, GetFileSize(FileHandle, nil));
      finally
        UnmapViewOfFile(ViewPointer);
      end;
    finally
      CloseHandle(MapHandle);
    end;
  finally
    CloseHandle(FileHandle);
  end;
  MD5Final(Context, Result);
end;

function MD5Print(D: MD5Digest): string;
var
  I: byte;
const
  Digits: array[0..15] of char =
  ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
begin
  Result := '';
  for I := 0 to 15 do Result := Result + Digits[(D[I] shr 4) and $0F] + Digits[D[I] and $0F];
end;

function MD5Match(D1, D2: MD5Digest): boolean;
var
  I: byte;
begin
  I := 0;
  Result := TRUE;
  while Result and (I < 16) do begin
    Result := D1[I] = D2[I];
    inc(I);
  end;
end;

function RivestStr(Str: string): string;
begin
  Result := MD5Print(MD5String(Str));
end;

function GetHardCode: string;
begin
  Result := RivestStr(Format('[%s][%d][%s]',[GetHDSerialNo,GetCpuInfo,Getmac2]));
end;

function GetFileMD5(filename: string): string;
var
  str: string;
  ms: TMemoryStream;
begin
  if FileExists(filename) then begin
    ms := TMemoryStream.Create;
    try
      try
        ms.LoadFromFile(filename);
        SetLength(str,ms.size);
        ms.Seek(0,0);
        ms.ReadBuffer(str[1],ms.Size);
      except
        Result := 'ReadError';
        Exit;
      end;
    finally
      ms.Free;
    end;   
  end;
  Result := RivestStr(str);
end;
//获取系统版本
function GetWMIProperty(WMIType, WMIProperty: string): string;
const
  WbemUser = '';
  WbemPassword = '';
  WbemComputer = 'localhost';
var
  FSWbemLocator, FWMIService, FWbemObjectSet, Obj: OleVariant;
  C: Cardinal;
  i, Len: integer;
  tempItem: IEnumVariant;
  count: integer;
  msg: string;
begin
  try
    result := '';
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer(WbemComputer, 'root/CIMV2', WbemUser, WbemPassword);
    FWbemObjectSet := FWMIService.ExecQuery('Select * from Win32_' + WMIType);
    tempItem := IEnumVariant(IUnknown(FWbemObjectSet._NewEnum));
    Result := '';
    count := 0;
    while (tempItem.Next(1, obj, c) = S_OK) do
    begin
      Obj := Obj.Properties_.Item(WMIProperty, 0).Value;
      if not VarIsNull(obj) then
      begin
        if (count > 0) then
          result := result + ',';
        Result := Result + trim(Obj);
        Inc(count);
      end;
    end;
  except
//    on E: Exception do
//    begin
//      msg := Format('GetWMIProperty Error,WMIType:%s, WMIProperty:%s, Msg:%s',
//        [WMIType, WMIProperty, E.Message]);
//      ShowMessage(msg);
//    end;
  end;
  if (lowercase(result) = 'none') then
    result := '';
end;
end.

