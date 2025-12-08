unit Fpgk;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, FfilePgk, StdCtrls, ExtCtrls, shellapi, ComCtrls;

type
    TForm1 = class(TForm)
        PageControl1:TPageControl;
        TabSheet1:TTabSheet;
        TabSheet2:TTabSheet;
        Label1:TLabel;
        Label2:TLabel;
        Image1:TImage;
        ListBox1:TListBox;
        Edit1:TEdit;
        PanelpGK:TPanel;
        ButtonADD:TButton;
        ButtonSAVE:TButton;
        ButtonCLOSE:TButton;
        ButtonDEL:TButton;
        PanelCREATE:TPanel;
        ButtonLOAD:TButton;
        OpenDialog1:TOpenDialog;
        ListBoxPGK:TListBox;
        ListBoxPPP:TListBox;
        ButtonPPP:TButton;
        Memoppp:TMemo;
        Panel1:TPanel;
        ButtonPgkUnite:TButton;
        ButtonPgkUniteclose:TButton;
        ButtonPgkUniteCREATE:TButton;
        MemoPgkUnite:TMemo;
        MemoPGK:TMemo;
        ButtonPGK:TButton;
        ListBoxUnite:TListBox;
        TabSheet3:TTabSheet;
        Button1:TButton;
        Button2:TButton;
        ListBox2:TListBox;
        CheckBox_hebing:TCheckBox;
    Button3: TButton;
        procedure ButtonCLOSEClick(Sender:TObject);
        procedure ButtonLOADClick(Sender:TObject);
        procedure FormDestroy(Sender:TObject);
        procedure FormCreate(Sender:TObject);
        procedure ButtonADDClick(Sender:TObject);
        procedure ButtonDELClick(Sender:TObject);
        procedure ButtonSAVEClick(Sender:TObject);
        procedure ListBox1Click(Sender:TObject);
        procedure ButtonPGKClick(Sender:TObject);
        procedure ButtonPgkUniteCREATEClick(Sender:TObject);
        procedure ButtonPPPClick(Sender:TObject);
        procedure ButtonPgkUniteClick(Sender:TObject);
        procedure ButtonPgkUnitecloseClick(Sender:TObject);
        procedure Button1Click(Sender:TObject);
        procedure Button2Click(Sender:TObject);
    procedure Button3Click(Sender: TObject);
    private
        { Private declarations }
        procedure WMDropFiles(var mess:TMessage); message WM_DROPFILES;
    public
        { Public declarations }
        filepgk:Tfilepgk;
        pgkfile:Tfilepgk;
        pppfile:Tfilepgk;
        PgkUnite:TPgkUnite;

        procedure fenObj(s:string);
        procedure fenTile(s:string);
    end;

var
    Form1           :TForm1;

implementation

{$R *.dfm}
//uses ObjCls, tilecls;

procedure Tform1.WMDropFiles(var mess:TMessage);
var
    buffer          :array[0..255] of Char;
    dropfilescount  :integer;
    i               :integer;
    p               :pchar;
    s               :string;
begin

    inherited;

    begin
        getmem(p, 65535);
        try

            dropfilescount := DragQueryFile(Mess.wParam, $FFFFFFFF, nil, 0);
            for i := 0 to dropfilescount - 1 do
            begin

                DragQueryFile(Mess.wParam, I, P, 255);
                //在此处处理字符串P即可
                if PageControl1.ActivePage.Caption = '分解文件' then
                begin
                    s := ExtractFileExt(strpas(p));

                    if UpperCase(s) = UpperCase('.obj') then
                    begin
                        fenObj(strpas(p));
                    end
                    else if UpperCase(s) = UpperCase('.til') then
                    begin
                        fenTile(strpas(p));

                    end;
                end
                else
                begin

                    if PanelpGK.Visible = true then
                    begin
                        if FileExists(strpas(p)) = FALSE then Continue;
                        if CheckBox_hebing.Checked then
                            filepgk.add_append(strpas(p))
                        else
                            filepgk.add(strpas(p));

                    end;
                end;
            end;
        finally
            FreeMem(p);
        end;
    end;
    DragFinish(mess.wParam);
    if filepgk <> nil then
        if PageControl1.ActivePage.Caption = '分解文件' then
        else
            if PanelpGK.Visible = true then
            ListBox1.Items.Text := filepgk.GETmemu;
