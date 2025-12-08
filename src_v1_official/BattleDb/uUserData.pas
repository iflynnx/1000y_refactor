unit uUserData;

interface

uses
   Classes, SysUtils, UserSDB;

type
   TUserData = class
   private
      FName : String;

      FIndex : Integer;
      FCharName : String;
      FServerName : String;
      FAge : Word;
      FSex : Byte;
      FMainMagic : String;

      FWin : Integer;
      FLose : Integer;
      FDisConnected : Integer;
      FPoint : Integer;
      FServerPoint : Integer;

      FGrade : Integer;
      FServerGrade : Integer;
      FMagicGrade : Integer;

      FLastFighterName : String;
      FFightingCount : Byte;
   public
      constructor Create;
      destructor Destroy; override;

      function LoadFromSDB (aIndex : Integer; aDB : TUserStringDB) : Boolean;

      function GetDataStr : String;

      property Name : String read FName write FName;
      property CharName : String read FCharName write FCharName;
      property ServerName : String read FServerName write FServerName;
      property Age : Word read FAge write FAge;
      property Sex : Byte read FSex write FSex;
      property MainMagic : String read FMainMagic write FMainMagic;

      property Win : Integer read FWin write FWin;
      property Lose : Integer read FLose write FLose;
      property DisConnected : Integer read FDisConnected write FDisConnected;
      property Point : Integer read FPoint write FPoint;
      property ServerPoint : Integer read FServerPoint write FServerPoint;

      property Grade : Integer read FGrade write FGrade;
      property ServerGrade : Integer read FServerGrade write FServerGrade;
      property MagicGrade : Integer read FMagicGrade write FMagicGrade;

      property LastFighterName : String read FLastFighterName write FLastFighterName;
      property FightingCount : Byte read FFightingCount write FFightingCount;
   end;

implementation

constructor TUserData.Create;
begin
   FName := '';

   FIndex := 0;
   FCharName := '';
   FServerName := '';
   FAge := 0;
   FSex := 0;
   FMainMagic := '';

   FWin := 0;
   FLose := 0;
   FDisConnected := 0;
   FPoint := 0;
   FServerPoint := 0;

   FGrade := 0;
   FServerGrade := 0;
   FMagicGrade := 0;

   FLastFighterName := '';
   FFightingCount := 0;
end;

destructor TUserData.Destroy;
begin
   inherited Destroy;
end;

function TUserData.LoadFromSDB (aIndex : Integer; aDB : TUserStringDB) : Boolean;
var
   iName, Str : String;
begin
   Result := false;

   iName := aDB.GetIndexName (aIndex);
   if iName = '' then exit;

   FCharName := aDB.GetFieldValueString (iName, 'CharName');
   FServerName := aDB.GetFieldValueString (iName, 'ServerName');

   FAge := aDB.GetFieldValueInteger (iName, 'Age');
   Str := aDB.GetFieldValueString (iName, 'Sex');
   if Str = '³²' then FSex := 0 else FSex := 1;
   FMainMagic := aDB.GetFieldValueString (iName, 'MainMagic');

   FWin := aDB.GetFieldValueInteger (iName, 'Win');
   FLose := aDB.GetFieldValueInteger (iName, 'Lose');
   FDisConnected := aDB.GetFieldValueInteger (iName, 'DisConnected');
   FPoint := aDB.GetFieldValueInteger (iName, 'Point');
   FServerPoint := aDB.GetFieldValueInteger (iName, 'ServerPoint');

   FGrade := 0;
   FServerGrade := 0;
   FMagicGrade := 0;

   FLastFighterName := aDB.GetFieldValueString (iName, 'LastFighterName');
   FFightingCount := aDB.GetFieldValueInteger (iName, 'FightingCount');

   FName := FServerName + ':' + FCharName;

   Result := true;
end;

function TUserData.GetDataStr : String;
var
   Str : String;
begin
   if FSex = 0 then Str := '³²' else Str := '¿©';
   
   Result := FServerName + ',' + FCharName + ',' + IntToStr (FAge) + ',' + Str + ',' + FMainMagic + ',' + IntToStr (FWin) + ',' + IntToStr (FLose) + ',' + IntToStr (FDisConnected) + ',' + IntToStr (FPoint) + ',' + IntToStr (FServerPoint) + ',' + IntToStr (FGrade) + ',' + IntToStr (FServerGrade) + ',' + IntToStr (FMagicGrade) + ',' + FLastFighterName + ',' + IntToStr(FFightingCount);
end;

end.
