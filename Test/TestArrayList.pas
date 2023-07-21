unit TestArrayList;

interface

uses
  TestFramework,
  Lists,
  System.SysUtils,
  System.Classes;

type
  TestTArrayList = class(TTestCase)
  strict private
    FArrayList, Temp: IBaseList;
  public
    procedure SetUp; override;
    procedure TearDown; override;
    procedure Checkelements(Source: String; Temp: IBaseList);
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

procedure TestTArrayList.SetUp;
begin
  FArrayList := TArrayList.Create;
end;

procedure TestTArrayList.TearDown;
begin
  // FreeAndNil(FArrayList);
  // FreeAndNil(Temp);
  FArrayList := nil;
  Temp := nil;
end;

procedure TestTArrayList.Checkelements(Source: String; Temp: IBaseList);
var
  I: Integer;
begin
  for I := 0 to FArrayList.Count - 1 do
    Check(FArrayList[I] = Temp[I], Format('List items dont match at index %d' +
      Source, [I]));
end;

procedure TestTArrayList.TestAdd;
var
  ReturnValue: Integer;
  a: Integer;
begin
  a := 3;
  ReturnValue := FArrayList.Add(a);
  CheckEquals(0, ReturnValue, 'Unexpected wrong position');
  CheckEquals(1, FArrayList.Count, 'Unexpected count elems in list');
  a := 1;
  ReturnValue := FArrayList.Add(a);
  CheckEquals(1, ReturnValue, 'Unexpected wrong position');
  CheckEquals(2, FArrayList.Count, 'Unexpected count elems in list');
  a := 2;
  ReturnValue := FArrayList.Add(a);
  CheckEquals(2, ReturnValue, 'Unexpected wrong position');
  CheckEquals(3, FArrayList.Count, 'Unexpected count elems in list');
end;

procedure TestTArrayList.TestAssign;
begin
  Temp := TLinkedList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  FArrayList.Assign(Temp);
  Checkelements(' after Assign(LinkedList)', Temp);
  // FreeAndNil(Temp);
  Temp := nil;
  Temp := TArrayList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  FArrayList.Assign(Temp);
  Checkelements(' after Assign(ArrayList)', Temp);
end;

procedure TestTArrayList.TestAssignTo;
begin
  Temp := TLinkedList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  Temp.AssignTo(FArrayList);
  Checkelements(' after LinkedList[2, 4, 8, 16, 32].AssignTo', Temp);
  // FreeAndNil(Temp);
  Temp := nil;
  Temp := TArrayList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  Temp.AssignTo(FArrayList);
  Checkelements(' after ArrayList[2, 4, 8, 16, 32].AssignTo', Temp);
end;

procedure TestTArrayList.TestInsert;
var
  ReturnValue: Boolean;
  a: Integer;
  pos: Integer;
begin
  // Вставка в неверную позицию
  pos := 1;
  a := 2;
  try
    FArrayList.Insert(pos, a);
  except
    on EListError do
    begin
      ReturnValue := False;
    end;
  end;
  CheckEquals(False, ReturnValue, 'Unexpected insert');
  CheckEquals(0, FArrayList.Count, 'Unexpected count elems in list');
  // Вставка 1-го элемента
  pos := 0;
  a := 2;
  ReturnValue := True;
  FArrayList.Insert(pos, a);
  CheckEquals(True, ReturnValue, 'Unexpected failed insert');
  CheckEquals(1, FArrayList.Count, 'Unexpected count elems in list');
  // Вставка в конец
  pos := 1;
  a := 4;
  FArrayList.Insert(pos, a);
  CheckEquals(True, ReturnValue, 'Unexpected failed insert');
  CheckEquals(2, FArrayList.Count, 'Unexpected count elems in list');
  // Вставка в середину
  pos := 1;
  a := 8;
  FArrayList.Insert(pos, a);
  CheckEquals(True, ReturnValue, 'Unexpected failed insert');
  CheckEquals(3, FArrayList.Count, 'Unexpected count elems in list');
  // Замена "головы"
  pos := 0;
  a := 16;
  FArrayList.Insert(pos, a);
  CheckEquals(True, ReturnValue, 'Unexpected failed insert');
  CheckEquals(4, FArrayList.Count, 'Unexpected count elems in list');
