object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 437
  Top = 270
  Height = 435
  Width = 665
  object MyConn: TMyConnection
    Database = 'mysql'
    Options.Charset = 'gb2312'
    Username = 'root'
    Server = '127.0.0.1'
    OnError = MyConnError
    LoginPrompt = False
    Left = 104
    Top = 72
  end
  object Query: TMyQuery
    Connection = MyConn
    Left = 104
    Top = 144
  end
end
