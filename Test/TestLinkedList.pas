unit TestLinkedList;

interface

uses
  TestFramework,
  Lists,
  System.SysUtils,
  System.Classes;

type
  TestTLinkedList = class(TTestCase)
  strict private
    FLinkedList, Temp: IBaseList;
  public
    procedure SetUp; override;
    procedure TearDown; override;
    procedure CheckElements(Source: String; Temp: IBaseList);
  published
    procedure TestAdd;
    procedure TestInsert;
    procedure TestDelete;
    procedure TestClear;
    procedure TestCount;
    procedure TestAssign;
    procedure TestAssignTo;
    procedure TestClone;
    procedure TestSort;
    procedure TestSave;
    procedure TestLoad;
  end;

implementation

procedure TestTLinkedList.SetUp;
begin
  FLinkedList := TLinkedList.Create;
end;

procedure TestTLinkedList.TearDown;
begin
  //FreeAndNil(FLinkedList);
  //FreeAndNil(Temp)
  FLinkedList := nil;
  Temp := nil;
end;

procedure TestTLinkedList.CheckElements(Source: String; Temp: IBaseList);
var
  I: Integer;
begin
  for I := 0 to FLinkedList.Count - 1 do
    Check(FLinkedList[I] = Temp[I], Format('List items dont match at index %d' +
      Source, [I]));
end;

procedure TestTLinkedList.TestAdd;
var
  ReturnValue: Integer;
  a: Integer;
begin
  a := 3;
  ReturnValue := FLinkedList.Add(a);
  CheckEquals(0, ReturnValue, 'Unexpected wrong position');
  CheckEquals(1, FLinkedList.Count, 'Unexpected count elems in list');
  a := 1;
  ReturnValue := FLinkedList.Add(a);
  CheckEquals(1, ReturnValue, 'Unexpected wrong position');
  CheckEquals(2, FLinkedList.Count, 'Unexpected count elems in list');
  CheckEquals(3, FLinkedList[0], 'Unexpected value head');
  a := 2;
  ReturnValue := FLinkedList.Add(a);
  CheckEquals(2, ReturnValue, 'Unexpected wrong position');
  CheckEquals(3, FLinkedList.Count, 'Unexpected count elems in list');
end;

procedure TestTLinkedList.TestAssign;
begin
  Temp := TLinkedList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  FLinkedList.Assign(Temp);
  CheckElements(' after Assign(LinkedList)', Temp);
  //FreeAndNil(Temp);
  Temp := nil;
  Temp := TArrayList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  FLinkedList.Assign(Temp);
  CheckElements(' after Assign(ArrayList)', Temp);
end;

procedure TestTLinkedList.TestAssignTo;
begin
  Temp := TLinkedList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  Temp.AssignTo(FLinkedList);
  CheckElements(' after LinkedList[2, 4, 8, 16, 32].AssignTo', Temp);
  //FreeAndNil(Temp);
  Temp := nil;
  Temp := TArrayList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  Temp.AssignTo(FLinkedList);
  CheckElements(' after ArrayList[2, 4, 8, 16, 32].AssignTo', Temp);
end;

procedure TestTLinkedList.TestInsert;
var
  ReturnValue: Boolean;
  a: Integer;
  pos: Integer;
begin
  // Вставка в неверную позицию
  pos := 1;
  a := 2;
  try
    FLinkedList.Insert(pos, a);
    ReturnValue := True;
  except
    on EListError do
    begin
      ReturnValue := False;
    end;
  end;
  CheckEquals(False, ReturnValue, 'Unexpected insert');
  CheckEquals(0, FLinkedList.Count, 'Unexpected count elems in list');
  // Вставка 1-го элемента
  pos := 0;
  a := 2;
  ReturnValue := True;
  FLinkedList.Insert(pos, a);
  CheckEquals(True, ReturnValue, 'Unexpected failed insert');
  CheckEquals(1, FLinkedList.Count, 'Unexpected count elems in list');
  CheckEquals(2, FLinkedList[0], 'Unexpected inserted value');
  // Вставка в конец
  pos := 1;
  a := 4;
  FLinkedList.Insert(pos, a);
  CheckEquals(True, ReturnValue, 'Unexpected failed insert');
  CheckEquals(2, FLinkedList.Count, 'Unexpected count elems in list');
  CheckEquals(4, FLinkedList[1], 'Unexpected inserted value');
  // Вставка в середину
  pos := 1;
  a := 8;
  FLinkedList.Insert(pos, a);
  CheckEquals(True, ReturnValue, 'Unexpected failed insert');
  CheckEquals(3, FLinkedList.Count, 'Unexpected count elems in list');
  CheckEquals(8, FLinkedList[1], 'Unexpected inserted value');
  // Замена "головы"
  pos := 0;
  a := 16;
  FLinkedList.Insert(pos, a);
  CheckEquals(True, ReturnValue, 'Unexpected failed insert');
  CheckEquals(4, FLinkedList.Count, 'Unexpected count elems in list');
  CheckEquals(16, FLinkedList[0], 'Unexpected inserted value');
