unit ScriptForMysql;

interface
uses
  PaxPascal, PaxScripter, class_DataSetWrapper, DB, SysUtils;
implementation

procedure clearQuerySQL;
begin
  G_TDataSetWrapper.clearQuerySQL;
end;

procedure addQuerySQL(ASQL: string);
begin
  G_TDataSetWrapper.addQuerySQL(ASQL);
end;

procedure excuteQuerySQL;
begin
  G_TDataSetWrapper.excuteQuerySQL;
end;

function getQueryDataSet: TDataSet;
begin
  Result := G_TDataSetWrapper.GetQueryDataSet;
end;

function getFieldData(ADataSet: TDataSet; AFiledName: string): Variant;
begin
  Result := ADataSet.FieldByName(AFiledName).AsVariant;
end;

function getDataFromMySQL(ASQL: string; AFieldName: string): Variant;
begin

  Result := G_TDataSetWrapper.getDataFromSQL(ASQL, AFieldName);
end;

function doSQL(ASQL: string): Integer;
begin
  Result := G_TDataSetWrapper.doSQL(ASQL);
end;

initialization
  begin
    G_TDataSetWrapper := TDataSetWrapper.Create;
    RegisterRoutine('function IntToStr(Value: Integer): string;', @inttostr);
//    RegisterRoutine('function getQueryDataSet:TDataSet;', @getQueryDataSet);
//    RegisterRoutine('procedure clearQuerySQL;', @clearQuerySQL);
//    RegisterRoutine('procedure addQuerySQL(ASQL: string);', @addQuerySQL);
//    RegisterRoutine('procedure excuteQuerySQL;', @excuteQuerySQL);
    RegisterRoutine('function doSQL(ASQL: string): Integer;', @doSQL);
    RegisterRoutine('function getDataFromMySQL(ASQL: string; AFieldName: string): Variant;', @getDataFromMySQL);
   // RegisterClassType(TDataSet);
   // RegisterRoutine('function getFieldData(ADataSet:TDataSet;AFiledName:string):Variant;', @getFieldData);
  //  RegisterMethod(TDataSet, 'procedure Next;', @TDataSet.Next);
  end;

finalization //2015.11.10 在水一方 内存泄露005
  begin
    G_TDataSetWrapper.Free;
  end;

end.

