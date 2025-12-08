unit ADxUtil;

interface

uses
  Windows, Messages, SysUtils, Classes, StdCtrls, ExtCtrls, Forms,
  Graphics, Buttons, AnsImg2, DxDraws, DirectX, AUtil32;

procedure ADXDrawImageKeyColor (aSurface: TDirectDrawSurface; X, Y:integer; AnsImage:TAns2Image; aTrans: Boolean; akeycolor:integer);
procedure ADXDrawImage (aSurface: TDirectDrawSurface; X, Y:integer; AnsImage:TAns2Image; aTrans: Boolean);
procedure ADCDrawDitherSurface (aDest: TDirectDrawSurface; X, Y:integer; aSour: TDirectDrawSurface; adither:integer; aTrans:Boolean);


function  ADXLock (aSurface: TDirectDrawSurface):Boolean;
procedure ADXDrawImageLocked (X, Y:integer; AnsImage:TAns2Image; aTrans: Boolean);
procedure ADXDrawImageKeyColorLocked (X, Y:integer; AnsImage:TAns2Image; aTrans: Boolean; akeycolor:integer);
function  ADXUnLock (aSurface: TDirectDrawSurface):Boolean;


procedure ADCDrawDarkenSurface (aDest: TDirectDrawSurface; X, Y:integer; aSour: TDirectDrawSurface);

implementation

var
   adxddsd : DDSURFACEDESC;
   adxWidth, adxHeight:integer;
   adxOpened : Boolean = FALSE;


function ADXLock (aSurface: TDirectDrawSurface):Boolean;
begin
   Result := FALSE;
   if (aSurface.IDDSurface <> nil) then begin
      adxddsd.dwSize := SizeOf(adxddsd);
      if aSurface.Lock(TRect(nil^), adxddsd) then begin
         adxWidth := aSurface.Width;
         adxHeight := aSurface.Height;
         adxOpened := TRUE;
         Result := TRUE;
      end;
   end;
end;

function ADXUnLock (aSurface: TDirectDrawSurface):Boolean;
begin
   Result := FALSE;
   if adxOpened then begin
//      aSurface.UnLock(adxddsd.lpSurface);
      aSurface.UnLock;
      Result := TRUE;
   end;
end;

procedure ADXDrawImageLocked (X, Y:integer; AnsImage:TAns2Image; aTrans: Boolean);
var
	spb, dpb, TempSS, TempDD : PTAns2Color;
   i, j : integer;
   ir, sr, dr: TRect;
begin
   if AnsImage = nil then exit;

   sr := Rect(x, y, x+AnsImage.Width-1, y+AnsImage.Height-1);
   dr := Rect(0, 0, adxWidth-1, adxHeight-1);

   if not IntersectRect(ir, sr, dr) then exit;

   spb := AnsImage.Bits;
   inc (spb, ((ir.left-x)+(ir.top-y)*AnsImage.Width));

   dpb := PTAns2Color(Integer(adxddsd.lpSurface));
//   if dpb = nil then exit;                                 // Surface½ÇÆÐ

   inc (PBYTE (dpb), (ir.left*2+ir.top*adxddsd.lPitch));

   if aTrans = FALSE then begin
      for i := ir.Top to ir.Bottom do begin
         move (spb^, dpb^, (ir.right-ir.left+1) * sizeof(TAns2Color));
         inc (spb, AnsImage.Width);
         inc (PBYTE(dpb), adxddsd.lPitch);
      end;
   end else begin
      for i := ir.Top to ir.Bottom do begin
         TempSS := spb; TempDD := dpb;
         for j := ir.left to ir.right do begin
            if TempSS^ <> AnsImage.TransparentColor then TempDD^ := TempSS^;
            inc (TempSS); Inc (TempDD);
         end;
         inc (spb, AnsImage.Width);
         inc (PBYTE(dpb), adxddsd.lPitch);
      end;
   end;
end;

procedure ADXDrawImageKeyColor (aSurface: TDirectDrawSurface; X, Y:integer; AnsImage:TAns2Image; aTrans: Boolean; akeycolor:integer);
var
   ddsd: DDSURFACEDESC;
	spb, dpb, TempSS, TempDD : PTAns2Color;
   i, j : integer;
   ir, sr, dr: TRect;