end;

procedure TForm1.ButtonCLOSEClick(Sender:TObject);
begin
    PanelCREATE.Visible := TRUE;
    PanelpGK.Visible := not PanelCREATE.Visible;
    Edit1.Text := '';
    ListBox1.Items.Text := '';
    filepgk.Free;
    filepgk := nil;
end;

procedure TForm1.ButtonLOADClick(Sender:TObject);
begin
    if OpenDialog1.Execute then
    begin
        edit1.Text := OpenDialog1.FileName;
        if CheckBox_hebing.Checked then
            filepgk := tfilepgk.Create(OpenDialog1.FileName, true, false)
        else
            filepgk := tfilepgk.Create(OpenDialog1.FileName, true, true);

        ListBox1.Items.Text := filepgk.GETmemu;
        PanelCREATE.Visible := FALSE;
        PanelpGK.Visible := not PanelCREATE.Visible;

    end;
end;

procedure TForm1.FormDestroy(Sender:TObject);
begin
    if filepgk <> nil then filepgk.Free;
    DragAcceptFiles(handle, False); //是窗体的句柄

end;

procedure TForm1.FormCreate(Sender:TObject);
begin
    pgkfile := nil;
    pppfile := nil;
    PgkUnite := nil;
    filepgk := nil;
    Memoppp.Clear;
    MemoPGK.Clear;
    MemoPgkUnite.Clear;
    DragAcceptFiles(handle, true); //是窗体的句柄

end;

procedure TForm1.ButtonADDClick(Sender:TObject);
begin
    if OpenDialog1.Execute then
    begin

        filepgk.add(OpenDialog1.FileName);
        ListBox1.Items.Text := filepgk.GETmemu;
    end;
end;

procedure TForm1.ButtonDELClick(Sender:TObject);
var
    S               :string;
    I               :INTEGER;
begin
    I := ListBox1.ItemIndex;
    if (I < 0) or (I >= ListBox1.Count) then EXIT;
    S := ListBox1.Items.Strings[I];
    filepgk.del(S);
    ListBox1.Items.Text := filepgk.GETmemu;
end;

procedure TForm1.ButtonSAVEClick(Sender:TObject);
begin
    filepgk.saveToFile;            //(edit1.Text);
end;

procedure TForm1.ListBox1Click(Sender:TObject);
var
    S               :string;
    I               :INTEGER;
    aStream         :TMemoryStream;
