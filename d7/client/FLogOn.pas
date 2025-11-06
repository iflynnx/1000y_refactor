unit FLogOn;

interface

uses
  Windows, SysUtils, Classes, ExtCtrls, Controls, Graphics, Forms,
  Buttons, StdCtrls, adeftype, deftype, uBuffer,
  uAnsTick, aUtil32, Dll_Sock, inifiles, ScktComp, WinSock,
  Dialogs, Cltype, A2Form, Log, mmSystem, uPackets, Messages, ansunit,
  uProcessUnit, UrlMon, uHostAddr, A2Img;

const
   MAXSOCKETDATASIZE = 10000;
   MAXSOCKETSENDDATASIZE = 4096;

   PROCESSDATASIZE = 4096;

   PacketBufferSize = 8192;
   SocketBufferSize = 64192;

   // add by minds
   SendPacketCountMax = 10000;

   // Virtual Keyboard in China
   VirtKeyWidth = 340;
   VirtKeyHeight = 110;
   VirtKeyImage = 24;
   
type
  TConnectState = ( cs_none, cs_balance, cs_gate, cs_gameserver );

// Delete by minds 030104 uHostAddr unit栏肺 颗辫
{
  THostAddressClass = class
   private
     IpList: TStringList;
     PortList: TStringList;
     NameList: TStringList;
     function GetCount: integer;
   public
     constructor Create (aFileName: string);
     destructor Destroy; override;
     function FindIndexByName (aname: string): integer;
     function GetIps(aidx: integer; adefault: string) : string;
     function GetPorts(aidx: integer; adefault: string) : string;
     function GetNames(aidx: integer; adefault: string) : string;
     property Count: integer read GetCount;
  end;
}
  TFrmLogOn = class(TForm)

    TimerReConnect: TTimer;
    TimerNixConnectConfirmed: TTimer;
    A2Form: TA2Form;
    BtnLogin: TA2Button;
    BtnNewUser: TA2Button;
    BtnExit: TA2Button;
    EdID: TA2Edit;
    EdPass: TA2Edit;
    PnInfo: TA2Label;
    ComboBox: TA2ComboBox;
    TimerSpeedCheck: TTimer;
    sckConnect: TClientSocket;
    timerProcess: TTimer;
    TimerMacroCheck: TTimer;
    ComboBoxR: TA2ComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EdIdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdPassKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnExitClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure BtnLogInClick(Sender: TObject);
    procedure BtnNewUserClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure TimerReConnectTimer(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure TimerNixConnectConfirmedTimer(Sender: TObject);
    procedure TimerSpeedCheckTimer(Sender: TObject);
    procedure sckConnectConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckConnectDisconnect(Sender: TObject;Socket: TCustomWinSocket);
    procedure sckConnectError(Sender: TObject; Socket: TCustomWinSocket;ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure sckConnectRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckConnectWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure timerProcessTimer(Sender: TObject);
    procedure TimerMacroCheckTimer(Sender: TObject);
    procedure ComboBoxRChange(Sender: TObject);
    procedure EdPassEnter(Sender: TObject);
    procedure EdPassExit(Sender: TObject);
    procedure A2FormAdxPaint(aAnsImage: TA2Image);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    SendPacketCount : integer;
    SendMoveCount : integer;
    PacketSender : TPacketSender;
    PacketReceiver : TPacketReceiver;

    HostAddressClass : THostAddressClass;

    FStartTime : TDateTime;
    FCurTick, FOldTick : integer;

    procedure InitMainSocketAndBuffer;

  private
    // Virtual Keyboard in China
    bShowVirtualKey: Boolean;
    VirtKeyX: integer;
    VirtKeyY: integer;
    VirtKeyDown: string;
    procedure DrawKeyValue(A2Image: TA2Image; PushKey: string; Shift: Boolean);
    procedure DrawKey(A2Image: TA2Image; X, Y: integer; Shift: Boolean; PushKey, DrawKey: string);
  public
   function MessageProcess (var Code : TWordComData) : Boolean;
   procedure ClearEdit (abo:Boolean);
   function  SocketAddData(cnt: integer; pb: pbyte) :Boolean;
   function  SocketAddOneData(adata:byte) :Boolean;

   function  SocketDisConnect(ErrText, ErrCaption : string; aActive : Boolean): Boolean;
   procedure SetFormText;
  end;

function Conv (astr : string): string;

var
   FrmLogOn: TFrmLogOn;

   mainFont : string = 'Arial';
   CurServerName : string = '';
   MessageDelayTime : array [0..255] of integer;

   CaptionServerName : string = '';

   ReConnectId : string = '';
   ReConnectPass : string = '';
   ReConnectChar : string = '';
   ReConnectIpAddr : string = '';
   ReConnectPort : integer = 0;

   boTimePaid : Boolean = TRUE; // 牢器讥眉农侩
   ReConnetFlag : Boolean = TRUE;
   indexTick : integer;

   ConnectState : TConnectState;
   boDirectClose : Boolean = FALSE;

   PacketCount : integer = 0;
   PacketMaxCount : integer = 0;

implementation

uses
   FSelChar, FMain, FBottom, FAttrib, AtzCls, FHistory, uCookie;

{$R *.DFM}

///////////////////////////////
//         FrmLogin
///////////////////////////////
procedure TFrmLogOn.FormCreate(Sender: TObject);
var
   i, n : integer;
   cserver: string;
   str : string;
   TimepayType : TTimepayType;
begin
    if G_Default800 then
  begin
    ClientHeight := 600;
    ClientWidth := 800;
  end else
  begin
    ClientHeight := 768;
    ClientWidth := 1024;
  end;

   bShowVirtualKey := False;
   VirtKeyDown := '';
   
   ConnectState := cs_none;

   FStartTime := Time;
   FOldTick := mmAnsTick;
   indexTick := 0;
   FrmM.AddA2Form (Self, A2form);
   Left := 0; Top := 0;



   //PacketSender := TPacketSender.Create ('Sender', 65535);
   //PacketReceiver := TPacketReceiver.Create ('Receiver', 65535);
   PacketSender := TPacketSender.Create ('Sender', 65535, nil, TRUE, TRUE);
   PacketReceiver := TPacketReceiver.Create ('Receiver', 65535, TRUE);

{  // change by minds 020218
   PacketSender := nil;
   PacketReceiver := nil;
}
   InitMainSocketAndBuffer;

   timerProcess.Interval := 10;
   timerProcess.Enabled := true;

   SetFormText;

   cserver := ClientIni.ReadString ('CLIENT','NAMEOFLEND',Conv('创造'));
   HostAddressClass := THostAddressClass.Create ('addr.txt');

   // 瘤开 殿废
   for i := 0 to HostAddressClass.RegionList.Count-1 do begin
      ComboBoxR.Items.add(HostAddressClass.RegionList[i]);
   end;

   n := HostAddressClass.FindIndexByName (cserver);
   if n < 0 then n := 0;
   ComboBoxR.Text := HostAddressClass.GetRegions(n, '');
   ComboBox.Text := cserver;

   for i := 0 to HostAddressClass.Count-1 do begin
      if HostAddressClass.GetRegions(i, '') = ComboBoxR.Text then
         ComboBox.Items.add(HostAddressClass.GetNames(i, ''));
   end;

   FillChar (MessageDelayTime, sizeof(MessageDelayTime), 0);

   str := '';
   for i := 1 to ParamCount +2 do begin
      str := str + ParamStr(i) + ' ';
   end;

   case NATION_VERSION of
      NATION_KOREA: ;
      else exit;
   end;

   if Loadtimepay then begin
      TimepayType := CheckTimePayed(str);
      case TimepayType of
         Tpt_actoz :;
         Tpt_timepay :
            begin
               TimerNixConnectConfirmed.Enabled := TRUE; // 牢器讥 眉农鸥烙赣 累悼 DLL俊辑 家南楷搬捞 谗辨矫 眉农窃
               boTimePaid := FALSE; // FALSE老版快 牢器讥烙
            end;
         Tpt_Close :
            begin
               SocketDisConnect(Conv('与服务器连接中断'),Conv('用户认证'),TRUE);
            end;
      end;
   end;
end;

procedure TFrmLogOn.FormDestroy(Sender: TObject);
begin
   if PacketSender <> nil then begin
      PacketSender.Free;
      PacketSender := nil;
   end;
   if PacketReceiver <> nil then begin
      PacketReceiver.Free;
      PacketReceiver := nil;
   end;
end;
procedure TFrmLogOn.BtnLogInClick(Sender: TObject);
var
   cIdPass : TCIdPass;
   cIdPassAzaCom : TCIdPassAzaCom;
   str : string;
begin
   ATWaveLib.play('click.wav', 0, EffectVolume);

   if boTimePaid then begin // boTimePaid FALSE : 牢器讥
      Fillchar (cIdPass, sizeof(cIdPass), 0);
      cIdPass.rmsg := CM_IDPASS;
      StrPCopy ( @cIdPass.rId, EdId.Text);
      StrPCopy ( @cIdPass.rPass, EdPass.Text);
      SocketAddData (sizeof(cIdPass), @cIdPass);
   end else begin
      cIdPassAzaCom.rmsg := CM_IDPASSAZACOM;
      StrPCopy ( @cIdPassAzaCom.rId, EdId.Text);
      StrPCopy ( @cIdPassAzaCom.rPass, EdPass.Text);
      str := 'None';
      if not boTimePaid then str := StrPas (GetCompanyName);
      StrPCopy ( @cIdPassAzaCom.rAzaComId, str);
      SocketAddData (sizeof(cIdPassAzaCom), @cIdPassAzaCom);
   end;

   ClearEdit(FALSE);
   PnInfo.Caption := Conv('请稍后…');
end;

procedure TFrmLogOn.BtnNewUserClick(Sender: TObject);
var
   PageIni: TIniFile;
   tmpStr: string;
   Url: WideString;
begin
   ATWaveLib.play('click.wav', 0, EffectVolume);

   PageIni := TIniFile.Create('.\PAGE.INI');
   tmpStr := PageIni.ReadString('HOMEPAGE', 'REGIST', 'http://www.1000y.com/ID/default.asp');
   Url := tmpStr;
   HlinkNavigateString(nil, PWideChar(Url));
   PageIni.Free;
end;
{
procedure TFrmLogOn.BtnNewUserClick(Sender: TObject);
begin
   ATWaveLib.play('click.wav', 0, EffectVolume);
   Visible := FALSE;
   FrmStipulation.Visible := TRUE;
end;
}

procedure TFrmLogOn.BtnExitClick(Sender: TObject);
begin
//   FrmM.SoundManager.NewPlayEffect ('click.wav',0,0);
   ATWaveLib.play('click.wav', 0, EffectVolume);
   SocketAddOneData (CM_CLOSE);
   bodirectclose := TRUE;
end;

procedure TFrmLogOn.InitMainSocketAndBuffer;
begin
   if PacketSender <> nil then begin
      PacketSender.Clear;
   end;
   if PacketReceiver <> nil then begin
      PacketReceiver.Clear;
   end;
end;

procedure TFrmLogOn.ClearEdit (abo:Boolean);
begin
   if abo then begin
//      EdId.Enabled := abo;
//      EdPass.Enabled := abo;
      if Visible then EdId.SetFocus;
      EdId.Text := '';
      EdPass.Text := '';
   end else begin
      EdId.SetFocus;
//      EdId.Enabled := abo;
//      EdPass.Enabled := abo;
   end;
end;

procedure TFrmLogOn.EditKeyPress(Sender: TObject; var Key: Char);
begin
   if (key = char (VK_ESCAPE)) or (key = char(VK_RETURN)) then key := char(0);
end;

procedure TFrmLogOn.EdIdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case key of
      VK_RETURN : EdPass.SetFocus;
      VK_ESCAPE : ClearEdit(TRUE);
   end;
end;

procedure TFrmLogOn.EdPassKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if key = VK_ESCAPE then ClearEdit(TRUE);
   if key <> VK_RETURN then exit;

   if Length (Edid.Text) < 2 then begin Edid.SetFocus; exit; end;
   if Length (EdPass.Text) < 4 then begin EdPass.SetFocus; exit; end;

   if Pos (',', EdID.Text) > 0 then begin Edid.SetFocus; exit; end;
   if Pos (',', EdPass.Text) > 0 then begin EdPass.SetFocus; exit; end;

   BtnLogInClick (Self);
end;

function TFrmLogOn.MessageProcess (var Code : TWordComData) : Boolean;
var
   i : integer;
   str, rdstr : string;
   pckey : PTCKey;
   psWs : PTWordInfoString;
   psMessage : PTSMessage;
   psWindow : PTSWindow;

   psReConnect: PTSReConnect;
   psSConnectThru : PTSConnectThru;
begin
   Result := true;

   pckey := @Code.data;
   case pckey^.rmsg of
      SM_CONNECTTHRU :         //253
         begin
            TimerReConnect.Enabled := FALSE;
            psSConnectThru := @Code.Data;
            ReConnectIpAddr := StrPas(@psSConnectThru.rIpAddr);
            ReConnectPort := psSConnectThru.rPort;
            sckConnect.Active := false;

            TimerReConnect.Enabled := TRUE;

            Result := false;
         end;
      SM_RECONNECT:
         begin
            psReConnect := @Code.Data;
            ReConnectId := StrPas (@psReConnect^.rid);
            ReConnectPass := StrPas (@psReConnect^.rPass);
            ReConnectIpAddr := StrPas (@psReConnect^.ripAddr);
            ReConnectChar := StrPas (@psReConnect^.rCharName);
            ReConnectPort := psReConnect^.rPort;
            sckConnect.Active := false;

            TimerReConnect.Enabled := TRUE;
         end;
      SM_CLOSE :
         begin
            if pckey^.rkey = 1 then begin
               SocketDisConnect('请访问: http://www.1000y.com.cn 更新版本', Conv('版本错误'), TRUE);
               sleep (100);
               FrmM.close;
            end;
         end;
      SM_MSGANDCLOSE :
         begin
            psMessage := @Code.Data;
            SocketDisConnect(GetWordString(psMessage^.rWordString), Conv('千年'), TRUE);
            Sleep (100);
            FrmM.close;
         end;
      SM_MESSAGE :
         begin
            psMessage := @Code.Data;
            case psMessage^.rkey of
               MESSAGE_LOGIN        :
                  begin
                     PnInfo.Caption := GetWordString (psMessage^.rWordString);
                  end;
               MESSAGE_CREATELOGIN  :
                  begin
//                     FrmNewUser.Pninfo.Caption := GetWordString (psMessage^.rWordString);
                  end;
               MESSAGE_SELCHAR      :
                  begin
                     FrmSelChar.Pninfo.Caption := GetWordString (psMessage^.rWordString);
                  end;
               MESSAGE_GAMEING      :;
            end;
            if psMessage^.rkey = MESSAGE_LOGIN then
              ClearEdit (TRUE);
         end;
      SM_WINDOW :
         begin
            psWindow := @code.data;
            case pswindow^.rwindow of
               1 :
                  begin
                     Visible := pswindow^.rboShow;
                  end;
               2 :
                  begin
//                     FrmNewUser.Visible := pswindow^.rboShow;
                  end;
               3 :
                  begin
                     if pswindow^.rboShow then begin
                        FrmSelChar.MyShow;
                     end
                     else begin
                        FrmSelChar.MyHide;
                     end;
                  end;
               4 :
                  begin
                  end;
            end;
         end;
      SM_CHARINFO :
         begin
            FrmSelChar.ListBox1.Clear;
            psws := @Code.Data;
            str := GetWordString (psws^.rWordString);
            while TRUE do begin
               str := GetValidStr3 (str, rdstr, ',');
               if rdstr <> '' then FrmSelChar.ListBox1.AddItem (rdstr);
               if (str = '') or (FrmSelChar.ListBox1.Count > 5) then break;
            end;
            FrmSelChar.ListBox1.ItemIndex := 0;
            for i := 0 to FrmSelChar.ListBox1.Count -1 do begin
               str := FrmSelChar.ListBox1.Items[i];
               str := GetValidStr3 (str, rdstr, ':');
               if Pos (FrmLogon.ComboBox.Text,Str) > 0 then begin
                  FrmSelChar.ListBox1.ItemIndex := i;
                  break;
               end;
            end;
         end;
      else begin
         FrmM.MessageProcess (code);
         FrmBottom.MessageProcess (code);
         FrmAttrib.MessageProcess (code);
      end;
   end;
end;

function TFrmLogOn.SocketAddData(cnt:integer; pb:pbyte): Boolean;
var
   n : integer;
   sd : TWordComData;
   pcMove: PTCMove;
begin
   Result := FALSE;

   n := pb^;

   if n = CM_NETSTATE then begin
      if ChatMan.bSideMessage = false then begin
{$IFNDEF _DEBUG}
         MessageDelayTime[n] := mmAnsTick;
{$ENDIF}
      end;
      SendMoveCount := 0;
   end;

   if (n >= 0) and (n <= 255) then begin
      if MessageDelayTime[n] + 25 > mmAnsTick then exit;
      MessageDelayTime[n] := mmAnsTick;
   end;

   if n = CM_MOVE then begin
      pcMove := PTCMove(pb);
      pcMove^.rTick := SendMoveCount;
      pcMove^.rTick := oz_CRC32(pb, sizeof(TCMove));
      inc(SendMoveCount);
      if SendMoveCount mod 6 = 0 then begin
        pcMove^.rTick := oz_CRC32(pb, sizeof(TCMove));
      end;
   end;

   Result := True;
   sd.Size := cnt;

   Move (pb^, sd.data, cnt);

   if PacketSender <> nil then begin
      PacketSender.PutPacket (SendPacketCount, 0, 0, @sd, cnt + SizeOf (Word));
      inc(SendPacketCount);
      if SendPacketCount >= SendPacketCountMax then SendPacketCount := 0;
   end;
end;

function  TFrmLogOn.SocketAddOneData(adata:byte) :Boolean;
var sd : TComdata;
begin
   fillchar (sd, sizeof(sd), 0);
   sd.Size := 3;
   sd.data[0] := adata;

   Result := SocketAddData (3, @sd.data);
end;

function  TFrmLogOn.SocketDisConnect(ErrText, ErrCaption : string; aActive : Boolean): Boolean;
begin
   Result := true;
   try
      if aActive = TRUE then begin
         if sckConnect.Active then sckConnect.Active := FALSE;
      end;
   except
      Result := FALSE;
   end;
   if (ErrText <> '') or (ErrCaption <> '') then Application.MessageBox(Pchar(ErrText), Pchar(ErrCaption), 0);
end;

procedure TFrmLogOn.FormActivate(Sender: TObject);
const
   bofirst: boolean = TRUE;
var
   n : integer;
   sip, sport, sname : string;
begin
   if not bofirst then exit;
   bofirst := FALSE;

   if Animater.CheckMotion(AM_HIT10_READY) = false then begin
      ShowMessage(Conv('版本错误'));
      PostQuitMessage(0);
      boDirectClose := True;
      exit;
   end;

   n := HostAddressClass.FindIndexByname (ComBoBox.text);
   sip := HostAddressClass.GetIps (n , '210.113.15.129');
   sport := HostAddressClass.GetPorts (n , '3051');
   sname := HostAddressClass.GetNames (n , Conv('创造'));

   sckConnect.Address := sip;
   sckConnect.Port := _StrToInt (sport);

   Caption := Conv('千年')+' [' + sname +']';

   CaptionServerName := sname;

   try
      sckConnect.Active := TRUE;
   except
      Pninfo.Caption := Conv('连接失败');
   end;
   CurServerName := Combobox.text;
end;

procedure TFrmLogOn.ComboBoxChange(Sender: TObject);
var
   n : integer;
   sip, sport, sname: string;
begin
   n := HostAddressClass.FindIndexByName (ComboBox.Text);
   ComboBox.Text := HostAddressClass.GetNames (n, Conv('创造'));
   if CurServerName = ComboBox.Text then exit;
   CurServerName := ComboBox.Text;

   ClientIni.WriteString ('CLIENT','NAMEOFLEND',ComboBox.Text);

   ConnectState := cs_none;
   sckConnect.Active := false;

   n := HostAddressClass.FindIndexByname (ComBoBox.text);
   sip := HostAddressClass.GetIps (n , '210.113.15.129');
   sport := HostAddressClass.GetPorts (n , '3051');
   sname := HostAddressClass.GetNames (n , Conv('创造'));

   try
      if not sckConnect.Active then begin
         sckConnect.Address := sip;
         sckConnect.Port := _StrToInt (sport);
      end else sckConnect.Active := FALSE;
   except
      Pninfo.Caption := Conv('连接失败');
      exit;
   end;

   Pninfo.Caption := Conv('连接中…');

   EdId.Enabled := FALSE;
   EdPass.Enabled := FALSE;
   BtnLogin.Enabled := FALSE;
   BtnNewUser.Enabled := FALSE;
   EdId.Color := clBtnFace;
   EdPass.Color := clBtnFace;

   try
      sckConnect.Active := TRUE;
   except
      Pninfo.Caption := Conv('连接失败');
   end;
   CurServerName := Combobox.text;
end;

procedure TFrmLogOn.ComboBoxRChange(Sender: TObject);
var
   i: integer;
begin
   ComboBox.Text := '';
   ComboBox.Items.Clear;
   for i := 0 to HostAddressClass.Count-1 do begin
      if ComboBoxR.Text = HostAddressClass.GetRegions(i, '') then begin
         ComboBox.Items.Add(HostAddressClass.GetNames(i, ''));
         if ComboBox.Text = '' then ComboBox.Text := HostAddressClass.GetNames(i, '');
      end;
   end;
   ComboBox.OnChange(Self);
end;

procedure TFrmLogOn.TimerReConnectTimer(Sender: TObject);
begin
   try
      sckConnect.Address := ReConnectIpAddr;
      sckConnect.Port := ReConnectPort;
      sckConnect.Active := true;
      TimerReConnect.Enabled := FALSE;
   except
      exit;
   end;
end;


procedure TFrmLogOn.SetFormText;
begin
   // FrmLogOn font set
   FrmLogOn.Font.Name :=mainFont;

   PnInfo.Font.Name := mainFont;
   ComboBox.Font.Name := mainFont;
   EdID.Font.Name := mainFont;
   EdPass.Font.Name := mainFont;

   Caption := Conv('千年');
   Pninfo.Caption := Conv('连接中…若无连线帐号，请按【新名称】建立');
end;


procedure TFrmLogOn.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
   FrmM.SetA2Form (Self, A2form);
end;

procedure TFrmLogOn.TimerNixConnectConfirmedTimer(Sender: TObject);
var
   str : string;
begin
   if not boTimePaid then begin
      if not CheckConnect then begin
         TimerNixConnectConfirmed.Enabled := FALSE;
         str := ErrorMessage;
         if str = '' then str := Conv('不知名错误');
         SocketDisConnect(str,Conv('用户认证'),TRUE);
         FrmM.Close;
      end;
   end;
end;

procedure TFrmLogOn.TimerSpeedCheckTimer(Sender: TObject);
var
   Tick : integer;
   nHour, nMin, nSec, nMSec : word;
   ElaspedTime : TDateTime;
   aTime : integer;
begin

/////

   FCurTick := mmAnsTick;
   Tick := (FCurTick - FOldTick) div 100;
   ElaspedTime := Time - FStartTime;
   DecodeTime (ElaspedTime, nHour, nMin, nSec, nMSec);
   aTime := nHour * 3600 + nMin * 60 + nSec + 15;
   inc(indexTick);
   if indexTick > 10000 then begin
      FOldTick := mmAnsTick;
      FStartTime := Time;
      indexTick := 0;
   end;
   if Tick > aTime then begin
      TimerSpeedCheck.Enabled := FALSE;
      SocketDisConnect(Conv('由于使用外挂程序关闭.'), Conv('千年'), TRUE);
      sleep (100);
      FrmM.Close;
   end;
end;

procedure TFrmLogOn.sckConnectConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
   cVer : TCVer;
begin
{$ifdef _HACKCHECK}
   with Socket.RemoteAddr.sin_addr.S_un_b do begin
      if ((s_b1=#127) and (s_b2=#0)) or ((s_b1=#192) and (s_b2=#168)) then begin
         FrmM.DXTimer1.Enabled := FALSE;
         SocketDisConnect(Conv('与服务器连接中断'),Conv('千年'),FALSE);
         FrmM.Close;
      end;
   end;
{$endif}
   {
   if PacketSender <> nil then begin
      PacketSender.Free;
      PacketSender := nil;
   end;
   if PacketReceiver <> nil then begin
      PacketReceiver.Free;
      PacketReceiver := nil;
   end;
   }
   PacketSender.Clear;
   PacketReceiver.Clear;
   PacketSender.SetSocket(Socket);
   // add by minds
   SendPacketCount := 0;

   {  // change by minds 020218
   PacketSender := TPacketSender.Create ('Sender', 65535, Socket);
   PacketReceiver := TPacketReceiver.Create ('Receiver', 65535);
   }
   if ConnectState = cs_none then begin
      Pninfo.Caption := Conv('连线成功...若无连线帐号，请按【新名称】建立');

      EdId.Enabled := TRUE;
      EdPass.Enabled := TRUE;
      BtnLogin.Enabled := TRUE;
      BtnNewUser.Enabled := TRUE;
      EdId.Color := clBlack;
      EdPass.Color := clBlack;
      if Visible then EdId.SetFocus;

      ConnectState := cs_balance;
   end else if ConnectState = cs_balance then begin
      cVer.rmsg := CM_VERSION;
      cVer.rVer := PROGRAM_VERSION;
      cVer.rNation := NATION_VERSION;
      SocketAddData (sizeof(cVer), @cVer);

      ConnectState := cs_gate;
   end;
end;

procedure TFrmLogOn.sckConnectDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   PacketSender.SetSocket(nil);
   PacketSender.Clear;
   PacketReceiver.Clear;
   {  // change by minds 020218
   if PacketSender <> nil then begin
      PacketSender.Free;
      PacketSender := nil;
   end;
   if PacketReceiver <> nil then begin
      PacketReceiver.Free;
      PacketReceiver := nil;
   end;
   }
   if not ReConnetFlag then exit;
   if FrmBottom.Visible then begin
      if ReConnectId = '' then begin
         ReConnetFlag := FALSE;
         TimerNixConnectConfirmed.Enabled := FALSE;
         FrmM.DXTimer1.Enabled := FALSE;
         if boTimePaid then
            if not CloseFlag then SocketDisConnect (Conv('与服务器连接中断'),Conv('千年'),FALSE);
         FrmM.Close;
      end;
   end;
end;

procedure TFrmLogOn.sckConnectError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   if ErrorCode = WSAECONNREFUSED then Socket.Close;
   if ErrorCode = WSAECONNABORTED then Socket.Close;
   ErrorCode := 0;
   PnInfo.Caption := Conv('连接失败!!!')
end;

procedure TFrmLogOn.sckConnectRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   buffer : array [0..4096 - 1] of char;
   nRead : Integer;
begin
   nRead := Socket.ReceiveBuf (buffer, 4096);
   if nRead > 0 then begin
      if PacketReceiver <> nil then begin
         if PacketReceiver.PutData (@buffer, nRead) = false then begin
         end;
      end;
   end;
end;

procedure TFrmLogOn.sckConnectWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if PacketSender <> nil then begin
      PacketSender.WriteAllow := true;
   end;
end;

procedure TFrmLogOn.timerProcessTimer(Sender: TObject);
var
   nSize, i : Integer;
   PacketData : TPacketData;
   ComData : TWordComData;
begin
   if PacketSender <> nil then PacketSender.Update;

   if PacketReceiver <> nil then begin
      PacketReceiver.Update;
      if PacketReceiver.Count > 0 then begin
         for i := 0 to 50 -1 do begin
            if not sckConnect.Active then exit;
            if PacketReceiver.Count = 0 then exit;
            if PacketReceiver.GetPacket (@PacketData) = false then break;

            nSize := PacketData.PacketSize - SizeOf (Word) - SizeOf (Integer) - SizeOf (Byte) - SizeOf (Byte);

            if nSize < 4096 then begin
               Move (PacketData.Data, ComData, nSize);
               if MessageProcess (ComData) = false then break;
               PacketCount := PacketCount + 1;
               if PacketCount > PacketMaxCount then PacketMaxCount := PacketCount;
            end;
         end;
      end;
   end;

end;


var
   ansStringClass : TansStringClass;

function Conv (astr : string): string;
begin
   Result := ansStringClass.GetString(astr);
end;

procedure TFrmLogOn.TimerMacroCheckTimer(Sender: TObject);
var
   h : pchar;
begin
///// 皋农肺 力芭
   h := pchar(FindWindow(nil, '皓?彳酗'));
   if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

   h := pchar(FindWindow(nil, 'GearNT'));
   if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

   h := pchar(FindWindow(nil, '1000y - XZ'));
   if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

   h := pchar(FindWindow(nil, 'Brothers Speeder'));
   if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

   h := pchar(FindWindow(nil, '冈扁概农肺3.1(快吝按)'));
   if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

   h := pchar(FindWindow(nil, 'GhostMouse'));
   if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

   h := pchar(FindWindow(nil, '玫斥概农肺'));
   if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

   h := pchar(FindWindow(nil, '玫斥(1000y) Macro Program Version 2.9a'));
   if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

   h := pchar(FindWindow(nil, '玫斥(1000y) Macro Program Version 2.3c'));
   if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

   ////////// Marco Express
   h := pchar(FindWindow(nil, 'Macro Express Editor (MACEX)'));
   if h <> nil then PostMessage(THandle(h), WM_CLOSE, 0, 0);

   h := pchar(FindWindow(nil, 'Auto Training Program Ver. 5.0'));
   if h <> nil then PostMessage(THandle(h), WM_CLOSE, 0, 0);

   h := pchar(FindWindow(nil, '1000yMacro(轿颇炉 傈侩)'));
   if h <> nil then PostMessage(THandle(h), WM_CLOSE, 0, 0);

   h := pchar(FindWindow(nil, '1000yMacro'));
   if h <> nil then PostMessage(THandle(h), WM_CLOSE, 0, 0);

   BuildProcess32List;
   TerminateProcessName('macexp.exe');
end;

procedure TFrmLogOn.EdPassEnter(Sender: TObject);
begin
   Randomize;
   VirtKeyX := Random(295-8) + 8;
   VirtKeyY := Random(364-344) + 344;
   bShowVirtualKey := True;
end;

procedure TFrmLogOn.EdPassExit(Sender: TObject);
begin
   bShowVirtualKey := False;
end;

procedure TFrmLogOn.A2FormAdxPaint(aAnsImage: TA2Image);
var
   KeyImage: TA2Image;
   KeyState: TKeyboardState;
begin
   if bShowVirtualKey then begin
      KeyImage := EtcViewClass[VirtKeyImage];
      if KeyImage = nil then exit;
      aAnsImage.DrawImage(KeyImage, VirtKeyX, VirtKeyY, true);
      GetKeyboardState(KeyState);
      DrawKeyValue(aAnsImage, VirtKeyDown, ssShift in KeyboardStateToShiftState(KeyState));
   end;
end;

procedure TFrmLogon.DrawKeyValue(A2Image: TA2Image; PushKey: string; Shift: Boolean);
begin
   DrawKey(A2Image, 40,  10, Shift, PushKey, '1');
   DrawKey(A2Image, 65,  10, Shift, PushKey, '2');
   DrawKey(A2Image, 91,  10, Shift, PushKey, '3');
   DrawKey(A2Image, 117, 10, Shift, PushKey, '4');
   DrawKey(A2Image, 142, 10, Shift, PushKey, '5');
   DrawKey(A2Image, 168, 10, Shift, PushKey, '6');
   DrawKey(A2Image, 193, 10, Shift, PushKey, '7');
   DrawKey(A2Image, 220, 10, Shift, PushKey, '8');
   DrawKey(A2Image, 245, 10, Shift, PushKey, '9');
   DrawKey(A2Image, 271, 10, Shift, PushKey, '0');
   DrawKey(A2Image, 303, 10, Shift, PushKey, '<-');

   DrawKey(A2Image, 52,  36, Shift, PushKey, 'q');
   DrawKey(A2Image, 77,  36, Shift, PushKey, 'w');
   DrawKey(A2Image, 104, 36, Shift, PushKey, 'e');
   DrawKey(A2Image, 130, 36, Shift, PushKey, 'r');
   DrawKey(A2Image, 155, 36, Shift, PushKey, 't');
   DrawKey(A2Image, 181, 36, Shift, PushKey, 'y');
   DrawKey(A2Image, 206, 36, Shift, PushKey, 'u');
   DrawKey(A2Image, 233, 36, Shift, PushKey, 'i');
   DrawKey(A2Image, 258, 36, Shift, PushKey, 'o');
   DrawKey(A2Image, 284, 36, Shift, PushKey, 'p');

   DrawKey(A2Image, 59,  62, Shift, PushKey, 'a');
   DrawKey(A2Image, 84,  62, Shift, PushKey, 's');
   DrawKey(A2Image, 110, 62, Shift, PushKey, 'd');
   DrawKey(A2Image, 136, 62, Shift, PushKey, 'f');
   DrawKey(A2Image, 161, 62, Shift, PushKey, 'g');
   DrawKey(A2Image, 187, 62, Shift, PushKey, 'h');
   DrawKey(A2Image, 212, 62, Shift, PushKey, 'j');
   DrawKey(A2Image, 239, 62, Shift, PushKey, 'k');
   DrawKey(A2Image, 264, 62, Shift, PushKey, 'l');

   DrawKey(A2Image, 72,  88, Shift, PushKey, 'z');
   DrawKey(A2Image, 97,  88, Shift, PushKey, 'x');
   DrawKey(A2Image, 122, 88, Shift, PushKey, 'c');
   DrawKey(A2Image, 148, 88, Shift, PushKey, 'v');
   DrawKey(A2Image, 173, 88, Shift, PushKey, 'b');
   DrawKey(A2Image, 199, 88, Shift, PushKey, 'n');
   DrawKey(A2Image, 224, 88, Shift, PushKey, 'm');

   if Shift then begin
      DrawKey(A2Image, 18,  88, false, 'Shift', 'Shift');
      DrawKey(A2Image, 288, 88, false, 'Shift', 'Shift');
   end else begin
      DrawKey(A2Image, 18,  88, false, '', 'Shift');
      DrawKey(A2Image, 288, 88, false, '', 'Shift');
   end;

   DrawKey(A2Image, 291, 62, false, PushKey, 'Enter');
end;

procedure TFrmLogon.DrawKey(A2Image: TA2Image; X, Y: integer; Shift: Boolean; PushKey, DrawKey: string);
var
   Col: Word;
begin
   Col := WinRGB(25, 26, 22);
   if DrawKey = PushKey then Col := WinRGB(25, 6, 5);
   if Shift then begin
      DrawKey := UpperCase(DrawKey);
      if DrawKey = '1' then DrawKey := '!';
      if DrawKey = '2' then DrawKey := '@';
      if DrawKey = '3' then DrawKey := '#';
      if DrawKey = '4' then DrawKey := '$';
      if DrawKey = '5' then DrawKey := '%';
      if DrawKey = '6' then DrawKey := '^';
      if DrawKey = '7' then DrawKey := '&';
      if DrawKey = '8' then DrawKey := '*';
      if DrawKey = '9' then DrawKey := '(';
      if DrawKey = '0' then DrawKey := ')';
   end;
   ATextOut(A2Image, VirtKeyX+X, VirtKeyY+Y, Col, DrawKey);
end;

procedure TFrmLogOn.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   VirtPoint: TPoint;
   KeyState: TKeyboardState;
begin
   VirtPoint := Point(X - VirtKeyX, Y - VirtKeyY);
   VirtKeyDown := '';
   if PtInRect(Rect(30, 4, 333, 26), VirtPoint) then // 123~90<-
      case VirtPoint.X of
      30..51:   VirtKeyDown := '1';
      56..77:   VirtKeyDown := '2';
      81..103:  VirtKeyDown := '3';
      107..129: VirtKeyDown := '4';
      133..154: VirtKeyDown := '5';
      158..180: VirtKeyDown := '6';
      184..206: VirtKeyDown := '7';
      210..231: VirtKeyDown := '8';
      235..257: VirtKeyDown := '9';
      261..283: VirtKeyDown := '0';
      287..334: VirtKeyDown := '<-';
      end
   else if PtInRect(Rect(42, 30, 296, 52), VirtPoint) then // qwe ~ iop
      case VirtPoint.X of
      42..64:   VirtKeyDown := 'q';
      68..90:   VirtKeyDown := 'w';
      94..115:  VirtKeyDown := 'e';
      120..141: VirtKeyDown := 'r';
      145..167: VirtKeyDown := 't';
      171..193: VirtKeyDown := 'y';
      197..219: VirtKeyDown := 'u';
      223..244: VirtKeyDown := 'i';
      248..270: VirtKeyDown := 'o';
      274..296: VirtKeyDown := 'p';
      end
   else if PtInRect(Rect(49, 56, 276, 78), VirtPoint) then // asd ~ jkl
      case VirtPoint.X of
      49..71:   VirtKeyDown := 'a';
      75..97:   VirtKeyDown := 's';
      101..122: VirtKeyDown := 'd';
      127..148: VirtKeyDown := 'f';
      152..174: VirtKeyDown := 'g';
      178..200: VirtKeyDown := 'h';
      204..226: VirtKeyDown := 'j';
      230..251: VirtKeyDown := 'k';
      255..277: VirtKeyDown := 'l';
      end
   else if PtInRect(Rect(62, 82, 263, 104), VirtPoint) then // zxc ~ bnm
      case VirtPoint.X of
      62..84:   VirtKeyDown := 'z';
      88..110:  VirtKeyDown := 'x';
      114..135: VirtKeyDown := 'c';
      140..161: VirtKeyDown := 'v';
      165..187: VirtKeyDown := 'b';
      191..213: VirtKeyDown := 'n';
      217..239: VirtKeyDown := 'm';
      end
   else if PtInRect(Rect(300, 30, 333, 78), VirtPoint) or
      PtInRect(Rect(280, 56, 299, 78), VirtPoint) then begin // Enter
      VirtKeyDown := 'Enter';
      BtnLogin.OnClick(Sender);
      exit;
   end;

   if VirtKeyDown = '' then exit;
   GetKeyboardState(KeyState);
   if VirtKeyDown = '<-' then begin
      EdPass.Text := Copy(EdPass.Text, 1, Length(EdPass.Text)-1);
   end else begin
      if ssShift in KeyboardStateToShiftState(KeyState) then
         if VirtKeyDown = '1' then EdPass.Text := EdPass.Text + '!'
         else if VirtKeyDown = '2' then EdPass.Text := EdPass.Text + '@'
         else if VirtKeyDown = '3' then EdPass.Text := EdPass.Text + '#'
         else if VirtKeyDown = '4' then EdPass.Text := EdPass.Text + '$'
         else if VirtKeyDown = '5' then EdPass.Text := EdPass.Text + '%'
         else if VirtKeyDown = '6' then EdPass.Text := EdPass.Text + '^'
         else if VirtKeyDown = '7' then EdPass.Text := EdPass.Text + '&'
         else if VirtKeyDown = '8' then EdPass.Text := EdPass.Text + '*'
         else if VirtKeyDown = '9' then EdPass.Text := EdPass.Text + '('
         else if VirtKeyDown = '0' then EdPass.Text := EdPass.Text + ')'
         else EdPass.Text := EdPass.Text + UpperCase(VirtKeyDown)
      else
         EdPass.Text := EdPass.Text + VirtKeyDown;
   end;
   EdPass.SelStart := Length(EdPass.Text);
end;

procedure TFrmLogOn.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   VirtKeyDown := '';
end;

Initialization
begin
   ansStringClass := TansStringClass.Create;
   if NATION_VERSION = NATION_KOREA then exit;
   ansStringClass.LoadFromFile ('ncl1000.acs');
end;

Finalization
begin
   ansStringClass.Free;
end;


end.

