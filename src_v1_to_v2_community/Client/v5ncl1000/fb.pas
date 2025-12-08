unit fb;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,IniFiles,FMain, A2Form, Gauges, ScktComp;

type
  Tfrmfb = class(TForm)
    RadioGroup1: TRadioGroup;
    Button1: TButton;
  //  A2Form: TA2Form;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  frmfb: Tfrmfb;

implementation

uses fbl;

{$R *.dfm}


procedure Tfrmfb.Button1Click(Sender: TObject);
var
    ClientIni: TIniFile;
begin
     ClientIni := TIniFile.Create('.\ClientIni.ini');
    try
        ClientIni.WriteInteger('FBL', 'fbl',RadioGroup1.ItemIndex);
    finally
        ClientIni.Free;
    end;
   case RadioGroup1.ItemIndex of
   0:
     begin
     fwide:=800;
     fhei:=600;
     end;
   1:
     begin
     fwide:=1024;
     fhei:=768;
     end;
   end;
   FBLXZ:=True;  //选择后结束循环
   frmfb.Free;
end;


procedure Tfrmfb.FormCreate(Sender: TObject);
var
    ClientIni: TIniFile;
begin
     ClientIni := TIniFile.Create('.\ClientIni.ini');
    try
      RadioGroup1.ItemIndex:=ClientIni.readInteger('FBL', 'fbl',0);

    finally
        ClientIni.Free;
    end;

end;

procedure Tfrmfb.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
ExitProcess(0);
end;

end.
