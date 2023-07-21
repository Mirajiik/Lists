unit Lists;

interface

uses System.SysUtils, System.Classes;

type
  IBaseList = interface(IInterface)
    function GetValue(Index: Integer): Integer;
    procedure SetValue(Index: Integer; const Value: Integer);
    function GetCount: Integer;
    function Add(a: Integer): Integer;
    procedure Insert(pos, a: Integer);
    procedure Delete(pos: Integer);
    procedure Clear();
    procedure Print();
    property Count: Integer read GetCount;
    property Items[Index: Integer]: Integer read GetValue
      write SetValue; default;
    procedure Sort;
    function Save(FName: String): Boolean;
    function Load(FName: String): Boolean;
    procedure Assign(Source: IBaseList);
    procedure AssignTo(Dest: IBaseList);
    function Clone(): IBaseList;
  end;

  TBaseList = class abstract(TInterfacedObject, IBaseList)
  private
  protected
    FCount: Integer;
    function GetValue(Index: Integer): Integer; virtual; abstract;
    procedure SetValue(Index: Integer; const Value: Integer); virtual; abstract;
    function GetCount: Integer;
  public
    function Add(a: Integer): Integer; virtual; abstract;
    procedure Insert(pos, a: Integer); virtual; abstract;
    procedure Delete(pos: Integer); virtual; abstract;
    procedure Clear(); virtual; abstract;
    procedure Print(); virtual; abstract;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: Integer read GetValue
      write SetValue; default;
    procedure Assign(Source: IBaseList);
    procedure AssignTo(Dest: IBaseList);
    procedure Sort; virtual;
    function Clone(): IBaseList;
    destructor Destroy; override;
    function Save(FName: String): Boolean; virtual;
    function Load(FName: String): Boolean;
  end;

  TArrayList = class(TBaseList)
  private
    FArray: TArray<Integer>;
  protected
    function GetValue(Index: Integer): Integer; override;
    procedure SetValue(Index: Integer; const Value: Integer); override;
  public
    function Add(a: Integer): Integer; override;
    procedure Insert(pos, a: Integer); override;
    procedure Delete(pos: Integer); override;
    procedure Clear(); override;
    procedure Print(); override;
    constructor Create;
  end;

  TListElement = class
  private
    FValue: Integer;
    FNext: TListElement;
  public
    property Value: Integer read FValue write FValue;
    property Next: TListElement read FNext;
    constructor Create(a: Integer); overload;
    constructor Create(a: Integer; Next: TListElement); overload;
  end;

  TLinkedList = class(TBaseList)
  private
    FHead: TListElement;
    function GetItem(Index: Integer): TListElement;
  protected
    function GetValue(Index: Integer): Integer; override;
    procedure SetValue(Index: Integer; const Value: Integer); override;
  public
    function Add(a: Integer): Integer; override;
    procedure Insert(pos, a: Integer); override;
    procedure Delete(pos: Integer); override;
    procedure Clear(); override;
    procedure Print(); override;
    procedure Sort(); override;
    constructor Create;
    function Save(FName: String): Boolean; override;
  end;

implementation

{ TArrayList }

function TArrayList.Add(a: Integer): Integer;
begin
  if Count = Length(FArray) then
  begin
    SetLength(FArray, Length(FArray) * 2);
  end;
  FArray[Count] := a;
  Result := Count;
  Inc(FCount);
end;

procedure TArrayList.Clear;
begin
  self.FCount := 0;
  Finalize(FArray);
  FArray := TArray<Integer>.Create(1);
end;

constructor TArrayList.Create;
begin
  inherited;
  FCount := 0;
  FArray := TArray<Integer>.Create(1);
end;

procedure TArrayList.Delete(pos: Integer);
var
  I: Integer;
begin
  if (pos < 0) or (pos >= Count) then
    raise EListError.Create('Trying to remove a non-existent element');

  for I := pos to Count - 2 do
  begin
    FArray[I] := FArray[I + 1];
  end;
  Dec(FCount);
end;