begin
   if AnsImage = nil then exit;

   sr := Rect(x, y, x+AnsImage.Width-1, y+AnsImage.Height-1);
   dr := Rect(0, 0, aSurface.Width-1, aSurface.Height-1);

   if not IntersectRect(ir, sr, dr) then exit;

   if (aSurface.IDDSurface <> nil) then begin
      ddsd.dwSize := SizeOf(ddsd);
      if aSurface.Lock(TRect(nil^), ddsd) then begin
         try
            spb := AnsImage.Bits;
            inc (spb, ((ir.left-x)+(ir.top-y)*AnsImage.Width));

            dpb := PTAns2Color(Integer(ddsd.lpSurface));
            inc (PBYTE(dpb), (ir.left*2+ir.top*ddsd.lPitch));

            if aTrans = FALSE then begin
               for i := ir.Top to ir.Bottom do begin
                  move (spb^, dpb^, (ir.right-ir.left+1) * sizeof(TAns2Color));
                  inc (spb, AnsImage.Width);
                  inc (dpb, aSurface.Width);
               end;
            end else begin
               for i := ir.Top to ir.Bottom do begin
                  TempSS := spb; TempDD := dpb;
                  for j := ir.left to ir.right do begin
                     if TempSS^ <> AnsImage.TransparentColor then begin
                        if TempSS^ <> akeycolor then TempDD^ := TempSS^
                        else begin
                           TempDD^ := darkentbl[TempDD^];
                        end;
                     end;
                     inc (TempSS); Inc (TempDD);
                  end;
                  inc (spb, AnsImage.Width);
                  inc (PBYTE(dpb), ddsd.lPitch);
               end;
            end;
         finally
//           aSurface.UnLock(ddsd.lpSurface);
           aSurface.UnLock;
         end;
      end;
   end;
end;

////////////////////////////////////////////////
//
////////////////////////////////////////////////

procedure ADCDrawDarkenSurface (aDest: TDirectDrawSurface; X, Y:integer; aSour: TDirectDrawSurface);
var
   dddest, ddsour: DDSURFACEDESC;
	spb, dpb, TempSS, TempDD : PTAns2Color;
   i, j : integer;
   ir, sr, dr: TRect;
begin
   sr := Rect(x, y, x+aSour.Width-1, y+aSour.Height-1);
   dr := Rect(0, 0, aDest.Width-1, aDest.Height-1);
   if not IntersectRect(ir, sr, dr) then exit;

   if (aDest.IDDSurface = nil) then exit;
   if (aSour.IDDSurface = nil) then exit;

   dddest.dwSize := SizeOf(dddest);
   ddsour.dwSize := SizeOf(ddsour);

   if not aDest.Lock(TRect(nil^), dddest) then exit;
//   if not aSour.Lock(TRect(nil^), ddsour) then begin aDest.UnLock(dddest.lpSurface); exit; end;
   if not aSour.Lock(TRect(nil^), ddsour) then begin aDest.UnLock; exit; end;

   spb := PTAns2Color(Integer(ddsour.lpSurface));
   inc (PBYTE(spb), ((ir.left-x)*2+(ir.top-y)*ddsour.lPitch));

   dpb := PTAns2Color(Integer(dddest.lpSurface));
   inc (PBYTE(dpb), (ir.left*2+ir.top*dddest.lPitch));

   for i := ir.Top to ir.Bottom do begin
      TempSS := spb; TempDD := dpb;
      for j := ir.left to ir.right do begin
         TempDD^ := darkentbl[TempSS^];
         inc (TempSS); Inc (TempDD);
      end;
      inc (PBYTE(spb), ddsour.lPitch);
      inc (PBYTE(dpb), dddest.lPitch);
   end;

   aSour.UnLock;
   aDest.UnLock;
end;

procedure ADCDrawDitherSurface (aDest: TDirectDrawSurface; X, Y:integer; aSour: TDirectDrawSurface; adither:integer; aTrans:Boolean);
var
   dddest, ddsour: DDSURFACEDESC;
	spb, dpb, TempSS, TempDD : PTAns2Color;
   i, j, n : integer;
   ir, sr, dr: TRect;
begin
   case adither of
      0 :
         begin
            aDest.Draw (x,y, aSour.ClientRect, aSour, aTrans);
            exit;
         end;
      1 : adither := 2;
      2 : adither := 4;
      3 : adither := 8;
      else exit;
   end;

   sr := Rect(x, y, x+aSour.Width-1, y+aSour.Height-1);
   dr := Rect(0, 0, aDest.Width-1, aDest.Height-1);
   if not IntersectRect(ir, sr, dr) then exit;

   if (aDest.IDDSurface = nil) then exit;
   if (aSour.IDDSurface = nil) then exit;

   dddest.dwSize := SizeOf(dddest);
   ddsour.dwSize := SizeOf(ddsour);

   if not aDest.Lock(TRect(nil^), dddest) then exit;
   if not aSour.Lock(TRect(nil^), ddsour) then begin aDest.UnLock; exit; end;

   spb := PTAns2Color(Integer(ddsour.lpSurface));
   inc (PBYTE(spb), ((ir.left-x)*2+(ir.top-y)*ddsour.lPitch));

   dpb := PTAns2Color(Integer(dddest.lpSurface));
   inc (PBYTE(dpb), (ir.left*2+ir.top*dddest.Lpitch));

   if adither = 4 then begin
     inc (spb); inc(dpb);
   end;

   for i := ir.Top to ir.Bottom do begin
      TempSS := spb; TempDD := dpb;

      if (i mod adither) = 0 then begin

         if (i mod (adither*2)) = 0 then begin
            inc (TempSS, adither div 2);
            inc (TempDD, adither div 2);
         end;

         n := (ir.right - ir.left) div adither;
         for j := 0 to n -1 do begin
            TempDD^ := TempSS^;
            inc (TempSS, adither); Inc (TempDD, adither);
         end;
      end;
      inc (PBYTE(spb), ddsour.lPitch);
      inc (PBYTE(dpb), dddest.lPitch);
   end;
   aSour.UnLock;
   aDest.UnLock;
