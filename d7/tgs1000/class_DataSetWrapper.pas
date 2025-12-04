unit class_DataSetWrapper;

interface
uses
  DB, MyAccess, Lua, LuaLib, Variants, Dialogs;
type
  TDataSetWrapper = class
  private
    FQueryDataSet: TDataSet;
  public
    procedure initDataSet;
    procedure clearQuerySQL;
    procedure addQuerySQL(ASQL: string);
    procedure excuteQuerySQL;
    function GetQueryDataSet: TDataSet;
    constructor Create(); virtual;
    destructor Destroy; override;
    function doSQL(ASQL: string): Integer;
    function getDataFromSQL(ASQL: string; AFieldName: string): Variant;
    function getMySqlDataSetForLua(L: TLuaState): Integer;
  end;
var
  G_TDataSetWrapper: TDataSetWrapper;
implementation
uses
  uDM;
{ TDataSetWrapper }

procedure TDataSetWrapper.addQuerySQL(ASQL: string);
begin
  dm.Query.SQL.Add(ASQL);
end;

procedure TDataSetWrapper.clearQuerySQL;
begin
  dm.Query.SQL.Clear;
end;

constructor TDataSetWrapper.Create; //2015.11.10 在水一方 内存泄露004
begin
  Tdm.CreateDM;
  FQueryDataSet := nil;
  initDataSet;
end;

destructor TDataSetWrapper.Destroy;
begin
  FQueryDataSet := nil;
  dm.Free;
  inherited;
end;

function TDataSetWrapper.doSQL(ASQL: string): Integer;
var
  mysql: TMyQuery;
  i: integer;
begin
  try
    Result := 0;
    try
      if not dm.MyConn.Connected then
      begin
        dm.Connect;
      //  dm.MyConn.Connect;
      end;

      mysql := TMyQuery.Create(nil);
      if dm.MyConn.Connected then
      begin
        mysql.Connection := dm.MyConn;
        mysql.SQL.Clear;
        mysql.SQL.Add('set names "gbk"');
        mysql.ExecSQL;
      end;
      mysql.Free;

      mysql := TMyQuery.Create(nil);
      if dm.MyConn.Connected then
      begin
        mysql.Connection := dm.MyConn;
        mysql.SQL.Clear;
        mysql.SQL.Add(ASQL);
        mysql.ExecSQL;
        Result := mysql.RowsAffected;
      end;
    finally
      mysql.Close;
      mysql.Free;
    end;
  except
    Result := 0;
  end;
end;

procedure TDataSetWrapper.excuteQuerySQL;
begin
  dm.Query.ExecSQL;
end;

function TDataSetWrapper.getDataFromSQL(ASQL: string; AFieldName: string): Variant;
var
  mysql: TMyQuery;
begin
  try
    try
      if not dm.MyConn.Connected then
      begin
        dm.MyConn.Connect;
      end;

      mysql := TMyQuery.Create(nil);
      if dm.MyConn.Connected then
      begin
        mysql.Connection := dm.MyConn;
        mysql.SQL.Clear;
        mysql.SQL.Add('set names "gbk"');
        mysql.ExecSQL;
      end;
      mysql.Free;
      
      mysql := TMyQuery.Create(nil);
      if dm.MyConn.Connected then
      begin
        mysql.Connection := dm.MyConn;
        mysql.SQL.Clear;
        mysql.SQL.Add(ASQL);
        mysql.ExecSQL;
        if not mysql.IsEmpty then
          Result := mysql.FieldByName(AFieldName).AsVariant else
          Result := -999;
      end;
    except
    end;

  finally
    mysql.Close;
    mysql.Free;
  end;
end;

function TDataSetWrapper.getMySqlDataSetForLua(L: TLuaState): Integer;
var
  sSql: string;
  i: Integer;
var
  mysql: TMyQuery;
  v: Variant;
  s: string;
  vi: Integer;
  vas: string;
  vd: Double;
  totalrows: Integer;
begin
  sSql := lua_tostring(L, 1);
  try
    try
      if not dm.MyConn.Connected then
      begin
        dm.Connect;
      end;

      mysql := TMyQuery.Create(nil);
      if dm.MyConn.Connected then
      begin
        mysql.Connection := dm.MyConn;
        mysql.SQL.Clear;
        mysql.SQL.Add('set names "gbk"');
        mysql.ExecSQL;
      end;
      mysql.Free;

      mysql := TMyQuery.Create(nil);
      if dm.MyConn.Connected then
      begin
        mysql.Connection := dm.MyConn;
        mysql.SQL.Clear;
        mysql.SQL.Add(sSql);
        mysql.ExecSQL;
        Result := 0; //没数据
        if not mysql.IsEmpty then
        begin          
          lua_newtable(L); //创建一个表格，放在栈顶
          mysql.First;
          totalrows := 0;
          while not mysql.Eof do
          begin
            Inc(totalrows); //增加行数
            lua_pushnumber(L, totalrows); //压入key
            lua_newtable(L); //压入value,也是一个table
            //遍历每行数据的所有字段
            for i := 0 to mysql.Fields.Count - 1 do
            begin
              v := mysql.Fields[i].AsVariant;
//              case v.VType of
//                vtInteger: begin
//
//                    vi := v.VInteger;
//                    lua_pushinteger(L, vi);
//                  end;
//                vtAnsiString: begin
//                    vas := v.VPChar;
//                    lua_pushstring(L, PAnsiChar(vas));
//                  end;
//                vtBoolean: begin
//                    lua_pushboolean(L, v.VBoolean);
//                  end;
//                vtCurrency: begin
//                    vd := v.vfloat;
//                    lua_pushnumber(L, vd);
//                  end;
//              end;
// lua_settable(L, -3);
              //如果下边的获取数据方式不行则用上边注释掉的部分
              s := VarToStrDef(v, 'errdata'); //如果遇到不能转换的数据则返回errdata
              lua_pushstring(L, PAnsiChar(mysql.Fields[i].FullName));
              lua_pushstring(L, PAnsiChar(s)); //压入key
              lua_settable(L, -3);
            end;
            lua_settable(L, -3); //这时候父table的位置还是-3,弹出key,value(subtable),并设置到table里去
            //获取下一行数据
            mysql.Next;
          end;
//          lua_pushstring(L, PAnsiChar('rowtotalcount'));
//          lua_pushinteger(L, totalrows);
//          lua_settable(L, -3);
          Result := 1;
        end;
      end;
    except
      ///这里异常 你得填个异常数值
      Lua_PushInteger(L, -1);
      Result := 1;
    end;

  finally
    mysql.Close;
    mysql.Free;
  end;

end;

function TDataSetWrapper.GetQueryDataSet: TDataSet;
begin
  Result := FQueryDataSet;
end;

procedure TDataSetWrapper.initDataSet;
begin
  FQueryDataSet := dm.Query;
end;

end.