end;

procedure TestTArrayList.TestLoad;
var
  FileStream: TFileStream;
  Writer: TWriter;
begin
  // 0 Элементов
  FileStream := TFileStream.Create('ModulTestArray', fmCreate);
  Writer := TWriter.Create(FileStream, 1024);
  FreeAndNil(Writer);
  FreeAndNil(FileStream);
  FArrayList.Load('ModulTestArray');
  CheckEquals(0, FArrayList.Count,
    'Incorrect number of items in the ArrayList');
  // 1 элемент
  FileStream := TFileStream.Create('ModulTestArray', fmCreate);
  Writer := TWriter.Create(FileStream, 1024);
  Writer.WriteListBegin;
  Writer.WriteInteger(2);
  Writer.WriteListEnd;
  FreeAndNil(Writer);
  FreeAndNil(FileStream);
  FArrayList.Load('ModulTestArray');
  CheckEquals(1, FArrayList.Count,
    'Incorrect number of items in the ArrayList');
  CheckEquals(2, FArrayList[0], 'Invalid element value in the ArrayList');
  // 3 элемента
  FileStream := TFileStream.Create('ModulTestArray', fmCreate);
  Writer := TWriter.Create(FileStream, 1024);
  Writer.WriteListBegin;
  Writer.WriteInteger(2);
  Writer.WriteInteger(4);
  Writer.WriteInteger(6);
  Writer.WriteListEnd;
  FreeAndNil(Writer);
  FreeAndNil(FileStream);
  FArrayList.Load('ModulTestArray');
  CheckEquals(3, FArrayList.Count,
    'Incorrect number of items in the ArrayList');
  CheckEquals(2, FArrayList[0], 'Invalid element value in the ArrayList');
  CheckEquals(4, FArrayList[1], 'Invalid element value in the ArrayList');
  CheckEquals(6, FArrayList[2], 'Invalid element value in the ArrayList');
end;

procedure TestTArrayList.TestSave;
var
  FileStream: TFileStream;
  Reader: TReader;
  Numbers: TArray<Integer>;
  I: Integer;
begin
  // 0 элементов
  SetLength(Numbers, 10);
  FArrayList.Save('ModulTestArray');
  FileStream := TFileStream.Create('ModulTestArray', fmOpenRead);
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
  CheckEquals(0, FArrayList.Count,
    'Incorrect number of items in the ArrayList');
  // 1 элемент
  FArrayList.Add(9);
  FArrayList.Save('ModulTestArray');
  FileStream := TFileStream.Create('ModulTestArray', fmOpenRead);
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
  CheckEquals(1, FArrayList.Count,
    'Incorrect number of items in the ArrayList');
  CheckEquals(9, Numbers[0], 'Invalid element value in the saved file');
  // 3 элемента
  FArrayList.Add(5);
  FArrayList.Add(1);
  FArrayList.Save('ModulTestArray');
  FileStream := TFileStream.Create('ModulTestArray', fmOpenRead);
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
  CheckEquals(3, FArrayList.Count,
    'Incorrect number of items in the ArrayList');
  CheckEquals(9, Numbers[0], 'Invalid element value in the saved file');
  CheckEquals(5, Numbers[1], 'Invalid element value in the saved file');
  CheckEquals(1, Numbers[2], 'Invalid element value in the saved file');
end;

procedure TestTArrayList.TestSort;
begin
  FArrayList.Sort;
  FArrayList.Add(1);
  FArrayList.Sort;
  FArrayList.Add(2);
  FArrayList.Sort;
  FArrayList.Add(3);
  FArrayList.Sort;
  Check((FArrayList[0] = 1) and (FArrayList[1] = 2) and (FArrayList[2] = 3),
    'Invalid elements after Sort');
  FArrayList.Clear;
  FArrayList.Add(3);
  FArrayList.Add(2);
  FArrayList.Add(1);
  FArrayList.Sort;
  Check((FArrayList[0] = 1) and (FArrayList[1] = 2) and (FArrayList[2] = 3),
    'Wrong elements after Sort descending elements');
  FArrayList.Clear;
  FArrayList.Add(9);
  FArrayList.Add(3);
  FArrayList.Add(7);
  FArrayList.Add(2);
  FArrayList.Add(1);
  FArrayList.Sort;
  Check((FArrayList[0] = 1) and (FArrayList[1] = 2) and (FArrayList[2] = 3) and
    (FArrayList[3] = 7) and (FArrayList[4] = 9),
    'Wrong elements after Sort random elements');
  FArrayList.Clear;
  FArrayList.Add(3);
  FArrayList.Add(3);
  FArrayList.Add(3);
  FArrayList.Add(1);
  FArrayList.Sort;
  Check((FArrayList[0] = 1) and (FArrayList[1] = 3) and (FArrayList[2] = 3) and
    (FArrayList[3] = 3), 'Wrong elements after Sort identical elements');
