//2016.04.18 在水一方
unit FGameToolsAssist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmGameToolsAssist = class(TForm)
    lstPreTraining: TListBox;
    lstTraining: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnAddAll: TButton;
    btnExit: TButton;
    rb1: TRadioButton;
    rb2: TRadioButton;
    rb3: TRadioButton;
    procedure rb1Click(Sender: TObject);
    procedure btnAddAllClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure lstPreTrainingDblClick(Sender: TObject);
    procedure lstTrainingDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure loadFromfile(afilenam: string);
    procedure savetofile(afilenam: string);
  end;

const
  Pre = 'GameToolsAssist_';
var
  FrmGameToolsAssist: TFrmGameToolsAssist;

implementation
uses
  FAttrib, uIniFile, CharCls;

{$R *.dfm}

procedure TFrmGameToolsAssist.loadFromfile(afilenam: string);
var
  i, j, Count: integer;
  temp: TObject;
  str, str1: string;
  ini: TiniFileclass;
begin
  if FileExists('.\user\' + afilenam + '.dat') = false then
    ini := TiniFileclass.Create('.\user\_default.dat')
  else
    ini := TiniFileclass.Create('.\user\' + afilenam + '.dat');

  try
    for j := 0 to ComponentCount - 1 do
    begin
      temp := Components[j];
      if temp is TListBox then
      begin
        //不保存的项目
        if TListBox(temp).name = 'lstPreTraining' then Continue;
        Count := ini.ReadInteger(Pre+'TListBox', TListBox(temp).Name + '.Count', TListBox(temp).Count);
        if Count > 0 then
        begin
          TListBox(temp).Clear;
          for i := 0 to Count - 1 do
          begin
            str := ini.ReadString(Pre+'TListBox', format(TListBox(temp).Name + '%d', [i]), str);
            TListBox(temp).AddItem(str,nil);
          end;
        end;
      end;
    end;
  finally
    ini.Free;
  end;
end;

procedure TFrmGameToolsAssist.savetofile(afilenam: string);
var
  str: string;
  i, j: integer;
  ini: TiniFileclass;
  temp: TObject;
begin
  if not DirectoryExists('.\user') then
    CreateDir('.\user');
  if afilenam = '' then
    Exit;
  ini := TiniFileclass.Create('.\user\' + afilenam + '.dat');
  try
    for j := 0 to ComponentCount - 1 do
    begin
      temp := Components[j];
      if temp is TListBox then
      begin
        //不保存的项目
        if TListBox(temp).name = 'lstPreTraining' then Continue;
        ini.WriteInteger(Pre+'TListBox', TListBox(temp).Name + '.Count', TListBox(temp).Count);
        for i := 0 to TListBox(temp).Count - 1 do
        begin
          ini.WriteString(Pre+'TListBox', format(TListBox(temp).Name + '%d', [i]), TListBox(temp).Items[i]);
        end;
      end;
    end;
  finally
    ini.Free;
  end;
end;

procedure TFrmGameToolsAssist.rb1Click(Sender: TObject);
var
  i: integer;
  ts: TStringList;
begin
  ts := TStringList.Create;
  case TRadioButton(Sender).Tag of
  0: ts.Text := HaveMagicClass.DefaultMagic.getAttackMagicNameList(2);
  1: ts.Text := HaveMagicClass.HaveMagic.getAttackMagicNameList(2);
  2: ts.Text := HaveMagicClass.HaveRiseMagic.getAttackMagicNameList(2);
  end;
  for i := ts.Count - 1 downto 0 do begin
    if lstTraining.Items.IndexOf(ts[i]) >= 0 then
      ts.Delete(i);
  end;
  lstPreTraining.Items.Text := ts.Text;
  ts.Free;
end;

procedure TFrmGameToolsAssist.btnAddAllClick(Sender: TObject);
begin
  lstTraining.Items.AddStrings(lstPreTraining.Items);
  lstPreTraining.Items.Clear;
end;

procedure TFrmGameToolsAssist.btnExitClick(Sender: TObject);
begin
  savetofile(CharCenterName);
end;

procedure TFrmGameToolsAssist.lstPreTrainingDblClick(Sender: TObject);
begin
  lstTraining.Items.Add(lstPreTraining.Items[lstPreTraining.ItemIndex]);
  lstPreTraining.Items.Delete(lstPreTraining.ItemIndex);
end;

procedure TFrmGameToolsAssist.lstTrainingDblClick(Sender: TObject);
begin 
  lstPreTraining.Items.Add(lstTraining.Items[lstTraining.ItemIndex]);
  lstTraining.Items.Delete(lstTraining.ItemIndex);
end;

end.
