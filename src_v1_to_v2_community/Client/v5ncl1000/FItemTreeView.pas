unit FItemTreeView;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, StdCtrls;

type
    TfrmItemTreeView = class(TForm)
        TreeView1:TTreeView;
        Edit1:TEdit;
        Label1:TLabel;
        Button1:TButton;
        Button2:TButton;
        procedure FormCreate(Sender:TObject);
        procedure TreeView1DblClick(Sender:TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    frmItemTreeView :TfrmItemTreeView;

implementation

uses FMain;

{$R *.dfm}

procedure TfrmItemTreeView.FormCreate(Sender:TObject);
begin
    Parent := FrmM;
    if FileExists('TreeViewItem.txt') then
        TreeView1.LoadFromFile('TreeViewItem.txt');
end;

procedure TfrmItemTreeView.TreeView1DblClick(Sender:TObject);
begin
    if TreeView1.Selected.HasChildren = false then
    begin
        //frmAuction.A2EditsousuoText.Text := TreeView1.Selected.Text;
        Visible := false;
    end;
end;

end.

