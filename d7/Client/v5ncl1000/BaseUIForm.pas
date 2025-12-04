unit BaseUIForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, NativeXml,
  Dialogs, A2Img, A2Form, ExtCtrls, VCLUnZip;

type
  TfrmBaseUI = class(TForm)



    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FFormName: string;
    { Private declarations }
  protected
    FTestPos: Boolean;
    FUIConfig: TNativeXml;
    FConfigFileName: string;
    FUIPath: string;
    FControlMark: string;
    FAllowCache: Boolean;
  public
    procedure SetConfigFileName; virtual; abstract;
    procedure settransparent(transparent: Boolean); virtual;
    procedure SetNewVersionTest(); virtual;
   // procedure SetNewVersionOld(); virtual;
    procedure SetTestPos(ATestPos: Boolean);
    function GetTestPos: Boolean;
    procedure SetControlPos(AControl: TControl); virtual;
    procedure SetNewVersion(); virtual;
    procedure SetA2ImgPos(AImg: TA2Image);
    procedure SetImageOveray(AImageOveray: Integer); virtual;
    property FormName: string read FFormName write FFormName;
    function GetUIStream(var memArch, memOut: TMemoryStream; FName: string): Boolean;
  end;

const //2015.11.12 在水一方 >>>>>>
  zipmode = true;
  alwayscache = true;
  zippass = 'pklXpCB9iphjwRnR';
  xmlzipfile = '.\data\D7D1D405405A3EFB.dat';
  bmpzipfile = '.\data\D7D1CE055C5A3EFB.dat';
 // xmlzipfile = '.\data\uixml.ui';
 // bmpzipfile = '.\data\uibmp.ui';

var
  frmBaseUI: TfrmBaseUI;
  UnZip: TVCLUnZip;
  xmlzipstream: TMemoryStream;
  bmpzipstream: TMemoryStream;
  uicache: TStringList;
function upzipstream(var memArch, memOut: TMemoryStream; FName: string; tocache: Boolean = false): Boolean;
                                 //2015.11.12 在水一方 <<<<<<
implementation



{$R *.dfm}

function upzipstream(var memArch, memOut: TMemoryStream; FName: string; tocache: Boolean): Boolean; //2015.11.12 在水一方
var
  i: integer;
  memAdd: TMemoryStream;
begin
  Result := False;
  try
    if tocache or alwayscache then begin
      i := uicache.IndexOf(FName);
      if i >= 0 then begin
        if alwayscache then
          memOut := TMemoryStream(uicache.Objects[i])
        else
          memOut.CopyFrom(TMemoryStream(uicache.Objects[i]), 0);
        memOut.Position := 0;
        Result := True;
        Exit;
      end;
    end;
    if not alwayscache then
      with UnZip do
      begin
        memArch.Position := 0;
        ArchiveStream := memArch;
        if zippass <> '' then
          Password := zippass;
        try
          UnZipToStream(memOut, Fname);
          if tocache or alwayscache then begin
            memAdd := TMemoryStream.Create;
            memAdd.CopyFrom(memOut, 0);
            uicache.AddObject(FName, memAdd);
          end;
          Result := True;
        except
          memOut.Clear;
        end;
        memOut.Position := 0;
      end;
  except
  end;
end;

procedure upzipstreamall(var memArch: TMemoryStream); //2015.11.13 在水一方
var
  i: integer;
  FName: string;
  memAdd: TMemoryStream;
begin
  try
    with UnZip do
    begin
      memArch.Position := 0;
      ArchiveStream := memArch;
      if zippass <> '' then
        Password := zippass;
      ReadZip;
      try
        for i := 0 to Count - 1 do begin
          memAdd := TMemoryStream.Create;
          UnZipToStreamByIndex(memAdd, i);
          FName := Filename[i];
          uicache.AddObject(FName, memAdd);
        end;
        uicache.Sort;
      except
        memAdd.Clear;
      end;
    end;
  except
  end;
end;

function getbmpres(var memOut: TMemoryStream; FName: string): Boolean; //2015.11.18 在水一方
begin
  Result := upzipstream(bmpzipstream, memOut, FName, alwayscache);
end;

{ TfrmBaseUI }


{ TfrmBaseUI }


function TfrmBaseUI.GetUIStream(var memArch, memOut: TMemoryStream; FName: string): Boolean;
begin
  Result := upzipstream(memArch, memOut, FName, FAllowCache);
