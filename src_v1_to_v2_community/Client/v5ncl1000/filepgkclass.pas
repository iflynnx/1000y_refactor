unit filepgkclass;
{*.bmp

=>>> bmp.pgk
------------------
mapmini目录小地图图片
*.hdf
*.map
*.obj
*.til

 =>>> map.pgk
------------------
*.atz
*.sdb
*.atd
*.ini
*.txt
 =>>> sys.pgk
------------------
wav目录打包1个文件
=>>> wav.pgk
------------------
eft目录打包1个文件
=>>> eft.pgk
------------------
sprite目录打包1个文件
=>>> sprite.pgk
------------------
ect目录打包1个文件
=>>> ect.pgk
------------------}
interface
uses
    Windows, SysUtils, Classes, FfilePgk,uKeyClass, Atzcls;

var
    pgkBmp: Tfilepgk;
    //pgkbmp_n:Tfilepgk;
    pgkmap: Tfilepgk;
    pgksys: Tfilepgk;
    //  pgkwav          :Tfilepgk;
    pgkeft: Tfilepgk;
    pgksprite: Tfilepgk;
    pgkect: Tfilepgk;

    pgkeft_W: Tfilepgk;

implementation

procedure tempPgk();
var
    filepgk: Tfilepgk;
begin       //2015.11.12 在水一方
    if FileExists('.\data\'+Enc('temp.pgk')+'.dgk') = FALSE then
    begin
        filepgk := tfilepgk.Create('.\data\'+Enc('temp.pgk')+'.dgk', true, false);
        filepgk.Free;
    end;
end;
procedure savePgkDataFileName(pgk:Tfilepgk);
var
  i:Integer;
  skc:TStringKeyClass;
  data:TList;
      pd              :PTStringKeyData;
      tmp:TStrings;
begin
  if (pgk.fdata<>nil) then
  begin
     skc:= pgk.fdata.getTStringKeyClass;
     if skc<>nil then
     begin
       data:= skc.getDataList;
       if data<> nil then
       begin
         try
           tmp:=TStringList.Create;
         for i:=0 to data.Count-1 do
         begin
          pd:=  data.Items[i];
         tmp.Add(pd^.StringKey);
         end;
         tmp.SaveToFile(pgk.ClassName);
         finally
           tmp.Free;
         end;
       end;  
     end;  
  end;
    
end;
initialization
 // {$IFDEF FPK}
    begin  //2015.11.12 在水一方
        pgkeft_W := tfilepgk.Create('.\data\'+Enc('eft_w.pgk')+'.dgk', true, false);

        pgkBmp := Tfilepgk.Create('.\data\'+Enc('bmp.pgk')+'.dgk');
        //pgkBmp_n := Tfilepgk.Create('.\data\'+Enc('bmp_n.pgk')+'.dgk');
        pgksys := Tfilepgk.Create('.\data\'+Enc('sys.pgk')+'.dgk');
        //  savePgkDataFileName(pgksys);

        tempPgk;
        if FileExists('.\data\'+Enc('map.pgk')+'.dgk') = FALSE then
            pgkmap := Tfilepgk.Create('.\data\'+Enc('temp.pgk')+'.dgk')
        else
            pgkmap := Tfilepgk.Create('.\data\'+Enc('map.pgk')+'.dgk');

        if FileExists('.\data\'+Enc('eft.pgk')+'.dgk') = FALSE then
            pgkeft := Tfilepgk.Create('.\data\'+Enc('temp.pgk')+'.dgk')
        else
            pgkeft := Tfilepgk.Create('.\data\'+Enc('eft.pgk')+'.dgk');
        if FileExists('.\data\'+Enc('sprite.pgk')+'.dgk') = FALSE then
            pgksprite := Tfilepgk.Create('.\data\'+Enc('temp.pgk')+'.dgk')
        else
            pgksprite := Tfilepgk.Create('.\data\'+Enc('sprite.pgk')+'.dgk');
        if FileExists('.\data\'+Enc('ect.pgk')+'.dgk') = FALSE then
            pgkect := Tfilepgk.Create('.\data\'+Enc('temp.pgk')+'.dgk')
        else
            pgkect := Tfilepgk.Create('.\data\'+Enc('ect.pgk')+'.dgk');

    end;
//   {$ELSE}

//    begin
//        pgkeft_W := tfilepgk.Create('.\eft_w.pgk', true, false);
//
//        pgkBmp := Tfilepgk.Create('.\bmp.pgk');
//        pgkBmp_n := Tfilepgk.Create('.\bmp_n.pgk');
//        pgksys := Tfilepgk.Create('.\sys.pgk');
//        tempPgk;
//        if FileExists('map.pgk') = FALSE then
//            pgkmap := Tfilepgk.Create('.\temp.pgk')
//        else
//            pgkmap := Tfilepgk.Create('.\map.pgk');
//
//        if FileExists('eft.pgk') = FALSE then
//            pgkeft := Tfilepgk.Create('.\temp.pgk')
//        else
//            pgkeft := Tfilepgk.Create('.\eft.pgk');
//        if FileExists('sprite.pgk') = FALSE then
//            pgksprite := Tfilepgk.Create('.\temp.pgk')
//        else
//            pgksprite := Tfilepgk.Create('.\sprite.pgk');
//        if FileExists('ect.pgk') = FALSE then
//            pgkect := Tfilepgk.Create('.\temp.pgk')
//        else
//            pgkect := Tfilepgk.Create('.\ect.pgk');
//
//    end;
//   {$ENDIF}
finalization
    begin
        pgkeft_W.Free;
        pgkBmp.Free;
        //pgkbmp_n.free;
        pgkmap.Free;
        pgksys.Free;
        // pgkwav.Free;
        pgkeft.Free;
        pgksprite.Free;
        pgkect.Free;
    end;

end.

