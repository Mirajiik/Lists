unit RandomTestArrayList;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, Lists, System.SysUtils;

type
  // Test methods for class TArrayList

  TestTArrayList = class(TTestCase)
  strict private
    FArrayList: TArrayList;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure RandomTests;
  end;

implementation

procedure TestTArrayList.SetUp;
begin
  FArrayList := TArrayList.Create;
end;

procedure TestTArrayList.TearDown;
begin
  FArrayList.Free;
  FArrayList := nil;
end;

procedure TestTArrayList.RandomTests;
var
  Action, ReturnValue, k: Integer;
  BoolReturnValue : Boolean;
  pos, a: Integer;
  I: Integer;
begin
  FArrayList := TArrayList.Create;
  k := 0;
  for I := 0 to 500 do
  begin
    Action := Random(5);
    case Action of
      0:
      begin
        a := Random(100);
        ReturnValue := FArrayList.Add(a);
        CheckEquals(FArrayList.Count, ReturnValue + 1, 'Unexpected list count after Add');
        Inc(k);
      end;
      1:
      begin
        pos := Random(30);
        a := Random(100);
        BoolReturnValue := FArrayList.Insert(pos, a);
        CheckEquals((pos >= 0) and (pos < FArrayList.Count), BoolReturnValue, 'Unexpected return value after Insert');
        if BoolReturnValue then
        begin
          Inc(k);
        end;
        CheckEquals(k, FArrayList.Count, 'Unexpected list count after Insert');
      end;
      2:
      begin
        pos := Random(30);
        BoolReturnValue := FArrayList.Delete(pos);
        CheckEquals((pos >= 0) and (pos < k), BoolReturnValue, 'Unexpected return value after Delete');
        if BoolReturnValue then
        begin
          Dec(k);
        end;
        CheckEquals(k, FArrayList.Count, 'Unexpected list count after Delete');
      end;
      3:
      begin
        FArrayList.Clear;
        CheckEquals(0, FArrayList.Count, 'Unexpected non-empty array');
        k := 0;
      end;
      4: CheckEquals(k, FArrayList.Count, 'Unexpected list count after CheckCount');
    end;

  end;


end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTArrayList.Suite);
end.