end;

procedure ADXDrawImage (aSurface: TDirectDrawSurface; X, Y:integer; AnsImage:TAns2Image; aTrans: Boolean);
var
   ddsd: DDSURFACEDESC;
	spb, dpb, TempSS, TempDD : PTAns2Color;
   i, j : integer;
   ir, sr, dr: TRect;
begin
   if AnsImage = nil then exit;

   sr := Rect(x, y, x+AnsImage.Width-1, y+AnsImage.Height-1);
   dr := Rect(0, 0, aSurface.Width-1, aSurface.Height-1);

   if not IntersectRect(ir, sr, dr) then exit;

   if (aSurface.IDDSurface <> nil) then begin
      ddsd.dwSize := SizeOf(ddsd);
      if aSurface.Lock(TRect(nil^), ddsd) then begin
         try
            spb := AnsImage.Bits;
            inc (spb, ((ir.left-x)+(ir.top-y)*AnsImage.Width));

            dpb := PTAns2Color(Integer(ddsd.lpSurface));
//            inc (dpb, (ir.left+ir.top*aSurface.Width));
            inc (PBYTE(dpb), (ir.left*2+ir.top*ddsd.lPitch));

            if aTrans = FALSE then begin
               for i := ir.Top to ir.Bottom do begin
                  move (spb^, dpb^, (ir.right-ir.left+1) * sizeof(TAns2Color));
                  inc (spb, AnsImage.Width);
//                  inc (dpb, aSurface.Width);
                  inc (PBYTE(dpb), ddsd.lPitch);
               end;
            end else begin
               for i := ir.Top to ir.Bottom do begin
                  TempSS := spb; TempDD := dpb;
                  for j := ir.left to ir.right do begin
                     if TempSS^ <> AnsImage.TransparentColor then TempDD^ := TempSS^;
                     inc (TempSS); Inc (TempDD);
                  end;
                  inc (spb, AnsImage.Width);
//                  inc (dpb, aSurface.Width);
                  inc (PBYTE(dpb), ddsd.lPitch);
               end;
            end;
         finally
           aSurface.UnLock;
//           aSurface.UnLock(ddsd.lpSurface);
         end;
      end;
   end;
end;

procedure ADXDrawImageKeyColorLocked (X, Y:integer; AnsImage:TAns2Image; aTrans: Boolean; akeycolor:integer);
var
	spb, dpb, TempSS, TempDD : PTAns2Color;
   i, j : integer;
   ir, sr, dr: TRect;
begin
   if AnsImage = nil then exit;

   sr := Rect(x, y, x+AnsImage.Width-1, y+AnsImage.Height-1);
   dr := Rect(0, 0, adxWidth-1, adxHeight-1);

   if not IntersectRect(ir, sr, dr) then exit;

   spb := AnsImage.Bits;
   inc (spb, ((ir.left-x)+(ir.top-y)*AnsImage.Width));

   dpb := PTAns2Color(Integer(adxddsd.lpSurface));
   inc (PBYTE (dpb), (ir.left*2+ir.top*adxddsd.lPitch));

   if aTrans = FALSE then begin
      for i := ir.Top to ir.Bottom do begin
         move (spb^, dpb^, (ir.right-ir.left+1) * sizeof(TAns2Color));
         inc (spb, AnsImage.Width);
         inc (PBYTE(dpb), adxddsd.lPitch);
      end;
   end else begin
      for i := ir.Top to ir.Bottom do begin
         TempSS := spb; TempDD := dpb;
         for j := ir.left to ir.right do begin
            if TempSS^ <> AnsImage.TransparentColor then begin
               if TempSS^ <> akeycolor then TempDD^ := TempSS^
               else begin
                  TempDD^ := darkentbl[TempDD^];
               end;
            end;
            inc (TempSS); Inc (TempDD);
         end;
         inc (spb, AnsImage.Width);
         inc (PBYTE(dpb), adxddsd.lPitch);
      end;
   end;
end;

end.