end;

function TfrmBaseUI.GetTestPos: Boolean;
begin
  Result := FTestPos;
end;

procedure TfrmBaseUI.SetA2ImgPos(AImg: TA2Image);
var
  node: TXmlNode;
  width, height, left, top: Integer;
  visible: Boolean;
  A2Down, A2Mouse, A2NotEnabled, A2Up: string;
  temping, temping2: TA2Image;
  path: string;
  A2Image: string;
  imgwidth, imgheight: Integer;
  controlName: string;
  tmpStream: TMemoryStream;
begin
  path := '.\ui\img\';
  if FTestPos then
  begin

    try

      controlName := AImg.Name;
      node := FUIConfig.Root.NodeByName('Views').FindNode(controlName + FControlMark);
      if (node = nil) then
      begin
        node := FUIConfig.Root.NodeByName('Views').FindNode(controlName);
        if (node = nil) then
          Exit;
      end;


      A2Image := node.ReadWidestring('A2Image', '');
      if (A2Image <> '') then
      begin
        if not zipmode then //2015.11.12 在水一方 >>>>>>
          AImg.LoadFromFile(path + A2Image)
        else begin
          if not alwayscache then
            tmpStream := TMemoryStream.Create;
          try
            if GetUIStream(bmpzipstream, tmpStream, A2Image) then
            begin
              try
                AImg.LoadFromStream(tmpStream);
              except
                ShowMessage('客户端缺少图片' + A2Image);
              end;
            end;
          finally
            if not alwayscache then
              tmpStream.Free;
          end;
        end; //2015.11.12 在水一方 <<<<<<
      //  AImg.SaveToFile('test.bmp');
      end;

    except
    end;
  end;
end;

procedure TfrmBaseUI.SetControlPos(AControl: TControl);
var
  node: TXmlNode;
  width, height, left, top: Integer;
  visible: Boolean;
  A2Down, A2Mouse, A2NotEnabled, A2Up: string;
  SelectImage, SelectNotImage, EnabledImage: string;
  temping, temping2: TA2Image;
  path: string;
  A2Image, A2Imageback: string;
  imgwidth, imgheight: Integer;
  transparent: Boolean;
  imageOveray: Integer;
  hint: string;
  usedefault, defaultpos: Boolean;
  _color: Integer;
  pic: TPicture;
  txt: string;
  ItemHeight: integer;
  ItemMerginX, ItemMerginY: integer;
  FFontSelBACKColor: Tcolor;
  changeline: boolean;
  FHeightSpac, FLineEndSpac: integer;
  controlName: string;
  fontColor: TColor;
  tmpbo: Boolean;
  tmpCount: Integer;
  uipath: string;
  tmpStream: TMemoryStream;
