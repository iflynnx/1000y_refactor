unit uDBRecordDef;

interface

uses
deftype;

type
   TDBHeader = packed record
      ID : array[0..4 - 1] of byte;
      RecordCount : Integer;
      RecordDataSize : Integer;
      RecordFullSize : Integer;
      boSavedIndex : Boolean;
      Dummy : array [0..32 - 1] of byte;
   end;
   PTDBHeader = ^TDBHeader;

   TDBItemData = packed record
      Name : array [0..20 - 1] of byte;      // ÀÌ¸§
      Count : Integer;                       // ¼ö·®
      Color : Byte;                          // »ö»ó
      Durability : Word;                     // ÃÖ´ëÄ¡³»±¸¼º
      CurDurability : Word;                  // ÇöÀç³»±¸¼º
      UpGrade : byte;                        // µî±Þ
      AddType : Byte;                        // Ãß°¡¼Ó¼º
      Dummy : Byte;                          // Reserved

      // add by Orber at 2004-08-26 10:53
      rLockState : Byte;
      runLockTime : Word;
   end;

   TDBMarketItemData = packed record
      Name : array [0..20 - 1] of byte;      // ÀÌ¸§
      Count : Integer;                       // ¼ö·®
      Color : Byte;                          // »ö»ó
      Durability : Word;                     // ÃÖ´ëÄ¡³»±¸¼º
      CurDurability : Word;                  // ÇöÀç³»±¸¼º
      UpGrade : byte;                        // µî±Þ
      AddType : Byte;                        // Ãß°¡¼Ó¼º
      Cost : Integer;                        // ÆÇ¸ÅÇÒ¶§ °¡°Ý
      Dummy : Byte;                          // Reserved
   end;

   TDBMagicData = packed record
      Name : array [0..20 - 1] of byte;
      Skill : Integer;
   end;
   TDBBasicMagicData = packed record
      Skill : integer;
   end;

   TDBBestMagicData = packed record
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

   TDBRecord = packed record
      PrimaryKey     : array [0..20 - 1] of byte;              // Ä³¸¯¸í

      MasterName     : array [0..20 - 1] of byte;              // °èÁ¤¸í
      Password       : array [0..10 - 1] of byte;              // ºñ¹Ð¹øÈ£
      GroupKey       : Word;                                   // ´ÜÃ¼¹øÈ£
      Guild          : array [0..20 - 1] of byte;              // ¹®ÆÄ¸í
      LastDate       : array [0..12 - 1] of byte;              // ÃÖÁ¾Á¢¼ÓÀÏ
      CreateDate     : array [0..12 - 1] of byte;              // ÃÖÃÊÁ¢¼ÓÀÏ
      Sex            : array [0..6 - 1] of byte;               // ¼ºº°
      // add by Orber at 2004-12-21 17:46:33
      Lover          : array [0..20-1] of byte;

      ServerId       : byte;                                   // Map ¹øÈ£
      x              : word;                                   // X ÁÂÇ¥
      y              : word;                                   // Y ÁÂÇ¥

      Light          : Integer;                                // ¾ç±â
      Dark           : Integer;                                // À½±â
      Energy         : Integer;                                // ¿ø±â
      InPower        : Integer;                                // ³»°ø
      OutPower       : Integer;                                // ¿Ü°ø
      Magic          : Integer;                                // ¹«°ø
      Life           : Integer;                                // È°·Â

      Talent         : integer;                                // Àç´É
      GoodChar       : integer;                                // ½Å¼º
      BadChar        : integer;                                // ¸¶¼º
      Adaptive       : integer;                                // ³»¼º
      Revival        : integer;                                // Àç»ý
      Immunity       : integer;                                // ¸é¿ª
      Virtue         : integer;                                // È£¿¬Áö±â

      CurEnergy      : integer;                                // ÇöÀç ¿ø±â
      CurInPower     : integer;                                // ÇöÀç ³»°ø
      CurOutPower    : integer;                                // ÇöÀç ¿Ü°ø
      CurMagic       : integer;                                // ÇöÀç ¹«°ø
      CurLife        : integer;                                // ÇöÀç È°·Â
      CurHealth      : integer;                                // ÇöÀç
      CurSatiety     : integer;                                // ÇöÀç
      CurPoisoning   : integer;                                // ÇöÀç
      CurHeadSeek    : integer;                                // ÇöÀç ¸Ó¸® È°·Â
      CurArmSeek     : integer;                                // ÇöÀç ÆÈ È°·Â
      CurLegSeek     : integer;                                // ÇöÀç ´Ù¸® È°·Â

      ExtraExp       : integer;
      AddableStatePoint : integer;
      TotalStatePoint : integer;
      CurrentGrade : Byte;

      BasicMagicArr : array [0..HAVEBasicMagicArr - 1] of TDBBasicMagicData;   //Ò»²ãÎÞÃû
      BasicRiseMagicArr : array [0..HAVEBasicRiseMagicArr - 1] of TDBMagicData;     // ¶þ²ãÀËÈË
      WearItemArr : array [0..8 - 1] of TDBItemData;             //´©ÉÏ
      HaveItemArr : array [0..HAVEITEMSIZE - 1] of TDBItemData;             //ÎïÆ·À¸
      HaveMagicArr : array [0..HaveMagicSIZE - 1] of TDBMagicData;           //Ò»²ãÎä¹¦
      HaveRiseMagicArr : array [0..HAVERISEMAGICSIZE - 1] of TDBMagicData;    // ¶þ²ãÎä¹¦
      HaveMysteryArr : array [0..HAVEMYSTERYMAGICSIZE - 1] of TDBMagicData;      // ¼úÀå¹ý¹«°ø
      HaveBestSpecialMagicArr : array [0..HAVEBESTSPECIALMAGICSIZE-1] of TDBBestMagicData; //ÐÂ Èý²ãÕÐÊ½ 15¸ö
      HaveBestProtectMagicArr : array [0..HAVEBESTPROTECTMAGICSIZE-1] of TDBBestMagicData; // ÐÂ Èý²ã»¤Ìå 5¸ö
      HaveBestAttackMagicArr : array [0..HAVEBESTATTACKMAGICSIZE-1] of TDBBestMagicData; // ¾øÐÂ Èý²ã¹¥»÷Îä¹¦ 5¸ö

      HaveMaterialItemArr : array [0..5 - 1] of TDBItemData;   // Àç·áÃ¢ 5°³
      HaveMarketItemArr : array [0..10 - 1] of TDBMarketItemData;    // °³ÀÎÆÇ¸ÅÃ¢ 10°³

      Person1        : array [0..20 - 1] of Byte;
      Person2        : array [0..20 - 1] of Byte;
      Key            : array [0..10 - 1] of Byte;

      CompleteQuestNo : Integer;
      CurrentQuestNo : Integer;
      QuestStr       : array [0..20 - 1] of byte;
      FirstQuestNo : Integer;                                   // ÃÊº¸¸¶À»¿ë quest°ª...

      JobKind        : byte;              // Á÷Á¾
      ExtJobKind : Byte;
      CurExtJobExp : Integer;

      Person3        : array [0..20 - 1] of Byte;               // »çÁ¦ÀÌº¥¿ë...
      Person4        : array [0..20 - 1] of Byte;

      EventRecord    : array [0..20 - 1] of Byte;
      Dummy : array[0..66 - 1] of byte;
      CRCKey : Cardinal;
   end;
   PTDBRecord = ^TDBRecord;

  // add by Orber at 2004-11-04 20:05:21
   TCheckCharData  = packed record
      rCharData : TDBRecord;
      rEnd : Byte;
   end;

implementation

end.
