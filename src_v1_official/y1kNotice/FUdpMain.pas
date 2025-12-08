unit FUdpMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, deftype,
  StdCtrls, IniFiles, adeftype, Barutil, AUtil32, ExtCtrls, Grids, uAnstick, UserSdb, FSUdpM,
  ScktComp, TrafficGraph;

type
   TUserData = record
      rServerId : integer;
      rConId : integer;
      rLoginId  : string[20];
      rCharName : string[20];
      rIpaddr   : string[20];
      rSenderPort : integer;
   end;
   PTUserData = ^TUserData;

   TUserListClass = class
    private
      DataList : TList;
    public
      constructor Create;
      destructor  Destroy; override;
      function    FindUser (var idx: integer; aLoginId, aCharName: string): PTUserData;
      function    AddUser (aServerId, aConid, aSenderPort: integer; aLoginId, aCharName, aIpaddr: string; aType : Byte): Integer;
      procedure   DeleteUser(aLoginId, aCharName: string);
      procedure   DeleteAllUserbyServerId (aServerId: integer);
      procedure   CloseUserByLoginId (aLoginId, aipaddr: string);
      function    GetServerUserCount (aServerId: integer): integer;
      procedure   SaveToFile (aFileName: string);
   end;

  TIpData = record
    ipaddr : wstring;
    Port : integer;
    name : string[32];
    Count : integer;
  end;
  PTIpData = ^TIpData;

  TFrmScreen = class(TForm)
    BtnClose: TButton;
    TimerProcess: TTimer;
    SG: TStringGrid;
    BtnSave: TButton;
    ServerSocket1: TServerSocket;
    lstInfo: TListBox;
    lstResult: TListBox;
    cmbServer: TComboBox;
    cmdReLoad: TButton;
    grpInfo: TTrafficGraph;
    timerDisplay: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerProcessTimer(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure cmdReLoadClick(Sender: TObject);
    procedure timerDisplayTimer(Sender: TObject);
  private
    UserListClass : TUserListClass;
    Ini: TIniFile;
    ipCount : integer;
    IpList : TList;
    procedure StringProcess (aServerId: integer; var code: TComData);
  public
    NoticeIniDate : string;
  end;

  procedure AddInfo (aStr : String);
  procedure AddResult (aStr : String);

var
  FrmScreen: TFrmScreen;
  GateWayList : TStringList;
  FreeIpList : TStringList;


implementation

uses FHer;

{$R *.DFM}

var
   UdpHandle : integer;

procedure AddInfo (aStr : String);
begin
   if frmScreen.lstInfo.Items.Count >= 1000 then begin
      frmScreen.lstInfo.Items.Delete (0);
   end;
   frmScreen.lstInfo.Items.Add (aStr);
   frmScreen.lstInfo.ItemIndex := frmScreen.lstInfo.Items.Count - 1;
end;

procedure AddResult (aStr : String);
begin
   if frmScreen.lstResult.Items.Count >= 1000 then begin
      frmScreen.lstResult.Items.Delete (0);
   end;
   frmScreen.lstResult.Items.Add (aStr);
   frmScreen.lstResult.ItemIndex := frmScreen.lstResult.Items.Count - 1;
end;

procedure TFrmScreen.StringProcess (aServerId: integer; var code: TComData);
var
   pd : PTNTData;
begin
   pd := @Code.Data;

   case pd^.rmsg of
      NM_NONE           :;
      NM_CM_INUSER         :
         begin
            UserListClass.CloseUserByLoginId (pd^.rLoginId, pd^.rIpaddr);
            UserListClass.AddUser (aServerId, pd^.rConId, pd^.rSenderPort, pd^.rLoginId, pd^.rCharName, pd^.rIpaddr, pd^.rPaidType);
         end;
      NM_CM_OUTUSER        :
         begin
            UserListClass.DeleteUser (pd^.rLoginId, pd^.rCharName);
         end;
      NM_CM_ALLCLEAR   :
         begin
            UserListClass.DeleteAllUserbyServerId (aServerId);
         end;
   end;
end;

procedure TFrmScreen.FormCreate(Sender: TObject);
var
   i : integer;
   pi : PTIpData;
   nd : TNTData;
begin
   FreeIpList := TStringList.Create;
   if FileExists ('FreeIpList.TXT') then FreeIpList.LoadFromFile ('FreeIpList.TXT');
   GateWayList := TStringList.Create;
   if FileExists ('gatewaylist.txt') then GateWayList.LoadFromFile ('gatewaylist.txt');
   Ini := TIniFile.Create ('.\Notice.ini');
   UserListClass := TUserListClass.Create;

   UdpHandle := DllUdpAlloc (Ini.ReadInteger ('NOTICE','PORT', 5999));

   ServerSocket1.Port := Ini.ReadInteger ('NOTICE','PORT', 5999);
   ServerSocket1.Active := TRUE;

   Caption := 'Y1K_Notice[Port:' + IntToStr (Ini.ReadInteger ('NOTICE','PORT', 5999))+']';

   IpList := TList.Create;
   ipCount := Ini.ReadInteger ('NOTICE','IPCOUNT', 0);
   SG.RowCount := ipCount;

   for i := 1 to ipCount do begin
      new (pi);
      SetWSString (pi^.ipaddr, Ini.ReadString ('NOTICE','IP' + IntToStr(i), '127.0.0.1'));
      pi^.name := Ini.ReadString ('NOTICE','NAME'+IntToStr(i), '테스트');
      pi^.Port := Ini.ReadInteger ('NOTICE','PORT'+IntToStr(i), 0);
      pi^.Count := 0;
      IpList.Add (pi);
      SG.Cells [0, i-1] := pi^.name;

      cmbServer.Items.Add (pi^.Name);
      
      DllUdpAddIp (UdpHandle, pi^.ipaddr);
   end;
   if cmbServer.Items.Count > 0 then begin
      cmbServer.ItemIndex := 0;
   end;

   FillChar (nd, sizeof(nd), 0);
   for i := 0 to ipCount-1 do begin
      nd.rmsg := NM_SM_REQUESTALLUSER;
      DllUdpSendData (PTIpData(IpList[i])^.ipaddr, PTIpData(IpList[i])^.Port, sizeof(nd), @nd);
   end;

   timerDisplay.Interval := 1000;
   timerDisplay.Enabled := true;

   TimerProcess.Enabled := TRUE;
end;

procedure TFrmScreen.FormDestroy(Sender: TObject);
var i : integer;
begin
   for i := 0 to IpList.Count-1 do begin
      dispose (IpList[i]);
   end;
   IpList.Free;

   UserListClass.free;
   Ini.Free;
   
   GateWayList.Free;
   FreeIpList.Free;
end;

procedure TFrmScreen.TimerProcessTimer(Sender: TObject);
var
   i: integer;
   sd : TComData;
   pi : PTIpData;
begin
   for i := 0 to IpList.Count -1 do begin
      pi := IpList[i];
      while TRUE do begin
         if not DllUdpGetData (UdpHandle, pi^.ipaddr, sd) then break;
         StringProcess (i, sd);
      end;

      pi^.Count := UserListClass.GetServerUserCount (i);
      SG.Cells [1, i] := IntToStr (pi^.Count);
   end;
end;

procedure TFrmScreen.BtnCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TFrmScreen.BtnSaveClick(Sender: TObject);
var
   i: integer;
   pi : PTIpData;
begin
   UserListclass.SaveToFile('curuser.sdb');
   for i := 0 to IpList.Count -1 do begin
      pi := IpList[i];
      pi^.Count := 0;
      SG.Cells [1, i] := IntToStr (pi^.Count);
   end;
end;


///////////////////////////////////
//         PaidDbClass
///////////////////////////////////

constructor TUserListClass.Create;
begin
   DataList := TList.Create;
end;

destructor  TUserListClass.Destroy;
var i: integer;
begin
   for i := 0 to DataList.count -1 do dispose (DataList[i]);
   DataList.Free;
   inherited Destroy;
end;

function    TUserListClass.FindUser (var idx: integer; aLoginId, aCharName: string): PTUserData;
var
   i: integer;
   pu : PTUserData;
begin
   Result := nil;
   for i := 0 to DataList.Count -1 do begin
      pu := DataList[i];
      if (pu^.rLoginId = aLoginId) and (pu^.rCharName = aCharName) then begin
         idx := i;
         Result := pu;
         exit;
      end;
   end;
end;

function    TUserListClass.AddUser (aServerId, aConid, aSenderPort: integer; aLoginId, aCharName, aIpaddr: string; aType : Byte): Integer;
   procedure SetUserData (apu: PTUserData; aServerId, aConid, aSenderPort: integer; aLoginId, aCharName, aIpaddr: string);
   begin
      apu^.rServerId := aServerId;
      apu^.rConId := aConid;
      apu^.rLoginId := aLogInid;
      apu^.rCharName := aCharName;
      apu^.rIpaddr := aIpAddr;
      apu^.rSenderPort := aSenderPort;
   end;
var
   idx: integer;
   pu : PTUserData;
begin
   Result := -1;

   AddInfo (format ('IN : %s (%s)', [aLoginID, aCharName]));

   pu := FindUser (idx, aLoginId, aCharName);
   if pu <> nil then begin
      SetUserData (pu, aServerId, aConid, aSenderPort, aLoginId, aCharName, aIpAddr);
      exit;
   end;

   new (pu);
   SetUserData (pu, aServerId, aConid, aSenderPort, aLoginId, aCharName, aIpAddr);
   Result := DataList.Add (pu);
end;

procedure   TUserListClass.DeleteUser (aLoginId, aCharName: string);
var
   cidx: integer;
   pu : PTUserData;
begin
   AddInfo (format ('OUT : %s (%s)', [aLoginID, aCharName]));

   pu := FindUser (cidx, aLoginId, aCharName);
   if pu <> nil then begin
      dispose (pu);
      DataList.Delete (cidx);
   end;
end;

procedure   TUserListClass.DeleteAllUserbyServerId (aServerId: integer);
var
   i: integer;
   pu : PTUserData;
begin
   for i := DataList.Count -1 downto 0 do begin
      pu := DataList[i];
      if pu^.rServerId = aServerId then begin
         dispose (pu);
         DataList.Delete (i);
      end;
   end;
end;

procedure   TUserListClass.CloseUserByLoginId (aLoginId, aipaddr: string);
var
   i: integer;
   pu : PTUserData;
   nd : TNTData;
   Str : String;
begin
   for i := 0 to GateWayList.Count -1 do
      if GateWayList[i] = aipaddr then aipaddr := '';

   for i := 0 to DataList.Count -1 do begin
      pu := DataList[i];
//      if (pu^.rLoginId = aLoginId) or (pu^.ripaddr = aipaddr) then begin  // 중복접속 불가
      if (pu^.rLoginId = aLoginId) then begin
         AddResult (format ('BAN : %s (%s)', [pu^.rLoginID, pu^.rCharName]));

         nd.rmsg := NM_SM_REQUESTCLOSE;
         nd.rConId := pu^.rConId;
         nd.rLoginId := pu^.rLoginId;
         nd.rIpaddr := pu^.rIpaddr;
         nd.rCharName := pu^.rCharName;
         nd.rSenderPort := pu^.rSenderPort;

         DllUdpSendData (PTIpData(FrmScreen.IpList[pu^.rServerId])^.ipaddr, pu^.rSenderPort, sizeof(nd), @nd);
      end;
   end;
end;

function    TUserListClass.GetServerUserCount (aServerId: integer): integer;
var
   i, ret: integer;
begin
   ret := 0;
   for i := 0 to DataList.Count -1 do begin
      if PTUserData (DataList[i])^.rServerId = aServerId then ret := ret + 1;
   end;
   Result := ret;
end;

procedure   TUserListClass.SaveToFile (aFileName: string);
var
   i : integer;
   pu : PTUserData;
   StringList : TStringList;
begin
   StringList := TStringList.Create;
   StringList.Add ('Name,CharName,Ipaddr,');
   for i := 0 to DataList.Count -1 do begin
      pu := DataList[i];
      StringList.Add (format ('%s,%s,%s,',[pu^.rLoginId, pu^.rCharName, pu^.rIpaddr]));
   end;
   StringList.SaveToFile (aFileName);
   StringList.Free;
end;

procedure TFrmScreen.FormHide(Sender: TObject);
begin
   FrmMain.Close;
end;

procedure TFrmScreen.ServerSocket1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
   str, datastr: string;
   cmd, uid: string;
begin
   str := Socket.ReceiveText;
   while TRUE do begin
      if str = '' then break;
      str := GetValidStr3 (str, DataStr, #13);

      Datastr := GetValidStr3 (Datastr, cmd, ',');
      Datastr := GetValidStr3 (Datastr, uid, ',');

      if CompareText (cmd,'@CLOSE') = 0 then UserListClass.CloseUserByLoginId (uid, '');
   end;
end;

procedure TFrmScreen.cmdReLoadClick(Sender: TObject);
var
   i : Integer;
   ServerName : String;
   pi : PTIpData;
   nd : TNTData;
begin
   if cmbServer.ItemIndex < 0 then exit;

   ServerName := cmbServer.Items [cmbServer.ItemIndex];
   if ServerName = '' then exit;

   FillChar (nd, sizeof(nd), 0);
   nd.rmsg := NM_SM_REQUESTALLUSER;
   for i := 0 to IpList.Count - 1 do begin
      pi := IpList.Items [i];
      if pi^.Name = ServerName then begin
         DllUdpSendData (PTIpData(IpList[i])^.ipaddr, PTIpData(IpList[i])^.Port, sizeof(nd), @nd);
         exit;
      end;
   end;
end;

procedure TFrmScreen.timerDisplayTimer(Sender: TObject);
var
   i : Integer;
   TotalCount : Integer;
   pi : PTIpData;
begin
   TotalCount := 0;
   for i := 0 to IpList.Count - 1 do begin
      pi := IpList.Items [i];
      TotalCount := TotalCount + pi^.Count;
   end;

   grpInfo.Add (TotalCount);
end;

end.