begin
  path := '.\ui\img\';
  if FTestPos then
  begin
    if not alwayscache then
      tmpStream := TMemoryStream.Create;
    try
      try
        defaultpos := False;
        controlName := AControl.Name;
        if FFormName <> '' then
          controlName := FFormName;

        node := FUIConfig.Root.NodeByName('Views').FindNode(controlName + FControlMark);
        if (node = nil) then
        begin
          node := FUIConfig.Root.NodeByName('Views').FindNode(controlName);
          if (node = nil) then
            Exit;
        end;

        width := node.ReadInteger('width', -1);
        height := node.ReadInteger('height', -1);
        imgwidth := node.ReadInteger('imgwidth', -1);
        if imgwidth = -1 then
          imgwidth := 32;

        imgheight := node.ReadInteger('imgheight', -1);
        if imgheight = -1 then
          imgheight := 32;
        left := node.ReadInteger('left', -1);
        top := node.ReadInteger('top', -1);
        visible := node.ReadBool('visible', True);
        if not (AControl is TForm) then
          AControl.Visible := visible;

        if visible then
        begin
          if AControl is TForm then
          begin
            transparent := node.ReadBool('transparent', False);
            imageOveray := node.ReadInteger('ImageOveray', -1);
            SetImageOveray(imageOveray);
            settransparent(transparent);
          end;

          if AControl is TA2Button then
          begin
            try

              usedefault := node.ReadBool('usedefault', False);

              temping := TA2Image.Create(imgwidth, imgheight, 0, 0);
              A2Down := node.ReadWidestring('A2Down', '');
              hint := node.ReadWidestring('hint', '');
              if (hint <> '') then
                TA2Button(AControl).Hint := hint;
              if (A2Down <> '') then
              begin
                if not zipmode then begin
                  if usedefault then
                  begin
                    TA2Button(AControl).DownImage.LoadFromFile(path + A2Down)
                  end else
                  begin
                    temping.LoadFromFile(path + A2Down);
                    TA2Button(AControl).A2Down := temping;
                  end;
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Down) then
                    if usedefault then
                    begin
                      TA2Button(AControl).DownImage.Bitmap;
                      TA2Button(AControl).DownImage.Graphic.LoadFromStream(tmpStream);
                    end else
                    begin
                      temping.LoadFromStream(tmpStream);
                      TA2Button(AControl).A2Down := temping;
                    end;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              A2Mouse := node.ReadWidestring('A2Mouse', '');
              if (A2Mouse <> '') then
              begin
                if not zipmode then begin
                  if usedefault then
                  begin
                    TA2Button(AControl).ImageMouse.LoadFromFile(path + A2Mouse);
                  end else
                  begin
                    temping.LoadFromFile(path + A2Mouse);
                    TA2Button(AControl).A2Mouse := temping;
                  end;
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Mouse) then
                    if usedefault then
                    begin
                      TA2Button(AControl).ImageMouse.Bitmap;
                      TA2Button(AControl).ImageMouse.Graphic.LoadFromStream(tmpStream);
                    end else
                    begin
                      temping.LoadFromStream(tmpStream);
                      TA2Button(AControl).A2Mouse := temping;
                    end;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              A2Up := node.ReadWidestring('A2Up', '');
              if (A2Up <> '') then
              begin
                if not zipmode then begin
                  if FileExists(path + A2Up) then
                  begin
                    if usedefault then
                    begin
                      TA2Button(AControl).UpImage.LoadFromFile(path + A2Up);
                    end else
                    begin
                      temping.LoadFromFile(path + A2Up);
                      TA2Button(AControl).A2Up := temping;
                    end;
                  end;
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Up) then
                    if usedefault then
                    begin
                      TA2Button(AControl).UpImage.Bitmap;
                      TA2Button(AControl).UpImage.Graphic.LoadFromStream(tmpStream);
                    end else
                    begin
                      temping.LoadFromStream(tmpStream);
                      TA2Button(AControl).A2Up := temping;
                    end;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              A2NotEnabled := node.ReadWidestring('A2NotEnabled', '');
              if (A2NotEnabled <> '') then
              begin
                if not zipmode then begin
                  if usedefault then
                  begin
                    TA2Button(AControl).ImageNotEnabled.LoadFromFile(path + A2NotEnabled);
                  end
                  else
                  begin
                    temping.LoadFromFile(path + A2NotEnabled);
                    TA2Button(AControl).A2NotEnabled := temping;
                  end;
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2NotEnabled) then
                    if usedefault then
                    begin
                      TA2Button(AControl).ImageNotEnabled.Bitmap;
                      TA2Button(AControl).ImageNotEnabled.Graphic.LoadFromStream(tmpStream);
                    end else
                    begin
                      temping.LoadFromStream(tmpStream);
                      TA2Button(AControl).A2NotEnabled := temping;
                    end;
                  if not alwayscache then tmpStream.Clear;
                end;
              end else
              begin
                TA2Button(AControl).A2NotEnabled := nil;
              end;
            finally
              temping.Free;

            end;
          end;

          if AControl is TA2CheckBox then
          begin
            try
              temping := TA2Image.Create(imgwidth, imgheight, 0, 0);
              SelectImage := node.ReadWidestring('SelectImage', '');

              if (SelectImage <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + SelectImage);
                  TA2CheckBox(AControl).SelectImage := temping;
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, SelectImage) then
                    temping.LoadFromStream(tmpStream);
                  TA2CheckBox(AControl).SelectImage := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              SelectNotImage := node.ReadWidestring('SelectNotImage', '');
              if (SelectNotImage <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + SelectNotImage);
                  TA2CheckBox(AControl).SelectNotImage := temping;
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, SelectNotImage) then
                    temping.LoadFromStream(tmpStream);
                  TA2CheckBox(AControl).SelectNotImage := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              EnabledImage := node.ReadWidestring('EnabledImage', '');
              if (EnabledImage <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + EnabledImage);
                  TA2CheckBox(AControl).EnabledImage := temping;
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, EnabledImage) then
                    temping.LoadFromStream(tmpStream);
                  TA2CheckBox(AControl).EnabledImage := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;

            finally
              temping.Free;
            end;
          end;
          if AControl is TImage then
          begin
            A2Image := node.ReadWidestring('A2Image', '');
            if (A2Image <> '') then
            begin
              try
                if not zipmode then begin
                  TImage(AControl).Picture.LoadFromFile(path + A2Image); // := temping;
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Image) then
                    TImage(AControl).Picture.Bitmap;
                  TImage(AControl).Picture.Graphic.LoadFromStream(tmpStream);
                  if not alwayscache then tmpStream.Clear;
                end;
              finally
              end;
            end;

          end;
          if AControl is TA2ILabel then
          begin
            A2Image := node.ReadWidestring('A2Image', '');
            usedefault := node.ReadBool('usedefault', False);
            transparent := node.ReadBool('transparent', False);
            TA2ILabel(AControl).Transparent := transparent;
            if (A2Image <> '') or usedefault then
            begin
              temping := TA2Image.Create(imgwidth, imgheight, 0, 0);
              try
                if not zipmode then begin
                  if not usedefault then
                    temping.LoadFromFile(path + A2Image);
                  TA2ILabel(AControl).A2Image := temping;
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Image) then
                    temping.LoadFromStream(tmpStream);
                  TA2ILabel(AControl).A2Image := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              finally
                temping.Free;

              end;
            end;

          end;
          if AControl is TA2Label then
          begin
            A2Image := node.ReadWidestring('text', '');
            if A2Image <> '' then
              TA2Label(AControl).Caption := A2Image;
            fontColor := node.ReadColor('FontColor', 0);
            if fontColor <> 0 then

              TA2Label(AControl).FontColor := ColorSysToDxColor(fontColor);
          end;

          if AControl is TA2ComboBox then
          begin
            A2Image := node.ReadWidestring('A2Image', '');
            if (A2Image <> '') then
            begin
              if not zipmode then begin
                try
                  TA2ComboBox(AControl).Picture.LoadFromFile(path + A2Image);
                except
                  ShowMessage('TA2ComboBox加载图片失败:' + path + A2Image);
                end;
              end
              else begin
                if GetUIStream(bmpzipstream, tmpStream, A2Image) then
                  TA2ComboBox(AControl).Picture.Bitmap;
                TA2ComboBox(AControl).Picture.Graphic.LoadFromStream(tmpStream);
                if not alwayscache then tmpStream.Clear;
              end;
            end;

          end;


          if AControl is TA2ListBox then
          begin
            try

              temping := TA2Image.Create(32, 32, 0, 0);
              temping2 := TA2Image.Create(32, 32, 0, 0);
              A2Up := node.ReadWidestring('BackImage', '');
              tmpbo := node.ReadBool('ScrollTrack', False);
              tmpCount := node.ReadInteger('NoHotDrawItemsCount', 0);
              uipath := node.ReadWidestring('UiImgPath', '.\ui\img\');
              TA2ListBox(AControl).UiImgPath := uipath;
              TA2ListBox(AControl).ScrollTrack := tmpbo;
             // TA2ListBox(AControl).NoHotDrawItemsCount:=tmpCount;
              if A2Up <> '' then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Up);
                  TA2ListBox(AControl).SetScrollBackImage(temping);
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Up) then
                    temping.LoadFromStream(tmpStream);
                  TA2ListBox(AControl).SetScrollBackImage(temping);
                  if not alwayscache then tmpStream.Clear;
                end;
              end;

              A2Down := node.ReadWidestring('TopImageA2Down', '');
              A2Up := node.ReadWidestring('TopImageA2Up', '');
              if (A2Down <> '') and (A2Up <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Up);
                  temping2.LoadFromFile(path + A2Down);
                  TA2ListBox(AControl).SetScrollTopImage(temping, temping2);
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Up) then
                    temping.LoadFromStream(tmpStream);
                  if not alwayscache then tmpStream.Clear;
                  if GetUIStream(bmpzipstream, tmpStream, A2Down) then
                    temping2.LoadFromStream(tmpStream);
                  if not alwayscache then tmpStream.Clear;
                  TA2ListBox(AControl).SetScrollTopImage(temping, temping2);
                end;
              end;

              A2Down := node.ReadWidestring('TrackImageA2Down', '');
              A2Up := node.ReadWidestring('TrackImageA2Up', '');
              if (A2Down <> '') and (A2Up <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Up);
                  temping2.LoadFromFile(path + A2Down);
                  TA2ListBox(AControl).SetScrollTrackImage(temping, temping2);
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Up) then
                    temping.LoadFromStream(tmpStream);
                  if not alwayscache then tmpStream.Clear;
                  if GetUIStream(bmpzipstream, tmpStream, A2Down) then
                    temping2.LoadFromStream(tmpStream);
                  if not alwayscache then tmpStream.Clear;
                  TA2ListBox(AControl).SetScrollTrackImage(temping, temping2);
                end;
              end;

              A2Down := node.ReadWidestring('BottomImageA2Down', '');
              A2Up := node.ReadWidestring('BottomImageA2Up', '');
              if (A2Down <> '') and (A2Up <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Up);
                  temping2.LoadFromFile(path + A2Down);
                  TA2ListBox(AControl).SetScrollBottomImage(temping, temping2);
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Up) then
                    temping.LoadFromStream(tmpStream);
                  if not alwayscache then tmpStream.Clear;
                  if GetUIStream(bmpzipstream, tmpStream, A2Down) then
                    temping2.LoadFromStream(tmpStream);
                  if not alwayscache then tmpStream.Clear;
                  TA2ListBox(AControl).SetScrollBottomImage(temping, temping2);
                end;
              end;

              A2Up := node.ReadWidestring('ListBackImage', '');
              if (A2Up <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Up);
                  TA2ListBox(AControl).SetBackImage(temping);
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Up) then
                    temping.LoadFromStream(tmpStream);
                  TA2ListBox(AControl).SetBackImage(temping);
                  if not alwayscache then tmpStream.Clear;
                end;
              end;

              A2Up := node.ReadWidestring('SelectedItemBack', '');
              if (A2Up <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Up);
                  TA2ListBox(AControl).setSelectedItemBack(temping);
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Up) then
                    temping.LoadFromStream(tmpStream);
                  TA2ListBox(AControl).setSelectedItemBack(temping);
                  if not alwayscache then tmpStream.Clear;
                end;
              end;

              A2Up := node.ReadWidestring('DefaultItemBack', '');
              if (A2Up <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Up);
                  TA2ListBox(AControl).setDefaultItemBack(temping);
                end
                else begin
                  if GetUIStream(bmpzipstream, tmpStream, A2Up) then
                    temping.LoadFromStream(tmpStream);
                  TA2ListBox(AControl).setDefaultItemBack(temping);
                  if not alwayscache then tmpStream.Clear;
                end;
              end;

              ItemHeight := node.ReadInteger('ItemHeight', -1);
              if ItemHeight <> -1 then
                TA2ListBox(AControl).ItemHeight := ItemHeight;
              ItemMerginX := node.ReadInteger('ItemMerginX', -1);
              if ItemMerginX <> -1 then
                TA2ListBox(AControl).ItemMerginX := ItemMerginX;
              ItemMerginY := node.ReadInteger('ItemMerginY', -1);
              if ItemMerginY <> -1 then
                TA2ListBox(AControl).ItemMerginY := ItemMerginY;

              ItemMerginX := node.ReadInteger('ItemFontMerginX', -1);
              if ItemMerginX <> -1 then
                TA2ListBox(AControl).ItemFontMerginX := ItemMerginX;
              ItemMerginY := node.ReadInteger('ItemFontMerginY', -1);
              if ItemMerginY <> -1 then
                TA2ListBox(AControl).ItemFontMerginY := ItemMerginY;


              fontColor := node.ReadColor('FontColor', 0);
              if fontColor <> 0 then
                TA2ListBox(AControl).FontColor := ColorSysToDxColor(fontColor);
              fontColor := node.ReadColor('FontSelColor', -1);
              if fontColor <> -1 then
                TA2ListBox(AControl).FontSelColor := ColorSysToDxColor(fontColor);

              fontColor := node.ReadColor('FontMovColor', -1);
              if fontColor <> -1 then
                TA2ListBox(AControl).FontMovColor := ColorSysToDxColor(fontColor);

              FFontSelBACKColor := node.ReadColor('FFontSelBACKColor', 0);
              if FFontSelBACKColor <> 0 then
                TA2ListBox(AControl).FFontSelBACKColor := ColorSysToDxColor(FFontSelBACKColor);

            finally
              temping.Free;
              temping2.Free;
            end;



          end;
          if width <> -1 then
          begin
            AControl.Width := width;
          end;
          if height <> -1 then
          begin
            AControl.Height := height;
          end;
          if left <> -1 then
          begin
            AControl.Left := left;
          end;
          if top <> -1 then
          begin
            AControl.Top := top;
          end;
        end;

      except
        on e: Exception do
        begin
          ShowMessage(e.Message);
        end;
      end;
    finally
      if not alwayscache then
        tmpStream.Free;
    end;

  end else
  begin
    AControl.Visible := True;
  end;
