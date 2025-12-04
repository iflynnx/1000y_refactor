unit uSetWinIni;

interface
uses
    uIniFile, Forms, A2Form, filepgkclass, A2Img, Gauges, Buttons,
    StdCtrls, ExtCtrls;
type
    TinitWindows = class
    public
        constructor Create;
        destructor Destroy; override;
        procedure LoadFromFile(aform:TForm); //从文件导出
        procedure OutputToFile(aform:TForm); //导入文件
    end;

implementation

uses SysUtils;

{ TinitWindows }

constructor TinitWindows.Create;
begin
end;

destructor TinitWindows.Destroy;
begin

    inherited;
end;

procedure TinitWindows.OutputToFile(aform:TForm);
var
    i               :integer;
    temp            :TObject;
    ini             :TiniFileclass;
begin
    ini := TiniFileclass.Create('.\' + aform.Name + '.txt');
    try
        for i := 0 to aform.ComponentCount - 1 do
        begin
            temp := aform.Components[i];
            if temp is TLabel then
            begin
                if TLabel(temp).Name <> '' then
                begin
                    ini.WriteString(TLabel(temp).Name, 'caption', TLabel(temp).Caption);
                    ini.WriteInteger(TLabel(temp).Name, 'left', TLabel(temp).Left);
                    ini.WriteInteger(TLabel(temp).Name, 'top', TLabel(temp).Top);
                    ini.WriteInteger(TLabel(temp).Name, 'width', TLabel(temp).Width);
                    ini.WriteInteger(TLabel(temp).Name, 'height', TLabel(temp).Height);
                    ini.WriteBool(TLabel(temp).Name, 'visible', TLabel(temp).Visible);
                end;
            end
            else if temp is TEdit then
            begin
                if TEdit(temp).Name <> '' then
                begin
                    //ini.WriteString(TEdit(temp).Name, 'caption', TEdit(temp).Caption);
                    ini.WriteInteger(TEdit(temp).Name, 'left', TEdit(temp).Left);
                    ini.WriteInteger(TEdit(temp).Name, 'top', TEdit(temp).Top);
                    ini.WriteInteger(TEdit(temp).Name, 'width', TEdit(temp).Width);
                    ini.WriteInteger(TEdit(temp).Name, 'height', TEdit(temp).Height);
                    ini.WriteBool(TLabel(temp).Name, 'visible', TEdit(temp).Visible);
                end;
            end
            else if temp is TSpeedButton then
            begin
                if TSpeedButton(temp).Name <> '' then
                begin
                    ini.WriteString(TSpeedButton(temp).Name, 'caption', TSpeedButton(temp).Caption);
                    ini.WriteInteger(TSpeedButton(temp).Name, 'left', TSpeedButton(temp).Left);
                    ini.WriteInteger(TSpeedButton(temp).Name, 'top', TSpeedButton(temp).Top);
                    ini.WriteInteger(TSpeedButton(temp).Name, 'width', TSpeedButton(temp).Width);
                    ini.WriteInteger(TSpeedButton(temp).Name, 'height', TSpeedButton(temp).Height);
                    ini.WriteBool(TSpeedButton(temp).Name, 'visible', TSpeedButton(temp).Visible);
                end;
            end
            else if temp is TGauge then
            begin
                if TGauge(temp).Name <> '' then
                begin
                    //ini.WriteString(TGauge(temp).Name, 'caption', TGauge(temp).Caption);
                    ini.WriteInteger(TGauge(temp).Name, 'left', TGauge(temp).Left);
                    ini.WriteInteger(TGauge(temp).Name, 'top', TGauge(temp).Top);
                    ini.WriteInteger(TGauge(temp).Name, 'width', TGauge(temp).Width);
                    ini.WriteInteger(TGauge(temp).Name, 'height', TGauge(temp).Height);
                    ini.WriteBool(TGauge(temp).Name, 'visible', TGauge(temp).Visible);
                end;
            end
            else if temp is TListBox then
            begin
                if TListBox(temp).Name <> '' then
                begin
                    //ini.WriteString(TListBox(temp).Name, 'caption', TListBox(temp).Caption);
                    ini.WriteInteger(TListBox(temp).Name, 'left', TListBox(temp).Left);
                    ini.WriteInteger(TListBox(temp).Name, 'top', TListBox(temp).Top);
                    ini.WriteInteger(TListBox(temp).Name, 'width', TListBox(temp).Width);
                    ini.WriteInteger(TListBox(temp).Name, 'height', TListBox(temp).Height);
                    ini.WriteBool(TListBox(temp).Name, 'visible', TListBox(temp).Visible);
                end;
            end
            else if temp is TImage then
            begin
                if TImage(temp).Name <> '' then
                begin
                    //ini.WriteString(TImage(temp).Name, 'caption', TImage(temp).Caption);
                    ini.WriteInteger(TImage(temp).Name, 'left', TImage(temp).Left);
                    ini.WriteInteger(TImage(temp).Name, 'top', TImage(temp).Top);
                    ini.WriteInteger(TImage(temp).Name, 'width', TImage(temp).Width);
                    ini.WriteInteger(TImage(temp).Name, 'height', TImage(temp).Height);
                    ini.WriteBool(TImage(temp).Name, 'visible', TImage(temp).Visible);
                end;
            end
            else if temp is TA2Label then
            begin
                if TA2Label(temp).Name <> '' then
                begin
                    ini.WriteString(TA2Label(temp).Name, 'caption', TA2Label(temp).Caption);
                    ini.WriteInteger(TA2Label(temp).Name, 'left', TA2Label(temp).Left);
                    ini.WriteInteger(TA2Label(temp).Name, 'top', TA2Label(temp).Top);
                    ini.WriteInteger(TA2Label(temp).Name, 'width', TA2Label(temp).Width);
                    ini.WriteInteger(TA2Label(temp).Name, 'height', TA2Label(temp).Height);
                    ini.WriteBool(TA2Label(temp).Name, 'visible', TA2Label(temp).Visible);
                end;
            end
            else if temp is TA2Button then
            begin
                if TA2Button(temp).Name <> '' then
                begin
                    ini.WriteString(TA2Button(temp).Name, 'caption', TA2Button(temp).Caption);
                    ini.WriteInteger(TA2Button(temp).Name, 'left', TA2Button(temp).Left);
                    ini.WriteInteger(TA2Button(temp).Name, 'top', TA2Button(temp).Top);
                    ini.WriteInteger(TA2Button(temp).Name, 'width', TA2Button(temp).Width);
                    ini.WriteInteger(TA2Button(temp).Name, 'height', TA2Button(temp).Height);
                    ini.WriteBool(TA2Button(temp).Name, 'visible', TA2Button(temp).Visible);
                    ini.WriteString(TA2Button(temp).Name, 'upImage', '');
                    ini.WriteString(TA2Button(temp).Name, 'downImage', '');
                    ini.WriteString(TA2Button(temp).Name, 'mouseImage', '');
                    ini.WriteString(TA2Button(temp).Name, 'enableImage', '');
                end;

            end
            else if temp is TA2ListBox then
            begin
                if TA2ListBox(temp).Name <> '' then
                begin
                    ini.WriteString(TA2ListBox(temp).Name, 'caption', TA2ListBox(temp).Caption);
                    ini.WriteInteger(TA2ListBox(temp).Name, 'left', TA2ListBox(temp).Left);
                    ini.WriteInteger(TA2ListBox(temp).Name, 'top', TA2ListBox(temp).Top);
                    ini.WriteInteger(TA2ListBox(temp).Name, 'width', TA2ListBox(temp).Width);
                    ini.WriteInteger(TA2ListBox(temp).Name, 'height', TA2ListBox(temp).Height);
                    ini.WriteBool(TA2ListBox(temp).Name, 'visible', TA2ListBox(temp).Visible);
                end;

            end
            else if temp is TA2Edit then
            begin
                if TA2Edit(temp).Name <> '' then
                begin
                    ini.WriteInteger(TA2Edit(temp).Name, 'left', TA2Edit(temp).Left);
                    ini.WriteInteger(TA2Edit(temp).Name, 'top', TA2Edit(temp).Top);
                    ini.WriteInteger(TA2Edit(temp).Name, 'width', TA2Edit(temp).Width);
                    ini.WriteInteger(TA2Edit(temp).Name, 'height', TA2Edit(temp).Height);
                    ini.WriteBool(TA2Edit(temp).Name, 'visible', TA2Edit(temp).Visible);
                end;

            end
            else if temp is TA2ComboBox then
            begin
                if TA2ComboBox(temp).Name <> '' then
                begin
                    ini.WriteInteger(TA2ComboBox(temp).Name, 'left', TA2ComboBox(temp).Left);
                    ini.WriteInteger(TA2ComboBox(temp).Name, 'top', TA2ComboBox(temp).Top);
                    ini.WriteInteger(TA2ComboBox(temp).Name, 'width', TA2ComboBox(temp).Width);
                    ini.WriteInteger(TA2ComboBox(temp).Name, 'height', TA2ComboBox(temp).Height);
                    ini.WriteBool(TA2ComboBox(temp).Name, 'visible', TA2ComboBox(temp).Visible);
                end;

            end
            else if temp is TA2ILabel then
            begin
                if TA2ILabel(temp).Name <> '' then
                begin
                    ini.WriteString(TA2ILabel(temp).Name, 'caption', TA2ILabel(temp).Caption);
                    ini.WriteInteger(TA2ILabel(temp).Name, 'left', TA2ILabel(temp).Left);
                    ini.WriteInteger(TA2ILabel(temp).Name, 'top', TA2ILabel(temp).Top);
                    ini.WriteInteger(TA2ILabel(temp).Name, 'width', TA2ILabel(temp).Width);
                    ini.WriteInteger(TA2ILabel(temp).Name, 'height', TA2ILabel(temp).Height);
                    ini.WriteBool(TA2ILabel(temp).Name, 'visible', TA2ILabel(temp).Visible);
                    ini.WriteString(TA2ILabel(temp).Name, 'Image', '');
                    ini.WriteString(TA2ILabel(temp).Name, 'ImageBack', '');
                    ini.WriteString(TA2ILabel(temp).Name, 'ImageLUP', '');
                    ini.WriteString(TA2ILabel(temp).Name, 'ImageRDown', '');
                end;

            end;
        end;
    finally
        ini.Free;
    end;

end;

procedure TinitWindows.LoadFromFile(aform:TForm);
var
    temp            :TObject;
    i               :integer;
    outing          :TA2Image;
    str             :string;
    ini             :TiniFileclass;
begin
    //当前目录找文件，有使用
    //当前没有，在PGKSYS里找文件 使用
    if FileExists('.\' + aform.Name + '.txt') = false then
    begin
        ini := TiniFileclass.Create('.\pgksys\' + aform.Name + '.txt');
    end
    else
    begin
        ini := TiniFileclass.Create('.\' + aform.Name + '.txt');
    end;

    try
        for i := 0 to aform.ComponentCount - 1 do
        begin
            temp := aform.Components[i];

            if temp is TEdit then
            begin
                if TEdit(temp).Name <> '' then
                begin
                    //ini.WriteString(TEdit(temp).Name, 'caption', TEdit(temp).Caption);
                    TEdit(temp).Left := ini.ReadInteger(TEdit(temp).Name, 'left', TEdit(temp).Left);
                    TEdit(temp).Top := ini.ReadInteger(TEdit(temp).Name, 'top', TEdit(temp).Top);
                    TEdit(temp).Width := ini.ReadInteger(TEdit(temp).Name, 'width', TEdit(temp).Width);
                    TEdit(temp).Height := ini.ReadInteger(TEdit(temp).Name, 'height', TEdit(temp).Height);
                    TEdit(temp).Visible := ini.ReadBool(TLabel(temp).Name, 'visible', TEdit(temp).Visible);
                end;
            end
            else if temp is TSpeedButton then
            begin
                if TSpeedButton(temp).Name <> '' then
                begin
                    TSpeedButton(temp).Caption := ini.ReadString(TSpeedButton(temp).Name, 'caption', TSpeedButton(temp).Caption);
                    TSpeedButton(temp).Left := ini.ReadInteger(TSpeedButton(temp).Name, 'left', TSpeedButton(temp).Left);
                    TSpeedButton(temp).Top := ini.ReadInteger(TSpeedButton(temp).Name, 'top', TSpeedButton(temp).Top);
                    TSpeedButton(temp).Width := ini.ReadInteger(TSpeedButton(temp).Name, 'width', TSpeedButton(temp).Width);
                    TSpeedButton(temp).Height := ini.ReadInteger(TSpeedButton(temp).Name, 'height', TSpeedButton(temp).Height);
                    TSpeedButton(temp).Visible := ini.ReadBool(TSpeedButton(temp).Name, 'visible', TSpeedButton(temp).Visible);
                end;
            end
            else if temp is TGauge then
            begin
                if TGauge(temp).Name <> '' then
                begin
                    //ini.WriteString(TGauge(temp).Name, 'caption', TGauge(temp).Caption);
                    TGauge(temp).Left := ini.ReadInteger(TGauge(temp).Name, 'left', TGauge(temp).Left);
                    TGauge(temp).Top := ini.ReadInteger(TGauge(temp).Name, 'top', TGauge(temp).Top);
                    TGauge(temp).Width := ini.ReadInteger(TGauge(temp).Name, 'width', TGauge(temp).Width);
                    TGauge(temp).Height := ini.ReadInteger(TGauge(temp).Name, 'height', TGauge(temp).Height);
                    TGauge(temp).Visible := ini.ReadBool(TGauge(temp).Name, 'visible', TGauge(temp).Visible);
                end;
            end
            else if temp is TListBox then
            begin
                if TListBox(temp).Name <> '' then
                begin
                    //ini.WriteString(TListBox(temp).Name, 'caption', TListBox(temp).Caption);
                    TListBox(temp).Left := ini.ReadInteger(TListBox(temp).Name, 'left', TListBox(temp).Left);
                    TListBox(temp).Top := ini.ReadInteger(TListBox(temp).Name, 'top', TListBox(temp).Top);
                    TListBox(temp).Width := ini.ReadInteger(TListBox(temp).Name, 'width', TListBox(temp).Width);
                    TListBox(temp).Height := ini.ReadInteger(TListBox(temp).Name, 'height', TListBox(temp).Height);
                    TListBox(temp).Visible := ini.ReadBool(TListBox(temp).Name, 'visible', TListBox(temp).Visible);
                end;
            end
            else if temp is TImage then
            begin
                if TImage(temp).Name <> '' then
                begin
                    //ini.WriteString(TImage(temp).Name, 'caption', TImage(temp).Caption);
                    TImage(temp).Left := ini.ReadInteger(TImage(temp).Name, 'left', TImage(temp).Left);
                    TImage(temp).Top := ini.ReadInteger(TImage(temp).Name, 'top', TImage(temp).Top);
                    TImage(temp).Width := ini.ReadInteger(TImage(temp).Name, 'width', TImage(temp).Width);
                    TImage(temp).Height := ini.ReadInteger(TImage(temp).Name, 'height', TImage(temp).Height);
                    TImage(temp).Visible := ini.ReadBool(TImage(temp).Name, 'visible', TImage(temp).Visible);
                end;
            end
            else if temp is TA2Label then
            begin
                if TA2Label(temp).Name <> '' then
                begin
                    TA2Label(temp).Caption := ini.ReadString(TA2Label(temp).Name, 'caption', TA2Label(temp).Caption);
                    TA2Label(temp).Left := ini.ReadInteger(TA2Label(temp).Name, 'left', TA2Label(temp).Left);
                    TA2Label(temp).Top := ini.ReadInteger(TA2Label(temp).Name, 'top', TA2Label(temp).Top);
                    TA2Label(temp).Width := ini.ReadInteger(TA2Label(temp).Name, 'width', TA2Label(temp).Width);
                    TA2Label(temp).Height := ini.ReadInteger(TA2Label(temp).Name, 'height', TA2Label(temp).Height);
                    TA2Label(temp).Visible := ini.ReadBool(TA2Label(temp).Name, 'visible', TA2Label(temp).Visible);
                end;
            end
            else if temp is TA2Button then
            begin
                if TA2Button(temp).Name <> '' then
                begin
                    TA2Button(temp).Caption := ini.ReadString(TA2Button(temp).Name, 'caption', TA2Button(temp).Caption);
                    TA2Button(temp).Left := ini.ReadInteger(TA2Button(temp).Name, 'left', TA2Button(temp).Left);
                    TA2Button(temp).Top := ini.ReadInteger(TA2Button(temp).Name, 'top', TA2Button(temp).Top);
                    TA2Button(temp).Width := ini.ReadInteger(TA2Button(temp).Name, 'width', TA2Button(temp).Width);
                    TA2Button(temp).Height := ini.ReadInteger(TA2Button(temp).Name, 'height', TA2Button(temp).Height);
                    TA2Button(temp).Visible := ini.ReadBool(TA2Button(temp).Name, 'visible', TA2Button(temp).Visible);
                    outing := TA2Image.Create(32, 32, 0, 0);
                    try
                        str := ini.ReadString(TA2Button(temp).Name, 'upImage', '');
                        if str <> '' then
                        begin
                            if pgkbmp.isfile(str) then
                            begin
                                pgkbmp.getBmp(str, outing);
                                TA2Button(temp).A2Up := outing;
                            end;
                        end;
                        str := ini.ReadString(TA2Button(temp).Name, 'downImage', '');
                        if str <> '' then
                        begin
                            if pgkbmp.isfile(str) then
                            begin
                                pgkbmp.getBmp(str, outing);
                                TA2Button(temp).A2Down := outing;
                            end;
                        end;
                        str := ini.ReadString(TA2Button(temp).Name, 'mouseImage', '');
                        if str <> '' then
                        begin
                            if pgkbmp.isfile(str) then
                            begin
                                pgkbmp.getBmp(str, outing);
                                TA2Button(temp).A2Mouse := outing;
                            end;
                        end;
                        str := ini.ReadString(TA2Button(temp).Name, 'enableImage', '');
                        if str <> '' then
                        begin
                            if pgkbmp.isfile(str) then
                            begin
                                pgkbmp.getBmp(str, outing);
                                TA2Button(temp).A2NotEnabled := outing;
                            end;
                        end;
                    finally
                        outing.Free;
                    end;
                end;

            end
            else if temp is TA2ListBox then
            begin
                if TA2ListBox(temp).Name <> '' then
                begin
                    TA2ListBox(temp).Caption := ini.ReadString(TA2ListBox(temp).Name, 'caption', TA2ListBox(temp).Caption);
                    TA2ListBox(temp).Left := ini.ReadInteger(TA2ListBox(temp).Name, 'left', TA2ListBox(temp).Left);
                    TA2ListBox(temp).Top := ini.ReadInteger(TA2ListBox(temp).Name, 'top', TA2ListBox(temp).Top);
                    TA2ListBox(temp).Width := ini.ReadInteger(TA2ListBox(temp).Name, 'width', TA2ListBox(temp).Width);
                    TA2ListBox(temp).Height := ini.ReadInteger(TA2ListBox(temp).Name, 'height', TA2ListBox(temp).Height);
                    TA2ListBox(temp).Visible := ini.ReadBool(TA2ListBox(temp).Name, 'visible', TA2ListBox(temp).Visible);

                end;

            end
            else if temp is TA2Edit then
            begin
                if TA2Edit(temp).Name <> '' then
                begin
                    TA2Edit(temp).Left := ini.ReadInteger(TA2Edit(temp).Name, 'left', TA2Edit(temp).Left);
                    TA2Edit(temp).Top := ini.ReadInteger(TA2Edit(temp).Name, 'top', TA2Edit(temp).Top);
                    TA2Edit(temp).Width := ini.ReadInteger(TA2Edit(temp).Name, 'width', TA2Edit(temp).Width);
                    TA2Edit(temp).Height := ini.ReadInteger(TA2Edit(temp).Name, 'height', TA2Edit(temp).Height);
                    TA2Edit(temp).Visible := ini.ReadBool(TA2Edit(temp).Name, 'visible', TA2Edit(temp).Visible);
                end;
            end
            else if temp is TA2ComboBox then
            begin
                if TA2ComboBox(temp).Name <> '' then
                begin
                    TA2ComboBox(temp).Left := ini.ReadInteger(TA2ComboBox(temp).Name, 'left', TA2ComboBox(temp).Left);
                    TA2ComboBox(temp).Top := ini.ReadInteger(TA2ComboBox(temp).Name, 'top', TA2ComboBox(temp).Top);
                    TA2ComboBox(temp).Width := ini.ReadInteger(TA2ComboBox(temp).Name, 'width', TA2ComboBox(temp).Width);
                    TA2ComboBox(temp).Height := ini.ReadInteger(TA2ComboBox(temp).Name, 'height', TA2ComboBox(temp).Height);
                    TA2ComboBox(temp).Visible := ini.ReadBool(TA2ComboBox(temp).Name, 'visible', TA2ComboBox(temp).Visible);
                end;
            end
            else if temp is TA2ILabel then
            begin
                if TA2ILabel(temp).Name <> '' then
                begin
                    TA2ILabel(temp).Caption := ini.ReadString(TA2ILabel(temp).Name, 'caption', TA2ILabel(temp).Caption);
                    TA2ILabel(temp).Left := ini.ReadInteger(TA2ILabel(temp).Name, 'left', TA2ILabel(temp).Left);
                    TA2ILabel(temp).Top := ini.ReadInteger(TA2ILabel(temp).Name, 'top', TA2ILabel(temp).Top);
                    TA2ILabel(temp).Width := ini.ReadInteger(TA2ILabel(temp).Name, 'width', TA2ILabel(temp).Width);
                    TA2ILabel(temp).Height := ini.ReadInteger(TA2ILabel(temp).Name, 'height', TA2ILabel(temp).Height);
                    TA2ILabel(temp).Visible := ini.ReadBool(TA2ILabel(temp).Name, 'visible', TA2ILabel(temp).Visible);

                    outing := TA2Image.Create(32, 32, 0, 0);
                    try
                        str := ini.ReadString(TA2Button(temp).Name, 'Image', '');
                        if str <> '' then
                        begin
                            if pgkbmp.isfile(str) then
                            begin
                                pgkbmp.getBmp(str, outing);
                                TA2ILabel(temp).A2Image := outing;
                            end;
                        end;
                        str := ini.ReadString(TA2Button(temp).Name, 'ImageRDown', '');
                        if str <> '' then
                        begin
                            if pgkbmp.isfile(str) then
                            begin
                                pgkbmp.getBmp(str, outing);
                                TA2ILabel(temp).A2ImageRDown := outing;
                            end;
                        end;
                        str := ini.ReadString(TA2Button(temp).Name, 'ImageLUP', '');
                        if str <> '' then
                        begin
                            if pgkbmp.isfile(str) then
                            begin
                                pgkbmp.getBmp(str, outing);
                                TA2ILabel(temp).A2ImageLUP := outing;
                            end;
                        end;
                        str := ini.ReadString(TA2Button(temp).Name, 'ImageBack', '');
                        if str <> '' then
                        begin
                            if pgkbmp.isfile(str) then
                            begin
                                pgkbmp.getBmp(str, outing);
                                TA2ILabel(temp).A2Imageback := outing;
                            end;
                        end;
                    finally
                        outing.Free;
                    end;
                end;
            end
            else if temp is TLabel then
            begin
                if TLabel(temp).Name <> '' then
                begin
                    TLabel(temp).Caption := ini.ReadString(TLabel(temp).Name, 'caption', TLabel(temp).Caption);
                    TLabel(temp).Left := ini.ReadInteger(TLabel(temp).Name, 'left', TLabel(temp).Left);
                    TLabel(temp).Top := ini.ReadInteger(TLabel(temp).Name, 'top', TLabel(temp).Top);
                    TLabel(temp).Width := ini.ReadInteger(TLabel(temp).Name, 'width', TLabel(temp).Width);
                    TLabel(temp).Height := ini.ReadInteger(TLabel(temp).Name, 'height', TLabel(temp).Height);
                    TLabel(temp).Visible := ini.ReadBool(TLabel(temp).Name, 'visible', TLabel(temp).Visible);
                end;
            end
        end;
    finally
        ini.Free;
    end;

end;

end.

