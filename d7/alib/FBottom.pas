unit FBottom;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs;

type
    TForm2 = class(TForm)
    private
    { Private declarations }
    public
    { Public declarations }
        procedure AddChat(astr: string; fcolor, bcolor: integer);
    end;

var
    Form2: TForm2;

implementation

{$R *.dfm}

{ TForm2 }

procedure TForm2.AddChat(astr: string; fcolor, bcolor: integer);
begin
//
end;

end.