begin
    I := ListBox1.ItemIndex;
    if (I < 0) or (I >= ListBox1.Count) then EXIT;
    S := ListBox1.Items.Strings[I];
    if (pos(UpperCase('.bmp'), UpperCase(s)) > 0) then
    begin

        if filepgk.fboWrite then
        begin
            aStream := TMemoryStream.Create;
            try
                filepgk.get(s, aStream);

                aStream.Position := 0;
                Image1.Picture.Bitmap.LoadFromStream(aStream);
            finally
                aStream.Free;
            end;
        end
        else
            Image1.Picture.LoadFromFile('.\pgkTEMP\' + S);
    end;
end;

procedure TForm1.ButtonPGKClick(Sender:TObject);
begin
    if OpenDialog1.Execute then
    begin
        MemoPGK.Text := OpenDialog1.FileName;
        pgkfile := Tfilepgk.Create(OpenDialog1.FileName, true);
        ListBoxPGK.Items.Text := pgkfile.GETmemu;
        ButtonPGK.Enabled := false;
        ButtonPPP.Enabled := TRUE;
        ButtonPgkUniteCREATE.Enabled := FALSE;
        ButtonPgkUniteclose.Enabled := TRUE;
        ButtonPgkUnite.Enabled := false;
    end;
end;

procedure TForm1.ButtonPgkUniteCREATEClick(Sender:TObject);
begin
    if OpenDialog1.Execute then
    begin
        MemoPgkUnite.Text := OpenDialog1.FileName;
        PgkUnite := TPgkUnite.Create(OpenDialog1.FileName);
        ListBoxUnite.Items.Text := PgkUnite.GETmemu;
        ButtonPGK.Enabled := TRUE;
        ButtonPPP.Enabled := TRUE;
        ButtonPgkUniteCREATE.Enabled := FALSE;
        ButtonPgkUniteclose.Enabled := TRUE;
        ButtonPgkUnite.Enabled := false;
    end;
end;

procedure TForm1.ButtonPPPClick(Sender:TObject);
begin
    if OpenDialog1.Execute then
    begin
        Memoppp.Text := OpenDialog1.FileName;
        PPPfile := Tfilepgk.Create(OpenDialog1.FileName, true);
        ListBoxPPP.Items.Text := PPPfile.GETmemu;
        ButtonPGK.Enabled := false;
        ButtonPPP.Enabled := FALSE;
        ButtonPgkUniteCREATE.Enabled := FALSE;
        ButtonPgkUniteclose.Enabled := TRUE;
        ButtonPgkUnite.Enabled := TRUE;
    end;
end;

procedure TForm1.ButtonPgkUniteClick(Sender:TObject);
begin
    if pgkfile = nil then EXIT;
    if pppfile = nil then EXIT;
    if PgkUnite = nil then EXIT;
    PgkUnite.setPGK(pgkfile);
    PgkUnite.setppp(pppfile);
    PgkUnite.Unite;
    ListBoxUnite.Items.Text := PgkUnite.GETmemu;
end;

procedure TForm1.ButtonPgkUnitecloseClick(Sender:TObject);
begin
    PgkUnite.Free;
    PgkUnite := nil;
    if pgkfile <> nil then
        pgkfile.Free;
    pgkfile := nil;
    if pppfile <> nil then
        pppfile.Free;
    pppfile := nil;
    Memoppp.Clear;
    MemoPGK.Clear;
    MemoPgkUnite.Clear;
    ListBoxPGK.Clear;
    ListBoxPPP.Clear;
    ListBoxUnite.Clear;
    ButtonPGK.Enabled := false;
    ButtonPPP.Enabled := FALSE;
    ButtonPgkUniteCREATE.Enabled := TRUE;
    ButtonPgkUniteclose.Enabled := FALSE;
    ButtonPgkUnite.Enabled := FALSE;
end;

procedure TForm1.Button1Click(Sender:TObject);
var
    S               :string;
begin
    if OpenDialog1.Execute = false then exit;
    s := OpenDialog1.FileName;
    fenObj(s);

end;

procedure TForm1.fenObj(s:string);
//var
  //  ob              :TObjectDataList;
begin
    {  ob := TObjectDataList.Create;
      try
          ob.LoadFromFile(s);
          ob.FStream.LoadFromFile(s);
          ob.SaveToFile(s);
          ListBox2.Items.Add('分解了' + s);
      finally
          ob.Free;
      end;
    }
end;

procedure TForm1.fenTile(s:string);
//var
//    ob              :TTileDataList;
begin
    {  ob := TTileDataList.Create;
      try
          ob.LoadFromFile(s);
          ob.FStream.LoadFromFile(s);
          ob.SaveToFile(s);
          ListBox2.Items.Add('分解了' + s);
      finally
          ob.Free;
      end;
     }
end;

procedure TForm1.Button2Click(Sender:TObject);
var
    S               :string;
begin
    if OpenDialog1.Execute = false then exit;
    s := OpenDialog1.FileName;
    fenTile(s);

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   image1.Picture.SaveToFile('F:\KC完整代码\debug\bmp\'+ListBox1.Items[ListBox1.ItemIndex]);
end;

end.

