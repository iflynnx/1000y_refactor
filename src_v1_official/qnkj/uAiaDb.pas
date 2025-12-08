unit uAiaDb;

interface

uses SysUtils;

const
   // Server To Client Protocol
   ERR = 3000;
   RTT = 3001;
   RNE = 3002;
   RAK = 3003;

   RSF = 3011;
   RSS = 3012;
   RSO = 3013;

   RSC = 3031;

   // Client To Server Protocol
   TTL = 2001;
   NER = 2002;  //  원래는 NEW였으나 메모리할당 new함수와 충돌로 인해...

   SFI = 2011;
   SFA = 2012;
   SFB = 2013;
   SFC = 2014;

   SSI = 2021;
   SSA = 2022;
   SSB = 2023;
   SSC = 2024;

   SCI = 2031;
   SCA = 2032;
   SCB = 2033;
   SCC = 2034;

   USA = 2042;
   USB = 2043;
   USC = 2044;
   UGA = 2045;
   UGB = 2046;
   UGC = 2047;
   UGS = 2048;
   UGM = 2049;

   DEL = 2050;

   SOA = 2061;
   SOB = 2062;
   SOC = 2063;
   SNA = 2064;
   SNB = 2065;
   SNC = 2066;

   TCH = 2091;

type
   ActozString = string;
   ActozDateTime = string;

   TRSORecord = record
      rResponseCode : integer;
      rResult : integer;
      rPTNCode : integer;
      rData : ActozString;
      rErrorNo : integer;
      rErrorStr : string;
   end;

function GetResponseCode(aRsp : PChar): integer;
function ResponseToRSORecord(aRsp : PChar; var aRecord : TRSORecord): integer;
function StrToActozS(aSrc : string): ActozString;
function ActozSToStr(aSrc : ActozString): string;
function DateTimeToActozDT(aDateTime: TDateTime): ActozDateTime;
function ActozDTToDateTime(aAtzDt : ActozDateTime): TDateTime;

implementation

// BlockingSocket.dll로 얻어온 m/w의 응답 번호를 알아냄
function GetResponseCode(aRsp : PChar): integer;
var
   i, nRspCode, nDivPos : integer;
   arrRspCode : array [0..10] of char;