function TArrayList.GetValue(Index: Integer): Integer;
begin
  if (Index < 0) or (Index >= Count) then
    raise EListError.Create('Trying to get a non-existent element');

  Exit(FArray[Index]);
end;

procedure TArrayList.Insert(pos, a: Integer);
var
  I: Integer;
begin
  if (pos < 0) or (pos > Count) then
    raise EListError.Create('Wrong insertion position');

  if (Count = Length(FArray)) then
  begin
    SetLength(FArray, Length(FArray) * 2);
  end;
  Inc(FCount);
  for I := Count - 1 downto pos + 1 do
  begin
    FArray[I] := FArray[I - 1];
  end;
  FArray[pos] := a;
end;

procedure TArrayList.Print;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Write(IntToStr(FArray[I]) + '  ');
  Writeln;
end;

procedure TArrayList.SetValue(Index: Integer; const Value: Integer);
begin
  if (Index < 0) or (Index >= Count) then
    raise EListError.Create('Trying to get a non-existent element');
  FArray[Index] := Value;
end;

{ TListElement }
constructor TListElement.Create(a: Integer);
begin
  FValue := a;
  FNext := nil;
end;

constructor TListElement.Create(a: Integer; Next: TListElement);
begin
  FValue := a;
  FNext := Next;
end;

{ TLinkedList }
function TLinkedList.Add(a: Integer): Integer;
begin
  if (Count > 0) then
  begin
    GetItem(Count - 1).FNext := TListElement.Create(a);
  end
  else
  begin
    FHead := TListElement.Create(a);
  end;
  Result := Count;
  Inc(FCount);
end;

procedure TLinkedList.Clear;
var
  ListPointer: TListElement;
begin
  while Assigned(FHead) do
  begin
    ListPointer := FHead.Next;
    FHead.Free;
    FHead := ListPointer;
  end;
  FCount := 0;
end;

constructor TLinkedList.Create;
begin
  inherited;
  FCount := 0;
  FHead := nil;
end;

procedure TLinkedList.Delete(pos: Integer);
var
  PrevListPointer, DelListPointer: TListElement;
begin
  if (pos < 0) or (pos >= Count) then
    raise EListError.Create('Trying to remove a non-existent element');

  if pos = 0 then
  begin
    DelListPointer := FHead;
    FHead := FHead.FNext;
  end
  else
  begin
    PrevListPointer := GetItem(pos - 1);
    DelListPointer := PrevListPointer.Next;
    if Assigned(DelListPointer) then
      PrevListPointer.FNext := DelListPointer.Next
    else
      PrevListPointer.FNext := nil;
  end;
  FreeAndNil(DelListPointer);
  Dec(FCount);
end;

function TLinkedList.GetItem(Index: Integer): TListElement;
var
  I: Integer;
begin
  if (Index < 0) or (Index >= Count) then
    raise EListError.Create('Trying to get a non-existent element');

  Result := FHead;
  for I := 1 to Index do
  begin
    Result := Result.Next;
  end;
end;

function TLinkedList.GetValue(Index: Integer): Integer;
begin
  Result := GetItem(Index).Value;
end;

procedure TLinkedList.Insert(pos, a: Integer);
var
  NextListPointer, PrevListPointer: TListElement;
begin
  if pos = 0 then
  begin
    PrevListPointer := FHead;
    FHead := TListElement.Create(a, PrevListPointer);
    Inc(FCount);
  end
  else
  begin
    PrevListPointer := GetItem(pos - 1);
    NextListPointer := PrevListPointer.Next;
    PrevListPointer.FNext := TListElement.Create(a, NextListPointer);
    Inc(FCount);
  end;
end;

procedure TLinkedList.Print;
var
  CurrListPointer: TListElement;
  I: Integer;
begin
  CurrListPointer := FHead;
  for I := 1 to Count do
  begin
    Write(IntToStr(CurrListPointer.Value) + '  ');
    CurrListPointer := CurrListPointer.Next;
  end;
  Writeln;
end;

function TLinkedList.Save(FName: String): Boolean;
var
  FileStream : TFileStream;
  Writer: TWriter;
  CurrListElem : TListElement;
