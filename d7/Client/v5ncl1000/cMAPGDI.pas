unit cMAPGDI;
//自动 画 地图索引图
interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, GDIPOBJ, GDIPAPI, GDIPUTIL;
procedure ToDrawZoomStream(hdc: HDC; Stream1: tStream; fw, fh: UINT);

implementation

procedure ToDrawZoomStream(hdc: HDC; Stream1: tStream; fw, fh: UINT);
var
    gpCanvas: TGPGraphics;
    gpBitmap: TGPImage;
    gpThumbnail: TGPImage;
    t: TStreamAdapter;
    pb: pbyte;
   //  tPos            :Largeint;
begin

    Stream1.Position := 0;
    t := TStreamAdapter.Create(Stream1);
    try

        gpCanvas := TGPGraphics.Create(hdc);
        gpBitmap := TGPBitmap.Create(t);
       // gpBitmap.FromStream(t);
        gpCanvas.SetInterpolationMode(InterpolationModeHighQuality);            //设置分辨率
        gpThumbnail := gpBitmap.GetThumbnailImage(fw, fh, nil, nil);            //64*64大小的缩略图
        try
            gpCanvas.DrawImage(gpThumbnail, 0, 0, fw, fh);
        finally
            gpThumbnail.free;
            gpBitmap.free;
            gpCanvas.free;
        end;
    finally
       // t.Free;
    end;

end;

end.

