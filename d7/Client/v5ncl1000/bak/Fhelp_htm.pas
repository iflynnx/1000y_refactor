unit Fhelp_htm;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ComCtrls, OleCtrls, SHDocVw, ExtCtrls,IniFiles;

type
    TfrmHelp = class(TForm)
        TreeView1: TTreeView;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    WebBrowser1: TWebBrowser;
    TabSheet3: TTabSheet;
    Memo2: TMemo;
    TabSheet6: TTabSheet;
    WebBrowser4: TWebBrowser;
    Button5: TButton;
    WebBrowser2: TWebBrowser;
        procedure FormCreate(Sender: TObject);
        procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
 
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);

    private
        { Private declarations }
    public
        { Public declarations }
//    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    end;
var
    frmHelp: TfrmHelp;
implementation

{$R *.dfm}
uses activex, MSHTML, FMain, filepgkclass, Math, FQuest, FGuild,
  FBillboardcharts, FEmporia, FBottom, FSound;

procedure LoadStream(WebBrowser: TWebBrowser; Stream: TStream);
var
    PersistStreamInit: IPersistStreamInit;
    StreamAdapter: IStream;
    MemoryStream: TMemoryStream;
begin
    WebBrowser.Navigate('about:blank');
    repeat
        Application.ProcessMessages;
        Sleep(0);
    until
        WebBrowser.ReadyState = READYSTATE_COMPLETE;
    if WebBrowser.Document.QueryInterface(IPersistStreamInit, PersistStreamInit) = S_OK then
    begin
        if PersistStreamInit.InitNew = S_OK then
        begin
            MemoryStream := TMemoryStream.Create;
            try
                MemoryStream.CopyFrom(Stream, 0);
                MemoryStream.Position := 0;
            except
                MemoryStream.Free;
                raise;
            end;
            StreamAdapter := TStreamAdapter.Create(MemoryStream, soOwned);
            PersistStreamInit.Load(StreamAdapter);
        end;
    end;

end;

procedure TfrmHelp.FormCreate(Sender: TObject);
var
    ClientIni: TIniFile;
    navi1,navi2,help:string;
begin
     ClientIni := TIniFile.Create('.\ClientIni.ini');
    try
      navi1:=Trim(ClientIni.ReadString('FBL', 'navi1',''));
      navi2:=Trim(ClientIni.ReadString('FBL', 'navi2',''));
      help:=Trim(ClientIni.ReadString('FBL', 'help',''));
    finally
        ClientIni.Free;
    end;
 
    self.Align := alcustom;
    top := 0;
    Left := (fwide - Width) div 2;
    Parent := FrmM;
   WebBrowser2.Navigate(help);    //帮助
    WebBrowser1.Navigate(navi1);    //装备
    WebBrowser4.Navigate(navi2);     //任务
  //  WebBrowser1.Navigate('http://www.onlinejw.com/help/help.htm');

  {  if FileExists('helpList.txt') then
    begin

        TreeView1.LoadFromFile('helpList.txt');
        exit;
    end;
    if pgksys.isfile('helpList.txt') then
    begin
        MemoryStream := TMemoryStream.Create;
        try
            pgksys.get('helpList.txt', MemoryStream);
            MemoryStream.Position := 0;
            TreeView1.LoadFromStream(MemoryStream);
        finally
            MemoryStream.Free;
        end;
    end;

    TreeView1.Selected := TreeView1.Items.GetFirstNode;
   }
end;



procedure TfrmHelp.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
    str: string;
    tempNode: TTreeNode;
    MemoryStream: TMemoryStream;
begin
{
    tempNode := Node;
    str := tempNode.Text;
    while tempNode.Parent <> nil do
    begin
        tempNode := tempNode.Parent;
        str := tempNode.Text + '_' + str;
    end;
    Caption := str;
    if FileExists(str + '.html') then
    begin
        MemoryStream := TMemoryStream.Create;
        try
            MemoryStream.LoadFromFile(str + '.html');
            MemoryStream.Position := 0;
            LoadStream(WebBrowser1, MemoryStream);
        finally
            MemoryStream.Free;
        end;
        exit;
    end;
    if pgksys.isfile(str + '.html') then
    begin
        MemoryStream := TMemoryStream.Create;
        try
            pgksys.get(str + '.html', MemoryStream);
            MemoryStream.Position := 0;
            LoadStream(WebBrowser1, MemoryStream);
        finally
            MemoryStream.Free;
        end;
    end;
    }
end;


 



procedure TfrmHelp.Button2Click(Sender: TObject);
begin
      frmGuild.Visible := not frmGuild.Visible;
    if frmGuild.Visible then
    begin
        FrmM.SetA2Form(frmGuild, frmGuild.A2form);
        FrmM.move_win_form_Align(frmGuild, mwfCenter);
    end;
        Close;
end;

procedure TfrmHelp.Button3Click(Sender: TObject);
begin
    frmBillboardcharts.Visible := not frmBillboardcharts.Visible;
    if frmBillboardcharts.Visible then
    begin
        FrmM.SetA2Form(frmBillboardcharts, frmBillboardcharts.A2form);
        FrmM.move_win_form_Align(frmBillboardcharts, mwfCenter);
    end;
        Close;
end;

procedure TfrmHelp.Button4Click(Sender: TObject);
begin
//                  frmProcession.Visible := not frmProcession.Visible;
//                  if frmProcession.Visible then
//                  begin
//                      FrmM.SetA2Form(frmProcession, frmProcession.A2form);
//                      FrmM.move_win_form_Align(frmProcession, mwfCenter);
//                  end;
//     Close;
end;

procedure TfrmHelp.Button5Click(Sender: TObject);
begin
   FrmSound.Visible := not FrmSound.Visible;                                   // option芒
  //   FrmSelMagic.Visible := not FrmSelMagic.Visible;
  if FrmSound.Visible then
  begin

      FrmM.SetA2Form(FrmSound, FrmSound.A2form);
      //   FrmM.move_win_form_Align(FrmNewMagic, mwfRight);
  end;
  Close;
end;

end.

