unit dll_Sock;

interface

uses
   Windows, Graphics, ExtCtrls;

type
   TAnsSocketEvent = procedure (aeventstr: shortstring) of object;

function  AllocAnsSocket : LongInt;
procedure FreeAnsSocket (aHandle: LongInt);
function  GetAnsSocketAllowSend (aHandle: LongInt): Boolean;
function  AnsSocketRead (aHandle: LongInt; pb: pbyte; acnt: integer): integer;
function  AnsSocketSend  (aHandle: LongInt; pb: pbyte; acnt: integer): integer;
function  AnsSocketUpDate (aHandle: LongInt): Boolean;
function  SetAnsSocketPort (aHandle: LongInt; aPort: integer): Boolean;
function  SetAnsSocketOnEvent  (aHandle: LongInt; AnsSocketEvent: TAnsSocketEvent): Boolean;
function  SetAnsSocketAddress (aHandle: LongInt; addr: ShortString): Boolean;
function  SetAnsSocketActive (aHandle: LongInt; aActive: Boolean): Boolean;

function  GetPictureBitmap (ahandle: integer): TBitmap;
procedure FreePicture  (ahandle: integer);
function  AllocPicture  (apicname: shortstring): integer; 


implementation

function  AllocAnsSocket; external 'AnsCSock.dll' name 'AllocAnsSocket';
procedure FreeAnsSocket; external 'AnsCSock.dll' name 'FreeAnsSocket';
function  GetAnsSocketAllowSend; external 'AnsCSock.dll' name 'GetAnsSocketAllowSend';
function  AnsSocketRead; external 'AnsCSock.dll' name 'AnsSocketRead';
function  AnsSocketSend; external 'AnsCSock.dll' name 'AnsSocketSend';
function  AnsSocketUpDate; external 'AnsCSock.dll' name 'AnsSocketUpDate';
function  SetAnsSocketPort; external 'AnsCSock.dll' name 'SetAnsSocketPort';
function  SetAnsSocketOnEvent; external 'AnsCSock.dll' name 'SetAnsSocketOnEvent';
function  SetAnsSocketAddress; external 'AnsCSock.dll' name 'SetAnsSocketAddress';
function  SetAnsSocketActive; external 'AnsCSock.dll' name 'SetAnsSocketActive';

function  GetPictureBitmap; external 'AnsCSock.dll' name 'GetPictureBitmap';
procedure FreePicture; external 'AnsCSock.dll' name 'FreePicture';
function  AllocPicture; external 'AnsCSock.dll' name 'AllocPicture';

end.