end;

procedure TestTLinkedList.TestLoad;
var
  FileStream: TFileStream;
  Writer: TWriter;
begin
  // 0 Элементов
  FileStream := TFileStream.Create('ModulTestLinked', fmCreate);
  Writer := TWriter.Create(FileStream, 1024);
  FreeAndNil(Writer);
  FreeAndNil(FileStream);
  FLinkedList.Load('ModulTestLinked');
  CheckEquals(0, FLinkedList.Count,
    'Incorrect number of items in the ArrayList');
  // 1 элемент
  FileStream := TFileStream.Create('ModulTestLinked', fmCreate);
  Writer := TWriter.Create(FileStream, 1024);
  Writer.WriteListBegin;
  Writer.WriteInteger(2);
  Writer.WriteListEnd;
  FreeAndNil(Writer);
  FreeAndNil(FileStream);
  FLinkedList.Load('ModulTestLinked');
  CheckEquals(1, FLinkedList.Count,
    'Incorrect number of items in the ArrayList');
  CheckEquals(2, FLinkedList[0], 'Invalid element value in the ArrayList');
  // 3 элемента
  FileStream := TFileStream.Create('ModulTestLinked', fmCreate);
  Writer := TWriter.Create(FileStream, 1024);
  Writer.WriteListBegin;
  Writer.WriteInteger(2);
  Writer.WriteInteger(4);
  Writer.WriteInteger(6);
  Writer.WriteListEnd;
  FreeAndNil(Writer);
  FreeAndNil(FileStream);
  FLinkedList.Load('ModulTestLinked');
  CheckEquals(3, FLinkedList.Count,
    'Incorrect number of items in the ArrayList');
  CheckEquals(2, FLinkedList[0], 'Invalid element value in the ArrayList');
  CheckEquals(4, FLinkedList[1], 'Invalid element value in the ArrayList');
  CheckEquals(6, FLinkedList[2], 'Invalid element value in the ArrayList');
end;

procedure TestTLinkedList.TestSave;
var
  FileStream: TFileStream;
  Reader: TReader;
  Numbers: TArray<Integer>;
  I: Integer;
begin
  // 0 элементов
  SetLength(Numbers, 10);
  FLinkedList.Save('ModulTestLinked');
  FileStream := TFileStream.Create('ModulTestLinked', fmOpenRead);
  Reader := TReader.Create(FileStream, 1024);
  Reader.ReadListBegin;
  I := 0;
  while not Reader.EndOfList do
  begin
    Numbers[I] := Reader.ReadInteger;
    Inc(I);
  end;
  Reader.ReadListEnd;
  FreeAndNil(Reader);
  FreeAndNil(FileStream);
  CheckEquals(0, I, 'Incorrect number of items in the saved file');
  CheckEquals(0, FLinkedList.Count,
    'Incorrect number of items in the ArrayList');
  // 1 элемент
  FLinkedList.Add(9);
  FLinkedList.Save('ModulTestLinked');
  FileStream := TFileStream.Create('ModulTestLinked', fmOpenRead);
  Reader := TReader.Create(FileStream, 1024);
  Reader.ReadListBegin;
  I := 0;
  while not Reader.EndOfList do
  begin
    Numbers[I] := Reader.ReadInteger;
    Inc(I);
  end;
  Reader.ReadListEnd;
  FreeAndNil(Reader);
  FreeAndNil(FileStream);
  CheckEquals(1, I, 'Incorrect number of items in the saved file');
  CheckEquals(1, FLinkedList.Count,
    'Incorrect number of items in the ArrayList');
  CheckEquals(9, Numbers[0], 'Invalid element value in the saved file');
  // 3 элемента
  FLinkedList.Add(5);
  FLinkedList.Add(1);
  FLinkedList.Save('ModulTestLinked');
  FileStream := TFileStream.Create('ModulTestLinked', fmOpenRead);
  Reader := TReader.Create(FileStream, 1024);
  Reader.ReadListBegin;
  I := 0;
  while not Reader.EndOfList do
  begin
    Numbers[I] := Reader.ReadInteger;
    Inc(I);
  end;
  Reader.ReadListEnd;
  FreeAndNil(Reader);
  FreeAndNil(FileStream);
  CheckEquals(3, I, 'Incorrect number of items in the saved file');
  CheckEquals(3, FLinkedList.Count,
    'Incorrect number of items in the ArrayList');
  CheckEquals(9, Numbers[0], 'Invalid element value in the saved file');
  CheckEquals(5, Numbers[1], 'Invalid element value in the saved file');
  CheckEquals(1, Numbers[2], 'Invalid element value in the saved file');
end;