end;


procedure TfrmBaseUI.SetNewVersion;
begin
  if FTestPos then
    SetNewVersionTest;
  //else
  //  SetNewVersionOld;
end;

procedure TfrmBaseUI.SetNewVersionTest;
var
  tmpStream: TMemoryStream;
begin
  if FTestPos then
  begin
    FUIConfig.Free;
    FUIConfig := TNativeXml.Create;
    FUIConfig.Utf8Encoded := True;
    if not zipmode then //2015.11.12 在水一方 >>>>>>
      FUIConfig.LoadFromFile('.\ui\' + FConfigFileName)
    else begin
      if not alwayscache then
        tmpStream := TMemoryStream.Create;
      try
        if GetUIStream(xmlzipstream, tmpStream, FConfigFileName) then
          FUIConfig.LoadFromStream(tmpStream);
      finally
        if not alwayscache then
          tmpStream.Free;
      end;
    end; //2015.11.12 在水一方 <<<<<<
  end;
end;

procedure TfrmBaseUI.SetTestPos(ATestPos: Boolean);
begin
  FTestPos := ATestPos;
end;

procedure TfrmBaseUI.FormCreate(Sender: TObject);
var
  tmpStream: TMemoryStream;
begin
  FUIPath := '.\ui\img\';
  SetConfigFileName;
  FTestPos := False;
  FUIConfig := TNativeXml.Create;
  FUIConfig.Utf8Encoded := True;
  if not zipmode then //2015.11.12 在水一方 >>>>>>
    FUIConfig.LoadFromFile('.\ui\' + FConfigFileName)
  else begin
    if not alwayscache then
      tmpStream := TMemoryStream.Create;
    try
      if GetUIStream(xmlzipstream, tmpStream, FConfigFileName) then
        FUIConfig.LoadFromStream(tmpStream);
    finally
      if not alwayscache then
        tmpStream.Free;
    end;
  end; //2015.11.12 在水一方 <<<<<<
  FControlMark := '';
 // FrmM.AddA2Form(Self, A2Form);
end;

//procedure TfrmBaseUI.SetNewVersionOld;
//begin
//
//end;

procedure TfrmBaseUI.settransparent(transparent: Boolean);
begin

end;

procedure TfrmBaseUI.FormDestroy(Sender: TObject);
begin
  FUIConfig.free;
end;

procedure TfrmBaseUI.SetImageOveray(AImageOveray: Integer);
begin

end;

initialization //2015.11.12 在水一方 >>>>>>
  begin
    UnZip := TVCLUnZip.Create(nil);
    uicache := TStringList.Create;
    if FileExists(xmlzipfile) then begin
      xmlzipstream := TMemoryStream.Create;
      xmlzipstream.LoadFromFile(xmlzipfile);
      if alwayscache then
        upzipstreamall(xmlzipstream);
    end;
    if FileExists(bmpzipfile) then begin
      bmpzipstream := TMemoryStream.Create;
      bmpzipstream.LoadFromFile(bmpzipfile);
      if alwayscache then
        upzipstreamall(bmpzipstream);
    end;
    getres := getbmpres; //2015.11.18 在水一方
  end;

finalization
  begin
    UnZip.Free;
    uicache.Free;
    if xmlzipstream <> nil then xmlzipstream.Free;
    if bmpzipstream <> nil then bmpzipstream.Free;
  end; //2015.11.12 在水一方 <<<<<<

end.

