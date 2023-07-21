unit RandomTestLists;

interface

uses
  TestFramework, Lists, System.SysUtils;

type
  TestTLists = class(TTestCase)
  strict private
    FArrayList, FLinkedList: IBaseList;
    procedure CheckElements(Source: String = '');
    procedure TestAction(Action, pos, a: Integer; EText: String; CurrList, SuppList: IBaseList);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure RandomTests;
  end;

implementation

procedure TestTLists.SetUp;
begin
  FArrayList := TArrayList.Create;
  FLinkedList := TLinkedList.Create;
  Randomize;
end;

procedure TestTLists.TearDown;
begin
  // FreeAndNil(FArrayList);
  // FreeAndNil(FLinkedList);
  FArrayList := nil;
  FLinkedList := nil;
end;

procedure TestTLists.TestAction(Action, pos, a: Integer; EText: String; CurrList, SuppList: IBaseList);
var
  ReturnIntValue, k, J: Integer;
begin
  case Action of
    0:
      begin
        k := CurrList.Count;
        ReturnIntValue := CurrList.Add(a);
        CheckEquals(ReturnIntValue, CurrList.Count - 1, Format('Invalid return value of Add to %s element', [EText]));
        CheckEquals(k + 1, CurrList.Count, 'Incorrect count elements after Add');
      end;
    1:
      begin
        k := CurrList.Count;
        CurrList.Insert(pos, a);
        CheckEquals(CurrList[pos], a, 'Invalid element at the insertion point');
        CheckEquals(k + 1, CurrList.Count, 'Incorrect count elements after Insert');
      end;
    2:
      begin
        k := CurrList.Count;
        CurrList.Delete(pos);
        CheckEquals(k - 1, CurrList.Count, 'Incorrect count elements after Delete');
      end;
    3:
      begin
        Exit;
        CurrList.Clear;
        CheckEquals(0, CurrList.Count, 'Incorrect count elements after Clear');
      end;
    4:
      begin
        CurrList.Clear;
        CurrList.Assign(SuppList);
        CheckElements(' after Assign');
      end;
    5:
      begin
        CurrList.Clear;
        SuppList.AssignTo(CurrList);
        CheckElements(' after AssignTo');
      end;
    6:
      begin
        CurrList.Clear;
        CurrList := SuppList.Clone;
        CheckElements(' after Clone');
      end;
    7:
      begin
        k := CurrList.Count;
        CurrList.Sort;
        for J := 0 to k - 2 do
          Check(CurrList[J] <= CurrList[J + 1], Format('Unsorted elements in List at indexs %d and %d', [J, J + 1]));
        CheckEquals(k, CurrList.Count, 'Incorrect count elements after Sort');
      end;
    8:
      begin
        k := CurrList.Count;
        CurrList.Save('RandomTestSaveLoad');
        CurrList.Clear;
        CurrList.Load('RandomTestSaveLoad');
        CheckEquals(k, CurrList.Count, 'Incorrect count elements after SaveLoad');
        CheckElements(' after SaveLoad');
      end;
  end;
end;

procedure TestTLists.CheckElements(Source: String = '');
var
  I: Integer;
begin
  for I := 0 to FArrayList.Count - 1 do
    Check(FArrayList[I] = FLinkedList[I], Format('List items dont match at index %d' + Source, [I]));
end;

procedure TestTLists.RandomTests;
var
  Action, I, EArrayList, ELinkedListExptCount: Integer;
  a, pos: Integer;
begin
  EArrayList := 0;
  ELinkedListExptCount := 0;
  for I := 0 to 5000 do
  begin
    Action := Random(9);
    a := Random(100);
    pos := Random(FArrayList.Count * 2);
    try
      TestAction(Action, pos, a, 'ArrayList', FArrayList, FLinkedList);
    except
      on EListError do
        Inc(EArrayList);
    end;
    try
      TestAction(Action, pos, a, 'LinkedList', FLinkedList, FArrayList);
    except
      on EListError do
        Inc(ELinkedListExptCount);
    end;
    CheckEquals(FArrayList.Count, FLinkedList.Count, 'Mismatch of list sizes');
    CheckEquals(EArrayList, ELinkedListExptCount, 'Mismatch count of exceptions');
    if Action <= 3 then
      CheckElements(' after Add/Insert/Delete');
  end;
end;

initialization

RegisterTest(TestTLists.Suite);

end.