begin
   FillChar (arrRspCode, SizeOf(arrRspCode), #0);
   for i := 0 to StrLen(aRsp)-1 do if aRsp[i] = #32 then break;
   nDivPos := i;
//   nDivPos := StrPos(PChar(' '), aRsp);
   if (nDivPos <= 0) or (nDivPos > 10) then begin
      Result := 0; exit;
   end;

   StrMove(@arrRspCode, aRsp, nDivPos);
   arrRspCode[i+1] := #0;
   try
      nRspCode := StrToInt(StrPas(@arrRspCode));
   except
      nRspCode := 0;
   end;

   Result := nRspCode;
end;

function ResponseToRSORecord(aRsp : PChar; var aRecord : TRSORecord): integer;
   function GetValidActozS(aSrc , aDst : PChar; chDiv: Char): PChar;
   var
      nLength, i : integer;
   begin
      nLength := StrLen(aSrc);
      for i := 0 to nLength-1 do begin
         if (aSrc[i] = chDiv) or (aSrc[i] = #13) or (aSrc[i] = #10) then begin
            aDst[i] := #0;
            if i < (nLength -1) then Result := @aSrc[i+1]     ///이부분 좀 생각을 해봐야..
            else Result := aSrc;
            exit;
         end;
         aDst[i] := aSrc[i];
         aDst[i+1] := #0;
      end;
      Result := aSrc;
   end;
var
   nRspLen : integer;
   arrTemp : array [0..255] of char;
   pC : PChar;
begin
   Result := -1;
   nRspLen := StrLen(aRsp);
   if nRspLen <= 0 then exit;

   pC := aRsp;
   try
      pC := GetValidActozS(pC, @arrTemp, #32);
      aRecord.rResponseCode := StrToInt(StrPas(@arrTemp));

      pC := GetValidActozS(pC, @arrTemp, #32);
      aRecord.rResult := StrToInt(StrPas(@arrTemp));

      if aRecord.rResult = 1 then begin
         GetValidActozS(pC, @arrTemp, #32);
         aRecord.rData := StrPas(@arrTemp);
      end
      else begin
         pC := GetValidActozS(pC, @arrTemp, #32);
         aRecord.rErrorNo := StrToInt(StrPas(@arrTemp));

         GetValidActozS(pC, @arrTemp, #32);
         aRecord.rErrorStr := StrPas(@arrTemp);
      end;
   except
      exit;
   end;

   if aRecord.rResult = 1 then Result := 0
   else Result := aRecord.rErrorNo;
end;

function StrToActozS(aSrc : string): ActozString;
var
   arrActozS : array [0..2000-1] of char;
   i, j, nSrcLen : integer;
begin
   FillChar (arrActozS, SizeOf(arrActozS), #0);
   i := 1;   j := 0;
   try
      nSrcLen := Length(aSrc);
      while i <= nSrcLen do begin
         if aSrc[i] = #10 then begin          // #10(라인피드)->'\_2'
            arrActozS[j] := '\';
            arrActozS[j+1] := '_';
            arrActozS[j+2] := '2';
            inc(j, 3);
         end
         else if aSrc[i] = #13 then begin     // #13(캐리지리턴)->'\_1'
            arrActozS[j] := '\';
            arrActozS[j+1] := '_';
            arrActozS[j+2] := '1';
            inc(j, 3);
         end
         else if aSrc[i] = #32 then begin     // #32(공백)->'\_3'
            arrActozS[j] := '\';
            arrActozS[j+1] := '_';
            arrActozS[j+2] := '3';
            inc(j, 3);
         end
         else if aSrc[i] = #92 then begin     // #92('\'), '\_'->'\_0'
            if aSrc[i+1] = #95 then begin     // #95('_')
               arrActozS[j] := '\';
               arrActozS[j+1] := '_';
               arrActozS[j+2] := '0';
               inc(j, 3);   inc(i);
            end
            else begin
               arrActozS[j] := aSrc[i];
               inc(j);
            end;
         end
         else begin
            arrActozS[j] := aSrc[i];
            inc(j);
         end;
         inc(i);
      end;
   except
      Result := actozstring('');
      exit;
   end;
   arrActozS[j] := #0;

   Result := ActozString(StrPas(@arrActozS));
end;

function ActozSToStr(aSrc : ActozString): string;
var
   arrStrTemp : array[0..2000-1] of char;
   i, j, nSrcLen : integer;
begin
   FillChar(arrStrTemp, SizeOf(arrStrTemp), #0);
   i := 1;   j := 0;
   try
      nSrcLen := Length(aSrc);
      while i <= nSrcLen do begin
         if aSrc[i] = #92 then begin
            if aSrc[i+1] = #95 then begin
               if aSrc[i+2] = '0' then begin
                  arrStrTemp[j] := #92;
                  arrStrTemp[j+1] := #95;
                  inc(j, 2);   inc(i, 2);
               end
               else if aSrc[i+2] = '1' then begin
                  arrStrTemp[j] := #13;
                  inc(j);   inc(i, 2);
               end
               else if aSrc[i+2] = '2' then begin
                  arrStrTemp[j] := #10;
                  inc(j);   inc(i, 2);
               end
               else if aSrc[i+2] = '3' then begin
                  arrStrTemp[j] := #32;
                  inc(j);   inc(i, 2);
               end
               else begin
                  arrStrTemp[j] := aSrc[i];
                  inc(j);
               end;
            end
            else begin
               arrStrTemp[j] := aSrc[i];
               inc(j);
            end;
         end
         else begin
            arrStrTemp[j] := aSrc[i];
            inc(j);
         end;
         inc(i);
      end;
   except
      Result := '';
      exit;
   end;
   arrStrTemp[j] := #0;

   Result := StrPas(@arrStrTemp);
end;

function DateTimeToActozDT(aDateTime: TDateTime): ActozDateTime;
var
   wYear, wMonth, wDay : word;
   wHour, wMin, wSec, wMSec : word;
   lDate, lTime : longint;
begin
   DecodeDate(aDateTime, wYear, wMonth, wDay);
   DecodeTime(aDateTime, wHour, wMin, wSec, wMSec);

   lDate := wYear*10000  + wMonth*100 + wDay;
   lTime := wHour*100 + wMin;

   Result := ActozDateTime(IntToStr(lDate) +'.'+ IntToStr(lTime));
end;

function ActozDTToDateTime(aAtzDt : ActozDateTime): TDateTime;
var
   nDivPos : integer;
   strDate, strTime : string;
   lDate, lTime : longint;
   wYear, wMonth, wDay, wHour, wMin : word;
   dtDate, dtTime : TDateTime;
begin
   nDivPos := Pos('.', aAtzDt);
   if nDivPos > 0 then begin
      strDate := Copy(aAtzDt, 1, nDivPos-1);
      strTime := Copy(aAtzDt, nDivPos+1, Length(aAtzDt)-nDivPos);

      lDate := StrToInt(strDate);
      lTime := StrToInt(strTime);

      wYear := lDate div 10000;
      wMonth := (lDate - wYear*10000) div 100;
      wDay := lDate - wYear*10000 - wMonth*100;

      wHour := lTime div 100;
      wMin := lTime - wHour*100;

      dtDate := EncodeDate(wYear, wMonth, wDay);
      dtTime := EncodeTime(wHour, wMin, 0, 0);

      Result := dtDate + dtTime;
   end
   else
      Result := EncodeDate(1, 1, 1);
end;

end.
