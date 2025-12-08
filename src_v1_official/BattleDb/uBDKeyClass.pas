unit uBDKeyClass;

interface

uses
   Windows, Classes, SysUtils, uUserData;

const
   MAXSERVERCOUNT = 20;
   MAXMAGICCOUNT = 10;

type

   TUserDataKeyClass = class
   private
      DataList : TList;

      function GetInsertPos (aPoint : Integer) : Integer;
      function GetCount : Integer;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      procedure Sort;

      function Add (aUserData : TUserData) : Boolean;
      function Insert (aUserData : TUserData) : Boolean;
      function Delete (aUserData : TUserData) : Boolean;
      function Update (aUserData : TUserData) : Boolean;
      function Select (aIndex : Integer) : TUserData;

      procedure SetGrade;

      property Count : Integer read GetCount;
   end;

   function UserDataSortCompare (Item1, Item2: Pointer): Integer;

implementation

function UserDataSortCompare (Item1, Item2: Pointer): Integer;
var
   pd1, pd2 : TUserData;
begin
   Result := 0;

   pd1 := TUserData (Item1);
   pd2 := TUserData (Item2);

   if pd1.Point < pd2.Point then begin
      Result := 1;
   end else if pd1.Point > pd2.Point then begin
      Result := -1;
   end;
end;

// TUserDataKeyClass
constructor TUserDataKeyClass.Create;
begin
   DataList := TList.Create;
end;

destructor TUserDataKeyClass.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

procedure TUserDataKeyClass.Clear;
begin
   DataList.Clear;
end;

function TUserDataKeyClass.GetCount : Integer;
begin
   Result := DataList.Count;
end;

procedure TUserDataKeyClass.Sort;
var
   i : Integer;
   UserData : TUserData;
begin
   DataList.Sort (UserDataSortCompare);

   for i := 0 to DataList.Count - 1 do begin
      UserData := DataList.Items [i];
      UserData.Grade := i + 1;
   end;
end;

procedure TUserDataKeyClass.SetGrade;
var
   i : Integer;
   UserData : TUserData;
begin
   for i := 0 to DataList.Count - 1 do begin
      UserData := DataList.Items [i];
      UserData.Grade := i + 1;
   end;
end;

function TUserDataKeyClass.Update (aUserData : TUserData) : Boolean;
var
   nPos, PrevPos, NextPos : Integer;
   PrevUserData, NextUserData : TUserData;
begin
   Result := false;

   nPos := DataList.IndexOf (aUserData);
   if nPos < 0 then exit;

   if nPos > 0 then begin
      PrevPos := nPos - 1;
      PrevUserData := DataList.Items [nPos - 1];
   end else begin
      PrevPos := -1;
      PrevUserData := nil;
   end;
   if nPos < DataList.Count - 1 then begin
      NextPos := nPos + 1;
      NextUserData := DataList.Items [nPos + 1];
   end else begin
      NextPos := -1;
      NextUserData := nil;
   end;

   if PrevUserData <> nil then begin
      if PrevUserData.Point < aUserData.Point then begin
         while PrevPos >= 0 do begin
            PrevUserData := DataList.Items [PrevPos];
            if PrevUserData.Point < aUserData.Point then begin
               DataList.Exchange (PrevPos, PrevPos + 1);
            end else begin
               break;
            end;
            Dec (PrevPos);
         end;
         exit;
      end;
   end;
   if NextUserData <> nil then begin
      if NextUserData.Point > aUserData.Point then begin
         while NextPos < DataList.Count do begin
            NextUserData := DataList.Items [NextPos];
            if NextUserData.Point > aUserData.Point then begin
               DataList.Exchange (NextPos - 1, NextPos);
            end else begin
               break;
            end;
            Inc (NextPos);
         end;
         exit;
      end;
   end;

   Result := true;
end;

function TUserDataKeyClass.Add (aUserData : TUserData) : Boolean;
begin
   Result := false;

   DataList.Add (aUserData);

   Result := true;
end;

function TUserDataKeyClass.GetInsertPos (aPoint : Integer) : Integer;
var
   i : Integer;
   HighPos, LowPos, MidPos : Integer;
   UserData : TUserData;
begin
   Result := -1;

   LowPos := 0;
   HighPos := DataList.Count - 1;
   MidPos := (LowPos + HighPos) div 2;

   while LowPos <= HighPos do begin
      UserData := DataList.Items [MidPos];
      if UserData.Point = aPoint then begin
         Result := MidPos;
         exit;
      end else if UserData.Point < aPoint then begin
         HighPos := MidPos - 1;
      end else begin
         LowPos := MidPos + 1;
      end;
      MidPos := (LowPos + HighPos) div 2;
   end;

   if HighPos >= 0 then MidPos := MidPos + 1;

   Result := MidPos;
end;

function TUserDataKeyClass.Insert (aUserData : TUserData) : Boolean;
var
   nPos : Integer;
begin
   Result := false;

   nPos := GetInsertPos (aUserData.Point);
   if nPos < 0 then exit;

   DataList.Insert (nPos, aUserData);

   Result := true;
end;

function TUserDataKeyClass.Delete (aUserData : TUserData) : Boolean;
var
   nPos : Integer;
begin
   Result := false;

   nPos := DataList.IndexOf (aUserData);
   if nPos >= 0 then begin
      DataList.Delete (nPos);
      Result := true;
      exit;
   end;
end;

function TUserDataKeyClass.Select (aIndex : Integer) : TUserData;
begin
   Result := nil;

   if (aIndex >= 0) and (aIndex < DataList.Count) then begin
      Result := DataList.Items [aIndex];
      exit;
   end;
end;

end.