procedure TestTLinkedList.TestSort;
begin
  FLinkedList.Sort;
  FLinkedList.Add(1);
  FLinkedList.Sort;
  FLinkedList.Add(2);
  FLinkedList.Sort;
  FLinkedList.Add(3);
  FLinkedList.Sort;
  Check((FLinkedList[0] = 1) and (FLinkedList[1] = 2) and (FLinkedList[2] = 3),
    'Invalid elements after Sort');
  FLinkedList.Clear;
  FLinkedList.Add(3);
  FLinkedList.Add(2);
  FLinkedList.Add(1);
  FLinkedList.Sort;
  Check((FLinkedList[0] = 1) and (FLinkedList[1] = 2) and (FLinkedList[2] = 3),
    'Wrong elements after Sort descending elements');
  FLinkedList.Clear;
  FLinkedList.Add(9);
  FLinkedList.Add(3);
  FLinkedList.Add(7);
  FLinkedList.Add(2);
  FLinkedList.Add(1);
  FLinkedList.Sort;
  Check((FLinkedList[0] = 1) and (FLinkedList[1] = 2) and (FLinkedList[2] = 3)
    and (FLinkedList[3] = 7) and (FLinkedList[4] = 9),
    'Wrong elements after Sort random elements');
  FLinkedList.Clear;
  FLinkedList.Add(3);
  FLinkedList.Add(3);
  FLinkedList.Add(3);
  FLinkedList.Add(1);
  FLinkedList.Sort;
  Check((FLinkedList[0] = 1) and (FLinkedList[1] = 3) and (FLinkedList[2] = 3)
    and (FLinkedList[3] = 3), 'Wrong elements after Sort identical elements');
end;

procedure TestTLinkedList.TestDelete;
var
  ReturnValue: Boolean;
  pos: Integer;
begin
  FLinkedList.Add(2);
  FLinkedList.Add(4);
  FLinkedList.Add(8);
  FLinkedList.Add(16);
  FLinkedList.Add(32);
  // Удаление несуществующего
  pos := 5;
  try
    FLinkedList.Delete(pos);
    ReturnValue := True;
  except
    on EListError do
    begin
      ReturnValue := False;
    end;
  end;
  CheckEquals(False, ReturnValue, 'Unexpected deleting a non-existent');
  CheckEquals(5, FLinkedList.Count, 'Unexpected count elems in list');
  // Удаление "головы"
  pos := 0;
  ReturnValue := True;
  FLinkedList.Delete(pos);
  CheckEquals(True, ReturnValue, 'Unexpected failed deleting');
  CheckEquals(4, FLinkedList.Count, 'Unexpected count elems in list');
  CheckEquals(4, FLinkedList[0], 'Unexpected value head');
  // Удаление хвоста
  pos := 3;
  FLinkedList.Delete(pos);
  CheckEquals(True, ReturnValue, 'Unexpected failed deleting');
  CheckEquals(3, FLinkedList.Count, 'Unexpected count elems in list');
  CheckEquals(16, FLinkedList[FLinkedList.Count - 1], 'Unexpected value tail');
  // Удаление центрального элемента
  pos := 1;
  FLinkedList.Delete(pos);
  CheckEquals(True, ReturnValue, 'Unexpected failed deleting');
  CheckEquals(2, FLinkedList.Count, 'Unexpected count elems in list');
  // Удаление оставшихся
  pos := 1;
  FLinkedList.Delete(pos);
  CheckEquals(True, ReturnValue, 'Unexpected failed deleting');
  CheckEquals(1, FLinkedList.Count, 'Unexpected count elems in list');
  pos := 0;
  FLinkedList.Delete(pos);
  CheckEquals(True, ReturnValue, 'Unexpected failed deleting');
  CheckEquals(0, FLinkedList.Count, 'Unexpected count elems in list');
end;

procedure TestTLinkedList.TestClear;
begin
  FLinkedList.Add(2);
  FLinkedList.Add(4);
  FLinkedList.Add(8);
  FLinkedList.Add(16);
  FLinkedList.Add(32);
  FLinkedList.Clear;
  CheckEquals(0, FLinkedList.Count, 'Unexpected non-empty array');
end;

procedure TestTLinkedList.TestClone;
begin
  Temp := TLinkedList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  //FreeAndNil(FLinkedList);
  FLinkedList := nil;
  FLinkedList := Temp.Clone;
  CheckElements(' after Assign(LinkedList)', Temp);
  //FreeAndNil(Temp);
  Temp := nil;
  Temp := TArrayList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  //FreeAndNil(FLinkedList);
  FLinkedList := nil;
  FLinkedList := Temp.Clone;
  CheckElements(' after Assign(ArrayList)', Temp);
end;

procedure TestTLinkedList.TestCount;
begin
  FLinkedList.Add(2);
  FLinkedList.Add(4);
  FLinkedList.Add(8);
  FLinkedList.Delete(1);
  FLinkedList.Add(16);
  FLinkedList.Insert(0, 32);
  FLinkedList.Delete(2);
  FLinkedList.Insert(2, 64);
  CheckEquals(4, FLinkedList.Count, 'Unexpected count elems in list');
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTLinkedList.Suite);

end.
