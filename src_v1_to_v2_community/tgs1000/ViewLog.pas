unit ViewLog;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, StdCtrls, deftype;

type
    TfrmLog = class(TForm)
        Memo1: TMemo;
        PageControl1: TPageControl;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        TabSheet3: TTabSheet;
        Edit1: TEdit;
        Label1: TLabel;
        Button1: TButton;
        Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ComboBox1: TComboBox;
    Button6: TButton;
        procedure Edit1Change(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    frmLog: TfrmLog;

implementation

{$R *.dfm}
uses uGConnect, uuser, UTelemanagement;

procedure TfrmLog.Edit1Change(Sender: TObject);
begin
    NetPackLogName := Edit1.Text;
end;

procedure TfrmLog.Button1Click(Sender: TObject);
begin
    tmlog.gettostringlist(Memo1.Lines);
end;

procedure TfrmLog.Button2Click(Sender: TObject);
begin
    UserList.SendNoticeMessage('<服务器公告>' + ComboBox1.Text, $0000FFFF);
end;

procedure TfrmLog.Button3Click(Sender: TObject);
begin
    UserList.SendRollMSG( $0000FFFF,'<服务器公告>' + ComboBox1.Text);
end;

procedure TfrmLog.Button4Click(Sender: TObject);
begin
    UserList.SendTopMSG($0000FFFF,'<服务器公告>' + ComboBox1.Text );
end;

procedure TfrmLog.Button5Click(Sender: TObject);
begin
     UserList.SendCenterMSG( $0000FFFF,'<服务器公告>' + ComboBox1.Text,1);
end;

procedure TfrmLog.Button6Click(Sender: TObject);
begin
    UserList.SendTopMSG($0000FFFF,ComboBox1.Text );
end;

end.

