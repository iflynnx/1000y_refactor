unit fbl;
  //{$DEFINE  Free}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,IniFiles,   md5, IdAntiFreezeBase,
  IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, ComCtrls;

type
  Tfrmfbl = class(TForm)
    StatusBar1: TStatusBar;
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Button1: TButton;
    pass: TEdit;
    user: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    passnew1: TEdit;
    oldpass: TEdit;
    name: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    passnew2: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Button2: TButton;
    Button3: TButton;
    Label7: TLabel;
  //  A2Form: TA2Form;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmfbl: Tfrmfbl;
  head:string;
  verurl: string =      'http://www.bearqn.com/verify/getver.asp';
  checkurl: string =      'http://www.bearqn.com/verify/getdata.asp';
  userpassurl: string = 'http://www.bearqn.com/verify/userpass.asp';
  expireurl: string =   'http://www.bearqn.com/verify/expire.asp';
  
implementation
    uses SVMain,  IdHashMessageDigest, IdHashCRC;
{$R *.dfm}
  
  

function passwordchange(url: string): boolean;
var
  temhttp: TIdHTTP;
  aParams: string;

begin
  result := false;
  temhttp := TIdHTTP.Create(nil);
 { temhttp.onWorkBegin := ConfigServer.IdHTTP1WorkBegin;
  temhttp.onwork := ConfigServer.IdHTTP1work;   }
  // temhttp.onStatus := ConfigServer.IdHTTP1Status;
  try
    frmfbl.statusbar1.panels[0].text := '开始验证';
   { ConfigServer.progressbar1.Visible := true;
    ConfigServer.progressbar1.Left := ConfigServer.progressBarRect.Left;
    ConfigServer.progressbar1.top := ConfigServer.progressBarRect.top;
    ConfigServer.progressbar1.width := ConfigServer.progressBarRect.Right -
      ConfigServer.progressBarRect.Left;
    ConfigServer.progressbar1.height := ConfigServer.progressBarRect.Bottom -
      ConfigServer.progressBarRect.top;
    ConfigServer.progressbar1.Parent := ConfigServer.statusbar1;  }
    frmfbl.IdAntiFreeze1.OnlyWhenIdle := False; //设置使程序有反应.
    temhttp.Request.ContentType := 'application/x-www-form-urlencoded';
    aParams := temhttp.get(url + '?user='
      + frmfbl.name.text + '&pass=' +
      md5.md5print(md5.md5string(frmfbl.oldpass.text)) + '&newpass=' +
      md5.md5print(md5.md5string(frmfbl.passnew1.text)));
    showmessage(pchar(aparams));
    if (length(aparams) < 1) then
    begin
      frmfbl.statusbar1.panels[0].Text := '网络不通，验证失败';
      result := false
    end
    else
    begin
      frmfbl.statusbar1.panels[0].Text := aparams;
     // ConfigServer.Gauge.Visible := false;
      result := true;
    end;

  finally
    frmfbl.IdHTTP1.Free;
    temhttp.free;
  end;
end;
function getfilec:string;
var
  i:Integer;
  vv:ofstruct;

begin
  i:=openfile(pchar(ParamStr(0)),vv,0);
result:=IntToStr(GetFileSize(i,nil));
_lclose(i);

end;
function authen(url: string): boolean;
var
  temhttp: TIdHTTP;
  aParams: string;
  timeA, timeB: string;
begin
  timeA := datetimetostr(time());
  timeB := md5.md5print(md5.md5string(timeA));
  head := md5.md5print(md5.md5string(md5.md5print(md5.md5string(timeB))));
  result := false;
  temhttp := TIdHTTP.Create(nil);
  {temhttp.onWorkBegin := FrmMain.IdHTTP1WorkBegin;
  temhttp.onwork := FrmMain.IdHTTP1work;
  temhttp.onworkEnd:=FrmMain.IdHTTP1WorkEnd;  }
  // temhttp.onStatus := ConfigServer.IdHTTP1Status;
  try
    frmfbl.statusbar1.panels[0].text := '开始验证';
   { ConfigServer.progressbar1.Visible := true;
    ConfigServer.progressbar1.Left := ConfigServer.progressBarRect.Left;
    ConfigServer.progressbar1.top := ConfigServer.progressBarRect.top;
    ConfigServer.progressbar1.width := ConfigServer.progressBarRect.Right -
      ConfigServer.progressBarRect.Left;
    ConfigServer.progressbar1.height := ConfigServer.progressBarRect.Bottom -
      ConfigServer.progressBarRect.top;
    ConfigServer.progressbar1.Parent := ConfigServer.statusbar1;  }
    frmfbl.IdAntiFreeze1.OnlyWhenIdle := False; //设置使程序有反应.
    temhttp.Request.ContentType := 'application/x-www-form-urlencoded';
    aParams := temhttp.get(url + '?user='
      + frmfbl.user.text + '&pass=' +
      md5.md5print(md5.md5string(frmfbl.pass.text)) + '&str=' + timeB);
    if (length(aparams) < 30) then
    begin
      if length(aparams) > 10 then
        frmfbl.statusbar1.panels[0].text := aParams
      else
        if url = verurl then
          frmfbl.statusbar1.panels[0].text := '最后更新服务端日期:' +
            aParams
        else
          frmfbl.statusbar1.panels[0].text := '使用日期截止到:' + aParams;
      result := false
    end
    else
    begin
     // timea:=;
     // if Pos(head, aparams) = 0 then exit; //暗桩1
        if Pos(head, aparams) = 0 then
          exit
        else   Delete(aparams, 1, length(head)); //删除返回的头
        if length(aparams) = 0 then exit else
        if  md5.md5print(md5.md5string(Trim(getfilec))) = Trim(aParams)  then
        begin
       check1:=True;
     // SaveInfo(aparams);  //下载保存服务端，这里验证就不要了
       frmfbl.statusbar1.panels[0].Text := '验证完毕,请稍等';
    //  ConfigServer.progressbar1.Visible := false;

       result := true;
       end
       else
       begin
       frmfbl.statusbar1.panels[0].Text := '版本有升级，请联系官方';//ExitProcess(0);
       check1:=True;
       result := true;
       end;
    end;

  finally
    frmfbl.IdHTTP1.Free;
    temhttp.free;
  end;
end;
procedure Tfrmfbl.Button1Click(Sender: TObject);

begin
  {$IFDEF Free}
    if  not authen(checkurl) then Exit else check2:=True;
   {$ELSE}
    check1:=true;
    check2:=True;
 {$ENDIF}

   FBLXZ:=True;  //选择后结束循环
   frmfbl.Free;
end;


procedure Tfrmfbl.Button2Click(Sender: TObject);
begin
  if passnew1.text <> passnew2.text then
  begin
    frmfbl.statusbar1.panels[0].Text := '新密码输入不匹配';
    exit;
  end;

    try
    if not passwordchange(userpassurl) then exit;
  except
  end ;
end;
procedure Tfrmfbl.Button3Click(Sender: TObject);
begin
   try
    authen(expireurl);
  except
  end ;
end;

procedure Tfrmfbl.FormClose(Sender: TObject; var Action: TCloseAction);
begin
ExitProcess(0);
end;

end.
