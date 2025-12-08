unit uAiaDbBlockSock;

interface

uses   Windows;

function CreateSocket(aIniPath: PChar): SHORT; stdcall;
function DeleteSocket(): SHORT; stdcall;
// 인자 nWaitTime은 초단위의 값임. 0보다 작은 값을 인자로 넘기면 BlockingSocket이 됨
function GetTotalRecords(aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function NewRecord(aId: PChar; aData: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;

function SelectFullRecordById(aId: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function SelectFullRecordBySheaderA(aSheadera: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function SelectFullRecordBySheaderB(aSheaderb: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function SelectFullRecordBySheaderC(aSheaderc: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;

function SelectSimpleRecordById(aId: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function SelectSimpleRecordBySheaderA(aSheadera: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function SelectSimpleRecordBySheaderB(aSheaderb: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function SelectSimpleRecordBySheaderC(aSheaderc: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;

function UpdateHeaderA(aId: PChar; aPassword: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;  // 패스워드 변경

function DeleteRecord(aId: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;

function SelectSHeaderAById(aId: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function SelectSHeaderBById(aId: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function SelectSHeaderCById(aId: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function SelectHeaderAById(aId: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function SelectHeaderBById(aId: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
function SelectHeaderCById(aId: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;

function TouchTheLastUpdateTime(aId: PChar; aBuffer: PChar; nWaitTime: SHORT): SHORT; stdcall;
//이 함수는 소켓으로 받은 값이 메시지 아이디의 응답 메시지 인지 확인하지 않음.
function SelectByMsgId(aMsgId: SHORT; aId: PChar; aBuffer: PChar; nWaitTime: SHORT):SHORT; stdcall;

implementation

function CreateSocket; external 'blockingSocket.dll' name 'CreateSocket';
function DeleteSocket; external 'blockingSocket.dll' name 'DeleteSocket';

function GetTotalRecords; external 'blockingSocket.dll' name 'GetTotalRecords';
function NewRecord; external 'blockingSocket.dll' name 'NewRecord';

function SelectFullRecordById; external 'blockingSocket.dll' name 'SelectFullRecordById';
function SelectFullRecordBySheaderA; external 'blockingSocket.dll' name 'SelectFullRecordBySheaderA';
function SelectFullRecordBySheaderB; external 'blockingSocket.dll' name 'SelectFullRecordBySheaderB';
function SelectFullRecordBySheaderC; external 'blockingSocket.dll' name 'SelectFullRecordBySheaderC';

function SelectSimpleRecordById; external 'blockingSocket.dll' name 'SelectSimpleRecordById';
function SelectSimpleRecordBySheaderA; external 'blockingSocket.dll' name 'SelectSimpleRecordBySheaderA';
function SelectSimpleRecordBySheaderB; external 'blockingSocket.dll' name 'SelectSimpleRecordBySheaderB';
function SelectSimpleRecordBySheaderC; external 'blockingSocket.dll' name 'SelectSimpleRecordBySheaderC';

function UpdateHeaderA; external 'blockingSocket.dll' name 'UpdateHeaderA';

function DeleteRecord; external 'blockingSocket.dll' name 'DeleteRecord';

function SelectSHeaderAById; external 'blockingSocket.dll' name 'SelectSHeaderAById';
function SelectSHeaderBById; external 'blockingSocket.dll' name 'SelectSHeaderBById';
function SelectSHeaderCById; external 'blockingSocket.dll' name 'SelectSHeaderCById';
function SelectHeaderAById; external 'blockingSocket.dll' name 'SelectHeaderAById';
function SelectHeaderBById; external 'blockingSocket.dll' name 'SelectHeaderBById';
function SelectHeaderCById; external 'blockingSocket.dll' name 'SelectHeaderCById';

function TouchTheLastUpdateTime; external 'blockingSocket.dll' name 'TouchTheLastUpdateTime';

function SelectByMsgId; external 'blockingSocket.dll' name 'SelectByMsgId';

end.
