unit uAnsTick;

interface

uses
    Windows, SysUtils, Classes, mmsystem;

function ProgramHour:integer;
function mmTickSetAddValue(avalue:integer):Boolean;
function GetItemLineTime(v:integer):INTEGER; //返回 分
function GetItemLineTimeSec(v:integer):INTEGER; //返回 秒

var
    mmAnsTick       :integer = 0;
    mmAnsTick0      :integer = 0;
implementation

var
    mytimerid       :integer;

    mmAnsTickAddValue:integer = 1;

function GetItemLineTime(v:integer):INTEGER; //返回 分
begin
    Result := v div mmAnsTickAddValue div 6000;
end;

function GetItemLineTimeSec(v:integer):INTEGER; //返回 秒
begin
    Result := round(v / mmAnsTickAddValue / 100);

end;

function ProgramHour:integer;
begin
    Result := mmAnsTick div mmAnsTickAddValue div 360000;
end;

procedure mmTickTimerProc(uTimerID, uMessage:UINT; dwUser, dw1, dw2:DWORD) stdcall;
begin
    mmAnsTick := (timeGetTime - mmAnsTick0) div 10;
    //    mmAnsTick := mmAnsTick + mmAnsTickAddValue;
        //100毫秒
end;

function mmTickSetAddValue(avalue:integer):Boolean;
begin
    Result := TRUE;
    if avalue < 1 then
    begin
        Result := FALSE;
        exit;
    end;
    if avalue > 100 then
    begin
        Result := FALSE;
        exit;
    end;
    mmAnsTickAddValue := avalue;
end;

initialization
    begin
        mmAnsTick0 := timeGetTime;
        mytimerid := timeSetEvent(10, 10, @mmTickTimerProc, 1000, TIME_PERIODIC);
    end;
    {MMRESULT timeSetEvent（ UINT uDelay,
                                     UINT uResolution,
                                     LPTIMECALLBACK lpTimeProc,
                                     WORD dwUser,
                                     UINT fuEvent ）

            uDelay：以毫秒指定事件的周期。
             Uresolution：以毫秒指定延时的精度，数值越小定时器事件分辨率越高。缺省值为1ms。
             LpTimeProc：指向一个回调函数。
             DwUser：存放用户提供的回调数据。
             FuEvent：指定定时器事件类型：
             TIME_ONESHOT：uDelay毫秒后只产生一次事件
             TIME_PERIODIC ：每隔uDelay毫秒周期性地产生事件。

    }
finalization
    begin
        timeKillEvent(mytimerid);
    end;

    {
    uses
     Windows, SysUtils, Classes, mmsystem;

       function ProgramHour: integer;
       function mmTickSetAddValue (avalue: integer): Boolean;
       function mmAnsTick: integer;

       procedure mmAnsTickMark;
       function  mmAnsTickisflowMark: Boolean;

    implementation

    var
       LastTick : DWORD = 0;
       CurMod : DWORD = 0;
       mmAnsTickAddValue : integer = 1;
       CurAnsTick : integer = 0;

       MarkTick : DWORD = 0;

    procedure mmAnsTickMark;
    begin
       MarkTick := TimeGetTime;
    end;

    function  mmAnsTickisflowMark: Boolean;
    begin
       if MarkTick <> TimeGetTime then Result := TRUE
       else Result := FALSE;
    end;

    function mmAnsTick: integer;
    var
       inctick : DWORD;
       CurTick : DWORD;
    begin
       CurTick := TimeGetTime;
       if CurTick >= LastTick then inctick := CurTick - LastTick
       else inctick := 0;
       LastTick := CurTick;

       inctick := inctick + CurMod;
       while TRUE do begin
          if inctick < 10 then break;
          CurAnsTick := CurAnsTick + mmAnsTickAddValue;
          inctick := incTick - 10;
       end;
       CurMod := inctick;

       Result := CurAnsTick;
    end;

    function ProgramHour: integer;
    begin
       Result := mmAnsTick div mmAnsTickAddValue div 360000;
    end;

    function  mmTickSetAddValue (avalue: integer): Boolean;
    begin
       Result := TRUE;
       if avalue < 1 then begin Result := FALSE; exit; end;
       if avalue > 100 then begin Result := FALSE; exit; end;
       mmAnsTickAddValue := avalue;
    end;

    Initialization
    begin
       LastTick := TimeGetTime;
    end;

    Finalization
    begin
    end;
    }

end.

