unit uItemLog;
//本单元 废弃
interface

uses
    Classes, SysUtils, DefType, uKeyClass,  uSendCls;

const
    ITEMLOGID       = 'ITEMLOG';

    {  TItemLogHeader = record
          ID:array[0..10 - 1] of byte;
          Count:Integer;
          FreeCount:Integer;
      end;
      PTItemLogHeader = ^TItemLogHeader;

      TItemLogData = record          //仓库  存放 结构  ？？？有问题 只保存了部分 物品 属性
          Name:array[0..20 - 1] of byte;
          Count:Integer;
          Color:Byte;
          Durability:Byte;
          UpGrade:array[0..4 - 1] of Byte;
          Dummy:Byte;
      end;
      PTItemLogData = ^TItemLogData;
      }

      {
      改变 模式
  1，    保存到文件，改由DB来保存
  2，    使用1份实力仓库类，改成每个人一份实力
      }

implementation

uses
    svClass, uUserSub;
end.

