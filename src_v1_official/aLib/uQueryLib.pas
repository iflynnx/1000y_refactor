unit uQueryLib;

interface

   function QueryGetQuery (aIniFile : shortstring): integer;
   function QueryFreeQuery (aHandle: integer): boolean;

   function QuerySetIniFile(aHandle: integer; aIniFile: shortstring):boolean;
   function QueryGetFields(aHandle: integer; pFields: pChar): boolean;
   function QuerySelect(aHandle: integer; PrimaryValue: ShortString ; pFields, pdata: pChar):boolean;
   function QueryUpdate(aHandle: integer; PrimaryValue: ShortString ; pFields, pdata: pChar):boolean;
   function QueryDelete(aHandle: integer; PrimaryValue: ShortString):boolean;
   function QueryInsert(aHandle: integer; PrimaryValue: ShortString ; pFields, pData: pChar):boolean;

implementation

   function QueryGetQuery; external 'QueryLib.dll' name 'QueryGetQuery';
   function QueryFreeQuery; external 'QueryLib.dll' name 'QueryFreeQuery';

   function QuerySetIniFile; external 'QueryLib.dll' name 'QuerySetIniFile';
   function QueryGetFields; external 'QueryLib.dll' name 'QueryGetFields';
   function QuerySelect; external 'QueryLib.dll' name 'QuerySelect';
   function QueryUpdate; external 'QueryLib.dll' name 'QueryUpdate';
   function QueryDelete; external 'QueryLib.dll' name 'QueryDelete';
   function QueryInsert; external 'QueryLib.dll' name 'QueryInsert';

end.
 