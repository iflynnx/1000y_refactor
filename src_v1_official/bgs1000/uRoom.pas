unit uRoom;

interface

type
   TRoom = class
   private

   public
      constructor Create;
      destructor Destroy; override;
   end;

   TRoomList = class
   private

   public
      constructor Create;
      destructor Destroy; override;

   end;

implementation

constructor TRoom.Create;
begin

end;

destructor TRoom.Destroy;
begin
   inherited Destroy;
end;

constructor TRoomList.Create;
begin

end;

destructor TRoomList.Destroy;
begin
   inherited Destroy;
end;

end.
