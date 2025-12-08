unit Encrypt;

interface

uses
  Windows, SysUtils,classes;

const

  CipherKey = 'A';

  CipherKeyLen = Length(CipherKey);
function encode(const s:string; skey:string=CipherKey):string;
function decode(const s:string; skey:string=CipherKey):string;
procedure enxor(AA:tstream);
function xortext(text:string;KEY:string='A'):string;
implementation


function xortext(text:string;KEY:string='A'):string;
var
  i:Integer;
  longkey,toto:string;
begin
    for i := 0 to (length(text) div length(key)) do
      longkey := longkey + key;

  for i := 1 to length(text) do begin
      toto := chr((ord(text[i]) XOR ord(longkey[i]))); // XOR algorithm
      result := result + toto;
  end;
end;

procedure enxor(AA:tstream);
var
  text,result:string;
  TAA:TMemoryStream;
begin
  TAA:=TMemoryStream.Create;
  TAA.LoadFromStream(AA);
  SetLength(text,TAA.size);
  TAA.ReadBuffer(text[1],TAA.Size);
  result:=xortext(text);
  TAA.Clear;
  TAA.WriteBuffer(result[1],Length(result));
  TAA.Position:=0;
  AA.Size:=0;
  AA.CopyFrom(TAA,TAA.SIZE);
  TAA.Free;
end;





function sth(s: string): string;
var tmpstr:string;
    i:integer;
begin
    tmpstr := '';
    for i:=1 to length(s) do
    begin
        tmpstr := tmpstr + inttoHex(ord(s[i]),2);
    end;
    result := tmpstr;
end;

function hts(S: string): string;
var hexS,tmpstr:string;
    i:integer;
    a:byte;
begin
    hexS  :=s;//应该是该字符串
    if length(hexS) mod 2=1 then
    begin
        hexS:=hexS+'0';
    end;
    tmpstr:='';
    for i:=1 to (length(hexS) div 2) do
    begin
        a:=strtoint('$'+hexS[2*i-1]+hexS[2*i]);
        tmpstr := tmpstr+chr(a);
    end;
    result :=tmpstr;
end;

function encode(const s:string; skey:string=CipherKey):string;
var
    i,j: integer;
    hexS,hexskey,midS,tmpstr:string;
    a,b,c:byte;
begin
    hexS   :=sth(s);
    hexskey:=sth(skey);
    midS   :=hexS;
    for i:=1 to (length(hexskey) div 2)   do
    begin
        if i<>1 then midS:= tmpstr;
        tmpstr:='';
        for j:=1 to (length(midS) div 2) do
        begin
            a:=strtoint('$'+midS[2*j-1]+midS[2*j]);
            b:=strtoint('$'+hexskey[2*i-1]+hexskey[2*i]);
            c:=a xor b;
            tmpstr := tmpstr+sth(chr(c));
        end;
    end;
    result := tmpstr;
end;

function decode(const s:string; skey:string=CipherKey):string;
var
    i,j: integer;
    hexS,hexskey,midS,tmpstr:string;
    a,b,c:byte;
begin
    hexS  :=s;//应该是该字符串
    if length(hexS) mod 2=1 then
    begin
        exit;
    end;
    hexskey:=sth(skey);
    tmpstr :=hexS;
    midS   :=hexS;
    for i:=(length(hexskey) div 2) downto 1 do
    begin
        if i<>(length(hexskey) div 2) then midS:= tmpstr;
        tmpstr:='';
        for j:=1 to (length(midS) div 2) do
        begin
            a:=strtoint('$'+midS[2*j-1]+midS[2*j]);
            b:=strtoint('$'+hexskey[2*i-1]+hexskey[2*i]);
            c:=a xor b;
            tmpstr := tmpstr+sth(chr(c));
        end;
    end;
    result := hts(tmpstr);
end;
end.

