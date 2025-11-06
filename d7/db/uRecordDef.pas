unit uRecordDef;

interface

uses
DefType;

const
   IndexID = 'IDX';

type
   TDBHeader = record
      ID : array[0..4 - 1] of byte;
      RecordCount : Integer;
      RecordDataSize : Integer;
      RecordFullSize : Integer;
      boSavedIndex : Boolean;
      Dummy : array [0..32 - 1] of byte;
   end;
   PTDBHeader = ^TDBHeader;

    TDBModuleType = (dmtNone, dmtUser, dmtTemp);
    TDBHeadModule = record
        rname: array[0..64 - 1] of byte;//string[64];
        rtime: tdatetime;
        rid: Integer;
        rstate: TDBModuleType;
    end;
    pTDBHeadModule = ^TDBHeadModule;

   TIndexHeader = record
      ID : array[0..4 - 1] of byte;
      IndexRecordCount : Integer;
      BlankRecordCount : Integer;
      FDBUpdateDate : array[0..32 - 1] of byte;
      Dummy : array[0..32 - 1] of byte;
   end;
   PTIndexHeader = ^TIndexHeader;

   TDBItemData = record
      Name : array [0..20 - 1] of byte;
      Count : Integer;
      Color : Byte;
      Durability : Word;
      CurDurability : Word;
      UpGrade : byte;
      AddType : Byte;
      Dummy : Byte;

      // add by Orber at 2004-08-26 10:53
      LockState : Byte;
      unLockTime : Word;
   end;

   TDBMarketItemData = record
      Name : array [0..20 - 1] of byte;
      Count : Integer;
      Color : Byte;
      Durability : Word;
      CurDurability : Word;
      UpGrade : byte;
      AddType : Byte;
      Cost : Integer;
      Dummy : Byte;
   end;

   TDBBestMagicData = record
      Name : array [0..20-1] of byte;
      Grade : byte;
      rDamageBody : word;
      rDamageHead : word;
      rDamageArm : word;
      rDamageLeg : word;
      rDamageEnergy : word;
      rArmorBody : word;
      rArmorHead : word;
      rArmorArm : word;
      rArmorLeg : word;
      rArmorEnergy : word;
      Skill : integer;
   end;
   
   TDBMagicData = record
      Name : array [0..20-1] of byte;
      Skill : Integer;
   end;
   TDBBasicMagicData = record
      Skill : integer;
   end;


   TDBRecord = record
      boUsed : byte;
      PrimaryKey : array [0..20 - 1] of byte;

      MasterName : array [0..20 - 1] of byte;
      Password : array [0..10 - 1] of byte;
      GroupKey : Word;
      
      Guild : array [0..20 - 1] of byte;
      LastDate : array [0..12 - 1] of byte;
      CreateDate : array [0..12 - 1] of byte;
      Sex : array [0..6 - 1] of byte;
      // add by Orber at 2004-12-21 17:46:33
      Lover: array [0..20-1] of byte;

      ServerId : byte;
      x : word;
      y : word;

      Light : Integer;
      Dark : Integer;
      Energy : Integer;
      InPower : Integer;
      OutPower : Integer;
      Magic : Integer;
      Life : Integer;

      Talent : integer;
      GoodChar : integer;
      BadChar : integer;

      Adaptive : integer;
      Revival : integer;
      Immunity : integer;
      Virtue : integer;
      
      CurEnergy    : integer;
      CurInPower   : integer;
      CurOutPower  : integer;
      CurMagic     : integer;
      CurLife      : integer;
      CurHealth    : integer;
      CurSatiety   : integer;
      CurPoisoning : integer;
      CurHeadSeak  : integer;
      CurArmSeak   : integer;
      CurLegSeak   : integer;

      ExtraExp          : integer;
      AddableStatePoint : integer;
      TotalStatePoint   : integer;
      CurrentGrade      : Byte;

      BasicMagicArr : array [0..HAVEBasicMagicArr - 1] of TDBBasicMagicData;   //Ò»²ãÎÞÃû
      BasicRiseMagicArr : array [0..HAVEBasicRiseMagicArr - 1] of TDBMagicData;     // ¶þ²ãÀËÈË
      WearItemArr : array [0..8 - 1] of TDBItemData;             //´©ÉÏ
      HaveItemArr : array [0..HAVEITEMSIZE - 1] of TDBItemData;             //ÎïÆ·À¸
      HaveMagicArr : array [0..HaveMagicSIZE - 1] of TDBMagicData;           //Ò»²ãÎä¹¦
      HaveRiseMagicArr : array [0..HAVERISEMAGICSIZE - 1] of TDBMagicData;    // ¶þ²ãÎä¹¦
      HaveMysteryMagicArr : array [0..HAVEMYSTERYMAGICSIZE - 1] of TDBMagicData; // ÕÆ·¨

      HaveBestSpecialMagicArr : array [0..HAVEBESTSPECIALMAGICSIZE-1] of TDBBestMagicData; //ÐÂ Èý²ãÕÐÊ½ 15¸ö
      HaveBestProtectMagicArr : array [0..HAVEBESTPROTECTMAGICSIZE-1] of TDBBestMagicData; // ÐÂ Èý²ã»¤Ìå 5¸ö
      HaveBestAttackMagicArr : array [0..HAVEBESTATTACKMAGICSIZE-1] of TDBBestMagicData; // ¾øÐÂ Èý²ã¹¥»÷Îä¹¦ 5¸ö

      HaveMaterialItemArr : array [0..5 - 1] of TDBItemData;   // Àç·áÃ¢ 5°³
      HaveMarketItemArr : array [0..10 - 1] of TDBMarketItemData;    // °³ÀÎÆÇ¸ÅÃ¢ 10°³      

      Person1 : array [0..20 - 1] of byte;
      Person2 : array [0..20 - 1] of byte;
      Key : array [0..10 - 1] of Byte;

      CompleteQuestNo : Integer;
      CurrentQuestNo : Integer;
      QuestStr : array [0..20 - 1] of byte;
      FirstQuestNo : Integer;                                   // ÃÊº¸¸¶À»¿ë quest°ª...      

      JobKind : Byte;
      ExtJobKind : Byte;
      CurJobExp : Integer;

      Person3        : array [0..20 - 1] of Byte;               // »çÁ¦ÀÌº¥¿ë...
      Person4        : array [0..20 - 1] of Byte;

      EventRecord    : array [0..20 - 1] of Byte;
      Dummy : array[0..66 - 1] of byte;
      CRCKey : Cardinal;
   end;
   PTDBRecord = ^TDBRecord;

   TDBRecordNew = record
      boUsed : byte;
      PrimaryKey : array [0..20 - 1] of byte;

      MasterName : array [0..20 - 1] of byte;
      Password : array [0..10 - 1] of byte;
      GroupKey : Word;
      
      Guild : array [0..20 - 1] of byte;
      LastDate : array [0..12 - 1] of byte;
      CreateDate : array [0..12 - 1] of byte;
      Sex : array [0..6 - 1] of byte;

      ServerId : byte;
      x : word;
      y : word;

      Light : Integer;
      Dark : Integer;
      Energy : Integer;
      InPower : Integer;
      OutPower : Integer;
      Magic : Integer;
      Life : Integer;

      Talent : integer;
      GoodChar : integer;
      BadChar : integer;

      Adaptive : integer;
      Revival : integer;
      Immunity : integer;
      Virtue : integer;
      
      CurEnergy    : integer;
      CurInPower   : integer;
      CurOutPower  : integer;
      CurMagic     : integer;
      CurLife      : integer;
      CurHealth    : integer;
      CurSatiety   : integer;
      CurPoisoning : integer;
      CurHeadSeak  : integer;
      CurArmSeak   : integer;
      CurLegSeak   : integer;

      ExtraExp          : integer;
      AddableStatePoint : integer;
      TotalStatePoint   : integer;
      CurrentGrade      : Byte;

      BasicMagicArr : array [0..HAVEBasicMagicArr - 1] of TDBBasicMagicData;   //Ò»²ãÎÞÃû
      BasicRiseMagicArr : array [0..HAVEBasicRiseMagicArr - 1] of TDBMagicData;     // ¶þ²ãÀËÈË
      WearItemArr : array [0..8 - 1] of TDBItemData;             //´©ÉÏ
      HaveItemArr : array [0..HAVEITEMSIZE - 1] of TDBItemData;             //ÎïÆ·À¸
      HaveMagicArr : array [0..HaveMagicSIZE - 1] of TDBMagicData;           //Ò»²ãÎä¹¦
      HaveRiseMagicArr : array [0..HAVERISEMAGICSIZE - 1] of TDBMagicData;    // ¶þ²ãÎä¹¦
      HaveMysteryMagicArr : array [0..HAVEMYSTERYMAGICSIZE - 1] of TDBMagicData; // ÕÆ·¨

      HaveBestSpecialMagicArr : array [0..15-1] of TDBBestMagicData; // Àý¼¼¹«°ø Áß ÃÊ½Ä(ÇÊ»ì±â)
      HaveBestProtectMagicArr : array [0..5-1] of TDBBestMagicData; // Àý¼¼¹«°ø Áß °ø·Â
      HaveBestAttackMagicArr : array [0..5-1] of TDBBestMagicData; // Àý¼¼¹«°ø Áß °ø°ÝÇü ¹«°ø

      HaveMaterialItemArr : array [0..5 - 1] of TDBItemData;   // Àç·áÃ¢ 5°³
      HaveMarketItemArr : array [0..10 - 1] of TDBMarketItemData;    // °³ÀÎÆÇ¸ÅÃ¢ 10°³      

      Person1 : array [0..20 - 1] of byte;
      Person2 : array [0..20 - 1] of byte;
      Key : array [0..10 - 1] of Byte;

      CompleteQuestNo : Integer;
      CurrentQuestNo : Integer;
      QuestStr : array [0..20 - 1] of byte;
      FirstQuestNo : Integer;                                   // ÃÊº¸¸¶À»¿ë quest°ª...      

      JobKind : Byte;
      Person3        : array [0..20 - 1] of Byte;               // »çÁ¦ÀÌº¥¿ë...
      Person4        : array [0..20 - 1] of Byte;

      Dummy : array[0..66 - 1] of byte;
   end;
   PTDBRecordNew = ^TDBRecordNew;

implementation

end.
