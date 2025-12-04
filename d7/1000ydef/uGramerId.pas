unit uGramerId;

interface

uses
  Windows, SysUtils, Classes, deftype, mmsystem;

function isGrammarID(ID: string): Boolean;
function isEmailID(ID: string): Boolean;
function isFullHangul(str: string): Boolean;
function IsHZ(ch: WideString): boolean;

implementation

//var
  //  FontTblBuf      :array[0..65536] of byte;
//   FontStream      :TFileStream;

function IsHZ(ch: WideString): boolean;
var
  i, iNum: integer;
begin
  result := false;
  for I := 1 to Length(ch) do
  begin
    iNum := ord(Ch[I]);
    if (iNum < 19968) or (iNum > 40869) then
    begin
      case Ch[I] of
        '0'..'9', 'a'..'z', 'A'..'Z': ;
      else exit; //×Ö·û ·Ç·¨
      end;
//      if not (Ch[I] in ['a'..'z', 'A'..'Z']) then
//      begin
//        result := false;
//        Exit;
//      end;
    end;
  end;
  result := true;
end;

function isFullHangul(str: string): Boolean;
var
  I, j: Integer;
begin
  result := false;
  I := 1;
  j := Length(str);
  while I <= j do
  begin
    if Integer(str[I]) > $A0 then
    begin //ºº×Ö
      if i = j then exit; //°ë¸öºº×Ö£¬·Ç·¨
      case LoWord(str[i]) shl 8 + LoWord(str[i + 1]) of
        $B0A1..$B0C4, //:Result := 'A';
          $B0C5..$B2C0, //:Result := 'B';
          $B2C1..$B4ED, //:Result := 'C';
          $B4EE..$B6E9, //:Result := 'D';
          $B6EA..$B7A1, //:Result := 'E';
          $B7A2..$B8C0, //:Result := 'F';
          $B8C1..$B9FD, //:Result := 'G';
          $B9FE..$BBF6, //:Result := 'H';
          $BBF7..$BFA5, //:Result := 'J';
          $BFA6..$C0AB, //:Result := 'K';
          $C0AC..$C2E7, //:Result := 'L';
          $C2E8..$C4C2, //:Result := 'M';
          $C4C3..$C5B5, //:Result := 'N';
          $C5B6..$C5BD, //:Result := 'O';
          $C5BE..$C6D9, //:Result := 'P';
          $C6DA..$C8BA, //:Result := 'Q';
          $C8BB..$C8F5, //:Result := 'R';
          $C8F6..$CBF9, //:Result := 'S';
          $CBFA..$CDD9, //:Result := 'T';
          $CDDA..$CEF3, //:Result := 'W';
          $CEF4..$D1B8, //:Result := 'X';
          $D1B9..$D4D0, //:Result := 'Y';
          $D4D1..$D7F9: ; //:Result := 'Z';

      else exit;
      end;
      Inc(I);
    end
    else
    begin
      case str[I] of
        '0'..'9', 'a'..'z', 'A'..'Z': ;
      else exit; //×Ö·û ·Ç·¨
      end;
    end;
    Inc(I);
  end;
  result := true;
end;
{
function isFullHangul(str:string):Boolean;
var
    data1, data2    :byte;
    cho, jung       :byte;
    //   jong: byte;
    i, len          :integer;
    wd              :word;
    pb              :pbyte;
begin
     Result := TRUE;
     exit;
     data2 := 0;

     i := 1;
     len := Length(str);

     while TRUE do
     begin
         if i > len then break;
         pb := @FontTblBuf;
         data1 := byte(str[i]);
         if data1 > 127 then
         begin
             if i + 1 <= len then
             begin
                 data2 := byte(str[i + 1]);
             end else
             begin
                 data2 := 0;
             end;
             wd := makeword(data2, data1);
             wd := wd - $8100;
             inc(pb, wd * 2);
             data1 := pb^;
             inc(pb);
             data2 := pb^;
             cho := (data1 and 124) shr 2;
             jung := (data1 and 3) * 8 + (data2 shr 5);
             //         jong := (data2 and 31);
             if cho = 1 then Result := FALSE; // ÃÊ¼º¾øÀ½.
             if jung = 2 then Result := FALSE; // Áß¼º¾øÀ½
             //         if jong = 255 then Result := FALSE;
             if cho > 20 then Result := FALSE; // Æ¯¼ö¹®ÀÚ
             if jung > 29 then Result := FALSE; // Æ¯¼ö¹®ÀÚ

             Inc(i);
         end else
         begin
         end;
         Inc(i);
     end;

end;
  }

function isGrammarID(ID: string): Boolean;
var
  i: Integer;
begin
  Result := TRUE;
  for i := 1 to Length(Id) do
  begin
    if ((byte(Id[i]) >= byte('0')) and (byte(Id[i]) <= byte('9')))
      or ((byte(Id[i]) >= byte('a')) and (byte(Id[i]) <= byte('z')))
      or ((byte(Id[i]) >= byte('A')) and (byte(Id[i]) <= byte('Z'))) then
    begin
    end else
    begin
      Result := FALSE;
      exit;
    end;
  end;
end;

function isEmailID(ID: string): Boolean;
var
  i: Integer;
begin
  Result := TRUE;
  for i := 1 to Length(Id) do
  begin
    if ((byte(Id[i]) >= byte('0')) and (byte(Id[i]) <= byte('9')))
      or ((byte(Id[i]) >= byte('a')) and (byte(Id[i]) <= byte('z')))
      or ((byte(Id[i]) >= byte('A')) and (byte(Id[i]) <= byte('Z')))
      or (id[i] = '@')
      or (id[i] = '.')
      or (id[i] = '_') then
    begin
    end else
    begin
      Result := FALSE;
      exit;
    end;
  end;
end;
initialization
    {  begin
          FontStream := TFileStream.Create('wintosan.tbl', fmOpenRead);
          FontStream.ReadBuffer(FontTblBuf, 65536);
          FontStream.Free;
      end;
     }
finalization
    { begin

     end;
     }
end.

