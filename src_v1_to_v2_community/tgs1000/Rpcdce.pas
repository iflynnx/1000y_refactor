

unit Rpcdce;

interface
uses
Windows,SysUtils;

type
TUUID=packed record
    Data1:ULONG;
    Data2:Word;
    Data3:Word;
    Data4:array [0..7] of Byte;//此数组的后6个元素就是网卡的物理地址信息
end;
TGUID=TUUID;
PUUID=^TUUID;

const
{以下为UuidCreateSequential函数的可能返回值}
RPC_S_UUID_LOCAL_ONLY:LongInt=1824; //函数生成的GUID只能保证在本计算机上是唯一的
RPC_S_UUID_NO_ADDRESS:LongInt=1739; //不能获取以太网或令牌环网网卡设备
RPC_S_OK:LongInt=0; //函数调用成功，生成的GUID中包含了网卡的物理地址信息

function UuidCreateSequential(var uuid:TUUID):Cardinal;stdcall; //此函数只使用于单网卡的机器
function GetMACAddress:string;

implementation

function UuidCreateSequential;external 'Rpcrt4.dll' name 'UuidCreateSequential';

//引用此单元后，只需要调用GetMACAddress函数即可获得网卡物理地址
function GetMACAddress:string;
var
uuid:TUUID;
I:Integer;
begin
Result:='';
if UuidCreateSequential(uuid)=RPC_S_OK then
for I:=2 to 7 do
begin
    if I>2 then Result:=Result+'-';
    Result:=Result+IntToHex(uuid.Data4[I],2);
end;
end;


end.
 
 
