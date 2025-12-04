unit fMapSdb;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UserSdb, ExtCtrls;

type
  TfrmMapsdb = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    Button2: TButton;
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMapsdb: TfrmMapsdb;
  Mapsdb: TNewStringDb;
  MapsdbNameList: tstringlist;
implementation
uses FMapMain;
{$R *.dfm}

procedure TfrmMapsdb.Button1Click(Sender: TObject);
var
  i: integer;
  iname, MapTitle: string;
  s: string;
begin
  ListBox1.Items.Text := '';
  Mapsdb.Clear;
  Mapsdb.LoadFile(INITGSPATH + '\Init\map.sdb');

  MapsdbNameList.Text := Mapsdb.getNaneIndexList;
  ListBox1.Items.Text := Mapsdb.getNaneIndexList;
  for i := 0 to MapsdbNameList.Count - 1 do
  begin
    iname := MapsdbNameList.Strings[i];
    MapTitle := Mapsdb.GetFieldValueString(iname, 'MapTitle');

    s := format('%S,(%S)', [iname, MapTitle]);
    ListBox1.Items.Strings[I] := S;
  end;

end;

procedure TfrmMapsdb.FormCreate(Sender: TObject);
begin
  Mapsdb := TNewStringDb.Create;
  MapsdbNameList := tstringlist.Create;
end;

procedure TfrmMapsdb.FormDestroy(Sender: TObject);
begin
  MapsdbNameList.Free;
  Mapsdb.Free;
end;

procedure TfrmMapsdb.Button2Click(Sender: TObject);
var
  i: integer;
  iname, MapName, TilName, ObjName, RofName: string;
begin
//
  i := ListBox1.ItemIndex;
  if (i < 0) or (i > ListBox1.Items.Count - 1) then exit;
  iname := MapsdbNameList.Strings[i];
  MapName := Mapsdb.GetFieldValueString(iname, 'MapName');
  TilName := Mapsdb.GetFieldValueString(iname, 'TilName');
  ObjName := Mapsdb.GetFieldValueString(iname, 'ObjName');
  RofName := Mapsdb.GetFieldValueString(iname, 'RofName');
  FrmMain.LoadFile(MapName, ObjName, TilName, RofName);
end;

procedure TfrmMapsdb.ListBox1Click(Sender: TObject);
var
  i: integer;
  iname, MapName, TilName, ObjName, RofName, MapTitle: string;
begin
//
  i := ListBox1.ItemIndex;
  if (i < 0) or (i > ListBox1.Items.Count - 1) then exit;
  iname := MapsdbNameList.Strings[i];
  MapTitle := Mapsdb.GetFieldValueString(iname, 'MapTitle');
  MapName := Mapsdb.GetFieldValueString(iname, 'MapName');
  TilName := Mapsdb.GetFieldValueString(iname, 'TilName');
  ObjName := Mapsdb.GetFieldValueString(iname, 'ObjName');
  RofName := Mapsdb.GetFieldValueString(iname, 'RofName');
  MEMO1.Lines.Clear;
  MEMO1.Lines.Add('ID:' + iname);
  MEMO1.Lines.Add('MapTitle:' + MapTitle);
  MEMO1.Lines.Add('MapName:' + MapName);
  MEMO1.Lines.Add('TilName:' + TilName);
  MEMO1.Lines.Add('ObjName:' + ObjName);
  MEMO1.Lines.Add('RofName:' + RofName);
end;

procedure TfrmMapsdb.ListBox1DblClick(Sender: TObject);
begin
  Button2Click(nil);
end;

end.

