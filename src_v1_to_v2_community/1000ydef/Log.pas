unit Log;

interface

uses
    Windows, SysUtils, Classes, Dialogs;

type

    // 게임 로그를 기록하기 위한 클래스
    TLog = class
    private
        AppName:string;            // Application 명
        FileName:string;           // 로그 파일명
        LogLevel:Integer;          // 로그레벨 0이면 기록하지 않음
        boFirst:Boolean;
    public
        constructor Create(aname, fname:string; level:Integer);
        destructor Destroy; override;

        procedure WriteLog(level:Integer; Str:string);

    end;

var
    LogObj          :TLog;

implementation

constructor TLog.Create(aname, fname:string; level:Integer);
{
var
   Stream : TFileStream;
   flag : Boolean;
}
begin
    if level > 0 then ShowMessage('log 기록중');
    AppName := aname;
    FileName := fname;
    LogLevel := level;
    boFirst := TRUE;
end;

destructor TLog.Destroy;
begin
    WriteLog(1, AppName + ' 로그 기록 종료');
    inherited Destroy;
end;

procedure TLog.WriteLog(level:Integer; Str:string);
var
    Stream          :TFileStream;
    WritedStr       :string;
    WritedArray     :array[0..256] of Char;
begin
    if (LogLevel = 0) or (LogLevel < level) then Exit;

    if boFirst = TRUE then
    begin
        WritedStr := Format('[%s] %s%s%s', [DateTimeToStr(Now), AppName + ' 로그 기록 시작', Char(10), Char(13)]);
        StrPCopy(WritedArray, WritedStr);

        try
            DeleteFile(FileName);

            Stream := TFileStream.Create(FileName, fmCreate);
            Stream.Seek(0, soFromEnd);
            Stream.WriteBuffer(WritedArray, StrLen(WritedArray));
            Stream.Free;
        except
            on EFOpenError do ;
            on EWriteError do ;
        end;
        boFirst := FALSE;
    end;

    WritedStr := Format('[%s] %s%s%s', [DateTimeToStr(Now), Str, Char(10), Char(13)]);
    StrPCopy(WritedArray, WritedStr);

    try
        Stream := TFileStream.Create(FileName, fmOpenReadWrite);
        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(WritedArray, StrLen(WritedArray));
        Stream.Free;
    except
        on EFOpenError do ;
        on EWriteError do ;
    end;
end;

initialization;
    begin
        LogObj := TLog.Create('천년 클라이언트', '1000Y.Log', 0);
    end;

finalization;
    begin
        if LogObj <> nil then LogObj.Free;
    end;

end.