end;

procedure TestTArrayList.TestDelete;
var
  ReturnValue: Boolean;
  pos: Integer;
begin
  FArrayList.Add(2);
  FArrayList.Add(4);
  FArrayList.Add(8);
  FArrayList.Add(16);
  FArrayList.Add(32);
  // Удаление несуществующего
  pos := 5;
  try
    FArrayList.Delete(pos);
  except
    on EListError do
    begin
      ReturnValue := False;
    end;
  end;
  CheckEquals(False, ReturnValue, 'Unexpected deleting a non-existent');
  CheckEquals(5, FArrayList.Count, 'Unexpected count elems in list');
  // Удаление "головы"
  pos := 0;
  ReturnValue := True;
  FArrayList.Delete(pos);
  CheckEquals(True, ReturnValue, 'Unexpected failed deleting');
  CheckEquals(4, FArrayList.Count, 'Unexpected count elems in list');
  CheckEquals(4, FArrayList[0], 'Unexpected value head');
  // Удаление хвоста
  pos := 3;
  FArrayList.Delete(pos);
  CheckEquals(True, ReturnValue, 'Unexpected failed deleting');
  CheckEquals(3, FArrayList.Count, 'Unexpected count elems in list');
  CheckEquals(16, FArrayList[FArrayList.Count - 1], 'Unexpected value tail');
  // Удаление центрального элемента
  pos := 1;
  FArrayList.Delete(pos);
  CheckEquals(True, ReturnValue, 'Unexpected failed deleting');
  CheckEquals(2, FArrayList.Count, 'Unexpected count elems in list');
  // Удаление оставшихся
  pos := 1;
  FArrayList.Delete(pos);
  CheckEquals(True, ReturnValue, 'Unexpected failed deleting');
  CheckEquals(1, FArrayList.Count, 'Unexpected count elems in list');
  pos := 0;
  FArrayList.Delete(pos);
  CheckEquals(True, ReturnValue, 'Unexpected failed deleting');
  CheckEquals(0, FArrayList.Count, 'Unexpected count elems in list');
end;

procedure TestTArrayList.TestClear;
begin
  FArrayList.Add(2);
  FArrayList.Add(4);
  FArrayList.Add(8);
  FArrayList.Add(16);
  FArrayList.Add(32);
  FArrayList.Clear;
  CheckEquals(0, FArrayList.Count, 'Unexpected non-empty array');
end;

procedure TestTArrayList.TestClone;
begin
  Temp := TLinkedList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  // FreeAndNil(FArrayList);
  FArrayList := nil;
  FArrayList := Temp.Clone;
  Checkelements(' after Assign(LinkedList)', Temp);
  // FreeAndNil(Temp);
  Temp := nil;
  Temp := TArrayList.Create;
  Temp.Add(2);
  Temp.Add(4);
  Temp.Add(8);
  Temp.Add(16);
  Temp.Add(32);
  // FreeAndNil(FArrayList);
  FArrayList := nil;
  FArrayList := Temp.Clone;
  Checkelements(' after Assign(ArrayList)', Temp);
end;

procedure TestTArrayList.TestCount;
begin
  FArrayList.Add(2);
  FArrayList.Add(4);
  FArrayList.Add(8);
  FArrayList.Delete(1);
  FArrayList.Add(16);
  FArrayList.Insert(0, 32);
  FArrayList.Delete(2);
  FArrayList.Insert(2, 64);
  CheckEquals(4, FArrayList.Count, 'Unexpected count elems in list');
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTArrayList.Suite);

end.