begin
  try
    FileStream := TFileStream.Create(FName, fmCreate);
    Writer := TWriter.Create(FileStream, 1024);
  except
    on EInOutError do
      Exit(False);
  end;
  try
    try
      CurrListElem := Self.FHead;
      Writer.WriteListBegin;
      while CurrListElem <> nil do
      begin
        Writer.WriteInteger(CurrListElem.Value);
        CurrListElem := CurrListElem.Next;
      end;
      Writer.WriteListEnd;
      Result := True;
    except
      Result := False;
    end;
  finally
    FreeAndNil(Writer);
    FreeAndNil(FileStream);
  end;
end;

procedure TLinkedList.SetValue(Index: Integer; const Value: Integer);
begin
  GetItem(Index).FValue := Value;
end;

procedure TLinkedList.Sort;
var
  I, J, Temp: Integer;
  CurrListElem, NextListElem: TListElement;
begin
  for I := 1 to Count - 1 do
  begin
    CurrListElem := FHead;
    NextListElem := CurrListElem.Next;
    for J := 0 to Count - 1 - I do
    begin
      if CurrListElem.Value > NextListElem.Value then
      begin
        Temp := CurrListElem.Value;
        CurrListElem.Value := NextListElem.Value;
        NextListElem.Value := Temp;
      end;
      CurrListElem := CurrListElem.Next;
      NextListElem := NextListElem.Next;
    end;
  end;
end;

{ TBaseList }
procedure TBaseList.Assign(Source: IBaseList);
var
  I: Integer;
begin
  self.Clear;
  for I := 0 to Source.Count - 1 do
  begin
    self.Add(Source[I]);
  end;
end;

procedure TBaseList.AssignTo(Dest: IBaseList);
var
  I: Integer;
begin
  Dest.Clear;
  for I := 0 to Count - 1 do
  begin
    Dest.Add(self.Items[I]);
  end;
end;

function TBaseList.Clone: IBaseList;
begin
  Result := ClassType.Create as TBaseList;
  Result.Assign(self);
end;

destructor TBaseList.Destroy;
begin
  Clear;
  inherited;
end;

function TBaseList.GetCount: Integer;
begin
  Exit(FCount);
end;

function TBaseList.Load(FName: String): Boolean;
var
  FileStream : TFileStream;
  Reader: TReader;
  Reserv: IBaseList;
begin
  try
    FileStream := TFileStream.Create(FName, fmOpenRead);
    Reader := TReader.Create(FileStream, 1024);
  except
    on EInOutError do
      Exit(False);
  end;
  try
    try
      Reserv := self.Clone;
      self.Clear;
      Reader.ReadListBegin;
      while not Reader.EndOfList  do
      begin
        self.Add(Reader.ReadInteger);
      end;
      Reader.ReadListEnd;
      Result := True;
    except
      Result := False;
      Clear;
      self := Reserv.Clone as TBaseList;
    end;
  finally
    FreeAndNil(Reader);
    FreeAndNil(FileStream);
  end;
end;

function TBaseList.Save(FName: string): Boolean;
var
  FileStream : TFileStream;
  Writer: TWriter;
  I: Integer;
begin
  try
    FileStream := TFileStream.Create(FName, fmCreate);
    Writer := TWriter.Create(FileStream, 1024);
  except
    on EInOutError do
      Exit(False);
  end;
  try
    try
      Writer.WriteListBegin;
      for I := 0 to Count - 1 do
        Writer.WriteInteger(Self[I]);
      Writer.WriteListEnd;
      Result := True;
    except
      Result := False;
    end;
  finally
    FreeAndNil(Writer);
    FreeAndNil(FileStream);
  end;
end;

procedure TBaseList.Sort;
var
  I, J, Temp: Integer;
begin
  for I := 1 to Count - 1 do
    for J := 0 to Count - 1 - I do
      if self[J] > self[J + 1] then
      begin
        Temp := self[J];
        self[J] := self[J + 1];
        self[J + 1] := Temp;
      end;
end;

end.
